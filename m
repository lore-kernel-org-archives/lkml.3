Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaDUV0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:26:53 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:42376 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbaDUV0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:26:42 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org,
        devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 RESEND 5/5] ARM: dts: use real clocks for bcm21664
Date: Mon, 21 Apr 2014 16:26:27 -0500
Message-Id: <1398115587-32529-6-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398115587-32529-1-git-send-email-elder@linaro.org>
References: <1398115587-32529-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the "fake" fixed-rate clocks used previously for the
bcm21664 family with "real" ones.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/boot/dts/bcm21664.dtsi | 190 +++++++++++++++++++++++++---------------
 1 file changed, 118 insertions(+), 72 deletions(-)

diff --git a/arch/arm/boot/dts/bcm21664.dtsi b/arch/arm/boot/dts/bcm21664.dtsi
index 08a44d4..8b36682 100644
--- a/arch/arm/boot/dts/bcm21664.dtsi
+++ b/arch/arm/boot/dts/bcm21664.dtsi
@@ -14,6 +14,8 @@
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 
+#include "dt-bindings/clock/bcm21664.h"
+
 #include "skeleton.dtsi"
 
 / {
@@ -43,7 +45,7 @@
 		compatible = "brcm,bcm21664-dw-apb-uart", "snps,dw-apb-uart";
 		status = "disabled";
 		reg = <0x3e000000 0x118>;
-		clocks = <&uartb_clk>;
+		clocks = <&slave_ccu BCM21664_SLAVE_CCU_UARTB>;
 		interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
 		reg-shift = <2>;
 		reg-io-width = <4>;
@@ -53,7 +55,7 @@
 		compatible = "brcm,bcm21664-dw-apb-uart", "snps,dw-apb-uart";
 		status = "disabled";
 		reg = <0x3e001000 0x118>;
-		clocks = <&uartb2_clk>;
+		clocks = <&slave_ccu BCM21664_SLAVE_CCU_UARTB2>;
 		interrupts = <GIC_SPI 66 IRQ_TYPE_LEVEL_HIGH>;
 		reg-shift = <2>;
 		reg-io-width = <4>;
@@ -63,7 +65,7 @@
 		compatible = "brcm,bcm21664-dw-apb-uart", "snps,dw-apb-uart";
 		status = "disabled";
 		reg = <0x3e002000 0x118>;
-		clocks = <&uartb3_clk>;
+		clocks = <&slave_ccu BCM21664_SLAVE_CCU_UARTB3>;
 		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
 		reg-shift = <2>;
 		reg-io-width = <4>;
@@ -85,7 +87,7 @@
 		compatible = "brcm,kona-timer";
 		reg = <0x35006000 0x1c>;
 		interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&hub_timer_clk>;
+		clocks = <&aon_ccu BCM21664_AON_CCU_HUB_TIMER>;
 	};
 
 	gpio: gpio@35003000 {
@@ -106,7 +108,7 @@
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f180000 0x801c>;
 		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&sdio1_clk>;
+		clocks = <&master_ccu BCM21664_MASTER_CCU_SDIO1>;
 		status = "disabled";
 	};
 
@@ -114,7 +116,7 @@
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f190000 0x801c>;
 		interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&sdio2_clk>;
+		clocks = <&master_ccu BCM21664_MASTER_CCU_SDIO2>;
 		status = "disabled";
 	};
 
@@ -122,7 +124,7 @@
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f1a0000 0x801c>;
 		interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&sdio3_clk>;
+		clocks = <&master_ccu BCM21664_MASTER_CCU_SDIO3>;
 		status = "disabled";
 	};
 
@@ -130,7 +132,7 @@
 		compatible = "brcm,kona-sdhci";
 		reg = <0x3f1b0000 0x801c>;
 		interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&sdio4_clk>;
+		clocks = <&master_ccu BCM21664_MASTER_CCU_SDIO4>;
 		status = "disabled";
 	};
 
@@ -140,7 +142,7 @@
 		interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&bsc1_clk>;
+		clocks = <&slave_ccu BCM21664_SLAVE_CCU_BSC1>;
 		status = "disabled";
 	};
 
@@ -150,7 +152,7 @@
 		interrupts = <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&bsc2_clk>;
+		clocks = <&slave_ccu BCM21664_SLAVE_CCU_BSC2>;
 		status = "disabled";
 	};
 
@@ -160,7 +162,7 @@
 		interrupts = <GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&bsc3_clk>;
+		clocks = <&slave_ccu BCM21664_SLAVE_CCU_BSC3>;
 		status = "disabled";
 	};
 
