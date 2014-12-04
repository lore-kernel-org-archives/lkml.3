Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbaLDVmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:42:13 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:19761 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189AbaLDVln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:41:43 -0500
X-IronPort-AV: E=Sophos;i="5.07,518,1413270000"; 
   d="scan'208";a="52313851"
From: Ray Jui <rjui@broadcom.com>
To: Mike Turquette <mturquette@linaro.org>, Matt Porter <mporter@linaro.org>,
        Alex Elder <elder@linaro.org>, Tim Kryger <tim.kryger@linaro.org>,
        "Rob Herring" <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Scott Branden <sbranden@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, Ray Jui <rjui@broadcom.com>
Subject: [PATCH 3/4] clk: cygnus: add clock support for Broadcom Cygnus
Date: Thu, 4 Dec 2014 13:43:27 -0800
Message-ID: <1417729408-30357-4-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417729408-30357-1-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
 <1417729408-30357-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Broadcom Cygnus SoC is architected under the iProc architecture. It
has the following PLLs: ARMPLL, GENPLL, LCPLL0, MIPIPLL, all dervied
from an onboard crystal. Cygnus also has various ASIU clocks that are
derived directly from the onboard crystal.

Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/clk/bcm/Makefile               |    1 +
 drivers/clk/bcm/clk-cygnus.c           |  277 ++++++++++++++++++++++++++++++++
 include/dt-bindings/clock/bcm-cygnus.h |   77 +++++++++
 3 files changed, 355 insertions(+)
 create mode 100644 drivers/clk/bcm/clk-cygnus.c
 create mode 100644 include/dt-bindings/clock/bcm-cygnus.h

diff --git a/drivers/clk/bcm/Makefile b/drivers/clk/bcm/Makefile
index 6926636..afcbe55 100644
--- a/drivers/clk/bcm/Makefile
+++ b/drivers/clk/bcm/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_CLK_BCM_KONA)	+= clk-kona-setup.o
 obj-$(CONFIG_CLK_BCM_KONA)	+= clk-bcm281xx.o
 obj-$(CONFIG_CLK_BCM_KONA)	+= clk-bcm21664.o
 obj-$(CONFIG_COMMON_CLK_IPROC)	+= clk-iproc-armpll.o clk-iproc-pll.o clk-iproc-clk.o clk-iproc-asiu.o
