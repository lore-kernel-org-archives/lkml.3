Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3EKBIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 21:08:51 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:34740 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab3EKBIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 21:08:25 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] clk: mvebu: add Armada XP SoC-centric clock init
Date: Sat, 11 May 2013 03:08:06 +0200
Message-Id: <1368234490-31416-7-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is moving core clock and clock gating init for Armada XP to
its own file and adds a Kconfig option. Also init functions are added
and declared so they get called on of_clk_init.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/mvebu/Kconfig     |    5 +
 drivers/clk/mvebu/Makefile    |    1 +
 drivers/clk/mvebu/armada-xp.c |  204 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 210 insertions(+)
 create mode 100644 drivers/clk/mvebu/armada-xp.c

diff --git a/drivers/clk/mvebu/Kconfig b/drivers/clk/mvebu/Kconfig
index 1daf61e..8740d34 100644
--- a/drivers/clk/mvebu/Kconfig
+++ b/drivers/clk/mvebu/Kconfig
@@ -15,6 +15,11 @@ config ARMADA_370_CLK
 	select MVEBU_CLK_COMMON
 	select MVEBU_CLK_CPU
 
+config ARMADA_XP_CLK
+	bool
+	select MVEBU_CLK_COMMON
+	select MVEBU_CLK_CPU
+
 config DOVE_CLK
 	bool
 	select MVEBU_CLK_COMMON
diff --git a/drivers/clk/mvebu/Makefile b/drivers/clk/mvebu/Makefile
index 367b72c..13f3d22 100644
--- a/drivers/clk/mvebu/Makefile
+++ b/drivers/clk/mvebu/Makefile
@@ -4,5 +4,6 @@ obj-$(CONFIG_MVEBU_CLK_CPU) 	+= clk-cpu.o
 obj-$(CONFIG_MVEBU_CLK_GATING) 	+= clk-gating-ctrl.o
 
 obj-$(CONFIG_ARMADA_370_CLK)	+= armada-370.o
+obj-$(CONFIG_ARMADA_XP_CLK)	+= armada-xp.o
 obj-$(CONFIG_DOVE_CLK)		+= dove.o
 obj-$(CONFIG_KIRKWOOD_CLK)	+= kirkwood.o
