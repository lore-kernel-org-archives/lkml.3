Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab3K1Ouj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:50:39 -0500
Received: from 1.mo6.mail-out.ovh.net ([46.105.56.136]:59037 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758778Ab3K1Ouf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:50:35 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/6] ARM: at91/dt: define sama5d3 clocks
Date: Thu, 28 Nov 2013 15:50:28 +0100
Message-Id: <1385650228-8906-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com>
References: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 6359645625660438707
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define sama5d3 clocks in sama5d3 device tree.
Add references to the appropriate clocks in each peripheral.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/sama5d3.dtsi      |  379 ++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/sama5d3_can.dtsi  |   20 ++
 arch/arm/boot/dts/sama5d3_emac.dtsi |   11 +
 arch/arm/boot/dts/sama5d3_gmac.dtsi |   11 +
 arch/arm/boot/dts/sama5d3_lcd.dtsi  |   17 ++
 arch/arm/boot/dts/sama5d3_mci2.dtsi |   12 ++
 arch/arm/boot/dts/sama5d3_tcb1.dtsi |   12 ++
 arch/arm/boot/dts/sama5d3_uart.dtsi |   21 ++
 8 files changed, 482 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 5cdaba4..f0dbed0 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -13,6 +13,7 @@
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/clk/at91.h>
 
 / {
 	model = "Atmel SAMA5D3 family SoC";
@@ -56,6 +57,14 @@
 		reg = <0x20000000 0x8000000>;
 	};
 
+	clocks {
+		adc_op_clk: adc_op_clk{
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <20000000>;
+		};
+	};
+
 	ahb {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -79,6 +88,8 @@
 				status = "disabled";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&mci0_clk>;
+				clock-names = "mci_clk";
 			};
 
 			spi0: spi@f0004000 {
@@ -92,6 +103,8 @@
 				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&spi0_clk>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -101,6 +114,8 @@
 				interrupts = <38 IRQ_TYPE_LEVEL_HIGH 4>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				clocks = <&ssc0_clk>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -108,6 +123,8 @@
 				compatible = "atmel,at91sam9x5-tcb";
 				reg = <0xf0010000 0x100>;
 				interrupts = <26 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&tcb0_clk>;
+				clock-names = "t0_clk";
 			};
 
 			i2c0: i2c@f0014000 {
@@ -121,6 +138,7 @@
 				pinctrl-0 = <&pinctrl_i2c0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&twi0_clk>;
 				status = "disabled";
 			};
 
@@ -135,6 +153,7 @@
 				pinctrl-0 = <&pinctrl_i2c1>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&twi1_clk>;
 				status = "disabled";
 			};
 
@@ -144,6 +163,8 @@
 				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&usart0_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -153,6 +174,8 @@
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
+				clocks = <&usart1_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -174,6 +197,8 @@
 				status = "disabled";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&mci1_clk>;
+				clock-names = "mci_clk";
 			};
 
 			spi1: spi@f8008000 {
@@ -187,6 +212,8 @@
 				dma-names = "tx", "rx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&spi1_clk>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -196,6 +223,8 @@
 				interrupts = <39 IRQ_TYPE_LEVEL_HIGH 4>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
+				clocks = <&ssc1_clk>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -219,6 +248,9 @@
 					&pinctrl_adc0_ad10
 					&pinctrl_adc0_ad11
 					>;
+				clocks = <&adc_clk>,
+					 <&adc_op_clk>;
+				clock-names = "adc_clk", "adc_op_clk";
 				atmel,adc-channel-base = <0x50>;
 				atmel,adc-channels-used = <0xfff>;
 				atmel,adc-drdy-mask = <0x1000000>;
@@ -274,6 +306,7 @@
 				dma-names = "tx", "rx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&twi2_clk>;
 				status = "disabled";
 			};
 
@@ -283,6 +316,8 @@
 				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
