Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaFMSN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:13:59 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:35602 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaFMSN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:13:57 -0400
From: Doug Anderson <dianders@chromium.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, broonie@kernel.org, sjg@chromium.org,
        olof@lixom.net, javier.martinez@collabora.co.uk, ch.naveen@samsung.com,
        swarren@wwwdotorg.org, khilman@linaro.org, ajaynumb@gmail.com,
        rahul.sharma@samsung.com, tushar.b@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, ben-linux@fluff.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: Add cros_ec to exynos5420-peach-pit and exynos5800-peach-pi
Date: Fri, 13 Jun 2014 11:13:33 -0700
Message-Id: <1402683213-23120-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1402683213-23120-1-git-send-email-dianders@chromium.org>
References: <1402683213-23120-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds cros_ec to exynos5420-peach-pit and exynos5800-peach-pi,
including:
* The keyboard
* The i2c tunnel
* The tps65090 under the i2c tunnel
* The battery under the i2c tunnel

To add extra motivation, it should be noted that tps65090 is one of
the things needed to get display-related FETs turned on for pit and
pi.

Note that this relies on a few outstanding changes:
* Needs "cros-ec-keyboard.dtsi" in order to compile properly.  See
  (ARM: dts: Create a cros-ec-keyboard fragment) at
  <https://patchwork.kernel.org/patch/4297451/>.
* Needs (mfd: cros_ec: spi: Fix end of transfer on devices with no
  spi-msg-delay) from this series to work properly.
* Needs (spi: s3c64xx: fix broken "cs_gpios" usage in the driver) and
  (spi: s3c64xx: for DT platofrms always get the chipselect info from
  DT node) to work properly and match the documented bindings.  See
  <https://patchwork.kernel.org/patch/4346701/> and
  <https://patchwork.kernel.org/patch/4346711/>

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 146 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 146 +++++++++++++++++++++++++++++
 2 files changed, 292 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 1c5b8f9..67b7c32 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -25,6 +25,11 @@
 		"google,pit", "google,peach","samsung,exynos5420",
 		"samsung,exynos5";
 
+	aliases {
+		/* Assign 20 so we don't get confused w/ builtin ones */
+		i2c20 = "/spi@12d40000/cros-ec@0/i2c-tunnel";
+	};
+
 	memory {
 		reg = <0x20000000 0x80000000>;
 	};
@@ -87,6 +92,13 @@
 		pinctrl-0 = <&usb301_vbus_en>;
 		enable-active-high;
 	};
+
+	vbat: fixed-regulator {
+		compatible = "regulator-fixed";
+		regulator-name = "vbat-supply";
+		regulator-boot-on;
+		regulator-always-on;
+	};
 };
 
 &pinctrl_0 {
@@ -111,6 +123,20 @@
 		samsung,pin-drv = <0>;
 	};
 
