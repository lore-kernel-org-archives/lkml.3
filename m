Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab3LDPeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:34:03 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:33036 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab3LDPd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:33:59 -0500
Message-ID: <529F4B64.9030604@linaro.org>
Date: Wed, 04 Dec 2013 09:33:56 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Christian Daudt <bcm@fixthebug.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mike Turquette <mturquette@linaro.org>
CC: "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] ARM: dts: bcm281xx: define real clocks
References: <529F4B0F.2020801@linaro.org>
In-Reply-To: <529F4B0F.2020801@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the "fake" clocks defined in the "bcm11351.dtsi" device tree
file with real definitions backed by the new BCM281xx clock driver..

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
---
v2: - got rid of the "not_selected" clock definition

 arch/arm/boot/dts/bcm11351.dtsi |  240
++++++++++++++++++++++++++-------------
 1 file changed, 164 insertions(+), 76 deletions(-)

diff --git a/arch/arm/boot/dts/bcm11351.dtsi
b/arch/arm/boot/dts/bcm11351.dtsi
index 1246885..23cddbe 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -14,6 +14,8 @@
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/interrupt-controller/irq.h>

+#include "dt-bindings/clock/bcm281xx.h"
+
 #include "skeleton.dtsi"

 / {
@@ -43,7 +45,7 @@
 		compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
 		status = "disabled";
 		reg = <0x3e000000 0x1000>;
-		clocks = <&uartb_clk>;
+		clocks = <&slave_ccu BCM281XX_SLAVE_CCU_UARTB>;
 		interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
 		reg-shift = <2>;
 		reg-io-width = <4>;
@@ -53,7 +55,7 @@
 		compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
 		status = "disabled";
 		reg = <0x3e001000 0x1000>;
-		clocks = <&uartb2_clk>;
+		clocks = <&slave_ccu BCM281XX_SLAVE_CCU_UARTB2>;
 		interrupts = <GIC_SPI 66 IRQ_TYPE_LEVEL_HIGH>;
 		reg-shift = <2>;
 		reg-io-width = <4>;
@@ -63,7 +65,7 @@
 		compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
 		status = "disabled";
 		reg = <0x3e002000 0x1000>;
-		clocks = <&uartb3_clk>;
+		clocks = <&slave_ccu BCM281XX_SLAVE_CCU_UARTB3>;
 		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
 		reg-shift = <2>;
 		reg-io-width = <4>;
@@ -73,7 +75,7 @@
 		compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
 		status = "disabled";
 		reg = <0x3e003000 0x1000>;
-		clocks = <&uartb4_clk>;
+		clocks = <&slave_ccu BCM281XX_SLAVE_CCU_UARTB4>;
 		interrupts = <GIC_SPI 64 IRQ_TYPE_LEVEL_HIGH>;
 		reg-shift = <2>;
 		reg-io-width = <4>;
@@ -95,7 +97,7 @@
 		compatible = "brcm,kona-timer";
 		reg = <0x35006000 0x1000>;
 		interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&hub_timer_clk>;
+		clocks = <&aon_ccu BCM281XX_AON_CCU_HUB_TIMER>;
 	};

 	gpio: gpio@35003000 {
@@ -118,7 +120,7 @@
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f180000 0x10000>;
 		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&sdio1_clk>;
+		clocks = <&master_ccu BCM281XX_MASTER_CCU_SDIO1>;
 		status = "disabled";
 	};

@@ -126,7 +128,7 @@
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f190000 0x10000>;
 		interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&sdio2_clk>;
+		clocks = <&master_ccu BCM281XX_MASTER_CCU_SDIO2>;
 		status = "disabled";
 	};

@@ -134,7 +136,7 @@
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f1a0000 0x10000>;
 		interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&sdio3_clk>;
+		clocks = <&master_ccu BCM281XX_MASTER_CCU_SDIO3>;
 		status = "disabled";
 	};

@@ -142,99 +144,125 @@
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f1b0000 0x10000>;
 		interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&sdio4_clk>;
