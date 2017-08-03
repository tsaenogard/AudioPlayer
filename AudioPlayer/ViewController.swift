//
//  ViewController.swift
//  AudioPlayer
//
//  Created by XCODE on 2017/5/12.
//  Copyright © 2017年 Gjun. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var backgroundImageView: UIImageView!
    var numberLabel: UILabel!
    var numberTextField: UITextField!
    var offsetLabel: UILabel!
    var offsetTextField: UITextField!
    var volumeLabel: UILabel!
    var volumeSlider: UISlider!
    var playButton: UIButton!
    var stopButton: UIButton!
    
    enum ButtonTag: Int {
        case play = 1, stop
    }
    
    var player: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.prepareForPlayer()
        self.initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUI()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.numberTextField.resignFirstResponder()
        self.offsetTextField.resignFirstResponder()
    }

    //MARK: - function
    private func prepareForPlayer() {
        guard let path = Bundle.main.path(forResource: "music", ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: path)
        self.player = try? AVAudioPlayer(contentsOf: url)
    }
    
    private func initUI() {
        self.backgroundImageView = UIImageView(image: UIImage(named: "background"))
        self.backgroundImageView.contentMode = .scaleAspectFill
        self.view.addSubview(self.backgroundImageView)
        
        self.numberLabel = UILabel()
        self.numberLabel.text = "次數"
        self.numberLabel.textColor = UIColor.darkGray
        self.view.addSubview(self.numberLabel)
        
        self.numberTextField = UITextField()
        self.numberTextField.text = "3"
        self.numberTextField.textColor = UIColor.darkGray
        self.numberTextField.borderStyle = .roundedRect
        self.view.addSubview(self.numberTextField)
        
        self.offsetLabel = UILabel()
        self.offsetLabel.text = "偏移"
        self.offsetLabel.textColor = UIColor.darkGray
        self.view.addSubview(self.offsetLabel)
        
        self.offsetTextField = UITextField()
        self.offsetTextField.text = "0"
        self.offsetTextField.textColor = UIColor.darkGray
        self.offsetTextField.borderStyle = .roundedRect
        self.view.addSubview(self.offsetTextField)
        
        self.volumeLabel = UILabel()
        self.volumeLabel.text = "音量"
        self.volumeLabel.textColor = UIColor.darkGray
        self.view.addSubview(self.volumeLabel)
        
        self.volumeSlider = UISlider()
        self.volumeSlider.maximumValue = 1.0
        self.volumeSlider.minimumValue = 0.0
        self.volumeSlider.value = 0.5
        self.volumeSlider.addTarget(self, action: #selector(self.sliderAction(_:)), for: .valueChanged)
        self.view.addSubview(self.volumeSlider)
        
        self.playButton = UIButton()
        self.playButton.tag = ButtonTag.play.rawValue
        self.playButton.setTitle("PLAY", for: .normal)
        self.playButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.playButton.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.55)
        self.playButton.layer.cornerRadius = 8.0
        self.playButton.addTarget(self, action: #selector(self.onButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(self.playButton)
        
        self.stopButton = UIButton()
        self.stopButton.tag = ButtonTag.stop.rawValue
        self.stopButton.setTitle("STOP", for: .normal)
        self.stopButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.stopButton.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.55)
        self.stopButton.layer.cornerRadius = 8.0
        self.stopButton.addTarget(self, action: #selector(self.onButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(self.stopButton)
    }
    
    private func setUI() {
        let frameW = UIScreen.main.bounds.width
        let gap: CGFloat = 10
        
        self.backgroundImageView.frame = self.view.frame
        
        let labelX = frameW / 4
        let labelW: CGFloat = 40
        let labelH: CGFloat = 21
        let dataX = labelX + labelW + gap
        let dataW = frameW / 2 - gap - labelW
        let dataH: CGFloat = 30
        
        let numberTextFieldY: CGFloat = 70
        let numberLabelY = numberTextFieldY + 4.5
        self.numberLabel.frame = CGRect(x: labelX, y: numberLabelY, width: labelW, height: labelH)
        self.numberTextField.frame = CGRect(x: dataX, y: numberTextFieldY, width: dataW, height: dataH)
        
        let offsetTextFieldY = numberTextFieldY + dataH + gap
        let offsetLabelY = offsetTextFieldY + 4.5
        self.offsetLabel.frame = CGRect(x: labelX, y: offsetLabelY, width: labelW, height: labelH)
        self.offsetTextField.frame = CGRect(x: dataX, y: offsetTextFieldY, width: dataW, height: dataH)
        
        let volumeSliderY = offsetTextFieldY + dataH + gap * 4
        let volumeLabelY = volumeSliderY + 4.5
        self.volumeLabel.frame = CGRect(x: labelX, y: volumeLabelY, width: labelW, height: labelH)
        self.volumeSlider.frame = CGRect(x: dataX, y: volumeSliderY, width: dataW, height: dataH)
        
        let buttonY = volumeSliderY + dataH + gap * 2
        let buttonW = (frameW / 2 - gap) / 2
        let buttonH: CGFloat = 30
        let playButtonX = labelX
        let stopButtonX = playButtonX + buttonW + gap
        self.playButton.frame = CGRect(x: playButtonX, y: buttonY, width: buttonW, height: buttonH)
        self.stopButton.frame = CGRect(x: stopButtonX, y: buttonY, width: buttonW, height: buttonH)
    }
    
    //MARK: - selector
    func onButtonAction(_ sender: UIButton) {
        if self.player == nil { return }
        guard let tag = ButtonTag(rawValue: sender.tag) else { return }
        switch tag {
        case .play:
            self.player.volume = self.volumeSlider.value
            self.player.numberOfLoops = Int(self.numberTextField.text!) ?? 0
            self.player.currentTime = Double(self.offsetTextField.text!) ?? 0
            self.player.prepareToPlay()
            self.player.play()
        case .stop:
            self.player.stop()
        }
    }
    
    func sliderAction(_ sender: UISlider) {
        if self.player == nil { return }
        self.player.volume = sender.value
    }

}

