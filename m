Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaBJRe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:34:29 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59717 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752962AbaBJRdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:33:06 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 1/6] clk: mvebu: add clock support for Armada 375
Date: Mon, 10 Feb 2014 18:32:44 +0100
Message-Id: <1392053569-28037-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
References: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the clock support for the new SoC Armada 375: core clocks and
gating clocks.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/clk/mvebu/Kconfig      |   4 +
 drivers/clk/mvebu/Makefile     |   1 +
 drivers/clk/mvebu/armada-375.c | 184 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 189 insertions(+)
 create mode 100644 drivers/clk/mvebu/armada-375.c

diff --git a/drivers/clk/mvebu/Kconfig b/drivers/clk/mvebu/Kconfig
index c339b829d3e3..a54ba170634b 100644
--- a/drivers/clk/mvebu/Kconfig
+++ b/drivers/clk/mvebu/Kconfig
@@ -13,6 +13,10 @@ config ARMADA_370_CLK
 	select MVEBU_CLK_CPU
 	select MVEBU_CLK_COREDIV
 
+config ARMADA_375_CLK
+	bool
+	select MVEBU_CLK_COMMON
+
 config ARMADA_XP_CLK
 	bool
 	select MVEBU_CLK_COMMON
diff --git a/drivers/clk/mvebu/Makefile b/drivers/clk/mvebu/Makefile
index 21bbfb4a9f42..0b13811b9f62 100644
--- a/drivers/clk/mvebu/Makefile
+++ b/drivers/clk/mvebu/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_MVEBU_CLK_CPU) 	+= clk-cpu.o
 obj-$(CONFIG_MVEBU_CLK_COREDIV)	+= clk-corediv.o
 
 obj-$(CONFIG_ARMADA_370_CLK)	+= armada-370.o
+obj-$(CONFIG_ARMADA_375_CLK)	+= armada-375.o
 obj-$(CONFIG_ARMADA_XP_CLK)	+= armada-xp.o
 obj-$(CONFIG_DOVE_CLK)		+= dove.o
 obj-$(CONFIG_KIRKWOOD_CLK)	+= kirkwood.o
