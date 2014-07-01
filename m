Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbaGAONv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:13:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35573 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758033AbaGAONs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:13:48 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 05/33] ARM: at91/dt: rm9200: define clocks
Date: Tue,  1 Jul 2014 16:12:14 +0200
Message-Id: <1404223962-30471-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91rm9200.dtsi | 304 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 304 insertions(+)

diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index c61b16fba79b..477cfe570f47 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -14,6 +14,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/clock/at91.h>
 
 / {
 	model = "Atmel AT91RM9200 family SoC";
@@ -51,6 +52,20 @@
 		reg = <0x20000000 0x04000000>;
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
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -79,6 +94,260 @@
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
+					#atmel,pll-clk-output-range-cells = <3>;
+					atmel,pll-clk-output-ranges = <80000000 160000000 0>,
+								<150000000 180000000 2>;
+				};
+
+				pllb: pllbck {
+					compatible = "atmel,at91rm9200-clk-pll";
+					#clock-cells = <0>;
+					interrupts-extended = <&pmc AT91_PMC_LOCKB>;
+					clocks = <&main>;
+					reg = <1>;
+					atmel,clk-input-range = <1000000 32000000>;
+					#atmel,pll-clk-output-range-cells = <3>;
+					atmel,pll-clk-output-ranges = <80000000 160000000 0>,
+								<150000000 180000000 2>;
+				};
+
+				mck: masterck {
+					compatible = "atmel,at91rm9200-clk-master";
+					#clock-cells = <0>;
+					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
+					clocks = <&slow_xtal>, <&main>, <&plla>, <&pllb>;
+					atmel,clk-output-range = <0 80000000>;
+					atmel,clk-divisors = <1 2 3 4>;
+				};
+
+				usb: usbck {
+					compatible = "atmel,at91rm9200-clk-usb";
+					#clock-cells = <0>;
+					atmel,clk-divisors = <1 2>;
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
+					udpck: udpck {
+						#clock-cells = <0>;
+						reg = <2>;
+						clocks = <&usb>;
+					};
+
+					uhpck: uhpck {
+						#clock-cells = <0>;
+						reg = <4>;
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
+					pioC_clk: pioC_clk {
+						#clock-cells = <0>;
+						reg = <4>;
+					};
+
+					pioD_clk: pioD_clk {
+						#clock-cells = <0>;
+						reg = <5>;
+					};
+
+					usart0_clk: usart0_clk {
+						#clock-cells = <0>;
+						reg = <6>;
+					};
+
+					usart1_clk: usart1_clk {
+						#clock-cells = <0>;
+						reg = <7>;
+					};
+
+					usart2_clk: usart2_clk {
+						#clock-cells = <0>;
+						reg = <8>;
+					};
+
+					usart3_clk: usart3_clk {
+						#clock-cells = <0>;
+						reg = <9>;
+					};
+
+					mci0_clk: mci0_clk {
+						#clock-cells = <0>;
+						reg = <10>;
+					};
+
+					udc_clk: udc_clk {
+						#clock-cells = <0>;
+						reg = <11>;
+					};
+
+					twi0_clk: twi0_clk {
+						reg = <12>;
+						#clock-cells = <0>;
+					};
+
+					spi0_clk: spi0_clk {
+						#clock-cells = <0>;
+						reg = <13>;
+					};
+
+					ssc0_clk: ssc0_clk {
+						#clock-cells = <0>;
+						reg = <14>;
+					};
+
+					ssc1_clk: ssc1_clk {
+						#clock-cells = <0>;
+						reg = <15>;
+					};
+
+					ssc2_clk: ssc2_clk {
+						#clock-cells = <0>;
+						reg = <16>;
+					};
+
+					tcb0_clk: tcb0_clk {
+						#clock-cells = <0>;
+						reg = <17>;
+					};
+
+					tcb1_clk: tcb1_clk {
+						#clock-cells = <0>;
+						reg = <18>;
+					};
+
+					tcb2_clk: tcb2_clk {
+						#clock-cells = <0>;
+						reg = <19>;
+					};
+
+					tcb3_clk: tcb3_clk {
+						#clock-cells = <0>;
+						reg = <20>;
+					};
+
+					tcb4_clk: tcb4_clk {
+						#clock-cells = <0>;
+						reg = <21>;
+					};
+
+					tcb5_clk: tcb5_clk {
+						#clock-cells = <0>;
+						reg = <22>;
+					};
+
+					ohci_clk: ohci_clk {
+						#clock-cells = <0>;
+						reg = <23>;
+					};
+
+					macb0_clk: macb0_clk {
+						#clock-cells = <0>;
+						reg = <24>;
+					};
+				};
 			};
 
 			st: timer@fffffd00 {
@@ -93,6 +362,8 @@
 				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0
 					      18 IRQ_TYPE_LEVEL_HIGH 0
 					      19 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&tcb0_clk>, <&tcb1_clk>, <&tcb2_clk>;
+				clock-names = "t0_clk", "t1_clk", "t2_clk";
 			};
 
 			tcb1: timer@fffa4000 {
@@ -101,6 +372,8 @@
 				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0
 					      21 IRQ_TYPE_LEVEL_HIGH 0
 					      22 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&tcb3_clk>, <&tcb4_clk>, <&tcb5_clk>;
+				clock-names = "t0_clk", "t1_clk", "t2_clk";
 			};
 
 			i2c0: i2c@fffb8000 {
@@ -109,6 +382,7 @@
 				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 6>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_twi>;
+				clocks = <&twi0_clk>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 				status = "disabled";
@@ -118,6 +392,8 @@
 				compatible = "atmel,hsmci";
 				reg = <0xfffb4000 0x4000>;
 				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&mci0_clk>;
+				clock-names = "mci_clk";
 				#address-cells = <1>;
 				#size-cells = <0>;
 				pinctrl-names = "default";
@@ -130,6 +406,8 @@
 				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&ssc0_clk>;
+				clock-names = "pclk";
 				status = "disable";
 			};
 
