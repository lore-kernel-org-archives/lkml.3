Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab3FGSOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:14:22 -0400
Received: from 14.mo1.mail-out.ovh.net ([178.32.97.215]:38237 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756928Ab3FGSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:14:19 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 43/50] ARM: at91/dt: move sama5d3 SoCs to new at91 clk implem
Date: Fri,  7 Jun 2013 20:14:11 +0200
Message-Id: <1370628853-3057-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 2560859340028540956
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

Define sama5d3 clocks in sama5d3 device tree.
Add references to the appropriate clocks in each peripheral.
Split optional sam9x5 peripherals in several device tree files. These
files are included by each SoC according to it's availability.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/sama5d3.dtsi      |  358 +++++++++++++++--------------------
 arch/arm/boot/dts/sama5d3_can.dtsi  |   67 +++++++
 arch/arm/boot/dts/sama5d3_emac.dtsi |   56 ++++++
 arch/arm/boot/dts/sama5d3_gmac.dtsi |   89 +++++++++
 arch/arm/boot/dts/sama5d3_lcd.dtsi  |   73 +++++++
 arch/arm/boot/dts/sama5d3_mci2.dtsi |   59 ++++++
 arch/arm/boot/dts/sama5d3_tcb1.dtsi |   39 ++++
 arch/arm/boot/dts/sama5d3_uart.dtsi |   42 ++++
 8 files changed, 580 insertions(+), 203 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index c00e158..fded941 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -30,7 +30,6 @@
 		gpio3 = &pioD;
 		gpio4 = &pioE;
 		tcb0 = &tcb0;
-		tcb1 = &tcb1;
 		i2c0 = &i2c0;
 		i2c1 = &i2c1;
 		i2c2 = &i2c2;
@@ -70,6 +69,8 @@
 				status = "disabled";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 21>;
+				clock-names = "mci_clk";
 			};
 
 			spi0: spi@f0004000 {
@@ -85,6 +86,8 @@
 					   >;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi0>;
+				clocks = <&periph 24>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -94,15 +97,8 @@
 				interrupts = <38 IRQ_TYPE_LEVEL_HIGH 4>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
-				status = "disabled";
-			};
-
-			can0: can@f000c000 {
-				compatible = "atmel,at91sam9x5-can";
-				reg = <0xf000c000 0x300>;
-				interrupts = <40 IRQ_TYPE_LEVEL_HIGH 3>;
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_can0_rx_tx>;
+				clocks = <&periph 38>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
@@ -110,6 +106,8 @@
 				compatible = "atmel,at91sam9x5-tcb";
 				reg = <0xf0010000 0x100>;
 				interrupts = <26 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&periph 26>;
+				clock-names = "t0_clk";
 			};
 
 			i2c0: i2c@f0014000 {
@@ -123,6 +121,7 @@
 				pinctrl-0 = <&pinctrl_i2c0>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 18>;
 				status = "disabled";
 			};
 
@@ -137,6 +136,7 @@
 				pinctrl-0 = <&pinctrl_i2c1>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 19>;
 				status = "disabled";
 			};
 
@@ -146,6 +146,8 @@
 				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart0>;
+				clocks = <&periph 12>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -155,15 +157,8 @@
 				interrupts = <13 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart1>;
-				status = "disabled";
-			};
-
-			macb0: ethernet@f0028000 {
-				compatible = "cnds,pc302-gem", "cdns,gem";
-				reg = <0xf0028000 0x100>;
-				interrupts = <34 IRQ_TYPE_LEVEL_HIGH 3>;
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_macb0_data_rgmii &pinctrl_macb0_signal_rgmii>;
+				clocks = <&periph 13>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -187,19 +182,6 @@
 				#size-cells = <0>;
 			};
 
-			mmc2: mmc@f8004000 {
-				compatible = "atmel,hsmci";
-				reg = <0xf8004000 0x600>;
-				interrupts = <23 IRQ_TYPE_LEVEL_HIGH 0>;
-				dmas = <&dma1 2 1>;
-				dma-names = "rxtx";
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_mmc2_clk_cmd_dat0 &pinctrl_mmc2_dat1_3>;
-				status = "disabled";
-				#address-cells = <1>;
-				#size-cells = <0>;
-			};
-
 			spi1: spi@f8008000 {
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -213,6 +195,8 @@
 					   >;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_spi1>;
+				clocks = <&periph 25>;
+				clock-names = "spi_clk";
 				status = "disabled";
 			};
 
@@ -222,23 +206,11 @@
 				interrupts = <39 IRQ_TYPE_LEVEL_HIGH 4>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
+				clocks = <&periph 39>;
+				clock-names = "pclk";
 				status = "disabled";
 			};
 
