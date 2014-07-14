Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbaGNUVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:21:00 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48877 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbaGNUUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:20:48 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, bcousson@baylibre.com, tony@atomide.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 1/5] arm: dts: omap3-gta04: Add missing nodes to fully describe gta04 board
Date: Mon, 14 Jul 2014 22:20:24 +0200
Message-Id: <1405369228-27197-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405369228-27197-1-git-send-email-marek@goldelico.com>
References: <1405369228-27197-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dts | 443 +++++++++++++++++++++++++++++++++++---
 1 file changed, 412 insertions(+), 31 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
index 215513b..bd6a71d 100644
--- a/arch/arm/boot/dts/omap3-gta04.dts
+++ b/arch/arm/boot/dts/omap3-gta04.dts
@@ -12,7 +12,7 @@
 #include "omap36xx.dtsi"
 
 / {
-	model = "OMAP3 GTA04";
+	model = "Goldelico GTA04";
 	compatible = "ti,omap3-gta04", "ti,omap36xx", "ti,omap3";
 
 	cpus {
@@ -26,6 +26,11 @@
 		reg = <0x80000000 0x20000000>; /* 512 MB */
 	};
 
+	aliases {
+		display0 = &lcd;
+		display1 = &tv0;
+	};
+
 	gpio-keys {
 		compatible = "gpio-keys";
 
@@ -37,15 +42,78 @@
 		};
 	};
 
+	gpio-keys-wwan-wakeup {
+		compatible = "gpio-keys";
+
+		wwan_wakeup_button: wwan-wakeup-button {
+			label = "3G_WOE";
+			linux,code = <240>;
+			gpios = <&gpio1 10 GPIO_ACTIVE_HIGH>;
+			gpio-key,wakeup;
+		};
+	};
+
+	hsusb2_phy: hsusb2_phy {
+		compatible = "usb-nop-xceiv";
+		reset-gpios = <&gpio6 14 GPIO_ACTIVE_LOW>; /* gpio_174 = reset for USB3322 */
+	};
+
+	antenna-detect {
+		compatible = "linux,extcon-gpio";
+		label = "gps_antenna";
+		gpios = <&gpio5 16 0>; /* gpio_144 */
+		debounce-delay-ms = <10>;
+		irq-flags = <IRQ_TYPE_EDGE_BOTH>;
+		state-on = "external";
+		state-off = "internal";
+	};
+
 	sound {
 		compatible = "ti,omap-twl4030";
 		ti,model = "gta04";
 
 		ti,mcbsp = <&mcbsp2>;
 		ti,codec = <&twl_audio>;
+
+		ti,mcbsp-voice = <&mcbsp4>;
+	};
+
+	sound_card {
+		compatible = "goldelico,gta04-audio";
+		gta04,cpu-dai = <&mcbsp2>;
+	};
+
+	gtm601_codec: voice_codec {
+		compatible = "gtm601-codec";
+	};
+
+	sound_voice {
+		compatible = "goldelico,gta04-voice";
+		gta04,cpu-dai = <&mcbsp4>;
+		gta04,codec = <&gtm601_codec>;
 	};
 
-	spi_lcd {
+	w2cbw003_codec: headset_codec {
+		compatible = "w2cbw003-codec";
+	};
+
+	sound_headset {
+		compatible = "goldelico,gta04-headset";
+		gta04,cpu-dai = <&mcbsp3>;
+		gta04,codec = <&w2cbw003_codec>;
+	};
+
+	sound_fm {
+		compatible = "goldelico,gta04-fm";
+		gta04,cpu-dai = <&mcbsp1>;
+		gta04,codec = <&si4721_codec>;
+	};
+
+	madc-hwmon {
+		compatible = "ti,twl4030-madc-hwmon";
+	};
+
+	spi_lcd: spi_lcd {
 		compatible = "spi-gpio";
 		#address-cells = <0x1>;
 		#size-cells = <0x0>;
@@ -75,7 +143,7 @@
 		};
 	};
 
