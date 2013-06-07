Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3FGUDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 16:03:50 -0400
Received: from 10.mo1.mail-out.ovh.net ([178.32.96.102]:47596 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753181Ab3FGUDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 16:03:48 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 37/50] ARM: at91/dt: move at91sam9260 SoC to new at91 clk implem
Date: Fri,  7 Jun 2013 22:03:43 +0200
Message-Id: <1370635423-4325-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 4410149936040278044
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define at91sam9260 clocks in at91sam9260 device tree.
Add references to the appropriate clocks in each peripheral.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9260.dtsi |  144 +++++++++++++++++++++++++++++++++++-
 1 file changed, 143 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 899a7cf..eac42f9 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -72,6 +72,109 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91rm9200-pmc";
 				reg = <0xfffffc00 0x100>;
+
+				clk32k: slck {
+					compatible = "fixed-clock";
+					#clock-cells = <0>;
+					clock-frequency = <32768>;
+				};
+
+				main: mainck {
+					compatible = "atmel,at91rm9200-clk-main", "fixed-clock";
+					#clock-cells = <0>;
+					clocks = <&clk32k>;
+				};
+
+				plla: pllack {
+					compatible = "atmel,at91rm9200-clk-pll";
+					#clock-cells = <0>;
+					clocks = <&main>;
+					id = <0>;
+					input = <1000000 32000000>;
+					output = <80000000 160000000
+						  150000000 240000000>;
+					out = <0 2>;
+				};
+
+				pllb: pllbck {
+					compatible = "atmel,at91rm9200-clk-pll";
+					#clock-cells = <0>;
+					clocks = <&main>;
+					id = <1>;
+					input = <1000000 5000000>;
+					output = <70000000 130000000>;
+					out = <1>;
+				};
+
+				mck: masterck {
+					compatible = "atmel,at91rm9200-clk-master";
+					#clock-cells = <0>;
+					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
+					output = <0 105000000>;
+					divisors = <1 2 4 0>;
+				};
+
+				usb: usbck {
+					compatible = "atmel,at91rm9200-clk-usb";
+					#clock-cells = <0>;
+					clocks = <&pllb>;
+					divisors = <1 2 4 0>;
+				};
+
+				prog: progck {
+					compatible = "atmel,at91rm9200-clk-programmable";
+					#clock-cells = <1>;
+					ids = <0 1>;
+					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
+					clock-output-names = "prog0", "prog1";
+				};
+
+				system: systemck {
+					compatible = "atmel,at91rm9200-clk-system";
+					#clock-cells = <1>;
+					ids = <6 7 8 9>;
+					clocks = <&usb>, <&usb>, <&prog 0>, <&prog 1>;
+					clock-output-names = "udpck", "uhpck", "pck0", "pck1";
+				};
+
+				periph: periphck {
+					compatible = "atmel,at91rm9200-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <2 3 4 5 6 7 8 9 10 11 12 13 14 17
+					       18 19 20 21 22 23 24 25 26 27 28>;
+					clock-output-names = "pioA_clk",
+							     "pioB_clk",
+							     "pioC_clk",
+							     "adc_clk",
+							     "usart0_clk",
+							     "usart1_clk",
+							     "usart2_clk",
+							     "mci_clk",
+							     "udc_clk",
+							     "twi_clk",
+							     "spi0_clk",
+							     "spi1_clk",
+							     "ssc_clk",
+							     "tc0_clk",
+							     "tc1_clk",
+							     "tc2_clk",
+							     "ohci_clk",
+							     "pclk",
+							     "isi_clk",
+							     "usart3_clk",
+							     "usart4_clk",
+							     "usart5_clk",
+							     "tc3_clk",
+							     "tc4_clk",
+							     "tc5_clk";
+
+					adc_op_clk: adc_op_clk{
+						compatible = "fixed-clock";
+						#clock-cells = <0>;
+						clock-frequency = <5000000>;
+					};
+				};
 			};
 
 			rstc@fffffd00 {
@@ -88,6 +191,7 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&mck>;
 			};
 
 			tcb0: timer@fffa0000 {
@@ -96,6 +200,8 @@
 				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0
 					      18 IRQ_TYPE_LEVEL_HIGH 0
 					      19 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 17>, <&periph 18>, <&periph 19>;
+				clock-names = "t0_clk", "t1_clk", "t2_clk";
 			};
 
 			tcb1: timer@fffdc000 {
@@ -104,6 +210,8 @@
 				interrupts = <26 IRQ_TYPE_LEVEL_HIGH 0
 					      27 IRQ_TYPE_LEVEL_HIGH 0
 					      28 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 26>, <&periph 27>, <&periph 28>;
+				clock-names = "t0_clk", "t1_clk", "t2_clk";
 			};
 
 			pinctrl@fffff400 {
@@ -271,7 +379,7 @@
 						atmel,pins =
 							<AT91_PIOA 10 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PA10 periph B */
 							 AT91_PIOA 11 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PA11 periph B */
-							 AT91_PIOA 24 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PA24 periph B */
+							 AT91_PIOA 22 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PA22 periph B */
 							 AT91_PIOA 25 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PA25 periph B */
 							 AT91_PIOA 26 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PA26 periph B */
 							 AT91_PIOA 27 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PA27 periph B */
@@ -439,6 +547,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 2>;
 				};
 
 				pioB: gpio@fffff600 {
@@ -449,6 +558,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 3>;
 				};
 
 				pioC: gpio@fffff800 {
@@ -459,6 +569,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 4>;
 				};
 			};
 
@@ -468,6 +579,8 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&mck>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -479,6 +592,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&periph 6>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -490,6 +605,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&periph 7>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -501,6 +618,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
+				clocks = <&periph 8>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -512,6 +631,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart3>;
+				clocks = <&periph 23>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -523,6 +644,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart0>;
+				clocks = <&periph 24>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -534,6 +657,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart1>;
+				clocks = <&periph 25>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -543,6 +668,8 @@
 				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb_rmii>;
+				clocks = <&periph 21>, <&periph 21>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 			};
 
@@ -550,6 +677,8 @@
 				compatible = "atmel,at91rm9200-udc";
 				reg = <0xfffa4000 0x4000>;
 				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 2>;
+				clocks = <&periph 10>, <&system 6>;
+				clock-names = "udc_clk", "udpck";
 				status = "disabled";
 			};
 
@@ -559,6 +688,7 @@
 				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 11>;
 				status = "disabled";
 			};
 
@@ -568,6 +698,8 @@
 				interrupts = <9 IRQ_TYPE_LEVEL_HIGH 0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 9>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -577,6 +709,8 @@
 				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&periph 14>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -588,6 +722,8 @@
 				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&periph 12>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -599,6 +735,8 @@
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&periph 13>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -606,6 +744,8 @@
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xfffe0000 0x100>;
 				interrupts = <5 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 5>, <&adc_op_clk>;
+				clock-names = "adc_clk", "adc_op_clk";
 				atmel,adc-use-external-triggers;
 				atmel,adc-channels-used = <0xf>;
 				atmel,adc-vref = <3300>;
@@ -669,6 +809,8 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00500000 0x100000>;
 			interrupts = <20 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&periph 20>, <&periph 20>, <&system 7>;
+			clock-names = "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 	};
-- 
1.7.9.5

