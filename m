Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaHTVFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 17:05:55 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17862 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaHTVFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 17:05:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Aug 2014 13:56:11 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        <devicetree@vger.kernel.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v4 13/16] cpufreq: Add cpufreq driver for Tegra124
Date: Thu, 21 Aug 2014 00:04:41 +0300
Message-ID: <1408568684-11016-14-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1408568684-11016-1-git-send-email-ttynkkynen@nvidia.com>
References: <1408568684-11016-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new cpufreq driver for Tegra124. Instead of using the PLLX as
the CPU clocksource, switch immediately to the DFLL. It allows the use
of higher clock rates, and will automatically scale the CPU voltage as
well. Besides the CPU clocksource switch, we let the cpufreq-cpu0 driver
for all the cpufreq operations.

This driver also relies on the DFLL driver to fill the OPP table for the
CPU0 device, so that the cpufreq-cpu0 driver knows what frequencies to
use.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
v4:
 - check for get_cpu_device() return value
 - add comment why an extra platform driver+device is required
 - back to 'depends on GENERIC_CPUFREQ_CPU0'

v3:
 - separate Kconfig entry
 - use 'select GENERIC_CPUFREQ_CPU0', not depends
 - support unbinding of the platform device
 - allocate a state structure instead of globals
 - use of_match_machine()
 - various style nits fixed
---
 drivers/cpufreq/Kconfig.arm        |   7 ++
 drivers/cpufreq/Makefile           |   1 +
 drivers/cpufreq/tegra124-cpufreq.c | 215 +++++++++++++++++++++++++++++++++++++
 3 files changed, 223 insertions(+)
 create mode 100644 drivers/cpufreq/tegra124-cpufreq.c

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 3795a16..5dd4cb3 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -247,3 +247,10 @@ config ARM_TEGRA20_CPUFREQ
 	default y
 	help
 	  This adds the CPUFreq driver support for Tegra20 SOCs.
+
+config ARM_TEGRA124_CPUFREQ
+	bool "Tegra124 CPUFreq support"
+	depends on ARCH_TEGRA && GENERIC_CPUFREQ_CPU0
+	default y
+	help
+	  This adds the CPUFreq driver support for Tegra124 SOCs.
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 428451a..25b4f53 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_ARM_SA1100_CPUFREQ)	+= sa1100-cpufreq.o
 obj-$(CONFIG_ARM_SA1110_CPUFREQ)	+= sa1110-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
 obj-$(CONFIG_ARM_TEGRA20_CPUFREQ)	+= tegra20-cpufreq.o
+obj-$(CONFIG_ARM_TEGRA124_CPUFREQ)	+= tegra124-cpufreq.o
 obj-$(CONFIG_ARM_VEXPRESS_SPC_CPUFREQ)	+= vexpress-spc-cpufreq.o
 
 ##################################################################################