-	battery {
+	madc_battery: battery {
 		compatible = "ti,twl4030-madc-battery";
 		capacity = <1200000>;
 		charging-calibration-data = <4200 100
@@ -100,6 +168,83 @@
 		                   "ichg",
 		                   "vbat";
 	};
+
+	backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pwm 0 2000000>;
+		brightness-levels = <0 11 20 30 40 50 60 70 80 90 100>;
+		default-brightness-level = <10>;
+		pinctrl-names = "default";
+		pintcrl-0 = <&backlight_pins>;
+		power-supply = <&power>;
+	};
+
+	pwm: omap_pwm {
+		compatible = "ti,omap-pwm";
+		timers = <&timer11>;
+		#pwm-cells = <2>;
+	};
+
+	/* should be a PWM */
+	power: fixed_regulator@0 {
+	       compatible = "regulator-fixed";
+	       regulator-name = "bl-enable";
+	       regulator-boot-on;
+	       regulator-always-on;
+	       regulator-min-microvolt = "1000000";
+	       regulator-max-microvolt = "1000000";
+	       gpio = <&gpio2 25 0>;	/* GPT11/PWM */
+	       enable-active-high;
+	};
+
+	tv0: connector@1 {
+		compatible = "svideo-connector";
+		label = "tv";
+
+		port {
+			tv_connector_in: endpoint {
+				remote-endpoint = <&venc_out>;
+			};
+		};
+	};
+
+	tv_amp: opa362 {
+		compatible = "ti,opa362";
+		gpio = <&gpio1 23 0>;	/* GPIO to enable video out amplifier */
+	};
+
+	/* presents a single gpio to be plumbed to uart1 dts */
+	bt_en: w2cbw003 {
+		compatible = "wi2wi,w2cbw003";
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		vdd-supply = <&vaux4>;
+	};
+
+	/* presents a single gpio to be plumbed to uart2 dts */
+	gps_en: w2sg0004 {
+		compatible = "wi2wi,w2sg0004";
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		lna-supply = <&vsim>;	/* LNA regulator */
+		on-off-gpio = <&gpio5 17 0>;	/* gpio_145: trigger for turning on/off w2sg0004 */
+		rx-gpio = <&gpio5 19 0>;	/* gpio_147: RX */
+		rx-on-mux = < (PIN_INPUT_PULLUP | MUX_MODE0) >;
+		rx-off-mux = < (PIN_INPUT_PULLUP | MUX_MODE4) >;
+	};
+
+	/* control modem power through rfkill */
+	modem_en: modem {
+		compatible = "option,gtm601";
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		usb-port = <&hsusb2_phy>;
+		on-off-gpio = <&gpio6 26 0>;	/* gpio_186: trigger to power on modem */
+		on-indicator-gpio = <0>;
+	};
 };
 
 &omap3_pmx_core {
@@ -168,11 +313,72 @@
                >;
        };
 
