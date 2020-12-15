//
//  ViewController.swift
//  Lesson1
//
//  Created by admin on 12/15/20.
//

import UIKit
import SnapKit

class StopwatchButton: UIButton {
    override var isSelected: Bool {
        willSet {
            backgroundColor = newValue == true ? .red : .blue
        }
    }
}

class ViewController: UIViewController {

    private var timer: Timer?
    private var seconds = 0

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .medium)
        return label
    }()

    private let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("Круг", for: .normal)
        button.setTitle("Сброс", for: .selected)
        button.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
        button.layer.cornerRadius = 30
        return button
    }()

    private let rightButton: StopwatchButton = {
        let button = StopwatchButton()
        button.setTitle("Старт", for: .normal)
        button.setTitle("Стоп", for: .selected)
        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.layer.cornerRadius = 30
        return button
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        layoutUI()
    }

    // MARK: Configure layout

    private func layoutUI() {
        configureTimeLabel()
        configureLeftButton()
        configureRightButton()
        configureStackView()
    }

    private func configureTimeLabel() {
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
    }

    private func configureLeftButton() {
        view.addSubview(leftButton)
        leftButton.addTarget(self, action: #selector(leftButtonDidPress), for: .touchUpInside)
        leftButton.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(60)
        }
    }

    private func configureRightButton() {
        view.addSubview(rightButton)
        rightButton.addTarget(self, action: #selector(rightButtonDidPress), for: .touchUpInside)
        rightButton.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.size.equalTo(60)
        }
    }

    private func configureStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(rightButton.snp.bottom).offset(20)
        }
    }

    // MARK: Helper

    private func formatValue(value: Int) -> String {
        return value < 10 ? "0\(value)" : "\(value)"
    }

    // MARK: User interactions

    @objc private func leftButtonDidPress() {
        if leftButton.isSelected {
            timer?.invalidate()
            timer = nil
            seconds = 0
            timeLabel.text = "00:00"
            stackView.arrangedSubviews.forEach {
                $0.removeFromSuperview()
            }
            leftButton.isSelected = false
        } else {
            let label = UILabel()
            label.text = timeLabel.text
            label.textColor = .white
            stackView.addArrangedSubview(label)
        }
    }

    @objc private func rightButtonDidPress() {
        rightButton.isSelected.toggle()
        if rightButton.isSelected {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
        leftButton.isSelected = !rightButton.isSelected
        // background color
    }

    @objc private func timerDidFire() {
        seconds += 1
        let minutes = seconds / 60
        let seconds = self.seconds % 60
        let formattedMinutes = formatValue(value: minutes)
        let formattedSeconds = formatValue(value: seconds)
        timeLabel.text = "\(formattedMinutes):\(formattedSeconds)"
    }
}

