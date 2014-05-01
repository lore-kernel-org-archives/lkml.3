Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaEAHLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 03:11:05 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15228 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEAHLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 03:11:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 01 May 2014 00:01:26 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH] ARM: tegra: add Tegra Note 7 device tree
Date: Thu, 1 May 2014 16:10:17 +0900
Message-ID: <1398928217-32629-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra Note 7 is a consumer tablet embedding a Tegra 4 SoC with 1GB RAM
and a 720p panel.

The following features are enabled by this device tree: UART, eMMC, USB
(needs external power), PMIC, backlight, DSI panel, keys.

SD card, HDMI, charger, self-powered USB, audio, wifi, bluetooth are not
yet supported but might be by future patches (likely in that order).

Touch panel, sensors & cameras will probably never be supported.

Pinctrl is not set yet, as the bootloader-provided values allow us to
use the currently supported hardware.

A default kernel command-line as well as initrd addresses are hardcoded
to match the static values the bootloader is known to use. This allows
booting from an appended DTB without having to alter it at boot time,
since the bootloader has no Device Tree support.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
[treding@nvidia.com: DT fixes, DSI panel support]
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
DT for SHIELD (roth) is to follow, but I would like to get all reviews on
this one first and apply them to SHIELD for a (hopefully) smooth submission.

SD card not working yet is quite weird. I am investigating this as well as
HDMI, but would like to get this DT secured for 3.16 first and send the
rest as incremental follow-up patches.

Thanks!

 arch/arm/boot/dts/Makefile         |   1 +
 arch/arm/boot/dts/tegra114-tn7.dts | 390 +++++++++++++++++++++++++++++++++++++
 2 files changed, 391 insertions(+)
 create mode 100644 arch/arm/boot/dts/tegra114-tn7.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 49717b2db19a..fb662207a504 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -369,6 +369,7 @@ dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
 	tegra30-cardhu-a02.dtb \
 	tegra30-cardhu-a04.dtb \
 	tegra114-dalmore.dtb \
+	tegra114-tn7.dtb \
 	tegra124-jetson-tk1.dtb \
 	tegra124-venice2.dtb
 dtb-$(CONFIG_ARCH_U300) += ste-u300.dtb