-			can1: can@f8010000 {
-				compatible = "atmel,at91sam9x5-can";
-				reg = <0xf8010000 0x300>;
-				interrupts = <41 IRQ_TYPE_LEVEL_HIGH 3>;
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_can1_rx_tx>;
-			};
-
-			tcb1: timer@f8014000 {
-				compatible = "atmel,at91sam9x5-tcb";
-				reg = <0xf8014000 0x100>;
-				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 0>;
-			};
-
 			adc0: adc@f8018000 {
 				compatible = "atmel,at91sam9260-adc";
 				reg = <0xf8018000 0x100>;
@@ -259,6 +231,8 @@
 					&pinctrl_adc0_ad10
 					&pinctrl_adc0_ad11
 					>;
+				clocks = <&periph 29>, <&adc_op_clk>;
+				clock-names = "adc_clk", "adc_op_clk";
 				atmel,adc-channel-base = <0x50>;
 				atmel,adc-channels-used = <0xfff>;
 				atmel,adc-drdy-mask = <0x1000000>;
@@ -314,6 +288,7 @@
 				dma-names = "tx", "rx";
 				#address-cells = <1>;
 				#size-cells = <0>;
+				clocks = <&periph 20>;
 				status = "disabled";
 			};
 
@@ -323,6 +298,8 @@
 				interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart2>;
+				clocks = <&periph 14>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -332,15 +309,8 @@
 				interrupts = <15 IRQ_TYPE_LEVEL_HIGH 5>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_usart3>;
-				status = "disabled";
-			};
-
-			macb1: ethernet@f802c000 {
-				compatible = "cdns,at32ap7000-macb", "cdns,macb";
-				reg = <0xf802c000 0x100>;
-				interrupts = <35 IRQ_TYPE_LEVEL_HIGH 3>;
-				pinctrl-names = "default";
-				pinctrl-0 = <&pinctrl_macb1_rmii>;
+				clocks = <&periph 15>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -367,6 +337,8 @@
 				reg = <0xffffe600 0x200>;
 				interrupts = <30 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&periph 30>;
+				clock-names = "dma_clk";
 			};
 
 			dma1: dma-controller@ffffe800 {
@@ -374,6 +346,8 @@
 				reg = <0xffffe800 0x200>;
 				interrupts = <31 IRQ_TYPE_LEVEL_HIGH 0>;
 				#dma-cells = <2>;
+				clocks = <&periph 31>;
+				clock-names = "dma_clk";
 			};
 
 			ramc0: ramc@ffffea00 {
@@ -387,6 +361,8 @@
 				interrupts = <2 IRQ_TYPE_LEVEL_HIGH 7>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
+				clocks = <&periph 2>;
+				clock-names = "usart";
 				status = "disabled";
 			};
 
@@ -468,22 +444,6 @@
 					};
 				};
 
-				can0 {
-					pinctrl_can0_rx_tx: can0_rx_tx {
-						atmel,pins =
-							<AT91_PIOD 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PD14 periph C RX, conflicts with SCK0, SPI0_NPCS1 */
-							 AT91_PIOD 15 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PD15 periph C TX, conflicts with CTS0, SPI0_NPCS2 */
-					};
-				};
-
-				can1 {
-					pinctrl_can1_rx_tx: can1_rx_tx {
-						atmel,pins =
-							<AT91_PIOB 14 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB14 periph B RX, conflicts with GCRS */
-							 AT91_PIOB 15 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB15 periph B TX, conflicts with GCOL */
-					};
-				};
-
 				dbgu {
 					pinctrl_dbgu: dbgu-0 {
 						atmel,pins =
@@ -531,107 +491,6 @@
 					};
 				};
 
