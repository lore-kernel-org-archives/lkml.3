Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492Ab3CZJN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:13:27 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50966 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3CZJNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:13:25 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] ARM: sunxi: dt: Reorganize the dtsi
Date: Tue, 26 Mar 2013 10:13:08 +0100
Message-Id: <1364289198-11589-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the early days, the A10 and A13 shared quite some code. Nowadays it
shares less and less code, the A31 diverging even more, so it doesn't
make much sense to continue to maintain this structure, just use one
DTSI for every SoC, and that's it.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts |    2 +-
 arch/arm/boot/dts/sun4i-a10-hackberry.dts  |    2 +-
 arch/arm/boot/dts/sun4i-a10.dtsi           |  157 +++++++++++++++++++++++++--
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts  |    2 +-
 arch/arm/boot/dts/sun5i-a13.dtsi           |  145 ++++++++++++++++++++++++-
 arch/arm/boot/dts/sunxi.dtsi               |  159 ----------------------------
 6 files changed, 295 insertions(+), 172 deletions(-)
 delete mode 100644 arch/arm/boot/dts/sunxi.dtsi

diff --git a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
index cd06a3c..8e95845 100644
--- a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
+++ b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
@@ -26,7 +26,7 @@
 		bootargs = "earlyprintk console=ttyS0,115200";
 	};
 
-	soc {
+	soc@01c20000 {
 		pinctrl@01c20800 {
 			led_pins_cubieboard: led_pins@0 {
 				allwinner,pins = "PH20", "PH21";
diff --git a/arch/arm/boot/dts/sun4i-a10-hackberry.dts b/arch/arm/boot/dts/sun4i-a10-hackberry.dts
index 2046000..b9efac1 100644
--- a/arch/arm/boot/dts/sun4i-a10-hackberry.dts
+++ b/arch/arm/boot/dts/sun4i-a10-hackberry.dts
@@ -22,7 +22,7 @@
 		bootargs = "earlyprintk console=ttyS0,115200";
 	};
 
-	soc {
+	soc@01c20000 {
 		uart0: serial@01c28000 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&uart0_pins_a>;
diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 68a27fc..5c0920b 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -10,14 +10,123 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
-/include/ "sunxi.dtsi"
+/include/ "skeleton.dtsi"
 
 / {
+	interrupt-parent = <&intc>;
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,cortex-a8";
+		};
+	};
+
 	memory {
 		reg = <0x40000000 0x80000000>;
 	};
 
-	soc {
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/*
+		 * This is a dummy clock, to be used as placeholder on
+		 * other mux clocks when a specific parent clock is not
+		 * yet implemented. It should be dropped when the driver
+		 * is complete.
+		 */
+		dummy: dummy {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <0>;
+		};
+
+		osc24M_fixed: osc24M_fixed {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <24000000>;
+		};
+
+		osc24M: osc24M@01c20050 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-osc-clk";
+			reg = <0x01c20050 0x4>;
+			clocks = <&osc24M_fixed>;
+		};
+
+		osc32k: osc32k {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
+		};
+
+		pll1: pll1@01c20000 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-pll1-clk";
+			reg = <0x01c20000 0x4>;
+			clocks = <&osc24M>;
+		};
+
+		/* dummy is 200M */
+		cpu: cpu@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-cpu-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&osc32k>, <&osc24M>, <&pll1>, <&dummy>;
+		};
+
+		axi: axi@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-axi-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&cpu>;
+		};
+
+		ahb: ahb@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-ahb-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&axi>;
+		};
+
+		apb0: apb0@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-apb0-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&ahb>;
+		};
+
+		/* dummy is pll62 */
+		apb1_mux: apb1_mux@01c20058 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-apb1-mux-clk";
+			reg = <0x01c20058 0x4>;
+			clocks = <&osc24M>, <&dummy>, <&osc32k>;
+		};
+
+		apb1: apb1@01c20058 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-apb1-clk";
+			reg = <0x01c20058 0x4>;
+			clocks = <&apb1_mux>;
+		};
+	};
+
+	soc@01c20000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x01c20000 0x300000>;
+		ranges;
+
+		intc: interrupt-controller@01c20400 {
+			compatible = "allwinner,sunxi-ic";
+			reg = <0x01c20400 0x400>;
+			interrupt-controller;
+			#interrupt-cells = <1>;
+		};
+
 		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun4i-a10-pinctrl";
 			reg = <0x01c20800 0x400>;
@@ -48,13 +157,35 @@
 			};
 		};
 
+		timer@01c20c00 {
+			compatible = "allwinner,sunxi-timer";
+			reg = <0x01c20c00 0x90>;
+			interrupts = <22>;
+			clocks = <&osc24M>;
+		};
+
+		wdt: watchdog@01c20c90 {
+			compatible = "allwinner,sunxi-wdt";
+			reg = <0x01c20c90 0x10>;
+		};
+
 		uart0: serial@01c28000 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28000 0x400>;
 			interrupts = <1>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart1: serial@01c28400 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28400 0x400>;
