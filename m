Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaDOLH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:07:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39405 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751068AbaDOLHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:07:48 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/2] ARM: at91/dt: sam9rl: add lcd, adc, usb gadget and pwm support
Date: Tue, 15 Apr 2014 13:07:42 +0200
Message-Id: <1397560063-7439-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397560063-7439-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397560063-7439-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the ADC, LCD, USB gadget and PWM controllers to the
at91sam9rl. It also reorders the pinctrl_spi0 as it was not correctly sorted.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9rl.dtsi | 265 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 256 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index 63e1784d272c..6202e161314a 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -11,6 +11,7 @@
 #include <dt-bindings/clk/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/pwm/pwm.h>
 
 / {
 	model = "Atmel AT91SAM9RL family SoC";
@@ -32,6 +33,7 @@
 		i2c1 = &i2c1;
 		ssc0 = &ssc0;
 		ssc1 = &ssc1;
+		pwm0 = &pwm0;
 	};
 
 	cpus {
@@ -48,12 +50,31 @@
 		reg = <0x20000000 0x04000000>;
 	};
 
+	clocks {
+		adc_op_clk: adc_op_clk{
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <1000000>;
+		};
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges;
 
+		fb0: fb@00500000 {
+			compatible = "atmel,at91sam9rl-lcdc";
+			reg = <0x00500000 0x1000>;
+			interrupts = <23 IRQ_TYPE_LEVEL_HIGH 3>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_fb>;
+			clocks = <&lcd_clk>, <&lcd_clk>;
+			clock-names = "hclk", "lcdc_clk";
+			status = "disabled";
+		};
+
 		nand0: nand@40000000 {
 			compatible = "atmel,at91rm9200-nand";
 			#address-cells = <1>;
@@ -187,6 +208,16 @@
 				status = "disabled";
 			};
 
+			pwm0: pwm@fffc8000 {
+				compatible = "atmel,at91sam9rl-pwm";
+				reg = <0xfffc8000 0x300>;
+				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 4>;
+				#pwm-cells = <3>;
+				clocks = <&pwm_clk>;
+				clock-names = "pwm_clk";
+				status = "disabled";
+			};
+
 			spi0: spi@fffcc000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -200,6 +231,111 @@
 				status = "disabled";
 			};
 
