Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab3CGROf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:14:35 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:59075 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903Ab3CGROd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:14:33 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-kernel@lists.linaro.org,
        mark.hambleton@broadcom.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH V2] cpufreq: ARM big LITTLE: Add generic cpufreq driver and its DT glue
Date: Fri,  8 Mar 2013 01:14:23 +0800
Message-Id: <6cba8f153cfd4b0d3075a34a6dfe287bdec2eb06.1362676407.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

big LITTLE is ARM's new Architecture focussing power/performance needs of modern
world. More information about big LITTLE can be found here:

http://www.arm.com/products/processors/technologies/biglittleprocessing.php
http://lwn.net/Articles/481055/

In order to keep cpufreq support for all big LITTLE platforms simple/generic,
this patch tries to add a generic cpufreq driver layer for all big LITTLE
platforms.

The driver is divided into two parts:
- Core driver: Generic and shared across all big LITTLE SoC's
- Glue drivers: Per platform drivers providing ops to the core driver

This patch adds in a generic glue driver which would extract information from
Device Tree.

Future SoC's can either reuse the DT glue or write their own depending on the
need.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

V1->V2:
- s/IS_ERR_OR_NULL/IS_ERR for return value of clk_get
- Added "depends on HAVE_CLK" in Kconfig
- Removed "default n" from Kconfig
- Renamed cluster clk to "cpu-cluster.%u" and added it as dev_id instead of
  con_id and using clk_get_sys() instead of clk_get()
- Removed setting clk to freq_table to NULL on put_clk_and_freq_table call.

 .../bindings/cpufreq/arm_big_little_dt.txt         |  29 +++
 MAINTAINERS                                        |  11 +
 drivers/cpufreq/Kconfig.arm                        |  12 +
 drivers/cpufreq/Makefile                           |   4 +
 drivers/cpufreq/arm_big_little.c                   | 276 +++++++++++++++++++++
 drivers/cpufreq/arm_big_little.h                   |  40 +++
 drivers/cpufreq/arm_big_little_dt.c                | 125 ++++++++++
 7 files changed, 497 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt
 create mode 100644 drivers/cpufreq/arm_big_little.c
 create mode 100644 drivers/cpufreq/arm_big_little.h
 create mode 100644 drivers/cpufreq/arm_big_little_dt.c