@@ -170,105 +172,149 @@
 		interrupts = <GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&bsc4_clk>;
+		clocks = <&slave_ccu BCM21664_SLAVE_CCU_BSC4>;
 		status = "disabled";
 	};
 
 	clocks {
-		bsc1_clk: bsc1 {
-			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
-			#clock-cells = <0>;
-		};
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
 
-		bsc2_clk: bsc2 {
-			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
+		/*
+		 * Fixed clocks are defined before CCUs whose
+		 * clocks may depend on them.
+		 */
+
+		ref_32k_clk: ref_32k {
 			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
 		};
 
-		bsc3_clk: bsc3 {
-			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
+		bbl_32k_clk: bbl_32k {
 			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
 		};
 
-		bsc4_clk: bsc4 {
+		ref_13m_clk: ref_13m {
+			#clock-cells = <0>;
 			compatible = "fixed-clock";
 			clock-frequency = <13000000>;
-			#clock-cells = <0>;
 		};
 
-		pmu_bsc_clk: pmu_bsc {
+		var_13m_clk: var_13m {
+			#clock-cells = <0>;
 			compatible = "fixed-clock";
 			clock-frequency = <13000000>;
-			#clock-cells = <0>;
 		};
 
-		hub_timer_clk: hub_timer {
-			compatible = "fixed-clock";
-			clock-frequency = <32768>;
+		dft_19_5m_clk: dft_19_5m {
 			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <19500000>;
 		};
 
-		pwm_clk: pwm {
+		ref_crystal_clk: ref_crystal {
+			#clock-cells = <0>;
 			compatible = "fixed-clock";
 			clock-frequency = <26000000>;
-			#clock-cells = <0>;
 		};
 
-		sdio1_clk: sdio1 {
-			compatible = "fixed-clock";
-			clock-frequency = <48000000>;
+		ref_52m_clk: ref_52m {
 			#clock-cells = <0>;
-		};
-
-		sdio2_clk: sdio2 {
 			compatible = "fixed-clock";
-			clock-frequency = <48000000>;
-			#clock-cells = <0>;
+			clock-frequency = <52000000>;
 		};
 
-		sdio3_clk: sdio3 {
-			compatible = "fixed-clock";
-			clock-frequency = <48000000>;
+		var_52m_clk: var_52m {
 			#clock-cells = <0>;
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
-			clock-frequency = <1000000>;
-			#clock-cells = <0>;
-		};
-
-		uartb_clk: uartb {
-			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
-			#clock-cells = <0>;
-		};
-
-		uartb2_clk: uartb2 {
-			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
-			#clock-cells = <0>;
-		};
-
-		uartb3_clk: uartb3 {
-			compatible = "fixed-clock";
-			clock-frequency = <13000000>;
-			#clock-cells = <0>;
+			clock-frequency = <52000000>;
 		};
 
 		usb_otg_ahb_clk: usb_otg_ahb {
+			#clock-cells = <0>;
 			compatible = "fixed-clock";
 			clock-frequency = <52000000>;
+		};
+
+		ref_96m_clk: ref_96m {
 			#clock-cells = <0>;
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
+		root_ccu: root_ccu {
+			compatible = BCM21664_DT_ROOT_CCU_COMPAT;
+			reg = <0x35001000 0x0f00>;
+			#clock-cells = <1>;
+			clock-output-names = "frac_1m";
+		};
+
+		aon_ccu: aon_ccu {
+			compatible = BCM21664_DT_AON_CCU_COMPAT;
+			reg = <0x35002000 0x0f00>;
+			#clock-cells = <1>;
+			clock-output-names = "hub_timer";
+		};
+
+		master_ccu: master_ccu {
+			compatible = BCM21664_DT_MASTER_CCU_COMPAT;
+			reg = <0x3f001000 0x0f00>;
+			#clock-cells = <1>;
+			clock-output-names = "sdio1",
+					     "sdio2",
+					     "sdio3",
+					     "sdio4",
+					     "sdio1_sleep",
+					     "sdio2_sleep",
+					     "sdio3_sleep",
+					     "sdio4_sleep";
+		};
+
+		slave_ccu: slave_ccu {
+			compatible = BCM21664_DT_SLAVE_CCU_COMPAT;
+			reg = <0x3e011000 0x0f00>;
+			#clock-cells = <1>;
+			clock-output-names = "uartb",
+					     "uartb2",
+					     "uartb3",
+					     "bsc1",
+					     "bsc2",
+					     "bsc3",
+					     "bsc4";
 		};
 	};
 
-- 
1.9.1

