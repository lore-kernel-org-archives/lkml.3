Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3AYJAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:00:42 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:46589 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3AYJAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:00:40 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Brian Lilly <brian@crystalfontz.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCHv2] ARM: mxs: dt: Add Crystalfontz CFA-10037 device tree support
Date: Fri, 25 Jan 2013 10:00:35 +0100
Message-Id: <1359104435-26995-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CFA-10037 is another expansion board for the CFA-10036 module, with
only a USB Host, a Ethernet device and a lot of gpios.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/Makefile           |    1 +
 arch/arm/boot/dts/imx28-cfa10037.dts |   77 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-mxs/mach-mxs.c         |    8 ++++
 3 files changed, 86 insertions(+)
 create mode 100644 arch/arm/boot/dts/imx28-cfa10037.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index e44da40..f9912f6 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -95,6 +95,7 @@ dtb-$(CONFIG_ARCH_MXS) += imx23-evk.dtb \
 	imx28-apf28dev.dtb \
 	imx28-apx4devkit.dtb \
 	imx28-cfa10036.dtb \
+	imx28-cfa10037.dtb \
 	imx28-cfa10049.dtb \
 	imx28-evk.dtb \
 	imx28-m28evk.dtb \
diff --git a/arch/arm/boot/dts/imx28-cfa10037.dts b/arch/arm/boot/dts/imx28-cfa10037.dts
new file mode 100644
index 0000000..c2ef3a3
--- /dev/null
+++ b/arch/arm/boot/dts/imx28-cfa10037.dts
@@ -0,0 +1,77 @@
+/*
+ * Copyright 2012 Free Electrons
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/*
+ * The CFA-10049 is an expansion board for the CFA-10036 module, thus we
+ * need to include the CFA-10036 DTS.
+ */
+/include/ "imx28-cfa10036.dts"
+
+/ {
+	model = "Crystalfontz CFA-10037 Board";
+	compatible = "crystalfontz,cfa10037", "crystalfontz,cfa10036", "fsl,imx28";
+
+	apb@80000000 {
+		apbh@80000000 {
+			pinctrl@80018000 {
+				pinctrl-names = "default", "default";
+				pinctrl-1 = <&hog_pins_cfa10037>;
+
+				hog_pins_cfa10037: hog-10037@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x0073 /* MX28_PAD_GPMI_D7__GPIO_0_7 */
+						0x2153 /* MX28_PAD_SSP2_D5__GPIO_2_21 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+			};
+		};
+
+		apbx@80040000 {
+			usbphy1: usbphy@8007e000 {
+				status = "okay";
+			};
+		};
+	};
+
+	ahb@80080000 {
+		usb1: usb@80090000 {
+			vbus-supply = <&reg_usb1_vbus>;
+			pinctrl-0 = <&usbphy1_pins_a>;
+			pinctrl-names = "default";
+			status = "okay";
+		};
+
+		mac0: ethernet@800f0000 {
+			phy-mode = "rmii";
+			pinctrl-names = "default";
+			pinctrl-0 = <&mac0_pins_a>;
+			phy-reset-gpios = <&gpio2 21 0>;
+			phy-reset-duration = <100>;
+			status = "okay";
+		};
+	};
+
+	regulators {
+		compatible = "simple-bus";
+
+		reg_usb1_vbus: usb1_vbus {
+			compatible = "regulator-fixed";
+			regulator-name = "usb1_vbus";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&gpio0 7 1>;
+		};
+	};
+};
diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 4668cf7..622c45a 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -417,6 +417,12 @@ static void __init cfa10049_init(void)
 	mxsfb_pdata.ld_intf_width = STMLCDIF_18BIT;
 }
 
+static void __init cfa10037_init(void)
+{
+	enable_clk_enet_out();
+	update_fec_mac_prop(OUI_CRYSTALFONTZ);
+}
+
 static void __init apf28_init(void)
 {
 	enable_clk_enet_out();
@@ -437,6 +443,8 @@ static void __init mxs_machine_init(void)
 		m28evk_init();
 	else if (of_machine_is_compatible("bluegiga,apx4devkit"))
 		apx4devkit_init();
+	else if (of_machine_is_compatible("crystalfontz,cfa10037"))
+		cfa10037_init();
 	else if (of_machine_is_compatible("crystalfontz,cfa10049"))
 		cfa10049_init();
 	else if (of_machine_is_compatible("armadeus,imx28-apf28"))
-- 
1.7.10.4

