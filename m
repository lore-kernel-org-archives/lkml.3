Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3DAM7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:59:18 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61495 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909Ab3DAM7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:59:15 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH 9/9] cpufreq: ARM big LITTLE: Add generic cpufreq driver and its DT glue
Date: Mon,  1 Apr 2013 18:27:49 +0530
Message-Id: <46a588403ada25e7b16873175d1181ebb981095d.1364820621.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
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
 .../bindings/cpufreq/arm_big_little_dt.txt         |  65 +++++
 MAINTAINERS                                        |  11 +
 drivers/cpufreq/Kconfig.arm                        |  12 +
 drivers/cpufreq/Makefile                           |   5 +
 drivers/cpufreq/arm_big_little.c                   | 282 +++++++++++++++++++++
 drivers/cpufreq/arm_big_little.h                   |  40 +++
 drivers/cpufreq/arm_big_little_dt.c                |  92 +++++++
 7 files changed, 507 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt
 create mode 100644 drivers/cpufreq/arm_big_little.c
 create mode 100644 drivers/cpufreq/arm_big_little.h
 create mode 100644 drivers/cpufreq/arm_big_little_dt.c

diff --git a/Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt b/Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt
new file mode 100644
index 0000000..0715695
--- /dev/null
+++ b/Documentation/devicetree/bindings/cpufreq/arm_big_little_dt.txt
@@ -0,0 +1,65 @@
+Generic ARM big LITTLE cpufreq driver's DT glue
+-----------------------------------------------
+
+This is DT specific glue layer for generic cpufreq driver for big LITTLE
+systems.
+
+Both required and optional properties listed below must be defined
+under node /cpus/cpu@x. Where x is the first cpu inside a cluster.
+
+FIXME: Cpus should boot in the order specified in DT and all cpus for a cluster
+must be present contiguously. Generic DT driver will check only node 'x' for
+cpu:x.
+
+Required properties:
+- operating-points: Refer to Documentation/devicetree/bindings/power/opp.txt
+  for details
+
+Optional properties:
+- clock-latency: Specify the possible maximum transition latency for clock,
+  in unit of nanoseconds.
+
+Examples:
+
+cpus {
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	cpu@0 {
+		compatible = "arm,cortex-a15";
+		reg = <0>;
+		next-level-cache = <&L2>;
+		operating-points = <
+			/* kHz    uV */
+			792000  1100000
+			396000  950000
+			198000  850000
+		>;
+		clock-latency = <61036>; /* two CLK32 periods */
+	};
+
+	cpu@1 {
+		compatible = "arm,cortex-a15";
+		reg = <1>;
+		next-level-cache = <&L2>;
+	};
+
+	cpu@100 {
+		compatible = "arm,cortex-a7";
+		reg = <100>;
+		next-level-cache = <&L2>;
+		operating-points = <
+			/* kHz    uV */
+			792000  950000
+			396000  750000
+			198000  450000
+		>;
+		clock-latency = <61036>; /* two CLK32 periods */
+	};
+
+	cpu@101 {
+		compatible = "arm,cortex-a7";
+		reg = <101>;
+		next-level-cache = <&L2>;
+	};
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index 72b0843..3676526 100644
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
index 863fd18..ba9a3e1 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -44,6 +44,11 @@ obj-$(CONFIG_X86_INTEL_PSTATE)		+= intel_pstate.o
 
 ##################################################################################
 # ARM SoC drivers
+obj-$(CONFIG_ARM_BIG_LITTLE_CPUFREQ)	+= arm_big_little.o
+# big LITTLE per platform glues. Keep DT_BL_CPUFREQ as the last entry in all big
+# LITTLE drivers, so that it is probed last.
+obj-$(CONFIG_ARM_DT_BL_CPUFREQ)		+= arm_big_little_dt.o
+
 obj-$(CONFIG_UX500_SOC_DB8500)		+= dbx500-cpufreq.o
 obj-$(CONFIG_ARM_S3C2416_CPUFREQ)	+= s3c2416-cpufreq.o
 obj-$(CONFIG_ARM_S3C64XX_CPUFREQ)	+= s3c64xx-cpufreq.o
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
new file mode 100644
index 0000000..1d29d1a
--- /dev/null
+++ b/drivers/cpufreq/arm_big_little.c
@@ -0,0 +1,282 @@
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
+#include <linux/cpu.h>
+#include <linux/cpufreq.h>
+#include <linux/cpumask.h>
+#include <linux/export.h>
+#include <linux/of_platform.h>
+#include <linux/opp.h>
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
+static void put_cluster_clk_and_freq_table(struct device *cpu_dev)
+{
+	u32 cluster = cpu_to_cluster(cpu_dev->id);
+
+	if (!atomic_dec_return(&cluster_usage[cluster])) {
+		clk_put(clk[cluster]);
+		opp_free_cpufreq_table(cpu_dev, &freq_table[cluster]);
+		dev_dbg(cpu_dev, "%s: cluster: %d\n", __func__, cluster);
+	}
+}
+
+static int get_cluster_clk_and_freq_table(struct device *cpu_dev)
+{
+	u32 cluster = cpu_to_cluster(cpu_dev->id);
+	char name[14] = "cpu-cluster.";
+	int ret;
+
+	if (atomic_inc_return(&cluster_usage[cluster]) != 1)
+		return 0;
+
+	ret = arm_bL_ops->init_opp_table(cpu_dev);
+	if (ret) {
+		dev_err(cpu_dev, "%s: init_opp_table failed, cpu: %d, err: %d\n",
+				__func__, cpu_dev->id, ret);
+		goto atomic_dec;
+	}
+
+	ret = opp_init_cpufreq_table(cpu_dev, &freq_table[cluster]);
+	if (ret) {
+		dev_err(cpu_dev, "%s: failed to init cpufreq table, cpu: %d, err: %d\n",
+				__func__, cpu_dev->id, ret);
+		goto atomic_dec;
+	}
+
+	name[12] = cluster + '0';
+	clk[cluster] = clk_get_sys(name, NULL);
+	if (!IS_ERR(clk[cluster])) {
+		dev_dbg(cpu_dev, "%s: clk: %p & freq table: %p, cluster: %d\n",
+				__func__, clk[cluster], freq_table[cluster],
+				cluster);
+		return 0;
+	}
+
+	dev_err(cpu_dev, "%s: Failed to get clk for cpu: %d, cluster: %d\n",
+			__func__, cpu_dev->id, cluster);
+	ret = PTR_ERR(clk[cluster]);
+	opp_free_cpufreq_table(cpu_dev, &freq_table[cluster]);
+
+atomic_dec:
+	atomic_dec(&cluster_usage[cluster]);
+	dev_err(cpu_dev, "%s: Failed to get data for cluster: %d\n", __func__,
+			cluster);
+	return ret;
+}
+
+/* Per-CPU initialization */
+static int bL_cpufreq_init(struct cpufreq_policy *policy)
+{
+	u32 cur_cluster = cpu_to_cluster(policy->cpu);
+	struct device *cpu_dev;
+	int ret;
+
+	cpu_dev = get_cpu_device(policy->cpu);
+	if (!cpu_dev) {
+		pr_err("%s: failed to get cpu%d device\n", __func__,
+				policy->cpu);
+		return -ENODEV;
+	}
+
+	ret = get_cluster_clk_and_freq_table(cpu_dev);
+	if (ret)
+		return ret;
+
+	ret = cpufreq_frequency_table_cpuinfo(policy, freq_table[cur_cluster]);
+	if (ret) {
+		dev_err(cpu_dev, "CPU %d, cluster: %d invalid freq table\n",
+				policy->cpu, cur_cluster);
+		put_cluster_clk_and_freq_table(cpu_dev);
+		return ret;
+	}
+
+	cpufreq_frequency_table_get_attr(freq_table[cur_cluster], policy->cpu);
+
+	if (arm_bL_ops->get_transition_latency)
+		policy->cpuinfo.transition_latency =
+			arm_bL_ops->get_transition_latency(cpu_dev);
+	else
+		policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
+
+	policy->cur = bL_cpufreq_get(policy->cpu);
+
+	cpumask_copy(policy->cpus, topology_core_cpumask(policy->cpu));
+
+	dev_info(cpu_dev, "CPU %d initialized\n", policy->cpu);
+	return 0;
+}
+
+static int bL_cpufreq_exit(struct cpufreq_policy *policy)
+{
+	struct device *cpu_dev;
+
+	cpu_dev = get_cpu_device(policy->cpu);
+	if (!cpu_dev) {
+		pr_err("%s: failed to get cpu%d device\n", __func__,
+				policy->cpu);
+		return -ENODEV;
+	}
+
+	put_cluster_clk_and_freq_table(cpu_dev);
+	dev_dbg(cpu_dev, "%s: Exited, cpu: %d\n", __func__, policy->cpu);
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
+	.name			= "arm-big-little",
+	.flags			= CPUFREQ_STICKY,
+	.verify			= bL_cpufreq_verify_policy,
+	.target			= bL_cpufreq_set_target,
+	.get			= bL_cpufreq_get,
+	.init			= bL_cpufreq_init,
+	.exit			= bL_cpufreq_exit,
+	.have_multiple_policies	= true,
+	.attr			= bL_cpufreq_attr,
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
+	if (!ops || !strlen(ops->name) || !ops->init_opp_table) {
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
+		pr_err("%s: Registered with: %s, can't unregister, exiting\n",
+				__func__, arm_bL_ops->name);
+		return;
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
index 0000000..70f18fc
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
+#include <linux/device.h>
+#include <linux/types.h>
+
+struct cpufreq_arm_bL_ops {
+	char name[CPUFREQ_NAME_LEN];
+	int (*get_transition_latency)(struct device *cpu_dev);
+
+	/*
+	 * This must set opp table for cpu_dev in a similar way as done by
+	 * of_init_opp_table().
+	 */
+	int (*init_opp_table)(struct device *cpu_dev);
+};
+
+int bL_cpufreq_register(struct cpufreq_arm_bL_ops *ops);
+void bL_cpufreq_unregister(struct cpufreq_arm_bL_ops *ops);
+
+#endif /* CPUFREQ_ARM_BIG_LITTLE_H */
diff --git a/drivers/cpufreq/arm_big_little_dt.c b/drivers/cpufreq/arm_big_little_dt.c
new file mode 100644
index 0000000..452ff46
--- /dev/null
+++ b/drivers/cpufreq/arm_big_little_dt.c
@@ -0,0 +1,92 @@
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
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/opp.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include "arm_big_little.h"
+
+static int dt_init_opp_table(struct device *cpu_dev)
+{
+	struct device_node *np = NULL;
+	int count = 0, ret;
+
+	for_each_child_of_node(of_find_node_by_path("/cpus"), np) {
+		if (count++ != cpu_dev->id)
+			continue;
+		if (!of_get_property(np, "operating-points", NULL))
+			return -ENODATA;
+
+		cpu_dev->of_node = np;
+
+		ret = of_init_opp_table(cpu_dev);
+		if (ret)
+			return ret;
+
+		return 0;
+	}
+
+	return -ENODEV;
+}
+
+static int dt_get_transition_latency(struct device *cpu_dev)
+{
+	struct device_node *np = NULL;
+	u32 transition_latency = CPUFREQ_ETERNAL;
+	int count = 0;
+
+	for_each_child_of_node(of_find_node_by_path("/cpus"), np) {
+		if (count++ != cpu_dev->id)
+			continue;
+
+		of_property_read_u32(np, "clock-latency", &transition_latency);
+		return 0;
+	}
+
+	return -ENODEV;
+}
+
+static struct cpufreq_arm_bL_ops dt_bL_ops = {
+	.name	= "dt-bl",
+	.get_transition_latency = dt_get_transition_latency,
+	.init_opp_table = dt_init_opp_table,
+};
+
+static int generic_bL_init(void)
+{
+	return bL_cpufreq_register(&dt_bL_ops);
+}
+module_init(generic_bL_init);
+
+static void generic_bL_exit(void)
+{
+	return bL_cpufreq_unregister(&dt_bL_ops);
+}
+module_exit(generic_bL_exit);
+
+MODULE_AUTHOR("Viresh Kumar <viresh.kumar@linaro.org>");
+MODULE_DESCRIPTION("Generic ARM big LITTLE cpufreq driver via DT");
+MODULE_LICENSE("GPL");
-- 
1.7.12.rc2.18.g61b472e

