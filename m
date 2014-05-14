Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaENUQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:16:23 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:58457 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaENUPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:15:40 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jisheng Zhang <jszhang@marvell.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/10] ARM: dts: berlin: convert BG2CD to DT clock nodes
Date: Wed, 14 May 2014 22:15:19 +0200
Message-Id: <1400098522-14770-9-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1400098522-14770-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1400098522-14770-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts Berlin BG2CD SoC dtsi to make use of the new DT clock
nodes for Berlin SoCs. Also add a binding include to ease core clock
references.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- dropped of_clk_create_name() usage required unique node names for
  clocks and plls
- added clock-output-names to allow fixed-factor-clock to find its
  parent name

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jisheng Zhang <jszhang@marvell.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/berlin2cd.dtsi | 205 +++++++++++++++++++++++++++++++++------
 1 file changed, 177 insertions(+), 28 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
index 6eb1bdae23ac..818c7557bad5 100644
--- a/arch/arm/boot/dts/berlin2cd.dtsi
+++ b/arch/arm/boot/dts/berlin2cd.dtsi
@@ -12,6 +12,7 @@
  */
 
 #include "skeleton.dtsi"
+#include <dt-bindings/clock/berlin2.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 
 / {
@@ -30,24 +31,18 @@
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
-			clock-frequency = <75000000>;
-		};
+	refclk: oscillator {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <25000000>;
+	};
 
-		sysclk: system-clock {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <300000000>;
-		};
+	twdclk: twdclk {
+		compatible = "fixed-factor-clock";
+		#clock-cells = <0>;
+		clocks = <&coreclk CLKID_CPU>;
+		clock-mult = <1>;
+		clock-div = <3>;
 	};
 
 	soc {
@@ -76,7 +71,7 @@
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xad0600 0x20>;
 			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&sysclk>;
+			clocks = <&twdclk>;
 		};
 
 		apb@e80000 {
@@ -163,7 +158,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c00 0x14>;
 				interrupts = <8>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "okay";
 			};
@@ -172,7 +167,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c14 0x14>;
 				interrupts = <9>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "okay";
 			};
@@ -181,7 +176,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c28 0x14>;
 				interrupts = <10>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -190,7 +185,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c3c 0x14>;
 				interrupts = <11>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -199,7 +194,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c50 0x14>;
 				interrupts = <12>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -208,7 +203,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c64 0x14>;
 				interrupts = <13>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -217,7 +212,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c78 0x14>;
 				interrupts = <14>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -226,7 +221,7 @@
 				compatible = "snps,dw-apb-timer";
 				reg = <0x2c8c 0x14>;
 				interrupts = <15>;
-				clocks = <&cfgclk>;
+				clocks = <&coreclk CLKID_CFG>;
 				clock-names = "timer";
 				status = "disabled";
 			};
@@ -241,6 +236,160 @@
 			};
 		};
 
+		syspll: syspll@ea0014 {
+			compatible = "marvell,berlin2-pll";
+			#clock-cells = <0>;
+			reg = <0xea0014 0x14>;
+			clocks = <&refclk>;
+		};
+
+		mempll: mempll@ea0028 {
+			compatible = "marvell,berlin2-pll";
+			#clock-cells = <0>;
+			reg = <0xea0028 0x14>;
+			clocks = <&refclk>;
+		};
+
+		cpupll: cpupll@ea003c {
+			compatible = "marvell,berlin2-pll";
+			#clock-cells = <0>;
+			reg = <0xea003c 0x14>;
+			clocks = <&refclk>;
+		};
+
+		avpll: avpll@ea0040 {
+			compatible = "marvell,berlin2-avpll";
+			#clock-cells = <2>;
+			reg = <0xea0050 0x100>;
+			clocks = <&refclk>;
+		};
+
+		coreclk: core-clock@ea0150 {
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
+			clock-output-names = "sys", "cpu", "drmfigo", "cfg",
+				"gfx", "zsp", "perif", "pcube", "vscope",
+				"nfc_ecc", "vpp", "app", "audio0", "audio2",
+				"audio3", "audio1", "geth0", "geth1", "sata",
+				"ahbapb", "usb0", "usb1", "pbridge", "sdio0",
+				"sdio1", "nfc", "smemc", "audiohd", "video0",
+				"video1", "video2";
+		};
+
+		gfx3dcore_clk: gfx3dcore@ea022c {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea022c 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		gfx3dsys_clk: gfx3dsys@ea0230 {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea0230 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		arc_clk: arc@ea0234 {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea0234 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		vip_clk: vip@ea0238 {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea0238 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		sdio0xin_clk: sdio0xin@ea023c {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea023c 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		sdio1xin_clk: sdio1xin@ea0240 {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea0240 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		gfx3dextra_clk: gfx3dextra@ea0244 {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea0244 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		gc360_clk: gc360@ea024c {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea024c 0x4>;
+			clocks = <&syspll>,
+				<&avpll 1 4>, <&avpll 1 5>,
+				<&avpll 1 6>, <&avpll 1 7>;
+			clock-names = "mux_bypass",
+				"mux0", "mux1", "mux2", "mux3";
+		};
+
+		sdio_dllmst_clk: sdio_dllmst@ea0250 {
+			compatible = "marvell,berlin2-clk-div";
+			#clock-cells = <0>;
+			reg = <0xea0250 0x4>;
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
@@ -285,7 +434,7 @@
 				reg-shift = <2>;
 				reg-io-width = <1>;
 				interrupts = <8>;
-				clocks = <&smclk>;
+				clocks = <&refclk>;
 				status = "disabled";
 			};
 
@@ -295,7 +444,7 @@
 				reg-shift = <2>;
 				reg-io-width = <1>;
 				interrupts = <9>;
-				clocks = <&smclk>;
+				clocks = <&refclk>;
 				status = "disabled";
 			};
 
-- 
1.9.1