diff --git a/drivers/clk/mvebu/armada-xp.c b/drivers/clk/mvebu/armada-xp.c
new file mode 100644
index 0000000..cf7612e
--- /dev/null
+++ b/drivers/clk/mvebu/armada-xp.c
@@ -0,0 +1,204 @@
+/*
+ * Marvell Armada XP SoC clocks
+ *
+ * Copyright (C) 2012 Marvell
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
+ *
+ * Armada XP Sample At Reset is a 64 bit bitfiled split in two
+ * register of 32 bits
+ */
+
+#define SARL				0	/* Low part [0:31] */
+#define	 SARL_AXP_PCLK_FREQ_OPT		21
+#define	 SARL_AXP_PCLK_FREQ_OPT_MASK	0x7
+#define	 SARL_AXP_FAB_FREQ_OPT		24
+#define	 SARL_AXP_FAB_FREQ_OPT_MASK	0xF
+#define SARH				4	/* High part [32:63] */
+#define	 SARH_AXP_PCLK_FREQ_OPT		(52-32)
+#define	 SARH_AXP_PCLK_FREQ_OPT_MASK	0x1
+#define	 SARH_AXP_PCLK_FREQ_OPT_SHIFT	3
+#define	 SARH_AXP_FAB_FREQ_OPT		(51-32)
+#define	 SARH_AXP_FAB_FREQ_OPT_MASK	0x1
+#define	 SARH_AXP_FAB_FREQ_OPT_SHIFT	4
+
+enum { AXP_CPU_TO_NBCLK, AXP_CPU_TO_HCLK, AXP_CPU_TO_DRAMCLK };
+
+static const struct coreclk_ratio __initconst axp_coreclk_ratios[] = {
+	{ .id = AXP_CPU_TO_NBCLK, .name = "nbclk" },
+	{ .id = AXP_CPU_TO_HCLK, .name = "hclk" },
+	{ .id = AXP_CPU_TO_DRAMCLK, .name = "dramclk" },
+};
+
+/* Armada XP TCLK frequency is fixed to 250MHz */
+static u32 __init axp_get_tclk_freq(void __iomem *sar)
+{
+	return 250000000;
+}
+
+static const u32 __initconst axp_cpu_freqs[] = {
+	1000000000,
+	1066000000,
+	1200000000,
+	1333000000,
+	1500000000,
+	1666000000,
+	1800000000,
+	2000000000,
+	667000000,
+	0,
+	800000000,
+	1600000000,
+};
+
+static u32 __init axp_get_cpu_freq(void __iomem *sar)
+{
+	u32 cpu_freq;
+	u8 cpu_freq_select = 0;
+
+	cpu_freq_select = ((readl(sar + SARL) >> SARL_AXP_PCLK_FREQ_OPT) &
+			   SARL_AXP_PCLK_FREQ_OPT_MASK);
+	/*
+	 * The upper bit is not contiguous to the other ones and
+	 * located in the high part of the SAR registers
+	 */
+	cpu_freq_select |= (((readl(sar + SARH) >> SARH_AXP_PCLK_FREQ_OPT) &
+	     SARH_AXP_PCLK_FREQ_OPT_MASK) << SARH_AXP_PCLK_FREQ_OPT_SHIFT);
+	if (cpu_freq_select >= ARRAY_SIZE(axp_cpu_freqs)) {
+		pr_err("CPU freq select unsupported: %d\n", cpu_freq_select);
+		cpu_freq = 0;
+	} else
+		cpu_freq = axp_cpu_freqs[cpu_freq_select];
+
+	return cpu_freq;
+}
+
+static const int __initconst axp_nbclk_ratios[32][2] = {
+	{0, 1}, {1, 2}, {2, 2}, {2, 2},
+	{1, 2}, {1, 2}, {1, 1}, {2, 3},
+	{0, 1}, {1, 2}, {2, 4}, {0, 1},
+	{1, 2}, {0, 1}, {0, 1}, {2, 2},
+	{0, 1}, {0, 1}, {0, 1}, {1, 1},
+	{2, 3}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {1, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+};
+
+static const int __initconst axp_hclk_ratios[32][2] = {
+	{0, 1}, {1, 2}, {2, 6}, {2, 3},
+	{1, 3}, {1, 4}, {1, 2}, {2, 6},
+	{0, 1}, {1, 6}, {2, 10}, {0, 1},
+	{1, 4}, {0, 1}, {0, 1}, {2, 5},
+	{0, 1}, {0, 1}, {0, 1}, {1, 2},
+	{2, 6}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {1, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+};
+
+static const int __initconst axp_dramclk_ratios[32][2] = {
+	{0, 1}, {1, 2}, {2, 3}, {2, 3},
+	{1, 3}, {1, 2}, {1, 2}, {2, 6},
+	{0, 1}, {1, 3}, {2, 5}, {0, 1},
+	{1, 4}, {0, 1}, {0, 1}, {2, 5},
+	{0, 1}, {0, 1}, {0, 1}, {1, 1},
+	{2, 3}, {0, 1}, {0, 1}, {0, 1},
+	{0, 1}, {0, 1}, {0, 1}, {1, 1},
+	{0, 1}, {0, 1}, {0, 1}, {0, 1},
+};
+
+static void __init axp_get_clk_ratio(
+	void __iomem *sar, int id, int *mult, int *div)
+{
+	u32 opt = ((readl(sar + SARL) >> SARL_AXP_FAB_FREQ_OPT) &
+	      SARL_AXP_FAB_FREQ_OPT_MASK);
+	/*
+	 * The upper bit is not contiguous to the other ones and
+	 * located in the high part of the SAR registers
+	 */
+	opt |= (((readl(sar + SARH) >> SARH_AXP_FAB_FREQ_OPT) &
+		 SARH_AXP_FAB_FREQ_OPT_MASK) << SARH_AXP_FAB_FREQ_OPT_SHIFT);
+
+	switch (id) {
+	case AXP_CPU_TO_NBCLK:
+		*mult = axp_nbclk_ratios[opt][0];
+		*div = axp_nbclk_ratios[opt][1];
+		break;
+	case AXP_CPU_TO_HCLK:
+		*mult = axp_hclk_ratios[opt][0];
+		*div = axp_hclk_ratios[opt][1];
+		break;
+	case AXP_CPU_TO_DRAMCLK:
+		*mult = axp_dramclk_ratios[opt][0];
+		*div = axp_dramclk_ratios[opt][1];
+		break;
+	}
+}
+
+static const struct coreclk_soc_desc axp_coreclks = {
+	.get_tclk_freq = axp_get_tclk_freq,
+	.get_cpu_freq = axp_get_cpu_freq,
+	.get_clk_ratio = axp_get_clk_ratio,
+	.ratios = axp_coreclk_ratios,
+	.num_ratios = ARRAY_SIZE(axp_coreclk_ratios),
+};
+
+static void __init axp_coreclk_init(struct device_node *np)
+{
+	mvebu_coreclk_setup(np, &axp_coreclks);
+}
+CLK_OF_DECLARE(axp_core_clk, "marvell,armada-xp-core-clock",
+	       axp_coreclk_init);
+
+/*
+ * Clock Gating Control
+ */
+
+static const struct clk_gating_soc_desc __initconst axp_gating_desc[] = {
+	{ "audio", NULL, 0, 0 },
+	{ "ge3", NULL, 1, 0 },
+	{ "ge2", NULL,  2, 0 },
+	{ "ge1", NULL, 3, 0 },
+	{ "ge0", NULL, 4, 0 },
+	{ "pex0", NULL, 5, 0 },
+	{ "pex1", NULL, 6, 0 },
+	{ "pex2", NULL, 7, 0 },
+	{ "pex3", NULL, 8, 0 },
+	{ "bp", NULL, 13, 0 },
+	{ "sata0lnk", NULL, 14, 0 },
+	{ "sata0", "sata0lnk", 15, 0 },
+	{ "lcd", NULL, 16, 0 },
+	{ "sdio", NULL, 17, 0 },
+	{ "usb0", NULL, 18, 0 },
+	{ "usb1", NULL, 19, 0 },
+	{ "usb2", NULL, 20, 0 },
+	{ "xor0", NULL, 22, 0 },
+	{ "crypto", NULL, 23, 0 },
+	{ "tdm", NULL, 25, 0 },
+	{ "xor1", NULL, 28, 0 },
+	{ "sata1lnk", NULL, 29, 0 },
+	{ "sata1", "sata1lnk", 30, 0 },
+	{ }
+};
+
+static void __init axp_clk_gating_init(struct device_node *np)
+{
+	mvebu_clk_gating_setup(np, axp_gating_desc);
+}
+CLK_OF_DECLARE(axp_clk_gating, "marvell,armada-xp-gating-clock",
+	       axp_clk_gating_init);
-- 
1.7.10.4