@@ -139,6 +417,8 @@
 				interrupts = <15 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
+				clocks = <&ssc1_clk>;
+				clock-names = "pclk";
 				status = "disable";
 			};
 
@@ -148,6 +428,8 @@
 				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc2_tx &pinctrl_ssc2_rx>;
+				clocks = <&ssc2_clk>;
+				clock-names = "pclk";
 				status = "disable";
 			};
 
@@ -158,6 +440,8 @@
 				phy-mode = "rmii";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb_rmii>;
+				clocks = <&macb0_clk>;
+				clock-names = "ether_clk";
 				status = "disabled";
 			};
 
@@ -496,6 +780,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioA_clk>;
 				};
 
 				pioB: gpio@fffff600 {
@@ -506,6 +791,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioB_clk>;
 				};
 
 				pioC: gpio@fffff800 {
@@ -516,6 +802,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioC_clk>;
 				};
 
 				pioD: gpio@fffffa00 {
@@ -526,6 +813,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioD_clk>;
 				};
 			};
 
@@ -535,6 +823,8 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&mck>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -546,6 +836,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart0>;
+				clocks = <&usart0_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -557,6 +849,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart1>;
+				clocks = <&usart1_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -568,6 +862,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart2>;
+				clocks = <&usart2_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -579,6 +875,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart3>;
+				clocks = <&usart3_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -586,6 +884,8 @@
 				compatible = "atmel,at91rm9200-udc";
 				reg = <0xfffb0000 0x4000>;
 				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 2>;
+				clocks = <&udc_clk>, <&udpck>;
+				clock-names = "pclk", "hclk";
 				status = "disabled";
 			};
 
@@ -597,6 +897,8 @@
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&spi0_clk>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 		};
@@ -622,6 +924,8 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00300000 0x100000>;
 			interrupts = <23 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&usb>, <&ohci_clk>, <&ohci_clk>, <&uhpck>;
+			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 	};
-- 
1.9.1

