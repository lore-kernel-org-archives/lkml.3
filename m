Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbbA0M3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:29:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35314 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644AbbA0MTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 090/126] ARM: dts: imx51-babbage: Fix ULPI PHY reset modelling
Date: Tue, 27 Jan 2015 12:16:35 +0000
Message-Id: <1422361031-19364-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 7a9f0604bd56936b2b18f49824e0e392dc7878c3 upstream.

GPIO2_5 is the reset GPIO for the USB3317 ULPI PHY. Instead of modelling it as
a regulator, the correct approach is to use the 'reset_gpios' property of the
"usb-nop-xceiv" node.

GPIO1_7 is the reset GPIO for the USB2517 USB hub. As we currently don't have
dt bindings to describe a HUB reset, let's keep using the regulator approach.

Rename the regulator to 'reg_hub_reset' to better describe its function and bind
it with the USB host1 port instead.

USB host support has been introduced by commit 9bf206a9d13be3 ("ARM: dts:
imx51-babbage: Add USB Host1 support"), which landed in 3.16 and it seems that
USB has only been functional due to previous bootloader initialization.

With this patch applied we can get USB host to work without relying on the
bootloader.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/imx51-babbage.dts | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/arch/arm/boot/dts/imx51-babbage.dts b/arch/arm/boot/dts/imx51-babbage.dts
index 181d77fa2fa6..bc7138a1efca 100644
--- a/arch/arm/boot/dts/imx51-babbage.dts
+++ b/arch/arm/boot/dts/imx51-babbage.dts
@@ -127,24 +127,12 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		reg_usbh1_vbus: regulator@0 {
-			compatible = "regulator-fixed";
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_usbh1reg>;
-			reg = <0>;
-			regulator-name = "usbh1_vbus";
-			regulator-min-microvolt = <5000000>;
-			regulator-max-microvolt = <5000000>;
-			gpio = <&gpio2 5 GPIO_ACTIVE_HIGH>;
-			enable-active-high;
-		};
-
-		reg_usbotg_vbus: regulator@1 {
+		reg_hub_reset: regulator@0 {
 			compatible = "regulator-fixed";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_usbotgreg>;
-			reg = <1>;
-			regulator-name = "usbotg_vbus";
+			reg = <0>;
+			regulator-name = "hub_reset";
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			gpio = <&gpio1 7 GPIO_ACTIVE_HIGH>;
@@ -176,6 +164,7 @@
 			reg = <0>;
 			clocks = <&clks IMX5_CLK_DUMMY>;
 			clock-names = "main_clk";
+			reset-gpios = <&gpio2 5 GPIO_ACTIVE_LOW>;
 		};
 	};
 };
@@ -419,7 +408,7 @@
 &usbh1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_usbh1>;
-	vbus-supply = <&reg_usbh1_vbus>;
+	vbus-supply = <&reg_hub_reset>;
 	fsl,usbphy = <&usbh1phy>;
 	phy_type = "ulpi";
 	status = "okay";
@@ -429,7 +418,6 @@
 	dr_mode = "otg";
 	disable-over-current;
 	phy_type = "utmi_wide";
-	vbus-supply = <&reg_usbotg_vbus>;
 	status = "okay";
 };
 
-- 
2.1.4