+		clocks = <&master_ccu BCM281XX_MASTER_CCU_SDIO4>;
 		status = "disabled";
 	};

 	clocks {
-		bsc1_clk: bsc1 {
-			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		root_ccu: root_ccu {
+			compatible = "brcm,bcm11351-root-ccu";
+			reg = <0x35001000 0x0f00>;
+			#clock-cells = <1>;
+			clock-output-names = "frac_1m";
+		};
+
+		hub_ccu: hub_ccu {
+			compatible = "brcm,bcm11351-hub-ccu";
+			reg = <0x34000000 0x0f00>;
+			#clock-cells = <1>;
+			clock-output-names = "tmon_1m";
+		};
+
+		aon_ccu: aon_ccu {
+			compatible = "brcm,bcm11351-aon-ccu";
+			reg = <0x35002000 0x0f00>;
+			#clock-cells = <1>;
+			clock-output-names = "hub_timer",
+					     "pmu_bsc",
+					     "pmu_bsc_var";
+		};
+
+		master_ccu: master_ccu {
+			compatible = "brcm,bcm11351-master-ccu";
+			reg = <0x3f001000 0x0f00>;
+			#clock-cells = <1>;
+			clock-output-names = "sdio1",
+					     "sdio2",
+					     "sdio3",
+					     "sdio4",
+					     "usb_ic",
+					     "hsic2_48m",
+					     "hsic2_12m";
+		};
+
+		slave_ccu: slave_ccu {
+			compatible = "brcm,bcm11351-slave-ccu";
+			reg = <0x3e011000 0x0f00>;
+			#clock-cells = <1>;
+			clock-output-names = "uartb",
+					     "uartb2",
+					     "uartb3",
+					     "uartb4",
+					     "ssp0",
+					     "ssp2",
+					     "bsc1",
+					     "bsc2",
+					     "bsc3",
+					     "pwm";
+		};
+
+		ref_1m_clk: ref_1m {
 			#clock-cells = <0>;
-		};
-
-		bsc2_clk: bsc2 {
-			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
-			#clock-cells = <0>;
-		};
-
-		bsc3_clk: bsc3 {
-			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
-			#clock-cells = <0>;
-		};
-
-		pmu_bsc_clk: pmu_bsc {
-			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
-			#clock-cells = <0>;
-		};
-
-		hub_timer_clk: hub_timer {
-			compatible = "fixed-clock";
-			clock-frequency = <32768>;
-			#clock-cells = <0>;
-		};
-
-		pwm_clk: pwm {
-			compatible = "fixed-clock";
-			clock-frequency = <26000000>;
-			#clock-cells = <0>;
-		};
-
-		sdio1_clk: sdio1 {
-			compatible = "fixed-clock";
-			clock-frequency = <48000000>;
-			#clock-cells = <0>;
-		};
-
-		sdio2_clk: sdio2 {
-			compatible = "fixed-clock";
-			clock-frequency = <48000000>;
-			#clock-cells = <0>;
-		};
-
-		sdio3_clk: sdio3 {
-			compatible = "fixed-clock";
-			clock-frequency = <48000000>;
-			#clock-cells = <0>;
-		};
-
-		sdio4_clk: sdio4 {
-			compatible = "fixed-clock";
-			clock-frequency = <48000000>;
-			#clock-cells = <0>;
-		};
-
-		tmon_1m_clk: tmon_1m {
 			compatible = "fixed-clock";
 			clock-frequency = <1000000>;
+		};
+
+		ref_32k_clk: ref_32k {
 			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
 		};

-		uartb_clk: uartb {
+		bbl_32k_clk: bbl_32k {
+			#clock-cells = <0>;
 			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
+			clock-frequency = <32768>;
+		};
+
+		ref_13m_clk: ref_13m {
 			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <13000000>;
 		};

-		uartb2_clk: uartb2 {
+		var_13m_clk: var_13m {
+			#clock-cells = <0>;
 			compatible = "fixed-clock";
 			clock-frequency = <13000000>;
+		};
+
+		dft_19_5m_clk: dft_19_5m {
 			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <19500000>;
 		};

-		uartb3_clk: uartb3 {
+		ref_crystal_clk: ref_crystal {
+			#clock-cells = <0>;
 			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
+			clock-frequency = <26000000>;
+		};
+
+		ref_cx40_clk: ref_cx40 {
 			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <40000000>;
 		};

-		uartb4_clk: uartb4 {
+		ref_52m_clk: ref_52m {
+			#clock-cells = <0>;
 			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
+			clock-frequency = <52000000>;
+		};
+
+		var_52m_clk: var_52m {
 			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <52000000>;
 		};

 		usb_otg_ahb_clk: usb_otg_ahb {
@@ -242,5 +270,65 @@
 			clock-frequency = <52000000>;
 			#clock-cells = <0>;
 		};
+
+		ref_96m_clk: ref_96m {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <96000000>;
+		};
+
+		var_96m_clk: var_96m {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <96000000>;
+		};
+
+		ref_104m_clk: ref_104m {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <104000000>;
+		};
+
+		var_104m_clk: var_104m {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <104000000>;
+		};
+
+		ref_156m_clk: ref_156m {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <156000000>;
+		};
+
+		var_156m_clk: var_156m {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <156000000>;
+		};
+
+		ref_208m_clk: ref_208m {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <208000000>;
+		};
+
+		var_208m_clk: var_208m {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <208000000>;
+		};
+
+		ref_312m_clk: ref_312m {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <312000000>;
+		};
+
+		var_312m_clk: var_312m {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <312000000>;
+		};
 	};
 };
-- 
1.7.9.5

