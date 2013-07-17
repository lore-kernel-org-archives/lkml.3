Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3GQPyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:54:18 -0400
Received: from 8.mo1.mail-out.ovh.net ([178.33.110.239]:54090 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754263Ab3GQPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:54:17 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bo Shen <voice.shen@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 29/42] ARM: at91/dt: move at91sam9260 SoC to new at91 clk implem
Date: Wed, 17 Jul 2013 17:53:57 +0200
Message-Id: <1374076437-20418-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 13690098443674941548
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define at91sam9260 clocks in at91sam9260 device tree.
Add references to the appropriate clocks in each peripheral.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9260.dtsi |  236 ++++++++++++++++++++++++++++++++++++
 1 file changed, 236 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index c7ccbcb..24b0165 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -48,6 +48,14 @@
 		reg = <0x20000000 0x04000000>;
 	};
 
+	clocks {
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
@@ -76,6 +84,195 @@
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
+					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
+
+					prog0@0 {
+						id = <0>;
+					};
+
+					prog1@1 {
+						id = <1>;
+					};
+				};
+
+				system: systemck {
+					compatible = "atmel,at91rm9200-clk-system";
+					#clock-cells = <1>;
+
+					udpck@6 {
+						id = <6>;
+					};
+
+					uhpck@7 {
+						id = <7>;
+					};
+
+					pck0@8 {
+						id = <8>;
+					};
+
+					pck1@9 {
+						id = <9>;
+					};
+				};
+
+				periph: periphck {
+					compatible = "atmel,at91rm9200-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+
+					pioA_clk@2 {
+						id = <2>;
+					};
+
+					pioB_clk@3 {
+						id = <3>;
+					};
+
+					pioC_clk@4 {
+						id = <4>;
+					};
+
+					adc_clk@5 {
+						id = <5>;
+					};
+
+					usart0_clk@6 {
+						id = <6>;
+					};
+
+					usart1_clk@7 {
+						id = <7>;
+					};
+
+					usart2_clk@8 {
+						id = <8>;
+					};
+
+					mci_clk@9 {
+						id = <9>;
+					};
+
+					udc_clk@10 {
+						id = <10>;
+					};
+
+					twi_clk@11 {
+						id = <11>;
+					};
+
+					spi0_clk@12 {
+						id = <12>;
+					};
+
+					spi1_clk@13 {
+						id = <13>;
+					};
+
+					ssc_clk@14 {
+						id = <14>;
+					};
+
+					tc0_clk@17 {
+						id = <17>;
+					};
+
+					tc1_clk@18 {
+						id = <18>;
+					};
+
+					tc2_clk@19 {
+						id = <19>;
+					};
+
+					ohci_clk@20 {
+						id = <20>;
+					};
+
+					pclk@21 {
+						id = <21>;
+					};
+
+					isi_clk@22 {
+						id = <22>;
+					};
+
+					usart3@23 {
+						id = <23>;
+					};
+
+					usart4@24 {
+						id = <24>;
+					};
+
+					usart5@25 {
+						id = <25>;
+					};
+
+					tc3_clk@26 {
+						id = <26>;
+					};
+
+					tc4_clk@27 {
+						id = <27>;
+					};
+
+					tc5_clk@28 {
+						id = <28>;
+					};
+				};
 			};
 
 			rstc@fffffd00 {
@@ -92,6 +289,7 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&mck>;
 			};
 
 			tcb0: timer@fffa0000 {
@@ -100,6 +298,8 @@
 				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0
 					      18 IRQ_TYPE_LEVEL_HIGH 0
 					      19 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 17>, <&periph 18>, <&periph 19>;
+				clock-names = "t0_clk", "t1_clk", "t2_clk";
 			};
 
 			tcb1: timer@fffdc000 {
@@ -108,6 +308,8 @@
 				interrupts = <26 IRQ_TYPE_LEVEL_HIGH 0
 					      27 IRQ_TYPE_LEVEL_HIGH 0
 					      28 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 26>, <&periph 27>, <&periph 28>;
+				clock-names = "t0_clk", "t1_clk", "t2_clk";
 			};
 
 			pinctrl@fffff400 {
@@ -443,6 +645,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 2>;
 				};
 
 				pioB: gpio@fffff600 {
@@ -453,6 +656,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 3>;
 				};
 
 				pioC: gpio@fffff800 {
@@ -463,6 +667,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 4>;
 				};
 			};
 
@@ -472,6 +677,8 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&mck>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -483,6 +690,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&periph 6>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -494,6 +703,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&periph 7>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -505,6 +716,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
+				clocks = <&periph 8>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -516,6 +729,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart3>;
+				clocks = <&periph 23>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -527,6 +742,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart0>;
+				clocks = <&periph 24>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -538,6 +755,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart1>;
+				clocks = <&periph 25>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -547,6 +766,8 @@
 				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb_rmii>;
+				clocks = <&periph 21>, <&periph 21>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 			};
 
@@ -554,6 +775,8 @@
 				compatible = "atmel,at91rm9200-udc";
 				reg = <0xfffa4000 0x4000>;
 				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 2>;
+				clocks = <&periph 10>, <&system 6>;
+				clock-names = "udc_clk", "udpck";
 				status = "disabled";
 			};
 
@@ -563,6 +786,7 @@
 				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 11>;
 				status = "disabled";
 			};
 
@@ -572,6 +796,8 @@
 				interrupts = <9 IRQ_TYPE_LEVEL_HIGH 0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 9>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -581,6 +807,8 @@
 				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&periph 14>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -592,6 +820,8 @@
 				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&periph 12>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -603,6 +833,8 @@
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&periph 13>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -610,6 +842,8 @@
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xfffe0000 0x100>;
 				interrupts = <5 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 5>, <&adc_op_clk>;
+				clock-names = "adc_clk", "adc_op_clk";
 				atmel,adc-use-external-triggers;
 				atmel,adc-channels-used = <0xf>;
 				atmel,adc-vref = <3300>;
@@ -673,6 +907,8 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00500000 0x100000>;
 			interrupts = <20 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&usb>, <&periph 20>, <&periph 20>, <&system 7>;
+			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 	};
-- 
1.7.9.5

