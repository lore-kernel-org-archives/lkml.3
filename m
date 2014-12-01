Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009AbaLAXVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:21:46 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51617 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbaLAXVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:21:08 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 15/16] metag: tz1090: add TZ1090 clocks to device tree
Date: Mon,  1 Dec 2014 23:20:05 +0000
Message-Id: <1417476006-10407-16-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the common clock framework for the TZ1090 SoC, and add a
tz1090_clk device tree file instantiating and connecting together the
clock providers.

Most of the clock graph is represented, apart from the AFE output clocks
which aren't usually of much interest to Linux. These are represented
with a single placeholder clock for now, but in reality it is a whole IP
block with multiple clocks and a PLL.

Provided clocks include external oscillators:
- xtal1 (specified-clock)
- xtal2 (fixed-rate, rate to be specified by board dts if fitted)
- xtal3 (fixed-rate, rate to be specified by board dts if fitted)
External clock inputs:
- ext_adc_dac (0 Hz fixed-rate placeholder)
Internal groups of clocks
- afe_clks (0 Hz fixed-rate placeholder for multiple output clocks)
- pdc_clks (img,tz1090-pdc-clocks, mainly for 32khz low power clock)
- top_clks (img,tz1090-top-clocks, majority of clocking infrastructure)
- hep_cru (img,tz1090-hep-cru, high end peripheral clocks)
- perip_cru (img,tz1090-perip-cru, system clock to peripherals)

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: linux-metag@vger.kernel.org
Cc: devicetree@vger.kernel.org
---
Changes since v1 (patch 15):
- Convert explicit DT representation of clock infrastructure using
  generic bindings to several TZ1090 specific bindings representing
  groups of TZ1090 clocks.
- Combine unrepresented AFE block clocks into single fixed-clock
  placeholder.
- Split out use of Meta core clock into separate patch 16.
---
 arch/metag/Kconfig.soc              |   1 +
 arch/metag/boot/dts/tz1090.dtsi     |   1 +
 arch/metag/boot/dts/tz1090_clk.dtsi | 143 ++++++++++++++++++++++++++++++++++++
 3 files changed, 145 insertions(+)
 create mode 100644 arch/metag/boot/dts/tz1090_clk.dtsi

diff --git a/arch/metag/Kconfig.soc b/arch/metag/Kconfig.soc
index 973640f..93c21c3 100644
--- a/arch/metag/Kconfig.soc
+++ b/arch/metag/Kconfig.soc
@@ -17,6 +17,7 @@ config META21_FPGA
 config SOC_TZ1090
 	bool "Toumaz Xenif TZ1090 SoC (Comet)"
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select COMMON_CLK
 	select IMGPDC_IRQ
 	select METAG_LNKGET_AROUND_CACHE
 	select METAG_META21
diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index 24ea7d2..48aa8b1 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -9,6 +9,7 @@
 #include "skeleton.dtsi"
 
 #include <dt-bindings/interrupt-controller/irq.h>
