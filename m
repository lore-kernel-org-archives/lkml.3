Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaKYASM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:18:12 -0500
Received: from mail-ig0-f202.google.com ([209.85.213.202]:59897 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaKYARq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:17:46 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH V6 12/12] ARM: tegra: venice2: Add xHCI support
Date: Mon, 24 Nov 2014 16:17:24 -0800
Message-Id: <1416874644-12070-13-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1416874644-12070-1-git-send-email-abrestic@chromium.org>
References: <1416874644-12070-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign ports previously owned by the EHCI controllers to the xHCI
controller.  There are two external USB ports (UTMI ports 0/2 and
USB3 ports 0/1) and an internal USB port (UTMI port 1).  PCIe lanes
0 and 1 are used by the USB3 ports.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
No changes from v5.
Changes from v4:
 - Updated regulator and pinconfig properties.
No changes from v3.
Changes from v2:
 - Updated VBUS power supply names.
Changes from v1:
 - Updated USB power supplies.
---
 arch/arm/boot/dts/tegra124-venice2.dts | 79 ++++++++++++++++++++++------------
 1 file changed, 51 insertions(+), 28 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index 5c3f781..abe59f7 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -745,7 +745,7 @@
 					regulator-always-on;
 				};
 
-				ldo0 {
+				avdd_1v05_run: ldo0 {
 					regulator-name = "+1.05V_RUN_AVDD";
 					regulator-min-microvolt = <1050000>;
 					regulator-max-microvolt = <1050000>;
@@ -887,6 +887,56 @@
 		status = "okay";
 	};
 
+	usb@0,70090000 {
+		status = "okay";
+		phys = <&padctl TEGRA_XUSB_PADCTL_UTMI_P0>, /* 1st USB A */
+		       <&padctl TEGRA_XUSB_PADCTL_UTMI_P1>, /* Internal USB */
+		       <&padctl TEGRA_XUSB_PADCTL_UTMI_P2>, /* 2nd USB A */
+		       <&padctl TEGRA_XUSB_PADCTL_USB3_P0>, /* 1st USB A */
+		       <&padctl TEGRA_XUSB_PADCTL_USB3_P1>; /* 2nd USB A */
+		phy-names = "utmi-0", "utmi-1", "utmi-2", "usb3-0", "usb3-1";
+		avddio-pex-supply = <&vdd_1v05_run>;
+		dvddio-pex-supply = <&vdd_1v05_run>;
+		avdd-usb-supply = <&vdd_3v3_lp0>;
+		avdd-pll-utmip-supply = <&vddio_1v8>;
+		avdd-pll-erefe-supply = <&avdd_1v05_run>;
+		avdd-usb-ss-pll-supply = <&vdd_1v05_run>;
+		hvdd-usb-ss-supply = <&vdd_3v3_lp0>;
+		hvdd-usb-ss-pll-e-supply = <&vdd_3v3_lp0>;
+	};
+
+	padctl@0,7009f000 {
+		pinctrl-0 = <&padctl_default>;
+		pinctrl-names = "default";
+
+		vbus-0-supply = <&vdd_usb1_vbus>;
+		vbus-1-supply = <&vdd_run_cam>;
+		vbus-2-supply = <&vdd_usb3_vbus>;
+
+		padctl_default: pinmux {
+			otg {
+				nvidia,lanes = "otg-0", "otg-1", "otg-2";
+				nvidia,function = "xusb";
+			};
+
+			usb3p0 {
+				nvidia,lanes = "pcie-0";
+				nvidia,function = "usb3";
+				nvidia,iddq = <0>;
+				nvidia,usb2-port = <0>;
+				nvidia,usb3-port = <0>;
+			};
+
+			usb3p1 {
+				nvidia,lanes = "pcie-1";
+				nvidia,function = "usb3";
+				nvidia,iddq = <0>;
+				nvidia,usb2-port = <2>;
+				nvidia,usb3-port = <1>;
+			};
+		};
+	};
+
 	sdhci@0,700b0400 {
 		cd-gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_HIGH>;
 		power-gpios = <&gpio TEGRA_GPIO(R, 0) GPIO_ACTIVE_HIGH>;
@@ -907,33 +957,6 @@
 		};
 	};
 
-	usb@0,7d000000 {
-		status = "okay";
-	};
-
-	usb-phy@0,7d000000 {
-		status = "okay";
-		vbus-supply = <&vdd_usb1_vbus>;
-	};
-
-	usb@0,7d004000 {
-		status = "okay";
-	};
-
-	usb-phy@0,7d004000 {
-		status = "okay";
-		vbus-supply = <&vdd_run_cam>;
-	};
-
-	usb@0,7d008000 {
-		status = "okay";
-	};
-
-	usb-phy@0,7d008000 {
-		status = "okay";
-		vbus-supply = <&vdd_usb3_vbus>;
-	};
-
 	backlight: backlight {
 		compatible = "pwm-backlight";
 
-- 
2.1.0.rc2.206.gedb03e5

