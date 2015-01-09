Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbbAIPO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:14:58 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:36906 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757953AbbAIPMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:12:54 -0500
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org, peter.griffin@linaro.org
Subject: [PATCH 2/3] ARM: dts: Add STiH418 SoC support
Date: Fri,  9 Jan 2015 16:11:45 +0100
Message-Id: <1420816306-11305-3-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420816306-11305-1-git-send-email-maxime.coquelin@st.com>
References: <1420816306-11305-1-git-send-email-maxime.coquelin@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-09_05:2015-01-09,2015-01-09,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STiH418 is advanced UHD 60fps AVC processor with 3D graphic acceleration and
quad-core ARM Cortex A9 CPU.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 arch/arm/boot/dts/stih418-clock.dtsi     | 348 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stih418.dtsi           |  99 +++++++++
 include/dt-bindings/clock/stih418-clks.h |  34 +++
 3 files changed, 481 insertions(+)
 create mode 100644 arch/arm/boot/dts/stih418-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih418.dtsi
 create mode 100644 include/dt-bindings/clock/stih418-clks.h

diff --git a/arch/arm/boot/dts/stih418-clock.dtsi b/arch/arm/boot/dts/stih418-clock.dtsi
new file mode 100644
index 0000000..0ab23da
--- /dev/null
+++ b/arch/arm/boot/dts/stih418-clock.dtsi
@@ -0,0 +1,348 @@
+/*
+ * Copyright (C) 2015 STMicroelectronics R&D Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <dt-bindings/clock/stih418-clks.h>
+/ {
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		compatible = "st,stih418-clk", "simple-bus";
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
+						     "clk-tp",
+						     "clk-rx-icn-dmu",
+						     "clk-rx-icn-hva",
+						     "clk-icn-cpu",
+						     "clk-tx-icn-dmu",
+						     "clk-mmc-0",
+						     "clk-mmc-1",
+						     "clk-jpegdec",
+						     "clk-icn-reg",
+						     "clk-proc-bdisp-0",
+						     "clk-proc-bdisp-1",
+						     "clk-pp-dmu",
+						     "clk-vid-dmu",
+						     "clk-dss-lpc",
+						     "clk-st231-aud-0",
+						     "clk-st231-gp-1",
+						     "clk-st231-dmu",
+						     "clk-icn-lmi",
+						     "clk-tx-icn-1",
+						     "clk-icn-sbc",
+						     "clk-stfe-frc2",
+						     "clk-eth-phyref",
+						     "clk-eth-ref-phyclk",
+						     "clk-flash-promip",
+						     "clk-main-disp",
+						     "clk-aux-disp",
+						     "clk-compo-dvp",
+						     "clk-tx-icn-hades",
+						     "clk-rx-icn-hades",
+						     "clk-icn-reg-16",
+						     "clk-pp-hevc",
+						     "clk-clust-hevc",
+						     "clk-hwpe-hevc",
+						     "clk-fc-hevc",
+						     "clk-proc-mixer",
+						     "clk-proc-sc",
+						     "clk-avsp-hevc";
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
+						     "",
+						     "",
+						     "",
+						     "",
+						     "clk-tmds-hdmi-div2",
+						     "clk-pix-aux-disp",
+						     "clk-denc",
+						     "clk-pix-hddac",
+						     "clk-hddac",
+						     "clk-sddac",
+						     "clk-pix-dvo",
+						     "clk-dvo",
+						     "clk-pix-hdmi",
+						     "clk-tmds-hdmi",
+						     "clk-ref-hdmiphy",
+						     "", "", "", "", "",
+						     "", "", "", "", "",
+						     "", "", "", "", "",
+						     "", "", "", "", "",
+						     "", "", "", "", "",
+						     "", "", "", "", "",
+						     "", "clk-vp9";
+			};
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
diff --git a/arch/arm/boot/dts/stih418.dtsi b/arch/arm/boot/dts/stih418.dtsi
new file mode 100644
index 0000000..354d90f
--- /dev/null
+++ b/arch/arm/boot/dts/stih418.dtsi
@@ -0,0 +1,99 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics Limited.
+ * Author: Peter Griffin <peter.griffin@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+#include "stih418-clock.dtsi"
+#include "stih407-family.dtsi"
+#include "stih410-pinctrl.dtsi"
+/ {
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <2>;
+		};
+		cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <3>;
+		};
+	};
+
+	soc {
+		usb2_picophy1: phy2 {
+			compatible = "st,stih407-usb2-phy";
+			#phy-cells = <0>;
+			st,syscfg = <&syscfg_core 0xf8 0xf4>;
+			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
+				 <&picophyreset STIH407_PICOPHY0_RESET>;
+			reset-names = "global", "port";
+		};
+
+		usb2_picophy2: phy3 {
+			compatible = "st,stih407-usb2-phy";
+			#phy-cells = <0>;
+			st,syscfg = <&syscfg_core 0xfc 0xf4>;
+			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
+				 <&picophyreset STIH407_PICOPHY1_RESET>;
+			reset-names = "global", "port";
+		};
+
+		ohci0: usb@9a03c00 {
+			compatible = "st,st-ohci-300x";
+			reg = <0x9a03c00 0x100>;
+			interrupts = <GIC_SPI 180 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
+			resets = <&powerdown STIH407_USB2_PORT0_POWERDOWN>,
+				 <&softreset STIH407_USB2_PORT0_SOFTRESET>;
+			reset-names = "power", "softreset";
+			phys = <&usb2_picophy1>;
+			phy-names = "usb";
+		};
+
+		ehci0: usb@9a03e00 {
+			compatible = "st,st-ehci-300x";
+			reg = <0x9a03e00 0x100>;
+			interrupts = <GIC_SPI 151 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb0>;
+			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
+			resets = <&powerdown STIH407_USB2_PORT0_POWERDOWN>,
+				 <&softreset STIH407_USB2_PORT0_SOFTRESET>;
+			reset-names = "power", "softreset";
+			phys = <&usb2_picophy1>;
+			phy-names = "usb";
+		};
+
+		ohci1: usb@9a83c00 {
+			compatible = "st,st-ohci-300x";
+			reg = <0x9a83c00 0x100>;
+			interrupts = <GIC_SPI 181 IRQ_TYPE_NONE>;
+			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
+			resets = <&powerdown STIH407_USB2_PORT1_POWERDOWN>,
+				 <&softreset STIH407_USB2_PORT1_SOFTRESET>;
+			reset-names = "power", "softreset";
+			phys = <&usb2_picophy2>;
+			phy-names = "usb";
+		};
+
+		ehci1: usb@9a83e00 {
+			compatible = "st,st-ehci-300x";
+			reg = <0x9a83e00 0x100>;
+			interrupts = <GIC_SPI 153 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_usb1>;
+			clocks = <&clk_s_c0_flexgen CLK_TX_ICN_DISP_0>;
+			resets = <&powerdown STIH407_USB2_PORT1_POWERDOWN>,
+				 <&softreset STIH407_USB2_PORT1_SOFTRESET>;
+			reset-names = "power", "softreset";
+			phys = <&usb2_picophy2>;
+			phy-names = "usb";
+		};
+	};
+};
diff --git a/include/dt-bindings/clock/stih418-clks.h b/include/dt-bindings/clock/stih418-clks.h
new file mode 100644
index 0000000..b62aa0b
--- /dev/null
+++ b/include/dt-bindings/clock/stih418-clks.h
@@ -0,0 +1,34 @@
+/*
+ * This header provides constants clk index STMicroelectronics
+ * STiH418 SoC.
+ */
+#ifndef _DT_BINDINGS_CLK_STIH418
+#define _DT_BINDINGS_CLK_STIH418
+
+#include "stih410-clks.h"
+
+/* STiH418 introduces new clock outputs compared to STiH410 */
+
+/* CLOCKGEN C0 */
+#define CLK_PROC_BDISP_0        14
+#define CLK_PROC_BDISP_1        15
+#define CLK_TX_ICN_1            23
+#define CLK_ETH_PHYREF          27
+#define CLK_PP_HEVC             35
+#define CLK_CLUST_HEVC          36
+#define CLK_HWPE_HEVC           37
+#define CLK_FC_HEVC             38
+#define CLK_PROC_MIXER		39
+#define CLK_PROC_SC		40
+#define CLK_AVSP_HEVC		41
+
+/* CLOCKGEN D2 */
+#undef CLK_PIX_PIP
+#undef CLK_PIX_GDP1
+#undef CLK_PIX_GDP2
+#undef CLK_PIX_GDP3
+#undef CLK_PIX_GDP4
+
+#define CLK_TMDS_HDMI_DIV2	5
+#define CLK_VP9			47
+#endif
-- 
1.9.1

