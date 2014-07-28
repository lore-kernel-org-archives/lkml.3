Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaG1O54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:57:56 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:51030 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaG1O5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:57:54 -0400
From: Stefan Agner <stefan@agner.ch>
To: peter.chen@freescale.com, s.hauer@pengutronix.de, shawn.guo@freescale.com
Cc: b35083@freescale.com, jingchang.lu@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 1/7] ARM: dts: vf610: Add USB PHY and controller
Date: Mon, 28 Jul 2014 16:57:27 +0200
Message-Id: <240a6eadc0050de82af3e174a999f67e0ca27afa.1406558450.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <cover.1406558450.git.stefan@agner.ch>
References: <cover.1406558450.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds USB PHY and USB controller nodes. Vybrid SoCs have two
independent USB cores which each supports DR (dual role). However,
real OTG is not supported since the OTG ID pin is not available.

The PHYs are located within the anadig register range, hence we need
to change the length of the anadig registers.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf610.dtsi | 46 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 6a6190c..f36acb5 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -25,6 +25,8 @@
 		gpio2 = &gpio3;
 		gpio3 = &gpio4;
 		gpio4 = &gpio5;
+		usbphy0 = &usbphy0;
+		usbphy1 = &usbphy1;
 	};
 
 	cpus {
@@ -285,9 +287,25 @@
 				gpio-ranges = <&iomuxc 0 128 7>;
 			};
 
-			anatop@40050000 {
-				compatible = "fsl,vf610-anatop";
-				reg = <0x40050000 0x1000>;
+			anatop: anatop@40050000 {
+				compatible = "fsl,vf610-anatop", "syscon";
+				reg = <0x40050000 0x400>;
+			};
+
+			usbphy0: usbphy@40050800 {
+				compatible = "fsl,vf610-usbphy";
+				reg = <0x40050800 0x400>;
+				interrupts = <0 50 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks VF610_CLK_USBPHY0>;
+				fsl,anatop = <&anatop>;
+			};
+
+			usbphy1: usbphy@40050c00 {
+				compatible = "fsl,vf610-usbphy";
+				reg = <0x40050c00 0x400>;
+				interrupts = <0 51 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks VF610_CLK_USBPHY1>;
+				fsl,anatop = <&anatop>;
 			};
 
 			i2c0: i2c@40066000 {
@@ -309,6 +327,18 @@
 				reg = <0x4006b000 0x1000>;
 				#clock-cells = <1>;
 			};
+
+			usbdev0: usb@40034000 {
+				compatible = "fsl,vf610-usb", "fsl,imx27-usb";
+				reg = <0x40034000 0x800>;
+				interrupts = <0 75 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks VF610_CLK_USBC0>;
+				fsl,usbphy = <&usbphy0>;
+				dr_mode = "peripheral";
+				status = "disabled";
+			};
+
+
 		};
 
 		aips1: aips-bus@40080000 {
@@ -371,6 +401,16 @@
 				status = "disabled";
 			};
 
+			usbh1: usb@400b4000 {
+				compatible = "fsl,vf610-usb", "fsl,imx27-usb";
+				reg = <0x400b4000 0x800>;
+				interrupts = <0 76 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks VF610_CLK_USBC1>;
+				fsl,usbphy = <&usbphy1>;
+				dr_mode = "host";
+				status = "disabled";
+			};
+
 			ftm: ftm@400b8000 {
 				compatible = "fsl,ftm-timer";
 				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
-- 
2.0.2

