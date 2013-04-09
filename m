Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936340Ab3DIJMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:12:53 -0400
Received: from [213.199.154.188] ([213.199.154.188]:49185 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935498Ab3DIJMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:12:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: <Yuantian.Tang@freescale.com>
To: <rjw@sisk.pl>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <viresh.kumar@linaro.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        Tang Yuantian <yuantian.tang@freescale.com>,
        Tang Yuantian <Yuantian.Tang@freescale.com>,
        Li Yang <leoli@freescale.com>
Subject: [PATCH v4] cpufreq: powerpc: Add cpufreq driver for Freescale e500mc SoCs
Date: Tue, 9 Apr 2013 16:32:45 +0800
Message-ID: <1365496365-28450-1-git-send-email-Yuantian.Tang@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Yuantian <yuantian.tang@freescale.com>

Add cpufreq driver for Freescale e500mc, e5500 and e6500 SoCs
which are capable of changing the CPU frequency dynamically

Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
v4:
	- rebase on bleeding-edge branch of Rafael's linux-pm.git 
	- #define pr_fmt() for better debug prints
	- use newest cpufreq_notify_transition()
	- support CPU hotplug
	- remove table[i].index as it is not used
	- remove cpus_per_cluster
v3:
	- change sizeof(struct name).. to sizeof(*p)
	- remove the struct cpufreq_data, use global variable instead
	- resolve setting policy->cpus incorrectly
	- add CPUFREQ_POSTCHANGE notifier when setting frequency error
v2:
	- add depends on OF and COMMON_CLK in Kconfig
	- use clk.h instead of clk-provider.h
	- change per_cpu variable from struct to pointer

 drivers/cpufreq/Kconfig.powerpc       |  10 ++
 drivers/cpufreq/Makefile              |   1 +
 drivers/cpufreq/ppc-corenet-cpufreq.c | 254 ++++++++++++++++++++++++++++++++++
 3 files changed, 265 insertions(+)
 create mode 100644 drivers/cpufreq/ppc-corenet-cpufreq.c

diff --git a/drivers/cpufreq/Kconfig.powerpc b/drivers/cpufreq/Kconfig.powerpc
index 9c926ca..88f629e 100644
--- a/drivers/cpufreq/Kconfig.powerpc
+++ b/drivers/cpufreq/Kconfig.powerpc
@@ -23,3 +23,13 @@ config CPU_FREQ_MAPLE
 	help
 	  This adds support for frequency switching on Maple 970FX
 	  Evaluation Board and compatible boards (IBM JS2x blades).
+
+config PPC_CORENET_CPUFREQ
+	tristate "CPU frequency scaling driver for Freescale E500MC SoCs"
+	depends on PPC_E500MC && OF && COMMON_CLK
+	select CPU_FREQ_TABLE
+	select CLK_PPC_CORENET
+	help
+	  This adds the CPUFreq driver support for Freescale e500mc,
+	  e5500 and e6500 series SoCs which are capable of changing
+	  the CPU's frequency dynamically.
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 6ad0b91..5125034 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -84,6 +84,7 @@ obj-$(CONFIG_CPU_FREQ_CBE)		+= ppc-cbe-cpufreq.o
 ppc-cbe-cpufreq-y			+= ppc_cbe_cpufreq_pervasive.o ppc_cbe_cpufreq.o
 obj-$(CONFIG_CPU_FREQ_CBE_PMI)		+= ppc_cbe_cpufreq_pmi.o
 obj-$(CONFIG_CPU_FREQ_MAPLE)		+= maple-cpufreq.o
+obj-$(CONFIG_PPC_CORENET_CPUFREQ)   += ppc-corenet-cpufreq.o
 
 ##################################################################################
 # Other platform drivers
diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
new file mode 100644
index 0000000..e230282
--- /dev/null
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -0,0 +1,254 @@
+/*
+ * Copyright 2013 Freescale Semiconductor, Inc.
+ *
+ * CPU Frequency Scaling driver for Freescale PowerPC corenet SoCs.
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
+
+/**
+ * struct cpu_data - per CPU data struct
+ * @clk: the clk of CPU
+ * @parent: the parent node of cpu clock
+ * @table: frequency table
+ */
+struct cpu_data {
+	struct clk *clk;
+	struct device_node *parent;
+	struct cpufreq_frequency_table *table;
+};
+
+/* serialize frequency changes  */
+static DEFINE_MUTEX(cpufreq_lock);
+static DEFINE_PER_CPU(struct cpu_data *, cpu_data);
+
+static unsigned int corenet_cpufreq_get_speed(unsigned int cpu)
+{
+	struct cpu_data *data = per_cpu(cpu_data, cpu);
+
+	return clk_get_rate(data->clk) / 1000;
+}
+
+/* reduce the duplicated frequency in frequency table */
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
+static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
+{
+	struct device_node *np;
+	int i, count, ret;
+	struct clk *clk;
+	struct cpufreq_frequency_table *table;
+	struct cpu_data *data;
+	unsigned int cpu = policy->cpu;
+
+	np = of_get_cpu_node(cpu, NULL);
+	if (!np)
+		return -ENODEV;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		pr_err("%s: no memory\n", __func__);
+		goto err_np;
+	}
+
+	data->clk = of_clk_get(np, 0);
+	if (IS_ERR(data->clk)) {
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
+	for (i = 0; i < count; i++) {
+		clk = of_clk_get(data->parent, i);
+		table[i].frequency = clk_get_rate(clk) / 1000;
+	}
+	freq_table_redup(table, count);
+	table[i].frequency = CPUFREQ_TABLE_END;
+
+	/* set the min and max frequency properly */
+	ret = cpufreq_frequency_table_cpuinfo(policy, table);
+	if (ret) {
+		pr_err("invalid frequency table: %d\n", ret);
+		goto err_nomem1;
+	}
+
+	data->table = table;
+	per_cpu(cpu_data, cpu) = data;
+
+#ifdef CONFIG_SMP
+	/* update ->cpus if we have cluster, no harm if not */
+	cpumask_copy(policy->cpus, cpu_core_mask(cpu));
+#endif
+
+	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
+	policy->cur = corenet_cpufreq_get_speed(policy->cpu);
+
+	cpufreq_frequency_table_get_attr(table, cpu);
+	of_node_put(np);
+
+	return 0;
+
+err_nomem1:
+	kfree(table);
+err_node:
+	of_node_put(data->parent);
+err_nomem2:
+	per_cpu(cpu_data, cpu) = NULL;
+	kfree(data);
+err_np:
+	of_node_put(np);
+
+	return -ENODEV;
+}
+
+static int __exit corenet_cpufreq_cpu_exit(struct cpufreq_policy *policy)
+{
+	struct cpu_data *data = per_cpu(cpu_data, policy->cpu);
+
+	cpufreq_frequency_table_put_attr(policy->cpu);
+	of_node_put(data->parent);
+	kfree(data->table);
+	kfree(data);
+	per_cpu(cpu_data, policy->cpu) = NULL;
+
+	return 0;
+}
+
+static int corenet_cpufreq_verify(struct cpufreq_policy *policy)
+{
+	struct cpufreq_frequency_table *table =
+		per_cpu(cpu_data, policy->cpu)->table;
+
+	return cpufreq_frequency_table_verify(policy, table);
+}
+
+static int corenet_cpufreq_target(struct cpufreq_policy *policy,
+		unsigned int target_freq, unsigned int relation)
+{
+	struct cpufreq_freqs freqs;
+	unsigned int new;
+	struct clk *parent;
+	int ret;
+	struct cpu_data *data = per_cpu(cpu_data, policy->cpu);
+
+	cpufreq_frequency_table_target(policy, data->table,
+			target_freq, relation, &new);
+
+	if (policy->cur == data->table[new].frequency)
+		return 0;
+
+	freqs.old = policy->cur;
+	freqs.new = data->table[new].frequency;
+	freqs.cpu = policy->cpu;
+
+	mutex_lock(&cpufreq_lock);
+	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+
+	parent = of_clk_get(data->parent, new);
+	ret = clk_set_parent(data->clk, parent);
+	if (ret) {
+		freqs.new = freqs.old;
+		cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+		mutex_unlock(&cpufreq_lock);
+		return ret;
+	}
+
+	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	mutex_unlock(&cpufreq_lock);
+
+	return 0;
+}
+
+static struct freq_attr *corenet_cpufreq_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
+};
+
+static struct cpufreq_driver ppc_corenet_cpufreq_driver = {
+	.name		= "ppc_cpufreq",
+	.owner		= THIS_MODULE,
+	.flags		= CPUFREQ_CONST_LOOPS,
+	.init		= corenet_cpufreq_cpu_init,
+	.exit		= __exit_p(corenet_cpufreq_cpu_exit),
+	.verify		= corenet_cpufreq_verify,
+	.target		= corenet_cpufreq_target,
+	.get		= corenet_cpufreq_get_speed,
+	.attr		= corenet_cpufreq_attr,
+};
+
+static const struct of_device_id node_matches[] __initconst = {
+	{ .compatible = "fsl,qoriq-clockgen-1.0", },
+	{ .compatible = "fsl,qoriq-clockgen-2", },
+	{}
+};
+
+static int __init ppc_corenet_cpufreq_init(void)
+{
+	int ret = 0;
+	struct device_node  *np;
+
+	np = of_find_matching_node(NULL, node_matches);
+	if (!np)
+		return -ENODEV;
+
+	of_node_put(np);
+
+	ret = cpufreq_register_driver(&ppc_corenet_cpufreq_driver);
+	if (!ret)
+		pr_info("Freescale PowerPC corenet CPU frequency scaling driver\n");
+
+	return ret;
+}
+module_init(ppc_corenet_cpufreq_init);
+
+static void __exit ppc_corenet_cpufreq_exit(void)
+{
+	cpufreq_unregister_driver(&ppc_corenet_cpufreq_driver);
+}
+module_exit(ppc_corenet_cpufreq_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tang Yuantian <Yuantian.Tang@freescale.com>");
+MODULE_DESCRIPTION("cpufreq driver for Freescale e500mc series SoCs");
-- 
1.8.0


