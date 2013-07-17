Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab3GQQAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:00:54 -0400
Received: from 9.mo1.mail-out.ovh.net ([178.32.108.172]:59297 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756174Ab3GQQAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:00:52 -0400
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
Subject: [PATCH v2 31/42] ARM: at91/dt: move at91sam9g45 SoC to new at91 clk implem
Date: Wed, 17 Jul 2013 18:00:33 +0200
Message-Id: <1374076833-20540-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 13801562533801261164
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define at91sam9g45 clocks in at91sam9g45 device tree.
Add references to the appropriate clocks in each peripheral.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi |  257 ++++++++++++++++++++++++++++++++++++
 1 file changed, 257 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index c3e5148..dfca115 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -52,6 +52,14 @@
 		reg = <0x70000000 0x10000000>;
 	};
 
+	clocks {
+		adc_op_clk: adc_op_clk{
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <13200000>;
+		};
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -81,6 +89,211 @@
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
+					compatible = "atmel,at91sam9g45-clk-pll";
+					#clock-cells = <0>;
+					clocks = <&main>;
+					id = <0>;
+					input = <2000000 32000000>;
+					output = <74500000 800000000
+						  69500000 750000000
+						  64500000 700000000
+						  59500000 650000000
+						  54500000 600000000
+						  49500000 550000000
+						  44500000 500000000
+						  40000000 450000000>;
+					out = <0 1 2 3 0 1 2 3>;
+					icpll = <0 0 0 0 1 1 1 1>;
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
+					clocks = <&main>;
+				};
+
+				mck: masterck {
+					compatible = "atmel,at91rm9200-clk-master";
+					#clock-cells = <0>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>;
+					output = <0 133000000>;
+					divisors = <1 2 4 3>;
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
+					#clock-cells = <1>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>, <&mck>;
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
+					ddrck@2 {
+						id = <2>;
+					};
+
+					uhpck@6 {
+						id = <6>;
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
+					pioDE_clk@5 {
+						id = <5>;
+					};
+
+					trng_clk@6 {
+						id = <6>;
+					};
+
+					usart0_clk@7 {
+						id = <7>;
+					};
+
+					usart1_clk@8 {
+						id = <8>;
+					};
+
+					usart2_clk@9 {
+						id = <9>;
+					};
+
+					usart3_clk@10 {
+						id = <10>;
+					};
+
+					mci0_clk@11 {
+						id = <11>;
+					};
+
+					twi0_clk@12 {
+						id = <12>;
+					};
+
+					twi1_clk@13 {
+						id = <13>;
+					};
+
+					spi0_clk@14 {
+						id = <14>;
+					};
+
+					spi1_clk@15 {
+						id = <15>;
+					};
+
+					ssc0_clk@16 {
+						id = <16>;
+					};
+
+					ssc1_clk@17 {
+						id = <17>;
+					};
+
+					tcb0_clk@18 {
+						id = <18>;
+					};
+
+					pwm_clk@19 {
+						id = <19>;
+					};
+
+					tsc_clk@20 {
+						id = <20>;
+					};
+
+					dma_clk@21 {
+						id = <21>;
+					};
+
+					uhphs_clk@22 {
+						id = <22>;
+					};
+
+					lcdc_clk@23 {
+						id = <23>;
+					};
+
+					ac97_clk@24 {
+						id = <24>;
+					};
+
+					pclk@25 {
+						id = <25>;
+					};
+
+					isi_clk@26 {
+						id = <26>;
+					};
+
+					udphs_clk@27 {
+						id = <27>;
+					};
+
+					mci1_clk@29 {
+						id = <29>;
+					};
+				};
 			};
 
 			rstc@fffffd00 {
@@ -92,6 +305,7 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				clocks = <&mck>;
 			};
 
 
@@ -104,12 +318,16 @@
 				compatible = "atmel,at91rm9200-tcb";
 				reg = <0xfff7c000 0x100>;
 				interrupts = <18 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 18>;
+				clock-names = "t0_clk";
 			};
 
 			tcb1: timer@fffd4000 {
 				compatible = "atmel,at91rm9200-tcb";
 				reg = <0xfffd4000 0x100>;
 				interrupts = <18 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 18>;
+				clock-names = "t0_clk";
 			};
 
 			dma: dma-controller@ffffec00 {
@@ -117,6 +335,8 @@
 				reg = <0xffffec00 0x200>;
 				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&periph 21>;
+				clock-names = "dma_clk";
 			};
 
 			pinctrl@fffff200 {
@@ -433,6 +653,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 2>;
 				};
 
 				pioB: gpio@fffff400 {
@@ -443,6 +664,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 3>;
 				};
 
 				pioC: gpio@fffff600 {
@@ -453,6 +675,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 4>;
 				};
 
 				pioD: gpio@fffff800 {
@@ -463,6 +686,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 5>;
 				};
 
 				pioE: gpio@fffffa00 {
@@ -473,6 +697,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&periph 5>;
 				};
 			};
 
@@ -482,6 +707,8 @@
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&mck>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -493,6 +720,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&periph 7>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -504,6 +733,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&periph 8>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -515,6 +746,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
+				clocks = <&periph 9>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -526,6 +759,8 @@
 				atmel,use-dma-tx;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart3>;
+				clocks = <&periph 10>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -535,6 +770,8 @@
 				interrupts = <25 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb_rmii>;
+				clocks = <&periph 25>, <&periph 25>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 			};
 
@@ -544,6 +781,7 @@
 				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 12>;
 				status = "disabled";
 			};
 
@@ -553,6 +791,7 @@
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 6>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 13>;
 				status = "disabled";
 			};
 
@@ -562,6 +801,8 @@
 				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&periph 16>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -571,6 +812,8 @@
 				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
+				clocks = <&periph 17>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -578,6 +821,8 @@
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xfffb0000 0x100>;
 				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 20>, <&adc_op_clk>;
+				clock-names = "adc_clk", "adc_op_clk";
 				atmel,adc-use-external-triggers;
 				atmel,adc-channels-used = <0xff>;
 				atmel,adc-vref = <3300>;
@@ -622,6 +867,8 @@
 				dma-names = "rxtx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 29>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -633,6 +880,8 @@
 				dma-names = "rxtx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 29>;
+				clock-names = "mci_clk";
 				status = "disabled";
 			};
 
@@ -650,6 +899,8 @@
 				interrupts = <14 4 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&periph 14>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -661,6 +912,8 @@
 				interrupts = <15 4 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&periph 15>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -749,6 +1002,8 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00700000 0x100000>;
 			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&usb>, <&periph 22>, <&periph 22>, <&system 6>;
+			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 
@@ -756,6 +1011,8 @@
 			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
 			reg = <0x00800000 0x100000>;
 			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&periph 22>, <&system 6>;
+			clock-names = "ehci_clk", "uhpck";
 			status = "disabled";
 		};
 	};
-- 
1.7.9.5

