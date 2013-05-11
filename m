Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3EKBKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 21:10:47 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44144 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab3EKBIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 21:08:21 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] clk: mvebu: add Kirkwood SoC-centric clock init
Date: Sat, 11 May 2013 03:08:04 +0200
Message-Id: <1368234490-31416-5-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is moving core clock and clock gating init for Kirkwood to its
own file and adds a Kconfig option. Also init functions are added and
declared so they get called on of_clk_init.

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
 drivers/clk/mvebu/Kconfig    |    4 +
 drivers/clk/mvebu/Makefile   |    1 +
 drivers/clk/mvebu/kirkwood.c |  247 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 252 insertions(+)
 create mode 100644 drivers/clk/mvebu/kirkwood.c

diff --git a/drivers/clk/mvebu/Kconfig b/drivers/clk/mvebu/Kconfig
index bc5f05e..211695c 100644
--- a/drivers/clk/mvebu/Kconfig
+++ b/drivers/clk/mvebu/Kconfig
@@ -13,3 +13,7 @@ config MVEBU_CLK_COMMON
 config DOVE_CLK
 	bool
 	select MVEBU_CLK_COMMON
+
+config KIRKWOOD_CLK
+	bool
+	select MVEBU_CLK_COMMON
diff --git a/drivers/clk/mvebu/Makefile b/drivers/clk/mvebu/Makefile
index bfc3078..97d1ab0 100644
--- a/drivers/clk/mvebu/Makefile
+++ b/drivers/clk/mvebu/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_MVEBU_CLK_CPU) 	+= clk-cpu.o
 obj-$(CONFIG_MVEBU_CLK_GATING) 	+= clk-gating-ctrl.o
 
 obj-$(CONFIG_DOVE_CLK)		+= dove.o
