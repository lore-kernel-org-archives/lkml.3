Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaLYKsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 05:48:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36402 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaLYKsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 05:48:04 -0500
Date: Thu, 25 Dec 2014 11:48:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Nishanth Menon <nm@ti.com>, linux-omap <linux-omap@vger.kernel.org>,
        sre@debian.org, sre@ring0.de, aaro.koskinen@iki.fi, tony@atomide.com,
        ivo.g.dimitrov.75@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: v3.19-rc1 regression(?) on N900
Message-ID: <20141225104759.GA3515@amd>
References: <549B44E2.6080202@ti.com>
 <201412250932.40403@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412250932.40403@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-12-25 09:32:40, Pali Rohár wrote:
> On Wednesday 24 December 2014 23:57:38 Nishanth Menon wrote:
> > based on automated testing with u-boot as a chained
> > bootloader..
> > 
> > v3.18: boots fine:
> > https://github.com/nmenon/kernel-test-logs/blob/v3.18/omap2plu
> > s_defconfig/n900.txt
> > 
> > v3.19-rc1: hung
> > https://github.com/nmenon/kernel-test-logs/blob/v3.19-rc1/omap
> > 2plus_defconfig/n900.txt
> > 
> > in the interim, my farm had a bit of breakdown around the time
> > of n900 breakdown..
> > 
> > as per my last functional linux-next logs:
> > https://github.com/nmenon/kernel-test-logs/blob/next-20141204/
> > omap2plus_defconfig/n900.txt -> hung.
> > https://github.com/nmenon/kernel-test-logs/blob/next-20141112/
> > omap2plus_defconfig/n900.txt -> working.
> > 
> > DEBUG_LL, CONFIG_DEBUG_OMAP3UART3=y and early_printk did not
> > yield information either
> > 
> > Note: I am using the combined uImage+dtb image.[2]
> > 
> > I think this might just be my setup..(i use chained loader ->
> > NOLO->u-boot->serial download->kernel) but anyways.. Since
> > Pali thought others might be interested in sharing
> > experience...
> > 
> > [1]   http://slexy.org/raw/s2osxhhwbR
> > [2]
> > https://github.com/nmenon/linux-2.6-playground/commit/177f5f71
> > b3f21ea484ee4b09a2e0c015de522417
> 
> CCing other people.
> 
> I see same problem in qemu with 3.19-rc1 kernel when doing DT 
> boot. In qemu I'm using direct booting from OneNAND (X-Loader --> 
> NOLO --> kernel) without U-Boot. After NOLO load & boot kernel I 
> do not see any other output from serial console. Also on qemu 
> screen there is no new output (just NOKIA logo from bootloader).
> 
> I do not have this problem when doing legacy/board code boot with 
> 3.19-rc1 kernel, so this problem is related to DT.
> 
> Kernel 3.18-rc1 worked fine for both DT and legacy boot.
> 
> Can somebody look what broke DT booting?