diff --git a/drivers/clk/mvebu/armada-375.c b/drivers/clk/mvebu/armada-375.c
new file mode 100644
index 000000000000..c991a4d95e10
--- /dev/null
+++ b/drivers/clk/mvebu/armada-375.c
@@ -0,0 +1,184 @@
+/*
+ * Marvell Armada 375 SoC clocks
+ *
+ * Copyright (C) 2014 Marvell
+ *
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ * Andrew Lunn <andrew@lunn.ch>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include "common.h"
+
+/*
+ * Core Clocks
+ */
+
+/*
+ * For the Armada 375 SoCs, the CPU, DDR and L2 clocks frequencies are
+ * all modified at the same time, and not separately as for the Armada
+ * 370 or the Armada XP SoCs.
+ *
+ * SAR0[21:17]   : CPU frequency    DDR frequency   L2 frequency
+ *		 6   =  400 MHz	    400 MHz	    200 MHz
+ *		 15  =  600 MHz	    600 MHz	    300 MHz
+ *		 21  =  800 MHz	    534 MHz	    400 MHz
+ *		 25  = 1000 MHz	    500 MHz	    500 MHz
+ *		 others reserved.
+ *
+ * SAR0[22]   : TCLK frequency
+ *		 0 = 166 MHz
+ *		 1 = 200 MHz
+ */
+
+#define SAR1_A375_TCLK_FREQ_OPT		   22
+#define SAR1_A375_TCLK_FREQ_OPT_MASK	   0x1
+#define SAR1_A375_CPU_DDR_L2_FREQ_OPT	   17
+#define SAR1_A375_CPU_DDR_L2_FREQ_OPT_MASK 0x1F
+
+static const u32 armada_375_tclk_frequencies[] __initconst = {
+	166000000,
+	200000000,
+};
+
+static u32 __init armada_375_get_tclk_freq(void __iomem *sar)
+{
+	u8 tclk_freq_select;
+
+	tclk_freq_select = ((readl(sar) >> SAR1_A375_TCLK_FREQ_OPT) &
+			    SAR1_A375_TCLK_FREQ_OPT_MASK);
+	return armada_375_tclk_frequencies[tclk_freq_select];
+}
+
+
+static const u32 armada_375_cpu_frequencies[] __initconst = {
+	0, 0, 0, 0, 0, 0,
+	400000000,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	600000000,
+	0, 0, 0, 0, 0,
+	800000000,
+	0, 0, 0,
+	1000000000,
+};
+
+static u32 __init armada_375_get_cpu_freq(void __iomem *sar)
+{
+	u8 cpu_freq_select;
+
+	cpu_freq_select = ((readl(sar) >> SAR1_A375_CPU_DDR_L2_FREQ_OPT) &
+			   SAR1_A375_CPU_DDR_L2_FREQ_OPT_MASK);
+	if (cpu_freq_select >= ARRAY_SIZE(armada_375_cpu_frequencies)) {
+		pr_err("Selected CPU frequency (%d) unsupported\n",
+			cpu_freq_select);
+		return 0;
+	} else
+		return armada_375_cpu_frequencies[cpu_freq_select];
+}
+
+enum { A375_CPU_TO_DDR, A375_CPU_TO_L2 };
+
+static const struct coreclk_ratio armada_375_coreclk_ratios[] __initconst = {
+	{ .id = A375_CPU_TO_L2,	 .name = "l2clk" },
+	{ .id = A375_CPU_TO_DDR, .name = "ddrclk" },
+};
+
+static const int armada_375_cpu_l2_ratios[32][2] __initconst = {
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {1, 2}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {1, 2},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {1, 2}, {0, 1}, {0, 1},
+	{0, 1}, {1, 2}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+};
+
+static const int armada_375_cpu_ddr_ratios[32][2] __initconst = {
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {1, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {2, 3},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {2, 3}, {0, 1}, {0, 1},
+	{0, 1}, {1, 2}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+};
+
+static void __init armada_375_get_clk_ratio(
+	void __iomem *sar, int id, int *mult, int *div)
+{
+	u32 opt = ((readl(sar) >> SAR1_A375_CPU_DDR_L2_FREQ_OPT) &
+		SAR1_A375_CPU_DDR_L2_FREQ_OPT_MASK);
+
+	switch (id) {
+	case A375_CPU_TO_L2:
+		*mult = armada_375_cpu_l2_ratios[opt][0];
+		*div = armada_375_cpu_l2_ratios[opt][1];
+		break;
+	case A375_CPU_TO_DDR:
+		*mult = armada_375_cpu_ddr_ratios[opt][0];
+		*div = armada_375_cpu_ddr_ratios[opt][1];
+		break;
+	}
+}
+
+static const struct coreclk_soc_desc armada_375_coreclks = {
+	.get_tclk_freq = armada_375_get_tclk_freq,
+	.get_cpu_freq = armada_375_get_cpu_freq,
+	.get_clk_ratio = armada_375_get_clk_ratio,
+	.ratios = armada_375_coreclk_ratios,
+	.num_ratios = ARRAY_SIZE(armada_375_coreclk_ratios),
+};
+
+static void __init armada_375_coreclk_init(struct device_node *np)
+{
+	mvebu_coreclk_setup(np, &armada_375_coreclks);
+}
+CLK_OF_DECLARE(armada_375_core_clk, "marvell,armada-375-core-clock",
+	       armada_375_coreclk_init);
+
+/*
+ * Clock Gating Control
+ */
+static const struct clk_gating_soc_desc armada_375_gating_desc[] __initconst = {
+	{ "mu", NULL, 2 },
+	{ "pp", NULL, 3 },
+	{ "ptp", NULL, 4 },
+	{ "pex0", NULL, 5 },
+	{ "pex1", NULL, 6 },
+	{ "audio", NULL, 8 },
+	{ "nd_clk", "nand", 11 },
+	{ "sata0_link", "sata0_core", 14 },
+	{ "sata0_core", NULL, 15 },
+	{ "usb3", NULL, 16 },
+	{ "sdio", NULL, 17 },
+	{ "usb", NULL, 18 },
+	{ "gop", NULL, 19 },
+	{ "sata1_link", "sata1_core", 20 },
+	{ "sata1_core", NULL, 21 },
+	{ "xor0", NULL, 22 },
+	{ "xor1", NULL, 23 },
+	{ "copro", NULL, 24 },
+	{ "tdm", NULL, 25 },
+	{ "crypto0_enc", NULL, 28 },
+	{ "crypto0_core", NULL, 29 },
+	{ "crypto1_enc", NULL, 30 },
+	{ "crypto1_core", NULL, 31 },
+	{ }
+};
+
+static void __init armada_375_clk_gating_init(struct device_node *np)
+{
+	mvebu_clk_gating_setup(np, armada_375_gating_desc);
+}
+CLK_OF_DECLARE(armada_375_clk_gating, "marvell,armada-375-gating-clock",
+	       armada_375_clk_gating_init);
-- 
1.8.1.2

