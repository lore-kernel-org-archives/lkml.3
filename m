Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab3CGEOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:14:08 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61645 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab3CGEOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:14:06 -0500
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 1/4] cpufreq: exynos: Adding cpufreq driver for exynos5440
Date: Thu,  7 Mar 2013 09:43:44 +0530
Message-Id: <1362629627-10012-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dvfs support for exynos5440 SOC. This soc has 4 cores and
they scale at same frequency. The nature of exynos5440 clock controller is
different from previous exynos controllers so not using the common exynos
cpufreq framework. The major difference being interrupt notfication for
frequency change. Also, OPP library is used for device tree parsing to get
different parameters like frequency, voltage etc. Since the opp library sorts
the frequency table in ascending order so they are again re-arranged in
descending order. This will have one-to-one mapping with the clock controller
state management logic.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
Changes in V3:
* Converted the driver to probe based as suggested by Viresh. This is also
  beneficial for multiplatform kernel.
* Other coding guidelines related changes.

Changes in V2:
* Added OPP library support to parse DT parameters.
* Removed a hack to handle interrupts in bootup.
* Implemented other review comments from Viresh and Inder.

All these patches are dependent on Thomas Abraham common clock patches.
(http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg15860.html)
This whole patch series is based on 3.9-rc1.
 
 .../bindings/cpufreq/cpufreq-exynos5440.txt        |   29 ++
 drivers/cpufreq/Kconfig.arm                        |    9 +
 drivers/cpufreq/Makefile                           |    1 +
 drivers/cpufreq/exynos5440-cpufreq.c               |  467 ++++++++++++++++++++
 4 files changed, 506 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
 create mode 100644 drivers/cpufreq/exynos5440-cpufreq.c

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
new file mode 100644
index 0000000..a0dbe0b
--- /dev/null
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
@@ -0,0 +1,29 @@
+
+Exynos5440 cpufreq driver
+-------------------
+
+Exynos5440 SoC cpufreq driver for CPU frequency scaling.
+
+Required properties:
+- interrupts: Interrupt to know the completion of cpu frequency change.
+- operating-points: Table of frequencies and voltage CPU could be transitioned into,
+	in the decreasing order. Frequency should be in KHZ units and voltage
+	should be in microvolts.
+
+Optional properties:
+- clock-latency: Clock monitor latency in microsecond.
+
+All the required listed above must be defined under node cpufreq.
+
+Example:
+--------
+	cpufreq@160000 {
+		compatible = "samsung,exynos5440-cpufreq";
+		reg = <0x160000 0x1000>;
+		interrupts = <0 57 0>;
+		operating-points = <
+				1000000 975000
+				800000  925000>;
+		clock-latency = <100000>;
+	};
+
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 030ddf6..7ed9c4a 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -77,6 +77,15 @@ config ARM_EXYNOS5250_CPUFREQ
 	  This adds the CPUFreq driver for Samsung EXYNOS5250
 	  SoC.
 
+config ARM_EXYNOS5440_CPUFREQ
+	def_bool SOC_EXYNOS5440
+	depends on HAVE_CLK && PM_OPP && OF
+	help
+	  This adds the CPUFreq driver for Samsung EXYNOS5440
+	  SoC. The nature of exynos5440 clock controller is
+	  different than previous exynos controllers so not using
+	  the common exynos framework.
+
 config ARM_KIRKWOOD_CPUFREQ
 	def_bool ARCH_KIRKWOOD && OF
 	help
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 863fd18..c841438 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_ARM_EXYNOS_CPUFREQ)	+= exynos-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)	+= exynos4210-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS4X12_CPUFREQ)	+= exynos4x12-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS5250_CPUFREQ)	+= exynos5250-cpufreq.o
+obj-$(CONFIG_ARM_EXYNOS5440_CPUFREQ)	+= exynos5440-cpufreq.o
 obj-$(CONFIG_ARM_KIRKWOOD_CPUFREQ)	+= kirkwood-cpufreq.o
 obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)	+= omap-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