diff --git a/drivers/cpufreq/tegra124-cpufreq.c b/drivers/cpufreq/tegra124-cpufreq.c
new file mode 100644
index 0000000..50c7a3a
--- /dev/null
+++ b/drivers/cpufreq/tegra124-cpufreq.c
@@ -0,0 +1,215 @@
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
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm_opp.h>
+#include <linux/regulator/consumer.h>
+#include <linux/types.h>
+
+struct tegra124_cpufreq_priv {
+	struct regulator *vdd_cpu_reg;
+	struct clk *cpu_clk;
+	struct clk *pllp_clk;
+	struct clk *pllx_clk;
+	struct clk *dfll_clk;
+	struct platform_device *cpufreq_cpu0_pdev;
+};
+
+static int tegra124_cpu_switch_to_dfll(struct tegra124_cpufreq_priv *priv)
+{
+	struct clk *orig_parent;
+	int ret;
+
+	ret = clk_set_rate(priv->dfll_clk, clk_get_rate(priv->cpu_clk));
+	if (ret)
+		return ret;
+
+	orig_parent = clk_get_parent(priv->cpu_clk);
+	clk_set_parent(priv->cpu_clk, priv->pllp_clk);
+
+	ret = clk_prepare_enable(priv->dfll_clk);
+	if (ret)
+		goto out;
+
+	clk_set_parent(priv->cpu_clk, priv->dfll_clk);
+
+	return 0;
+
+out:
+	clk_set_parent(priv->cpu_clk, orig_parent);
+
+	return ret;
+}
+
+static void tegra124_cpu_switch_to_pllx(struct tegra124_cpufreq_priv *priv)
+{
+	clk_set_parent(priv->cpu_clk, priv->pllp_clk);
+	clk_disable_unprepare(priv->dfll_clk);
+	regulator_sync_voltage(priv->vdd_cpu_reg);
+	clk_set_parent(priv->cpu_clk, priv->pllx_clk);
+}
+
+static int tegra124_cpufreq_probe(struct platform_device *pdev)
+{
+	struct tegra124_cpufreq_priv *priv;
+	struct device_node *np;
+	struct device *cpu_dev;
+	struct platform_device_info cpufreq_cpu0_devinfo = {};
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	cpu_dev = get_cpu_device(0);
+	if (!cpu_dev)
+		return -ENODEV;
+
+	np = of_cpu_device_node_get(0);
+	if (!np)
+		return -ENODEV;
+
+	priv->vdd_cpu_reg = regulator_get(cpu_dev, "vdd-cpu");
+	if (IS_ERR(priv->vdd_cpu_reg)) {
+		ret = PTR_ERR(priv->vdd_cpu_reg);
+		goto out_put_np;
+	}
+
+	priv->cpu_clk = of_clk_get_by_name(np, "cpu_g");
+	if (IS_ERR(priv->cpu_clk)) {
+		ret = PTR_ERR(priv->cpu_clk);
+		goto out_put_vdd_cpu_reg;
+	}
+
+	priv->dfll_clk = of_clk_get_by_name(np, "dfll");
+	if (IS_ERR(priv->dfll_clk)) {
+		ret = PTR_ERR(priv->dfll_clk);
+		goto out_put_cpu_clk;
+	}
+
+	priv->pllx_clk = of_clk_get_by_name(np, "pll_x");
+	if (IS_ERR(priv->pllx_clk)) {
+		ret = PTR_ERR(priv->pllx_clk);
+		goto out_put_dfll_clk;
+	}
+
+	priv->pllp_clk = of_clk_get_by_name(np, "pll_p");
+	if (IS_ERR(priv->pllp_clk)) {
+		ret = PTR_ERR(priv->pllp_clk);
+		goto out_put_pllx_clk;
+	}
+
+	ret = tegra124_cpu_switch_to_dfll(priv);
+	if (ret)
+		goto out_put_pllp_clk;
+
+	cpufreq_cpu0_devinfo.name = "cpufreq-cpu0";
+	cpufreq_cpu0_devinfo.parent = &pdev->dev;
+
+	priv->cpufreq_cpu0_pdev =
+		platform_device_register_full(&cpufreq_cpu0_devinfo);
+	if (IS_ERR(priv->cpufreq_cpu0_pdev)) {
+		ret = PTR_ERR(priv->cpufreq_cpu0_pdev);
+		goto out_switch_to_pllx;
+	}
+
+	platform_set_drvdata(pdev, priv);
+
+	return 0;
+
+out_switch_to_pllx:
+	tegra124_cpu_switch_to_pllx(priv);
+out_put_pllp_clk:
+	clk_put(priv->pllp_clk);
+out_put_pllx_clk:
+	clk_put(priv->pllx_clk);
+out_put_dfll_clk:
+	clk_put(priv->dfll_clk);
+out_put_cpu_clk:
+	clk_put(priv->cpu_clk);
+out_put_vdd_cpu_reg:
+	regulator_put(priv->vdd_cpu_reg);
+out_put_np:
+	of_node_put(np);
+
+	return ret;
+}
+
+static int tegra124_cpufreq_remove(struct platform_device *pdev)
+{
+	struct tegra124_cpufreq_priv *priv = platform_get_drvdata(pdev);
+
+	platform_device_unregister(priv->cpufreq_cpu0_pdev);
+	tegra124_cpu_switch_to_pllx(priv);
+
+	clk_put(priv->pllp_clk);
+	clk_put(priv->pllx_clk);
+	clk_put(priv->dfll_clk);
+	clk_put(priv->cpu_clk);
+	regulator_put(priv->vdd_cpu_reg);
+
+	return 0;
+}
+
+static struct platform_driver tegra124_cpufreq_platdrv = {
+	.driver = {
+		.name	= "cpufreq-tegra124",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tegra124_cpufreq_probe,
+	.remove		= tegra124_cpufreq_remove,
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
+	if (!of_match_machine(soc_of_matches))
+		return -ENODEV;
+
+	/*
+	 * Platform driver+device required for handling EPROBE_DEFER with
+	 * the regulator and the DFLL clock
+	 */
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
+module_init(tegra_cpufreq_init);
+
+MODULE_AUTHOR("Tuomas Tynkkynen <ttynkkynen@nvidia.com>");
+MODULE_DESCRIPTION("cpufreq driver for NVIDIA Tegra124");
+MODULE_LICENSE("GPL v2");
-- 
1.8.1.5

