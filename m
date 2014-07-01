Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbaGAOOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:14:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35672 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932430AbaGAOO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:14:29 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 23/33] ARM: at91/dt: sam9g45: define clocks
Date: Tue,  1 Jul 2014 16:12:32 +0200
Message-Id: <1404223962-30471-24-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the at91sam9g45 clocks in the SoC dtsi file.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi | 340 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 339 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index ace6bf197b70..c76a60a2e239 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -14,6 +14,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/clock/at91.h>
 
 / {
 	model = "Atmel AT91SAM9G45 family SoC";
@@ -53,6 +54,26 @@
 		reg = <0x70000000 0x10000000>;
 	};
 
+	clocks {
+		slow_xtal: slow_xtal {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+		};
+
+		main_xtal: main_xtal {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+		};
+
+		adc_op_clk: adc_op_clk{
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <300000>;
+		};
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -80,8 +101,274 @@
 			};
 
 			pmc: pmc@fffffc00 {
-				compatible = "atmel,at91rm9200-pmc";
+				compatible = "atmel,at91sam9g45-pmc";
 				reg = <0xfffffc00 0x100>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupt-controller;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				#interrupt-cells = <1>;
+
+				main_osc: main_osc {
+					compatible = "atmel,at91rm9200-clk-main-osc";
+					#clock-cells = <0>;
+					interrupts-extended = <&pmc AT91_PMC_MOSCS>;
+					clocks = <&main_xtal>;
+				};
+
+				main: mainck {
+					compatible = "atmel,at91rm9200-clk-main";
+					#clock-cells = <0>;
+					clocks = <&main_osc>;
+				};
+
+				plla: pllack {
+					compatible = "atmel,at91rm9200-clk-pll";
+					#clock-cells = <0>;
+					interrupts-extended = <&pmc AT91_PMC_LOCKA>;
+					clocks = <&main>;
+					reg = <0>;
+					atmel,clk-input-range = <2000000 32000000>;
+					#atmel,pll-clk-output-range-cells = <4>;
+					atmel,pll-clk-output-ranges = <745000000 800000000 0 0
+								       695000000 750000000 1 0
+								       645000000 700000000 2 0
+								       595000000 650000000 3 0
+								       545000000 600000000 0 1
+								       495000000 555000000 1 1
+								       445000000 500000000 2 1
+								       400000000 450000000 3 1>;
+				};
+
+				plladiv: plladivck {
+					compatible = "atmel,at91sam9x5-clk-plldiv";
+					#clock-cells = <0>;
+					clocks = <&plla>;
+				};
+
+				utmi: utmick {
+					compatible = "atmel,at91sam9x5-clk-utmi";
+					#clock-cells = <0>;
+					interrupts-extended = <&pmc AT91_PMC_LOCKU>;
+					clocks = <&main>;
+				};
+
+				mck: masterck {
+					compatible = "atmel,at91rm9200-clk-master";
+					#clock-cells = <0>;
+					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
+					clocks = <&slow_xtal>, <&main>, <&plladiv>, <&utmi>;
+					atmel,clk-output-range = <0 133333333>;
+					atmel,clk-divisors = <1 2 4 3>;
+				};
+
+				usb: usbck {
+					compatible = "atmel,at91sam9x5-clk-usb";
+					#clock-cells = <0>;
+					clocks = <&plladiv>, <&utmi>;
+				};
+
+				prog: progck {
+					compatible = "atmel,at91sam9g45-clk-programmable";
+					#address-cells = <1>;
+					#size-cells = <0>;
+					interrupt-parent = <&pmc>;
+					clocks = <&slow_xtal>, <&main>, <&plladiv>, <&utmi>, <&mck>;
+
+					prog0: prog0 {
+						#clock-cells = <0>;
+						reg = <0>;
+						interrupts = <AT91_PMC_PCKRDY(0)>;
+					};
+
+					prog1: prog1 {
+						#clock-cells = <0>;
+						reg = <1>;
+						interrupts = <AT91_PMC_PCKRDY(1)>;
+					};
+				};
+
+				systemck {
+					compatible = "atmel,at91rm9200-clk-system";
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					ddrck: ddrck {
+						#clock-cells = <0>;
+						reg = <2>;
+						clocks = <&mck>;
+					};
+
+					uhpck: uhpck {
+						#clock-cells = <0>;
+						reg = <6>;
+						clocks = <&usb>;
+					};
+
+					pck0: pck0 {
+						#clock-cells = <0>;
+						reg = <8>;
+						clocks = <&prog0>;
+					};
+
+					pck1: pck1 {
+						#clock-cells = <0>;
+						reg = <9>;
+						clocks = <&prog1>;
+					};
+				};
+
+				periphck {
+					compatible = "atmel,at91rm9200-clk-peripheral";
+					#address-cells = <1>;
+					#size-cells = <0>;
+					clocks = <&mck>;
+
+					pioA_clk: pioA_clk {
+						#clock-cells = <0>;
+						reg = <2>;
+					};
+
+					pioB_clk: pioB_clk {
+						#clock-cells = <0>;
+						reg = <3>;
+					};
+
+					pioC_clk: pioC_clk {
+						#clock-cells = <0>;
+						reg = <4>;
+					};
+
+					pioDE_clk: pioDE_clk {
+						#clock-cells = <0>;
+						reg = <5>;
+					};
+
+					trng_clk: trng_clk {
+						#clock-cells = <0>;
+						reg = <6>;
+					};
+
+					usart0_clk: usart0_clk {
+						#clock-cells = <0>;
+						reg = <7>;
+					};
+
+					usart1_clk: usart1_clk {
+						#clock-cells = <0>;
+						reg = <8>;
+					};
+
+					usart2_clk: usart2_clk {
+						#clock-cells = <0>;
+						reg = <9>;
+					};
+
+					usart3_clk: usart3_clk {
+						#clock-cells = <0>;
+						reg = <10>;
+					};
+
+					mci0_clk: mci0_clk {
+						#clock-cells = <0>;
+						reg = <11>;
+					};
+
+					twi0_clk: twi0_clk {
+						#clock-cells = <0>;
+						reg = <12>;
+					};
+
+					twi1_clk: twi1_clk {
+						#clock-cells = <0>;
+						reg = <13>;
+					};
+
+					spi0_clk: spi0_clk {
+						#clock-cells = <0>;
+						reg = <14>;
+					};
+
+					spi1_clk: spi1_clk {
+						#clock-cells = <0>;
+						reg = <15>;
+					};
+
+					ssc0_clk: ssc0_clk {
+						#clock-cells = <0>;
+						reg = <16>;
+					};
+
+					ssc1_clk: ssc1_clk {
+						#clock-cells = <0>;
+						reg = <17>;
+					};
+
+					tcb0_clk: tcb0_clk {
+						#clock-cells = <0>;
+						reg = <18>;
+					};
+
+					pwm_clk: pwm_clk {
+						#clock-cells = <0>;
+						reg = <19>;
+					};
+
+					adc_clk: adc_clk {
+						#clock-cells = <0>;
+						reg = <20>;
+					};
+
+					dma0_clk: dma0_clk {
+						#clock-cells = <0>;
+						reg = <21>;
+					};
+
+					uhphs_clk: uhphs_clk {
+						#clock-cells = <0>;
+						reg = <22>;
+					};
+
+					lcd_clk: lcd_clk {
+						#clock-cells = <0>;
+						reg = <23>;
+					};
+
+					ac97_clk: ac97_clk {
+						#clock-cells = <0>;
+						reg = <24>;
+					};
+
+					macb0_clk: macb0_clk {
+						#clock-cells = <0>;
+						reg = <25>;
+					};
+
+					isi_clk: isi_clk {
+						#clock-cells = <0>;
+						reg = <26>;
+					};
+
+					udphs_clk: udphs_clk {
+						#clock-cells = <0>;
+						reg = <27>;
+					};
+
+					aestdessha_clk: aestdessha_clk {
+						#clock-cells = <0>;
+						reg = <28>;
+					};
+
+					mci1_clk: mci1_clk {
+						#clock-cells = <0>;
+						reg = <29>;
+					};
+
+					vdec_clk: vdec_clk {
+						#clock-cells = <0>;
+						reg = <30>;
+					};
+				};
 			};
 
 			rstc@fffffd00 {
@@ -93,6 +380,7 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&mck>;
 			};
 
 