+			interrupts = <2>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
 			status = "disabled";
 		};
 
@@ -64,7 +195,17 @@
 			interrupts = <3>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart3: serial@01c28c00 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28c00 0x400>;
+			interrupts = <4>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
 			status = "disabled";
 		};
 
@@ -74,7 +215,7 @@
 			interrupts = <17>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc>;
+			clocks = <&osc24M>;
 			status = "disabled";
 		};
 
@@ -84,7 +225,7 @@
 			interrupts = <18>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc>;
+			clocks = <&osc24M>;
 			status = "disabled";
 		};
 
@@ -94,7 +235,7 @@
 			interrupts = <19>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc>;
+			clocks = <&osc24M>;
 			status = "disabled";
 		};
 
@@ -104,7 +245,7 @@
 			interrupts = <20>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
-			clocks = <&osc>;
+			clocks = <&osc24M>;
 			status = "disabled";
 		};
 	};
diff --git a/arch/arm/boot/dts/sun5i-a13-olinuxino.dts b/arch/arm/boot/dts/sun5i-a13-olinuxino.dts
index f1579a8..3ca5506 100644
--- a/arch/arm/boot/dts/sun5i-a13-olinuxino.dts
+++ b/arch/arm/boot/dts/sun5i-a13-olinuxino.dts
@@ -22,7 +22,7 @@
 		bootargs = "earlyprintk console=ttyS0,115200";
 	};
 
-	soc {
+	soc@01c20000 {
 		pinctrl@01c20800 {
 			led_pins_olinuxino: led_pins@0 {
 				allwinner,pins = "PG9";
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 945bfac..fdc5346 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -11,14 +11,123 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
-/include/ "sunxi.dtsi"
+/include/ "skeleton.dtsi"
 
 / {
+	interrupt-parent = <&intc>;
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,cortex-a8";
+		};
+	};
+
 	memory {
 		reg = <0x40000000 0x20000000>;
 	};
 
-	soc {
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/*
+		 * This is a dummy clock, to be used as placeholder on
+		 * other mux clocks when a specific parent clock is not
+		 * yet implemented. It should be dropped when the driver
+		 * is complete.
+		 */
+		dummy: dummy {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <0>;
+		};
+
+		osc24M_fixed: osc24M_fixed {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <24000000>;
+		};
+
+		osc24M: osc24M@01c20050 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-osc-clk";
+			reg = <0x01c20050 0x4>;
+			clocks = <&osc24M_fixed>;
+		};
+
+		osc32k: osc32k {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
+		};
+
+		pll1: pll1@01c20000 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-pll1-clk";
+			reg = <0x01c20000 0x4>;
+			clocks = <&osc24M>;
+		};
+
+		/* dummy is 200M */
+		cpu: cpu@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-cpu-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&osc32k>, <&osc24M>, <&pll1>, <&dummy>;
+		};
+
+		axi: axi@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-axi-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&cpu>;
+		};
+
+		ahb: ahb@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-ahb-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&axi>;
+		};
+
+		apb0: apb0@01c20054 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-apb0-clk";
+			reg = <0x01c20054 0x4>;
+			clocks = <&ahb>;
+		};
+
+		/* dummy is pll62 */
+		apb1_mux: apb1_mux@01c20058 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-apb1-mux-clk";
+			reg = <0x01c20058 0x4>;
+			clocks = <&osc24M>, <&dummy>, <&osc32k>;
+		};
+
+		apb1: apb1@01c20058 {
+			#clock-cells = <0>;
+			compatible = "allwinner,sunxi-apb1-clk";
+			reg = <0x01c20058 0x4>;
+			clocks = <&apb1_mux>;
+		};
+	};
+
+	soc@01c20000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x01c20000 0x300000>;
+		ranges;
+
+		intc: interrupt-controller@01c20400 {
+			compatible = "allwinner,sunxi-ic";
+			reg = <0x01c20400 0x400>;
+			interrupt-controller;
+			#interrupt-cells = <1>;
+		};
+
 		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun5i-a13-pinctrl";
 			reg = <0x01c20800 0x400>;
@@ -41,5 +150,37 @@
 				allwinner,pull = <0>;
 			};
 		};