diff --git a/arch/arm/boot/dts/tegra114-tn7.dts b/arch/arm/boot/dts/tegra114-tn7.dts
new file mode 100644
index 000000000000..065d88759291
--- /dev/null
+++ b/arch/arm/boot/dts/tegra114-tn7.dts
@@ -0,0 +1,390 @@
+/dts-v1/;
+
+#include <dt-bindings/input/input.h>
+#include "tegra114.dtsi"
+
+/ {
+	model = "Tegra Note 7";
+	compatible = "nvidia,tn7", "nvidia,tegra114";
+
+	chosen {
+		/* TN7's bootloader's arguments need to be overridden */
+		bootargs = "console=ttyS0,115200n8 console=tty1 gpt cma=128M fbcon=rotate:2";
+		/* TN7's bootloader will place initrd at this address */
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
+	host1x@50000000 {
+		hdmi@54280000 {
+			status = "okay";
+
+			hdmi-supply = <&vdd_5v0_hdmi>;
+			vdd-supply = <&vdd_3v3_hdmi>;
+			pll-supply = <&vdd_1v05_pll>;
+
+			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
+			nvidia,hpd-gpio =
+				<&gpio TEGRA_GPIO(N, 7) GPIO_ACTIVE_HIGH>;
+		};
+
+		dsi@54300000 {
+			status = "okay";
+
+			vdd-supply = <&vdd_1v2_ap>;
+
+			panel@0 {
+				compatible = "lg,ld070wx3-sl01";
+				reg = <0>;
+
+				power-supply = <&vdd_lcd>;
+				backlight = <&backlight>;
+			};
+		};
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
+	hdmi_ddc: i2c@7000c700 {
+		status = "okay";
+		clock-frequency = <100000>;
+	};
+
+	i2c@7000d000 {
+		status = "okay";
+		clock-frequency = <400000>;
+
+		palmas: pmic@58 {
+			compatible = "ti,palmas";
+			reg = <0x58>;
+			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_LOW>;
+
+			#interrupt-cells = <2>;
+			interrupt-controller;
+
+			ti,system-power-controller;
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
+				ldoln-in-supply = <&vdd_smps10_out2>;
+
+				regulators {
+					smps123 {
+						regulator-name = "vd-cpu";
+						regulator-min-microvolt = <1000000>;
+						regulator-max-microvolt = <1000000>;
+						regulator-always-on;
+						regulator-boot-on;
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
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					smps7 {
+						regulator-name = "vd-ddr";
+						regulator-min-microvolt = <1350000>;
+						regulator-max-microvolt = <1350000>;
+						regulator-always-on;
+						regulator-boot-on;
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
+					vdd_2v9_sys: smps9 {
+						regulator-name = "vs-sys-2v9";
+						regulator-min-microvolt = <2900000>;
+						regulator-max-microvolt = <2900000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					vdd_smps10_out1: smps10_out1 {
+						regulator-name = "vd-smps10-out1";
+						regulator-min-microvolt = <5000000>;
+						regulator-max-microvolt = <5000000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					vdd_smps10_out2: smps10_out2 {
+						regulator-name = "vd-smps10-out2";
+						regulator-min-microvolt = <5000000>;
+						regulator-max-microvolt = <5000000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					vdd_1v05_pll: ldo1 {
+						regulator-name = "va-pllx";
+						regulator-min-microvolt = <1050000>;
+						regulator-max-microvolt = <1050000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					vdd_1v2_ap: ldo2 {
+						regulator-name = "va-ap-1v2";
+						regulator-min-microvolt = <1200000>;
+						regulator-max-microvolt = <1200000>;
+						regulator-always-on;
+						regulator-boot-on;
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
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					ldo6 {
+						regulator-name = "va-sns-hv";
+						regulator-min-microvolt = <2850000>;
+						regulator-max-microvolt = <2850000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
+
+					ldo7 {
+						regulator-name = "va-cam1-hv";
+						regulator-min-microvolt = <2700000>;
+						regulator-max-microvolt = <2700000>;
+						regulator-always-on;
+						regulator-boot-on;
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
+						regulator-min-microvolt = <1800000>;
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
+						regulator-boot-on;
+					};
+
+					vdd_3v3_hdmi: ldoln {
+						regulator-name = "va-hdmi";
+						regulator-min-microvolt = <3300000>;
+						regulator-max-microvolt = <3300000>;
+						regulator-always-on;
+						regulator-boot-on;
+					};
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
+
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
+		/* Should be changed to "otg" once we have vbus_supply */
+		/* As of now, USB devices need to be powered externally */
+		dr_mode = "host";
+	};
+
+	backlight: backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pwm 1 40000>;
+
+		brightness-levels = <0 4 8 16 32 64 128 255>;
+		default-brightness-level = <6>;
+
+		power-supply = <&lcd_bl_en>;
+	};
+
+	clocks {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		clk32k_in: clock {
+			compatible = "fixed-clock";
+			reg = <0>;
+			#clock-cells = <0>;
+			clock-frequency = <32768>;
+		};
+	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		power {
+			label = "Power";
+			gpios = <&gpio TEGRA_GPIO(Q, 0) GPIO_ACTIVE_LOW>;
+			linux,code = <KEY_POWER>;
+			gpio-key,wakeup;
+		};
+
+		volume_down {
+			label = "Volume Down";
+			gpios = <&gpio TEGRA_GPIO(Q, 2) GPIO_ACTIVE_LOW>;
+			linux,code = <KEY_VOLUMEDOWN>;
+		};
+
+		volume_up {
+			label = "Volume Up";
+			gpios = <&gpio TEGRA_GPIO(R, 2) GPIO_ACTIVE_LOW>;
+			linux,code = <KEY_VOLUMEUP>;
+		};
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		/* FIXME: output of BQ24192 */
+		vs_sys: regulator@0 {
+			compatible = "regulator-fixed";
+			reg = <0>;
+			regulator-name = "VS_SYS";
+			regulator-min-microvolt = <4200000>;
+			regulator-max-microvolt = <4200000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
+
+		lcd_bl_en: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "VDD_LCD_BL";
+			regulator-min-microvolt = <16500000>;
+			regulator-max-microvolt = <16500000>;
+			gpio = <&gpio TEGRA_GPIO(H, 2) GPIO_ACTIVE_HIGH>;
+			enable-active-high;
+			vin-supply = <&vs_sys>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
+
+		vdd_lcd: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name = "VD_LCD_1V8";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			gpio = <&palmas_gpio 4 GPIO_ACTIVE_HIGH>;
+			enable-active-high;
+			vin-supply = <&vdd_1v8>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
+
+		vdd_5v0_hdmi: regulator@3 {
+			compatible = "regulator-fixed";
+			reg = <3>;
+			regulator-name = "VDD_5V_HDMI_CONN";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			gpio = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_HIGH>;
+			enable-active-high;
+			gpio-open-drain;
+			vin-supply = <&vdd_smps10_out1>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
+	};
+};
-- 
1.9.2

