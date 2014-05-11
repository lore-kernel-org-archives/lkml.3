Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbaEKUZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 16:25:34 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:37537 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137AbaEKUYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 16:24:54 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] ARM: dts: berlin: convert BG2 to DT clock nodes
Date: Sun, 11 May 2014 22:24:41 +0200
Message-Id: <1399839881-29895-9-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts Berlin BG2 SoC dtsi to make use of the new DT clock
nodes for Berlin SoCs. While at it, also fix up twdclk which is
running at cpuclk/3 instead of sysclk.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/berlin2.dtsi | 200 +++++++++++++++++++++++++++++++++++------
 1 file changed, 171 insertions(+), 29 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
index 56a1af2f1052..5d84171a1e4b 100644
--- a/arch/arm/boot/dts/berlin2.dtsi
+++ b/arch/arm/boot/dts/berlin2.dtsi
@@ -12,6 +12,7 @@
  */
 
 #include "skeleton.dtsi"
+#include <dt-bindings/clock/berlin2.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 
 / {
@@ -37,24 +38,18 @@
 		};
 	};
 
-	clocks {
-		smclk: sysmgr-clock {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <25000000>;
-		};
-
-		cfgclk: cfg-clock {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <100000000>;
-		};
+	refclk: oscillator {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <25000000>;
+	};
 
-		sysclk: system-clock {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <400000000>;
-		};
+	twdclk: twdclk {
+		compatible = "fixed-factor-clock";
+		#clock-cells = <0>;
+		clocks = <&coreclk CLKID_CPU>;
+		clock-mult = <1>;
+		clock-div = <3>;
 	};
 
 	soc {
@@ -83,7 +78,7 @@
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xad0600 0x20>;
 			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&sysclk>;
+			clocks = <&twdclk>;
 		};
 
 		apb@e80000 {
@@ -98,7 +93,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c00 0x14>;
 				interrupts = <8>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "okay";
 			};
@@ -107,7 +102,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c14 0x14>;
 				interrupts = <9>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "okay";
 			};
@@ -116,7 +111,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c28 0x14>;
 				interrupts = <10>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -125,7 +120,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c3c 0x14>;
 				interrupts = <11>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -134,7 +129,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c50 0x14>;
 				interrupts = <12>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -143,7 +138,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c64 0x14>;
 				interrupts = <13>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -152,7 +147,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c78 0x14>;
 				interrupts = <14>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -161,7 +156,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c8c 0x14>;
 				interrupts = <15>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -176,6 +171,153 @@
 			};
 		};
 
+		syspll: pll@ea0014 {
+			compatible = "marvell,berlin2-pll";
+			#clock-cells = <0>;
+			reg = <0xea0014 0x14>;
+			clocks = <&refclk>;
+		};
+
+		mempll: pll@ea0028 {
+			compatible = "marvell,berlin2-pll";
+			#clock-cells = <0>;
+			reg = <0xea0028 0x14>;
+			clocks = <&refclk>;
+		};
+
+		cpupll: pll@ea003c {
+			compatible = "marvell,berlin2-pll";
+			#clock-cells = <0>;
+			reg = <0xea003c 0x14>;
+			clocks = <&refclk>;
+		};
+
+		avpll: pll@ea0040 {
+			compatible = "marvell,berlin2-avpll";
+			#clock-cells = <2>;
+			reg = <0xea0050 0x100>;
+			clocks = <&refclk>;
+		};
+
+		coreclk: clock@ea0150 {
+			compatible = "marvell,berlin2-core-clocks";
+			#clock-cells = <1>;
+			reg = <0xea0150 0x1c>;
+			clocks = <&refclk>, <&syspll>, <&mempll>, <&cpupll>,
+				<&avpll 0 1>, <&avpll 0 2>,
+				<&avpll 0 3>, <&avpll 0 4>,
+				<&avpll 0 5>, <&avpll 0 6>,
+				<&avpll 0 7>, <&avpll 0 8>,
+				<&avpll 1 1>, <&avpll 1 2>,
+				<&avpll 1 3>, <&avpll 1 4>,
+				<&avpll 1 5>, <&avpll 1 6>,
+				<&avpll 1 7>, <&avpll 1 8>;
+			clock-names = "refclk", "syspll", "mempll", "cpupll",
+				"avpll_a1", "avpll_a2", "avpll_a3", "avpll_a4",
+				"avpll_a5", "avpll_a6", "avpll_a7", "avpll_a8",
+				"avpll_b1", "avpll_b2", "avpll_b3", "avpll_b4",
+				"avpll_b5", "avpll_b6", "avpll_b7", "avpll_b8";
+		};
+
+		gfx3dcore_clk: clock@ea022c {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea0022c 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		gfx3dsys_clk: clock@ea0230 {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea00230 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		arc_clk: clock@ea0234 {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea00234 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		vip_clk: clock@ea0238 {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea00238 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		sdio0xin_clk: clock@ea023c {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea0023c 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		sdio1xin_clk: clock@ea0240 {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea00240 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		gfx3dextra_clk: clock@ea0244 {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea00244 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		gc360_clk: clock@ea024c {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea0024c 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		sdio_dllmst_clk: clock@ea0250 {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea00250 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
 		apb@fc0000 {
 			compatible = "simple-bus";
 			#address-cells = <1>;
@@ -190,7 +332,7 @@
 				reg-shift = <2>;
 				reg-io-width = <1>;
 				interrupts = <8>;
-				clocks = <&smclk>;
+				clocks = <&refclk>;
 				status = "disabled";
 			};
 
@@ -200,7 +342,7 @@
 				reg-shift = <2>;
 				reg-io-width = <1>;
 				interrupts = <9>;
-				clocks = <&smclk>;
+				clocks = <&refclk>;
 				status = "disabled";
 			};
 
@@ -210,7 +352,7 @@
 				reg-shift = <2>;
 				reg-io-width = <1>;
 				interrupts = <10>;
-				clocks = <&smclk>;
+				clocks = <&refclk>;
 				status = "disabled";
 			};
 
-- 
1.9.1

