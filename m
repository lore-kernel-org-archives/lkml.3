Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaGJVoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:44:03 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17598 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaGJVn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:43:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 Jul 2014 14:33:01 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, <devicetree@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 12/13] cpufreq: Add cpufreq driver for Tegra124
Date: Fri, 11 Jul 2014 00:42:48 +0300
Message-ID: <1405028569-14253-13-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new cpufreq driver for Tegra124. Instead of using the PLLX as
the CPU clocksource, switch immediately to the DFLL. It allows the use
of higher clock rates, and will automatically scale the CPU voltage as
well. We also rely on the DFLL driver to determine the CPU clock
frequencies that the chip supports, so that we can directly build a
cpufreq table with the OPP library helper dev_pm_opp_init_cpufreq_table.

This driver is a completely independent of the old cpufreq driver
(tegra-cpufreq), which is only used on Tegra20.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
A platform_driver_register() followed by platform_device_register_simple()
looks pretty weird, but being a platform device is required for probe
deferral. Any better ways to handle this?

 drivers/cpufreq/Makefile           |   1 +
 drivers/cpufreq/tegra124-cpufreq.c | 221 +++++++++++++++++++++++++++++++++++++
 2 files changed, 222 insertions(+)
 create mode 100644 drivers/cpufreq/tegra124-cpufreq.c

diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index db6d9a2..3437d24 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_ARM_SA1100_CPUFREQ)	+= sa1100-cpufreq.o
 obj-$(CONFIG_ARM_SA1110_CPUFREQ)	+= sa1110-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
 obj-$(CONFIG_ARM_TEGRA_CPUFREQ)		+= tegra-cpufreq.o
+obj-$(CONFIG_ARM_TEGRA_CPUFREQ)		+= tegra124-cpufreq.o
 obj-$(CONFIG_ARM_VEXPRESS_SPC_CPUFREQ)	+= vexpress-spc-cpufreq.o
 
 ##################################################################################