diff --git a/Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt b/Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt
new file mode 100644
index 0000000..6f534eb
--- /dev/null
+++ b/Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt
@@ -0,0 +1,29 @@
+Generic ARM big LITTLE cpufreq driver's DT glue
+-----------------------------------------------
+
+It is DT specific glue layer for generic cpufreq driver for big LITTLE systems.
+
+Both required and optional properties listed below must be defined under node
+cluster*. * can be 0 or 1.
+
+Required properties:
+- freqs: List of all supported frequencies.
+
+Optional properties:
+- clock-latency: Specify the possible maximum transition latency for clock, in
+  unit of nanoseconds.
+
+Examples:
+
+cluster0: cluster@0 {
+        ..
+
+	freqs = <500000000 600000000 700000000 800000000 900000000 1000000000 1100000000 1200000000>;
+	clock-latency = <200000>;
+
+	..
+
+        cores {
+		..
+        };
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index 554fd30..b14b749 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2206,6 +2206,17 @@ S:	Maintained
 F:	drivers/cpufreq/
 F:	include/linux/cpufreq.h
 
+CPU FREQUENCY DRIVERS - ARM BIG LITTLE
+M:	Viresh Kumar <viresh.kumar@linaro.org>
+M:	Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
+L:	cpufreq@vger.kernel.org
+L:	linux-pm@vger.kernel.org
+W:	http://www.arm.com/products/processors/technologies/biglittleprocessing.php
+S:	Maintained
+F:	drivers/cpufreq/arm_big_little.h
+F:	drivers/cpufreq/arm_big_little.c
+F:	drivers/cpufreq/arm_big_little_dt.c
+
 CPUID/MSR DRIVER
 M:	"H. Peter Anvin" <hpa@zytor.com>
 S:	Maintained
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 030ddf6..87b7e48 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -2,6 +2,18 @@
 # ARM CPU Frequency scaling drivers
 #
 
+config ARM_BIG_LITTLE_CPUFREQ
+	tristate
+	depends on ARM_CPU_TOPOLOGY
+
+config ARM_DT_BL_CPUFREQ
+	tristate "Generic ARM big LITTLE CPUfreq driver probed via DT"
+	select ARM_BIG_LITTLE_CPUFREQ
+	depends on OF && HAVE_CLK
+	help
+	  This enables the Generic CPUfreq driver for ARM big.LITTLE platform.
+	  This gets frequency tables from DT.
+
 config ARM_OMAP2PLUS_CPUFREQ
 	bool "TI OMAP2+"
 	depends on ARCH_OMAP2PLUS
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 863fd18..d1b0832 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -44,6 +44,10 @@ obj-$(CONFIG_X86_INTEL_PSTATE)		+= intel_pstate.o
 
 ##################################################################################
 # ARM SoC drivers
+obj-$(CONFIG_ARM_BIG_LITTLE_CPUFREQ)	+= arm_big_little.o
+# big LITTLE per platform glues. Keep DT_BL_CPUFREQ as the last entry in all big
+# LITTLE drivers, so that it is probed last.
+obj-$(CONFIG_ARM_DT_BL_CPUFREQ)	+= arm_big_little_dt.o
 obj-$(CONFIG_UX500_SOC_DB8500)		+= dbx500-cpufreq.o
 obj-$(CONFIG_ARM_S3C2416_CPUFREQ)	+= s3c2416-cpufreq.o
 obj-$(CONFIG_ARM_S3C64XX_CPUFREQ)	+= s3c64xx-cpufreq.o
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
new file mode 100644
index 0000000..8b8b07e
--- /dev/null
+++ b/drivers/cpufreq/arm_big_little.c
@@ -0,0 +1,276 @@
+/*
+ * ARM big.LITTLE Platforms CPUFreq support
+ *
+ * Copyright (C) 2013 ARM Ltd.
+ * Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
+ *
+ * Copyright (C) 2013 Linaro.
+ * Viresh Kumar <viresh.kumar@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/clk.h>
+#include <linux/cpufreq.h>
+#include <linux/cpumask.h>
+#include <linux/export.h>
+#include <linux/of_platform.h>
+#include <linux/slab.h>
+#include <linux/topology.h>
+#include <linux/types.h>
+
+#include "arm_big_little.h"
+
+/* Currently we support only two clusters */
+#define MAX_CLUSTERS	2
+
+static struct cpufreq_arm_bL_ops *arm_bL_ops;
+static struct clk *clk[MAX_CLUSTERS];
+static struct cpufreq_frequency_table *freq_table[MAX_CLUSTERS];
+static atomic_t cluster_usage[MAX_CLUSTERS] = {ATOMIC_INIT(0), ATOMIC_INIT(0)};
+
+static int cpu_to_cluster(int cpu)
+{
+	return topology_physical_package_id(cpu);
+}
+
+static unsigned int bL_cpufreq_get(unsigned int cpu)
+{
+	u32 cur_cluster = cpu_to_cluster(cpu);
+
+	return clk_get_rate(clk[cur_cluster]) / 1000;
+}
+
+/* Validate policy frequency range */
+static int bL_cpufreq_verify_policy(struct cpufreq_policy *policy)
+{
+	u32 cur_cluster = cpu_to_cluster(policy->cpu);
+
+	return cpufreq_frequency_table_verify(policy, freq_table[cur_cluster]);
+}
+
+/* Set clock frequency */
+static int bL_cpufreq_set_target(struct cpufreq_policy *policy,
+		unsigned int target_freq, unsigned int relation)
+{
+	struct cpufreq_freqs freqs;
+	u32 cpu = policy->cpu, freq_tab_idx, cur_cluster;
+	int ret = 0;
+
+	cur_cluster = cpu_to_cluster(policy->cpu);
+
+	freqs.old = bL_cpufreq_get(policy->cpu);
+
+	/* Determine valid target frequency using freq_table */
+	cpufreq_frequency_table_target(policy, freq_table[cur_cluster],
+			target_freq, relation, &freq_tab_idx);
+	freqs.new = freq_table[cur_cluster][freq_tab_idx].frequency;
+
+	freqs.cpu = policy->cpu;
+
+	pr_debug("%s: cpu: %d, cluster: %d, oldfreq: %d, target freq: %d, new freq: %d\n",
+			__func__, cpu, cur_cluster, freqs.old, target_freq,
+			freqs.new);
+
+	if (freqs.old == freqs.new)
+		return 0;
+
+	for_each_cpu(freqs.cpu, policy->cpus)
+		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+
+	ret = clk_set_rate(clk[cur_cluster], freqs.new * 1000);
+	if (ret) {
+		pr_err("clk_set_rate failed: %d\n", ret);
+		return ret;
+	}
+
+	policy->cur = freqs.new;
+
+	for_each_cpu(freqs.cpu, policy->cpus)
+		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+
+	return ret;
+}
+
+/* translate the integer array into cpufreq_frequency_table entries */
+struct cpufreq_frequency_table *
+arm_bL_copy_table_from_array(unsigned int *table, int count)
+{
+	int i;
+
+	struct cpufreq_frequency_table *freq_table;
+
+	pr_debug("%s: table: %p, count: %d\n", __func__, table, count);
+
+	freq_table = kmalloc(sizeof(*freq_table) * (count + 1), GFP_KERNEL);
+	if (!freq_table)
+		return NULL;
+
+	for (i = 0; i < count; i++) {
+		pr_debug("%s: index: %d, freq: %d\n", __func__, i, table[i]);
+		freq_table[i].index = i;
+		freq_table[i].frequency = table[i]; /* in kHZ */
+	}
+
+	freq_table[i].index = count;
+	freq_table[i].frequency = CPUFREQ_TABLE_END;
+
+	return freq_table;
+}
+EXPORT_SYMBOL_GPL(arm_bL_copy_table_from_array);
+
+void arm_bL_free_freq_table(u32 cluster)
+{
+	pr_debug("%s: free freq table\n", __func__);
+
+	kfree(freq_table[cluster]);
+}
+EXPORT_SYMBOL_GPL(arm_bL_free_freq_table);
+
+static void put_cluster_clk_and_freq_table(u32 cluster)
+{
+	if (!atomic_dec_return(&cluster_usage[cluster])) {
+		clk_put(clk[cluster]);
+		arm_bL_ops->put_freq_tbl(cluster);
+		pr_debug("%s: cluster: %d\n", __func__, cluster);
+	}
+}
+
+static int get_cluster_clk_and_freq_table(u32 cluster)
+{
+	char name[14] = "cpu-cluster.";
+	int count;
+
+	if (atomic_inc_return(&cluster_usage[cluster]) != 1)
+		return 0;
+
+	freq_table[cluster] = arm_bL_ops->get_freq_tbl(cluster, &count);
+	if (!freq_table[cluster])
+		goto atomic_dec;
+
+	name[12] = cluster + '0';
+	clk[cluster] = clk_get_sys(name, NULL);
+	if (!IS_ERR(clk[cluster])) {
+		pr_debug("%s: clk: %p & freq table: %p, cluster: %d\n",
+				__func__, clk[cluster], freq_table[cluster],
+				cluster);
+		return 0;
+	}
+
+	arm_bL_ops->put_freq_tbl(cluster);
+
+atomic_dec:
+	atomic_dec(&cluster_usage[cluster]);
+	pr_err("%s: Failed to get data for cluster: %d\n", __func__, cluster);
+	return -ENODATA;
+}
+
+/* Per-CPU initialization */
+static int bL_cpufreq_init(struct cpufreq_policy *policy)
+{
+	u32 cur_cluster = cpu_to_cluster(policy->cpu);
+	int result;
+
+	result = get_cluster_clk_and_freq_table(cur_cluster);
+	if (result)
+		return result;
+
+	result = cpufreq_frequency_table_cpuinfo(policy,
+			freq_table[cur_cluster]);
+	if (result) {
+		pr_err("CPU %d, cluster: %d invalid freq table\n", policy->cpu,
+				cur_cluster);
+		put_cluster_clk_and_freq_table(cur_cluster);
+		return result;
+	}
+
+	cpufreq_frequency_table_get_attr(freq_table[cur_cluster], policy->cpu);
+
+	policy->cpuinfo.transition_latency =
+		arm_bL_ops->get_transition_latency(cur_cluster);
+	policy->cur = bL_cpufreq_get(policy->cpu);
+
+	cpumask_copy(policy->cpus, topology_core_cpumask(policy->cpu));
+
+	pr_info("CPU %d initialized\n", policy->cpu);
+	return 0;
+}
+
+static int bL_cpufreq_exit(struct cpufreq_policy *policy)
+{
+	put_cluster_clk_and_freq_table(cpu_to_cluster(policy->cpu));
+	pr_debug("%s: Exited, cpu: %d\n", __func__, policy->cpu);
+
+	return 0;
+}
+
+/* Export freq_table to sysfs */
+static struct freq_attr *bL_cpufreq_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
+};
+
+static struct cpufreq_driver bL_cpufreq_driver = {
+	.name	= "arm-big-little",
+	.flags	= CPUFREQ_STICKY,
+	.verify	= bL_cpufreq_verify_policy,
+	.target	= bL_cpufreq_set_target,
+	.get	= bL_cpufreq_get,
+	.init	= bL_cpufreq_init,
+	.exit	= bL_cpufreq_exit,
+	.attr	= bL_cpufreq_attr,
+};
+
+int bL_cpufreq_register(struct cpufreq_arm_bL_ops *ops)
+{
+	int ret;
+
+	if (arm_bL_ops) {
+		pr_debug("%s: Already registered: %s, exiting\n", __func__,
+				arm_bL_ops->name);
+		return -EBUSY;
+	}
+
+	if (!ops || !strlen(ops->name) || !ops->get_freq_tbl) {
+		pr_err("%s: Invalid arm_bL_ops, exiting\n", __func__);
+		return -ENODEV;
+	}
+
+	arm_bL_ops = ops;
+
+	ret = cpufreq_register_driver(&bL_cpufreq_driver);
+	if (ret) {
+		pr_info("%s: Failed registering platform driver: %s, err: %d\n",
+				__func__, ops->name, ret);
+		arm_bL_ops = NULL;
+	} else {
+		pr_info("%s: Registered platform driver: %s\n", __func__,
+				ops->name);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bL_cpufreq_register);
+
+void bL_cpufreq_unregister(struct cpufreq_arm_bL_ops *ops)
+{
+	if (arm_bL_ops != ops) {
+		pr_info("%s: Registered with: %s, can't unregister, exiting\n",
+				__func__, arm_bL_ops->name);
+	}
+
+	cpufreq_unregister_driver(&bL_cpufreq_driver);
+	pr_info("%s: Un-registered platform driver: %s\n", __func__,
+			arm_bL_ops->name);
+	arm_bL_ops = NULL;
+}
+EXPORT_SYMBOL_GPL(bL_cpufreq_unregister);
diff --git a/drivers/cpufreq/arm_big_little.h b/drivers/cpufreq/arm_big_little.h
new file mode 100644
index 0000000..049e15d
--- /dev/null
+++ b/drivers/cpufreq/arm_big_little.h
@@ -0,0 +1,40 @@
+/*
+ * ARM big.LITTLE platform's CPUFreq header file
+ *
+ * Copyright (C) 2013 ARM Ltd.
+ * Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
+ *
+ * Copyright (C) 2013 Linaro.
+ * Viresh Kumar <viresh.kumar@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+#ifndef CPUFREQ_ARM_BIG_LITTLE_H
+#define CPUFREQ_ARM_BIG_LITTLE_H
+
+#include <linux/cpufreq.h>
+#include <linux/types.h>
+
+struct cpufreq_arm_bL_ops {
+	char name[CPUFREQ_NAME_LEN];
+	u32 (*get_transition_latency)(u32 cluster);
+	struct cpufreq_frequency_table *(*get_freq_tbl)(u32 cluster,
+			int *count);
+	void (*put_freq_tbl)(u32 cluster);
+};
+
+struct cpufreq_frequency_table *
+arm_bL_copy_table_from_array(unsigned int *table, int count);
+void arm_bL_free_freq_table(u32 cluster);
+
+int bL_cpufreq_register(struct cpufreq_arm_bL_ops *ops);
+void bL_cpufreq_unregister(struct cpufreq_arm_bL_ops *ops);
+
+#endif /* CPUFREQ_ARM_BIG_LITTLE_H */
diff --git a/drivers/cpufreq/arm_big_little_dt.c b/drivers/cpufreq/arm_big_little_dt.c
new file mode 100644
index 0000000..c1eee50
--- /dev/null
+++ b/drivers/cpufreq/arm_big_little_dt.c
@@ -0,0 +1,125 @@
+/*
+ * Generic big.LITTLE CPUFreq Interface driver
+ *
+ * It provides necessary ops to arm_big_little cpufreq driver and gets
+ * Frequency information from Device Tree. Freq table in DT must be in KHz.
+ *
+ * Copyright (C) 2013 Linaro.
+ * Viresh Kumar <viresh.kumar@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/cpufreq.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include "arm_big_little.h"
+
+static struct cpufreq_frequency_table *generic_get_freq_tbl(u32 cluster,
+		int *count)
+{
+	struct device_node *np = NULL;
+	const struct property *pp;
+	unsigned int *table = NULL;
+	int cluster_id;
+	struct cpufreq_frequency_table *cpufreq_table;
+
+	while ((np = of_find_node_by_name(np, "cluster"))) {
+		if (of_property_read_u32(np, "reg", &cluster_id))
+			continue;
+
+		if (cluster_id != cluster)
+			continue;
+
+		pp = of_find_property(np, "freqs", NULL);
+		if (!pp)
+			continue;
+
+		*count = pp->length / sizeof(u32);
+		if (!*count)
+			continue;
+
+		table = kmalloc(sizeof(*table) * (*count), GFP_KERNEL);
+		if (!table) {
+			pr_err("%s: Failed to allocate memory for table\n",
+					__func__);
+			return NULL;
+		}
+
+		of_property_read_u32_array(np, "freqs", table, *count);
+		break;
+	}
+
+	if (!table) {
+		pr_err("%s: Unable to retrieve Freq table from Device Tree",
+				__func__);
+		return NULL;
+	}
+
+	cpufreq_table = arm_bL_copy_table_from_array(table, *count);
+	kfree(table);
+
+	return cpufreq_table;
+}
+
+static void generic_put_freq_tbl(u32 cluster)
+{
+	arm_bL_free_freq_table(cluster);
+}
+
+static u32 get_transition_latency(u32 cluster)
+{
+	struct device_node *np = NULL;
+	u32 transition_latency = CPUFREQ_ETERNAL;
+	int cluster_id;
+
+	while ((np = of_find_node_by_name(np, "cluster"))) {
+		if (of_property_read_u32(np, "reg", &cluster_id))
+			continue;
+
+		if (cluster_id != cluster)
+			continue;
+
+		of_property_read_u32(np, "clock-latency", &transition_latency);
+		return transition_latency;
+	}
+
+	pr_err("%s: Unable to get clock-latency from DT, use CPUFREQ_ETERNAL",
+			__func__);
+
+	return transition_latency;
+}
+
+static struct cpufreq_arm_bL_ops generic_bL_ops = {
+	.name	= "generic-bl",
+	.get_transition_latency = get_transition_latency,
+	.get_freq_tbl = generic_get_freq_tbl,
+	.put_freq_tbl = generic_put_freq_tbl,
+};
+
+static int generic_bL_init(void)
+{
+	return bL_cpufreq_register(&generic_bL_ops);
+}
+module_init(generic_bL_init);
+
+static void generic_bL_exit(void)
+{
+	return bL_cpufreq_unregister(&generic_bL_ops);
+}
+module_exit(generic_bL_exit);
+
+MODULE_DESCRIPTION("Generic ARM big LITTLE cpufreq driver");
+MODULE_LICENSE("GPL");
-- 
1.7.12.rc2.18.g61b472e