-				lcd {
-					pinctrl_lcd: lcd-0 {
-						atmel,pins =
-							<AT91_PIOA 24 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA24 periph A LCDPWM */
-							 AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA26 periph A LCDVSYNC */
-							 AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA27 periph A LCDHSYNC */
-							 AT91_PIOA 25 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA25 periph A LCDDISP */
-							 AT91_PIOA 29 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA29 periph A LCDDEN */
-							 AT91_PIOA 28 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA28 periph A LCDPCK */
-							 AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA0 periph A LCDD0 pin */
-							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA1 periph A LCDD1 pin */
-							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA2 periph A LCDD2 pin */
-							 AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA3 periph A LCDD3 pin */
-							 AT91_PIOA 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA4 periph A LCDD4 pin */
-							 AT91_PIOA 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA5 periph A LCDD5 pin */
-							 AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA6 periph A LCDD6 pin */
-							 AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA7 periph A LCDD7 pin */
-							 AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA8 periph A LCDD8 pin */
-							 AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA9 periph A LCDD9 pin */
-							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA10 periph A LCDD10 pin */
-							 AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA11 periph A LCDD11 pin */
-							 AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA12 periph A LCDD12 pin */
-							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA13 periph A LCDD13 pin */
-							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA14 periph A LCDD14 pin */
-							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA15 periph A LCDD15 pin */
-							 AT91_PIOC 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC14 periph C LCDD16 pin */
-							 AT91_PIOC 13 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC13 periph C LCDD17 pin */
-							 AT91_PIOC 12 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC12 periph C LCDD18 pin */
-							 AT91_PIOC 11 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC11 periph C LCDD19 pin */
-							 AT91_PIOC 10 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC10 periph C LCDD20 pin */
-							 AT91_PIOC 15 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC15 periph C LCDD21 pin */
-							 AT91_PIOE 27 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PE27 periph C LCDD22 pin */
-							 AT91_PIOE 28 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PE28 periph C LCDD23 pin */
-					};
-				};
-
-				macb0 {
-					pinctrl_macb0_data_rgmii: macb0_data_rgmii {
-						atmel,pins =
-							<AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB0 periph A GTX0, conflicts with PWMH0 */
-							 AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB1 periph A GTX1, conflicts with PWML0 */
-							 AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB2 periph A GTX2, conflicts with TK1 */
-							 AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB3 periph A GTX3, conflicts with TF1 */
-							 AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB4 periph A GRX0, conflicts with PWMH1 */
-							 AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB5 periph A GRX1, conflicts with PWML1 */
-							 AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB6 periph A GRX2, conflicts with TD1 */
-							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB7 periph A GRX3, conflicts with RK1 */
-					};
-					pinctrl_macb0_data_gmii: macb0_data_gmii {
-						atmel,pins =
-							<AT91_PIOB 19 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB19 periph B GTX4, conflicts with MCI1_CDA */
-							 AT91_PIOB 20 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB20 periph B GTX5, conflicts with MCI1_DA0 */
-							 AT91_PIOB 21 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB21 periph B GTX6, conflicts with MCI1_DA1 */
-							 AT91_PIOB 22 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB22 periph B GTX7, conflicts with MCI1_DA2 */
-							 AT91_PIOB 23 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB23 periph B GRX4, conflicts with MCI1_DA3 */
-							 AT91_PIOB 24 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB24 periph B GRX5, conflicts with MCI1_CK */
-							 AT91_PIOB 25 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB25 periph B GRX6, conflicts with SCK1 */
-							 AT91_PIOB 26 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB26 periph B GRX7, conflicts with CTS1 */
-					};
-					pinctrl_macb0_signal_rgmii: macb0_signal_rgmii {
-						atmel,pins =
-							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB8 periph A GTXCK, conflicts with PWMH2 */
-							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A GTXEN, conflicts with PWML2 */
-							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A GRXCK, conflicts with RD1 */
-							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A GRXER, conflicts with PWML3 */
-							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A GMDC */
-							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB17 periph A GMDIO */
-							 AT91_PIOB 18 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB18 periph A G125CK */
-					};
-					pinctrl_macb0_signal_gmii: macb0_signal_gmii {
-						atmel,pins =
-							<AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A GTXEN, conflicts with PWML2 */
-							 AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB10 periph A GTXER, conflicts with RF1 */
-							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A GRXCK, conflicts with RD1 */
-							 AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB12 periph A GRXDV, conflicts with PWMH3 */
-							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A GRXER, conflicts with PWML3 */
-							 AT91_PIOB 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB14 periph A GCRS, conflicts with CANRX1 */
-							 AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB15 periph A GCOL, conflicts with CANTX1 */
-							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A GMDC */
-							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB17 periph A GMDIO */
-							 AT91_PIOB 27 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB27 periph B G125CKO */
-					};
-
-				};
-
-				macb1 {
-					pinctrl_macb1_rmii: macb1_rmii-0 {
-						atmel,pins =
-							<AT91_PIOC 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC0 periph A ETX0, conflicts with TIOA3 */
-							 AT91_PIOC 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC1 periph A ETX1, conflicts with TIOB3 */
-							 AT91_PIOC 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC2 periph A ERX0, conflicts with TCLK3 */
-							 AT91_PIOC 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC3 periph A ERX1, conflicts with TIOA4 */
-							 AT91_PIOC 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC4 periph A ETXEN, conflicts with TIOB4 */
-							 AT91_PIOC 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC5 periph A ECRSDV,conflicts with TCLK4 */
-							 AT91_PIOC 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC6 periph A ERXER, conflicts with TIOA5 */
-							 AT91_PIOC 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC7 periph A EREFCK, conflicts with TIOB5 */
-							 AT91_PIOC 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC8 periph A EMDC, conflicts with TCLK5 */
-							 AT91_PIOC 9 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC9 periph A EMDIO  */
-					};
-				};
-
 				mmc0 {
 					pinctrl_mmc0_clk_cmd_dat0: mmc0_clk_cmd_dat0 {
 						atmel,pins =
@@ -669,21 +528,6 @@
 					};
 				};
 