+#include "tz1090_clk.dtsi"
 
 / {
 	compatible = "toumaz,tz1090", "img,meta";
diff --git a/arch/metag/boot/dts/tz1090_clk.dtsi b/arch/metag/boot/dts/tz1090_clk.dtsi
new file mode 100644
index 0000000..2a98d60
--- /dev/null
+++ b/arch/metag/boot/dts/tz1090_clk.dtsi
@@ -0,0 +1,143 @@
+/*
+ * Copyright (C) 2013 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <dt-bindings/clock/tz1090-top.h>
+#include <dt-bindings/clock/tz1090-hep.h>
+#include <dt-bindings/clock/tz1090-perip.h>
+#include <dt-bindings/clock/tz1090-pdc.h>
+
+/ {
+	soc {
+		/*
+		 * ============ EXTERNAL CLOCKS/OSCILLATORS ============
+		 */
+
+		/* XTAL1 frequency is specified in reset bootstrap config */
+		xtal1: xtal1 {
+			compatible = "specified-clock";
+			#clock-cells = <0>;
+			reg = <0x02004004 0x4>;	/* CR_PERIP_RESET_CFG */
+			bit-mask = <0x00000f00>;	/* FXTAL */
+			/*	 FXTAL	Frequency */
+			table = <0	16384000>,
+				<1	19200000>,
+				<2	24000000>,
+				<3	24576000>,
+				<4	26000000>,
+				<5	36000000>,
+				<6	36864000>,
+				<7	38400000>,
+				<8	40000000>,
+				<9	48000000>;
+			clock-output-names = "xtal1";
+		};
+
+		/* XTAL2 oscillator (board specific, but 12MHz recommended) */
+		xtal2: xtal2 {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+			clock-output-names = "xtal2";
+		};
+
+		/* XTAL3 oscillator (32.768KHz if fitted, assume not fitted) */
+		xtal3: xtal3 {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+			clock-output-names = "xtal3";
+		};
+
+		ext_adc_dac: ext_adc_dac {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+			clock-output-names = "ext_adc_dac";
+		};
+
+
+		/*
+		 * ============ POWERDOWN CONTROLLER CLOCKS ============
+		 */
+
+		pdc_clks: pdc_clks {
+			compatible = "img,tz1090-pdc-clocks";
+			#clock-cells = <1>;
+			reg = <0x02006500 0x4>;	/* SOC_GPIO_CONTROL0 */
+			clocks = <&xtal1>,
+				 <&xtal3>;
+			clock-names = "xtal1",
+				      "xtal3";
+		};
+
+
+		/*
+		 * ============ AFE CLOCKS ============
+		 */
+
+		afe_clks: afe_clks {
+			/* This is just a placeholder at the moment */
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+		};
+
+
+		/*
+		 * ============ TOP LEVEL CLOCKS ============
+		 */
+
+		top_clks: top_clks {
+			compatible = "img,tz1090-top-clocks";
+			#clock-cells = <1>;
+			reg = <0x02005900 0xb0>;
+			clocks = <&xtal1>, <&xtal2>, <&ext_adc_dac>,
+				 <&hep_cru CLK_HEP_DDR_EN>,
+				 <&afe_clks>, <&afe_clks>,
+				 <&afe_clks>, <&afe_clks>, <&afe_clks>;
+			clock-names = "xtal1", "xtal2", "ext_adc_dac",
+				      "ddr_en",
+				      "afe_progdiv1", "afe_progdiv3",
+				      "afe_rxsync", "afe_txsync", "iqadc_sync";
+			clock-indices = <CLK_TOP_SYS>,
+					<CLK_TOP_SYS_X2_UNDELETED>;
+			clock-output-names = "sys",
+					     "sys_x2_undeleted";
+		};
+
+
+		/*
+		 * ============ HIGH LEVEL PERIPHERAL CLOCKS ============
+		 */
+
+		hep_cru: hep_cru {
+			compatible = "img,tz1090-hep-cru";
+			#clock-cells = <1>;
+			reg = <0x02008c00 0x08>;
+			clocks = <&top_clks CLK_TOP_SYS>,
+				 <&top_clks CLK_TOP_SYS_X2_UNDELETED>;
+			clock-names = "sys",
+				      "sys_x2_undeleted";
+			clock-indices = <CLK_HEP_DDR_EN>;
+			clock-output-names = "ddr_en";
+		};
+
+		/*
+		 * ============ PERIPHERAL CLOCKS ============
+		 */
+
+		perip_cru: perip_cru {
+			compatible = "img,tz1090-perip-cru";
+			#clock-cells = <1>;
+			reg = <0x02004000 0x18>;
+			clocks = <&top_clks CLK_TOP_SYS>;
+			clock-names = "sys";
+		};
+
+	};
+};
-- 
2.0.4

