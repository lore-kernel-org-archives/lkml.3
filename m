Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbaKMLDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:03:32 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:61452 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840AbaKMLBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:01:09 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v2 11/14] ARM: STi: DT: STiH410: Add STiH410 SoC and b2120 board support.
Date: Thu, 13 Nov 2014 11:00:14 +0000
Message-Id: <1415876417-28728-12-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
References: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STiH410 is an advanced multi-HD AVC processor with 3D graphics acceleration
and 1.5-GHz ARM Cortex-A9 SMP CPU part of the stih407 family.

It has wide connectivity including USB 3.0, PCI-e, SATA and gigabit ethernet.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/Makefile           |   1 +
 arch/arm/boot/dts/stih410-b2120.dts  |  29 +++
 arch/arm/boot/dts/stih410-clock.dtsi | 338 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stih410.dtsi       |  14 ++
 4 files changed, 382 insertions(+)
 create mode 100644 arch/arm/boot/dts/stih410-b2120.dts
 create mode 100644 arch/arm/boot/dts/stih410-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih410.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 38c89ca..04cf4a4 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -409,6 +409,7 @@ dtb-$(CONFIG_ARCH_SPEAR3XX)+= spear300-evb.dtb \
 	spear320-hmi.dtb
 dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
 dtb-$(CONFIG_ARCH_STI)+= stih407-b2120.dtb \
+	stih410-b2120.dtb \
 	stih415-b2000.dtb \
 	stih415-b2020.dtb \
 	stih416-b2000.dtb \
