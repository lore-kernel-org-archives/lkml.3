Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaKPSAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 13:00:38 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:60988 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbaKPSAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 13:00:36 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de
Cc: linus.walleij@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH v2] ARM: dts: vf-colibri: add USB regulators
Date: Sun, 16 Nov 2014 19:00:28 +0100
Message-Id: <1416160828-18168-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add structure of USB supply logic. The USB hosts power enable
regulator is needed to control VBUS supply on the Colibri carrier
board.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
This is the second version of a leftover of the "ARM: dts: vf610:
USB/GPIO fixes" patchset. The rest is already applied.

Changes in v2:
- Assign pinctrl to usbh_vbus_reg explicitly
- Remove USB client/host VBUS supply (not yet implemented in
  driver)

 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi | 34 ++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/vf-colibri.dtsi         |  6 ++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
index 80e8fbc..2d3e966 100644
--- a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
+++ b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
@@ -11,6 +11,34 @@
 	chosen {
 		bootargs = "console=ttyLP0,115200";
 	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		sys_5v0_reg: regulator@0 {
+			compatible = "regulator-fixed";
+			reg = <0>;
+			regulator-name = "5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-always-on;
+		};
+
+		/* USBH_PEN */
+		usbh_vbus_reg: regulator@1 {
+			compatible = "regulator-fixed";
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usbh1_reg>;
+			reg = <1>;
+			regulator-name = "usbh_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&gpio3 19 GPIO_ACTIVE_LOW>;
+			vin-supply = <&sys_5v0_reg>;
+		};
+	};
 };
 
 &bl {
@@ -51,4 +79,8 @@
 
 &uart2 {
 	status = "okay";
-};
\ No newline at end of file
+};
+
+&usbh1 {
+	vbus-supply = <&usbh_vbus_reg>;
+};
diff --git a/arch/arm/boot/dts/vf-colibri.dtsi b/arch/arm/boot/dts/vf-colibri.dtsi
index 2371760..27bcf5f 100644
--- a/arch/arm/boot/dts/vf-colibri.dtsi
+++ b/arch/arm/boot/dts/vf-colibri.dtsi
@@ -163,5 +163,11 @@
 				VF610_PAD_PTD3__UART2_CTS		0x21a1
 			>;
 		};
+
+		pinctrl_usbh1_reg: gpio_usb_vbus {
+			fsl,pins = <
+				VF610_PAD_PTD4__GPIO_83			0x22ed
+			>;
+		};
 	};
 };
-- 
2.1.3

