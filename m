Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab3GaRmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:42:32 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1476 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab3GaRm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:42:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 31 Jul 2013 10:41:03 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 1/2] ARM: DTS: tegra: Add USB entries for Tegra30
Date: Wed, 31 Jul 2013 20:42:22 +0300
Message-ID: <1375292543-7896-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1375292543-7896-1-git-send-email-ttynkkynen@nvidia.com>
References: <1375292543-7896-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree entries for the 3 USB controllers and PHYs and
enable the third controller on Cardhu and Beaver boards.

Fix VBUS regulator entries on Beaver. The GPIO pins were wrong.
Also, a third GPIO is required to power the pullup resistors that drive
the VBUS voltage switches, so add an regulator entry for that.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 arch/arm/boot/dts/tegra30-beaver.dts  | 23 +++++++++-
 arch/arm/boot/dts/tegra30-cardhu.dtsi |  9 ++++
 arch/arm/boot/dts/tegra30.dtsi        | 86 +++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-beaver.dts b/arch/arm/boot/dts/tegra30-beaver.dts
index 87c5f7b..414ea02 100644
--- a/arch/arm/boot/dts/tegra30-beaver.dts
+++ b/arch/arm/boot/dts/tegra30-beaver.dts
@@ -285,6 +285,15 @@
 		non-removable;
 	};
 
+	usb@7d008000 {
+		status = "okay";
+	};
+
+	usb-phy@7d008000 {
+		vbus-supply = <&usb3_vbus_reg>;
+		status = "okay";
+	};
+
 	clocks {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -357,7 +366,7 @@
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			enable-active-high;
-			gpio = <&gpio TEGRA_GPIO(I, 4) GPIO_ACTIVE_HIGH>;
+			gpio = <&gpio TEGRA_GPIO(DD, 6) GPIO_ACTIVE_HIGH>;
 			gpio-open-drain;
 			vin-supply = <&vdd_5v_in_reg>;
 		};
@@ -369,7 +378,7 @@
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
 			enable-active-high;
-			gpio = <&gpio TEGRA_GPIO(H, 7) GPIO_ACTIVE_HIGH>;
+			gpio = <&gpio TEGRA_GPIO(DD, 4) GPIO_ACTIVE_HIGH>;
 			gpio-open-drain;
 			vin-supply = <&vdd_5v_in_reg>;
 		};
@@ -399,6 +408,16 @@
 			gpio = <&gpio TEGRA_GPIO(L, 7) GPIO_ACTIVE_HIGH>;
 			vin-supply = <&sys_3v3_reg>;
 		};
+
+		usb13_vbus_pullup: regulator@8 {
+			compatible = "regulator-fixed";
+			reg = <8>;
+			regulator-name = "usb13_vbus_pullup";
+			regulator-always-on;
+			regulator-boot-on;
+			enable-active-high;
+			gpio = <&gpio TEGRA_GPIO(H, 5) GPIO_ACTIVE_HIGH>;
+		};
 	};
 
 	gpio-leds {
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index f65b53d..7af52e4 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -330,6 +330,15 @@
 		non-removable;
 	};
 
+	usb@7d008000 {
+		status = "okay";
+	};
+
+	usb-phy@7d008000 {
+		vbus-supply = <&usb3_vbus_reg>;
+		status = "okay";
+	};
+
 	clocks {
 		compatible = "simple-bus";
 		#address-cells = <1>;
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index d8783f0..9920797 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -561,6 +561,92 @@
 		status = "disabled";
 	};
 
+	usb@7d000000 {
+		compatible = "nvidia,tegra30-ehci", "usb-ehci";
+		reg = <0x7d000000 0x4000>;
+		interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
+		phy_type = "utmi";
+		clocks = <&tegra_car TEGRA30_CLK_USBD>;
+		nvidia,needs-double-reset;
+		nvidia,phy = <&phy1>;
+		status = "disabled";
+	};
+
+	phy1: usb-phy@7d000000 {
+		compatible = "nvidia,tegra30-usb-phy";
+		reg = <0x7d000000 0x4000 0x7d000000 0x4000>;
+		phy_type = "utmi";
+		clocks = <&tegra_car TEGRA30_CLK_USBD>,
+			 <&tegra_car TEGRA30_CLK_PLL_U>,
+			 <&tegra_car TEGRA30_CLK_USBD>;
+		clock-names = "reg", "pll_u", "utmi-pads";
+		nvidia,hssync-start-delay = <9>;
+		nvidia,idle-wait-delay = <17>;
+		nvidia,elastic-limit = <16>;
+		nvidia,term-range-adj = <6>;
+		nvidia,xcvr-setup = <51>;
+		nvidia.xcvr-setup-use-fuses;
+		nvidia,xcvr-lsfslew = <1>;
+		nvidia,xcvr-lsrslew = <1>;
+		nvidia,xcvr-hsslew = <32>;
+		nvidia,hssquelch-level = <2>;
+		nvidia,hsdiscon-level = <5>;
+		status = "disabled";
+	};
+
+	usb@7d004000 {
+		compatible = "nvidia,tegra30-ehci", "usb-ehci";
+		reg = <0x7d004000 0x4000>;
+		interrupts = <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
+		phy_type = "ulpi";
+		clocks = <&tegra_car TEGRA30_CLK_USB2>;
+		nvidia,phy = <&phy2>;
+		status = "disabled";
+	};
+
+	phy2: usb-phy@7d004000 {
+		compatible = "nvidia,tegra30-usb-phy";
+		reg = <0x7d004000 0x4000>;
+		phy_type = "ulpi";
+		clocks = <&tegra_car TEGRA30_CLK_USB2>,
+			 <&tegra_car TEGRA30_CLK_PLL_U>,
+			 <&tegra_car TEGRA30_CLK_CDEV2>;
+		clock-names = "reg", "pll_u", "ulpi-link";
+		status = "disabled";
+	};
+
+	usb@7d008000 {
+		compatible = "nvidia,tegra30-ehci", "usb-ehci";
+		reg = <0x7d008000 0x4000>;
+		interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
+		phy_type = "utmi";
+		clocks = <&tegra_car TEGRA30_CLK_USB3>;
+		nvidia,phy = <&phy3>;
+		status = "disabled";
+	};
+
+	phy3: usb-phy@7d008000 {
+		compatible = "nvidia,tegra30-usb-phy";
+		reg = <0x7d008000 0x4000 0x7d000000 0x4000>;
+		phy_type = "utmi";
+		clocks = <&tegra_car TEGRA30_CLK_USB3>,
+			 <&tegra_car TEGRA30_CLK_PLL_U>,
+			 <&tegra_car TEGRA30_CLK_USBD>;
+		clock-names = "reg", "pll_u", "utmi-pads";
+		nvidia,hssync-start-delay = <0>;
+		nvidia,idle-wait-delay = <17>;
+		nvidia,elastic-limit = <16>;
+		nvidia,term-range-adj = <6>;
+		nvidia,xcvr-setup = <51>;
+		nvidia.xcvr-setup-use-fuses;
+		nvidia,xcvr-lsfslew = <2>;
+		nvidia,xcvr-lsrslew = <2>;
+		nvidia,xcvr-hsslew = <32>;
+		nvidia,hssquelch-level = <2>;
+		nvidia,hsdiscon-level = <5>;
+		status = "disabled";
+	};
+
 	cpus {
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
1.8.1.5