+				clocks = <&usart2_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -292,6 +327,8 @@
 				interrupts = <15 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart3>;
+				clocks = <&usart3_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -318,6 +355,8 @@
 				reg = <0xffffe600 0x200>;
 				interrupts = <30 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&dma0_clk>;
+				clock-names = "dma_clk";
 			};
 
 			dma1: dma-controller@ffffe800 {
@@ -325,6 +364,8 @@
 				reg = <0xffffe800 0x200>;
 				interrupts = <31 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&dma1_clk>;
+				clock-names = "dma_clk";
 			};
 
 			ramc0: ramc@ffffea00 {
@@ -338,6 +379,8 @@
 				interrupts = <2 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&dbgu_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -626,6 +669,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioA_clk>;
 				};
 
 				pioB: gpio@fffff400 {
@@ -636,6 +680,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioB_clk>;
 				};
 
 				pioC: gpio@fffff600 {
@@ -646,6 +691,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioC_clk>;
 				};
 
 				pioD: gpio@fffff800 {
@@ -656,6 +702,7 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioD_clk>;
 				};
 
 				pioE: gpio@fffffa00 {
@@ -666,12 +713,334 @@
 					gpio-controller;
 					interrupt-controller;
 					#interrupt-cells = <2>;
+					clocks = <&pioE_clk>;
 				};
 			};
 
 			pmc: pmc@fffffc00 {
-				compatible = "atmel,at91rm9200-pmc";
+				compatible = "atmel,sama5d3-pmc";
 				reg = <0xfffffc00 0x120>;
+				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupt-controller;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				#interrupt-cells = <1>;
+
+				clk32k: slck {
+					compatible = "fixed-clock";
+					#clock-cells = <0>;
+					clock-frequency = <32768>;
+				};
+
+				main: mainck {
+					compatible = "atmel,at91rm9200-clk-main";
+					#clock-cells = <0>;
+					interrupt-parent = <&pmc>;
+					interrupts = <AT91_PMC_MOSCS>;
+					clocks = <&clk32k>;
+				};
+
+				plla: pllack {
+					compatible = "atmel,sama5d3-clk-pll";
+					#clock-cells = <0>;
+					interrupt-parent = <&pmc>;
+					interrupts = <AT91_PMC_LOCKA>;
+					clocks = <&main>;
+					reg = <0>;
+					atmel,clk-input-range = <8000000 50000000>;
+					#atmel,pll-clk-output-range-cells = <4>;
+					atmel,pll-clk-output-ranges = <400000000 1000000000 0 0>;
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
+					interrupt-parent = <&pmc>;
+					interrupts = <AT91_PMC_LOCKU>;
+					clocks = <&main>;
+				};
+
+				mck: masterck {
+					compatible = "atmel,at91sam9x5-clk-master";
+					#clock-cells = <0>;
+					interrupt-parent = <&pmc>;
+					interrupts = <AT91_PMC_MCKRDY>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>;
+					atmel,clk-output-range = <0 166000000>;
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
+					compatible = "atmel,at91sam9x5-clk-programmable";
+					#address-cells = <1>;
+					#size-cells = <0>;
+					interrupt-parent = <&pmc>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>, <&mck>;
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
+				};
+
+				smd: smdclk {
+					compatible = "atmel,at91sam9x5-clk-smd";
+					#clock-cells = <0>;
+					clocks = <&plladiv>, <&utmi>;
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
+					smdck: smdck {
+						#clock-cells = <0>;
+						reg = <4>;
+						clocks = <&smd>;
+					};
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
+				};
+
+				periphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#address-cells = <1>;
+					#size-cells = <0>;
+					clocks = <&mck>;
+
+					dbgu_clk: dbgu_clk {
+						#clock-cells = <0>;
+						reg = <2>;
+					};
+
+					pioA_clk: pioA_clk {
+						#clock-cells = <0>;
+						reg = <6>;
+					};
+
+					pioB_clk: pioB_clk {
+						#clock-cells = <0>;
+						reg = <7>;
+					};
+
+					pioC_clk: pioC_clk {
+						#clock-cells = <0>;
+						reg = <8>;
+					};
+
+					pioD_clk: pioD_clk {
+						#clock-cells = <0>;
+						reg = <9>;
+					};
+
+					pioE_clk: pioE_clk {
+						#clock-cells = <0>;
+						reg = <10>;
+					};
+
+					usart0_clk: usart0_clk {
+						#clock-cells = <0>;
+						reg = <12>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+
+					usart1_clk: usart1_clk {
+						#clock-cells = <0>;
+						reg = <13>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+
+					usart2_clk: usart2_clk {
+						#clock-cells = <0>;
+						reg = <14>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+
+					usart3_clk: usart3_clk {
+						#clock-cells = <0>;
+						reg = <15>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+
+					twi0_clk: twi0_clk {
+						reg = <18>;
+						#clock-cells = <0>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+
+					twi1_clk: twi1_clk {
+						#clock-cells = <0>;
+						reg = <19>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+
+					twi2_clk: twi2_clk {
+						#clock-cells = <0>;
+						reg = <20>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+
+					mci0_clk: mci0_clk {
+						#clock-cells = <0>;
+						reg = <21>;
+					};
+
+					mci1_clk: mci1_clk {
+						#clock-cells = <0>;
+						reg = <22>;
+					};
+
+					spi0_clk: spi0_clk {
+						#clock-cells = <0>;
+						reg = <24>;
+						atmel,clk-output-range = <0 133000000>;
+					};
+
+					spi1_clk: spi1_clk {
+						#clock-cells = <0>;
+						reg = <25>;
+						atmel,clk-output-range = <0 133000000>;
+					};
+
+					tcb0_clk: tcb0_clk {
+						#clock-cells = <0>;
+						reg = <26>;
+						atmel,clk-output-range = <0 133000000>;
+					};
+
+					pwm_clk: pwm_clk {
+						#clock-cells = <0>;
+						reg = <28>;
+					};
+
+					adc_clk: adc_clk {
+						#clock-cells = <0>;
+						reg = <29>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+
+					dma0_clk: dma0_clk {
+						#clock-cells = <0>;
+						reg = <30>;
+					};
+
+					dma1_clk: dma1_clk {
+						#clock-cells = <0>;
+						reg = <31>;
+					};
+
+					uhphs_clk: uhphs_clk {
+						#clock-cells = <0>;
+						reg = <32>;
+					};
+
+					udphs_clk: udphs_clk {
+						#clock-cells = <0>;
+						reg = <33>;
+					};
+
+					isi_clk: isi_clk {
+						#clock-cells = <0>;
+						reg = <37>;
+					};
+
+					ssc0_clk: ssc0_clk {
+						#clock-cells = <0>;
+						reg = <38>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+
+					ssc1_clk: ssc1_clk {
+						#clock-cells = <0>;
+						reg = <39>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+
+					sha_clk: sha_clk {
+						#clock-cells = <0>;
+						reg = <42>;
+					};
+
+					aes_clk: aes_clk {
+						#clock-cells = <0>;
+						reg = <43>;
+					};
+
+					tdes_clk: tdes_clk {
+						#clock-cells = <0>;
+						reg = <44>;
+					};
+
+					trng_clk: trng_clk {
+						#clock-cells = <0>;
+						reg = <45>;
+					};
+
+					fuse_clk: fuse_clk {
+						#clock-cells = <0>;
+						reg = <48>;
+					};
+				};
 			};
 
 			rstc@fffffe00 {
@@ -683,6 +1052,7 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffe30 0xf>;
 				interrupts = <3 IRQ_TYPE_LEVEL_HIGH 5>;
+				clocks = <&mck>;
 			};
 
 			watchdog@fffffe40 {
@@ -705,6 +1075,8 @@
 			reg = <0x00500000 0x100000
 			       0xf8030000 0x4000>;
 			interrupts = <33 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&udphs_clk>, <&utmi>;
+			clock-names = "pclk", "hclk";
 			status = "disabled";
 
 			ep0 {
@@ -817,6 +1189,9 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00600000 0x100000>;
 			interrupts = <32 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&usb>, <&uhphs_clk>, <&udphs_clk>,
+				 <&uhpck>;
+			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 
@@ -824,6 +1199,8 @@
 			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
 			reg = <0x00700000 0x100000>;
 			interrupts = <32 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&usb>, <&uhphs_clk>, <&uhpck>;
+			clock-names = "usb_clk", "ehci_clk", "uhpck";
 			status = "disabled";
 		};
 
diff --git a/arch/arm/boot/dts/sama5d3_can.dtsi b/arch/arm/boot/dts/sama5d3_can.dtsi
index 8ed3260..a077585 100644
--- a/arch/arm/boot/dts/sama5d3_can.dtsi
+++ b/arch/arm/boot/dts/sama5d3_can.dtsi
@@ -32,12 +32,30 @@
 
 			};
 
+			pmc: pmc@fffffc00 {
+				periphck {
+					can0_clk: can0_clk {
+						#clock-cells = <0>;
+						reg = <40>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+
+					can1_clk: can0_clk {
+						#clock-cells = <0>;
+						reg = <41>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+				};
+			};
+
 			can0: can@f000c000 {
 				compatible = "atmel,at91sam9x5-can";
 				reg = <0xf000c000 0x300>;
 				interrupts = <40 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_can0_rx_tx>;
+				clocks = <&can0_clk>;
+				clock-names = "can_clk";
 				status = "disabled";
 			};
 
@@ -47,6 +65,8 @@
 				interrupts = <41 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_can1_rx_tx>;
+				clocks = <&can1_clk>;
+				clock-names = "can_clk";
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm/boot/dts/sama5d3_emac.dtsi b/arch/arm/boot/dts/sama5d3_emac.dtsi
index 4d4f351..fe2af92 100644
--- a/arch/arm/boot/dts/sama5d3_emac.dtsi
+++ b/arch/arm/boot/dts/sama5d3_emac.dtsi
@@ -31,12 +31,23 @@
 				};
 			};
 
+			pmc: pmc@fffffc00 {
+				periphck {
+					macb1_clk: macb1_clk {
+						#clock-cells = <0>;
+						reg = <35>;
+					};
+				};
+			};
+
 			macb1: ethernet@f802c000 {
 				compatible = "cdns,at32ap7000-macb", "cdns,macb";
 				reg = <0xf802c000 0x100>;
 				interrupts = <35 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb1_rmii>;
+				clocks = <&macb1_clk>, <&macb1_clk>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm/boot/dts/sama5d3_gmac.dtsi b/arch/arm/boot/dts/sama5d3_gmac.dtsi
index 0ba8be3..a6cb050 100644
--- a/arch/arm/boot/dts/sama5d3_gmac.dtsi
+++ b/arch/arm/boot/dts/sama5d3_gmac.dtsi
@@ -64,12 +64,23 @@
 				};
 			};
 
+			pmc: pmc@fffffc00 {
+				periphck {
+					macb0_clk: macb0_clk {
+						#clock-cells = <0>;
+						reg = <34>;
+					};
+				};
+			};
+
 			macb0: ethernet@f0028000 {
 				compatible = "cdns,pc302-gem", "cdns,gem";
 				reg = <0xf0028000 0x100>;
 				interrupts = <34 IRQ_TYPE_LEVEL_HIGH 3>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_macb0_data_rgmii &pinctrl_macb0_signal_rgmii>;
+				clocks = <&macb0_clk>, <&macb0_clk>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm/boot/dts/sama5d3_lcd.dtsi b/arch/arm/boot/dts/sama5d3_lcd.dtsi
index 01f52a7..85d3027 100644
--- a/arch/arm/boot/dts/sama5d3_lcd.dtsi
+++ b/arch/arm/boot/dts/sama5d3_lcd.dtsi
@@ -50,6 +50,23 @@
 					};
 				};
 			};
+
+			pmc: pmc@fffffc00 {
+				periphck {
+					lcdc_clk: lcdc_clk {
+						#clock-cells = <0>;
+						reg = <36>;
+					};
+				};
+
+				systemck {
+					lcdck: lcdck {
+						#clock-cells = <0>;
+						reg = <3>;
+						clocks = <&mck>;
+					};
+				};
+			};
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/sama5d3_mci2.dtsi b/arch/arm/boot/dts/sama5d3_mci2.dtsi
index 38e88e3..b029fe7 100644
--- a/arch/arm/boot/dts/sama5d3_mci2.dtsi
+++ b/arch/arm/boot/dts/sama5d3_mci2.dtsi
@@ -9,6 +9,7 @@
 
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/clk/at91.h>
 
 / {
 	ahb {
@@ -30,6 +31,15 @@
 				};
 			};
 
+			pmc: pmc@fffffc00 {
+				periphck {
+					mci2_clk: mci2_clk {
+						#clock-cells = <0>;
+						reg = <23>;
+					};
+				};
+			};
+
 			mmc2: mmc@f8004000 {
 				compatible = "atmel,hsmci";
 				reg = <0xf8004000 0x600>;
@@ -38,6 +48,8 @@
 				dma-names = "rxtx";
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_mmc2_clk_cmd_dat0 &pinctrl_mmc2_dat1_3>;
+				clocks = <&mci2_clk>;
+				clock-names = "mci_clk";
 				status = "disabled";
 				#address-cells = <1>;
 				#size-cells = <0>;
diff --git a/arch/arm/boot/dts/sama5d3_tcb1.dtsi b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
index 5264bb4..382b044 100644
--- a/arch/arm/boot/dts/sama5d3_tcb1.dtsi
+++ b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
@@ -9,6 +9,7 @@
 
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/clk/at91.h>
 
 / {
 	aliases {
@@ -17,10 +18,21 @@
 
 	ahb {
 		apb {
+			pmc: pmc@fffffc00 {
+				periphck {
+					tcb1_clk: tcb1_clk {
+						#clock-cells = <0>;
+						reg = <27>;
+					};
+				};
+			};
+
 			tcb1: timer@f8014000 {
 				compatible = "atmel,at91sam9x5-tcb";
 				reg = <0xf8014000 0x100>;
 				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&tcb1_clk>;
+				clock-names = "t0_clk";
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/sama5d3_uart.dtsi b/arch/arm/boot/dts/sama5d3_uart.dtsi
index 98fcb2d..49d4d76 100644
--- a/arch/arm/boot/dts/sama5d3_uart.dtsi
+++ b/arch/arm/boot/dts/sama5d3_uart.dtsi
@@ -9,6 +9,7 @@
 
 #include <dt-bindings/pinctrl/at91.h>
 #include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/clk/at91.h>
 
 / {
 	ahb {
@@ -31,12 +32,30 @@
 				};
 			};
 
+			pmc: pmc@fffffc00 {
+				periphck {
+					uart0_clk: uart0_clk {
+						#clock-cells = <0>;
+						reg = <16>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+
+					uart1_clk: uart1_clk {
+						#clock-cells = <0>;
+						reg = <17>;
+						atmel,clk-output-range = <0 66000000>;
+					};
+				};
+			};
+
 			uart0: serial@f0024000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf0024000 0x200>;
 				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart0>;
+				clocks = <&uart0_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -46,6 +65,8 @@
 				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_uart1>;
+				clocks = <&uart1_clk>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 		};
-- 
1.7.9.5

