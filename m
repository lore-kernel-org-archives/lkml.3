Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbaJXOnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:43:24 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:46668 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756592AbaJXOlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:41:03 -0400
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com,
        pdeschrijver@nvidia.com, rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: mturquette@linaro.org, pwalmsley@nvidia.com, vinceh@nvidia.com,
        pgaikwad@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tuomas.tynkkynen@iki.fi,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>
Subject: [PATCH v5 13/16] cpufreq: Add cpufreq driver for Tegra124
Date: Fri, 24 Oct 2014 17:39:20 +0300
Message-Id: <1414161563-16812-14-git-send-email-mikko.perttunen@kapsi.fi>
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

Add a new cpufreq driver for Tegra124. Instead of using the PLLX as
the CPU clocksource, switch immediately to the DFLL. It allows the use
of higher clock rates, and will automatically scale the CPU voltage as
well. Besides the CPU clocksource switch, we let the cpufreq-dt driver
for all the cpufreq operations.

This driver also relies on the DFLL driver to fill the OPP table for the
CPU0 device, so that the cpufreq-dt driver knows what frequencies to
use.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
---
v5:
- Use of_is_machine_compatible in name of getting this merged some time.
  We can explore better alternatives once a need arises (multiple supported SoCs
  with separate parameter requirements)
- Changed references of cpufreq-cpu0 to cpufreq-dt since it was renamed
- Use cpufreq-dt platform data to specify that all cpus run off the same clock

 drivers/cpufreq/Kconfig.arm        |   7 ++
 drivers/cpufreq/Makefile           |   1 +
 drivers/cpufreq/tegra124-cpufreq.c | 217 +++++++++++++++++++++++++++++++++++++
 3 files changed, 225 insertions(+)
 create mode 100644 drivers/cpufreq/tegra124-cpufreq.c

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 22419f4..93d51de 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -247,3 +247,10 @@ config ARM_TEGRA20_CPUFREQ
 	default y
 	help
 	  This adds the CPUFreq driver support for Tegra20 SOCs.
+
+config ARM_TEGRA124_CPUFREQ
+	bool "Tegra124 CPUFreq support"
+	depends on ARCH_TEGRA && CPUFREQ_DT
+	default y
+	help
+	  This adds the CPUFreq driver support for Tegra124 SOCs.
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 0d3ec1c..a7d8256 100644
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
index 0000000..45778ce
--- /dev/null
+++ b/drivers/cpufreq/tegra124-cpufreq.c
@@ -0,0 +1,217 @@
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
+#include <linux/cpufreq-dt.h>
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
+	struct platform_device *cpufreq_dt_pdev;
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
+static struct cpufreq_dt_platform_data cpufreq_dt_pd = {
+	.independent_clocks = false,
+};
+
+static int tegra124_cpufreq_probe(struct platform_device *pdev)
+{
+	struct tegra124_cpufreq_priv *priv;
+	struct device_node *np;
+	struct device *cpu_dev;
+	struct platform_device_info cpufreq_dt_devinfo = {};
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
+	cpufreq_dt_devinfo.name = "cpufreq-dt";
+	cpufreq_dt_devinfo.parent = &pdev->dev;
+	cpufreq_dt_devinfo.data = &cpufreq_dt_pd;
+	cpufreq_dt_devinfo.size_data = sizeof(cpufreq_dt_pd);
+
+	priv->cpufreq_dt_pdev =
+		platform_device_register_full(&cpufreq_dt_devinfo);
+	if (IS_ERR(priv->cpufreq_dt_pdev)) {
+		ret = PTR_ERR(priv->cpufreq_dt_pdev);
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
+	platform_device_unregister(priv->cpufreq_dt_pdev);
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
+static int __init tegra_cpufreq_init(void)
+{
+	int ret;
+	struct platform_device *pdev;
+
+	if (!of_machine_is_compatible("nvidia,tegra124"))
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
2.1.0