+	ec_irq: ec-irq {
+		samsung,pins = "gpx1-5";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	tps65090_irq: tps65090-irq {
+		samsung,pins = "gpx2-5";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
 	hdmi_hpd_irq: hdmi-hpd-irq {
 		samsung,pins = "gpx3-7";
 		samsung,pin-function = <0>;
@@ -127,6 +153,19 @@
 };
 
 &pinctrl_3 {
+	/* Drive SPI lines at x2 for better integrity */
+	spi2-bus {
+		samsung,pin-drv = <2>;
+	};
+
+	/* Drive SPI chip select at x2 for better integrity */
+	ec_spi_cs: ec-spi-cs {
+		samsung,pins = "gpb1-2";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <2>;
+	};
+
 	usb300_vbus_en: usb300-vbus-en {
 		samsung,pins = "gph0-0";
 		samsung,pin-function = <1>;
@@ -189,6 +228,111 @@
 	};
 };
 
+&spi_2 {
+	status = "okay";
+	num-cs = <1>;
+	samsung,spi-src-clk = <0>;
+	cs-gpios = <&gpb1 2 0>;
+
+	cros_ec: cros-ec@0 {
+		compatible = "google,cros-ec-spi";
+		interrupt-parent = <&gpx1>;
+		interrupts = <5 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&ec_spi_cs &ec_irq>;
+		reg = <0>;
+		spi-max-frequency = <3125000>;
+
+		controller-data {
+			samsung,spi-feedback-delay = <1>;
+		};
+
+		i2c-tunnel {
+			compatible = "google,cros-ec-i2c-tunnel";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			google,remote-bus = <0>;
+
+			battery: sbs-battery@b {
+				compatible = "sbs,sbs-battery";
+				reg = <0xb>;
+				sbs,poll-retry-count = <1>;
+				sbs,i2c-retry-count = <2>;
+			};
+
+			power-regulator@48 {
+				compatible = "ti,tps65090";
+				reg = <0x48>;
+
+				/*
+				 * Config irq to disable internal pulls
+				 * even though we run in polling mode.
+				 */
+				pinctrl-names = "default";
+				pinctrl-0 = <&tps65090_irq>;
+
+				vsys1-supply = <&vbat>;
+				vsys2-supply = <&vbat>;
+				vsys3-supply = <&vbat>;
+				infet1-supply = <&vbat>;
+				infet2-supply = <&vbat>;
+				infet3-supply = <&vbat>;
+				infet4-supply = <&vbat>;
+				infet5-supply = <&vbat>;
+				infet6-supply = <&vbat>;
+				infet7-supply = <&vbat>;
+				vsys-l1-supply = <&vbat>;
+				vsys-l2-supply = <&vbat>;
+
+				regulators {
+					dcdc1 {
+						ti,enable-ext-control;
+					};
+					dcdc2 {
+						ti,enable-ext-control;
+					};
+					dcdc3 {
+						ti,enable-ext-control;
+					};
+					fet1 {
+						regulator-name = "vcd_led";
+					};
+					tps65090_fet2: fet2 {
+						regulator-name = "video_mid";
+						regulator-always-on;
+					};
+					fet3 {
+						regulator-name = "wwan_r";
+						regulator-always-on;
+					};
+					fet4 {
+						regulator-name = "sdcard";
+						regulator-always-on;
+					};
+					fet5 {
+						regulator-name = "camout";
+					};
+					fet6 {
+						regulator-name = "lcd_vdd";
+					};
+					tps65090_fet7: fet7 {
+						regulator-name = "video_mid_1a";
+						regulator-always-on;
+					};
+					ldo1 {
+					};
+					ldo2 {
+					};
+				};
+
+				charger {
+					compatible = "ti,tps65090-charger";
+				};
+			};
+		};
+	};
+};
+
 &hsi2c_7 {
 	status = "okay";
 
@@ -285,3 +429,5 @@
 		};
 	};
 };
+
+#include "cros-ec-keyboard.dtsi"
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index f3af207..b33f548 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -23,6 +23,11 @@
 		"google,pi", "google,peach", "samsung,exynos5800",
 		"samsung,exynos5";
 
+	aliases {
+		/* Assign 20 so we don't get confused w/ builtin ones */
+		i2c20 = "/spi@12d40000/cros-ec@0/i2c-tunnel";
+	};
+
 	memory {
 		reg = <0x20000000 0x80000000>;
 	};
@@ -78,6 +83,13 @@
 		pinctrl-0 = <&usb301_vbus_en>;
 		enable-active-high;
 	};
+
+	vbat: fixed-regulator {
+		compatible = "regulator-fixed";
+		regulator-name = "vbat-supply";
+		regulator-boot-on;
+		regulator-always-on;
+	};
 };
 
 &pinctrl_0 {
@@ -102,6 +114,20 @@
 		samsung,pin-drv = <0>;
 	};
 
