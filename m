Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbaKUH3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 02:29:33 -0500
Received: from mail-bn1bbn0102.outbound.protection.outlook.com ([157.56.111.102]:22272
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751230AbaKUH33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 02:29:29 -0500
From: Tang Yuantian <Yuantian.Tang@freescale.com>
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>, <r64188@freescale.com>,
        Tang Yuantian <Yuantian.Tang@freescale.com>
Subject: [PATCH 2/2] cpufreq: qoriq: rename the driver
Date: Fri, 21 Nov 2014 15:28:02 +0800
Message-ID: <1416554882-16566-2-git-send-email-Yuantian.Tang@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1416554882-16566-1-git-send-email-Yuantian.Tang@freescale.com>
References: <1416554882-16566-1-git-send-email-Yuantian.Tang@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(84676001)(47776003)(104166001)(20776003)(64706001)(102836001)(48376002)(92566001)(86362001)(92726001)(19580405001)(46102003)(21056001)(68736004)(44976005)(93916002)(6806004)(19580395003)(4396001)(50466002)(50226001)(97736003)(87936001)(107046002)(105606002)(77156002)(104016003)(87286001)(36756003)(62966003)(229853001)(88136002)(76176999)(106466001)(50986999)(95666004)(31966008)(120916001)(89996001)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB574;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB574;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB574;
X-Forefront-PRVS: 0402872DA1
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Yuantian.Tang@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB574;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver works on all QorIQ platforms which include
ARM-based cores and PPC-based cores.
Rename it in order to represent better.

Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
---
 drivers/cpufreq/ppc-corenet-cpufreq.c | 371 ----------------------------------
 drivers/cpufreq/qoriq-cpufreq.c       | 371 ++++++++++++++++++++++++++++++++++
 2 files changed, 371 insertions(+), 371 deletions(-)
 delete mode 100644 drivers/cpufreq/ppc-corenet-cpufreq.c
 create mode 100644 drivers/cpufreq/qoriq-cpufreq.c

diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
deleted file mode 100644
index 949d992..0000000
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ /dev/null
@@ -1,371 +0,0 @@
-/*
- * Copyright 2013 Freescale Semiconductor, Inc.
- *
- * CPU Frequency Scaling driver for Freescale QorIQ SoCs.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
-
-#include <linux/clk.h>
-#include <linux/cpufreq.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/of.h>
-#include <linux/slab.h>
-#include <linux/smp.h>
-
-/**
- * struct cpu_data
- * @parent: the parent node of cpu clock
- * @table: frequency table
- */
-struct cpu_data {
-	struct device_node *parent;
-	struct cpufreq_frequency_table *table;
-};
-
-/**
- * struct soc_data - SoC specific data
- * @freq_mask: mask the disallowed frequencies
- * @flag: unique flags
- */
-struct soc_data {
-	u32 freq_mask[4];
-	u32 flag;
-};
-
-#define FREQ_MASK	1
-/* see hardware specification for the allowed frqeuencies */
-static const struct soc_data sdata[] = {
-	{ /* used by p2041 and p3041 */
-		.freq_mask = {0x8, 0x8, 0x2, 0x2},
-		.flag = FREQ_MASK,
-	},
-	{ /* used by p5020 */
-		.freq_mask = {0x8, 0x2},
-		.flag = FREQ_MASK,
-	},
-	{ /* used by p4080, p5040 */
-		.freq_mask = {0},
-		.flag = 0,
-	},
-};
-
-/*
- * the minimum allowed core frequency, in Hz
- * for chassis v1.0, >= platform frequency
- * for chassis v2.0, >= platform frequency / 2
- */
-static u32 min_cpufreq;
-static const u32 *fmask;
-
-#if defined(CONFIG_ARM)
-static int get_cpu_physical_id(int cpu)
-{
-	return topology_core_id(cpu);
-}
-#else
-static int get_cpu_physical_id(int cpu)
-{
-	return get_hard_smp_processor_id(cpu);
-}
-#endif
-
-static u32 get_bus_freq(void)
-{
-	struct device_node *soc;
-	u32 sysfreq;
-
-	soc = of_find_node_by_type(NULL, "soc");
-	if (!soc)
-		return 0;
-
-	if (of_property_read_u32(soc, "bus-frequency", &sysfreq))
-		sysfreq = 0;
-
-	of_node_put(soc);
-
-	return sysfreq;
-}
-
-static struct device_node *cpu_to_clk_node(int cpu)
-{
-	struct device_node *np, *clk_np;
-
-	if (!cpu_present(cpu))
-		return NULL;
-
-	np = of_get_cpu_node(cpu, NULL);
-	if (!np)
-		return NULL;
-
-	clk_np = of_parse_phandle(np, "clocks", 0);
-	if (!clk_np)
-		return NULL;
-
-	of_node_put(np);
-
-	return clk_np;
-}
-
-/* traverse cpu nodes to get cpu mask of sharing clock wire */
-static void set_affected_cpus(struct cpufreq_policy *policy)
-{
-	struct device_node *np, *clk_np;
-	struct cpumask *dstp = policy->cpus;
-	int i;
-
-	np = cpu_to_clk_node(policy->cpu);
-	if (!np)
-		return;
-
-	for_each_present_cpu(i) {
-		clk_np = cpu_to_clk_node(i);
-		if (!clk_np)
-			continue;
-
-		if (clk_np == np)
-			cpumask_set_cpu(i, dstp);
-
-		of_node_put(clk_np);
-	}
-	of_node_put(np);
-}
-
-/* reduce the duplicated frequencies in frequency table */
-static void freq_table_redup(struct cpufreq_frequency_table *freq_table,
-		int count)
-{
-	int i, j;
-
-	for (i = 1; i < count; i++) {
-		for (j = 0; j < i; j++) {
-			if (freq_table[j].frequency == CPUFREQ_ENTRY_INVALID ||
-					freq_table[j].frequency !=
-					freq_table[i].frequency)
-				continue;
-
-			freq_table[i].frequency = CPUFREQ_ENTRY_INVALID;
-			break;
-		}
-	}
-}
-
-/* sort the frequencies in frequency table in descenting order */
-static void freq_table_sort(struct cpufreq_frequency_table *freq_table,
-		int count)
-{
-	int i, j, ind;
-	unsigned int freq, max_freq;
-	struct cpufreq_frequency_table table;
-
-	for (i = 0; i < count - 1; i++) {
-		max_freq = freq_table[i].frequency;
-		ind = i;
-		for (j = i + 1; j < count; j++) {
-			freq = freq_table[j].frequency;
-			if (freq == CPUFREQ_ENTRY_INVALID ||
-					freq <= max_freq)
-				continue;
-			ind = j;
-			max_freq = freq;
-		}
-
-		if (ind != i) {
-			/* exchange the frequencies */
-			table.driver_data = freq_table[i].driver_data;
-			table.frequency = freq_table[i].frequency;
-			freq_table[i].driver_data = freq_table[ind].driver_data;
-			freq_table[i].frequency = freq_table[ind].frequency;
-			freq_table[ind].driver_data = table.driver_data;
-			freq_table[ind].frequency = table.frequency;
-		}
-	}
-}
-
-static int qoriq_cpufreq_cpu_init(struct cpufreq_policy *policy)
-{
-	struct device_node *np;
-	int i, count, ret;
-	u32 freq, mask;
-	struct clk *clk;
-	struct cpufreq_frequency_table *table;
-	struct cpu_data *data;
-	unsigned int cpu = policy->cpu;
-	u64 u64temp;
-
-	np = of_get_cpu_node(cpu, NULL);
-	if (!np)
-		return -ENODEV;
-
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		goto err_np;
-
-	policy->clk = of_clk_get(np, 0);
-	if (IS_ERR(policy->clk)) {
-		pr_err("%s: no clock information\n", __func__);
-		goto err_nomem2;
-	}
-
-	data->parent = of_parse_phandle(np, "clocks", 0);
-	if (!data->parent) {
-		pr_err("%s: could not get clock information\n", __func__);
-		goto err_nomem2;
-	}
-
-	count = of_property_count_strings(data->parent, "clock-names");
-	table = kcalloc(count + 1, sizeof(*table), GFP_KERNEL);
-	if (!table) {
-		pr_err("%s: no memory\n", __func__);
-		goto err_node;
-	}
-
-	if (fmask)
-		mask = fmask[get_cpu_physical_id(cpu)];
-	else
-		mask = 0x0;
-
-	for (i = 0; i < count; i++) {
-		clk = of_clk_get(data->parent, i);
-		freq = clk_get_rate(clk);
-		/*
-		 * the clock is valid if its frequency is not masked
-		 * and large than minimum allowed frequency.
-		 */
-		if (freq < min_cpufreq || (mask & (1 << i)))
-			table[i].frequency = CPUFREQ_ENTRY_INVALID;
-		else
-			table[i].frequency = freq / 1000;
-		table[i].driver_data = i;
-	}
-	freq_table_redup(table, count);
-	freq_table_sort(table, count);
-	table[i].frequency = CPUFREQ_TABLE_END;
-
-	/* set the min and max frequency properly */
-	ret = cpufreq_table_validate_and_show(policy, table);
-	if (ret) {
-		pr_err("invalid frequency table: %d\n", ret);
-		goto err_nomem1;
-	}
-
-	data->table = table;
-
-	/* update ->cpus if we have cluster, no harm if not */
-	set_affected_cpus(policy);
-	policy->driver_data = data;
-
-	/* Minimum transition latency is 12 platform clocks */
-	u64temp = 12ULL * NSEC_PER_SEC;
-	do_div(u64temp, get_bus_freq());
-	policy->cpuinfo.transition_latency = u64temp + 1;
-
-	of_node_put(np);
-
-	return 0;
-
-err_nomem1:
-	kfree(table);
-err_node:
-	of_node_put(data->parent);
-err_nomem2:
-	policy->driver_data = NULL;
-	kfree(data);
-err_np:
-	of_node_put(np);
-
-	return -ENODEV;
-}
-
-static int __exit qoriq_cpufreq_cpu_exit(struct cpufreq_policy *policy)
-{
-	struct cpu_data *data = policy->driver_data;
-	unsigned int cpu;
-
-	of_node_put(data->parent);
-	kfree(data->table);
-	kfree(data);
-	policy->driver_data = NULL;
-
-	return 0;
-}
-
-static int qoriq_cpufreq_target(struct cpufreq_policy *policy,
-		unsigned int index)
-{
-	struct clk *parent;
-	struct cpu_data *data = policy->driver_data;
-
-	parent = of_clk_get(data->parent, data->table[index].driver_data);
-	return clk_set_parent(policy->clk, parent);
-}
-
-static struct cpufreq_driver qoriq_cpufreq_driver = {
-	.name		= "qoriq_cpufreq",
-	.flags		= CPUFREQ_CONST_LOOPS,
-	.init		= qoriq_cpufreq_cpu_init,
-	.exit		= __exit_p(qoriq_cpufreq_cpu_exit),
-	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_index	= qoriq_cpufreq_target,
-	.get		= cpufreq_generic_get,
-	.attr		= cpufreq_generic_attr,
-};
-
-static const struct of_device_id node_matches[] __initconst = {
-	{ .compatible = "fsl,p2041-clockgen", .data = &sdata[0], },
-	{ .compatible = "fsl,p3041-clockgen", .data = &sdata[0], },
-	{ .compatible = "fsl,p5020-clockgen", .data = &sdata[1], },
-	{ .compatible = "fsl,p4080-clockgen", .data = &sdata[2], },
-	{ .compatible = "fsl,p5040-clockgen", .data = &sdata[2], },
-	{ .compatible = "fsl,qoriq-clockgen-2.0", },
-	{}
-};
-
-static int __init qoriq_cpufreq_init(void)
-{
-	int ret;
-	struct device_node  *np;
-	const struct of_device_id *match;
-	const struct soc_data *data;
-
-	np = of_find_matching_node(NULL, node_matches);
-	if (!np)
-		return -ENODEV;
-
-	match = of_match_node(node_matches, np);
-	data = match->data;
-	if (data) {
-		if (data->flag)
-			fmask = data->freq_mask;
-		min_cpufreq = get_bus_freq();
-	} else {
-		min_cpufreq = get_bus_freq() / 2;
-	}
-
-	of_node_put(np);
-
-	ret = cpufreq_register_driver(&qoriq_cpufreq_driver);
-	if (!ret)
-		pr_info("Freescale QorIQ CPU frequency scaling driver\n");
-
-	return ret;
-}
-module_init(qoriq_cpufreq_init);
-
-static void __exit qoriq_cpufreq_exit(void)
-{
-	cpufreq_unregister_driver(&qoriq_cpufreq_driver);
-}
-module_exit(qoriq_cpufreq_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Tang Yuantian <Yuantian.Tang@freescale.com>");
-MODULE_DESCRIPTION("cpufreq driver for Freescale QorIQ series SoCs");
diff --git a/drivers/cpufreq/qoriq-cpufreq.c b/drivers/cpufreq/qoriq-cpufreq.c
new file mode 100644
index 0000000..949d992
--- /dev/null
+++ b/drivers/cpufreq/qoriq-cpufreq.c
@@ -0,0 +1,371 @@
+/*
+ * Copyright 2013 Freescale Semiconductor, Inc.
+ *
+ * CPU Frequency Scaling driver for Freescale QorIQ SoCs.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/clk.h>
+#include <linux/cpufreq.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+
+/**
+ * struct cpu_data
+ * @parent: the parent node of cpu clock
+ * @table: frequency table
+ */
+struct cpu_data {
+	struct device_node *parent;
+	struct cpufreq_frequency_table *table;
+};
+
+/**
+ * struct soc_data - SoC specific data
+ * @freq_mask: mask the disallowed frequencies
+ * @flag: unique flags
+ */
+struct soc_data {
+	u32 freq_mask[4];
+	u32 flag;
+};
+
+#define FREQ_MASK	1
+/* see hardware specification for the allowed frqeuencies */
+static const struct soc_data sdata[] = {
+	{ /* used by p2041 and p3041 */
+		.freq_mask = {0x8, 0x8, 0x2, 0x2},
+		.flag = FREQ_MASK,
+	},
+	{ /* used by p5020 */
+		.freq_mask = {0x8, 0x2},
+		.flag = FREQ_MASK,
+	},
+	{ /* used by p4080, p5040 */
+		.freq_mask = {0},
+		.flag = 0,
+	},
+};
+
+/*
+ * the minimum allowed core frequency, in Hz
+ * for chassis v1.0, >= platform frequency
+ * for chassis v2.0, >= platform frequency / 2
+ */
+static u32 min_cpufreq;
+static const u32 *fmask;
+
+#if defined(CONFIG_ARM)
+static int get_cpu_physical_id(int cpu)
+{
+	return topology_core_id(cpu);
+}
+#else
+static int get_cpu_physical_id(int cpu)
+{
+	return get_hard_smp_processor_id(cpu);
+}
+#endif
+
+static u32 get_bus_freq(void)
+{
+	struct device_node *soc;
+	u32 sysfreq;
+
+	soc = of_find_node_by_type(NULL, "soc");
+	if (!soc)
+		return 0;
+
+	if (of_property_read_u32(soc, "bus-frequency", &sysfreq))
+		sysfreq = 0;
+
+	of_node_put(soc);
+
+	return sysfreq;
+}
+
+static struct device_node *cpu_to_clk_node(int cpu)
+{
+	struct device_node *np, *clk_np;
+
+	if (!cpu_present(cpu))
+		return NULL;
+
+	np = of_get_cpu_node(cpu, NULL);
+	if (!np)
+		return NULL;
+
+	clk_np = of_parse_phandle(np, "clocks", 0);
+	if (!clk_np)
+		return NULL;
+
+	of_node_put(np);
+
+	return clk_np;
+}
+
+/* traverse cpu nodes to get cpu mask of sharing clock wire */
+static void set_affected_cpus(struct cpufreq_policy *policy)
+{
+	struct device_node *np, *clk_np;
+	struct cpumask *dstp = policy->cpus;
+	int i;
+
+	np = cpu_to_clk_node(policy->cpu);
+	if (!np)
+		return;
+
+	for_each_present_cpu(i) {
+		clk_np = cpu_to_clk_node(i);
+		if (!clk_np)
+			continue;
+
+		if (clk_np == np)
+			cpumask_set_cpu(i, dstp);
+
+		of_node_put(clk_np);
+	}
+	of_node_put(np);
+}
+
+/* reduce the duplicated frequencies in frequency table */
+static void freq_table_redup(struct cpufreq_frequency_table *freq_table,
+		int count)
+{
+	int i, j;
+
+	for (i = 1; i < count; i++) {
+		for (j = 0; j < i; j++) {
+			if (freq_table[j].frequency == CPUFREQ_ENTRY_INVALID ||
+					freq_table[j].frequency !=
+					freq_table[i].frequency)
+				continue;
+
+			freq_table[i].frequency = CPUFREQ_ENTRY_INVALID;
+			break;
+		}
+	}
+}
+
+/* sort the frequencies in frequency table in descenting order */
+static void freq_table_sort(struct cpufreq_frequency_table *freq_table,
+		int count)
+{
+	int i, j, ind;
+	unsigned int freq, max_freq;
+	struct cpufreq_frequency_table table;
+
+	for (i = 0; i < count - 1; i++) {
+		max_freq = freq_table[i].frequency;
+		ind = i;
+		for (j = i + 1; j < count; j++) {
+			freq = freq_table[j].frequency;
+			if (freq == CPUFREQ_ENTRY_INVALID ||
+					freq <= max_freq)
+				continue;
+			ind = j;
+			max_freq = freq;
+		}
+
+		if (ind != i) {
+			/* exchange the frequencies */
+			table.driver_data = freq_table[i].driver_data;
+			table.frequency = freq_table[i].frequency;
+			freq_table[i].driver_data = freq_table[ind].driver_data;
+			freq_table[i].frequency = freq_table[ind].frequency;
+			freq_table[ind].driver_data = table.driver_data;
+			freq_table[ind].frequency = table.frequency;
+		}
+	}
+}
+
+static int qoriq_cpufreq_cpu_init(struct cpufreq_policy *policy)
+{
+	struct device_node *np;
+	int i, count, ret;
+	u32 freq, mask;
+	struct clk *clk;
+	struct cpufreq_frequency_table *table;
+	struct cpu_data *data;
+	unsigned int cpu = policy->cpu;
+	u64 u64temp;
+
+	np = of_get_cpu_node(cpu, NULL);
+	if (!np)
+		return -ENODEV;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		goto err_np;
+
+	policy->clk = of_clk_get(np, 0);
+	if (IS_ERR(policy->clk)) {
+		pr_err("%s: no clock information\n", __func__);
+		goto err_nomem2;
+	}
+
+	data->parent = of_parse_phandle(np, "clocks", 0);
+	if (!data->parent) {
+		pr_err("%s: could not get clock information\n", __func__);
+		goto err_nomem2;
+	}
+
+	count = of_property_count_strings(data->parent, "clock-names");
+	table = kcalloc(count + 1, sizeof(*table), GFP_KERNEL);
+	if (!table) {
+		pr_err("%s: no memory\n", __func__);
+		goto err_node;
+	}
+
+	if (fmask)
+		mask = fmask[get_cpu_physical_id(cpu)];
+	else
+		mask = 0x0;
+
+	for (i = 0; i < count; i++) {
+		clk = of_clk_get(data->parent, i);
+		freq = clk_get_rate(clk);
+		/*
+		 * the clock is valid if its frequency is not masked
+		 * and large than minimum allowed frequency.
+		 */
+		if (freq < min_cpufreq || (mask & (1 << i)))
+			table[i].frequency = CPUFREQ_ENTRY_INVALID;
+		else
+			table[i].frequency = freq / 1000;
+		table[i].driver_data = i;
+	}
+	freq_table_redup(table, count);
+	freq_table_sort(table, count);
+	table[i].frequency = CPUFREQ_TABLE_END;
+
+	/* set the min and max frequency properly */
+	ret = cpufreq_table_validate_and_show(policy, table);
+	if (ret) {
+		pr_err("invalid frequency table: %d\n", ret);
+		goto err_nomem1;
+	}
+
+	data->table = table;
+
+	/* update ->cpus if we have cluster, no harm if not */
+	set_affected_cpus(policy);
+	policy->driver_data = data;
+
+	/* Minimum transition latency is 12 platform clocks */
+	u64temp = 12ULL * NSEC_PER_SEC;
+	do_div(u64temp, get_bus_freq());
+	policy->cpuinfo.transition_latency = u64temp + 1;
+
+	of_node_put(np);
+
+	return 0;
+
+err_nomem1:
+	kfree(table);
+err_node:
+	of_node_put(data->parent);
+err_nomem2:
+	policy->driver_data = NULL;
+	kfree(data);
+err_np:
+	of_node_put(np);
+
+	return -ENODEV;
+}
+
+static int __exit qoriq_cpufreq_cpu_exit(struct cpufreq_policy *policy)
+{
+	struct cpu_data *data = policy->driver_data;
+	unsigned int cpu;
+
+	of_node_put(data->parent);
+	kfree(data->table);
+	kfree(data);
+	policy->driver_data = NULL;
+
+	return 0;
+}
+
+static int qoriq_cpufreq_target(struct cpufreq_policy *policy,
+		unsigned int index)
+{
+	struct clk *parent;
+	struct cpu_data *data = policy->driver_data;
+
+	parent = of_clk_get(data->parent, data->table[index].driver_data);
+	return clk_set_parent(policy->clk, parent);
+}
+
+static struct cpufreq_driver qoriq_cpufreq_driver = {
+	.name		= "qoriq_cpufreq",
+	.flags		= CPUFREQ_CONST_LOOPS,
+	.init		= qoriq_cpufreq_cpu_init,
+	.exit		= __exit_p(qoriq_cpufreq_cpu_exit),
+	.verify		= cpufreq_generic_frequency_table_verify,
+	.target_index	= qoriq_cpufreq_target,
+	.get		= cpufreq_generic_get,
+	.attr		= cpufreq_generic_attr,
+};
+
+static const struct of_device_id node_matches[] __initconst = {
+	{ .compatible = "fsl,p2041-clockgen", .data = &sdata[0], },
+	{ .compatible = "fsl,p3041-clockgen", .data = &sdata[0], },
+	{ .compatible = "fsl,p5020-clockgen", .data = &sdata[1], },
+	{ .compatible = "fsl,p4080-clockgen", .data = &sdata[2], },
+	{ .compatible = "fsl,p5040-clockgen", .data = &sdata[2], },
+	{ .compatible = "fsl,qoriq-clockgen-2.0", },
+	{}
+};
+
+static int __init qoriq_cpufreq_init(void)
+{
+	int ret;
+	struct device_node  *np;
+	const struct of_device_id *match;
+	const struct soc_data *data;
+
+	np = of_find_matching_node(NULL, node_matches);
+	if (!np)
+		return -ENODEV;
+
+	match = of_match_node(node_matches, np);
+	data = match->data;
+	if (data) {
+		if (data->flag)
+			fmask = data->freq_mask;
+		min_cpufreq = get_bus_freq();
+	} else {
+		min_cpufreq = get_bus_freq() / 2;
+	}
+
+	of_node_put(np);
+
+	ret = cpufreq_register_driver(&qoriq_cpufreq_driver);
+	if (!ret)
+		pr_info("Freescale QorIQ CPU frequency scaling driver\n");
+
+	return ret;
+}
+module_init(qoriq_cpufreq_init);
+
+static void __exit qoriq_cpufreq_exit(void)
+{
+	cpufreq_unregister_driver(&qoriq_cpufreq_driver);
+}
+module_exit(qoriq_cpufreq_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tang Yuantian <Yuantian.Tang@freescale.com>");
+MODULE_DESCRIPTION("cpufreq driver for Freescale QorIQ series SoCs");
-- 
2.1.0.27.g96db324