You should be able to apply this to get it back to boot.

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 53f3ca0..7c17d084 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -13,9 +13,16 @@
 #include <dt-bindings/input/input.h>
 
 / {
-	model = "Nokia N900";
+	model = "Nokia RX-51 board";
 	compatible = "nokia,omap3-n900", "ti,omap3430", "ti,omap3";
 
+	aliases {
+		i2c0;
+		i2c1 = &i2c1;
+		i2c2 = &i2c2;
+		i2c3 = &i2c3;
+	};
+
 	cpus {
 		cpu@0 {
 			cpu0-supply = <&vcc>;
@@ -26,7 +33,7 @@
 		compatible = "gpio-leds";
 		heartbeat {
 			label = "debug::sleep";
-			gpios = <&gpio6 2 GPIO_ACTIVE_HIGH>;  /* gpio162 */
+			gpios = <&gpio6 2 GPIO_ACTIVE_HIGH>;  /* 162 */
 			linux,default-trigger = "default-on";
 			pinctrl-names = "default";
 			pinctrl-0 = <&debug_leds>;
@@ -140,14 +147,6 @@
 		>;
 	};
 
-	ethernet_pins: pinmux_ethernet_pins {
-		pinctrl-single,pins = <
-			OMAP3_CORE1_IOPAD(0x20b4, PIN_INPUT_PULLDOWN | MUX_MODE4)	/* gpmc_ncs3.gpio_54 */
-			OMAP3_CORE1_IOPAD(0x20fc, PIN_OUTPUT | MUX_MODE4)		/* dss_data16.gpio_86 */
-			OMAP3_CORE1_IOPAD(0x219c, PIN_OUTPUT | MUX_MODE4)		/* uart3_rts_sd.gpio_164 */
-		>;
-	};
-
 	gpmc_pins: pinmux_gpmc_pins {
 		pinctrl-single,pins = <
 
@@ -307,7 +306,7 @@
 	regulator-name = "V28";
 	regulator-min-microvolt = <2800000>;
 	regulator-max-microvolt = <2800000>;
-	regulator-always-on; /* due battery cover sensor */
+	regulator-always-on; /* due to battery cover sensor */
 };
 
 &vaux2 {
@@ -365,7 +364,6 @@
 	regulator-name = "VIO";
 	regulator-min-microvolt = <1800000>;
 	regulator-max-microvolt = <1800000>;
-
 };
 
 &vintana1 {
@@ -504,30 +502,6 @@
 		clock-mode = /bits/ 8 <0>; /* LP55XX_CLOCK_AUTO */
 		enable-gpio = <&gpio2 9 GPIO_ACTIVE_HIGH>; /* 41 */
 
-		chan0 {
-			chan-name = "lp5523:kb1";
-			led-cur = /bits/ 8 <50>;
-			max-cur = /bits/ 8 <100>;
-		};
-
-		chan1 {
-			chan-name = "lp5523:kb2";
-			led-cur = /bits/ 8 <50>;
-			max-cur = /bits/ 8 <100>;
-		};
-
-		chan2 {
-			chan-name = "lp5523:kb3";
-			led-cur = /bits/ 8 <50>;
-			max-cur = /bits/ 8 <100>;
-		};
-
-		chan3 {
-			chan-name = "lp5523:kb4";
-			led-cur = /bits/ 8 <50>;
-			max-cur = /bits/ 8 <100>;
-		};
-
 		chan4 {
 			chan-name = "lp5523:b";
 			led-cur = /bits/ 8 <50>;
@@ -545,18 +519,6 @@
 			led-cur = /bits/ 8 <50>;
 			max-cur = /bits/ 8 <100>;
 		};
-
-		chan7 {
-			chan-name = "lp5523:kb5";
-			led-cur = /bits/ 8 <50>;
-			max-cur = /bits/ 8 <100>;
-		};
-
-		chan8 {
-			chan-name = "lp5523:kb6";
-			led-cur = /bits/ 8 <50>;
-			max-cur = /bits/ 8 <100>;
-		};
 	};
 
 	bq27200: bq27200@55 {
@@ -564,6 +526,7 @@
 		reg = <0x55>;
 	};
 
+	/* Stereo headphone amplifier */
 	tpa6130a2: tpa6130a2@60 {
 		compatible = "ti,tpa6130a2";
 		reg = <0x60>;
@@ -596,6 +559,22 @@
 
 		ti,usb-charger-detection = <&isp1704>;
 	};
+
+	adp1653: led-controller@30 {
+		compatible = "adi,adp1653";
+		reg = <0x30>;
+		gpios = <&gpio3 24 GPIO_ACTIVE_HIGH>; /* 88 */
+
+		flash {
+			flash-timeout-microsec = <500000>;
+			flash-max-microamp = <320000>;
+			max-microamp = <50000>;
+		};
+
+		indicator {
+			max-microamp = <17500>;
+		};
+	};
 };
 
 &i2c3 {
@@ -603,6 +582,18 @@
 	pinctrl-0 = <&i2c3_pins>;
 
 	clock-frequency = <400000>;
+
+	/* bus 3, same as ad5820, et8ek8 */
+	/* bus 2, adp1653, smiapp */
+	ad5820: ad5820@c {
+		compatible = "adi,ad5820";
+		reg = <0x0c>;
+	};
+
+	et8ek8: et8ek8@3e {
+		compatible = "et,et8ek8";
+		reg = <0x3e>;
+	};
 };
 
 &mmc1 {
@@ -699,43 +690,6 @@
 			reg = <0x004c0000 0x0fb40000>;
 		};
 	};
-
-	ethernet@gpmc {
-		compatible = "smsc,lan91c94";
-
-		status = "disabled";
-
-		interrupt-parent = <&gpio2>;
-		interrupts = <22 IRQ_TYPE_LEVEL_HIGH>;	/* gpio54 */
-		reg = <1 0x300 0xf>;		/* 16 byte IO range at offset 0x300 */
-		bank-width = <2>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&ethernet_pins>;
-		power-gpios = <&gpio3 22 GPIO_ACTIVE_HIGH>;	/* gpio86 */
-		reset-gpios = <&gpio6 4 GPIO_ACTIVE_HIGH>;	/* gpio164 */
-		gpmc,device-width = <2>;
-		gpmc,sync-clk-ps = <0>;
-		gpmc,cs-on-ns = <0>;
-		gpmc,cs-rd-off-ns = <48>;
-		gpmc,cs-wr-off-ns = <24>;
-		gpmc,adv-on-ns = <0>;
-		gpmc,adv-rd-off-ns = <0>;
-		gpmc,adv-wr-off-ns = <0>;
-		gpmc,we-on-ns = <12>;
-		gpmc,we-off-ns = <18>;
-		gpmc,oe-on-ns = <12>;
-		gpmc,oe-off-ns = <48>;
-		gpmc,page-burst-access-ns = <0>;
-		gpmc,access-ns = <42>;
-		gpmc,rd-cycle-ns = <180>;
-		gpmc,wr-cycle-ns = <180>;
-		gpmc,bus-turnaround-ns = <0>;
-		gpmc,cycle2cycle-delay-ns = <0>;
-		gpmc,wait-monitoring-ns = <0>;
-		gpmc,clk-activation-ns = <0>;
-		gpmc,wr-access-ns = <0>;
-		gpmc,wr-data-mux-bus-ns = <12>;
-	};
 };
 
 &mcspi1 {
@@ -823,9 +777,21 @@
 };
 
 &uart2 {
+        compatible = "brcm,uart,bcm2048";
 	interrupts-extended = <&intc 73 &omap3_pmx_core OMAP3_UART2_RX>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart2_pins>;
+
+	clocks = <&uart2_fck>, <&uart2_ick>;
+	clock-names = "fck", "ick";
+
+	device {
+		  compatible = "brcm,bcm2048";
+		  reset-gpios = <&gpio3 27 GPIO_ACTIVE_HIGH>; /* 91 */
+		  host-wakeup-gpios = <&gpio4 5 GPIO_ACTIVE_HIGH>; /* 101 */
+		  bluetooth-wakeup-gpios = <&gpio2 5 GPIO_ACTIVE_HIGH>; /* 37 */
+		  bt-sysclk = <2>;
+	};
 };
 
 &uart3 {



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
