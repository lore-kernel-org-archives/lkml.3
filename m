Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbaFZP4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:56:25 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:42115 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbaFZP4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:56:22 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v4 6/6] ARM: sun8i: Add basic clock nodes to the DTSI
Date: Thu, 26 Jun 2014 23:55:44 +0800
Message-Id: <1403798144-32188-7-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403798144-32188-1-git-send-email-wens@csie.org>
References: <1403798144-32188-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have support for sun8i specific clocks in the driver,
add the corresponding clock nodes to the DTSI. Also update the
existing peripherals with the correct clocks.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun8i-a23.dtsi | 125 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 120 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-a23.dtsi b/arch/arm/boot/dts/sun8i-a23.dtsi
index ac5f69a..79c4083 100644
--- a/arch/arm/boot/dts/sun8i-a23.dtsi
+++ b/arch/arm/boot/dts/sun8i-a23.dtsi
@@ -64,6 +64,121 @@
 			clock-frequency = <32768>;
 			clock-output-names = "osc32k";
 		};
+
+		pll1: clk@01c20000 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun8i-a23-pll1-clk";
+			reg = <0x01c20000 0x4>;
+			clocks = <&osc24M>;
+			clock-output-names = "pll1";
+		};
+
+		/* dummy clock until actually implemented */
+		pll6: pll6_clk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <600000000>;
+			clock-output-names = "pll6";
+		};
+
+		cpu: cpu_clk@01c20050 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-a10-cpu-clk";
+			reg = <0x01c20050 0x4>;
+
+			/*
+			 * PLL1 is listed twice here.
+			 * While it looks suspicious, it's actually documented
+			 * that way both in the datasheet and in the code from
+			 * Allwinner.
+			 */
+			clocks = <&osc32k>, <&osc24M>, <&pll1>, <&pll1>;
+			clock-output-names = "cpu";
+		};
+
+		axi: axi_clk@01c20050 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun8i-a23-axi-clk";
+			reg = <0x01c20050 0x4>;
+			clocks = <&cpu>;
+			clock-output-names = "axi";
+		};
+
+		ahb1_mux: ahb1_mux_clk@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun6i-a31-ahb1-mux-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&osc32k>, <&osc24M>, <&axi>, <&pll6>;
+			clock-output-names = "ahb1_mux";
+		};
+
+		ahb1: ahb1_clk@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-a10-ahb-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&ahb1_mux>;
+			clock-output-names = "ahb1";
+		};
+
+		apb1: apb1_clk@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-a10-apb0-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&ahb1>;
+			clock-output-names = "apb1";
+		};
+
+		ahb1_gates: clk@01c20060 {
+			#clock-cells = <1>;
+			compatible = "allwinner,sun8i-a23-ahb1-gates-clk";
+			reg = <0x01c20060 0x8>;
+			clocks = <&ahb1>;
+			clock-output-names = "ahb1_mipidsi", "ahb1_dma",
+					"ahb1_mmc0", "ahb1_mmc1", "ahb1_mmc2",
+					"ahb1_nand", "ahb1_sdram",
+					"ahb1_hstimer", "ahb1_spi0",
+					"ahb1_spi1", "ahb1_otg", "ahb1_ehci",
+					"ahb1_ohci", "ahb1_ve", "ahb1_lcd",
+					"ahb1_csi", "ahb1_be",	"ahb1_fe",
+					"ahb1_gpu", "ahb1_spinlock",
+					"ahb1_drc";
+		};
+
+		apb1_gates: clk@01c20068 {
+			#clock-cells = <1>;
+			compatible = "allwinner,sun8i-a23-apb1-gates-clk";
+			reg = <0x01c20068 0x4>;
+			clocks = <&apb1>;
+			clock-output-names = "apb1_codec", "apb1_pio",
+					"apb1_daudio0",	"apb1_daudio1";
+		};
+
+		apb2_mux: apb2_mux_clk@01c20058 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-a10-apb1-mux-clk";
+			reg = <0x01c20058 0x4>;
+			clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;
+			clock-output-names = "apb2_mux";
+		};
+
+		apb2: apb2_clk@01c20058 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun6i-a31-apb2-div-clk";
+			reg = <0x01c20058 0x4>;
+			clocks = <&apb2_mux>;
+			clock-output-names = "apb2";
+		};
+
+		apb2_gates: clk@01c2006c {
+			#clock-cells = <1>;
+			compatible = "allwinner,sun8i-a23-apb2-gates-clk";
+			reg = <0x01c2006c 0x4>;
+			clocks = <&apb2>;
+			clock-output-names = "apb2_i2c0", "apb2_i2c1",
+					"apb2_i2c2", "apb2_uart0",
+					"apb2_uart1", "apb2_uart2",
+					"apb2_uart3", "apb2_uart4";
+		};
 	};
 
 	soc@01c00000 {
@@ -92,7 +207,7 @@
 			interrupts = <0 0 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb2_gates 16>;
 			status = "disabled";
 		};
 
@@ -102,7 +217,7 @@
 			interrupts = <0 1 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb2_gates 17>;
 			status = "disabled";
 		};
 
@@ -112,7 +227,7 @@
 			interrupts = <0 2 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb2_gates 18>;
 			status = "disabled";
 		};
 
@@ -122,7 +237,7 @@
 			interrupts = <0 3 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb2_gates 19>;
 			status = "disabled";
 		};
 
@@ -132,7 +247,7 @@
 			interrupts = <0 4 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb2_gates 20>;
 			status = "disabled";
 		};
 
-- 
2.0.0

