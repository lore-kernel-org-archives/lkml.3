Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaCCDu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 22:50:29 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7306 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaCCDuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 22:50:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 02 Mar 2014 19:47:29 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] ARM: tegra: add device tree for Tegra Note 7
Date: Mon, 3 Mar 2014 12:50:16 +0900
Message-ID: <1393818616-27131-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a device tree for Tegra Note 7. The set of enabled features is
still minimal with no display option and USB requiring external power.

Pinctrl is not set yet, as the bootloader-provided values allow us to
use the currently-supported hardware.

A default kernel command-line as well as initrd addresses are hardcoded
to match the static values the bootloader is known to use. This allows
booting from an appended DTB without having to alter it at boot time,
since the bootloader has no Device Tree support.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/Makefile         |   1 +
 arch/arm/boot/dts/tegra114-tn7.dts | 278 +++++++++++++++++++++++++++++++++++++
 2 files changed, 279 insertions(+)
 create mode 100644 arch/arm/boot/dts/tegra114-tn7.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 27ca6fd664d0..77829a8aa615 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -357,6 +357,7 @@ dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
 	tegra30-cardhu-a04.dtb \
 	tegra114-dalmore.dtb \
 	tegra114-roth.dtb \
+	tegra114-tn7.dtb \
 	tegra124-venice2.dtb
 dtb-$(CONFIG_ARCH_VERSATILE) += versatile-ab.dtb \
 	versatile-pb.dtb
