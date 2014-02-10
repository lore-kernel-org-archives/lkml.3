Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaBJRdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:33:17 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59734 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753595AbaBJRdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:33:10 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 4/6] clk: mvebu: add clock support for Armada 380/385
Date: Mon, 10 Feb 2014 18:32:47 +0100
Message-Id: <1392053569-28037-5-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
References: <1392053569-28037-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the clock support for the new SoCs Armada 380 and Armada 385:
core clocks and gating clocks.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/clk/mvebu/Kconfig      |   4 +
 drivers/clk/mvebu/Makefile     |   1 +
 drivers/clk/mvebu/armada-38x.c | 167 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+)
 create mode 100644 drivers/clk/mvebu/armada-38x.c

diff --git a/drivers/clk/mvebu/Kconfig b/drivers/clk/mvebu/Kconfig
index a54ba170634b..693f7be129f1 100644
--- a/drivers/clk/mvebu/Kconfig
+++ b/drivers/clk/mvebu/Kconfig
@@ -17,6 +17,10 @@ config ARMADA_375_CLK
 	bool
 	select MVEBU_CLK_COMMON
 
+config ARMADA_38X_CLK
+	bool
+	select MVEBU_CLK_COMMON
+
 config ARMADA_XP_CLK
 	bool
 	select MVEBU_CLK_COMMON
diff --git a/drivers/clk/mvebu/Makefile b/drivers/clk/mvebu/Makefile
index 0b13811b9f62..4c66162fb0b4 100644
--- a/drivers/clk/mvebu/Makefile
+++ b/drivers/clk/mvebu/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_MVEBU_CLK_COREDIV)	+= clk-corediv.o
 
 obj-$(CONFIG_ARMADA_370_CLK)	+= armada-370.o
 obj-$(CONFIG_ARMADA_375_CLK)	+= armada-375.o
+obj-$(CONFIG_ARMADA_38X_CLK)	+= armada-38x.o
 obj-$(CONFIG_ARMADA_XP_CLK)	+= armada-xp.o
 obj-$(CONFIG_DOVE_CLK)		+= dove.o
 obj-$(CONFIG_KIRKWOOD_CLK)	+= kirkwood.o