+obj-$(CONFIG_KIRKWOOD_CLK)	+= kirkwood.o
diff --git a/drivers/clk/mvebu/kirkwood.c b/drivers/clk/mvebu/kirkwood.c
new file mode 100644
index 0000000..71d2461
--- /dev/null
+++ b/drivers/clk/mvebu/kirkwood.c
@@ -0,0 +1,247 @@
+/*
+ * Marvell Kirkwood SoC clocks
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
+ * Kirkwood PLL sample-at-reset configuration
+ * (6180 has different SAR layout than other Kirkwood SoCs)
+ *
+ * SAR0[4:3,22,1] : CPU frequency (6281,6292,6282)
+ *	4  =  600 MHz
+ *	6  =  800 MHz
+ *	7  = 1000 MHz
+ *	9  = 1200 MHz
+ *	12 = 1500 MHz
+ *	13 = 1600 MHz
+ *	14 = 1800 MHz
+ *	15 = 2000 MHz
+ *	others reserved.
+ *
+ * SAR0[19,10:9] : CPU to L2 Clock divider ratio (6281,6292,6282)
+ *	1 = (1/2) * CPU
+ *	3 = (1/3) * CPU
+ *	5 = (1/4) * CPU
+ *	others reserved.
+ *
+ * SAR0[8:5] : CPU to DDR DRAM Clock divider ratio (6281,6292,6282)
+ *	2 = (1/2) * CPU
+ *	4 = (1/3) * CPU
+ *	6 = (1/4) * CPU
+ *	7 = (2/9) * CPU
+ *	8 = (1/5) * CPU
+ *	9 = (1/6) * CPU
+ *	others reserved.
+ *
+ * SAR0[4:2] : Kirkwood 6180 cpu/l2/ddr clock configuration (6180 only)
+ *	5 = [CPU =  600 MHz, L2 = (1/2) * CPU, DDR = 200 MHz = (1/3) * CPU]
+ *	6 = [CPU =  800 MHz, L2 = (1/2) * CPU, DDR = 200 MHz = (1/4) * CPU]
+ *	7 = [CPU = 1000 MHz, L2 = (1/2) * CPU, DDR = 200 MHz = (1/5) * CPU]
+ *	others reserved.
+ *
+ * SAR0[21] : TCLK frequency
+ *	0 = 200 MHz
+ *	1 = 166 MHz
+ *	others reserved.
+ */
+
+#define SAR_KIRKWOOD_CPU_FREQ(x)	\
+	(((x & (1 <<  1)) >>  1) |	\
+	 ((x & (1 << 22)) >> 21) |	\
+	 ((x & (3 <<  3)) >>  1))
+#define SAR_KIRKWOOD_L2_RATIO(x)	\
+	(((x & (3 <<  9)) >> 9) |	\
+	 (((x & (1 << 19)) >> 17)))
+#define SAR_KIRKWOOD_DDR_RATIO		5
+#define SAR_KIRKWOOD_DDR_RATIO_MASK	0xf
+#define SAR_MV88F6180_CLK		2
+#define SAR_MV88F6180_CLK_MASK		0x7
+#define SAR_KIRKWOOD_TCLK_FREQ		21
+#define SAR_KIRKWOOD_TCLK_FREQ_MASK	0x1
+
+enum { KIRKWOOD_CPU_TO_L2, KIRKWOOD_CPU_TO_DDR };
+
+static const struct coreclk_ratio __initconst kirkwood_coreclk_ratios[] = {
+	{ .id = KIRKWOOD_CPU_TO_L2, .name = "l2clk", },
+	{ .id = KIRKWOOD_CPU_TO_DDR, .name = "ddrclk", }
+};
+
+static u32 __init kirkwood_get_tclk_freq(void __iomem *sar)
+{
+	u32 opt = (readl(sar) >> SAR_KIRKWOOD_TCLK_FREQ) &
+		SAR_KIRKWOOD_TCLK_FREQ_MASK;
+	return (opt) ? 166666667 : 200000000;
+}
+
+static const u32 __initconst kirkwood_cpu_freqs[] = {
+	0, 0, 0, 0,
+	600000000,
+	0,
+	800000000,
+	1000000000,
+	0,
+	1200000000,
+	0, 0,
+	1500000000,
+	1600000000,
+	1800000000,
+	2000000000
+};
+
+static u32 __init kirkwood_get_cpu_freq(void __iomem *sar)
+{
+	u32 opt = SAR_KIRKWOOD_CPU_FREQ(readl(sar));
+	return kirkwood_cpu_freqs[opt];
+}
+
+static const int __initconst kirkwood_cpu_l2_ratios[8][2] = {
+	{ 0, 1 }, { 1, 2 }, { 0, 1 }, { 1, 3 },
+	{ 0, 1 }, { 1, 4 }, { 0, 1 }, { 0, 1 }
+};
+
+static const int __initconst kirkwood_cpu_ddr_ratios[16][2] = {
+	{ 0, 1 }, { 0, 1 }, { 1, 2 }, { 0, 1 },
+	{ 1, 3 }, { 0, 1 }, { 1, 4 }, { 2, 9 },
+	{ 1, 5 }, { 1, 6 }, { 0, 1 }, { 0, 1 },
+	{ 0, 1 }, { 0, 1 }, { 0, 1 }, { 0, 1 }
+};
+
+static void __init kirkwood_get_clk_ratio(
+	void __iomem *sar, int id, int *mult, int *div)
+{
+	switch (id) {
+	case KIRKWOOD_CPU_TO_L2:
+	{
+		u32 opt = SAR_KIRKWOOD_L2_RATIO(readl(sar));
+		*mult = kirkwood_cpu_l2_ratios[opt][0];
+		*div = kirkwood_cpu_l2_ratios[opt][1];
+		break;
+	}
+	case KIRKWOOD_CPU_TO_DDR:
+	{
+		u32 opt = (readl(sar) >> SAR_KIRKWOOD_DDR_RATIO) &
+			SAR_KIRKWOOD_DDR_RATIO_MASK;
+		*mult = kirkwood_cpu_ddr_ratios[opt][0];
+		*div = kirkwood_cpu_ddr_ratios[opt][1];
+		break;
+	}
+	}
+}
+
+static const u32 __initconst mv88f6180_cpu_freqs[] = {
+	0, 0, 0, 0, 0,
+	600000000,
+	800000000,
+	1000000000
+};
+
+static u32 __init mv88f6180_get_cpu_freq(void __iomem *sar)
+{
+	u32 opt = (readl(sar) >> SAR_MV88F6180_CLK) & SAR_MV88F6180_CLK_MASK;
+	return mv88f6180_cpu_freqs[opt];
+}
+
+static const int __initconst mv88f6180_cpu_ddr_ratios[8][2] = {
+	{ 0, 1 }, { 0, 1 }, { 0, 1 }, { 0, 1 },
+	{ 0, 1 }, { 1, 3 }, { 1, 4 }, { 1, 5 }
+};
+
+static void __init mv88f6180_get_clk_ratio(
+	void __iomem *sar, int id, int *mult, int *div)
+{
+	switch (id) {
+	case KIRKWOOD_CPU_TO_L2:
+	{
+		/* mv88f6180 has a fixed 1:2 CPU-to-L2 ratio */
+		*mult = 1;
+		*div = 2;
+		break;
+	}
+	case KIRKWOOD_CPU_TO_DDR:
+	{
+		u32 opt = (readl(sar) >> SAR_MV88F6180_CLK) &
+			SAR_MV88F6180_CLK_MASK;
+		*mult = mv88f6180_cpu_ddr_ratios[opt][0];
+		*div = mv88f6180_cpu_ddr_ratios[opt][1];
+		break;
+	}
+	}
+}
+
+static const struct coreclk_soc_desc kirkwood_coreclks = {
+	.get_tclk_freq = kirkwood_get_tclk_freq,
+	.get_cpu_freq = kirkwood_get_cpu_freq,
+	.get_clk_ratio = kirkwood_get_clk_ratio,
+	.ratios = kirkwood_coreclk_ratios,
+	.num_ratios = ARRAY_SIZE(kirkwood_coreclk_ratios),
+};
+
+static void __init kirkwood_coreclk_init(struct device_node *np)
+{
+	mvebu_coreclk_setup(np, &kirkwood_coreclks);
+}
+CLK_OF_DECLARE(kirkwood_core_clk, "marvell,kirkwood-core-clock",
+	       kirkwood_coreclk_init);
+
+static const struct coreclk_soc_desc mv88f6180_coreclks = {
+	.get_tclk_freq = kirkwood_get_tclk_freq,
+	.get_cpu_freq = mv88f6180_get_cpu_freq,
+	.get_clk_ratio = mv88f6180_get_clk_ratio,
+	.ratios = kirkwood_coreclk_ratios,
+	.num_ratios = ARRAY_SIZE(kirkwood_coreclk_ratios),
+};
+
+static void __init mv88f6180_coreclk_init(struct device_node *np)
+{
+	mvebu_coreclk_setup(np, &mv88f6180_coreclks);
+}
+CLK_OF_DECLARE(mv88f6180_core_clk, "marvell,mv88f6180-core-clock",
+	       mv88f6180_coreclk_init);
+
+/*
+ * Clock Gating Control
+ */
+
+static const struct clk_gating_soc_desc __initconst kirkwood_gating_desc[] = {
+	{ "ge0", NULL, 0, 0 },
+	{ "pex0", NULL, 2, 0 },
+	{ "usb0", NULL, 3, 0 },
+	{ "sdio", NULL, 4, 0 },
+	{ "tsu", NULL, 5, 0 },
+	{ "runit", NULL, 7, 0 },
+	{ "xor0", NULL, 8, 0 },
+	{ "audio", NULL, 9, 0 },
+	{ "powersave", "cpuclk", 11, 0 },
+	{ "sata0", NULL, 14, 0 },
+	{ "sata1", NULL, 15, 0 },
+	{ "xor1", NULL, 16, 0 },
+	{ "crypto", NULL, 17, 0 },
+	{ "pex1", NULL, 18, 0 },
+	{ "ge1", NULL, 19, 0 },
+	{ "tdm", NULL, 20, 0 },
+	{ }
+};
+
+static void __init kirkwood_clk_gating_init(struct device_node *np)
+{
+	mvebu_clk_gating_setup(np, kirkwood_gating_desc);
+}
+CLK_OF_DECLARE(kirkwood_clk_gating, "marvell,kirkwood-gating-clock",
+	       kirkwood_clk_gating_init);
-- 
1.7.10.4

