Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120AbaFXQ27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:28:59 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:36408 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965033AbaFXQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:28:55 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, sjg@chromium.org, olof@lixom.net,
        javier.martinez@collabora.co.uk, ch.naveen@samsung.com,
        swarren@wwwdotorg.org, khilman@linaro.org, ajaynumb@gmail.com,
        rahul.sharma@samsung.com, tushar.b@samsung.com,
        Doug Anderson <dianders@chromium.org>, ben-linux@fluff.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] ARM: dts: Add cros_ec to exynos5420-peach-pit and exynos5800-peach-pi
Date: Tue, 24 Jun 2014 09:28:52 -0700
Message-Id: <1403627332-4688-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
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
* Needs (spi: s3c64xx: fix broken "cs_gpios" usage in the driver) and
  (spi: s3c64xx: for DT platofrms always get the chipselect info from
  DT node) to work properly and match the documented bindings.  See
  <https://patchwork.kernel.org/patch/4346701/> and
  <https://patchwork.kernel.org/patch/4346711/>

Signed-off-by: Doug Anderson <dianders@chromium.org>
Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Tested-by: Tushar Behera <tushar.b@samsung.com>
---
Changes in v3:
- Added aliases for tps65090 regulators as per Tushar.

Changes in v2:
- Now just one patch since mfd patch landed.
- Rebased to ToT linux-next

 arch/arm/boot/dts/exynos5420-peach-pit.dts | 145 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 145 +++++++++++++++++++++++++++++
 2 files changed, 290 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 7649982..b2f1237 100644
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
 	backlight {
 		compatible = "pwm-backlight";
 		pwms = <&pwm 0 1000000 0>;
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
 
 &dp {
@@ -231,6 +243,20 @@
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
 	dp_hpd_gpio: dp_hpd_gpio {
 		samsung,pins = "gpx2-6";
 		samsung,pin-function = <0>;
@@ -247,6 +273,19 @@
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
@@ -266,6 +305,111 @@
 	status = "okay";
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
+					tps65090_dcdc1: dcdc1 {
+						ti,enable-ext-control;
+					};
+					tps65090_dcdc2: dcdc2 {
+						ti,enable-ext-control;
+					};
+					tps65090_dcdc3: dcdc3 {
+						ti,enable-ext-control;
+					};
+					tps65090_fet1: fet1 {
+						regulator-name = "vcd_led";
+					};
+					tps65090_fet2: fet2 {
+						regulator-name = "video_mid";
+						regulator-always-on;
+					};
+					tps65090_fet3: fet3 {
+						regulator-name = "wwan_r";
+						regulator-always-on;
+					};
+					tps65090_fet4: fet4 {
+						regulator-name = "sdcard";
+						regulator-always-on;
+					};
+					tps65090_fet5: fet5 {
+						regulator-name = "camout";
+					};
+					tps65090_fet6: fet6 {
+						regulator-name = "lcd_vdd";
+					};
+					tps65090_fet7: fet7 {
+						regulator-name = "video_mid_1a";
+						regulator-always-on;
+					};
+					tps65090_ldo1: ldo1 {
+					};
+					tps65090_ldo2: ldo2 {
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
 &uart_3 {
 	status = "okay";
 };
@@ -287,3 +431,4 @@
 	timeout-sec = <32>;
 };
 
+#include "cros-ec-keyboard.dtsi"
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 2c2c137..5c60bbe 100644
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
 	backlight {
 		compatible = "pwm-backlight";
 		pwms = <&pwm 0 1000000 0>;
@@ -85,6 +90,13 @@
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
 
 &dp {
@@ -229,6 +241,20 @@
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
 	dp_hpd_gpio: dp_hpd_gpio {
 		samsung,pins = "gpx2-6";
 		samsung,pin-function = <0>;
@@ -245,6 +271,19 @@
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
@@ -264,6 +303,111 @@
 	status = "okay";
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
+					tps65090_dcdc1: dcdc1 {
+						ti,enable-ext-control;
+					};
+					tps65090_dcdc2: dcdc2 {
+						ti,enable-ext-control;
+					};
+					tps65090_dcdc3: dcdc3 {
+						ti,enable-ext-control;
+					};
+					tps65090_fet1: fet1 {
+						regulator-name = "vcd_led";
+					};
+					tps65090_fet2: fet2 {
+						regulator-name = "video_mid";
+						regulator-always-on;
+					};
+					tps65090_fet3: fet3 {
+						regulator-name = "wwan_r";
+						regulator-always-on;
+					};
+					tps65090_fet4: fet4 {
+						regulator-name = "sdcard";
+						regulator-always-on;
+					};
+					tps65090_fet5: fet5 {
+						regulator-name = "camout";
+					};
+					tps65090_fet6: fet6 {
+						regulator-name = "lcd_vdd";
+					};
+					tps65090_fet7: fet7 {
+						regulator-name = "video_mid_1a";
+						regulator-always-on;
+					};
+					tps65090_ldo1: ldo1 {
+					};
+					tps65090_ldo2: ldo2 {
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
 &uart_3 {
 	status = "okay";
 };
@@ -285,3 +429,4 @@
 	timeout-sec = <32>;
 };
 
+#include "cros-ec-keyboard.dtsi"
-- 
2.0.0.526.g5318336

