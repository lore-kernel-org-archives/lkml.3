Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3FGMVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:21:50 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:45015 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab3FGMVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:21:43 -0400
MBOX-Line: From nobody Fri Jun  7 06:18:58 2013
Subject: [PATCH 1/3] clk: tegra: T114: add FCPU clock shaper programming,
 needed by the DFLL
To: linux-tegra@vger.kernel.org, mturquette@linaro.org
From: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Andrew Chew <achew@nvidia.com>, Aleksandr Frid <afrid@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Matthew Longnecker <mlongnecker@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 07 Jun 2013 06:18:58 -0600
Message-ID: <20130607121851.21868.16993.stgit@dusk.lan>
In-Reply-To: <20130607121505.21868.72360.stgit@dusk.lan>
References: <20130607121505.21868.72360.stgit@dusk.lan>
User-Agent: StGit/0.16-37-g27ac3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clock functions to initialize, enable, and disable the FCPU clock
shapers, based on the FCPU voltage rail state.  These will be used by
the DFLL clocksource driver code.

This version of the patch contains a fix for a problem noticed by Andrew
Chew <achew@nvidia.com>, where some of the FINETRIM_R bitfields were
incorrectly defined.

Based on code originally written by Aleksandr Frid <afrid@nvidia.com>.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Andrew Chew <achew@nvidia.com>
Reviewed-by: Andrew Chew <achew@nvidia.com>
Cc: Matthew Longnecker <mlongnecker@nvidia.com>
Cc: Aleksandr Frid <afrid@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c |  118 ++++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.h          |    4 +
 2 files changed, 122 insertions(+)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index eb27764..c6e35d4 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -21,6 +21,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/delay.h>
+#include <linux/export.h>
 #include <linux/clk/tegra.h>
 
 #include "clk.h"
@@ -41,8 +42,33 @@
 #define RST_DEVICES_CLR_V		0x434
 #define RST_DEVICES_SET_W		0x438
 #define RST_DEVICES_CLR_W		0x43c
+#define CPU_FINETRIM_SELECT		0x4d4	/* override default prop dlys */
+#define CPU_FINETRIM_DR			0x4d8	/* rise->rise prop dly A */
+#define CPU_FINETRIM_R			0x4e4	/* rise->rise prop dly inc A */
 #define RST_DEVICES_NUM			5
 
+/* CPU_FINETRIM_SELECT and CPU_FINETRIM_DR bitfields */
+#define CPU_FINETRIM_1_FCPU_1		BIT(0)	/* fcpu0 */
+#define CPU_FINETRIM_1_FCPU_2		BIT(1)	/* fcpu1 */
+#define CPU_FINETRIM_1_FCPU_3		BIT(2)	/* fcpu2 */
+#define CPU_FINETRIM_1_FCPU_4		BIT(3)	/* fcpu3 */
+#define CPU_FINETRIM_1_FCPU_5		BIT(4)	/* fl2 */
+#define CPU_FINETRIM_1_FCPU_6		BIT(5)	/* ftop */
+
+/* CPU_FINETRIM_R bitfields */
+#define CPU_FINETRIM_R_FCPU_1_SHIFT	0		/* fcpu0 */
+#define CPU_FINETRIM_R_FCPU_1_MASK	(0x3 << CPU_FINETRIM_R_FCPU_1_SHIFT)
+#define CPU_FINETRIM_R_FCPU_2_SHIFT	2		/* fcpu1 */
+#define CPU_FINETRIM_R_FCPU_2_MASK	(0x3 << CPU_FINETRIM_R_FCPU_2_SHIFT)
+#define CPU_FINETRIM_R_FCPU_3_SHIFT	4		/* fcpu2 */
+#define CPU_FINETRIM_R_FCPU_3_MASK	(0x3 << CPU_FINETRIM_R_FCPU_3_SHIFT)
+#define CPU_FINETRIM_R_FCPU_4_SHIFT	6		/* fcpu3 */
+#define CPU_FINETRIM_R_FCPU_4_MASK	(0x3 << CPU_FINETRIM_R_FCPU_4_SHIFT)
+#define CPU_FINETRIM_R_FCPU_5_SHIFT	8		/* fl2 */
+#define CPU_FINETRIM_R_FCPU_5_MASK	(0x3 << CPU_FINETRIM_R_FCPU_5_SHIFT)
+#define CPU_FINETRIM_R_FCPU_6_SHIFT	10		/* ftop */
+#define CPU_FINETRIM_R_FCPU_6_MASK	(0x3 << CPU_FINETRIM_R_FCPU_6_SHIFT)
+
 #define CLK_OUT_ENB_L			0x010
 #define CLK_OUT_ENB_H			0x014
 #define CLK_OUT_ENB_U			0x018
@@ -2054,6 +2080,98 @@ static void __init tegra114_clock_apply_init_table(void)
 	tegra_init_from_table(init_table, clks, clk_max);
 }
 
