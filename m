Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3EJODR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:03:17 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11801 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3EJODM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:03:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 10 May 2013 06:59:39 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v3 03/10] ARM: tegra: update device trees for USB binding rework
Date: Fri, 10 May 2013 19:24:04 +0530
Message-ID: <1368194051-4925-4-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com>
References: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates all Tegra board files so that they contain all the
properties required by the updated USB DT binding. Note that this patch
only adds the new properties and does not yet remove the old properties,
in order to maintain bisectability. The old properties will be removed
once the driver has been updated to assume the new bindings.

The only exception is otg property which was removed, as VBUS details
for all the boards are not known. This should not affect for those boards
in any way, as otg is not really supported in Tegra20 USB driver, though
it was set in DT properties.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
delta from v1:
1. Fixed voltage regulators were used for vbus-supply
2. Added UTMI PHY timing Parameters to DT.

delta from v2:
1. Removed dr_mode setting to otg, due to:
  a. Any ways existing Tegra USB driver does not support OTG.
  b. lack of knowledge of all Vbus supplies, on all target platforms.
Once real OTG support is added to Tegra USB driver, then this property can be
 set back to otg, for target platforms.

2. All changes related to 'nvidia,phy-reset-gpio' were moved to patch 2 of the
 same series.

 arch/arm/boot/dts/tegra20-iris-512.dts  |    1 -
 arch/arm/boot/dts/tegra20-seaboard.dts  |   14 +++++++++-
 arch/arm/boot/dts/tegra20-trimslice.dts |   13 +++++++++
 arch/arm/boot/dts/tegra20-whistler.dts  |   26 +++++++++++++++++
 arch/arm/boot/dts/tegra20.dtsi          |   46 +++++++++++++++++++++++--------
 5 files changed, 86 insertions(+), 14 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-iris-512.dts b/arch/arm/boot/dts/tegra20-iris-512.dts
index 52f1103..b7f71e8 100644
--- a/arch/arm/boot/dts/tegra20-iris-512.dts
+++ b/arch/arm/boot/dts/tegra20-iris-512.dts
@@ -38,7 +38,6 @@
 
 	usb@c5000000 {
 		status = "okay";
-		dr_mode = "otg";
 	};
 
 	usb@c5008000 {
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index 9dd4f8e..d51e969 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -566,7 +566,10 @@
 	usb@c5000000 {
 		status = "okay";
 		nvidia,vbus-gpio = <&gpio 24 0>; /* PD0 */
-		dr_mode = "otg";
+	};
+
+	usb-phy@c5000000 {
+		vbus-supply = <&vbus_reg>;
 	};
 
 	usb@c5004000 {
@@ -807,6 +810,15 @@
 			gpio = <&pmic 1 0>;
 			enable-active-high;
 		};
+
+		vbus_reg: regulator@3 {
+			compatible = "regulator-fixed";
+			reg = <3>;
+			regulator-name = "vdd_5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&gpio 24 0>; /* PD0 */
+		};
 	};
 
 	sound {
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index fd7afd6..85699f0 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -314,6 +314,10 @@
 		nvidia,vbus-gpio = <&gpio 170 0>; /* gpio PV2 */
 	};
 
+	usb-phy@c5000000 {
+		vbus-supply = <&vbus_reg>;
+	};
+
 	usb@c5004000 {
 		status = "okay";
 		nvidia,phy-reset-gpio = <&gpio 168 1>; /* gpio PV0, active low */
@@ -390,6 +394,15 @@
 			regulator-max-microvolt = <1800000>;
 			regulator-always-on;
 		};
+
+		vbus_reg: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name = "vdd_5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&gpio 170 0>; /* PV2 */
+		};
 	};
 
 	sound {
diff --git a/arch/arm/boot/dts/tegra20-whistler.dts b/arch/arm/boot/dts/tegra20-whistler.dts
index d2567f8..9aec63a 100644
--- a/arch/arm/boot/dts/tegra20-whistler.dts
+++ b/arch/arm/boot/dts/tegra20-whistler.dts
@@ -511,11 +511,19 @@
 		nvidia,vbus-gpio = <&tca6416 0 0>; /* GPIO_PMU0 */
 	};
 