+	ec_irq: ec-irq {
+		samsung,pins = "gpx1-5";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
+	tps65090_irq: tps65090-irq {
+		samsung,pins = "gpx2-5";
+		samsung,pin-function = <0>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
+
 	hdmi_hpd_irq: hdmi-hpd-irq {
 		samsung,pins = "gpx3-7";
 		samsung,pin-function = <0>;
@@ -111,6 +137,19 @@
 };
 
 &pinctrl_3 {
+	/* Drive SPI lines at x2 for better integrity */
+	spi2-bus {
+		samsung,pin-drv = <2>;
+	};
+
+	/* Drive SPI chip select at x2 for better integrity */
+	ec_spi_cs: ec-spi-cs {
+		samsung,pins = "gpb1-2";
+		samsung,pin-function = <1>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <2>;
+	};
+
 	usb300_vbus_en: usb300-vbus-en {
 		samsung,pins = "gph0-0";
 		samsung,pin-function = <1>;
@@ -173,6 +212,111 @@
 	};
 };
 
+&spi_2 {
+	status = "okay";
+	num-cs = <1>;
+	samsung,spi-src-clk = <0>;
+	cs-gpios = <&gpb1 2 0>;
+
+	cros_ec: cros-ec@0 {
+		compatible = "google,cros-ec-spi";
+		interrupt-parent = <&gpx1>;
+		interrupts = <5 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&ec_spi_cs &ec_irq>;
+		reg = <0>;
+		spi-max-frequency = <3125000>;
+
+		controller-data {
+			samsung,spi-feedback-delay = <1>;
+		};
+
+		i2c-tunnel {
+			compatible = "google,cros-ec-i2c-tunnel";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			google,remote-bus = <0>;
+
+			battery: sbs-battery@b {
+				compatible = "sbs,sbs-battery";
+				reg = <0xb>;
+				sbs,poll-retry-count = <1>;
+				sbs,i2c-retry-count = <2>;
+			};
+
+			power-regulator@48 {
+				compatible = "ti,tps65090";
+				reg = <0x48>;
+
+				/*
+				 * Config irq to disable internal pulls
+				 * even though we run in polling mode.
+				 */
+				pinctrl-names = "default";
+				pinctrl-0 = <&tps65090_irq>;
+
+				vsys1-supply = <&vbat>;
+				vsys2-supply = <&vbat>;
+				vsys3-supply = <&vbat>;
+				infet1-supply = <&vbat>;
+				infet2-supply = <&vbat>;
+				infet3-supply = <&vbat>;
+				infet4-supply = <&vbat>;
+				infet5-supply = <&vbat>;
+				infet6-supply = <&vbat>;
+				infet7-supply = <&vbat>;
+				vsys-l1-supply = <&vbat>;
+				vsys-l2-supply = <&vbat>;
+
+				regulators {
+					dcdc1 {
+						ti,enable-ext-control;
+					};
+					dcdc2 {
+						ti,enable-ext-control;
+					};
+					dcdc3 {
+						ti,enable-ext-control;
+					};
+					fet1 {
+						regulator-name = "vcd_led";
+					};
+					tps65090_fet2: fet2 {
+						regulator-name = "video_mid";
+						regulator-always-on;
+					};
+					fet3 {
+						regulator-name = "wwan_r";
+						regulator-always-on;
+					};
+					fet4 {
+						regulator-name = "sdcard";
+						regulator-always-on;
+					};
+					fet5 {
+						regulator-name = "camout";
+					};
+					fet6 {
+						regulator-name = "lcd_vdd";
+					};
+					tps65090_fet7: fet7 {
+						regulator-name = "video_mid_1a";
+						regulator-always-on;
+					};
+					ldo1 {
+					};
+					ldo2 {
+					};
+				};
+
+				charger {
+					compatible = "ti,tps65090-charger";
+				};
+			};
+		};
+	};
+};
+
 &dp {
 	status = "okay";
 	pinctrl-names = "default";
@@ -251,3 +395,5 @@
 &watchdog {
 	timeout-sec = <32>;
 };
+
+#include "cros-ec-keyboard.dtsi"
-- 
2.0.0.526.g5318336

