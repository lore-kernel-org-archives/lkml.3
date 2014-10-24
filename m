Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbaJXOlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:41:11 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:52930 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445AbaJXOlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:41:01 -0400
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com,
        pdeschrijver@nvidia.com, rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: mturquette@linaro.org, pwalmsley@nvidia.com, vinceh@nvidia.com,
        pgaikwad@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tuomas.tynkkynen@iki.fi,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>
Subject: [PATCH v5 12/16] cpufreq: tegra: Rename tegra-cpufreq to tegra20-cpufreq
Date: Fri, 24 Oct 2014 17:39:19 +0300
Message-Id: <1414161563-16812-13-git-send-email-mikko.perttunen@kapsi.fi>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414161563-16812-1-git-send-email-mikko.perttunen@kapsi.fi>
References: <1414161563-16812-1-git-send-email-mikko.perttunen@kapsi.fi>
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

The Tegra124 will use a different driver for frequency scaling, so
rename the old driver (which handles only Tegra20) appropriately.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Signed-off-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
---
 drivers/cpufreq/Kconfig.arm       |   6 +-
 drivers/cpufreq/Makefile          |   2 +-
 drivers/cpufreq/tegra-cpufreq.c   | 218 --------------------------------------
 drivers/cpufreq/tegra20-cpufreq.c | 218 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 222 insertions(+), 222 deletions(-)
 delete mode 100644 drivers/cpufreq/tegra-cpufreq.c
 create mode 100644 drivers/cpufreq/tegra20-cpufreq.c

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 83a75dc..22419f4 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -241,9 +241,9 @@ config ARM_SPEAR_CPUFREQ
 	help
 	  This adds the CPUFreq driver support for SPEAr SOCs.
 
-config ARM_TEGRA_CPUFREQ
-	bool "TEGRA CPUFreq support"
+config ARM_TEGRA20_CPUFREQ
+	bool "Tegra20 CPUFreq support"
 	depends on ARCH_TEGRA
 	default y
 	help
-	  This adds the CPUFreq driver support for TEGRA SOCs.
+	  This adds the CPUFreq driver support for Tegra20 SOCs.
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 40c53dc..0d3ec1c 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -75,7 +75,7 @@ obj-$(CONFIG_ARM_S5PV210_CPUFREQ)	+= s5pv210-cpufreq.o
 obj-$(CONFIG_ARM_SA1100_CPUFREQ)	+= sa1100-cpufreq.o
 obj-$(CONFIG_ARM_SA1110_CPUFREQ)	+= sa1110-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