@@ -105,12 +393,16 @@
 				compatible = "atmel,at91rm9200-tcb";
 				reg = <0xfff7c000 0x100>;
 				interrupts = <18 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&tcb0_clk>, <&tcb0_clk>, <&tcb0_clk>;
+				clock-names = "t0_clk", "t1_clk", "t2_clk";
 			};
 
 			tcb1: timer@fffd4000 {
 				compatible = "atmel,at91rm9200-tcb";
 				reg = <0xfffd4000 0x100>;
 				interrupts = <18 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&tcb0_clk>, <&tcb0_clk>, <&tcb0_clk>;
+				clock-names = "t0_clk", "t1_clk", "t2_clk";
 			};
 
 			dma: dma-controller@ffffec00 {
@@ -118,6 +410,8 @@
 				reg = <0xffffec00 0x200>;
 				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&dma0_clk>;
+				clock-names = "dma_clk";
 			};
 
 			pinctrl@fffff200 {
@@ -516,6 +810,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioA_clk>;
 				};
 
 				pioB: gpio@fffff400 {
@@ -526,6 +821,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioB_clk>;
 				};
 
 				pioC: gpio@fffff600 {
@@ -536,6 +832,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioC_clk>;
 				};
 
 				pioD: gpio@fffff800 {
@@ -546,6 +843,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioDE_clk>;
 				};
 
 				pioE: gpio@fffffa00 {
@@ -556,6 +854,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioDE_clk>;
 				};
 			};
 