diff --git a/arch/arm/boot/dts/stih410-b2120.dts b/arch/arm/boot/dts/stih410-b2120.dts
new file mode 100644
index 0000000..972c17a
--- /dev/null
+++ b/arch/arm/boot/dts/stih410-b2120.dts
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics (R&D) Limited.
+ * Author: Peter Griffin <peter.griffin@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/dts-v1/;
+#include "stih410.dtsi"
+#include "stihxxx-b2120.dtsi"
+/ {
+	model = "STiH410 B2120";
+	compatible = "st,stih410-b2120", "st,stih410";
+
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
+};
diff --git a/arch/arm/boot/dts/stih410-clock.dtsi b/arch/arm/boot/dts/stih410-clock.dtsi
new file mode 100644
index 0000000..6b5803a
--- /dev/null
+++ b/arch/arm/boot/dts/stih410-clock.dtsi
@@ -0,0 +1,338 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics R&D Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <dt-bindings/clock/stih410-clks.h>
+/ {
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		compatible = "st,stih410-clk", "simple-bus";
+
+		/*
+		 * Fixed 30MHz oscillator inputs to SoC
+		 */
+		clk_sysin: clk-sysin {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <30000000>;
+			clock-output-names = "CLK_SYSIN";
+		};
+
+		/*
+		 * ARM Peripheral clock for timers
+		 */
+		arm_periph_clk: clk-m-a9-periphs {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clocks = <&clk_m_a9>;
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+
+		/*
+		 * A9 PLL.
+		 */
+		clockgen-a9@92b0000 {
+			compatible = "st,clkgen-c32";
+			reg = <0x92b0000 0xffff>;
+
+			clockgen_a9_pll: clockgen-a9-pll {
+				#clock-cells = <1>;
+				compatible = "st,stih407-plls-c32-a9", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clockgen-a9-pll-odf";
+			};
+		};
+
+		/*
+		 * ARM CPU related clocks.
+		 */
+		clk_m_a9: clk-m-a9@92b0000 {
+			#clock-cells = <0>;
+			compatible = "st,stih407-clkgen-a9-mux", "st,clkgen-mux";
+			reg = <0x92b0000 0x10000>;
+
+			clocks = <&clockgen_a9_pll 0>,
+				 <&clockgen_a9_pll 0>,
+				 <&clk_s_c0_flexgen 13>,
+				 <&clk_m_a9_ext2f_div2>;
+		};
+
+		/*
+		 * ARM Peripheral clock for timers
+		 */
+		clk_m_a9_ext2f_div2: clk-m-a9-ext2f-div2s {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+
+			clocks = <&clk_s_c0_flexgen 13>;
+
+			clock-output-names = "clk-m-a9-ext2f-div2";
+
+			clock-div = <2>;
+			clock-mult = <1>;
+		};
+
+		/*
+		 * Bootloader initialized system infrastructure clock for
+		 * serial devices.
+		 */
+		clk_ext2f_a9: clockgen-c0@13 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <200000000>;
+			clock-output-names = "clk-s-icn-reg-0";
+		};
+
+		clockgen-a@090ff000 {
+			compatible = "st,clkgen-c32";
+			reg = <0x90ff000 0x1000>;
+
+			clk_s_a0_pll: clk-s-a0-pll {
+				#clock-cells = <1>;
+				compatible = "st,stih407-plls-c32-a0", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-s-a0-pll-ofd-0";
+			};
+
+			clk_s_a0_flexgen: clk-s-a0-flexgen {
+				compatible = "st,flexgen";
+
+				#clock-cells = <1>;
+
+				clocks = <&clk_s_a0_pll 0>,
+					 <&clk_sysin>;
+
+				clock-output-names = "clk-ic-lmi0",
+						     "clk-ic-lmi1";
+			};
+		};
+
+		clk_s_c0_quadfs: clk-s-c0-quadfs@9103000 {
+			#clock-cells = <1>;
+			compatible = "st,stih407-quadfs660-C", "st,quadfs";
+			reg = <0x9103000 0x1000>;
+
+			clocks = <&clk_sysin>;
+
+			clock-output-names = "clk-s-c0-fs0-ch0",
+					     "clk-s-c0-fs0-ch1",
+					     "clk-s-c0-fs0-ch2",
+					     "clk-s-c0-fs0-ch3";
+		};
+
+		clk_s_c0: clockgen-c@09103000 {
+			compatible = "st,clkgen-c32";
+			reg = <0x9103000 0x1000>;
+
+			clk_s_c0_pll0: clk-s-c0-pll0 {
+				#clock-cells = <1>;
+				compatible = "st,stih407-plls-c32-c0_0", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-s-c0-pll0-odf-0";
+			};
+
+			clk_s_c0_pll1: clk-s-c0-pll1 {
+				#clock-cells = <1>;
+				compatible = "st,stih407-plls-c32-c0_1", "st,clkgen-plls-c32";
+
+				clocks = <&clk_sysin>;
+
+				clock-output-names = "clk-s-c0-pll1-odf-0";
+			};
+
+			clk_s_c0_flexgen: clk-s-c0-flexgen {
+				#clock-cells = <1>;
+				compatible = "st,flexgen";
+
+				clocks = <&clk_s_c0_pll0 0>,
+					 <&clk_s_c0_pll1 0>,
+					 <&clk_s_c0_quadfs 0>,
+					 <&clk_s_c0_quadfs 1>,
+					 <&clk_s_c0_quadfs 2>,
+					 <&clk_s_c0_quadfs 3>,
+					 <&clk_sysin>;
+
+				clock-output-names = "clk-icn-gpu",
+						     "clk-fdma",
+						     "clk-nand",
+						     "clk-hva",
+						     "clk-proc-stfe",
+						     "clk-proc-tp",
+						     "clk-rx-icn-dmu",
+						     "clk-rx-icn-hva",
+						     "clk-icn-cpu",
+						     "clk-tx-icn-dmu",
+						     "clk-mmc-0",
+						     "clk-mmc-1",
+						     "clk-jpegdec",
+						     "clk-ext2fa9",
+						     "clk-ic-bdisp-0",
+						     "clk-ic-bdisp-1",
+						     "clk-pp-dmu",
+						     "clk-vid-dmu",
+						     "clk-dss-lpc",
+						     "clk-st231-aud-0",
+						     "clk-st231-gp-1",
+						     "clk-st231-dmu",
+						     "clk-icn-lmi",
+						     "clk-tx-icn-disp-1",
+						     "clk-icn-sbc",
+						     "clk-stfe-frc2",
+						     "clk-eth-phy",
+						     "clk-eth-ref-phyclk",
+						     "clk-flash-promip",
+						     "clk-main-disp",
+						     "clk-aux-disp",
+						     "clk-compo-dvp",
+						     "clk-tx-icn-hades",
+						     "clk-rx-icn-hades",
+						     "clk-icn-reg-16",
+						     "clk-pp-hades",
+						     "clk-clust-hades",
+						     "clk-hwpe-hades",
+						     "clk-fc-hades";
+			};
+		};
+
+		clk_s_d0_quadfs: clk-s-d0-quadfs@9104000 {
+			#clock-cells = <1>;
+			compatible = "st,stih407-quadfs660-D", "st,quadfs";
+			reg = <0x9104000 0x1000>;
+
+			clocks = <&clk_sysin>;
+
+			clock-output-names = "clk-s-d0-fs0-ch0",
+					     "clk-s-d0-fs0-ch1",
+					     "clk-s-d0-fs0-ch2",
+					     "clk-s-d0-fs0-ch3";
+		};
+
+		clockgen-d0@09104000 {
+			compatible = "st,clkgen-c32";
+			reg = <0x9104000 0x1000>;
+
+			clk_s_d0_flexgen: clk-s-d0-flexgen {
+				#clock-cells = <1>;
+				compatible = "st,flexgen";
+
+				clocks = <&clk_s_d0_quadfs 0>,
+					 <&clk_s_d0_quadfs 1>,
+					 <&clk_s_d0_quadfs 2>,
+					 <&clk_s_d0_quadfs 3>,
+					 <&clk_sysin>;
+
+				clock-output-names = "clk-pcm-0",
+						     "clk-pcm-1",
+						     "clk-pcm-2",
+						     "clk-spdiff",
+						     "clk-pcmr10-master",
+						     "clk-usb2-phy";
+			};
+		};
+
+		clk_s_d2_quadfs: clk-s-d2-quadfs@9106000 {
+			#clock-cells = <1>;
+			compatible = "st,stih407-quadfs660-D", "st,quadfs";
+			reg = <0x9106000 0x1000>;
+
+			clocks = <&clk_sysin>;
+
+			clock-output-names = "clk-s-d2-fs0-ch0",
+					     "clk-s-d2-fs0-ch1",
+					     "clk-s-d2-fs0-ch2",
+					     "clk-s-d2-fs0-ch3";
+		};
+
+		clk_tmdsout_hdmi: clk-tmdsout-hdmi {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <0>;
+		};
+
+		clockgen-d2@x9106000 {
+			compatible = "st,clkgen-c32";
+			reg = <0x9106000 0x1000>;
+
+			clk_s_d2_flexgen: clk-s-d2-flexgen {
+				#clock-cells = <1>;
+				compatible = "st,flexgen";
+
+				clocks = <&clk_s_d2_quadfs 0>,
+					 <&clk_s_d2_quadfs 1>,
+					 <&clk_s_d2_quadfs 2>,
+					 <&clk_s_d2_quadfs 3>,
+					 <&clk_sysin>,
+					 <&clk_sysin>,
+					 <&clk_tmdsout_hdmi>;
+
+				clock-output-names = "clk-pix-main-disp",
+						     "clk-pix-pip",
+						     "clk-pix-gdp1",
+						     "clk-pix-gdp2",
+						     "clk-pix-gdp3",
+						     "clk-pix-gdp4",
+						     "clk-pix-aux-disp",
+						     "clk-denc",
+						     "clk-pix-hddac",
+						     "clk-hddac",
+						     "clk-sddac",
+						     "clk-pix-dvo",
+						     "clk-dvo",
+						     "clk-pix-hdmi",
+						     "clk-tmds-hdmi",
+						     "clk-ref-hdmiphy";
+						     };
+		};
+
+		clk_s_d3_quadfs: clk-s-d3-quadfs@9107000 {
+			#clock-cells = <1>;
+			compatible = "st,stih407-quadfs660-D", "st,quadfs";
+			reg = <0x9107000 0x1000>;
+
+			clocks = <&clk_sysin>;
+
+			clock-output-names = "clk-s-d3-fs0-ch0",
+					     "clk-s-d3-fs0-ch1",
+					     "clk-s-d3-fs0-ch2",
+					     "clk-s-d3-fs0-ch3";
+		};
+
+		clockgen-d3@9107000 {
+			compatible = "st,clkgen-c32";
+			reg = <0x9107000 0x1000>;
+
+			clk_s_d3_flexgen: clk-s-d3-flexgen {
+				#clock-cells = <1>;
+				compatible = "st,flexgen";
+
+				clocks = <&clk_s_d3_quadfs 0>,
+					 <&clk_s_d3_quadfs 1>,
+					 <&clk_s_d3_quadfs 2>,
+					 <&clk_s_d3_quadfs 3>,
+					 <&clk_sysin>;
+
+				clock-output-names = "clk-stfe-frc1",
+						     "clk-tsout-0",
+						     "clk-tsout-1",
+						     "clk-mchi",
+						     "clk-vsens-compo",
+						     "clk-frc1-remote",
+						     "clk-lpc-0",
+						     "clk-lpc-1";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.dtsi
new file mode 100644
index 0000000..c05627e
--- /dev/null
+++ b/arch/arm/boot/dts/stih410.dtsi
@@ -0,0 +1,14 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics Limited.
+ * Author: Peter Griffin <peter.griffin@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+#include "stih410-clock.dtsi"
+#include "stih407-family.dtsi"
+#include "stih410-pinctrl.dtsi"
+/ {
+
+};
-- 
1.9.1

