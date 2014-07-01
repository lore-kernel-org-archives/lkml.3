Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbaGAOWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:22:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35601 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758098AbaGAOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:14:01 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 09/33] ARM: at91/dt: sam9260: define clocks
Date: Tue,  1 Jul 2014 16:12:18 +0200
Message-Id: <1404223962-30471-10-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the at91sam9260 clocks in the SoC dtsi file.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9260.dtsi | 314 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 313 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index c0e0eae16a27..0aa6679db4ab 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -12,6 +12,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/clock/at91.h>
 
 / {
 	model = "Atmel AT91SAM9260 family SoC";
@@ -48,6 +49,26 @@
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
+
+		adc_op_clk: adc_op_clk{
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <5000000>;
+		};
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -74,8 +95,260 @@
 			};
 
 			pmc: pmc@fffffc00 {
-				compatible = "atmel,at91rm9200-pmc";
+				compatible = "atmel,at91sam9260-pmc";
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
+				slow_rc_osc: slow_rc_osc {
+					compatible = "fixed-clock";
+					#clock-cells = <0>;
+					clock-frequency = <32768>;
+					clock-accuracy = <50000000>;
+				};
+
+				clk32k: slck {
+					compatible = "atmel,at91sam9260-clk-slow";
+					#clock-cells = <0>;
+					clocks = <&slow_rc_osc>, <&slow_xtal>;
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
+					atmel,pll-clk-output-ranges = <80000000 160000000 0 1>,
+								<150000000 240000000 2 1>;
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
+					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
+					atmel,clk-output-range = <0 105000000>;
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
+					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
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
+					adc_clk: adc_clk {
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
+					mci0_clk: mci0_clk {
+						#clock-cells = <0>;
+						reg = <9>;
+					};
+
+					udc_clk: udc_clk {
+						#clock-cells = <0>;
+						reg = <10>;
+					};
+
+					twi0_clk: twi0_clk {
+						reg = <11>;
+						#clock-cells = <0>;
+					};
+
+					spi0_clk: spi0_clk {
+						#clock-cells = <0>;
+						reg = <12>;
+					};
+
+					spi1_clk: spi1_clk {
+						#clock-cells = <0>;
+						reg = <13>;
+					};
+
+					ssc0_clk: ssc0_clk {
+						#clock-cells = <0>;
+						reg = <14>;
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
+					ohci_clk: ohci_clk {
+						#clock-cells = <0>;
+						reg = <20>;
+					};
+
+					macb0_clk: macb0_clk {
+						#clock-cells = <0>;
+						reg = <21>;
+					};
+
+					isi_clk: isi_clk {
+						#clock-cells = <0>;
+						reg = <22>;
+					};
+
+					usart3_clk: usart3_clk {
+						#clock-cells = <0>;
+						reg = <23>;
+					};
+
+					uart0_clk: uart0_clk {
+						#clock-cells = <0>;
+						reg = <24>;
+					};
+
+					uart1_clk: uart1_clk {
+						#clock-cells = <0>;
+						reg = <25>;
+					};
+
+					tcb3_clk: tcb3_clk {
+						#clock-cells = <0>;
+						reg = <26>;
+					};
+
+					tcb4_clk: tcb4_clk {
+						#clock-cells = <0>;
+						reg = <27>;
+					};
+
+					tcb5_clk: tcb5_clk {
+						#clock-cells = <0>;
+						reg = <28>;
+					};
+				};
 			};
 
 			rstc@fffffd00 {
@@ -92,6 +365,7 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&mck>;
 			};
 
 			tcb0: timer@fffa0000 {
@@ -100,6 +374,8 @@
 				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0
 					      18 IRQ_TYPE_LEVEL_HIGH 0
 					      19 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&tcb0_clk>, <&tcb1_clk>, <&tcb2_clk>;
+				clock-names = "t0_clk", "t1_clk", "t2_clk";
 			};
 
 			tcb1: timer@fffdc000 {
@@ -108,6 +384,8 @@
 				interrupts = <26 IRQ_TYPE_LEVEL_HIGH 0
 					      27 IRQ_TYPE_LEVEL_HIGH 0
 					      28 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&tcb3_clk>, <&tcb4_clk>, <&tcb5_clk>;
+				clock-names = "t0_clk", "t1_clk", "t2_clk";
 			};
 
 			pinctrl@fffff400 {
@@ -443,6 +721,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioA_clk>;
 				};
 
 				pioB: gpio@fffff600 {
@@ -453,6 +732,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioB_clk>;
 				};
 
 				pioC: gpio@fffff800 {
@@ -463,6 +743,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioC_clk>;
 				};
 			};
 
@@ -472,6 +753,8 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&mck>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -483,6 +766,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&usart0_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -494,6 +779,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&usart1_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -505,6 +792,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
+				clocks = <&usart2_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -516,6 +805,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart3>;
+				clocks = <&usart3_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -527,6 +818,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart0>;
+				clocks = <&uart0_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -538,6 +831,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart1>;
+				clocks = <&uart1_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -547,6 +842,8 @@
 				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb_rmii>;
+				clocks = <&macb0_clk>, <&macb0_clk>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 			};
 
@@ -554,6 +851,8 @@
 				compatible = "atmel,at91rm9200-udc";
 				reg = <0xfffa4000 0x4000>;
 				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 2>;
+				clocks = <&udc_clk>, <&udpck>;
+				clock-names = "pclk", "hclk";
 				status = "disabled";
 			};
 
@@ -563,6 +862,7 @@
 				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&twi0_clk>;
 				status = "disabled";
 			};
 
@@ -573,6 +873,8 @@
 				#address-cells = <1>;
 				#size-cells = <0>;
 				pinctrl-names = "default";
+				clocks = <&mci0_clk>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -582,6 +884,8 @@
 				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&ssc0_clk>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -593,6 +897,8 @@
 				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&spi0_clk>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -604,6 +910,8 @@
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&spi1_clk>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -613,6 +921,8 @@
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xfffe0000 0x100>;
 				interrupts = <5 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&adc_clk>, <&adc_op_clk>;
+				clock-names = "adc_clk", "adc_op_clk";
 				atmel,adc-use-external-triggers;
 				atmel,adc-channels-used = <0xf>;
 				atmel,adc-vref = <3300>;
@@ -680,6 +990,8 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00500000 0x100000>;
 			interrupts = <20 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&usb>, <&ohci_clk>, <&ohci_clk>, <&uhpck>;
+			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 	};
-- 
1.9.1