new file mode 100644
index 0000000..ea3d46d
--- /dev/null
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -0,0 +1,467 @@
+/*
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Amit Daniel Kachhap <amit.daniel@samsung.com>
+ *
+ * EXYNOS5440 - CPU frequency scaling support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/clk.h>
+#include <linux/cpu.h>
+#include <linux/cpufreq.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/opp.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+/* Register definations */
+#define XMU_DVFS_CTRL		0x0060
+#define XMU_PMU_P0_7		0x0064
+#define XMU_C0_3_PSTATE		0x0090
+#define XMU_P_LIMIT		0x00A0
+#define XMU_P_STATUS		0x00A4
+#define XMU_PMUEVTEN		0x00D0
+#define XMU_PMUIRQEN		0x00D4
+#define XMU_PMUIRQ		0x00D8
+
+/* PMU mask and shift definations */
+#define P_VALUE_MASK		0x7
+
+#define XMU_DVFS_CTRL_EN_SHIFT	0
+
+#define P0_7_CPUCLKDEV_SHIFT	21
+#define P0_7_CPUCLKDEV_MASK	0x7
+#define P0_7_ATBCLKDEV_SHIFT	18
+#define P0_7_ATBCLKDEV_MASK	0x7
+#define P0_7_CSCLKDEV_SHIFT	15
+#define P0_7_CSCLKDEV_MASK	0x7
+#define P0_7_CPUEMA_SHIFT	28
+#define P0_7_CPUEMA_MASK	0xf
+#define P0_7_L2EMA_SHIFT	24
+#define P0_7_L2EMA_MASK	0xf
+#define P0_7_VDD_SHIFT		8
+#define P0_7_VDD_MASK		0x7f
+#define P0_7_FREQ_SHIFT		0
+#define P0_7_FREQ_MASK		0xff
+
+#define C0_3_PSTATE_VALID_SHIFT	8
+#define C0_3_PSTATE_CURR_SHIFT	4
+#define C0_3_PSTATE_NEW_SHIFT	0
+
+#define PSTATE_CHANGED_EVTEN_SHIFT	0
+
+#define PSTATE_CHANGED_IRQEN_SHIFT	0
+
+#define PSTATE_CHANGED_SHIFT		0
+
+/* some constant values for clock divider calculation */
+#define CPU_DIV_FREQ_MAX	500
+#define CPU_DBG_FREQ_MAX	375
+#define CPU_ATB_FREQ_MAX	500
+
+#define PMIC_LOW_VOLT		0x30
+#define PMIC_HIGH_VOLT		0x28
+
+#define CPUEMA_HIGH		0x2
+#define CPUEMA_MID		0x4
+#define CPUEMA_LOW		0x7
+
+#define L2EMA_HIGH		0x1
+#define L2EMA_MID		0x3
+#define L2EMA_LOW		0x4
+
+#define DIV_TAB_MAX	2
+/* frequency unit is 20MHZ */
+#define FREQ_UNIT	20
+#define MAX_VOLTAGE	1550000 /* In micro volt */
+#define VOLTAGE_STEP	12500	/* In micro volt */
+
+#define CPUFREQ_NAME		"exynos5440_dvfs"
+#define DEF_TRANS_LATENCY	100000
+
+enum cpufreq_level_index {
+	L0, L1, L2, L3, L4,
+	L5, L6, L7, L8, L9,
+};
+#define CPUFREQ_LEVEL_END	(L7 + 1)
+
+struct exynos_dvfs_data {
+	void __iomem *base;
+	struct resource *mem;
+	int irq;
+	struct clk *cpu_clk;
+	unsigned int cur_frequency;
+	unsigned int latency;
+	struct cpufreq_frequency_table *freq_table;
+	unsigned int freq_count;
+	struct device *dev;
+	bool dvfs_enable;
+	struct work_struct irq_work;
+};
+
+static struct exynos_dvfs_data *dvfs_info;
+static DEFINE_MUTEX(cpufreq_lock);
+static struct cpufreq_freqs freqs;
+
+static int init_div_table(void)
+{
+	struct cpufreq_frequency_table *freq_tbl = dvfs_info->freq_table;
+	unsigned int tmp, clk_div, ema_div, freq, volt_id;
+	int i = 0;
+	struct opp *opp;
+
+	for (i = 0; freq_tbl[i].frequency != CPUFREQ_TABLE_END; i++) {
+
+		opp = opp_find_freq_exact(dvfs_info->dev,
+					freq_tbl[i].frequency * 1000, true);
+		if (IS_ERR(opp)) {
+			pr_err("failed to find valid OPP for %u KHZ\n",
+					freq_tbl[i].frequency);
+			return PTR_ERR(opp);
+		}
+
+		freq = freq_tbl[i].frequency / 1000; /* In MHZ */
+		clk_div = ((freq / CPU_DIV_FREQ_MAX) & P0_7_CPUCLKDEV_MASK)
+					<< P0_7_CPUCLKDEV_SHIFT;
+		clk_div |= ((freq / CPU_ATB_FREQ_MAX) & P0_7_ATBCLKDEV_MASK)
+					<< P0_7_ATBCLKDEV_SHIFT;
+		clk_div |= ((freq / CPU_DBG_FREQ_MAX) & P0_7_CSCLKDEV_MASK)
+					<< P0_7_CSCLKDEV_SHIFT;
+
+		/* Calculate EMA */
+		volt_id = opp_get_voltage(opp);
+		volt_id = (MAX_VOLTAGE - volt_id) / VOLTAGE_STEP;
+		if (volt_id < PMIC_HIGH_VOLT) {
+			ema_div = (CPUEMA_HIGH << P0_7_CPUEMA_SHIFT) |
+				(L2EMA_HIGH << P0_7_L2EMA_SHIFT);
+		} else if (volt_id > PMIC_LOW_VOLT) {
+			ema_div = (CPUEMA_LOW << P0_7_CPUEMA_SHIFT) |
+				(L2EMA_LOW << P0_7_L2EMA_SHIFT);
+		} else {
+			ema_div = (CPUEMA_MID << P0_7_CPUEMA_SHIFT) |
+				(L2EMA_MID << P0_7_L2EMA_SHIFT);
+		}
+
+		tmp = (clk_div | ema_div | (volt_id << P0_7_VDD_SHIFT)
+			| ((freq / FREQ_UNIT) << P0_7_FREQ_SHIFT));
+
+		__raw_writel(tmp, dvfs_info->base + XMU_PMU_P0_7 + 4 * i);
+	}
+
+	return 0;
+}
+
+static void exynos_enable_dvfs(void)
+{
+	unsigned int tmp, i, cpu;
+	struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
+	/* Disable DVFS */
+	__raw_writel(0,	dvfs_info->base + XMU_DVFS_CTRL);
+
+	/* Enable PSTATE Change Event */
+	tmp = __raw_readl(dvfs_info->base + XMU_PMUEVTEN);
+	tmp |= (1 << PSTATE_CHANGED_EVTEN_SHIFT);
+	 __raw_writel(tmp, dvfs_info->base + XMU_PMUEVTEN);
+
+	/* Enable PSTATE Change IRQ */
+	tmp = __raw_readl(dvfs_info->base + XMU_PMUIRQEN);
+	tmp |= (1 << PSTATE_CHANGED_IRQEN_SHIFT);
+	 __raw_writel(tmp, dvfs_info->base + XMU_PMUIRQEN);
+
+	/* Set initial performance index */
+	for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
+		if (freq_table[i].frequency == dvfs_info->cur_frequency)
+			break;
+
+	if (freq_table[i].frequency == CPUFREQ_TABLE_END) {
+		pr_crit("Boot up frequency not supported\n");
+		/* Assign the highest frequency */
+		i = 0;
+		dvfs_info->cur_frequency = freq_table[i].frequency;
+	}
+
+	pr_info("Setting dvfs initial frequency = %uKHZ",
+						dvfs_info->cur_frequency);
+
+	for (cpu = 0; cpu < CONFIG_NR_CPUS; cpu++) {
+		tmp = __raw_readl(dvfs_info->base + XMU_C0_3_PSTATE + cpu * 4);
+		tmp &= ~(P_VALUE_MASK << C0_3_PSTATE_NEW_SHIFT);
+		tmp |= (i << C0_3_PSTATE_NEW_SHIFT);
+		__raw_writel(tmp, dvfs_info->base + XMU_C0_3_PSTATE + cpu * 4);
+	}
+
+	/* Enable DVFS */
+	__raw_writel(1 << XMU_DVFS_CTRL_EN_SHIFT,
+				dvfs_info->base + XMU_DVFS_CTRL);
+}
+
+static int exynos_verify_speed(struct cpufreq_policy *policy)
+{
+	return cpufreq_frequency_table_verify(policy,
+					      dvfs_info->freq_table);
+}
+
+static unsigned int exynos_getspeed(unsigned int cpu)
+{
+	return dvfs_info->cur_frequency;
+}
+
+static int exynos_target(struct cpufreq_policy *policy,
+			  unsigned int target_freq,
+			  unsigned int relation)
+{
+	unsigned int index, tmp;
+	int ret = 0, i;
+	struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
+
+	mutex_lock(&cpufreq_lock);
+	freqs.old = dvfs_info->cur_frequency;
+
+	if (cpufreq_frequency_table_target(policy, freq_table,
+					   target_freq, relation, &index)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	freqs.new = freq_table[index].frequency;
+	freqs.cpu = policy->cpu;
+
+	for_each_cpu(freqs.cpu, policy->cpus)
+		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+
+	/* Set the target frequency in all C0_3_PSTATE register */
+	for_each_cpu(i, policy->cpus) {
+		tmp = __raw_readl(dvfs_info->base + XMU_C0_3_PSTATE + i * 4);
+		tmp &= ~(P_VALUE_MASK << C0_3_PSTATE_NEW_SHIFT);
+		tmp |= (index << C0_3_PSTATE_NEW_SHIFT);
+
+		__raw_writel(tmp, dvfs_info->base + XMU_C0_3_PSTATE + i * 4);
+	}
+out:
+	mutex_unlock(&cpufreq_lock);
+	return ret;
+}
+
+static void exynos_cpufreq_work(struct work_struct *work)
+{
+	unsigned int cur_pstate, index;
+	struct cpufreq_policy *policy = cpufreq_cpu_get(0); /* boot CPU */
+	struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
+
+	/* Ensure we can access cpufreq structures */
+	if (unlikely(dvfs_info->dvfs_enable == false))
+		goto skip_work;
+
+	mutex_lock(&cpufreq_lock);
+	freqs.old = dvfs_info->cur_frequency;
+
+	cur_pstate = __raw_readl(dvfs_info->base + XMU_P_STATUS);
+	if (cur_pstate >> C0_3_PSTATE_VALID_SHIFT & 0x1)
+		index = (cur_pstate >> C0_3_PSTATE_CURR_SHIFT) & P_VALUE_MASK;
+	else
+		index = (cur_pstate >> C0_3_PSTATE_NEW_SHIFT) & P_VALUE_MASK;
+
+	if (likely(index < dvfs_info->freq_count)) {
+		freqs.new = freq_table[index].frequency;
+		for_each_cpu(freqs.cpu, policy->cpus)
+			cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+		dvfs_info->cur_frequency = freqs.new;
+	} else {
+		pr_crit("New frequency out of range\n");
+	}
+
+	cpufreq_cpu_put(policy);
+	mutex_unlock(&cpufreq_lock);
+skip_work:
+	enable_irq(dvfs_info->irq);
+}
+
+static irqreturn_t exynos_cpufreq_irq(int irq, void *id)
+{
+	unsigned int tmp;
+
+	tmp = __raw_readl(dvfs_info->base + XMU_PMUIRQ);
+	if (tmp >> PSTATE_CHANGED_SHIFT & 0x1) {
+		__raw_writel(tmp, dvfs_info->base + XMU_PMUIRQ);
+		disable_irq_nosync(irq);
+		schedule_work(&dvfs_info->irq_work);
+	}
+	return IRQ_HANDLED;
+}
+
+static void exynos_sort_descend_freq_table(void)
+{
+	struct cpufreq_frequency_table *freq_tbl = dvfs_info->freq_table;
+	int i = 0, index;
+	unsigned int tmp_freq;
+
+	/*
+	 * Freq table is already in ascending order as it is created from
+	 * OPP library, so just swap the elements to make it descending.
+	 */
+	for (i = 0; i < dvfs_info->freq_count / 2; i++) {
+		index = dvfs_info->freq_count - i - 1;
+		tmp_freq = freq_tbl[i].frequency;
+		freq_tbl[i].frequency = freq_tbl[index].frequency;
+		freq_tbl[index].frequency = tmp_freq;
+	}
+}
+
+static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
+{
+	policy->cur = dvfs_info->cur_frequency;
+	cpufreq_frequency_table_get_attr(dvfs_info->freq_table, policy->cpu);
+
+	/* set the transition latency value */
+	policy->cpuinfo.transition_latency = dvfs_info->latency;
+
+	cpumask_setall(policy->cpus);
+
+	return cpufreq_frequency_table_cpuinfo(policy, dvfs_info->freq_table);
+}
+
+static struct cpufreq_driver exynos_driver = {
+	.flags		= CPUFREQ_STICKY,
+	.verify		= exynos_verify_speed,
+	.target		= exynos_target,
+	.get		= exynos_getspeed,
+	.init		= exynos_cpufreq_cpu_init,
+	.name		= CPUFREQ_NAME,
+};
+
+static int exynos_cpufreq_probe(struct platform_device *pdev)
+{
+	int ret = -EINVAL;
+	struct device_node *np;
+	struct resource res;
+
+	np =  of_find_compatible_node(NULL, NULL, "samsung,exynos5440-cpufreq");
+	if (!np)
+		return -ENODEV;
+
+	dvfs_info = devm_kzalloc(&pdev->dev, sizeof(*dvfs_info), GFP_KERNEL);
+	if (!dvfs_info) {
+		ret = -ENOMEM;
+		goto err_put_node;
+	}
+
+	dvfs_info->dev = &pdev->dev;
+	dvfs_info->dev->of_node = np;
+
+	ret = of_address_to_resource(np, 0, &res);
+	if (ret)
+		goto err_put_node;
+
+	dvfs_info->base = devm_ioremap(dvfs_info->dev, res.start,
+					resource_size(&res));
+	if (!dvfs_info->base) {
+		pr_err("No cpufreq memory map found\n");
+		ret = -ENODEV;
+		goto err_put_node;
+	}
+
+	dvfs_info->irq = irq_of_parse_and_map(np, 0);
+	if (dvfs_info->irq == 0) {
+		pr_err("No cpufreq irq found\n");
+		ret = -ENODEV;
+		goto err_put_node;
+	}
+
+	ret = of_init_opp_table(dvfs_info->dev);
+	if (ret) {
+		pr_err("failed to init OPP table: %d\n", ret);
+		goto err_put_node;
+	}
+
+	ret = opp_init_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
+	if (ret) {
+		pr_err("failed to init cpufreq table: %d\n", ret);
+		goto err_put_node;
+	}
+	dvfs_info->freq_count = opp_get_opp_count(dvfs_info->dev);
+	exynos_sort_descend_freq_table();
+
+	if (of_property_read_u32(np, "clock-latency", &dvfs_info->latency))
+		dvfs_info->latency = DEF_TRANS_LATENCY;
+
+	dvfs_info->cpu_clk = devm_clk_get(dvfs_info->dev, "armclk");
+	if (IS_ERR_OR_NULL(dvfs_info->cpu_clk)) {
+		pr_err("Failed to get cpu clock\n");
+		ret = PTR_ERR(dvfs_info->cpu_clk);
+		goto err_free_table;
+	}
+
+	dvfs_info->cur_frequency = clk_get_rate(dvfs_info->cpu_clk);
+	if (!dvfs_info->cur_frequency) {
+		pr_err("Failed to get clock rate\n");
+		ret = -EINVAL;
+		goto err_free_table;
+	}
+	dvfs_info->cur_frequency /= 1000;
+
+	INIT_WORK(&dvfs_info->irq_work, exynos_cpufreq_work);
+	if (devm_request_irq(dvfs_info->dev, dvfs_info->irq, exynos_cpufreq_irq,
+				IRQF_TRIGGER_NONE, CPUFREQ_NAME, dvfs_info)) {
+		pr_err("Failed to register IRQ\n");
+		ret = -ENODEV;
+		goto err_free_table;
+	}
+
+	ret = init_div_table();
+	if (ret) {
+		pr_err("Failed to initialise div table\n");
+		goto err_free_table;
+	}
+
+	exynos_enable_dvfs();
+	ret = cpufreq_register_driver(&exynos_driver);
+	if (ret) {
+		pr_err("%s: failed to register cpufreq driver\n", __func__);
+		goto err_free_table;
+	}
+
+	of_node_put(np);
+	dvfs_info->dvfs_enable = true;
+	pr_info("exynos5440 DVFS initialized.\n");
+	return 0;
+
+err_free_table:
+	opp_free_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
+err_put_node:
+	of_node_put(np);
+	pr_err("%s: failed initialization\n", __func__);
+	return ret;
+}
+
+static int exynos_cpufreq_remove(struct platform_device *pdev)
+{
+	cpufreq_unregister_driver(&exynos_driver);
+	opp_free_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
+	return 0;
+}
+
+static struct platform_driver exynos_cpufreq_platdrv = {
+	.driver = {
+		.name	= "exynos5440-cpufreq",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= exynos_cpufreq_probe,
+	.remove		= exynos_cpufreq_remove,
+};
+module_platform_driver(exynos_cpufreq_platdrv);
+
+MODULE_AUTHOR("Amit Daniel Kachhap <amit.daniel@samsung.com>");
+MODULE_DESCRIPTION("Exynos5440 cpufreq driver");
+MODULE_LICENSE("GPL");
-- 
1.7.1