+	backlight_pins: backlight_pins_pimnux {
+		pinctrl-single,pins = <0x8a MUX_MODE4>;
+	};
+
+	hsusb2_pins: pinmux_hsusb2_pins {
+		pinctrl-single,pins = <
+			OMAP3_CORE1_IOPAD(0x21d4, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi1_cs3.hsusb2_data2 */
+			OMAP3_CORE1_IOPAD(0x21d6, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_clk.hsusb2_data7 */
+			OMAP3_CORE1_IOPAD(0x21d8, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_simo.hsusb2_data4 */
+			OMAP3_CORE1_IOPAD(0x21da, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_somi.hsusb2_data5 */
+			OMAP3_CORE1_IOPAD(0x21dc, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs0.hsusb2_data6 */
+			OMAP3_CORE1_IOPAD(0x21de, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs1.hsusb2_data3 */
+		>;
+	};
+
+	i2c1_pins: pinmux_i2c1_pins {
+		pinctrl-single,pins = <
+			0x18a (PIN_INPUT_PULLUP | MUX_MODE0)   /* i2c1_scl.i2c1_scl */
+			0x18c (PIN_INPUT_PULLUP | MUX_MODE0)   /* i2c1_sda.i2c1_sda */
+		>;
+	};
+
+	i2c2_pins: pinmux_i2c2_pins {
+		pinctrl-single,pins = <
+			0x18e (PIN_INPUT_PULLUP | MUX_MODE0)   /* i2c2_scl.i2c2_scl */
+			0x190 (PIN_INPUT_PULLUP | MUX_MODE0)   /* i2c2_sda.i2c2_sda */
+		>;
+	};
+
+	i2c3_pins: pinmux_i2c3_pins {
+		pinctrl-single,pins = <
+			0x192 (PIN_INPUT_PULLUP | MUX_MODE0)   /* i2c3_scl.i2c3_scl */
+			0x194 (PIN_INPUT_PULLUP | MUX_MODE0)   /* i2c3_sda.i2c3_sda */
+		>;
+	};
+
+	bma180_pins: pinmux_bma180_pins {
+		pinctrl-single,pins = <
+			OMAP3_CORE1_IOPAD(0x213a, PIN_INPUT_PULLUP | MUX_MODE4)   /* gpio_115 */
+		>;
+	};
+};
+
+&omap3_pmx_core2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+			&hsusb2_2_pins
+	>;
+
+	hsusb2_2_pins: pinmux_hsusb2_2_pins {
+		pinctrl-single,pins = <
+			OMAP3630_CORE2_IOPAD(0x25f0, PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
+			OMAP3630_CORE2_IOPAD(0x25f2, PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
+			OMAP3630_CORE2_IOPAD(0x25f4, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d12.hsusb2_dir */
+			OMAP3630_CORE2_IOPAD(0x25f6, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d13.hsusb2_nxt */
+			OMAP3630_CORE2_IOPAD(0x25f8, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d14.hsusb2_data0 */
+			OMAP3630_CORE2_IOPAD(0x25fa, PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d15.hsusb2_data1 */
+		>;
+	};
+
 	spi_gpio_pins: spi_gpio_pinmux {
-		pinctrl-single,pins = <0x5a8 (PIN_OUTPUT | MUX_MODE4) /* clk */
-			0x5b6 (PIN_OUTPUT | MUX_MODE4) /* cs */
-			0x5b8 (PIN_OUTPUT | MUX_MODE4) /* tx */
-			0x5b4 (PIN_INPUT | MUX_MODE4) /* rx */
+		pinctrl-single,pins = <
+			OMAP3630_CORE2_IOPAD(0x25d8, PIN_OUTPUT | MUX_MODE4) /* clk */
+			OMAP3630_CORE2_IOPAD(0x25e6, PIN_OUTPUT | MUX_MODE4) /* cs */
+			OMAP3630_CORE2_IOPAD(0x25e8, PIN_OUTPUT | MUX_MODE4) /* tx */
+			OMAP3630_CORE2_IOPAD(0x25e4, PIN_INPUT | MUX_MODE4) /* rx */
 		>;
 	};
 };
@@ -184,11 +390,55 @@
 		reg = <0x48>;
 		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
 		interrupt-parent = <&intc>;
-	};
 
-	twl_audio: audio {
-		compatible = "ti,twl4030-audio";
-		codec {
+		twl_power: power {
+			compatible = "ti,twl4030-power";
+			ti,use_poweroff;
+		};
+		/* spare */
+		vaux1: regulator-vaux1 {
+			compatible = "ti,twl4030-vaux1";
+			regulator-min-microvolt = <2500000>;
+			regulator-max-microvolt = <3000000>;
+		};
+		/* sensors */
+		vaux2: regulator-vaux2 {
+			compatible = "ti,twl4030-vaux2";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
+			regulator-always-on;	/* we should not switch off while keeping 1V8 on! */
+		};
+		/* camera */
+		vaux3: regulator-vaux3 {
+			compatible = "ti,twl4030-vaux3";
+			regulator-min-microvolt = <2500000>;
+			regulator-max-microvolt = <2500000>;
+		};
+		/* WLAN/BT */
+		vaux4: regulator-vaux4 {
+			compatible = "ti,twl4030-vaux4";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <3150000>;
+		};
+		/* GPS LNA */
+		vsim: regulator-vsim {
+			compatible = "ti,twl4030-vsim";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <3150000>;
+		};
+		/* backup battery charger */
+		charger: bci {
+			ti,bb-uvolt = <3200000>;
+			ti,bb-uamp = <150>;
+		};
+		twl_audio: audio {
+			compatible = "ti,twl4030-audio";
+
+			ti,enable-vibra = <1>;
+
+			codec {
+				ti,ramp_delay_value = <3>;
+			};
 		};
 	};
 };
@@ -209,19 +459,25 @@
 
 	/* accelerometer */
 	bma180@41 {
+		/* we use the BMA150 Input (CONFIG_INPUT_BMA150) driver */
 		compatible = "bosch,bma180";
 		reg = <0x41>;
-		interrupt-parent = <&gpio3>;
-		interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
+		pinctrl-names = "default";
+		pintcrl-0 = <&bma180_pins>;
+		interrupt-parent = <&gpio4>;
+		interrupts = <19 (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING)>;
 	};
 
 	/* leds */
-	tca6507@45 {
+	tca_gpios: tca6507@45 {
 		compatible = "ti,tca6507";
 		#address-cells = <1>;
 		#size-cells = <0>;
 		reg = <0x45>;
 
+		gpio-controller;
+		#gpio-cells = <2>;
+
 		gta04_led0: red_aux@0 {
 			label = "gta04:red:aux";
 			reg = <0x0>;
@@ -242,12 +498,11 @@
 			label = "gta04:green:power";
 			reg = <0x4>;
 		};
-	};
 
-	/* compass aka magnetometer */
-	hmc5843@1e {
-		compatible = "honeywell,hmc5843";
-		reg = <0x1e>;
+		wifi_reset: wifi_reset@6 { /* reference as <&tca_gpios 0 0> since it is currently the only GPIO */
+			reg = <0x6>;
+			compatible = "gpio";
+		};
 	};
 
 	/* touchscreen */
@@ -256,13 +511,54 @@
 		reg = <0x48>;
 		interrupt-parent = <&gpio6>;
 		interrupts = <0 IRQ_TYPE_EDGE_FALLING>;
-		gpios = <&gpio6 0 GPIO_ACTIVE_LOW>;
-		ti,x-plate-ohms = <600>;
+		gpios = <&gpio6 0 GPIO_ACTIVE_LOW>;	/* gpio_160 */
+		ti,x-plate-ohms = <550>;
+		ti,rng_x = <123 456>;
+		ti,rng_y = <123 456>;
+		ti,rng_z = <123 456>;
+		ti,flip_x = <0>;
+		ti,flip_y = <1>;
+		ti,swap_xy = <0>;
+	};
+
+	/* compass aka magnetometer */
+	hmc5843@1e {
+		compatible = "honeywell,hmc5883l";
+		reg = <0x1e>;
+		vdd-supply = <&vaux2>;
 	};
+
+	/* gyroscope */
+	itg3200@68 {
+		compatible = "invensense,itg3200";
+		reg = <0x68>;
+		vdd-supply = <&vaux2>;
+	};
+
+	/* RFID EEPROM */
+	m24lr64@50 {
+		compatible = "at,24c64";
+		reg = <0x50>;
+	};
+
+	/* camera */
+	ov9655@30 {
+		compatible = "omnivision,ov9655";
+		reg = <0x30>;
+		vdd_ana-supply = <&vaux3>;
+	};
+
+	/* FM Radio (no kernel driver) */
+	si4721_codec: si4721@11 {
+		compatible = "silicon-labs,si4721";
+		reg = <0x11>;
+	};
+
 };
 
 &i2c3 {
 	clock-frequency = <100000>;
+	/* unused */
 };
 
 &usb_otg_hs {
@@ -286,35 +582,124 @@
 	vmmc-supply = <&vaux4>;
 	bus-width = <4>;
 	ti,non-removable;
+	reset-gpios = <&tca_gpios 0 GPIO_ACTIVE_LOW>;	/* W2CBW003 reset through tca6507 */
 };
 
 &mmc3 {
 	status = "disabled";
 };
 
-&uart1 {
+&uart1 { /* Bluetooth /dev/ttyO0 */
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart1_pins>;
+	dtr-gpio = <&bt_en 0 GPIO_ACTIVE_LOW>;	/* w2cbw bluetooth power control through virtual gpio */
 };
 
-&uart2 {
+&uart2 { /* GPS /dev/ttyO1 */
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart2_pins>;
+	dtr-gpio = <&gps_en 0 GPIO_ACTIVE_HIGH>;	/* w2sg0004 GPS power control through virtual gpio */
 };
 
-&uart3 {
+&uart3 { /* Console and IrDA /dev/ttyO2 */
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart3_pins>;
 };
 
+&usbhshost {
+	port2-mode = "ehci-phy";
+};
+
+&usbhsehci {
+	phys = <0 &hsusb2_phy>;
+};
+
 &charger {
 	bb_uvolt = <3200000>;
 	bb_uamp = <150>;
 };
 
-&vaux4 {
-	regulator-min-microvolt = <2800000>;
-	regulator-max-microvolt = <3150000>;
+&venc {
+	status = "ok";
+
+	vdda-supply = <&vdac>;
+
+	port {
+		venc_out: endpoint {
+			remote-endpoint = <&tv_connector_in>;
+			ti,channels = <2>;
+		};
+	};
+};
+
+&gpmc {
+	ranges = <0 0 0x30000000 0x04>;       /* CS0: NAND */
+
+	nand@0,0 {
+		reg = <0 0 0>; /* CS0, offset 0 */
+		nand-bus-width = <16>;
+		ti,nand-ecc-opt = "bch8";
+
+		gpmc,sync-clk-ps = <0>;
+		gpmc,cs-on-ns = <0>;
+		gpmc,cs-rd-off-ns = <44>;
+		gpmc,cs-wr-off-ns = <44>;
+		gpmc,adv-on-ns = <6>;
+		gpmc,adv-rd-off-ns = <34>;
+		gpmc,adv-wr-off-ns = <44>;
+		gpmc,we-off-ns = <40>;
+		gpmc,oe-off-ns = <54>;
+		gpmc,access-ns = <64>;
+		gpmc,rd-cycle-ns = <82>;
+		gpmc,wr-cycle-ns = <82>;
+		gpmc,wr-access-ns = <40>;
+		gpmc,wr-data-mux-bus-ns = <0>;
+		gpmc,device-width = <2>;
+
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		x-loader@0 {
+			label = "X-Loader";
+			reg = <0 0x80000>;
+		};
+
+		bootloaders@80000 {
+			label = "U-Boot";
+			reg = <0x80000 0x1e0000>;
+		};
+
+		bootloaders_env@260000 {
+			label = "U-Boot Env";
+			reg = <0x260000 0x20000>;
+		};
+
+		kernel@280000 {
+			label = "Kernel";
+			reg = <0x280000 0x400000>;
+		};
+
+		filesystem@680000 {
+			label = "File System";
+			reg = <0x680000 0xf980000>;
+		};
+	};
+};
+
+&mcbsp1 {
+	status = "okay";
+};
+
+&mcbsp2 {
+	status = "okay";
+};
+
+&mcbsp3 {
+	status = "okay";
+};
+
+&mcbsp4 {
+	status = "okay";
 };
 
 /* Needed to power the DPI pins */
@@ -335,7 +720,3 @@
 		};
 	};
 };
-
-&twl_madc {
-	ti,system-uses-second-madc-irq;
-};
-- 
1.9.1