+obj-$(CONFIG_ARCH_BCM_CYGNUS)	+= clk-cygnus.o
diff --git a/drivers/clk/bcm/clk-cygnus.c b/drivers/clk/bcm/clk-cygnus.c
new file mode 100644
index 0000000..f603d1d
--- /dev/null
+++ b/drivers/clk/bcm/clk-cygnus.c
@@ -0,0 +1,277 @@
+/*
+ * Copyright (C) 2014 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/clkdev.h>
+#include <linux/of_address.h>
+#include <linux/delay.h>
+
+#include <dt-bindings/clock/bcm-cygnus.h>
+#include "clk-iproc.h"
+
+#define reg_val(o, s, w) { .offset = o, .shift = s, .width = w, }
+
+#define aon_val(o, pw, ps, is) { .offset = o, .pwr_width = pw, \
+	.pwr_shift = ps, .iso_shift = is }
+
+#define asiu_div_val(o, es, hs, hw, ls, lw) \
+		{ .offset = o, .en_shift = es, .high_shift = hs, \
+		.high_width = hw, .low_shift = ls, .low_width = lw }
+
+#define reset_val(o, rs, prs, kis, kiw, kps, kpw, kas, kaw) { .offset = o, \
+	.reset_shift = rs, .p_reset_shift = prs, .ki_shift = kis, \
+	.ki_width = kiw, .kp_shift = kps, .kp_width = kpw, .ka_shift = kas, \
+	.ka_width = kaw }
+
+#define vco_ctrl_val(uo, lo) { .u_offset = uo, .l_offset = lo }
+
+#define enable_val(o, es, hs, bs) { .offset = o, .enable_shift = es, \
+	.hold_shift = hs, .bypass_shift = bs }
+
+#define asiu_gate_val(o, es) { .offset = o, .en_shift = es }
+
+static const struct iproc_pll_ctrl genpll = {
+	.flags = IPROC_CLK_AON | IPROC_CLK_PLL_HAS_NDIV_FRAC,
+	.aon = aon_val(0x0, 2, 1, 0),
+	.reset = reset_val(0x0, 11, 10, 4, 3, 0, 4, 7, 3),
+	.ndiv_int = reg_val(0x10, 20, 10),
+	.ndiv_frac = reg_val(0x10, 0, 20),
+	.pdiv = reg_val(0x14, 0, 4),
+	.vco_ctrl = vco_ctrl_val(0x18, 0x1c),
+	.status = reg_val(0x28, 12, 1),
+};
+
+static const struct iproc_pll_ctrl lcpll0 = {
+	.flags = IPROC_CLK_AON,
+	.aon = aon_val(0x0, 2, 5, 4),
+	.reset = reset_val(0x0, 31, 30, 27, 3, 23, 4, 19, 4),
+	.ndiv_int = reg_val(0x4, 16, 10),
+	.pdiv = reg_val(0x4, 26, 4),
+	.vco_ctrl = vco_ctrl_val(0x10, 0x14),
+	.status = reg_val(0x18, 12, 1),
+};
+
+/*
+ * MIPI PLL VCO frequency parameter table
+ */
+static const struct iproc_pll_vco_freq_param mipipll_vco_params[] = {
+	/* rate (Hz) ndiv_int ndiv_frac pdiv */
+	{ 750000000UL,   30,     0,        1 },
+	{ 1000000000UL,  40,     0,        1 },
+	{ 1350000000ul,  54,     0,        1 },
+	{ 2000000000UL,  80,     0,        1 },
+	{ 2100000000UL,  84,     0,        1 },
+	{ 2250000000UL,  90,     0,        1 },
+	{ 2500000000UL,  100,    0,        1 },
+	{ 2700000000UL,  54,     0,        0 },
+	{ 2975000000UL,  119,    0,        1 },
+	{ 3100000000UL,  124,    0,        1 },
+	{ 3150000000UL,  126,    0,        1 },
+};
+
+static const struct iproc_pll_ctrl mipipll = {
+	.flags = IPROC_CLK_PLL_ASIU | IPROC_CLK_PLL_HAS_NDIV_FRAC,
+	.aon = aon_val(0x0, 4, 17, 16),
+	.asiu = asiu_gate_val(0x0, 3),
+	.reset = reset_val(0x0, 11, 10, 4, 3, 0, 4, 7, 4),
+	.ndiv_int = reg_val(0x10, 20, 10),
+	.ndiv_frac = reg_val(0x10, 0, 20),
+	.pdiv = reg_val(0x14, 0, 4),
+	.vco_ctrl = vco_ctrl_val(0x18, 0x1c),
+	.status = reg_val(0x28, 12, 1),
+};
+
+static const struct iproc_clk_ctrl genpll_clk[BCM_CYGNUS_NUM_GENPLL_CLKS] = {
+	[BCM_CYGNUS_GENPLL_AXI21_CLK] = {
+		.channel = BCM_CYGNUS_GENPLL_AXI21_CLK,
+		.flags = IPROC_CLK_AON,
+		.enable = enable_val(0x4, 6, 0, 12),
+		.mdiv = reg_val(0x20, 0, 8),
+	},
+	[BCM_CYGNUS_GENPLL_250MHZ_CLK] = {
+		.channel = BCM_CYGNUS_GENPLL_250MHZ_CLK,
+		.flags = IPROC_CLK_AON,
+		.enable = enable_val(0x4, 7, 1, 13),
+		.mdiv = reg_val(0x20, 10, 8),
+	},
+	[BCM_CYGNUS_GENPLL_IHOST_SYS_CLK] = {
+		.channel = BCM_CYGNUS_GENPLL_IHOST_SYS_CLK,
+		.flags = IPROC_CLK_AON,
+		.enable = enable_val(0x4, 8, 2, 14),
+		.mdiv = reg_val(0x20, 20, 8),
+	},
+	[BCM_CYGNUS_GENPLL_ENET_SW_CLK] = {
+		.channel = BCM_CYGNUS_GENPLL_ENET_SW_CLK,
+		.flags = IPROC_CLK_AON,
+		.enable = enable_val(0x4, 9, 3, 15),
+		.mdiv = reg_val(0x24, 0, 8),
+	},
+	[BCM_CYGNUS_GENPLL_AUDIO_125_CLK] = {
+		.channel = BCM_CYGNUS_GENPLL_AUDIO_125_CLK,
+		.flags = IPROC_CLK_AON,
+		.enable = enable_val(0x4, 10, 4, 16),
+		.mdiv = reg_val(0x24, 10, 8),
+	},
+	[BCM_CYGNUS_GENPLL_CAN_CLK] = {
+		.channel = BCM_CYGNUS_GENPLL_CAN_CLK,
+		.flags = IPROC_CLK_AON,
+		.enable = enable_val(0x4, 11, 5, 17),
+		.mdiv = reg_val(0x24, 20, 8),
+	},
+};
+
+static const struct iproc_clk_ctrl lcpll0_clk[BCM_CYGNUS_NUM_LCPLL0_CLKS] = {
+	[BCM_CYGNUS_LCPLL0_PCIE_PHY_REF_CLK] = {
+		.channel = BCM_CYGNUS_LCPLL0_PCIE_PHY_REF_CLK,
+		.flags = IPROC_CLK_AON,
+		.enable = enable_val(0x0, 7, 1, 13),
+		.mdiv = reg_val(0x8, 0, 8),
+	},
+	[BCM_CYGNUS_LCPLL0_DDR_PHY_CLK] = {
+		.channel = BCM_CYGNUS_LCPLL0_DDR_PHY_CLK,
+		.flags = IPROC_CLK_AON,
+		.enable = enable_val(0x0, 8, 2, 14),
+		.mdiv = reg_val(0x8, 10, 8),
+	},
+	[BCM_CYGNUS_LCPLL0_SDIO_CLK] = {
+		.channel = BCM_CYGNUS_LCPLL0_SDIO_CLK,
+		.flags = IPROC_CLK_AON,
+		.enable = enable_val(0x0, 9, 3, 15),
+		.mdiv = reg_val(0x8, 20, 8),
+	},
+	[BCM_CYGNUS_LCPLL0_USB_PHY_REF_CLK] = {
+		.channel = BCM_CYGNUS_LCPLL0_USB_PHY_REF_CLK,
+		.flags = IPROC_CLK_AON,
+		.enable = enable_val(0x0, 10, 4, 16),
+		.mdiv = reg_val(0xc, 0, 8),
+	},
+	[BCM_CYGNUS_LCPLL0_SMART_CARD_CLK] = {
+		.channel = BCM_CYGNUS_LCPLL0_SMART_CARD_CLK,
+		.flags = IPROC_CLK_AON,
+		.enable = enable_val(0x0, 11, 5, 17),
+		.mdiv = reg_val(0xc, 10, 8),
+	},
+	[BCM_CYGNUS_LCPLL0_CH5_UNUSED] = {
+		.channel = BCM_CYGNUS_LCPLL0_CH5_UNUSED,
+		.flags = IPROC_CLK_AON,
+		.enable = enable_val(0x0, 12, 6, 18),
+		.mdiv = reg_val(0xc, 20, 8),
+	},
+};
+
+static const struct iproc_clk_ctrl mipipll_clk[BCM_CYGNUS_NUM_MIPIPLL_CLKS] = {
+	[BCM_CYGNUS_MIPIPLL_CH0_UNUSED] = {
+		.channel = BCM_CYGNUS_MIPIPLL_CH0_UNUSED,
+		.enable = enable_val(0x4, 12, 6, 18),
+		.mdiv = reg_val(0x20, 0, 8),
+	},
+	[BCM_CYGNUS_MIPIPLL_CH1_LCD] = {
+		.channel = BCM_CYGNUS_MIPIPLL_CH1_LCD,
+		.enable = enable_val(0x4, 13, 7, 19),
+		.mdiv = reg_val(0x20, 10, 8),
+	},
+	[BCM_CYGNUS_MIPIPLL_CH2_UNUSED] = {
+		.channel = BCM_CYGNUS_MIPIPLL_CH2_UNUSED,
+		.enable = enable_val(0x4, 14, 8, 20),
+		.mdiv = reg_val(0x20, 20, 8),
+	},
+	[BCM_CYGNUS_MIPIPLL_CH3_UNUSED] = {
+		.channel = BCM_CYGNUS_MIPIPLL_CH3_UNUSED,
+		.enable = enable_val(0x4, 15, 9, 21),
+		.mdiv = reg_val(0x24, 0, 8),
+	},
+	[BCM_CYGNUS_MIPIPLL_CH4_UNUSED] = {
+		.channel = BCM_CYGNUS_MIPIPLL_CH4_UNUSED,
+		.enable = enable_val(0x4, 16, 10, 22),
+		.mdiv = reg_val(0x24, 10, 8),
+	},
+	[BCM_CYGNUS_MIPIPLL_CH5_UNUSED] = {
+		.channel = BCM_CYGNUS_MIPIPLL_CH5_UNUSED,
+		.enable = enable_val(0x4, 17, 11, 23),
+		.mdiv = reg_val(0x24, 20, 8),
+	},
+};
+
+static const struct iproc_asiu_div asiu_div[BCM_CYGNUS_NUM_ASIU_CLKS] = {
+	[BCM_CYGNUS_ASIU_KEYPAD_CLK] =
+		asiu_div_val(0x0, 31, 16, 10, 0, 10),
+	[BCM_CYGNUS_ASIU_ADC_CLK] =
+		asiu_div_val(0x4, 31, 16, 10, 0, 10),
+	[BCM_CYGNUS_ASIU_PWM_CLK] =
+		asiu_div_val(0x8, 31, 16, 10, 0, 10),
+};
+
+static const struct iproc_asiu_gate asiu_gate[BCM_CYGNUS_NUM_ASIU_CLKS] = {
+	[BCM_CYGNUS_ASIU_KEYPAD_CLK] =
+		asiu_gate_val(0x0, 7),
+	[BCM_CYGNUS_ASIU_ADC_CLK] =
+		asiu_gate_val(0x0, 9),
+	[BCM_CYGNUS_ASIU_PWM_CLK] =
+		asiu_gate_val(IPROC_CLK_INVALID_OFFSET, 0),
+};
+
+static void __init cygnus_armpll_init(struct device_node *node)
+{
+	iproc_armpll_setup(node);
+}
+CLK_OF_DECLARE(cygnus_armpll, "brcm,cygnus-armpll", cygnus_armpll_init);
+
+static void __init cygnus_genpll_init(struct device_node *node)
+{
+	iproc_pll_setup(node, &genpll, NULL, 0);
+}
+CLK_OF_DECLARE(cygnus_genpll, "brcm,cygnus-genpll", cygnus_genpll_init);
+
+static void __init cygnus_lcpll0_init(struct device_node *node)
+{
+	iproc_pll_setup(node, &lcpll0, NULL, 0);
+}
+CLK_OF_DECLARE(cygnus_lcpll0, "brcm,cygnus-lcpll0", cygnus_lcpll0_init);
+
+static void __init cygnus_mipipll_init(struct device_node *node)
+{
+	iproc_pll_setup(node, &mipipll, mipipll_vco_params,
+			ARRAY_SIZE(mipipll_vco_params));
+}
+CLK_OF_DECLARE(cygnus_mipipll, "brcm,cygnus-mipipll", cygnus_mipipll_init);
+
+static void __init cygnus_genpll_clk_init(struct device_node *node)
+{
+	iproc_clk_setup(node, genpll_clk, BCM_CYGNUS_NUM_GENPLL_CLKS);
+}
+CLK_OF_DECLARE(cygnus_genpll_clk, "brcm,cygnus-genpll-clk",
+		cygnus_genpll_clk_init);
+
+static void __init cygnus_lcpll0_clk_init(struct device_node *node)
+{
+	iproc_clk_setup(node, lcpll0_clk, BCM_CYGNUS_NUM_LCPLL0_CLKS);
+}
+CLK_OF_DECLARE(cygnus_lcpll0_clk, "brcm,cygnus-lcpll0-clk",
+		cygnus_lcpll0_clk_init);
+
+static void __init cygnus_mipipll_clk_init(struct device_node *node)
+{
+	iproc_clk_setup(node, mipipll_clk, BCM_CYGNUS_NUM_MIPIPLL_CLKS);
+}
+CLK_OF_DECLARE(cygnus_mipipll_clk, "brcm,cygnus-mipipll-clk",
+		cygnus_mipipll_clk_init);
+
+static void __init cygnus_asiu_init(struct device_node *node)
+{
+	iproc_asiu_setup(node, asiu_div, asiu_gate, BCM_CYGNUS_NUM_ASIU_CLKS);
+}
+CLK_OF_DECLARE(cygnus_asiu_clk, "brcm,cygnus-asiu-clk", cygnus_asiu_init);
diff --git a/include/dt-bindings/clock/bcm-cygnus.h b/include/dt-bindings/clock/bcm-cygnus.h
new file mode 100644
index 0000000..45948b6
--- /dev/null
+++ b/include/dt-bindings/clock/bcm-cygnus.h
@@ -0,0 +1,77 @@
+/*
+ *  BSD LICENSE
+ *
+ *  Copyright(c) 2014 Broadcom Corporation.  All rights reserved.
+ *
+ *  Redistribution and use in source and binary forms, with or without
+ *  modification, are permitted provided that the following conditions
+ *  are met:
+ *
+ *    * Redistributions of source code must retain the above copyright
+ *      notice, this list of conditions and the following disclaimer.
+ *    * Redistributions in binary form must reproduce the above copyright
+ *      notice, this list of conditions and the following disclaimer in
+ *      the documentation and/or other materials provided with the
+ *      distribution.
+ *    * Neither the name of Broadcom Corporation nor the names of its
+ *      contributors may be used to endorse or promote products derived
+ *      from this software without specific prior written permission.
+ *
+ *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _CLOCK_BCM_CYGNUS_H
+#define _CLOCK_BCM_CYGNUS_H
+
+/* number of GENPLL clocks */
+#define BCM_CYGNUS_NUM_GENPLL_CLKS 6
+
+/* GENPLL clock channel ID */
+#define BCM_CYGNUS_GENPLL_AXI21_CLK          0
+#define BCM_CYGNUS_GENPLL_250MHZ_CLK         1
+#define BCM_CYGNUS_GENPLL_IHOST_SYS_CLK      2
+#define BCM_CYGNUS_GENPLL_ENET_SW_CLK        3
+#define BCM_CYGNUS_GENPLL_AUDIO_125_CLK      4
+#define BCM_CYGNUS_GENPLL_CAN_CLK            5
+
+/* number of LCPLL0 clocks */
+#define BCM_CYGNUS_NUM_LCPLL0_CLKS 6
+
+/* LCPLL0 clock channel ID */
+#define BCM_CYGNUS_LCPLL0_PCIE_PHY_REF_CLK    0
+#define BCM_CYGNUS_LCPLL0_DDR_PHY_CLK         1
+#define BCM_CYGNUS_LCPLL0_SDIO_CLK            2
+#define BCM_CYGNUS_LCPLL0_USB_PHY_REF_CLK     3
+#define BCM_CYGNUS_LCPLL0_SMART_CARD_CLK      4
+#define BCM_CYGNUS_LCPLL0_CH5_UNUSED          5
+
+/* number of MIPI PLL clocks */
+#define BCM_CYGNUS_NUM_MIPIPLL_CLKS 6
+
+/* MIPI PLL clock channel ID */
+#define BCM_CYGNUS_MIPIPLL_CH0_UNUSED         0
+#define BCM_CYGNUS_MIPIPLL_CH1_LCD            1
+#define BCM_CYGNUS_MIPIPLL_CH2_UNUSED         2
+#define BCM_CYGNUS_MIPIPLL_CH3_UNUSED         3
+#define BCM_CYGNUS_MIPIPLL_CH4_UNUSED         4
+#define BCM_CYGNUS_MIPIPLL_CH5_UNUSED         5
+
+/* number of ASIU clocks */
+#define BCM_CYGNUS_NUM_ASIU_CLKS 3
+
+/* ASIU clock IDs */
+#define BCM_CYGNUS_ASIU_KEYPAD_CLK    0
+#define BCM_CYGNUS_ASIU_ADC_CLK       1
+#define BCM_CYGNUS_ASIU_PWM_CLK       2
+
+#endif /* _CLOCK_BCM_CYGNUS_H */
-- 
1.7.9.5

