Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbbAYS1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:27:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbbAYSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3.18 164/183] ARM: dts: imx51-babbage: Fix ULPI PHY reset modelling
Date: Sun, 25 Jan 2015 10:08:06 -0800
Message-Id: <20150125180817.293320371@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx51-babbage.dts |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

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
 