+
+		timer@01c20c00 {
+			compatible = "allwinner,sunxi-timer";
+			reg = <0x01c20c00 0x90>;
+			interrupts = <22>;
+			clocks = <&osc24M>;
+		};
+
+		wdt: watchdog@01c20c90 {
+			compatible = "allwinner,sunxi-wdt";
+			reg = <0x01c20c90 0x10>;
+		};
+
+		uart1: serial@01c28400 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28400 0x400>;
+			interrupts = <2>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
+
+		uart3: serial@01c28c00 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28c00 0x400>;
+			interrupts = <4>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc24M>;
+			status = "disabled";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/sunxi.dtsi b/arch/arm/boot/dts/sunxi.dtsi
deleted file mode 100644
index cafd393..0000000
--- a/arch/arm/boot/dts/sunxi.dtsi
+++ /dev/null
@@ -1,159 +0,0 @@
-/*
- * Copyright 2012 Maxime Ripard
- *
- * Maxime Ripard <maxime.ripard@free-electrons.com>
- *
- * The code contained herein is licensed under the GNU General Public
- * License. You may obtain a copy of the GNU General Public License
- * Version 2 or later at the following locations:
- *
- * http://www.opensource.org/licenses/gpl-license.html
- * http://www.gnu.org/copyleft/gpl.html
- */
-
-/include/ "skeleton.dtsi"
-
-/ {
-	interrupt-parent = <&intc>;
-
-	cpus {
-		cpu@0 {
-			compatible = "arm,cortex-a8";
-		};
-	};
-
-	clocks {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		/*
-		 * This is a dummy clock, to be used as placeholder on
-		 * other mux clocks when a specific parent clock is not
-		 * yet implemented. It should be dropped when the driver
-		 * is complete.
-		 */
-		dummy: dummy {
-			#clock-cells = <0>;
-			compatible = "fixed-clock";
-			clock-frequency = <0>;
-		};
-
-		osc24M_fixed: osc24M_fixed {
-			#clock-cells = <0>;
-			compatible = "fixed-clock";
-			clock-frequency = <24000000>;
-		};
-
-		osc24M: osc24M@01c20050 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sunxi-osc-clk";
-			reg = <0x01c20050 0x4>;
-			clocks = <&osc24M_fixed>;
-		};
-
-		osc32k: osc32k {
-			#clock-cells = <0>;
-			compatible = "fixed-clock";
-			clock-frequency = <32768>;
-		};
-
-		pll1: pll1@01c20000 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sunxi-pll1-clk";
-			reg = <0x01c20000 0x4>;
-			clocks = <&osc24M>;
-		};
-
-		/* dummy is 200M */
-		cpu: cpu@01c20054 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sunxi-cpu-clk";
-			reg = <0x01c20054 0x4>;
-			clocks = <&osc32k>, <&osc24M>, <&pll1>, <&dummy>;
-		};
-
-		axi: axi@01c20054 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sunxi-axi-clk";
-			reg = <0x01c20054 0x4>;
-			clocks = <&cpu>;
-		};
-
-		ahb: ahb@01c20054 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sunxi-ahb-clk";
-			reg = <0x01c20054 0x4>;
-			clocks = <&axi>;
-		};
-
-		apb0: apb0@01c20054 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sunxi-apb0-clk";
-			reg = <0x01c20054 0x4>;
-			clocks = <&ahb>;
-		};
-
-		/* dummy is pll62 */
-		apb1_mux: apb1_mux@01c20058 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sunxi-apb1-mux-clk";
-			reg = <0x01c20058 0x4>;
-			clocks = <&osc24M>, <&dummy>, <&osc32k>;
-		};
-
-		apb1: apb1@01c20058 {
-			#clock-cells = <0>;
-			compatible = "allwinner,sunxi-apb1-clk";
-			reg = <0x01c20058 0x4>;
-			clocks = <&apb1_mux>;
-		};
-	};
-
-	soc {
-		compatible = "simple-bus";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		reg = <0x01c20000 0x300000>;
-		ranges;
-
-		timer@01c20c00 {
-			compatible = "allwinner,sunxi-timer";
-			reg = <0x01c20c00 0x90>;
-			interrupts = <22>;
-			clocks = <&osc24M>;
-		};
-
-		wdt: watchdog@01c20c90 {
-			compatible = "allwinner,sunxi-wdt";
-			reg = <0x01c20c90 0x10>;
-		};
-
-		intc: interrupt-controller@01c20400 {
-			compatible = "allwinner,sunxi-ic";
-			reg = <0x01c20400 0x400>;
-			interrupt-controller;
-			#interrupt-cells = <1>;
-		};
-
-		uart1: serial@01c28400 {
-			compatible = "snps,dw-apb-uart";
-			reg = <0x01c28400 0x400>;
-			interrupts = <2>;
-			reg-shift = <2>;
-			reg-io-width = <4>;
-			clocks = <&osc>;
-			status = "disabled";
-		};
-
-		uart3: serial@01c28c00 {
-			compatible = "snps,dw-apb-uart";
-			reg = <0x01c28c00 0x400>;
-			interrupts = <4>;
-			reg-shift = <2>;
-			reg-io-width = <4>;
-			clocks = <&osc>;
-			status = "disabled";
-		};
-	};
-};
-- 
1.7.10.4