+	usb-phy@c5000000 {
+		vbus-supply = <&vbus_reg1>;
+	};
+
 	usb@c5008000 {
 		status = "okay";
 		nvidia,vbus-gpio = <&tca6416 1 0>; /* GPIO_PMU1 */
 	};
 
+	usb-phy@c5008000 {
+		vbus-supply = <&vbus_reg2>;
+	};
+
 	sdhci@c8000400 {
 		status = "okay";
 		cd-gpios = <&gpio 69 1>; /* gpio PI5 */
@@ -568,6 +576,24 @@
 			regulator-max-microvolt = <5000000>;
 			regulator-always-on;
 		};
+
+		vbus_reg1: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name = "vdd_5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&tca6416 0 0>; /* GPIO_PMU0 */
+		};
+
+		vbus_reg2: regulator@3 {
+			compatible = "regulator-fixed";
+			reg = <3>;
+			regulator-name = "vdd_5v0";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&tca6416 1 0>; /* GPIO_PMU1 */
+		};
 	};
 
 	sound {
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 56a9110..62ea419 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -455,13 +455,23 @@
 		status = "disabled";
 	};
 
-	phy1: usb-phy@c5000400 {
+	phy1: usb-phy@c5000000 {
 		compatible = "nvidia,tegra20-usb-phy";
-		reg = <0xc5000400 0x3c00>;
+		reg = <0xc5000000 0x4000 0xc5000000 0x4000>;
 		phy_type = "utmi";
+		clocks = <&tegra_car 22>,
+			 <&tegra_car 127>,
+			 <&tegra_car 106>,
+			 <&tegra_car 22>;
+		clock-names = "reg", "pll_u", "timer", "utmi-pads";
 		nvidia,has-legacy-mode;
-		clocks = <&tegra_car 22>, <&tegra_car 127>;
-		clock-names = "phy", "pll_u";
+		hssync_start_delay = <9>;
+		idle_wait_delay = <17>;
+		elastic_limit = <16>;
+		term_range_adj = <6>;
+		xcvr_setup = <9>;
+		xcvr_lsfslew = <1>;
+		xcvr_lsrslew = <1>;
 	};
 
 	usb@c5004000 {
@@ -474,12 +484,14 @@
 		status = "disabled";
 	};
 
-	phy2: usb-phy@c5004400 {
+	phy2: usb-phy@c5004000 {
 		compatible = "nvidia,tegra20-usb-phy";
-		reg = <0xc5004400 0x3c00>;
+		reg = <0xc5004000 0x4000>;
 		phy_type = "ulpi";
-		clocks = <&tegra_car 93>, <&tegra_car 127>;
-		clock-names = "phy", "pll_u";
+		clocks = <&tegra_car 58>,
+			 <&tegra_car 127>,
+			 <&tegra_car 93>;
+		clock-names = "reg", "pll_u", "ulpi-link";
 	};
 
 	usb@c5008000 {
@@ -492,12 +504,22 @@
 		status = "disabled";
 	};
 
-	phy3: usb-phy@c5008400 {
+	phy3: usb-phy@c5008000 {
 		compatible = "nvidia,tegra20-usb-phy";
-		reg = <0xc5008400 0x3c00>;
+		reg = <0xc5008000 0x4000 0xc5000000 0x4000>;
 		phy_type = "utmi";
-		clocks = <&tegra_car 22>, <&tegra_car 127>;
-		clock-names = "phy", "pll_u";
+		clocks = <&tegra_car 59>,
+			 <&tegra_car 127>,
+			 <&tegra_car 106>,
+			 <&tegra_car 22>;
+		clock-names = "reg", "pll_u", "timer", "utmi-pads";
+		hssync_start_delay = <9>;
+		idle_wait_delay = <17>;
+		elastic_limit = <16>;
+		term_range_adj = <6>;
+		xcvr_setup = <9>;
+		xcvr_lsfslew = <2>;
+		xcvr_lsrslew = <2>;
 	};
 
 	sdhci@c8000000 {
-- 
1.7.0.4

