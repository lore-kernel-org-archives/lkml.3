Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbaGAOOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:14:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35703 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932430AbaGAOOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:14:48 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 29/33] ARM: at91/dt: sam9263: define clocks
Date: Tue,  1 Jul 2014 16:12:38 +0200
Message-Id: <1404223962-30471-30-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the at91sam9263 clocks in the SoC dtsi file.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9263.dtsi | 311 +++++++++++++++++++++++++++++++++++++
 1 file changed, 311 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index fece8665fb63..88a03f453d9d 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -10,6 +10,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/clock/at91.h>
 
 / {
 	model = "Atmel AT91SAM9263 family SoC";
@@ -32,6 +33,7 @@
 		ssc1 = &ssc1;
 		pwm0 = &pwm0;
 	};
+
 	cpus {
 		#address-cells = <0>;
 		#size-cells = <0>;
@@ -46,6 +48,20 @@
 		reg = <0x20000000 0x08000000>;
 	};
 
+	clocks {
+		main_xtal: main_xtal {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+		};
+
+		slow_xtal: slow_xtal {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+		};
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -69,6 +85,264 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91rm9200-pmc";
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
+					atmel,clk-input-range = <1000000 32000000>;
+					#atmel,pll-clk-output-range-cells = <4>;
+					atmel,pll-clk-output-ranges = <80000000 200000000 0 1>,
+								<190000000 240000000 2 1>;
+				};
+
+				pllb: pllbck {
+					compatible = "atmel,at91rm9200-clk-pll";
+					#clock-cells = <0>;
+					interrupts-extended = <&pmc AT91_PMC_LOCKB>;
+					clocks = <&main>;
+					reg = <1>;
+					atmel,clk-input-range = <1000000 5000000>;
+					#atmel,pll-clk-output-range-cells = <4>;
+					atmel,pll-clk-output-ranges = <70000000 130000000 1 1>;
+				};
+
+				mck: masterck {
+					compatible = "atmel,at91rm9200-clk-master";
+					#clock-cells = <0>;
+					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
+					clocks = <&slow_xtal>, <&main>, <&plla>, <&pllb>;
+					atmel,clk-output-range = <0 120000000>;
+					atmel,clk-divisors = <1 2 4 0>;
+				};
+
+				usb: usbck {
+					compatible = "atmel,at91rm9200-clk-usb";
+					#clock-cells = <0>;
+					atmel,clk-divisors = <1 2 4 0>;
+					clocks = <&pllb>;
+				};
+
+				prog: progck {
+					compatible = "atmel,at91rm9200-clk-programmable";
+					#address-cells = <1>;
+					#size-cells = <0>;
+					interrupt-parent = <&pmc>;
+					clocks = <&slow_xtal>, <&main>, <&plla>, <&pllb>;
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
+
+					prog2: prog2 {
+						#clock-cells = <0>;
+						reg = <2>;
+						interrupts = <AT91_PMC_PCKRDY(2)>;
+					};
+
+					prog3: prog3 {
+						#clock-cells = <0>;
+						reg = <3>;
+						interrupts = <AT91_PMC_PCKRDY(3)>;
+					};
+				};
+
+				systemck {
+					compatible = "atmel,at91rm9200-clk-system";
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					uhpck: uhpck {
+						#clock-cells = <0>;
+						reg = <6>;
+						clocks = <&usb>;
+					};
+
+					udpck: udpck {
+						#clock-cells = <0>;
+						reg = <7>;
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
+
+					pck2: pck2 {
+						#clock-cells = <0>;
+						reg = <10>;
+						clocks = <&prog2>;
+					};
+
+					pck3: pck3 {
+						#clock-cells = <0>;
+						reg = <11>;
+						clocks = <&prog3>;
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
+					pioCDE_clk: pioCDE_clk {
+						#clock-cells = <0>;
+						reg = <4>;
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
+					mci0_clk: mci0_clk {
+						#clock-cells = <0>;
+						reg = <10>;
+					};
+
+					mci1_clk: mci1_clk {
+						#clock-cells = <0>;
+						reg = <11>;
+					};
+
+					can_clk: can_clk {
+						#clock-cells = <0>;
+						reg = <12>;
+					};
+
+					twi0_clk: twi0_clk {
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
+					ac91_clk: ac97_clk {
+						#clock-cells = <0>;
+						reg = <18>;
+					};
+
+					tc0_clk: tc0_clk {
+						#clock-cells = <0>;
+						reg = <19>;
+					};
+
+					pwm_clk: pwm_clk {
+						#clock-cells = <0>;
+						reg = <20>;
+					};
+
+					macb0_clk: macb0_clk {
+						#clock-cells = <0>;
+						reg = <21>;
+					};
+
+					g2de_clk: g2de_clk {
+						#clock-cells = <0>;
+						reg = <23>;
+					};
+
+					udc_clk: udc_clk {
+						#clock-cells = <0>;
+						reg = <24>;
+					};
+
+					isi_clk: isi_clk {
+						#clock-cells = <0>;
+						reg = <25>;
+					};
+
+					lcd_clk: lcd_clk {
+						#clock-cells = <0>;
+						reg = <26>;
+					};
+
+					dma_clk: dma_clk {
+						#clock-cells = <0>;
+						reg = <27>;
+					};
+
+					ohci_clk: ohci_clk {
+						#clock-cells = <0>;
+						reg = <29>;
+					};
+				};
 			};
 
 			ramc: ramc@ffffe200 {
@@ -81,12 +355,15 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&mck>;
 			};
 
 			tcb0: timer@fff7c000 {
 				compatible = "atmel,at91rm9200-tcb";
 				reg = <0xfff7c000 0x100>;
 				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&tc0_clk>;
+				clock-names = "t0_clk";
 			};
 
 			rstc@fffffd00 {
@@ -403,6 +680,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioA_clk>;
 				};
 
 				pioB: gpio@fffff400 {
@@ -413,6 +691,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioB_clk>;
 				};
 
 				pioC: gpio@fffff600 {
@@ -423,6 +702,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioCDE_clk>;
 				};
 
 				pioD: gpio@fffff800 {
@@ -433,6 +713,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioCDE_clk>;
 				};
 
 				pioE: gpio@fffffa00 {
@@ -443,6 +724,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioCDE_clk>;
 				};
 			};
 
@@ -452,6 +734,8 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&mck>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -463,6 +747,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&usart0_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -474,6 +760,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&usart1_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -485,6 +773,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
+				clocks = <&usart2_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -494,6 +784,8 @@
 				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&ssc0_clk>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -503,6 +795,8 @@
 				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
+				clocks = <&ssc1_clk>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -512,6 +806,8 @@
 				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb_rmii>;
+				clocks = <&macb0_clk>, <&macb0_clk>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 			};
 
@@ -519,6 +815,8 @@
 				compatible = "atmel,at91rm9200-udc";
 				reg = <0xfff78000 0x4000>;
 				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 2>;
+				clocks = <&udc_clk>, <&udpck>;
+				clock-names = "pclk", "hclk";
 				status = "disabled";
 			};
 
@@ -528,6 +826,7 @@
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&twi0_clk>;
 				status = "disabled";
 			};
 
@@ -537,6 +836,8 @@
 				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&mci0_clk>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -546,6 +847,8 @@
 				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&mci1_clk>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -568,6 +871,8 @@
 				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&spi0_clk>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -579,6 +884,8 @@
 				interrupts = <15 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&spi1_clk>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -587,6 +894,8 @@
 				reg = <0xfffb8000 0x300>;
 				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 4>;
 				#pwm-cells = <3>;
+				clocks = <&pwm_clk>;
+				clock-names = "pwm_clk";
 				status = "disabled";
 			};
 		};
@@ -622,6 +931,8 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00a00000 0x100000>;
 			interrupts = <29 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&usb>, <&ohci_clk>, <&ohci_clk>, <&uhpck>;
+			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 	};
-- 
1.9.1

