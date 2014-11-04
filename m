Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaKDFad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 00:30:33 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:35705 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751081AbaKDFab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 00:30:31 -0500
X-Listener-Flag: 11101
From: Xudong Chen <xudong.chen@mediatek.com>
To: Mark Rutland <mark.rutland@arm.com>, <arm@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>
CC: <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Xudong Chen <xudong.chen@mediatek.com>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>
Subject: [PATCH v2 0/3] ARM: mediatek: Add driver for Mediatek I2C controller
Date: Tue, 4 Nov 2014 13:29:34 +0800
Message-ID: <1415078977-18374-1-git-send-email-xudong.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is the second version of Mediatek SoCs I2C controller common
bus driver.
Compared to the first version,
1. Add comment for feature have-pmic in dt-bindings file i2c-mt6577.txt.
2. Add notes for I2C4/5/6 in mt8135.dtsi.
3. Add check compatible for the feature have-pmic in i2c-mt65xx.c, if set
have-pmic for the compatible mt6577 the driver will return error.

Because the clock driver for mediatek SoC is not ready yet(still work in
progress), so I delete the related clock code in dtsi file for now.

This driver is based on 3.18-rc1 & Hongzhou's gpio patch.

MTK I2C HW has some limitation.
1. If the i2c_msg number is more than one, STOP will be issued instead of
RS(Repeat Start) between each message.
Such as: "START + ADDR + DATA_n + STOP + START + ADDR + DATA_n + STOP ..."

2. Mediatek I2C controller support WRRD(write then read) mode, in WRRD
mode the Repeat Start will be issued between 2 messages.
In this driver if 2 messages is first write then read, the driver will
combine 2 messages using Write-Read mode so the RS will be issued between
the 2 messages.
Ex: W/R/R, driver will combine first W/R and then R.
The data series will be:
"START + WriteADDR + DATA + RS + ReadADDR + DATA + STOP + START + ReadADDR +
DATA + STOP".

3. Due to HW limitation, in this version the max transfer data length is 255
in one message. If want to transfer more than 255 bytes, HW needs the SW
driver to split the data. Take 600 bytes for example, the data need to be
divided into 3 parts 255 + 255 + 90. The data series will be:
"START + ADDR + DATA_255 + RS + ADDR + DATA_255 + RS + ADDR +  DATA_90 + STOP"
instead of "START + ADDR + DATA_900 + STOP".
We haven't implement this yet, we will do this in the separate patch.

MT8135 and MT6589 can control I2C pins on PMIC(MT6397) by setting the i2c
registers in MT8135 side. In this case, driver should set OFFSET_PATH_DIR
bit first, the operation on other registers are still the same.
For now MT6589/MT8135 support this, MT6577/MT6595/MT8127 do not support.
For example, If want to use I2C4/5/6 pins on MT8135 just need to enable
the pinmux, else if want to use I2C pins on PMIC(MT6397) just need to add
"mediatek,have-pmic" property in the .dts file of each platform.

Xudong Chen (3):
  dt-bindings: Add I2C bindings for mt65xx/mt81xx.
  ARM: mediatek: Add I2C node for mt8135 and mt8127
  I2C: mediatek: Add driver for MediaTek I2C controller

 .../devicetree/bindings/i2c/i2c-mt6577.txt         |  39 ++
 arch/arm/boot/dts/mt8127.dtsi                      |  27 +
 arch/arm/boot/dts/mt8135.dtsi                      |  90 +++
 drivers/i2c/busses/Kconfig                         |   9 +
 drivers/i2c/busses/Makefile                        |   1 +
 drivers/i2c/busses/i2c-mt65xx.c                    | 742 +++++++++++++++++++++
 6 files changed, 908 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-mt6577.txt
 create mode 100644 drivers/i2c/busses/i2c-mt65xx.c

--
1.8.1.1.dirty

