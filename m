Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab3EKBKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 21:10:48 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:38397 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab3EKBIV (ORCPT
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
Subject: [PATCH 03/10] clk: mvebu: add Dove SoC-centric clock init
Date: Sat, 11 May 2013 03:08:03 +0200
Message-Id: <1368234490-31416-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is moving core clock and clock gating init for Dove to its own
file and adds a Kconfig option. Also init functions are added and
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
 drivers/clk/mvebu/Kconfig  |    4 +
 drivers/clk/mvebu/Makefile |    2 +
 drivers/clk/mvebu/dove.c   |  194 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 200 insertions(+)
 create mode 100644 drivers/clk/mvebu/dove.c

diff --git a/drivers/clk/mvebu/Kconfig b/drivers/clk/mvebu/Kconfig
index 2c3cf95..bc5f05e 100644
--- a/drivers/clk/mvebu/Kconfig
+++ b/drivers/clk/mvebu/Kconfig
@@ -9,3 +9,7 @@ config MVEBU_CLK_GATING
 
 config MVEBU_CLK_COMMON
 	bool
+
+config DOVE_CLK
+	bool
+	select MVEBU_CLK_COMMON
diff --git a/drivers/clk/mvebu/Makefile b/drivers/clk/mvebu/Makefile
index 2143230..bfc3078 100644
--- a/drivers/clk/mvebu/Makefile
+++ b/drivers/clk/mvebu/Makefile
@@ -2,3 +2,5 @@ obj-$(CONFIG_MVEBU_CLK_COMMON)	+= common.o
 obj-$(CONFIG_MVEBU_CLK_CORE) 	+= clk.o clk-core.o
 obj-$(CONFIG_MVEBU_CLK_CPU) 	+= clk-cpu.o
 obj-$(CONFIG_MVEBU_CLK_GATING) 	+= clk-gating-ctrl.o
+
+obj-$(CONFIG_DOVE_CLK)		+= dove.o
diff --git a/drivers/clk/mvebu/dove.c b/drivers/clk/mvebu/dove.c
new file mode 100644
index 0000000..79d7aed
--- /dev/null
+++ b/drivers/clk/mvebu/dove.c
@@ -0,0 +1,194 @@
+/*
+ * Marvell Dove SoC clocks
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
+ * Dove PLL sample-at-reset configuration
+ *
+ * SAR0[8:5]   : CPU frequency
+ *		 5  = 1000 MHz
+ *		 6  =  933 MHz
+ *		 7  =  933 MHz
+ *		 8  =  800 MHz
+ *		 9  =  800 MHz
+ *		 10 =  800 MHz
+ *		 11 = 1067 MHz
+ *		 12 =  667 MHz
+ *		 13 =  533 MHz
+ *		 14 =  400 MHz
+ *		 15 =  333 MHz
+ *		 others reserved.
+ *
+ * SAR0[11:9]  : CPU to L2 Clock divider ratio
+ *		 0 = (1/1) * CPU
+ *		 2 = (1/2) * CPU
+ *		 4 = (1/3) * CPU
+ *		 6 = (1/4) * CPU
+ *		 others reserved.
+ *
+ * SAR0[15:12] : CPU to DDR DRAM Clock divider ratio
+ *		 0  = (1/1) * CPU
+ *		 2  = (1/2) * CPU
+ *		 3  = (2/5) * CPU
+ *		 4  = (1/3) * CPU
+ *		 6  = (1/4) * CPU
+ *		 8  = (1/5) * CPU
+ *		 10 = (1/6) * CPU
+ *		 12 = (1/7) * CPU
+ *		 14 = (1/8) * CPU
+ *		 15 = (1/10) * CPU
+ *		 others reserved.
+ *
+ * SAR0[24:23] : TCLK frequency
+ *		 0 = 166 MHz
+ *		 1 = 125 MHz
+ *		 others reserved.
+ */
+
+#define SAR_DOVE_CPU_FREQ		5
+#define SAR_DOVE_CPU_FREQ_MASK		0xf
+#define SAR_DOVE_L2_RATIO		9
+#define SAR_DOVE_L2_RATIO_MASK		0x7
+#define SAR_DOVE_DDR_RATIO		12
+#define SAR_DOVE_DDR_RATIO_MASK		0xf
+#define SAR_DOVE_TCLK_FREQ		23
+#define SAR_DOVE_TCLK_FREQ_MASK		0x3
+
+enum { DOVE_CPU_TO_L2, DOVE_CPU_TO_DDR };
+
+static const struct coreclk_ratio __initconst dove_coreclk_ratios[] = {
+	{ .id = DOVE_CPU_TO_L2, .name = "l2clk", },
+	{ .id = DOVE_CPU_TO_DDR, .name = "ddrclk", }
+};
+
+static const u32 __initconst dove_tclk_freqs[] = {
+	166666667,
+	125000000,
+	0, 0
+};
+
+static u32 __init dove_get_tclk_freq(void __iomem *sar)
+{
+	u32 opt = (readl(sar) >> SAR_DOVE_TCLK_FREQ) &
+		SAR_DOVE_TCLK_FREQ_MASK;
+	return dove_tclk_freqs[opt];
+}
+
+static const u32 __initconst dove_cpu_freqs[] = {
+	0, 0, 0, 0, 0,
+	1000000000,
+	933333333, 933333333,
+	800000000, 800000000, 800000000,
+	1066666667,
+	666666667,
+	533333333,
+	400000000,
+	333333333
+};
+
+static u32 __init dove_get_cpu_freq(void __iomem *sar)
+{
+	u32 opt = (readl(sar) >> SAR_DOVE_CPU_FREQ) &
+		SAR_DOVE_CPU_FREQ_MASK;
+	return dove_cpu_freqs[opt];
+}
+
+static const int __initconst dove_cpu_l2_ratios[8][2] = {
+	{ 1, 1 }, { 0, 1 }, { 1, 2 }, { 0, 1 },
+	{ 1, 3 }, { 0, 1 }, { 1, 4 }, { 0, 1 }
+};
+
+static const int __initconst dove_cpu_ddr_ratios[16][2] = {
+	{ 1, 1 }, { 0, 1 }, { 1, 2 }, { 2, 5 },
+	{ 1, 3 }, { 0, 1 }, { 1, 4 }, { 0, 1 },
+	{ 1, 5 }, { 0, 1 }, { 1, 6 }, { 0, 1 },
+	{ 1, 7 }, { 0, 1 }, { 1, 8 }, { 1, 10 }
+};
+
+static void __init dove_get_clk_ratio(
+	void __iomem *sar, int id, int *mult, int *div)
+{
+	switch (id) {
+	case DOVE_CPU_TO_L2:
+	{
+		u32 opt = (readl(sar) >> SAR_DOVE_L2_RATIO) &
+			SAR_DOVE_L2_RATIO_MASK;
+		*mult = dove_cpu_l2_ratios[opt][0];
+		*div = dove_cpu_l2_ratios[opt][1];
+		break;
+	}
+	case DOVE_CPU_TO_DDR:
+	{
+		u32 opt = (readl(sar) >> SAR_DOVE_DDR_RATIO) &
+			SAR_DOVE_DDR_RATIO_MASK;
+		*mult = dove_cpu_ddr_ratios[opt][0];
+		*div = dove_cpu_ddr_ratios[opt][1];
+		break;
+	}
+	}
+}
+
+static const struct coreclk_soc_desc dove_coreclks = {
+	.get_tclk_freq = dove_get_tclk_freq,
+	.get_cpu_freq = dove_get_cpu_freq,
+	.get_clk_ratio = dove_get_clk_ratio,
+	.ratios = dove_coreclk_ratios,
+	.num_ratios = ARRAY_SIZE(dove_coreclk_ratios),
+};
+
+static void __init dove_coreclk_init(struct device_node *np)
+{
+	mvebu_coreclk_setup(np, &dove_coreclks);
+}
+CLK_OF_DECLARE(dove_core_clk, "marvell,dove-core-clock", dove_coreclk_init);
+
+/*
+ * Clock Gating Control
+ */
+
+static const struct clk_gating_soc_desc __initconst dove_gating_desc[] = {
+	{ "usb0", NULL, 0, 0 },
+	{ "usb1", NULL, 1, 0 },
+	{ "ge",	"gephy", 2, 0 },
+	{ "sata", NULL, 3, 0 },
+	{ "pex0", NULL, 4, 0 },
+	{ "pex1", NULL, 5, 0 },
+	{ "sdio0", NULL, 8, 0 },
+	{ "sdio1", NULL, 9, 0 },
+	{ "nand", NULL, 10, 0 },
+	{ "camera", NULL, 11, 0 },
+	{ "i2s0", NULL, 12, 0 },
+	{ "i2s1", NULL, 13, 0 },
+	{ "crypto", NULL, 15, 0 },
+	{ "ac97", NULL, 21, 0 },
+	{ "pdma", NULL, 22, 0 },
+	{ "xor0", NULL, 23, 0 },
+	{ "xor1", NULL, 24, 0 },
+	{ "gephy", NULL, 30, 0 },
+	{ }
+};
+
+static void __init dove_clk_gating_init(struct device_node *np)
+{
+	mvebu_clk_gating_setup(np, dove_gating_desc);
+}
+CLK_OF_DECLARE(dove_clk_gating, "marvell,dove-gating-clock",
+	       dove_clk_gating_init);
-- 
1.7.10.4