diff --git a/drivers/cpufreq/tegra124-cpufreq.c b/drivers/cpufreq/tegra124-cpufreq.c
new file mode 100644
index 0000000..3e29af4
--- /dev/null
+++ b/drivers/cpufreq/tegra124-cpufreq.c
@@ -0,0 +1,221 @@
+/*
+ * Tegra 124 cpufreq driver
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
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/clk.h>
+#include <linux/cpufreq.h>
+#include <linux/cpu.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm_opp.h>
+#include <linux/types.h>
+
+static struct cpufreq_frequency_table *freq_table;
+
+static struct device *cpu_dev;
+static struct clk *cpu_clk;
+static struct clk *pllp_clk;
+static struct clk *pllx_clk;
+static struct clk *dfll_clk;
+
+static int tegra124_target(struct cpufreq_policy *policy, unsigned int index)
+{
+	unsigned long cpu_rate = freq_table[index].frequency;
+	int ret;
+
+	ret = clk_set_rate(dfll_clk, cpu_rate * 1000);
+	if (ret)
+		pr_err("Failed to set cpu frequency to %lu kHz\n", cpu_rate);
+
+	return ret;
+}
+
+static int tegra124_cpu_init(struct cpufreq_policy *policy)
+{
+	int ret;
+
+	clk_prepare_enable(cpu_clk);
+
+	/* FIXME: what's the actual transition time? */
+	ret = cpufreq_generic_init(policy, freq_table, 300 * 1000);
+	if (ret) {
+		clk_disable_unprepare(cpu_clk);
+		return ret;
+	}
+
+	policy->clk = cpu_clk;
+	policy->suspend_freq = freq_table[0].frequency;
+	return 0;
+}
+
+static int tegra124_cpu_exit(struct cpufreq_policy *policy)
+{
+	clk_disable_unprepare(cpu_clk);
+	return 0;
+}
+
+static int tegra124_cpu_switch_to_dfll(void)
+{
+	struct clk *original_cpu_clk_parent;
+	unsigned long rate;
+	struct dev_pm_opp *opp;
+	int ret;
+
+	rate = clk_get_rate(cpu_clk);
+	opp = dev_pm_opp_find_freq_ceil(cpu_dev, &rate);
+	if (IS_ERR(opp))
+		return PTR_ERR(opp);
+
+	ret = clk_set_rate(dfll_clk, rate);
+	if (ret)
+		return ret;
+
+	original_cpu_clk_parent = clk_get_parent(cpu_clk);
+	clk_set_parent(cpu_clk, pllp_clk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(dfll_clk);
+	if (ret)
+		goto out_switch_to_original_parent;
+
+	clk_set_parent(cpu_clk, dfll_clk);
+
+	return 0;
+
+out_switch_to_original_parent:
+	clk_set_parent(cpu_clk, original_cpu_clk_parent);
+
+	return ret;
+}
+
+static struct cpufreq_driver tegra124_cpufreq_driver = {
+	.verify		= cpufreq_generic_frequency_table_verify,
+	.target_index	= tegra124_target,
+	.get		= cpufreq_generic_get,
+	.init		= tegra124_cpu_init,
+	.exit		= tegra124_cpu_exit,
+	.name		= "tegra124",
+	.attr		= cpufreq_generic_attr,
+#ifdef CONFIG_PM
+	.suspend	= cpufreq_generic_suspend,
+#endif
+};
+
+static int tegra124_cpufreq_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	cpu_dev = get_cpu_device(0);
+	if (!cpu_dev)
+		return -ENODEV;
+
+	cpu_clk = of_clk_get_by_name(cpu_dev->of_node, "cpu_g");
+	if (IS_ERR(cpu_clk))
+		return PTR_ERR(cpu_clk);
+
+	dfll_clk = of_clk_get_by_name(cpu_dev->of_node, "dfll");
+	if (IS_ERR(dfll_clk)) {
+		ret = PTR_ERR(dfll_clk);
+		goto out_put_cpu_clk;
+	}
+
+	pllx_clk = of_clk_get_by_name(cpu_dev->of_node, "pll_x");
+	if (IS_ERR(pllx_clk)) {
+		ret = PTR_ERR(pllx_clk);
+		goto out_put_dfll_clk;
+	}
+
+	pllp_clk = of_clk_get_by_name(cpu_dev->of_node, "pll_p");
+	if (IS_ERR(pllp_clk)) {
+		ret = PTR_ERR(pllp_clk);
+		goto out_put_pllx_clk;
+	}
+
+	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
+	if (ret)
+		goto out_put_pllp_clk;
+
+	ret = tegra124_cpu_switch_to_dfll();
+	if (ret)
+		goto out_free_table;
+
+	ret = cpufreq_register_driver(&tegra124_cpufreq_driver);
+	if (ret) {
+		/*
+		 * The VDD_CPU voltage may have been changed at this point and
+		 * and switching back to PLLX might not be safe. Don't even try.
+		 */
+		pr_err("failed to register cpufreq driver: %d\n", ret);
+	}
+
+	return ret;
+
+out_free_table:
+	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
+out_put_pllp_clk:
+	clk_put(pllp_clk);
+out_put_pllx_clk:
+	clk_put(pllx_clk);
+out_put_dfll_clk:
+	clk_put(dfll_clk);
+out_put_cpu_clk:
+	clk_put(cpu_clk);
+
+	return ret;
+}
+
+static struct platform_driver tegra124_cpufreq_platdrv = {
+	.driver = {
+		.name	= "cpufreq-tegra124",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tegra124_cpufreq_probe,
+};
+
+static const struct of_device_id soc_of_matches[] = {
+	{ .compatible = "nvidia,tegra124", },
+	{}
+};
+
+static int __init tegra_cpufreq_init(void)
+{
+	int ret;
+	struct platform_device *pdev;
+
+	if (!of_find_matching_node(NULL, soc_of_matches))
+		return -ENODEV;
+
+	ret = platform_driver_register(&tegra124_cpufreq_platdrv);
+	if (ret)
+		return ret;
+
+	pdev = platform_device_register_simple("cpufreq-tegra124", -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		platform_driver_unregister(&tegra124_cpufreq_platdrv);
+		return PTR_ERR(pdev);
+	}
+
+	return 0;
+}
+
+MODULE_AUTHOR("Tuomas Tynkkynen <ttynkkynen@nvidia.com>");
+MODULE_DESCRIPTION("cpufreq driver for nVIDIA Tegra124");
+MODULE_LICENSE("GPLv2");
+module_init(tegra_cpufreq_init);
-- 
1.8.1.5