-				mmc2 {
-					pinctrl_mmc2_clk_cmd_dat0: mmc2_clk_cmd_dat0 {
-						atmel,pins =
-							<AT91_PIOC 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC15 periph A MCI2_CK, conflicts with PCK2 */
-							 AT91_PIOC 10 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PC10 periph A MCI2_CDA with pullup */
-							 AT91_PIOC 11 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PC11 periph A MCI2_DA0 with pullup */
-					};
-					pinctrl_mmc2_dat1_3: mmc2_dat1_3 {
-						atmel,pins =
-							<AT91_PIOC 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC12 periph A MCI2_DA1 with pullup, conflicts with TIOA1 */
-							 AT91_PIOC 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC13 periph A MCI2_DA2 with pullup, conflicts with TIOB1 */
-							 AT91_PIOC 14 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC14 periph A MCI2_DA3 with pullup, conflicts with TCLK1 */
-					};
-				};
-
 				nand0 {
 					pinctrl_nand0_ale_cle: nand0_ale_cle-0 {
 						atmel,pins =
@@ -742,22 +586,6 @@
 					};
 				};
 
-				uart0 {
-					pinctrl_uart0: uart0-0 {
-						atmel,pins =
-							<AT91_PIOC 29 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC29 periph A, conflicts with PWMFI2, ISI_D8 */
-							 AT91_PIOC 30 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PC30 periph A with pullup, conflicts with ISI_PCK */
-					};
-				};
-
-				uart1 {
-					pinctrl_uart1: uart1-0 {
-						atmel,pins =
-							<AT91_PIOA 30 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PA30 periph B, conflicts with TWD0, ISI_VSYNC */
-							 AT91_PIOA 31 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;	/* PA31 periph B with pullup, conflicts with TWCK0, ISI_HSYNC */
-					};
-				};
-
 				usart0 {
 					pinctrl_usart0: usart0-0 {
 						atmel,pins =
@@ -869,6 +697,125 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91rm9200-pmc";
 				reg = <0xfffffc00 0x120>;
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
+					compatible = "atmel,sama5d3-clk-pll";
+					#clock-cells = <0>;
+					clocks = <&main>;
+					id = <0>;
+					input = <8000000 50000000>;
+					output = <400000000 1000000000>;
+					out = <0>;
+					icpll = <0>;
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
+					compatible = "atmel,at91sam9x5-clk-master";
+					#clock-cells = <0>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>;
+					output = <0 166000000>;
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
+					compatible = "atmel,at91sam9x5-clk-programmable";
+					#clock-cells = <1>;
+					ids = <0 1 2>;
+					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>, <&mck>;
+					clock-output-names = "prog0", "prog1", "prog2";
+				};
+
+				smd: smdck {
+					compatible = "atmel,at91sam9x5-clk-smd";
+					#clock-cells = <0>;
+					clocks = <&plladiv>, <&utmi>;
+				};
+
+				system: systemck {
+					compatible = "atmel,at91rm9200-clk-system";
+					#clock-cells = <1>;
+					ids = <2 4 6 7 8 9 10>;
+					clocks = <&mck>, <&smd>, <&usb>, <&usb>,
+						 <&prog 0>, <&prog 1>, <&prog 2>;
+					clock-output-names = "ddrck", "smdck", "uhpck", "udpck",
+							     "pck0", "pck1", "pck2";
+				};
+
+				periph: periphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <2 6 7 8 9 10 12 13 14 15 18 19 20 21 22 23 24
+						   25 26 28 29 37 38 39 42 43 44 45 48>;
+					clock-output-names = "pioA_clk",
+							     "pioB_clk",
+							     "pioB_clk",
+							     "pioD_clk",
+							     "pioE_clk",
+							     "usart0_clk",
+							     "usart1_clk",
+							     "usart2_clk",
+							     "usart3_clk",
+							     "twi0_clk",
+							     "twi1_clk",
+							     "twi2_clk",
+							     "mci0_clk",
+							     "mci1_clk",
+							     "mci2_clk",
+							     "spi0_clk",
+							     "spi1_clk",
+							     "tcb0_clk",
+							     "pwm_clk",
+							     "adc_clk",
+							     "dma0_clk",
+							     "dma1_clk",
+							     "uhphs_clk",
+							     "udphs_clk",
+							     "isi_clk",
+							     "ssc0_clk",
+							     "ssc1_clk",
+							     "sha_clk",
+							     "aes_clk",
+							     "tdes_clk",
+							     "trng_clk",
+							     "fuse_clk";
+
+					adc_op_clk: adc_op_clk{
+						compatible = "fixed-clock";
+						#clock-cells = <0>;
+						clock-frequency = <20000000>;
+					};
+				};
 			};
 
 			rstc@fffffe00 {
@@ -880,6 +827,7 @@
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffe30 0xf>;
 				interrupts = <3 IRQ_TYPE_LEVEL_HIGH 5>;
+				clocks = <&mck>;
 			};
 
 			watchdog@fffffe40 {
@@ -1014,6 +962,8 @@
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00600000 0x100000>;
 			interrupts = <32 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&periph 32>, <&periph 32>, <&system 6>;
+			clock-names = "ohci_clk", "hclk", "uhpck";
 			status = "disabled";
 		};
 