diff --git a/arch/arm/boot/dts/tegra114-tn7.dts b/arch/arm/boot/dts/tegra114-tn7.dts
new file mode 100644
index 000000000000..185759dc3f7f
--- /dev/null
+++ b/arch/arm/boot/dts/tegra114-tn7.dts
@@ -0,0 +1,278 @@
+/dts-v1/;
+
+#include "tegra114.dtsi"
+
+/ {
+	model = "Tegra Note 7";
+	compatible = "nvidia,tn7", "nvidia,tegra114";
+
+	chosen {
+		bootargs = "console=ttyS0,115200n8 console=tty1 gpt cma=128M fbcon=rotate:2";
+		linux,initrd-start = <0x82000000>;
+		linux,initrd-end = <0x82800000>;
+	};
+
+	firmware {
+		trusted-foundations {
+			compatible = "tlm,trusted-foundations";
+			tlm,version-major = <2>;
+			tlm,version-minor = <8>;
+		};
+	};
+
+	memory {
+		/* memory >= 0x37e00000 is reserved for firmware usage */
+		reg = <0x80000000 0x37e00000>;
+	};
+
+	serial@70006300 {
+		status = "okay";
+	};
+
+	pwm@7000a000 {
+		status = "okay";
+	};
+
+	i2c@7000d000 {
+		status = "okay";
+		clock-frequency = <400000>;
+
+		palmas: pmic@58 {
+			compatible = "ti,palmas";
+			reg = <0x58>;
+			interrupts = <0 86 IRQ_TYPE_LEVEL_HIGH>;
+			ti,irq-externally-inverted;
+
+			#interrupt-cells = <2>;
+			interrupt-controller;
+
+			palmas_gpio: gpio {
+				compatible = "ti,palmas-gpio";
+				gpio-controller;
+				#gpio-cells = <2>;
+			};
+
+			pmic {
+				compatible = "ti,tps65913-pmic", "ti,palmas-pmic";
+
+				regulators {
+					smps123 {
+						regulator-name = "vd-cpu";
+						regulator-min-microvolt = <1000000>;
+						regulator-max-microvolt = <1000000>;
+						regulator-boot-on;
+						regulator-always-on;
+					};
+
+					smps45 {
+						regulator-name = "vd-soc";
+						regulator-min-microvolt = <1100000>;
+						regulator-max-microvolt = <1100000>;
+						regulator-always-on;
+					};
+
+					smps6 {
+						regulator-name = "va-lcd-hv";
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <3000000>;
+						regulator-boot-on;
+						regulator-always-on;
+					};
+
+					smps7 {
+						regulator-name = "vd-ddr";
+						regulator-min-microvolt = <1350000>;
+						regulator-max-microvolt = <1350000>;
+						regulator-boot-on;
+						regulator-always-on;
+					};
+
+					vdd_1v8: smps8 {
+						regulator-name = "vs-pmu-1v8";
+						regulator-min-microvolt = <1800000>;
+						regulator-max-microvolt = <1800000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					smps9 {
+						regulator-name = "vs-sys-2v9";
+						regulator-min-microvolt = <2900000>;
+						regulator-max-microvolt = <2900000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					smps10_out1 {
+						regulator-name = "vd-smps10-out1";
+						regulator-min-microvolt = <5000000>;
+						regulator-max-microvolt = <5000000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					smps10_out2 {
+						regulator-name = "vd-smps10-out2";
+						regulator-min-microvolt = <5000000>;
+						regulator-max-microvolt = <5000000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					ldo1 {
+						regulator-name = "va-pllx";
+						regulator-min-microvolt = <1050000>;
+						regulator-max-microvolt = <1050000>;
+						regulator-boot-on;
+						regulator-always-on;
+					};
+
+					ldo2 {
+						regulator-name = "va-ap-1v2";
+						regulator-min-microvolt = <1200000>;
+						regulator-max-microvolt = <1200000>;
+					};
+
+					ldo3 {
+						regulator-name = "vd-fuse";
+						regulator-min-microvolt = <1800000>;
+						regulator-max-microvolt = <1800000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					ldo4 {
+						regulator-name = "vd-ts-hv";
+						regulator-min-microvolt = <3200000>;
+						regulator-max-microvolt = <3200000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					ldo5 {
+						regulator-name = "va-cam2-hv";
+						regulator-min-microvolt = <2700000>;
+						regulator-max-microvolt = <2700000>;
+					};
+
+					ldo6 {
+						regulator-name = "va-sns-hv";
+						regulator-min-microvolt = <2850000>;
+						regulator-max-microvolt = <2850000>;
+					};
+
+					ldo7 {
+						regulator-name = "va-cam1-hv";
+						regulator-min-microvolt = <2700000>;
+						regulator-max-microvolt = <2700000>;
+					};
+
+					ldo8 {
+						regulator-name = "va-ap-rtc";
+						regulator-min-microvolt = <1100000>;
+						regulator-max-microvolt = <1100000>;
+						ti,enable-ldo8-tracking;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					ldo9 {
+						regulator-name = "vi-sdcard";
+						regulator-min-microvolt = <2900000>;
+						regulator-max-microvolt = <2900000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					ldousb {
+						regulator-name = "avdd-usb";
+						regulator-min-microvolt = <3300000>;
+						regulator-max-microvolt = <3300000>;
+						regulator-always-on;
+					};
+
+					regen1 {
+						regulator-name = "snn-pmu-3v3-sys-en";
+						regulator-boot-on;
+						regulator-always-on;
+					};
+
+					regen2 {
+						regulator-name = "snn-pmu-regen2";
+					};
+
+				};
+			};
+
+			rtc {
+				compatible = "ti,palmas-rtc";
+				interrupt-parent = <&palmas>;
+				interrupts = <8 0>;
+			};
+
+		};
+	};
+	pmc@7000e400 {
+		nvidia,invert-interrupt;
+	};
+
+	/* eMMC */
+	sdhci@78000600 {
+		status = "okay";
+		bus-width = <8>;
+		vmmc-supply = <&vdd_1v8>;
+		non-removable;
+	};
+
+	usb@7d000000 {
+		status = "okay";
+	};
+
+	usb-phy@7d000000 {
+		status = "okay";
+		nvidia,xcvr-setup = <7>;
+		nvidia,xcvr-lsfslew = <2>;
+		nvidia,xcvr-lsrslew = <2>;
+		interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
+		dr_mode = "otg";
+	};
+
+	backlight: backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pwm 1 40000>;
+
+		brightness-levels = <0 16 32 48 64 80 96 112 128 144 160 176 192 208 224 240 255>;
+		default-brightness-level = <10>;
+
+		power-supply = <&lcd_bl_en>;
+		enable-gpios = <&gpio TEGRA_GPIO(H, 2) GPIO_ACTIVE_HIGH>;
+	};
+
+	clocks {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		clk32k_in: clock {
+			compatible = "fixed-clock";
+			reg=<0>;
+			#clock-cells = <0>;
+			clock-frequency = <32768>;
+		};
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		lcd_bl_en: regulator@0 {
+			compatible = "regulator-fixed";
+			regulator-name = "vs_sys";
+			regulator-min-microvolt = <4200000>;
+			regulator-max-microvolt = <4200000>;
+			enable-active-high;
+			regulator-boot-on;
+		};
+	};
+};
-- 
1.9.0

