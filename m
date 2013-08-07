Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab3HGOrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:47:18 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62358 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab3HGOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:47:11 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, swarren@nvidia.com
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/6] clk: Tegra: Add CPU0 clock driver
Date: Wed,  7 Aug 2013 20:16:43 +0530
Message-Id: <8d192a13cb7e088943da40689d62bc6353bd8604.1375886595.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375886595.git.viresh.kumar@linaro.org>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375886595.git.viresh.kumar@linaro.org>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds CPU0's clk driver for Tegra. It will be used by the generic
cpufreq-cpu0 driver to get/set cpu clk.

Most of the platform specific bits are picked from tegra-cpufreq.c.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/clk/tegra/Makefile      |   1 +
 drivers/clk/tegra/clk-cpu.c     | 164 ++++++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk-tegra30.c |   4 +
 include/linux/clk/tegra.h       |   1 +
 4 files changed, 170 insertions(+)
 create mode 100644 drivers/clk/tegra/clk-cpu.c

diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
index f49fac2..0e818c0 100644
--- a/drivers/clk/tegra/Makefile
+++ b/drivers/clk/tegra/Makefile
@@ -10,3 +10,4 @@ obj-y					+= clk-super.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= clk-tegra114.o
+obj-$(CONFIG_GENERIC_CPUFREQ_CPU0)	+= clk-cpu.o
diff --git a/drivers/clk/tegra/clk-cpu.c b/drivers/clk/tegra/clk-cpu.c
new file mode 100644
index 0000000..01716d6
--- /dev/null
+++ b/drivers/clk/tegra/clk-cpu.c
@@ -0,0 +1,164 @@
+/*
+ * Copyright (C) 2013 Linaro
+ *
+ * Author: Viresh Kumar <viresh.kumar@linaro.org>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+/*
+ * Responsible for setting cpu0 clk as requested by cpufreq-cpu0 driver
+ *
+ * All platform specific bits are taken from tegra-cpufreq driver.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/clk-provider.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+
+#define to_clk_cpu0(_hw) container_of(_hw, struct clk_cpu0, hw)
+
+struct clk_cpu0 {
+	struct clk_hw hw;
+	spinlock_t *lock;
+};
+
+static struct clk *cpu_clk;
+static struct clk *pll_x_clk;
+static struct clk *pll_p_clk;
+static struct clk *emc_clk;
+
+static unsigned long cpu0_recalc_rate(struct clk_hw *hw,
+		unsigned long parent_rate)
+{
+	return clk_get_rate(cpu_clk);
+}
+
+static long cpu0_round_rate(struct clk_hw *hw, unsigned long drate,
+		unsigned long *parent_rate)
+{
+	return clk_round_rate(cpu_clk, drate);
+}
+
+static int cpu0_set_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long parent_rate)
+{
+	int ret;
+
+	/*
+	 * Vote on memory bus frequency based on cpu frequency
+	 * This sets the minimum frequency, display or avp may request higher
+	 */
+	if (rate >= 816000000)
+		clk_set_rate(emc_clk, 600000000); /* cpu 816 MHz, emc max */
+	else if (rate >= 456000000)
+		clk_set_rate(emc_clk, 300000000); /* cpu 456 MHz, emc 150Mhz */
+	else
+		clk_set_rate(emc_clk, 100000000); /* emc 50Mhz */
+
+	/*
+	 * Take an extra reference to the main pll so it doesn't turn
+	 * off when we move the cpu off of it
+	 */
+	clk_prepare_enable(pll_x_clk);
+
+	ret = clk_set_parent(cpu_clk, pll_p_clk);
+	if (ret) {
+		pr_err("%s: Failed to switch cpu to clock pll_p\n", __func__);
+		goto out;
+	}
+
+	if (rate == clk_get_rate(pll_p_clk))
+		goto out;
+
+	ret = clk_set_rate(pll_x_clk, rate);
+	if (ret) {
+		pr_err("Failed to change pll_x to %lu\n", rate);
+		goto out;
+	}
+
+	ret = clk_set_parent(cpu_clk, pll_x_clk);
+	if (ret) {
+		pr_err("Failed to switch cpu to clock pll_x\n");
+		goto out;
+	}
+
+out:
+	clk_disable_unprepare(pll_x_clk);
+	return ret;
+}
+
+static struct clk_ops clk_cpu0_ops = {
+	.recalc_rate = cpu0_recalc_rate,
+	.round_rate = cpu0_round_rate,
+	.set_rate = cpu0_set_rate,
+};
+
+struct clk *tegra_clk_register_cpu0(void)
+{
+	struct clk_init_data init;
+	struct clk_cpu0 *cpu0;
+	struct clk *clk;
+
+	cpu0 = kzalloc(sizeof(*cpu0), GFP_KERNEL);
+	if (!cpu0) {
+		pr_err("%s: could not allocate cpu0 clk\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	cpu_clk = clk_get_sys(NULL, "cpu");
+	if (IS_ERR(cpu_clk)) {
+		clk = cpu_clk;
+		goto free_mem;
+	}
+
+	pll_x_clk = clk_get_sys(NULL, "pll_x");
+	if (IS_ERR(pll_x_clk)) {
+		clk = pll_x_clk;
+		goto put_cpu_clk;
+	}
+
+	pll_p_clk = clk_get_sys(NULL, "pll_p_cclk");
+	if (IS_ERR(pll_p_clk)) {
+		clk = pll_p_clk;
+		goto put_pll_x_clk;
+	}
+
+	emc_clk = clk_get_sys("cpu", "emc");
+	if (IS_ERR(emc_clk)) {
+		clk = emc_clk;
+		goto put_pll_p_clk;
+	}
+
+	cpu0->hw.init = &init;
+
+	init.name = "cpu0";
+	init.ops = &clk_cpu0_ops;
+	init.flags = CLK_IS_ROOT | CLK_GET_RATE_NOCACHE;
+	init.num_parents = 0;
+
+	clk = clk_register(NULL, &cpu0->hw);
+	if (!IS_ERR(clk))
+		return clk;
+
+	clk_prepare_enable(emc_clk);
+	clk_prepare_enable(cpu_clk);
+
+	clk_put(emc_clk);
+put_pll_p_clk:
+	clk_put(pll_p_clk);
+put_pll_x_clk:
+	clk_put(pll_x_clk);
+put_cpu_clk:
+	clk_put(cpu_clk);
+free_mem:
+	kfree(cpu0);
+
+	pr_err("%s: clk register failed\n", __func__);
+
+	return NULL;
+}
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index e2c6ca0..1cabeea 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1396,6 +1396,10 @@ static void __init tegra30_super_clk_init(void)
 					CLK_SET_RATE_PARENT, 1, 2);
 	clk_register_clkdev(clk, "twd", NULL);
 	clks[twd] = clk;
+
+	/* cpu0 clk for cpufreq driver */
+	clk = tegra_clk_register_cpu0();
+	clk_register_clkdev(clk, NULL, "cpu0");
 }
 
 static const char *mux_pllacp_clkm[] = { "pll_a_out0", "unused", "pll_p",
diff --git a/include/linux/clk/tegra.h b/include/linux/clk/tegra.h
index 23a0cee..d416138 100644
--- a/include/linux/clk/tegra.h
+++ b/include/linux/clk/tegra.h
@@ -128,5 +128,6 @@ static inline void tegra_periph_reset_deassert(struct clk *c) {}
 static inline void tegra_periph_reset_assert(struct clk *c) {}
 #endif
 void tegra_clocks_apply_init_table(void);
+struct clk *tegra_clk_register_cpu0(void);
 
 #endif /* __LINUX_CLK_TEGRA_H_ */
-- 
1.7.12.rc2.18.g61b472e

