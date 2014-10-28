Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbaJ1W3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:29:02 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:34836 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbaJ1W2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:28:06 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: [PATCH RESEND V4 9/9] ARM: tegra: venice2: Add xHCI support
Date: Tue, 28 Oct 2014 15:27:56 -0700
Message-Id: <1414535277-15645-10-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
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
No changes from v3.
Changes from v2:
 - Updated VBUS power supply names.
Changes from v1:
 - Updated USB power supplies.
---
 arch/arm/boot/dts/tegra124-venice2.dts | 79 ++++++++++++++++++++++------------
 1 file changed, 51 insertions(+), 28 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index 1300885..d7106f0 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -744,7 +744,7 @@
 					regulator-always-on;
 				};
 
-				ldo0 {
+				avdd_1v05_run: ldo0 {
 					regulator-name = "+1.05V_RUN_AVDD";
 					regulator-min-microvolt = <1050000>;
 					regulator-max-microvolt = <1050000>;
@@ -886,6 +886,56 @@
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
+		avdd-pex-pll-supply = <&vdd_1v05_run>;
+		hvdd-pex-supply = <&vdd_3v3_lp0>;
+		hvdd-pex-plle-supply = <&vdd_3v3_lp0>;
+	};
+
+	padctl@0,7009f000 {
+		pinctrl-0 = <&padctl_default>;
+		pinctrl-names = "default";
+
+		vbus-0-supply = <&vdd_usb1_vbus>;
+		vbus-1-supply = <&vdd_run_cam>;
+		vbus-2-supply = <&vdd_usb3_vbus>;
+		nvidia,usb3-port-0-lane = <TEGRA_XUSB_PADCTL_PIN_PCIE_0>;
+		nvidia,usb3-port-1-lane = <TEGRA_XUSB_PADCTL_PIN_PCIE_1>;
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
+				nvidia,usb2-port-num = <0>;
+			};
+
+			usb3p1 {
+				nvidia,lanes = "pcie-1";
+				nvidia,function = "usb3";
+				nvidia,iddq = <0>;
+				nvidia,usb2-port-num = <2>;
+			};
+		};
+	};
+
 	sdhci@0,700b0400 {
 		cd-gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_HIGH>;
 		power-gpios = <&gpio TEGRA_GPIO(R, 0) GPIO_ACTIVE_HIGH>;
@@ -906,33 +956,6 @@
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