diff --git a/drivers/clk/mvebu/armada-38x.c b/drivers/clk/mvebu/armada-38x.c
new file mode 100644
index 000000000000..8bccf4ecdab6
--- /dev/null
+++ b/drivers/clk/mvebu/armada-38x.c
@@ -0,0 +1,167 @@
+/*
+ * Marvell Armada 380/385 SoC clocks
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
+ * SAR[14:10] : Ratios between PCLK0, NBCLK, HCLK and DRAM clocks
+ *
+ * SAR[15]    : TCLK frequency
+ *		 0 = 250 MHz
+ *		 1 = 200 MHz
+ */
+
+#define SAR_A380_TCLK_FREQ_OPT		  15
+#define SAR_A380_TCLK_FREQ_OPT_MASK	  0x1
+#define SAR_A380_CPU_DDR_L2_FREQ_OPT	  10
+#define SAR_A380_CPU_DDR_L2_FREQ_OPT_MASK 0x1F
+
+static const u32 armada_38x_tclk_frequencies[] __initconst = {
+	250000000,
+	200000000,
+};
+
+static u32 __init armada_38x_get_tclk_freq(void __iomem *sar)
+{
+	u8 tclk_freq_select;
+
+	tclk_freq_select = ((readl(sar) >> SAR_A380_TCLK_FREQ_OPT) &
+			    SAR_A380_TCLK_FREQ_OPT_MASK);
+	return armada_38x_tclk_frequencies[tclk_freq_select];
+}
+
+static const u32 armada_38x_cpu_frequencies[] __initconst = {
+	0, 0, 0, 0,
+	1066 * 1000 * 1000, 0, 0, 0,
+	1332 * 1000 * 1000, 0, 0, 0,
+	1600 * 1000 * 1000,
+};
+
+static u32 __init armada_38x_get_cpu_freq(void __iomem *sar)
+{
+	u8 cpu_freq_select;
+
+	cpu_freq_select = ((readl(sar) >> SAR_A380_CPU_DDR_L2_FREQ_OPT) &
+			   SAR_A380_CPU_DDR_L2_FREQ_OPT_MASK);
+	if (cpu_freq_select >= ARRAY_SIZE(armada_38x_cpu_frequencies)) {
+		pr_err("Selected CPU frequency (%d) unsupported\n",
+			cpu_freq_select);
+		return 0;
+	}
+
+	return armada_38x_cpu_frequencies[cpu_freq_select];
+}
+
+enum { A380_CPU_TO_DDR, A380_CPU_TO_L2 };
+
+static const struct coreclk_ratio armada_38x_coreclk_ratios[] __initconst = {
+	{ .id = A380_CPU_TO_L2,	 .name = "l2clk" },
+	{ .id = A380_CPU_TO_DDR, .name = "ddrclk" },
+};
+
+static const int armada_38x_cpu_l2_ratios[32][2] __initconst = {
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{1, 2}, {0, 1}, {0, 1}, {0, 1},
+	{1, 2}, {0, 1}, {0, 1}, {0, 1},
+	{1, 2}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+};
+
+static const int armada_38x_cpu_ddr_ratios[32][2] __initconst = {
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{1, 2}, {0, 1}, {0, 1}, {0, 1},
+	{1, 2}, {0, 1}, {0, 1}, {0, 1},
+	{1, 2}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+};
+
+static void __init armada_38x_get_clk_ratio(
+	void __iomem *sar, int id, int *mult, int *div)
+{
+	u32 opt = ((readl(sar) >> SAR_A380_CPU_DDR_L2_FREQ_OPT) &
+		SAR_A380_CPU_DDR_L2_FREQ_OPT_MASK);
+
+	switch (id) {
+	case A380_CPU_TO_L2:
+		*mult = armada_38x_cpu_l2_ratios[opt][0];
+		*div = armada_38x_cpu_l2_ratios[opt][1];
+		break;
+	case A380_CPU_TO_DDR:
+		*mult = armada_38x_cpu_ddr_ratios[opt][0];
+		*div = armada_38x_cpu_ddr_ratios[opt][1];
+		break;
+	}
+}
+
+static const struct coreclk_soc_desc armada_38x_coreclks = {
+	.get_tclk_freq = armada_38x_get_tclk_freq,
+	.get_cpu_freq = armada_38x_get_cpu_freq,
+	.get_clk_ratio = armada_38x_get_clk_ratio,
+	.ratios = armada_38x_coreclk_ratios,
+	.num_ratios = ARRAY_SIZE(armada_38x_coreclk_ratios),
+};
+
+static void __init armada_38x_coreclk_init(struct device_node *np)
+{
+	mvebu_coreclk_setup(np, &armada_38x_coreclks);
+}
+CLK_OF_DECLARE(armada_38x_core_clk, "marvell,armada-380-core-clock",
+	       armada_38x_coreclk_init);
+
+/*
+ * Clock Gating Control
+ */
+static const struct clk_gating_soc_desc armada_38x_gating_desc[] __initconst = {
+	{ "audio", NULL, 0 },
+	{ "ge2", NULL, 2 },
+	{ "ge1", NULL, 3 },
+	{ "ge0", NULL, 4 },
+	{ "pex1", NULL, 5 },
+	{ "pex2", NULL, 6 },
+	{ "pex3", NULL, 7 },
+	{ "pex0", NULL, 8 },
+	{ "usb3h0", NULL, 9 },
+	{ "usb3h1", NULL, 10 },
+	{ "usb3d", NULL, 11 },
+	{ "bm", NULL, 13 },
+	{ "crypto0z", NULL, 14 },
+	{ "sata0", NULL, 15 },
+	{ "crypto1z", NULL, 16 },
+	{ "sdio", NULL, 17 },
+	{ "usb2", NULL, 18 },
+	{ "crypto1", NULL, 21 },
+	{ "xor0", NULL, 22 },
+	{ "crypto0", NULL, 23 },
+	{ "tdm", NULL, 25 },
+	{ "xor1", NULL, 28 },
+	{ "sata1", NULL, 30 },
+	{ }
+};
+
+static void __init armada_38x_clk_gating_init(struct device_node *np)
+{
+	mvebu_clk_gating_setup(np, armada_38x_gating_desc);
+}
+CLK_OF_DECLARE(armada_38x_clk_gating, "marvell,armada-380-gating-clock",
+	       armada_38x_clk_gating_init);
-- 
1.8.1.2