+
+/**
+ * tegra114_car_barrier - wait for pending writes to the CAR to complete
+ *
+ * Wait for any outstanding writes to the CAR MMIO space from this CPU
+ * to complete before continuing execution.  No return value.
+ */
+static void tegra114_car_barrier(void)
+{
+	wmb();		/* probably unnecessary */
+	readl_relaxed(clk_base + CPU_FINETRIM_SELECT);
+}
+
+/**
+ * tegra114_clock_tune_cpu_trimmers_high - use high-voltage propagation delays
+ *
+ * When the CPU rail voltage is in the high-voltage range, use the
+ * built-in hardwired clock propagation delays in the CPU clock
+ * shaper.  No return value.
+ */
+void tegra114_clock_tune_cpu_trimmers_high(void)
+{
+	u32 select = 0;
+
+	/* Use hardwired rise->rise & fall->fall clock propagation delays */
+	select |= ~(CPU_FINETRIM_1_FCPU_1 | CPU_FINETRIM_1_FCPU_2 |
+		    CPU_FINETRIM_1_FCPU_3 | CPU_FINETRIM_1_FCPU_4 |
+		    CPU_FINETRIM_1_FCPU_5 | CPU_FINETRIM_1_FCPU_6);
+	writel_relaxed(select, clk_base + CPU_FINETRIM_SELECT);
+
+	tegra114_car_barrier();
+}
+EXPORT_SYMBOL(tegra114_clock_tune_cpu_trimmers_high);
+
+/**
+ * tegra114_clock_tune_cpu_trimmers_low - use low-voltage propagation delays
+ *
+ * When the CPU rail voltage is in the low-voltage range, use the
+ * extended clock propagation delays set by
+ * tegra114_clock_tune_cpu_trimmers_init().  The intention is to
+ * maintain the input clock duty cycle that the FCPU subsystem
+ * expects.  No return value.
+ */
+void tegra114_clock_tune_cpu_trimmers_low(void)
+{
+	u32 select = 0;
+
+	/*
+	 * Use software-specified rise->rise & fall->fall clock
+	 * propagation delays (from
+	 * tegra114_clock_tune_cpu_trimmers_init()
+	 */
+	select |= (CPU_FINETRIM_1_FCPU_1 | CPU_FINETRIM_1_FCPU_2 |
+		   CPU_FINETRIM_1_FCPU_3 | CPU_FINETRIM_1_FCPU_4 |
+		   CPU_FINETRIM_1_FCPU_5 | CPU_FINETRIM_1_FCPU_6);
+	writel_relaxed(select, clk_base + CPU_FINETRIM_SELECT);
+
+	tegra114_car_barrier();
+}
+EXPORT_SYMBOL(tegra114_clock_tune_cpu_trimmers_low);
+
+/**
+ * tegra114_clock_tune_cpu_trimmers_init - set up and enable clk prop delays
+ *
+ * Program extended clock propagation delays into the FCPU clock
+ * shaper and enable them.  XXX Define the purpose - peak current
+ * reduction?  No return value.
+ */
+/* XXX Initial voltage rail state assumption issues? */
+void tegra114_clock_tune_cpu_trimmers_init(void)
+{
+	u32 dr = 0, r = 0;
+
+	/* Increment the rise->rise clock delay by four steps */
+	r |= (CPU_FINETRIM_R_FCPU_1_MASK | CPU_FINETRIM_R_FCPU_2_MASK |
+	      CPU_FINETRIM_R_FCPU_3_MASK | CPU_FINETRIM_R_FCPU_4_MASK |
+	      CPU_FINETRIM_R_FCPU_5_MASK | CPU_FINETRIM_R_FCPU_6_MASK);
+	writel_relaxed(r, clk_base + CPU_FINETRIM_R);
+
+	/*
+	 * Use the rise->rise clock propagation delay specified in the
+	 * r field
+	 */
+	dr |= (CPU_FINETRIM_1_FCPU_1 | CPU_FINETRIM_1_FCPU_2 |
+	       CPU_FINETRIM_1_FCPU_3 | CPU_FINETRIM_1_FCPU_4 |
+	       CPU_FINETRIM_1_FCPU_5 | CPU_FINETRIM_1_FCPU_6);
+	writel_relaxed(dr, clk_base + CPU_FINETRIM_DR);
+
+	tegra114_clock_tune_cpu_trimmers_low();
+}
+EXPORT_SYMBOL(tegra114_clock_tune_cpu_trimmers_init);
+
 static void __init tegra114_clock_init(struct device_node *np)
 {
 	struct device_node *node;
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 11278a8..c0b72fc 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -571,6 +571,10 @@ void tegra_init_from_table(struct tegra_clk_init_table *tbl,
 void tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 		struct clk *clks[], int clk_max);
 
+void tegra114_clock_tune_cpu_trimmers_high(void);
+void tegra114_clock_tune_cpu_trimmers_low(void);
+void tegra114_clock_tune_cpu_trimmers_init(void);
+
 typedef void (*tegra_clk_apply_init_table_func)(void);
 extern tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
 