@@ -1021,6 +971,8 @@
 			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
 			reg = <0x00700000 0x100000>;
 			interrupts = <32 IRQ_TYPE_LEVEL_HIGH 2>;
+			clocks = <&periph 32>, <&system 6>;
+			clock-names = "ehci_clk", "uhpck";
 			status = "disabled";
 		};
 
diff --git a/arch/arm/boot/dts/sama5d3_can.dtsi b/arch/arm/boot/dts/sama5d3_can.dtsi
new file mode 100644
index 0000000..2c428e6
--- /dev/null
+++ b/arch/arm/boot/dts/sama5d3_can.dtsi
@@ -0,0 +1,67 @@
+/*
+ * at91sama5d3_can.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
+ * CAN support
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+#include <dt-bindings/pinctrl/at91.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+/ {
+	ahb {
+		apb {
+			pinctrl@fffff200 {
+				can0 {
+					pinctrl_can0_rx_tx: can0_rx_tx {
+						atmel,pins =
+							<AT91_PIOD 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PD14 periph C RX, conflicts with SCK0, SPI0_NPCS1 */
+							 AT91_PIOD 15 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PD15 periph C TX, conflicts with CTS0, SPI0_NPCS2 */
+					};
+				};
+
+				can1 {
+					pinctrl_can1_rx_tx: can1_rx_tx {
+						atmel,pins =
+							<AT91_PIOB 14 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB14 periph B RX, conflicts with GCRS */
+							 AT91_PIOB 15 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB15 periph B TX, conflicts with GCOL */
+					};
+				};
+
+			};
+
+			pmc: pmc@fffffc00 {
+				canperiph: canperiphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <40 41>;
+					clock-output-names = "can0_clk", "can1_clk";
+				};
+			};
+
+			can0: can@f000c000 {
+				compatible = "atmel,at91sam9x5-can";
+				reg = <0xf000c000 0x300>;
+				interrupts = <40 IRQ_TYPE_LEVEL_HIGH 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_can0_rx_tx>;
+				clocks = <&canperiph 40>;
+				clock-names = "can_clk";
+				status = "disabled";
+			};
+
+			can1: can@f8010000 {
+				compatible = "atmel,at91sam9x5-can";
+				reg = <0xf8010000 0x300>;
+				interrupts = <41 IRQ_TYPE_LEVEL_HIGH 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_can1_rx_tx>;
+				clocks = <&canperiph 41>;
+				clock-names = "can_clk";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/sama5d3_emac.dtsi b/arch/arm/boot/dts/sama5d3_emac.dtsi
new file mode 100644
index 0000000..53e63ca
--- /dev/null
+++ b/arch/arm/boot/dts/sama5d3_emac.dtsi
@@ -0,0 +1,56 @@
+/*
+ * at91sama5d3_emac.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
+ * Ethernet.
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+#include <dt-bindings/pinctrl/at91.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+/ {
+	ahb {
+		apb {
+			pinctrl@fffff200 {
+				macb1 {
+					pinctrl_macb1_rmii: macb1_rmii-0 {
+						atmel,pins =
+							<AT91_PIOC 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC0 periph A ETX0, conflicts with TIOA3 */
+							 AT91_PIOC 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC1 periph A ETX1, conflicts with TIOB3 */
+							 AT91_PIOC 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC2 periph A ERX0, conflicts with TCLK3 */
+							 AT91_PIOC 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC3 periph A ERX1, conflicts with TIOA4 */
+							 AT91_PIOC 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC4 periph A ETXEN, conflicts with TIOB4 */
+							 AT91_PIOC 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC5 periph A ECRSDV,conflicts with TCLK4 */
+							 AT91_PIOC 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC6 periph A ERXER, conflicts with TIOA5 */
+							 AT91_PIOC 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC7 periph A EREFCK, conflicts with TIOB5 */
+							 AT91_PIOC 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC8 periph A EMDC, conflicts with TCLK5 */
+							 AT91_PIOC 9 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC9 periph A EMDIO  */
+					};
+				};
+			};
+
+			pmc: pmc@fffffc00 {
+				emacperiph: emacperiphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <35>;
+					clock-output-names = "macb0_clk";
+				};
+			};
+
+			macb1: ethernet@f802c000 {
+				compatible = "cdns,at32ap7000-macb", "cdns,macb";
+				reg = <0xf802c000 0x100>;
+				interrupts = <35 IRQ_TYPE_LEVEL_HIGH 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_macb1_rmii>;
+				clocks = <&emacperiph 35>, <&periph 35>;
+				clock-names = "hclk", "pclk";
+				status = "disabled";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/sama5d3_gmac.dtsi b/arch/arm/boot/dts/sama5d3_gmac.dtsi
new file mode 100644
index 0000000..8db198b
--- /dev/null
+++ b/arch/arm/boot/dts/sama5d3_gmac.dtsi
@@ -0,0 +1,89 @@
+/*
+ * at91sama5d3_gmac.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
+ * Gigabit Ethernet.
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+#include <dt-bindings/pinctrl/at91.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+/ {
+	ahb {
+		apb {
+			pinctrl@fffff200 {
+				macb0 {
+					pinctrl_macb0_data_rgmii: macb0_data_rgmii {
+						atmel,pins =
+							<AT91_PIOB 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB0 periph A GTX0, conflicts with PWMH0 */
+							 AT91_PIOB 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB1 periph A GTX1, conflicts with PWML0 */
+							 AT91_PIOB 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB2 periph A GTX2, conflicts with TK1 */
+							 AT91_PIOB 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB3 periph A GTX3, conflicts with TF1 */
+							 AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB4 periph A GRX0, conflicts with PWMH1 */
+							 AT91_PIOB 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB5 periph A GRX1, conflicts with PWML1 */
+							 AT91_PIOB 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB6 periph A GRX2, conflicts with TD1 */
+							 AT91_PIOB 7 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB7 periph A GRX3, conflicts with RK1 */
+					};
+					pinctrl_macb0_data_gmii: macb0_data_gmii {
+						atmel,pins =
+							<AT91_PIOB 19 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB19 periph B GTX4, conflicts with MCI1_CDA */
+							 AT91_PIOB 20 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB20 periph B GTX5, conflicts with MCI1_DA0 */
+							 AT91_PIOB 21 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB21 periph B GTX6, conflicts with MCI1_DA1 */
+							 AT91_PIOB 22 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB22 periph B GTX7, conflicts with MCI1_DA2 */
+							 AT91_PIOB 23 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB23 periph B GRX4, conflicts with MCI1_DA3 */
+							 AT91_PIOB 24 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB24 periph B GRX5, conflicts with MCI1_CK */
+							 AT91_PIOB 25 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PB25 periph B GRX6, conflicts with SCK1 */
+							 AT91_PIOB 26 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB26 periph B GRX7, conflicts with CTS1 */
+					};
+					pinctrl_macb0_signal_rgmii: macb0_signal_rgmii {
+						atmel,pins =
+							<AT91_PIOB 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB8 periph A GTXCK, conflicts with PWMH2 */
+							 AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A GTXEN, conflicts with PWML2 */
+							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A GRXCK, conflicts with RD1 */
+							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A GRXER, conflicts with PWML3 */
+							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A GMDC */
+							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB17 periph A GMDIO */
+							 AT91_PIOB 18 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PB18 periph A G125CK */
+					};
+					pinctrl_macb0_signal_gmii: macb0_signal_gmii {
+						atmel,pins =
+							<AT91_PIOB 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB9 periph A GTXEN, conflicts with PWML2 */
+							 AT91_PIOB 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB10 periph A GTXER, conflicts with RF1 */
+							 AT91_PIOB 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB11 periph A GRXCK, conflicts with RD1 */
+							 AT91_PIOB 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB12 periph A GRXDV, conflicts with PWMH3 */
+							 AT91_PIOB 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB13 periph A GRXER, conflicts with PWML3 */
+							 AT91_PIOB 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB14 periph A GCRS, conflicts with CANRX1 */
+							 AT91_PIOB 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB15 periph A GCOL, conflicts with CANTX1 */
+							 AT91_PIOB 16 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB16 periph A GMDC */
+							 AT91_PIOB 17 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PB17 periph A GMDIO */
+							 AT91_PIOB 27 AT91_PERIPH_B AT91_PINCTRL_NONE>;	/* PB27 periph B G125CKO */
+					};
+
+				};
+			};
+
+			pmc: pmc@fffffc00 {
+				gmacperiph: gmacperiphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <34>;
+					clock-output-names = "macb0_clk";
+				};
+			};
+
+			macb0: ethernet@f0028000 {
+				compatible = "cnds,pc302-gem", "cdns,gem";
+				reg = <0xf0028000 0x100>;
+				interrupts = <34 IRQ_TYPE_LEVEL_HIGH 3>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_macb0_data_rgmii &pinctrl_macb0_signal_rgmii>;
+				clocks = <&periph 34>, <&periph 34>;
+				clock-names = "hclk", "pclk";
+				status = "disabled";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/sama5d3_lcd.dtsi b/arch/arm/boot/dts/sama5d3_lcd.dtsi
new file mode 100644
index 0000000..06a42e7
--- /dev/null
+++ b/arch/arm/boot/dts/sama5d3_lcd.dtsi
@@ -0,0 +1,73 @@
+/*
+ * at91sama5d3_lcd.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
+ * LCD support
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+#include <dt-bindings/pinctrl/at91.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+/ {
+	ahb {
+		apb {
+			pinctrl@fffff200 {
+				lcd {
+					pinctrl_lcd: lcd-0 {
+						atmel,pins =
+							<AT91_PIOA 24 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA24 periph A LCDPWM */
+							 AT91_PIOA 26 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA26 periph A LCDVSYNC */
+							 AT91_PIOA 27 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA27 periph A LCDHSYNC */
+							 AT91_PIOA 25 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA25 periph A LCDDISP */
+							 AT91_PIOA 29 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA29 periph A LCDDEN */
+							 AT91_PIOA 28 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA28 periph A LCDPCK */
+							 AT91_PIOA 0 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA0 periph A LCDD0 pin */
+							 AT91_PIOA 1 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA1 periph A LCDD1 pin */
+							 AT91_PIOA 2 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA2 periph A LCDD2 pin */
+							 AT91_PIOA 3 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA3 periph A LCDD3 pin */
+							 AT91_PIOA 4 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA4 periph A LCDD4 pin */
+							 AT91_PIOA 5 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA5 periph A LCDD5 pin */
+							 AT91_PIOA 6 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA6 periph A LCDD6 pin */
+							 AT91_PIOA 7 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA7 periph A LCDD7 pin */
+							 AT91_PIOA 8 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA8 periph A LCDD8 pin */
+							 AT91_PIOA 9 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA9 periph A LCDD9 pin */
+							 AT91_PIOA 10 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA10 periph A LCDD10 pin */
+							 AT91_PIOA 11 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA11 periph A LCDD11 pin */
+							 AT91_PIOA 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA12 periph A LCDD12 pin */
+							 AT91_PIOA 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA13 periph A LCDD13 pin */
+							 AT91_PIOA 14 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA14 periph A LCDD14 pin */
+							 AT91_PIOA 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PA15 periph A LCDD15 pin */
+							 AT91_PIOC 14 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC14 periph C LCDD16 pin */
+							 AT91_PIOC 13 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC13 periph C LCDD17 pin */
+							 AT91_PIOC 12 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC12 periph C LCDD18 pin */
+							 AT91_PIOC 11 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC11 periph C LCDD19 pin */
+							 AT91_PIOC 10 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC10 periph C LCDD20 pin */
+							 AT91_PIOC 15 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PC15 periph C LCDD21 pin */
+							 AT91_PIOE 27 AT91_PERIPH_C AT91_PINCTRL_NONE	/* PE27 periph C LCDD22 pin */
+							 AT91_PIOE 28 AT91_PERIPH_C AT91_PINCTRL_NONE>;	/* PE28 periph C LCDD23 pin */
+					};
+				};
+			};
+
+			pmc: pmc@fffffc00 {
+				lcdperiph: lcdperiphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <36>;
+					clock-output-names = "lcdc_clk";
+				};
+
+				lcdsys: lcdsysck {
+					compatible = "atmel,at91rm9200-clk-system";
+					#clock-cells = <1>;
+					ids = <3>;
+					clocks = <&mck>;
+					clock-output-names = "lcdck";
+				};
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/sama5d3_mci2.dtsi b/arch/arm/boot/dts/sama5d3_mci2.dtsi
new file mode 100644
index 0000000..9bec872
--- /dev/null
+++ b/arch/arm/boot/dts/sama5d3_mci2.dtsi
@@ -0,0 +1,59 @@
+/*
+ * at91sama5d3_mci2.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
+ * 3 MMC ports
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+#include <dt-bindings/pinctrl/at91.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+/ {
+	ahb {
+		apb {
+			pinctrl@fffff200 {
+				mmc2 {
+					pinctrl_mmc2_clk_cmd_dat0: mmc2_clk_cmd_dat0 {
+						atmel,pins =
+							<AT91_PIOC 15 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC15 periph A MCI2_CK, conflicts with PCK2 */
+							 AT91_PIOC 10 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PC10 periph A MCI2_CDA with pullup */
+							 AT91_PIOC 11 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PC11 periph A MCI2_DA0 with pullup */
+					};
+					pinctrl_mmc2_dat1_3: mmc2_dat1_3 {
+						atmel,pins =
+							<AT91_PIOC 12 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC12 periph A MCI2_DA1 with pullup, conflicts with TIOA1 */
+							 AT91_PIOC 13 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC13 periph A MCI2_DA2 with pullup, conflicts with TIOB1 */
+							 AT91_PIOC 14 AT91_PERIPH_A AT91_PINCTRL_NONE>;	/* PC14 periph A MCI2_DA3 with pullup, conflicts with TCLK1 */
+					};
+				};
+			};
+
+			pmc: pmc@fffffc00 {
+				mci2periph: mci2periphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <23>;
+					clock-output-names = "mci2_clk";
+				};
+			};
+
+			mmc2: mmc@f8004000 {
+				compatible = "atmel,hsmci";
+				reg = <0xf8004000 0x600>;
+				interrupts = <23 4 0>;
+				dmas = <&dma1 2 1>;
+				dma-names = "rxtx";
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_mmc2_clk_cmd_dat0 &pinctrl_mmc2_dat1_3>;
+				status = "disabled";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				clocks = <&periph 23>;
+				clock-names = "mci_clk";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/sama5d3_tcb1.dtsi b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
new file mode 100644
index 0000000..338acc2
--- /dev/null
+++ b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
@@ -0,0 +1,39 @@
+/*
+ * at91sama5d3_tcb1.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
+ * 2 TC blocks.
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+#include <dt-bindings/pinctrl/at91.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+/ {
+	aliases {
+		tcb1 = &tcb1;
+	};
+
+	ahb {
+		apb {
+			pmc: pmc@fffffc00 {
+				tcb1periph: tcb1periphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <27>;
+					clock-output-names = "tcb1_clk";
+				};
+			};
+
+			tcb1: timer@f8014000 {
+				compatible = "atmel,at91sam9x5-tcb";
+				reg = <0xf8014000 0x100>;
+				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&tcb1periph 27>;
+				clock-names = "t0_clk";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/sama5d3_uart.dtsi b/arch/arm/boot/dts/sama5d3_uart.dtsi
new file mode 100644
index 0000000..8c3d869
--- /dev/null
+++ b/arch/arm/boot/dts/sama5d3_uart.dtsi
@@ -0,0 +1,42 @@
+/*
+ * at91sama5d3_uart.dtsi - Device Tree Include file for AT91SAM9x5 SoC with
+ * UART support
+ *
+ * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+/ {
+	ahb {
+		apb {
+			pinctrl@fffff200 {
+				uart0 {
+					pinctrl_uart0: uart0-0 {
+						atmel,pins =
+							<AT91_PIOC 29 AT91_PERIPH_A AT91_PINCTRL_NONE	/* PC29 periph A, conflicts with PWMFI2, ISI_D8 */
+							 AT91_PIOC 30 AT91_PERIPH_A AT91_PINCTRL_PULL_UP>;	/* PC30 periph A with pullup, conflicts with ISI_PCK */
+					};
+				};
+
+				uart1 {
+					pinctrl_uart1: uart1-0 {
+						atmel,pins =
+							<AT91_PIOA 30 AT91_PERIPH_B AT91_PINCTRL_NONE	/* PA30 periph B, conflicts with TWD0, ISI_VSYNC */
+							 AT91_PIOA 31 AT91_PERIPH_B AT91_PINCTRL_PULL_UP>;	/* PA31 periph B with pullup, conflicts with TWCK0, ISI_HSYNC */
+					};
+				};
+			};
+
+			pmc: pmc@fffffc00 {
+				uartperiph: uartperiphck {
+					compatible = "atmel,at91sam9x5-clk-peripheral";
+					#clock-cells = <1>;
+					clocks = <&mck>;
+					ids = <16 17>;
+					clock-output-names = "uart0_clk", "uart1_clk";
+				};
+			};
+		};
+	};
+};
-- 
1.7.9.5

