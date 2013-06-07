Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3FGSMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:12:32 -0400
Received: from 18.mo1.mail-out.ovh.net ([46.105.35.72]:41203 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755813Ab3FGSMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:12:31 -0400
X-Greylist: delayed 22322 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2013 14:12:31 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 38/50] ARM: at91/dt: move at91sam9263 SoC to new at91 clk implem
Date: Fri,  7 Jun 2013 20:12:28 +0200
Message-Id: <1370628748-2840-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 2531304467311065116
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

Define at91sam9263 clocks in at91sam9263 device tree.
Add references to the appropriate clocks in each peripheral.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9263.dtsi |  135 ++++++++++++++++++++++++++++++++++++
 1 file changed, 135 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index ff63811..f948575 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -64,6 +64,106 @@
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
+					output = <80000000 200000000
+						  190000000 240000000>;
+					out = <0 2>;
+				};
+
+				pllb: pllbck {
+					compatible = "atmel,at91rm9200-clk-pll";
+					#clock-cells = <0>;
+					clocks = <&main>;
+					id = <1>;
+					input = <1000000 32000000>;
+					output = <80000000 200000000
+						  190000000 240000000>;
+					out = <0 2>;
+				};
+
+				mck: masterck {
+					compatible = "atmel,at91rm9200-clk-master";
+					#clock-cells = <0>;
+					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
+					output = <0 120000000>;
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
+					ids = <0 1 2 3>;
+					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
+					clock-output-names = "prog0", "prog1", "prog2", "prog3";
+				};
+
+				system: systemck {
+					compatible = "atmel,at91rm9200-clk-system";
+					#clock-cells = <1>;
+					ids = <6 7 8 9 10 11>;
+					clocks = <&usb>, <&usb>, <&prog 0>, <&prog 1>, <&prog 2>,
+							 <&prog 3>;
+					clock-output-names = "udpck", "uhpck", "pck0", "pck1",
+										 "pck2", "pck3";
+				};
+
+				periph: periphck {
+					compatible = "atmel,at91rm9200-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <2 3 4 7 8 9 10 11 12 13 14 15 16
+					       17 18 19 20 21 23 24 25 26 27 29>;
+					clock-output-names = "pioA_clk",
+							     "pioB_clk",
+							     "pioCDE_clk",
+							     "usart0_clk",
+							     "usart1_clk",
+							     "usart2_clk",
+							     "mci0_clk",
+							     "mci1_clk",
+							     "can_clk",
+							     "twi_clk",
+							     "spi0_clk",
+							     "spi1_clk",
+							     "ssc0_clk",
+							     "ssc1_clk",
+							     "ac97_clk",
+							     "tcb_clk",
+							     "pwm_clk",
+							     "pclk",
+							     "2dge_clk",
+							     "udc_clk",
+							     "isi_clk",
+							     "lcdc_clk",
+							     "dma_clk",
+							     "ohci_clk";
+
+				};
 			};
 
 			ramc: ramc@ffffe200 {
@@ -76,12 +176,15 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&mck>;
 			};
 
 			tcb0: timer@fff7c000 {
 				compatible = "atmel,at91rm9200-tcb";
 				reg = <0xfff7c000 0x100>;
 				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 19>;
+				clock-names = "t0_clk";
 			};
 
 			rstc@fffffd00 {
@@ -370,6 +473,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 2>;
 				};
 
 				pioB: gpio@fffff400 {
@@ -380,6 +484,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 3>;
 				};
 
 				pioC: gpio@fffff600 {
@@ -390,6 +495,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 4>;
 				};
 
 				pioD: gpio@fffff800 {
@@ -400,6 +506,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 4>;
 				};
 
 				pioE: gpio@fffffa00 {
@@ -410,6 +517,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 4>;
 				};
 			};
 
@@ -419,6 +527,8 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&mck>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -430,6 +540,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&periph 7>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -441,6 +553,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&periph 8>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -452,6 +566,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
+				clocks = <&periph 9>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -461,6 +577,8 @@
 				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&periph 16>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -470,6 +588,8 @@
 				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
+				clocks = <&periph 17>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -479,6 +599,8 @@
 				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb_rmii>;
+				clocks = <&periph 21>, <&periph 21>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 			};
 
@@ -486,6 +608,8 @@
 				compatible = "atmel,at91rm9200-udc";
 				reg = <0xfff78000 0x4000>;
 				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 2>;
+				clocks = <&periph 24>, <&system 7>;
+				clock-names = "udc_clk", "udpck";
 				status = "disabled";
 			};
 
@@ -495,6 +619,7 @@
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 13>;
 				status = "disabled";
 			};
 
@@ -504,6 +629,8 @@
 				interrupts = <10 IRQ_TYPE_LEVEL_HIGH 0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 10>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -513,6 +640,8 @@
 				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 11>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -530,6 +659,8 @@
 				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&periph 14>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -541,6 +672,8 @@
 				interrupts = <15 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&periph 15>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 		};
@@ -567,6 +700,8 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00a00000 0x100000>;
 			interrupts = <29 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&periph 29>, <&periph 29>, <&system 6>;
+			clock-names = "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 	};
-- 
1.7.9.5

