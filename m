Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbaLDVyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:54:25 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:14923 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717AbaLDVyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:54:23 -0500
X-IronPort-AV: E=Sophos;i="5.07,518,1413270000"; 
   d="scan'208";a="52155331"
From: Ray Jui <rjui@broadcom.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Scott Branden <sbranden@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH 1/4] pinctrl: Broadcom Cygnus pinctrl device tree binding
Date: Thu, 4 Dec 2014 13:56:08 -0800
Message-ID: <1417730171-30455-2-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417730171-30455-1-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
 <1417730171-30455-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree binding documentation for Broadcom Cygnus pinctrl driver

Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
---
 .../bindings/pinctrl/brcm,cygnus-pinctrl.txt       |   92 ++++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/brcm,cygnus-pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/brcm,cygnus-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/brcm,cygnus-pinctrl.txt
new file mode 100644
index 0000000..86e4579
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/brcm,cygnus-pinctrl.txt
@@ -0,0 +1,92 @@
+Broadcom Cygnus Pin Controller
+
+The Cygnus pin controller supports setting the alternate functions of groups
+of pins. Pinmux configuration on individual pins is not supported by the
+Cygnus A0 SoC.
+
+Required properties:
+
+- compatible:
+    Must be "brcm,cygnus-pinctrl"
+
+- reg:
+    Define the base and range of the I/O address space that contain the Cygnus
+pin control registers
+
+- brcm,groups:
+    This can be strings of one or more group names. This defines the group(s)
+that one wants to configure
+
+- brcm,function:
+    This is the alternate function that one wants to configure to. Valid
+alternate functions are "alt1", "alt2", "alt3", "alt4"
+
+Each child node represents a configuration. Client devices reference the the
+child node to enable the mux configuration.
+
+For example:
+
+	pinctrl: pinctrl@0x0301d0c8 {
+		compatible = "brcm,cygnus-pinctrl";
+		reg = <0x0301d0c8 0x2c>;
+
+		i2s_0: i2s_0 {
+			brcm,groups = "smart_card0", "smart_card0_fcb";
+			brcm,function = "alt2";
+		};
+
+		i2s_1: i2s_1 {
+			brcm,groups = "smart_card1", "smart_card1_fcb";
+			brcm,function = "alt2";
+		};
+
+		spi_0: spi_0 {
+			brcm,groups = "spi0";
+			brcm,function = "alt1";
+		};
+	}
+
+	spi0@18028000 {
+			compatible = "arm,pl022", "arm,primecell";
+			reg = <0x18028000 0x1000>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
+			pinctrl-0 = <&spi_0>;
+			clocks = <&axi81_clk>;
+			clock-names = "apb_pclk";
+	};
+
+Consider the following snapshot of Cygnus pinmux table:
+
+number    pin            group              alt1             alt2        alt3        alt4
+------    ---            ----               ----             ----        ----        ----
+42        sc0_clk        smart_card0        SMART CARD0      I2S_0       N/A         chip_gpio24
+43        sc0_cmdvcc_l   smart_card0        SMART CARD0      I2S_0       N/A         STRAP
+44        sc0_detect     smart_card0        SMART CARD0      I2S_0       N/A         chip_gpio25
+45        sc0_fcb        smart_card0_fcb    SMART CARD0_FCB  I2S_0       N/A         chip_gpio26
+46        sc0_io         smart_card0        SMART CARD0      I2S_0       N/A         chip_gpio27
+47        sc0_rst_l      smart_card0        SMART CARD0      SPDIF       N/A         STRAP
+
+Note due to limitation of the Cygnus hardware, pinmux configuration can only
+be group based. To enable I2S_0 function, one needs the following child node
+configuration:
+
+	i2s_0: i2s_0 {
+		brcm,groups = "smart_card0", "smart_card0_fcb";
+		brcm,function = "alt2";
+	};
+
+This tells the Cygnus pin controller to configure groups "smart_card0" and
+"smart_card0_fcb" to I2S_0. With this configuration, pins 42, 43, 44, 45, 46
+become I2C_0, and pin 47 becomes SPDIF
+
+Consider another example, that one wants to configure the above pins as GPIO:
+
+	gpio_24_27: gpio_24_27 {
+		brcm,groups = "smart_card0", "smart_card0_fcb";
+		brcm,function = "alt4";
+	};
+
+With the above configuration, pins 42, 44, 45, 46 become GPIO, and 43 and 47
+become reserved for STRAP
-- 
1.7.9.5

