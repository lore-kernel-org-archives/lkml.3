Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaKGL7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:59:03 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45182 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaKGL6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:58:44 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH 11/13] ARM: STi: DT: STih407: Abstract common dt nodes into shared files.
Date: Fri,  7 Nov 2014 11:57:53 +0000
Message-Id: <1415361475-6218-12-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stih410 soc which will be added in the following commit is very similar to
the stih407, to enable maximum re-use of the dt files this commit abstracts the
common parts into a shared dt file stihxxx-b2120 for the board, and also a shared
file stih407-family.dtsi for the SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stih407-b2120.dts   |  67 +-----
 arch/arm/boot/dts/stih407-family.dtsi | 384 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stih407.dtsi        | 385 ----------------------------------
 arch/arm/boot/dts/stihxxx-b2120.dtsi  |  73 +++++++
 4 files changed, 460 insertions(+), 449 deletions(-)
 create mode 100644 arch/arm/boot/dts/stih407-family.dtsi
 delete mode 100644 arch/arm/boot/dts/stih407.dtsi
 create mode 100644 arch/arm/boot/dts/stihxxx-b2120.dtsi

diff --git a/arch/arm/boot/dts/stih407-b2120.dts b/arch/arm/boot/dts/stih407-b2120.dts
index fe69f92..e0057bf 100644
--- a/arch/arm/boot/dts/stih407-b2120.dts
+++ b/arch/arm/boot/dts/stih407-b2120.dts
@@ -7,72 +7,11 @@
  * published by the Free Software Foundation.
  */
 /dts-v1/;
-#include "stih407.dtsi"
+#include "stih407-clock.dtsi"
+#include "stih407-family.dtsi"
+#include "stihxxx-b2120.dtsi"
 / {
 	model = "STiH407 B2120";
 	compatible = "st,stih407-b2120", "st,stih407";
 
-	chosen {
-		bootargs = "console=ttyAS0,115200";
-		linux,stdout-path = &sbc_serial0;
-	};
-
-	memory {
-		device_type = "memory";
-		reg = <0x40000000 0x80000000>;
-	};
-
-	aliases {
-		ttyAS0 = &sbc_serial0;
-	};
-
-	soc {
-		sbc_serial0: serial@9530000 {
-			status = "okay";
-		};
-
-		leds {
-			compatible = "gpio-leds";
-			red {
-				#gpio-cells = <2>;
-				label = "Front Panel LED";
-				gpios = <&pio4 1 0>;
-				linux,default-trigger = "heartbeat";
-			};
-			green {
-				#gpio-cells = <2>;
-				gpios = <&pio1 3 0>;
-				default-state = "off";
-			};
-		};
-
-		i2c@9842000 {
-			status = "okay";
-		};
-
-		i2c@9843000 {
-			status = "okay";
-		};
-
-		i2c@9844000 {
-			status = "okay";
-		};
-
-		i2c@9845000 {
-			status = "okay";
-		};
-
-		i2c@9540000 {
-			status = "okay";
-		};
-
-		/* SSC11 to HDMI */
-		i2c@9541000 {
-			status = "okay";
-			/* HDMI V1.3a supports Standard mode only */
-			clock-frequency = <100000>;
-			st,i2c-min-scl-pulse-width-us = <0>;
-			st,i2c-min-sda-pulse-width-us = <5>;
-		};
-	};
 };
diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
new file mode 100644
index 0000000..c15e65b
--- /dev/null
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -0,0 +1,384 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics Limited.
+ * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+#include "stih407-pinctrl.dtsi"
+#include <dt-bindings/reset-controller/stih407-resets.h>
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0>;
+		};
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <1>;
+		};
+	};
+
+	intc: interrupt-controller@08761000 {
+		compatible = "arm,cortex-a9-gic";
+		#interrupt-cells = <3>;
+		interrupt-controller;
+		reg = <0x08761000 0x1000>, <0x08760100 0x100>;
+	};
+
+	scu@08760000 {
+		compatible = "arm,cortex-a9-scu";
+		reg = <0x08760000 0x1000>;
+	};
+
+	timer@08760200 {
+		interrupt-parent = <&intc>;
+		compatible = "arm,cortex-a9-global-timer";
+		reg = <0x08760200 0x100>;
+		interrupts = <GIC_PPI 11 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&arm_periph_clk>;
+	};
+
+	l2: cache-controller {
+		compatible = "arm,pl310-cache";
+		reg = <0x08762000 0x1000>;
+		arm,data-latency = <3 3 3>;
+		arm,tag-latency = <2 2 2>;
+		cache-unified;
+		cache-level = <2>;
+	};
+
+	soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		interrupt-parent = <&intc>;
+		ranges;
+		compatible = "simple-bus";
+
+		powerdown: powerdown-controller {
+			compatible = "st,stih407-powerdown";
+			#reset-cells = <1>;
+		};
+
+		softreset: softreset-controller {
+			compatible = "st,stih407-softreset";
+			#reset-cells = <1>;
+		};
+
+		picophyreset: picophyreset-controller {
+			compatible = "st,stih407-picophyreset";
+			#reset-cells = <1>;
+		};
+
+		syscfg_sbc: sbc-syscfg@9620000 {
+			compatible = "st,stih407-sbc-syscfg", "syscon";
+			reg = <0x9620000 0x1000>;
+		};
+
+		syscfg_front: front-syscfg@9280000 {
+			compatible = "st,stih407-front-syscfg", "syscon";
+			reg = <0x9280000 0x1000>;
+		};
+
+		syscfg_rear: rear-syscfg@9290000 {
+			compatible = "st,stih407-rear-syscfg", "syscon";
+			reg = <0x9290000 0x1000>;
+		};
+
+		syscfg_flash: flash-syscfg@92a0000 {
+			compatible = "st,stih407-flash-syscfg", "syscon";
+			reg = <0x92a0000 0x1000>;
+		};
+
+		syscfg_sbc_reg: fvdp-lite-syscfg@9600000 {
+			compatible = "st,stih407-sbc-reg-syscfg", "syscon";
+			reg = <0x9600000 0x1000>;
+		};
+
+		syscfg_core: core-syscfg@92b0000 {
+			compatible = "st,stih407-core-syscfg", "syscon";
+			reg = <0x92b0000 0x1000>;
+		};
+
+		syscfg_lpm: lpm-syscfg@94b5100 {
+			compatible = "st,stih407-lpm-syscfg", "syscon";
+			reg = <0x94b5100 0x1000>;
+		};
+
+		serial@9830000 {
+			compatible = "st,asc";
+			reg = <0x9830000 0x2c>;
+			interrupts = <GIC_SPI 122 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_serial0>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+
+			status = "disabled";
+		};
+
+		serial@9831000 {
+			compatible = "st,asc";
+			reg = <0x9831000 0x2c>;
+			interrupts = <GIC_SPI 123 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_serial1>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+
+			status = "disabled";
+		};
+
+		serial@9832000 {
+			compatible = "st,asc";
+			reg = <0x9832000 0x2c>;
+			interrupts = <GIC_SPI 124 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_serial2>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+
+			status = "disabled";
+		};
+
+		/* SBC_ASC0 - UART10 */
+		sbc_serial0: serial@9530000 {
+			compatible = "st,asc";
+			reg = <0x9530000 0x2c>;
+			interrupts = <GIC_SPI 138 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_sbc_serial0>;
+			clocks = <&clk_sysin>;
+
+			status = "disabled";
+		};
+
+		serial@9531000 {
+			compatible = "st,asc";
+			reg = <0x9531000 0x2c>;
+			interrupts = <GIC_SPI 139 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_sbc_serial1>;
+			clocks = <&clk_sysin>;
+
+			status = "disabled";
+		};
+
+		i2c@9840000 {
+			compatible = "st,comms-ssc4-i2c";
+			interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
+			reg = <0x9840000 0x110>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c0_default>;
+
+			status = "disabled";
+		};
+
+		i2c@9841000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9841000 0x110>;
+			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c1_default>;
+
+			status = "disabled";
+		};
+
+		i2c@9842000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9842000 0x110>;
+			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c2_default>;
+
+			status = "disabled";
+		};
+
+		i2c@9843000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9843000 0x110>;
+			interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c3_default>;
+
+			status = "disabled";
+		};
+
+		i2c@9844000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9844000 0x110>;
+			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c4_default>;
+
+			status = "disabled";
+		};
+
+		i2c@9845000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9845000 0x110>;
+			interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c5_default>;
+
+			status = "disabled";
+		};
+
+
+		/* SSCs on SBC */
+		i2c@9540000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9540000 0x110>;
+			interrupts = <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_sysin>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c10_default>;
+
+			status = "disabled";
+		};
+
+		i2c@9541000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9541000 0x110>;
+			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_sysin>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c11_default>;
+
+			status = "disabled";
+		};
+
+		/* Generic picoPHY */
+		usb2_picophy0: usbpicophy@0 {
+			compatible = "st,stih407-usb2-phy";
+			reg =	<0xf8 0x04>,	/* syscfg 5062 */
+				<0xf4 0x04>;    /* syscfg 5061 */
+			reg-names =	"param",
+					"ctrl";
+			#phy-cells = <0>;
+
+			st,syscfg = <&syscfg_core>;
+			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
+				 <&picophyreset STIH407_PICOPHY0_RESET>;
+			reset-names = "global",
+				      "port";
+		};
+
+		usb2_picophy1: usbpicophy@1 {
+			compatible = "st,stih407-usb2-phy";
+			#phy-cells = <0>;
+			reg =	<0xfc 0x04>,	/* syscfg 5063 */
+				<0xf4 0x04>;    /* syscfg 5061 */
+			reg-names =	"param",
+					"ctrl";
+
+			st,syscfg = <&syscfg_core>;
+			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
+				 <&picophyreset STIH407_PICOPHY1_RESET>;
+			reset-names = "global",
+				      "port";
+		};
+
+		usb2_picophy2: usbpicophy@2 {
+			compatible = "st,stih407-usb2-phy";
+			#phy-cells = <0>;
+			reg =	<0x100 0x04>,	/* syscfg 5064 */
+				<0xf4 0x04>;    /* syscfg 5061 */
+			reg-names =	"param",
+					"ctrl";
+
+			st,syscfg = <&syscfg_core>;
+			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
+				 <&picophyreset STIH407_PICOPHY2_RESET>;
+			reset-names = "global",
+				      "port";
+		};
+
+		ohci0: usb@9a03c00 {
+			compatible = "st,st-ohci-300x";
+			status = "disabled";
+			reg = <0x9a03c00 0x100>;
+			interrupts = <GIC_SPI 180 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
+			resets = <&powerdown STIH407_USB2_PORT0_POWERDOWN>,
+				 <&softreset STIH407_USB2_PORT0_SOFTRESET>;
+			reset-names = "power", "softreset";
+
+			phys = <&usb2_picophy0>;
+			phy-names = "usb";
+		};
+
+		ehci0: usb@9a03e00 {
+			compatible = "st,st-ehci-300x";
+			status = "disabled";
+			reg = <0x9a03e00 0x100>;
+			interrupts = <GIC_SPI 151 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb0>;
+			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
+			resets = <&powerdown STIH407_USB2_PORT0_POWERDOWN>,
+				 <&softreset STIH407_USB2_PORT0_SOFTRESET>;
+			reset-names = "power", "softreset";
+
+			phys = <&usb2_picophy0>;
+			phy-names = "usb";
+		};
+
+		ohci1: usb@9a83c00 {
+			compatible = "st,st-ohci-300x";
+			status = "disabled";
+			reg = <0x9a83c00 0x100>;
+			interrupts = <GIC_SPI 181 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
+			resets = <&powerdown STIH407_USB2_PORT1_POWERDOWN>,
+				 <&softreset STIH407_USB2_PORT1_SOFTRESET>;
+			reset-names = "power", "softreset";
+
+			phys = <&usb2_picophy1>;
+			phy-names = "usb";
+		};
+
+		ehci1: usb@9a83e00 {
+			compatible = "st,st-ehci-300x";
+			status = "disabled";
+			reg = <0x9a83e00 0x100>;
+			interrupts = <GIC_SPI 153 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb1>;
+			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
+			resets = <&powerdown STIH407_USB2_PORT1_POWERDOWN>,
+				 <&softreset STIH407_USB2_PORT1_SOFTRESET>;
+			reset-names = "power", "softreset";
+
+			phys = <&usb2_picophy1>;
+			phy-names = "usb";
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
deleted file mode 100644
index 5e01db2..0000000
--- a/arch/arm/boot/dts/stih407.dtsi
+++ /dev/null
@@ -1,385 +0,0 @@
-/*
- * Copyright (C) 2014 STMicroelectronics Limited.
- * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * publishhed by the Free Software Foundation.
- */
-#include "stih407-clock.dtsi"
-#include "stih407-pinctrl.dtsi"
-#include <dt-bindings/reset-controller/stih407-resets.h>
-/ {
-	#address-cells = <1>;
-	#size-cells = <1>;
-
-	cpus {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		cpu@0 {
-			device_type = "cpu";
-			compatible = "arm,cortex-a9";
-			reg = <0>;
-		};
-		cpu@1 {
-			device_type = "cpu";
-			compatible = "arm,cortex-a9";
-			reg = <1>;
-		};
-	};
-
-	intc: interrupt-controller@08761000 {
-		compatible = "arm,cortex-a9-gic";
-		#interrupt-cells = <3>;
-		interrupt-controller;
-		reg = <0x08761000 0x1000>, <0x08760100 0x100>;
-	};
-
-	scu@08760000 {
-		compatible = "arm,cortex-a9-scu";
-		reg = <0x08760000 0x1000>;
-	};
-
-	timer@08760200 {
-		interrupt-parent = <&intc>;
-		compatible = "arm,cortex-a9-global-timer";
-		reg = <0x08760200 0x100>;
-		interrupts = <GIC_PPI 11 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&arm_periph_clk>;
-	};
-
-	l2: cache-controller {
-		compatible = "arm,pl310-cache";
-		reg = <0x08762000 0x1000>;
-		arm,data-latency = <3 3 3>;
-		arm,tag-latency = <2 2 2>;
-		cache-unified;
-		cache-level = <2>;
-	};
-
-	soc {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		interrupt-parent = <&intc>;
-		ranges;
-		compatible = "simple-bus";
-
-		powerdown: powerdown-controller {
-			compatible = "st,stih407-powerdown";
-			#reset-cells = <1>;
-		};
-
-		softreset: softreset-controller {
-			compatible = "st,stih407-softreset";
-			#reset-cells = <1>;
-		};
-
-		picophyreset: picophyreset-controller {
-			compatible = "st,stih407-picophyreset";
-			#reset-cells = <1>;
-		};
-
-		syscfg_sbc: sbc-syscfg@9620000 {
-			compatible = "st,stih407-sbc-syscfg", "syscon";
-			reg = <0x9620000 0x1000>;
-		};
-
-		syscfg_front: front-syscfg@9280000 {
-			compatible = "st,stih407-front-syscfg", "syscon";
-			reg = <0x9280000 0x1000>;
-		};
-
-		syscfg_rear: rear-syscfg@9290000 {
-			compatible = "st,stih407-rear-syscfg", "syscon";
-			reg = <0x9290000 0x1000>;
-		};
-
-		syscfg_flash: flash-syscfg@92a0000 {
-			compatible = "st,stih407-flash-syscfg", "syscon";
-			reg = <0x92a0000 0x1000>;
-		};
-
-		syscfg_sbc_reg: fvdp-lite-syscfg@9600000 {
-			compatible = "st,stih407-sbc-reg-syscfg", "syscon";
-			reg = <0x9600000 0x1000>;
-		};
-
-		syscfg_core: core-syscfg@92b0000 {
-			compatible = "st,stih407-core-syscfg", "syscon";
-			reg = <0x92b0000 0x1000>;
-		};
-
-		syscfg_lpm: lpm-syscfg@94b5100 {
-			compatible = "st,stih407-lpm-syscfg", "syscon";
-			reg = <0x94b5100 0x1000>;
-		};
-
-		serial@9830000 {
-			compatible = "st,asc";
-			reg = <0x9830000 0x2c>;
-			interrupts = <GIC_SPI 122 IRQ_TYPE_NONE>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_serial0>;
-			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
-
-			status = "disabled";
-		};
-
-		serial@9831000 {
-			compatible = "st,asc";
-			reg = <0x9831000 0x2c>;
-			interrupts = <GIC_SPI 123 IRQ_TYPE_NONE>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_serial1>;
-			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
-
-			status = "disabled";
-		};
-
-		serial@9832000 {
-			compatible = "st,asc";
-			reg = <0x9832000 0x2c>;
-			interrupts = <GIC_SPI 124 IRQ_TYPE_NONE>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_serial2>;
-			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
-
-			status = "disabled";
-		};
-
-		/* SBC_ASC0 - UART10 */
-		sbc_serial0: serial@9530000 {
-			compatible = "st,asc";
-			reg = <0x9530000 0x2c>;
-			interrupts = <GIC_SPI 138 IRQ_TYPE_NONE>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_sbc_serial0>;
-			clocks = <&clk_sysin>;
-
-			status = "disabled";
-		};
-
-		serial@9531000 {
-			compatible = "st,asc";
-			reg = <0x9531000 0x2c>;
-			interrupts = <GIC_SPI 139 IRQ_TYPE_NONE>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_sbc_serial1>;
-			clocks = <&clk_sysin>;
-
-			status = "disabled";
-		};
-
-		i2c@9840000 {
-			compatible = "st,comms-ssc4-i2c";
-			interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
-			reg = <0x9840000 0x110>;
-			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
-			clock-names = "ssc";
-			clock-frequency = <400000>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_i2c0_default>;
-
-			status = "disabled";
-		};
-
-		i2c@9841000 {
-			compatible = "st,comms-ssc4-i2c";
-			reg = <0x9841000 0x110>;
-			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
-			clock-names = "ssc";
-			clock-frequency = <400000>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_i2c1_default>;
-
-			status = "disabled";
-		};
-
-		i2c@9842000 {
-			compatible = "st,comms-ssc4-i2c";
-			reg = <0x9842000 0x110>;
-			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
-			clock-names = "ssc";
-			clock-frequency = <400000>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_i2c2_default>;
-
-			status = "disabled";
-		};
-
-		i2c@9843000 {
-			compatible = "st,comms-ssc4-i2c";
-			reg = <0x9843000 0x110>;
-			interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
-			clock-names = "ssc";
-			clock-frequency = <400000>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_i2c3_default>;
-
-			status = "disabled";
-		};
-
-		i2c@9844000 {
-			compatible = "st,comms-ssc4-i2c";
-			reg = <0x9844000 0x110>;
-			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
-			clock-names = "ssc";
-			clock-frequency = <400000>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_i2c4_default>;
-
-			status = "disabled";
-		};
-
-		i2c@9845000 {
-			compatible = "st,comms-ssc4-i2c";
-			reg = <0x9845000 0x110>;
-			interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
-			clock-names = "ssc";
-			clock-frequency = <400000>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_i2c5_default>;
-
-			status = "disabled";
-		};
-
-
-		/* SSCs on SBC */
-		i2c@9540000 {
-			compatible = "st,comms-ssc4-i2c";
-			reg = <0x9540000 0x110>;
-			interrupts = <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk_sysin>;
-			clock-names = "ssc";
-			clock-frequency = <400000>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_i2c10_default>;
-
-			status = "disabled";
-		};
-
-		i2c@9541000 {
-			compatible = "st,comms-ssc4-i2c";
-			reg = <0x9541000 0x110>;
-			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk_sysin>;
-			clock-names = "ssc";
-			clock-frequency = <400000>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_i2c11_default>;
-
-			status = "disabled";
-		};
-
-		/* Generic picoPHY */
-		usb2_picophy0: usbpicophy@0 {
-			compatible = "st,stih407-usb2-phy";
-			reg =	<0xf8 0x04>,	/* syscfg 5062 */
-				<0xf4 0x04>;    /* syscfg 5061 */
-			reg-names =	"param",
-					"ctrl";
-			#phy-cells = <0>;
-
-			st,syscfg = <&syscfg_core>;
-			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
-				 <&picophyreset STIH407_PICOPHY0_RESET>;
-			reset-names = "global",
-				      "port";
-		};
-
-		usb2_picophy1: usbpicophy@1 {
-			compatible = "st,stih407-usb2-phy";
-			#phy-cells = <0>;
-			reg =	<0xfc 0x04>,	/* syscfg 5063 */
-				<0xf4 0x04>;    /* syscfg 5061 */
-			reg-names =	"param",
-					"ctrl";
-
-			st,syscfg = <&syscfg_core>;
-			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
-				 <&picophyreset STIH407_PICOPHY1_RESET>;
-			reset-names = "global",
-				      "port";
-		};
-
-		usb2_picophy2: usbpicophy@2 {
-			compatible = "st,stih407-usb2-phy";
-			#phy-cells = <0>;
-			reg =	<0x100 0x04>,	/* syscfg 5064 */
-				<0xf4 0x04>;    /* syscfg 5061 */
-			reg-names =	"param",
-					"ctrl";
-
-			st,syscfg = <&syscfg_core>;
-			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
-				 <&picophyreset STIH407_PICOPHY2_RESET>;
-			reset-names = "global",
-				      "port";
-		};
-
-		ohci0: usb@9a03c00 {
-			compatible = "st,st-ohci-300x";
-			status = "disabled";
-			reg = <0x9a03c00 0x100>;
-			interrupts = <GIC_SPI 180 IRQ_TYPE_NONE>;
-			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
-			resets = <&powerdown STIH407_USB2_PORT0_POWERDOWN>,
-				 <&softreset STIH407_USB2_PORT0_SOFTRESET>;
-			reset-names = "power", "softreset";
-
-			phys = <&usb2_picophy0>;
-			phy-names = "usb";
-		};
-
-		ehci0: usb@9a03e00 {
-			compatible = "st,st-ehci-300x";
-			status = "disabled";
-			reg = <0x9a03e00 0x100>;
-			interrupts = <GIC_SPI 151 IRQ_TYPE_NONE>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_usb0>;
-			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
-			resets = <&powerdown STIH407_USB2_PORT0_POWERDOWN>,
-				 <&softreset STIH407_USB2_PORT0_SOFTRESET>;
-			reset-names = "power", "softreset";
-
-			phys = <&usb2_picophy0>;
-			phy-names = "usb";
-		};
-
-		ohci1: usb@9a83c00 {
-			compatible = "st,st-ohci-300x";
-			status = "disabled";
-			reg = <0x9a83c00 0x100>;
-			interrupts = <GIC_SPI 181 IRQ_TYPE_NONE>;
-			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
-			resets = <&powerdown STIH407_USB2_PORT1_POWERDOWN>,
-				 <&softreset STIH407_USB2_PORT1_SOFTRESET>;
-			reset-names = "power", "softreset";
-
-			phys = <&usb2_picophy1>;
-			phy-names = "usb";
-		};
-
-		ehci1: usb@9a83e00 {
-			compatible = "st,st-ehci-300x";
-			status = "disabled";
-			reg = <0x9a83e00 0x100>;
-			interrupts = <GIC_SPI 153 IRQ_TYPE_NONE>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_usb1>;
-			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
-			resets = <&powerdown STIH407_USB2_PORT1_POWERDOWN>,
-				 <&softreset STIH407_USB2_PORT1_SOFTRESET>;
-			reset-names = "power", "softreset";
-
-			phys = <&usb2_picophy1>;
-			phy-names = "usb";
-		};
-	};
-};
diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
new file mode 100644
index 0000000..862bb2f
--- /dev/null
+++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
@@ -0,0 +1,73 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics (R&D) Limited.
+ * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/ {
+	chosen {
+		bootargs = "console=ttyAS0,115200";
+		linux,stdout-path = &sbc_serial0;
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x40000000 0x80000000>;
+	};
+
+	aliases {
+		ttyAS0 = &sbc_serial0;
+	};
+
+	soc {
+		sbc_serial0: serial@9530000 {
+			status = "okay";
+		};
+
+		leds {
+			compatible = "gpio-leds";
+			red {
+				#gpio-cells = <2>;
+				label = "Front Panel LED";
+				gpios = <&pio4 1 0>;
+				linux,default-trigger = "heartbeat";
+			};
+			green {
+				#gpio-cells = <2>;
+				gpios = <&pio1 3 0>;
+				default-state = "off";
+			};
+		};
+
+		i2c@9842000 {
+			status = "okay";
+		};
+
+		i2c@9843000 {
+			status = "okay";
+		};
+
+		i2c@9844000 {
+			status = "okay";
+		};
+
+		i2c@9845000 {
+			status = "okay";
+		};
+
+		i2c@9540000 {
+			status = "okay";
+		};
+
+		/* SSC11 to HDMI */
+		i2c@9541000 {
+			status = "okay";
+			/* HDMI V1.3a supports Standard mode only */
+			clock-frequency = <100000>;
+			st,i2c-min-scl-pulse-width-us = <0>;
+			st,i2c-min-sda-pulse-width-us = <5>;
+		};
+	};
+};
-- 
1.9.1

