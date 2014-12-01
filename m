Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbaLAXXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:23:01 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46117 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897AbaLAXU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:20:57 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 09/16] dt: binding: add binding for TZ1090 TOP clocks
Date: Mon,  1 Dec 2014 23:19:59 +0000
Message-Id: <1417476006-10407-10-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
References: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TZ1090 top level register region controls the majority of the SoC's
clocking infrastructure.

Create a clock binding for the provider of these clocks, and a header
file in <dt-bindings/clock/> for enumerating the provided clocks.

There are a variety of clocks provided, including from muxes, gates,
deleters, dividers, and PLLs.

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
- New patch.
- Convert explicit DT representation of clock infrastructure using
  generic bindings to several TZ1090 specific bindings representing
  groups of TZ1090 clocks.
---
 .../bindings/clock/img,tz1090-top-clocks.txt       |  68 ++++++++++++
 include/dt-bindings/clock/tz1090-top.h             | 118 +++++++++++++++++++++
 2 files changed, 186 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-top-clocks.txt
 create mode 100644 include/dt-bindings/clock/tz1090-top.h

diff --git a/Documentation/devicetree/bindings/clock/img,tz1090-top-clocks.txt b/Documentation/devicetree/bindings/clock/img,tz1090-top-clocks.txt
new file mode 100644
index 0000000..75b59f0
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/img,tz1090-top-clocks.txt
@@ -0,0 +1,68 @@
+Binding for TZ1090 Top level register clocks.
+
+This binding uses the common clock binding[1]. It represents the clocks
+controlled from the top level registers of the TZ1090, and encompasses most of
+the complexity of the TZ1090 clock tree:
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible         : Shall be "img,tz1090-top-clocks".
+- #clock-cells       : From common clock binding; shall be set to 1.
+- reg                : Base address for clock registers in top level register
+                       region.
+- clocks             : Clock specifiers for each input clock.
+- clock-names        : Labels for each input clock specified in clocks.
+                       Can contain the following entries:
+                       "xtal1"        : XTAL1 oscillator.
+                       "xtal3"        : XTAL2 oscillator.
+                       "ext_adc_dac"  : External ADC/DAC clock input.
+                       "ddr_en"       : Output of HEP DDR clock gate.
+                       "afe_progdiv1",
+                       "afe_progdiv3",
+                       "afe_rxsync",
+                       "afe_txsync",
+                       "iqadc_sync"   : Output clocks from AFE block.
+
+Optional properties:
+- clock-indices      : From common clock binding. Allows clock-output-names to
+                       be sparse.
+- clock-output-names : From common clock binding. May be used to name specific
+                       output clocks so that other clock providers can find
+                       the clocks by name before the provider has been
+                       instantiated. Can contain:
+                       "sys", "sys_x2_undeleted" "scb", "ext_stc0", "ext_stc1",
+                       "if1", "if0", "sys_ucc1", "sys_mtx", "meta", "ucc0",
+                       "ucc1_del", "sys_undeleted", "afe", "adcpll_div", "uart",
+                       "pdm", "spi0", "spi1", "i2sm", "usb_phy", "sdhost",
+                       "ring_osc", "i2s", "meta_trace", "pixel", "out0", "out1",
+                       "ddr", "sys_pll", "sys_pdc"
+
+Clock Specifier Definition:
+- <1st-cell>: Output clock number. Use constants from
+              <dt-bindings/clock/tz1090-top.h>.
+
+Examples:
+	top_clks: top_clks {
+		compatible = "img,tz1090-top-clocks";
+		#clock-cells = <1>;
+		reg = <0x02005900 0xb0>;
+		/* input clocks */
+		clocks = <&xtal1>, <&xtal2>, <&ext_adc_dac>,
+			 <&hep_cru CLK_HEP_DDR_EN>;
+		clock-names = "xtal1", "xtal2", "ext_adc_dac",
+			      "ddr_en";
+		/* output clocks for other clock providers */
+		clock-indices = <CLK_TOP_SYS>,
+				<CLK_TOP_SYS_X2_UNDELETED>;
+		clock-output-names = "sys",
+				     "sys_x2_undeleted";
+	};
+
+	ir {
+		...
+		clocks = <&pdc_clks CLK_PDC_32KHZ>,
+			 <&top_clks CLK_TOP_PDC>;
+		clock-names = "core", "sys";
+		...
+	};
diff --git a/include/dt-bindings/clock/tz1090-top.h b/include/dt-bindings/clock/tz1090-top.h
new file mode 100644
index 0000000..effb06a
--- /dev/null
+++ b/include/dt-bindings/clock/tz1090-top.h
@@ -0,0 +1,118 @@
+/*
+ * Copyright (C) 2013-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _DT_BINDINGS_CLK_TZ1090_TOP_H
+#define _DT_BINDINGS_CLK_TZ1090_TOP_H
+
+/* Ranges of top level clock numbers */
+#define CLK_TOP_CLKSWITCH_BASE		0
+#define CLK_TOP_CLKENAB_BASE		(CLK_TOP_CLKSWITCH_BASE  + 27)
+#define CLK_TOP_CLKSWITCH2_BASE		(CLK_TOP_CLKENAB_BASE    +  9)
+#define CLK_TOP_CLKENAB2_BASE		(CLK_TOP_CLKSWITCH2_BASE + 10)
+#define CLK_TOP_DEL_BASE		(CLK_TOP_CLKENAB2_BASE   +  7)
+#define CLK_TOP_DIV_BASE		(CLK_TOP_DEL_BASE        +  4)
+#define CLK_TOP_PLL_BASE		(CLK_TOP_DIV_BASE        + 18)
+#define CLK_TOP_CLKEN_BASE		(CLK_TOP_PLL_BASE        +  2)
+#define CLK_TOP_MAX			(CLK_TOP_CLKEN_BASE      +  1)
+
+
+/* CR_TOP_CLKSWITCH clocks */
+#define CLK_TOP_SYS_SW			(CLK_TOP_CLKSWITCH_BASE + 0)
+#define CLK_TOP_SYS_X2_UNDELETED	(CLK_TOP_CLKSWITCH_BASE + 1)
+#define CLK_TOP_OUT0_SW0		(CLK_TOP_CLKSWITCH_BASE + 2)
+#define CLK_TOP_OUT0_SW1		(CLK_TOP_CLKSWITCH_BASE + 3)
+#define CLK_TOP_OUT0_SW2		(CLK_TOP_CLKSWITCH_BASE + 4)
+#define CLK_TOP_OUT0_SW3		(CLK_TOP_CLKSWITCH_BASE + 5)
+#define CLK_TOP_OUT1_SW0		(CLK_TOP_CLKSWITCH_BASE + 6)
+#define CLK_TOP_OUT1_SW1		(CLK_TOP_CLKSWITCH_BASE + 7)
+#define CLK_TOP_OUT1_SW2		(CLK_TOP_CLKSWITCH_BASE + 8)
+#define CLK_TOP_OUT1_SW3		(CLK_TOP_CLKSWITCH_BASE + 9)
+#define CLK_TOP_I2S_SW2			(CLK_TOP_CLKSWITCH_BASE + 10)
+#define CLK_TOP_I2S_SW0			(CLK_TOP_CLKSWITCH_BASE + 11)
+#define CLK_TOP_I2S_SW1			(CLK_TOP_CLKSWITCH_BASE + 12)
+#define CLK_TOP_SCB_SW			(CLK_TOP_CLKSWITCH_BASE + 13)
+#define CLK_TOP_UART_SW			(CLK_TOP_CLKSWITCH_BASE + 14)
+#define CLK_TOP_EXT_STC0_SW		(CLK_TOP_CLKSWITCH_BASE + 15)
+#define CLK_TOP_EXT_STC1_SW		(CLK_TOP_CLKSWITCH_BASE + 16)
+#define CLK_TOP_USB_SW0			(CLK_TOP_CLKSWITCH_BASE + 17)
+#define CLK_TOP_USB_SW1			(CLK_TOP_CLKSWITCH_BASE + 18)
+#define CLK_TOP_AFE_SW0			(CLK_TOP_CLKSWITCH_BASE + 19)
+#define CLK_TOP_AFE_SW1			(CLK_TOP_CLKSWITCH_BASE + 20)
+#define CLK_TOP_ADCPLL_SW0		(CLK_TOP_CLKSWITCH_BASE + 21)
+#define CLK_TOP_ADCPLL_SW1		(CLK_TOP_CLKSWITCH_BASE + 22)
+#define CLK_TOP_ADCPLL_SW2		(CLK_TOP_CLKSWITCH_BASE + 23)
+#define CLK_TOP_ADCPLL_SW3		(CLK_TOP_CLKSWITCH_BASE + 24)
+#define CLK_TOP_USB_SW2			(CLK_TOP_CLKSWITCH_BASE + 25)
+#define CLK_TOP_USB_SW3			(CLK_TOP_CLKSWITCH_BASE + 26)
+
+/* CR_TOP_CLKENAB clocks */
+#define CLK_TOP_OUT0_EN			(CLK_TOP_CLKENAB_BASE + 0)
+#define CLK_TOP_OUT1_EN			(CLK_TOP_CLKENAB_BASE + 1)
+#define CLK_TOP_I2S_EN			(CLK_TOP_CLKENAB_BASE + 2)
+#define CLK_TOP_SCB			(CLK_TOP_CLKENAB_BASE + 3)
+#define CLK_TOP_UART_EN			(CLK_TOP_CLKENAB_BASE + 4)
+#define CLK_TOP_EXT_STC0		(CLK_TOP_CLKENAB_BASE + 5)
+#define CLK_TOP_EXT_STC1		(CLK_TOP_CLKENAB_BASE + 6)
+#define CLK_TOP_USB_EN			(CLK_TOP_CLKENAB_BASE + 7)
+#define CLK_TOP_ADCPLL_EN		(CLK_TOP_CLKENAB_BASE + 8)
+
+/* CR_TOP_CLKSWITCH2 clocks */
+#define CLK_TOP_PIXEL_SW0		(CLK_TOP_CLKSWITCH2_BASE + 0)
+#define CLK_TOP_PIXEL_SW1		(CLK_TOP_CLKSWITCH2_BASE + 1)
+#define CLK_TOP_PIXEL_SW2		(CLK_TOP_CLKSWITCH2_BASE + 2)
+#define CLK_TOP_PIXEL_SW3		(CLK_TOP_CLKSWITCH2_BASE + 3)
+#define CLK_TOP_PIXEL_SW4		(CLK_TOP_CLKSWITCH2_BASE + 4)
+#define CLK_TOP_IF1_SW			(CLK_TOP_CLKSWITCH2_BASE + 5)
+#define CLK_TOP_IF0_SW			(CLK_TOP_CLKSWITCH2_BASE + 6)
+#define CLK_TOP_DAC0_SW			(CLK_TOP_CLKSWITCH2_BASE + 7)
+#define CLK_TOP_UCC1_SW			(CLK_TOP_CLKSWITCH2_BASE + 8)
+#define CLK_TOP_UCC0_SW			(CLK_TOP_CLKSWITCH2_BASE + 9)
+
+/* CR_TOP_CLKENAB2 clocks */
+#define CLK_TOP_PIXEL_EN		(CLK_TOP_CLKENAB2_BASE + 0)
+#define CLK_TOP_IF1			(CLK_TOP_CLKENAB2_BASE + 1)
+#define CLK_TOP_IF0			(CLK_TOP_CLKENAB2_BASE + 2)
+#define CLK_TOP_EXT_ADC_EN		(CLK_TOP_CLKENAB2_BASE + 3)
+#define CLK_TOP_DAC0			(CLK_TOP_CLKENAB2_BASE + 4)
+#define CLK_TOP_SYS_UCC1		(CLK_TOP_CLKENAB2_BASE + 5)
+#define CLK_TOP_SYS_MTX			(CLK_TOP_CLKENAB2_BASE + 6)
+
+/* Clock deleters */
+#define CLK_TOP_SYS			(CLK_TOP_DEL_BASE + 0)
+#define CLK_TOP_META			(CLK_TOP_DEL_BASE + 1)
+#define CLK_TOP_UCC0			(CLK_TOP_DEL_BASE + 2)
+#define CLK_TOP_UCC1_DEL		(CLK_TOP_DEL_BASE + 3)
+
+/* Clock dividers */
+#define CLK_TOP_SYS_DIV			(CLK_TOP_DIV_BASE +  0)
+#define CLK_TOP_SYS_UNDELETED		(CLK_TOP_DIV_BASE +  1)
+#define CLK_TOP_AFE			(CLK_TOP_DIV_BASE +  2)
+#define CLK_TOP_ADCPLL_DIV		(CLK_TOP_DIV_BASE +  3)
+#define CLK_TOP_UART			(CLK_TOP_DIV_BASE +  4)
+#define CLK_TOP_PDM			(CLK_TOP_DIV_BASE +  5)
+#define CLK_TOP_SPI0			(CLK_TOP_DIV_BASE +  6)
+#define CLK_TOP_SPI1			(CLK_TOP_DIV_BASE +  7)
+#define CLK_TOP_I2SM			(CLK_TOP_DIV_BASE +  8)
+#define CLK_TOP_USB_PHY			(CLK_TOP_DIV_BASE +  9)
+#define CLK_TOP_SDHOST			(CLK_TOP_DIV_BASE + 10)
+#define CLK_TOP_RING_OSC		(CLK_TOP_DIV_BASE + 11)
+#define CLK_TOP_I2S			(CLK_TOP_DIV_BASE + 12)
+#define CLK_TOP_META_TRACE		(CLK_TOP_DIV_BASE + 13)
+#define CLK_TOP_PIXEL			(CLK_TOP_DIV_BASE + 14)
+#define CLK_TOP_OUT0			(CLK_TOP_DIV_BASE + 15)
+#define CLK_TOP_OUT1			(CLK_TOP_DIV_BASE + 16)
+#define CLK_TOP_DDR			(CLK_TOP_DIV_BASE + 17)
+
+/* PLL clocks */
+#define CLK_TOP_SYSPLL			(CLK_TOP_PLL_BASE + 0)
+#define CLK_TOP_ADCPLL			(CLK_TOP_PLL_BASE + 1)
+
+/* CR_TOP_CLKEN clocks */
+#define CLK_TOP_PDC			(CLK_TOP_CLKEN_BASE + 0)
+
+#endif
-- 
2.0.4