-obj-$(CONFIG_ARM_TEGRA_CPUFREQ)		+= tegra-cpufreq.o
+obj-$(CONFIG_ARM_TEGRA20_CPUFREQ)	+= tegra20-cpufreq.o
 obj-$(CONFIG_ARM_VEXPRESS_SPC_CPUFREQ)	+= vexpress-spc-cpufreq.o
 
 ##################################################################################
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
deleted file mode 100644
index 8084c7f..0000000
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ /dev/null
@@ -1,218 +0,0 @@
-/*
- * Copyright (C) 2010 Google, Inc.
- *
- * Author:
- *	Colin Cross <ccross@google.com>
- *	Based on arch/arm/plat-omap/cpu-omap.c, (C) 2005 Nokia Corporation
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/sched.h>
-#include <linux/cpufreq.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/err.h>
-#include <linux/clk.h>
-#include <linux/io.h>
-
-static struct cpufreq_frequency_table freq_table[] = {
-	{ .frequency = 216000 },
-	{ .frequency = 312000 },
-	{ .frequency = 456000 },
-	{ .frequency = 608000 },
-	{ .frequency = 760000 },
-	{ .frequency = 816000 },
-	{ .frequency = 912000 },
-	{ .frequency = 1000000 },
-	{ .frequency = CPUFREQ_TABLE_END },
-};
-
-#define NUM_CPUS	2
-
-static struct clk *cpu_clk;
-static struct clk *pll_x_clk;
-static struct clk *pll_p_clk;
-static struct clk *emc_clk;
-static bool pll_x_prepared;
-
-static unsigned int tegra_get_intermediate(struct cpufreq_policy *policy,
-					   unsigned int index)
-{
-	unsigned int ifreq = clk_get_rate(pll_p_clk) / 1000;
-
-	/*
-	 * Don't switch to intermediate freq if:
-	 * - we are already at it, i.e. policy->cur == ifreq
-	 * - index corresponds to ifreq
-	 */
-	if ((freq_table[index].frequency == ifreq) || (policy->cur == ifreq))
-		return 0;
-
-	return ifreq;
-}
-
-static int tegra_target_intermediate(struct cpufreq_policy *policy,
-				     unsigned int index)
-{
-	int ret;
-
-	/*
-	 * Take an extra reference to the main pll so it doesn't turn
-	 * off when we move the cpu off of it as enabling it again while we
-	 * switch to it from tegra_target() would take additional time.
-	 *
-	 * When target-freq is equal to intermediate freq we don't need to
-	 * switch to an intermediate freq and so this routine isn't called.
-	 * Also, we wouldn't be using pll_x anymore and must not take extra
-	 * reference to it, as it can be disabled now to save some power.
-	 */
-	clk_prepare_enable(pll_x_clk);
-
-	ret = clk_set_parent(cpu_clk, pll_p_clk);
-	if (ret)
-		clk_disable_unprepare(pll_x_clk);
-	else
-		pll_x_prepared = true;
-
-	return ret;
-}
-
-static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
-{
-	unsigned long rate = freq_table[index].frequency;
-	unsigned int ifreq = clk_get_rate(pll_p_clk) / 1000;
-	int ret = 0;
-
-	/*
-	 * Vote on memory bus frequency based on cpu frequency
-	 * This sets the minimum frequency, display or avp may request higher
-	 */
-	if (rate >= 816000)
-		clk_set_rate(emc_clk, 600000000); /* cpu 816 MHz, emc max */
-	else if (rate >= 456000)
-		clk_set_rate(emc_clk, 300000000); /* cpu 456 MHz, emc 150Mhz */
-	else
-		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
-
-	/*
-	 * target freq == pll_p, don't need to take extra reference to pll_x_clk
-	 * as it isn't used anymore.
-	 */
-	if (rate == ifreq)
-		return clk_set_parent(cpu_clk, pll_p_clk);
-
-	ret = clk_set_rate(pll_x_clk, rate * 1000);
-	/* Restore to earlier frequency on error, i.e. pll_x */
-	if (ret)
-		pr_err("Failed to change pll_x to %lu\n", rate);
-
-	ret = clk_set_parent(cpu_clk, pll_x_clk);
-	/* This shouldn't fail while changing or restoring */
-	WARN_ON(ret);
-
-	/*
-	 * Drop count to pll_x clock only if we switched to intermediate freq
-	 * earlier while transitioning to a target frequency.
-	 */
-	if (pll_x_prepared) {
-		clk_disable_unprepare(pll_x_clk);
-		pll_x_prepared = false;
-	}
-
-	return ret;
-}
-
-static int tegra_cpu_init(struct cpufreq_policy *policy)
-{
-	int ret;
-
-	if (policy->cpu >= NUM_CPUS)
-		return -EINVAL;
-
-	clk_prepare_enable(emc_clk);
-	clk_prepare_enable(cpu_clk);
-
-	/* FIXME: what's the actual transition time? */
-	ret = cpufreq_generic_init(policy, freq_table, 300 * 1000);
-	if (ret) {
-		clk_disable_unprepare(cpu_clk);
-		clk_disable_unprepare(emc_clk);
-		return ret;
-	}
-
-	policy->clk = cpu_clk;
-	policy->suspend_freq = freq_table[0].frequency;
-	return 0;
-}
-
-static int tegra_cpu_exit(struct cpufreq_policy *policy)
-{
-	clk_disable_unprepare(cpu_clk);
-	clk_disable_unprepare(emc_clk);
-	return 0;
-}
-
-static struct cpufreq_driver tegra_cpufreq_driver = {
-	.flags			= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
-	.verify			= cpufreq_generic_frequency_table_verify,
-	.get_intermediate	= tegra_get_intermediate,
-	.target_intermediate	= tegra_target_intermediate,
-	.target_index		= tegra_target,
-	.get			= cpufreq_generic_get,
-	.init			= tegra_cpu_init,
-	.exit			= tegra_cpu_exit,
-	.name			= "tegra",
-	.attr			= cpufreq_generic_attr,
-#ifdef CONFIG_PM
-	.suspend		= cpufreq_generic_suspend,
-#endif
-};
-
-static int __init tegra_cpufreq_init(void)
-{
-	cpu_clk = clk_get_sys(NULL, "cclk");
-	if (IS_ERR(cpu_clk))
-		return PTR_ERR(cpu_clk);
-
-	pll_x_clk = clk_get_sys(NULL, "pll_x");
-	if (IS_ERR(pll_x_clk))
-		return PTR_ERR(pll_x_clk);
-
-	pll_p_clk = clk_get_sys(NULL, "pll_p");
-	if (IS_ERR(pll_p_clk))
-		return PTR_ERR(pll_p_clk);
-
-	emc_clk = clk_get_sys("cpu", "emc");
-	if (IS_ERR(emc_clk)) {
-		clk_put(cpu_clk);
-		return PTR_ERR(emc_clk);
-	}
-
-	return cpufreq_register_driver(&tegra_cpufreq_driver);
-}
-
-static void __exit tegra_cpufreq_exit(void)
-{
-        cpufreq_unregister_driver(&tegra_cpufreq_driver);
-	clk_put(emc_clk);
-	clk_put(cpu_clk);
-}
-
-
-MODULE_AUTHOR("Colin Cross <ccross@android.com>");
-MODULE_DESCRIPTION("cpufreq driver for Nvidia Tegra2");
-MODULE_LICENSE("GPL");
-module_init(tegra_cpufreq_init);
-module_exit(tegra_cpufreq_exit);
diff --git a/drivers/cpufreq/tegra20-cpufreq.c b/drivers/cpufreq/tegra20-cpufreq.c
new file mode 100644
index 0000000..8084c7f
--- /dev/null
+++ b/drivers/cpufreq/tegra20-cpufreq.c
@@ -0,0 +1,218 @@
+/*
+ * Copyright (C) 2010 Google, Inc.
+ *
+ * Author:
+ *	Colin Cross <ccross@google.com>
+ *	Based on arch/arm/plat-omap/cpu-omap.c, (C) 2005 Nokia Corporation
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/cpufreq.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+
+static struct cpufreq_frequency_table freq_table[] = {
+	{ .frequency = 216000 },
+	{ .frequency = 312000 },
+	{ .frequency = 456000 },
+	{ .frequency = 608000 },
+	{ .frequency = 760000 },
+	{ .frequency = 816000 },
+	{ .frequency = 912000 },
+	{ .frequency = 1000000 },
+	{ .frequency = CPUFREQ_TABLE_END },
+};
+
+#define NUM_CPUS	2
+
+static struct clk *cpu_clk;
+static struct clk *pll_x_clk;
+static struct clk *pll_p_clk;
+static struct clk *emc_clk;
+static bool pll_x_prepared;
+
+static unsigned int tegra_get_intermediate(struct cpufreq_policy *policy,
+					   unsigned int index)
+{
+	unsigned int ifreq = clk_get_rate(pll_p_clk) / 1000;
+
+	/*
+	 * Don't switch to intermediate freq if:
+	 * - we are already at it, i.e. policy->cur == ifreq
+	 * - index corresponds to ifreq
+	 */
+	if ((freq_table[index].frequency == ifreq) || (policy->cur == ifreq))
+		return 0;
+
+	return ifreq;
+}
+
+static int tegra_target_intermediate(struct cpufreq_policy *policy,
+				     unsigned int index)
+{
+	int ret;
+
+	/*
+	 * Take an extra reference to the main pll so it doesn't turn
+	 * off when we move the cpu off of it as enabling it again while we
+	 * switch to it from tegra_target() would take additional time.
+	 *
+	 * When target-freq is equal to intermediate freq we don't need to
+	 * switch to an intermediate freq and so this routine isn't called.
+	 * Also, we wouldn't be using pll_x anymore and must not take extra
+	 * reference to it, as it can be disabled now to save some power.
+	 */
+	clk_prepare_enable(pll_x_clk);
+
+	ret = clk_set_parent(cpu_clk, pll_p_clk);
+	if (ret)
+		clk_disable_unprepare(pll_x_clk);
+	else
+		pll_x_prepared = true;
+
+	return ret;
+}
+
+static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
+{
+	unsigned long rate = freq_table[index].frequency;
+	unsigned int ifreq = clk_get_rate(pll_p_clk) / 1000;
+	int ret = 0;
+
+	/*
+	 * Vote on memory bus frequency based on cpu frequency
+	 * This sets the minimum frequency, display or avp may request higher
+	 */
+	if (rate >= 816000)
+		clk_set_rate(emc_clk, 600000000); /* cpu 816 MHz, emc max */
+	else if (rate >= 456000)
+		clk_set_rate(emc_clk, 300000000); /* cpu 456 MHz, emc 150Mhz */
+	else
+		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
+
+	/*
+	 * target freq == pll_p, don't need to take extra reference to pll_x_clk
+	 * as it isn't used anymore.
+	 */
+	if (rate == ifreq)
+		return clk_set_parent(cpu_clk, pll_p_clk);
+
+	ret = clk_set_rate(pll_x_clk, rate * 1000);
+	/* Restore to earlier frequency on error, i.e. pll_x */
+	if (ret)
+		pr_err("Failed to change pll_x to %lu\n", rate);
+
+	ret = clk_set_parent(cpu_clk, pll_x_clk);
+	/* This shouldn't fail while changing or restoring */
+	WARN_ON(ret);
+
+	/*
+	 * Drop count to pll_x clock only if we switched to intermediate freq
+	 * earlier while transitioning to a target frequency.
+	 */
+	if (pll_x_prepared) {
+		clk_disable_unprepare(pll_x_clk);
+		pll_x_prepared = false;
+	}
+
+	return ret;
+}
+
+static int tegra_cpu_init(struct cpufreq_policy *policy)
+{
+	int ret;
+
+	if (policy->cpu >= NUM_CPUS)
+		return -EINVAL;
+
+	clk_prepare_enable(emc_clk);
+	clk_prepare_enable(cpu_clk);
+
+	/* FIXME: what's the actual transition time? */
+	ret = cpufreq_generic_init(policy, freq_table, 300 * 1000);
+	if (ret) {
+		clk_disable_unprepare(cpu_clk);
+		clk_disable_unprepare(emc_clk);
+		return ret;
+	}
+
+	policy->clk = cpu_clk;
+	policy->suspend_freq = freq_table[0].frequency;
+	return 0;
+}
+
+static int tegra_cpu_exit(struct cpufreq_policy *policy)
+{
+	clk_disable_unprepare(cpu_clk);
+	clk_disable_unprepare(emc_clk);
+	return 0;
+}
+
+static struct cpufreq_driver tegra_cpufreq_driver = {
+	.flags			= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
+	.verify			= cpufreq_generic_frequency_table_verify,
+	.get_intermediate	= tegra_get_intermediate,
+	.target_intermediate	= tegra_target_intermediate,
+	.target_index		= tegra_target,
+	.get			= cpufreq_generic_get,
+	.init			= tegra_cpu_init,
+	.exit			= tegra_cpu_exit,
+	.name			= "tegra",
+	.attr			= cpufreq_generic_attr,
+#ifdef CONFIG_PM
+	.suspend		= cpufreq_generic_suspend,
+#endif
+};
+
+static int __init tegra_cpufreq_init(void)
+{
+	cpu_clk = clk_get_sys(NULL, "cclk");
+	if (IS_ERR(cpu_clk))
+		return PTR_ERR(cpu_clk);
+
+	pll_x_clk = clk_get_sys(NULL, "pll_x");
+	if (IS_ERR(pll_x_clk))
+		return PTR_ERR(pll_x_clk);
+
+	pll_p_clk = clk_get_sys(NULL, "pll_p");
+	if (IS_ERR(pll_p_clk))
+		return PTR_ERR(pll_p_clk);
+
+	emc_clk = clk_get_sys("cpu", "emc");
+	if (IS_ERR(emc_clk)) {
+		clk_put(cpu_clk);
+		return PTR_ERR(emc_clk);
+	}
+
+	return cpufreq_register_driver(&tegra_cpufreq_driver);
+}
+
+static void __exit tegra_cpufreq_exit(void)
+{
+        cpufreq_unregister_driver(&tegra_cpufreq_driver);
+	clk_put(emc_clk);
+	clk_put(cpu_clk);
+}
+
+
+MODULE_AUTHOR("Colin Cross <ccross@android.com>");
+MODULE_DESCRIPTION("cpufreq driver for Nvidia Tegra2");
+MODULE_LICENSE("GPL");
+module_init(tegra_cpufreq_init);
+module_exit(tegra_cpufreq_exit);
-- 
2.1.0

