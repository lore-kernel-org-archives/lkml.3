Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049AbaFRGQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:16:48 -0400
Received: from mail-ig0-f202.google.com ([209.85.213.202]:60840 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934022AbaFRGQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:16:43 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v1 9/9] ARM: tegra: venice2: Add XHCI support
Date: Tue, 17 Jun 2014 23:16:20 -0700
Message-Id: <1403072180-4944-10-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign ports previously owned by the EHCI controllers to the XHCI
controller.  There are two external USB ports (UTMI ports 0/2 and
USB3 ports 0/1) and an internal USB port (UTMI port 1).  PCIe lanes
0 and 1 are used by the USB3 ports.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/arm/boot/dts/tegra124-venice2.dts | 72 +++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 27 deletions(-)

diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts
index f1a5bac..bf88c81 100644
--- a/arch/arm/boot/dts/tegra124-venice2.dts
+++ b/arch/arm/boot/dts/tegra124-venice2.dts
@@ -878,6 +878,51 @@
 		status = "okay";
 	};
 
+	usb@0,70090000 {
+		status = "okay";
+		phys = <&padctl TEGRA_XUSB_PADCTL_UTMI_P0>,
+		       <&padctl TEGRA_XUSB_PADCTL_UTMI_P1>,
+		       <&padctl TEGRA_XUSB_PADCTL_UTMI_P2>,
+		       <&padctl TEGRA_XUSB_PADCTL_USB3_P0>,
+		       <&padctl TEGRA_XUSB_PADCTL_USB3_P1>;
+		phy-names = "utmi-0", "utmi-1", "utmi-2", "usb3-0", "usb3-1";
+		s1p05v-supply = <&vdd_1v05_run>;
+		s3p3v-supply = <&vdd_3v3_lp0>;
+		s1p8v-supply = <&vddio_1v8>;
+	};
+
+	padctl@0,7009f000 {
+		pinctrl-0 = <&padctl_default>;
+		pinctrl-names = "default";
+
+		vbus-otg-0-supply = <&vdd_usb1_vbus>;
+		vbus-otg-1-supply = <&vdd_run_cam>;
+		vbus-otg-2-supply = <&vdd_usb3_vbus>;
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
+				nvidia,usb3-port-num = <0>;
+				nvidia,usb2-port-num = <0>;
+			};
+
+			usb3p1 {
+				nvidia,lanes = "pcie-1";
+				nvidia,function = "usb3";
+				nvidia,iddq = <0>;
+				nvidia,usb3-port-num = <1>;
+				nvidia,usb2-port-num = <2>;
+			};
+		};
+	};
+
 	sdhci@0,700b0400 {
 		cd-gpios = <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_HIGH>;
 		power-gpios = <&gpio TEGRA_GPIO(R, 0) GPIO_ACTIVE_HIGH>;
@@ -898,33 +943,6 @@
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
2.0.0.526.g5318336

