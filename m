Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3HQTJC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 15:09:02 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50997 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754459Ab3HQTJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 15:09:00 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/2] ARM: sun7i: Enable the A20 clocks in the DTSI
Date: Sat, 17 Aug 2013 21:08:43 +0200
Message-Id: <1376766523-9107-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376766523-9107-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1376766523-9107-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the clock driver knows about the available clocks found on the
A20, we can build up the clock tree from the device tree.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 126 +++++++++++++++++++++++++++++++++++----
 1 file changed, 116 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index da1411b..fb81e78 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -44,7 +44,8 @@
 
 		osc24M: osc24M@01c20050 {
 			#clock-cells = <0>;
-			compatible = "fixed-clock";
+			compatible = "allwinner,sun4i-osc-clk";
+			reg = <0x01c20050 0x4>;
 			clock-frequency = <24000000>;
 		};
 
@@ -53,6 +54,111 @@
 			compatible = "fixed-clock";
 			clock-frequency = <32768>;
 		};
+
+		pll1: pll1@01c20000 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-pll1-clk";
+			reg = <0x01c20000 0x4>;
+			clocks = <&osc24M>;
+		};
+
+		/*
+		 * This is a dummy clock, to be used as placeholder on
+		 * other mux clocks when a specific parent clock is not
+		 * yet implemented. It should be dropped when the driver
+		 * is complete.
+		 */
+		pll6: pll6 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <0>;
+		};
+
+		cpu: cpu@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-cpu-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&osc32k>, <&osc24M>, <&pll1>, <&pll6>;
+		};
+
+		axi: axi@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-axi-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&cpu>;
+		};
+
+		ahb: ahb@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-ahb-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&axi>;
+		};
+
+		ahb_gates: ahb_gates@01c20060 {
+			#clock-cells = <1>;
+			compatible = "allwinner,sun7i-a20-ahb-gates-clk";
+			reg = <0x01c20060 0x8>;
+			clocks = <&ahb>;
+			clock-output-names = "ahb_usb0", "ahb_ehci0",
+				"ahb_ohci0", "ahb_ehci1", "ahb_ohci1",
+				"ahb_ss", "ahb_dma", "ahb_bist", "ahb_mmc0",
+				"ahb_mmc1", "ahb_mmc2", "ahb_mmc3", "ahb_ms",
+				"ahb_nand", "ahb_sdram", "ahb_ace",
+				"ahb_emac", "ahb_ts", "ahb_spi0", "ahb_spi1",
+				"ahb_spi2", "ahb_spi3", "ahb_sata",
+				"ahb_hstimer", "ahb_ve", "ahb_tvd", "ahb_tve0",
+				"ahb_tve1", "ahb_lcd0", "ahb_lcd1", "ahb_csi0",
+				"ahb_csi1", "ahb_hdmi1", "ahb_hdmi0",
+				"ahb_de_be0", "ahb_de_be1", "ahb_de_fe0",
+				"ahb_de_fe1", "ahb_gmac", "ahb_mp",
+				"ahb_mali";
+		};
+
+		apb0: apb0@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-apb0-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&ahb>;
+		};
+
+		apb0_gates: apb0_gates@01c20068 {
+			#clock-cells = <1>;
+			compatible = "allwinner,sun7i-a20-apb0-gates-clk";
+			reg = <0x01c20068 0x4>;
+			clocks = <&apb0>;
+			clock-output-names = "apb0_codec", "apb0_spdif",
+				"apb0_ac97", "apb0_iis0", "apb0_iis1",
+				"apb0_pio", "apb0_ir0", "apb0_ir1",
+				"apb0_iis2", "apb0_keypad";
+		};
+
+		apb1_mux: apb1_mux@01c20058 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-apb1-mux-clk";
+			reg = <0x01c20058 0x4>;
+			clocks = <&osc24M>, <&pll6>, <&osc32k>;
+		};
+
+		apb1: apb1@01c20058 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sun4i-apb1-clk";
+			reg = <0x01c20058 0x4>;
+			clocks = <&apb1_mux>;
+		};
+
+		apb1_gates: apb1_gates@01c2006c {
+			#clock-cells = <1>;
+			compatible = "allwinner,sun7i-a20-apb1-gates-clk";
+			reg = <0x01c2006c 0x4>;
+			clocks = <&apb1>;
+			clock-output-names = "apb1_i2c0", "apb1_i2c1",
+				"apb1_i2c2", "apb1_i2c3", "apb1_can",
+				"apb1_scr", "apb1_ps20", "apb1_ps21",
+				"apb1_i2c4", "apb1_uart0", "apb1_uart1",
+				"apb1_uart2", "apb1_uart3", "apb1_uart4",
+				"apb1_uart5", "apb1_uart6", "apb1_uart7";
+		};
 	};
 
 	soc@01c00000 {
@@ -65,7 +171,7 @@
 			compatible = "allwinner,sun7i-a20-pinctrl";
 			reg = <0x01c20800 0x400>;
 			interrupts = <0 28 1>;
-			clocks = <&osc24M>;
+			clocks = <&apb0_gates 5>;
 			gpio-controller;
 			interrupt-controller;
 			#address-cells = <1>;
@@ -117,7 +223,7 @@
 			interrupts = <0 1 1>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb1_gates 16>;
 			status = "disabled";
 		};
 
@@ -127,7 +233,7 @@
 			interrupts = <0 2 1>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb1_gates 17>;
 			status = "disabled";
 		};
 
@@ -137,7 +243,7 @@
 			interrupts = <0 3 1>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb1_gates 18>;
 			status = "disabled";
 		};
 
@@ -147,7 +253,7 @@
 			interrupts = <0 4 1>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb1_gates 19>;
 			status = "disabled";
 		};
 
@@ -157,7 +263,7 @@
 			interrupts = <0 17 1>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb1_gates 20>;
 			status = "disabled";
 		};
 
@@ -167,7 +273,7 @@
 			interrupts = <0 18 1>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb1_gates 21>;
 			status = "disabled";
 		};
 
@@ -177,7 +283,7 @@
 			interrupts = <0 19 1>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb1_gates 22>;
 			status = "disabled";
 		};
 
@@ -187,7 +293,7 @@
 			interrupts = <0 20 1>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc24M>;
+			clocks = <&apb1_gates 23>;
 			status = "disabled";
 		};
 
-- 
1.8.3.4