+			adc0: adc@fffd0000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9rl-adc";
+				reg = <0xfffd0000 0x100>;
+				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&adc_clk>, <&adc_op_clk>;
+				clock-names = "adc_clk", "adc_op_clk";
+				atmel,adc-use-external-triggers;
+				atmel,adc-channels-used = <0x3f>;
+				atmel,adc-vref = <3300>;
+				atmel,adc-startup-time = <40>;
+				atmel,adc-res = <8 10>;
+				atmel,adc-res-names = "lowres", "highres";
+				atmel,adc-use-res = "highres";
+
+				trigger@0 {
+					reg = <0>;
+					trigger-name = "timer-counter-0";
+					trigger-value = <0x1>;
+				};
+				trigger@1 {
+					reg = <1>;
+					trigger-name = "timer-counter-1";
+					trigger-value = <0x3>;
+				};
+
+				trigger@2 {
+					reg = <2>;
+					trigger-name = "timer-counter-2";
+					trigger-value = <0x5>;
+				};
+
+				trigger@3 {
+					reg = <3>;
+					trigger-name = "external";
+					trigger-value = <0x13>;
+					trigger-external;
+				};
+			};
+
+			usb0: gadget@fffd4000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "atmel,at91sam9rl-udc";
+				reg = <0x00600000 0x100000>,
+				      <0xfffd4000 0x4000>;
+				interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+				clocks = <&udphs_clk>, <&utmi>;
+				clock-names = "pclk", "hclk";
+				status = "disabled";
+
+				ep0 {
+					reg = <0>;
+					atmel,fifo-size = <64>;
+					atmel,nb-banks = <1>;
+				};
+
+				ep1 {
+					reg = <1>;
+					atmel,fifo-size = <1024>;
+					atmel,nb-banks = <2>;
+					atmel,can-dma;
+					atmel,can-isoc;
+				};
+
+				ep2 {
+					reg = <2>;
+					atmel,fifo-size = <1024>;
+					atmel,nb-banks = <2>;
+					atmel,can-dma;
+					atmel,can-isoc;
+				};
+
+				ep3 {
+					reg = <3>;
+					atmel,fifo-size = <1024>;
+					atmel,nb-banks = <3>;
+					atmel,can-dma;
+				};
+
+				ep4 {
+					reg = <4>;
+					atmel,fifo-size = <1024>;
+					atmel,nb-banks = <3>;
+					atmel,can-dma;
+				};
+
+				ep5 {
+					reg = <5>;
+					atmel,fifo-size = <1024>;
+					atmel,nb-banks = <3>;
+					atmel,can-dma;
+					atmel,can-isoc;
+				};
+
+				ep6 {
+					reg = <6>;
+					atmel,fifo-size = <1024>;
+					atmel,nb-banks = <3>;
+					atmel,can-dma;
+					atmel,can-isoc;
+				};
+			};
+
 			ramc0: ramc@ffffea00 {
 				compatible = "atmel,at91sam9260-sdramc";
 				reg = <0xffffea00 0x200>;
@@ -238,6 +374,44 @@
 					<0x003fffff 0x0001ff3c>;  /* pioD */
 
 				/* shared pinctrl settings */
+				adc0 {
+					pinctrl_adc0_ts: adc0_ts-0 {
+						atmel,pins =
+							<AT91_PIOA 17 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOA 18 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOA 19 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOA 20 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_adc0_ad0: adc0_ad0-0 {
+						atmel,pins = <AT91_PIOA 17 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_adc0_ad1: adc0_ad1-0 {
+						atmel,pins = <AT91_PIOA 18 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_adc0_ad2: adc0_ad2-0 {
+						atmel,pins = <AT91_PIOA 19 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_adc0_ad3: adc0_ad3-0 {
+						atmel,pins = <AT91_PIOA 20 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_adc0_ad4: adc0_ad4-0 {
+						atmel,pins = <AT91_PIOD 6 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_adc0_ad5: adc0_ad5-0 {
+						atmel,pins = <AT91_PIOD 7 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_adc0_adtrg: adc0_adtrg-0 {
+						atmel,pins = <AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+				};
+
 				dbgu {
 					pinctrl_dbgu: dbgu-0 {
 						atmel,pins =
@@ -246,6 +420,33 @@
 					};
 				};
 
+				fb {
+					pinctrl_fb: fb-0 {
+						atmel,pins =
+							<AT91_PIOC 1 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 3 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOC 5 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOC 6 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOC 7 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOC 9 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 10 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 11 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 12 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 13 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 15 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 16 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 17 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 18 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 19 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 20 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 21 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 22 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 23 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 24 AT91_PERIPH_B AT91_PINCTRL_NONE>,
+							<AT91_PIOC 25 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+				};
+
 				i2c_gpio0 {
 					pinctrl_i2c_gpio0: i2c_gpio0-0 {
 						atmel,pins =
@@ -307,6 +508,61 @@
 					};
 				};
 
+				pwm0 {
+					pinctrl_pwm0_pwm0_0: pwm0_pwm0-0 {
+						atmel,pins = <AT91_PIOB 8 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_pwm0_pwm0_1: pwm0_pwm0-1 {
+						atmel,pins = <AT91_PIOC 2 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_pwm0_pwm0_2: pwm0_pwm0-2 {
+						atmel,pins = <AT91_PIOD 14 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_pwm0_pwm1_0: pwm0_pwm1-0 {
+						atmel,pins = <AT91_PIOB 9 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_pwm0_pwm1_1: pwm0_pwm1-1 {
+						atmel,pins = <AT91_PIOC 3 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_pwm0_pwm1_2: pwm0_pwm1-2 {
+						atmel,pins = <AT91_PIOD 15 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_pwm0_pwm2_0: pwm0_pwm2-0 {
+						atmel,pins = <AT91_PIOD 5 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_pwm0_pwm2_1: pwm0_pwm2-1 {
+						atmel,pins = <AT91_PIOD 12 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_pwm0_pwm2_2: pwm0_pwm2-2 {
+						atmel,pins = <AT91_PIOD 16 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_pwm0_pwm3_0: pwm0_pwm3-0 {
+						atmel,pins = <AT91_PIOD 8 AT91_PERIPH_B AT91_PINCTRL_NONE>;
+					};
+
+					pinctrl_pwm0_pwm3_1: pwm0_pwm3-1 {
+						atmel,pins = <AT91_PIOD 18 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+				};
+
+				spi0 {
+					pinctrl_spi0: spi0-0 {
+						atmel,pins =
+							<AT91_PIOA 25 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE>,
+							<AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_NONE>;
+					};
+				};
+
 				ssc0 {
 					pinctrl_ssc0_tx: ssc0_tx-0 {
 						atmel,pins =
@@ -339,15 +595,6 @@
 					};
 				};
 
-				spi0 {
-					pinctrl_spi0: spi0-0 {
-						atmel,pins =
-							<AT91_PIOA 25 AT91_PERIPH_A AT91_PINCTRL_NONE>,
-							<AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE>,
-							<AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_NONE>;
-					};
-				};
-
 				tcb0 {
 					pinctrl_tcb0_tclk0: tcb0_tclk0-0 {
 						atmel,pins = <AT91_PIOA 3 AT91_PERIPH_B AT91_PINCTRL_NONE>;
-- 
1.8.3.2

