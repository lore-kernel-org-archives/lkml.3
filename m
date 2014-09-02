Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaIBVlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:41:39 -0400
Received: from mail-oi0-f73.google.com ([209.85.218.73]:54313 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbaIBVlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:41:36 -0400
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
Subject: [PATCH v3 8/9] ARM: tegra: jetson-tk1: Add xHCI support
Date: Tue,  2 Sep 2014 14:35:00 -0700
Message-Id: <1409693701-16520-9-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409693701-16520-1-git-send-email-abrestic@chromium.org>
References: <1409693701-16520-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign USB ports previously owned by the EHCI controllers to the xHCI
controller.  There is a mini-PCIe USB port (UTMI port 1) and a USB A
connector (UTMI port 2, USB3 port 0).  PCIe lane 0 is used for USB3
port 0.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v2:
 - Updated VBUS power supply names.
Changes from v1:
 - Updated USB power supplies.
---
 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 48 +++++++++++++++++--------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 624b0fb..a473750 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1515,7 +1515,7 @@
 					regulator-always-on;
 				};
 
-				ldo0 {
+				avdd_1v05_run: ldo0 {
 					regulator-name = "+1.05V_RUN_AVDD";
 					regulator-min-microvolt = <1050000>;
 					regulator-max-microvolt = <1050000>;
@@ -1619,15 +1619,40 @@
 		nvidia,sys-clock-req-active-high;
 	};
 
+	usb@0,70090000 {
+		status = "okay";
+		phys = <&padctl TEGRA_XUSB_PADCTL_UTMI_P1>, /* mini-PCIe USB */
+		       <&padctl TEGRA_XUSB_PADCTL_UTMI_P2>, /* USB A */
+		       <&padctl TEGRA_XUSB_PADCTL_USB3_P0>; /* USB A */
+		phy-names = "utmi-1", "utmi-2", "usb3-0";
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
 	padctl@0,7009f000 {
 		pinctrl-0 = <&padctl_default>;
 		pinctrl-names = "default";
 
+		vbus-2-supply = <&vdd_usb3_vbus>;
+		nvidia,usb3-port-0-lane = <TEGRA_XUSB_PADCTL_PIN_PCIE_0>;
+
 		padctl_default: pinmux {
+			otg {
+				nvidia,lanes = "otg-1", "otg-2";
+				nvidia,function = "xusb";
+			};
+
 			usb3 {
-				nvidia,lanes = "pcie-0", "pcie-1";
+				nvidia,lanes = "pcie-0";
 				nvidia,function = "usb3";
 				nvidia,iddq = <0>;
+				nvidia,usb2-port-num = <2>;
 			};
 
 			pcie {
@@ -1668,25 +1693,6 @@
 		};
 	};
 
-	/* mini-PCIe USB */
-	usb@0,7d004000 {
-		status = "okay";
-	};
-
-	usb-phy@0,7d004000 {
-		status = "okay";
-	};
-
-	/* USB A connector */
-	usb@0,7d008000 {
-		status = "okay";
-	};
-
-	usb-phy@0,7d008000 {
-		status = "okay";
-		vbus-supply = <&vdd_usb3_vbus>;
-	};
-
 	clocks {
 		compatible = "simple-bus";
 		#address-cells = <1>;
-- 
2.1.0.rc2.206.gedb03e5