@@ -565,6 +864,8 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&mck>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -576,6 +877,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&usart0_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -587,6 +890,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&usart1_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -598,6 +903,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
+				clocks = <&usart2_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -609,6 +916,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart3>;
+				clocks = <&usart3_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -618,6 +927,8 @@
 				interrupts = <25 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb_rmii>;
+				clocks = <&macb0_clk>, <&macb0_clk>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 			};
 
@@ -629,6 +940,7 @@
 				pinctrl-0 = <&pinctrl_i2c0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&twi0_clk>;
 				status = "disabled";
 			};
 
@@ -640,6 +952,7 @@
 				pinctrl-0 = <&pinctrl_i2c1>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&twi1_clk>;
 				status = "disabled";
 			};
 
@@ -649,6 +962,8 @@
 				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&ssc0_clk>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -658,6 +973,8 @@
 				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
+				clocks = <&ssc1_clk>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -667,6 +984,8 @@
 				compatible = "atmel,at91sam9g45-adc";
 				reg = <0xfffb0000 0x100>;
 				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&adc_clk>, <&adc_op_clk>;
+				clock-names = "adc_clk", "adc_op_clk";
 				atmel,adc-channels-used = <0xff>;
 				atmel,adc-vref = <3300>;
 				atmel,adc-startup-time = <40>;
@@ -706,6 +1025,7 @@
 				reg = <0xfffb8000 0x300>;
 				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 4>;
 				#pwm-cells = <3>;
+				clocks = <&pwm_clk>;
 				status = "disabled";
 			};
 
@@ -718,6 +1038,8 @@
 				dma-names = "rxtx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&mci0_clk>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -730,6 +1052,8 @@
 				dma-names = "rxtx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&mci1_clk>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -752,6 +1076,8 @@
 				interrupts = <14 4 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&spi0_clk>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -763,6 +1089,8 @@
 				interrupts = <15 4 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&spi1_clk>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -773,6 +1101,8 @@
 				reg = <0x00600000 0x80000
 				       0xfff78000 0x400>;
 				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&udphs_clk>, <&utmi>;
+				clock-names = "pclk", "hclk";
 				status = "disabled";
 
 				ep0 {
@@ -835,6 +1165,8 @@
 			interrupts = <23 IRQ_TYPE_LEVEL_HIGH 3>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_fb>;
+			clocks = <&lcd_clk>, <&lcd_clk>;
+			clock-names = "hclk", "lcdc_clk";
 			status = "disabled";
 		};
 
@@ -861,6 +1193,9 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00700000 0x100000>;
 			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			//TODO
+			clocks = <&usb>, <&uhphs_clk>, <&uhphs_clk>, <&uhpck>;
+			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 
@@ -868,6 +1203,9 @@
 			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
 			reg = <0x00800000 0x100000>;
 			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			//TODO
+			clocks = <&usb>, <&uhphs_clk>, <&uhphs_clk>, <&uhpck>;
+			clock-names = "usb_clk", "ehci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 	};
-- 
1.9.1

