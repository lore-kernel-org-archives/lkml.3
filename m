Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaJQD36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 23:29:58 -0400
Received: from mail-bl2on0114.outbound.protection.outlook.com ([65.55.169.114]:60926
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751643AbaJQD34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 23:29:56 -0400
X-Greylist: delayed 925 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2014 23:29:55 EDT
From: <B29983@freescale.com>
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>, Tang Yuantian <Yuantian.Tang@freescale.com>
Subject: [PATCH] cpufreq: qoriq: Make the driver usable on all QorIQ platforms
Date: Fri, 17 Oct 2014 11:13:36 +0800
Message-ID: <1413515616-15874-1-git-send-email-B29983@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(48376002)(106466001)(89996001)(104166001)(99396003)(81156004)(88136002)(62966002)(31966008)(36756003)(46102003)(85306004)(80022003)(97736003)(77156001)(87936001)(26826002)(107046002)(85852003)(4396001)(120916001)(95666004)(50226001)(229853001)(87286001)(102836001)(50986999)(105606002)(44976005)(68736004)(84676001)(69596002)(86152002)(92566001)(104016003)(21056001)(93916002)(92726001)(64706001)(76482002)(50466002)(47776003)(575784001)(6806004)(20776003)(19580395003)(19580405001)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB562;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB562;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Yuantian.Tang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Yuantian <Yuantian.Tang@freescale.com>

Freescale introduced new ARM core-based SoCs which support dynamic
frequency switch feature. DFS on new SoCs are compatible with current
PowerPC CoreNet platforms. In order to support those new platforms,
this driver needs to be slightly adjusted. The main changes include:

1. Changed the names of driver and functions in driver.
2. Added two new functions get_cpu_physical_id() and get_bus_freq().
3. Used a new way to get all the CPUs which sharing clock wire.

Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
---
 drivers/cpufreq/Kconfig.arm                        |   8 ++
 drivers/cpufreq/Kconfig.powerpc                    |  11 +-
 drivers/cpufreq/Makefile                           |   2 +-
 .../{ppc-corenet-cpufreq.c => qoriq-cpufreq.c}     | 150 ++++++++++++++-------
 4 files changed, 114 insertions(+), 57 deletions(-)
 rename drivers/cpufreq/{ppc-corenet-cpufreq.c => qoriq-cpufreq.c} (72%)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 83a75dc..1925ae94 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -247,3 +247,11 @@ config ARM_TEGRA_CPUFREQ
 	default y
 	help
 	  This adds the CPUFreq driver support for TEGRA SOCs.
+
+config QORIQ_CPUFREQ
+	tristate "CPU frequency scaling driver for Freescale QorIQ SoCs"
+	depends on OF && COMMON_CLK
+	select CLK_PPC_CORENET
+	help
+	  This adds the CPUFreq driver support for Freescale QorIQ SoCs
+	  which are capable of changing the CPU's frequency dynamically.
diff --git a/drivers/cpufreq/Kconfig.powerpc b/drivers/cpufreq/Kconfig.powerpc
index 72564b7..3a34248 100644
--- a/drivers/cpufreq/Kconfig.powerpc
+++ b/drivers/cpufreq/Kconfig.powerpc
@@ -23,14 +23,13 @@ config CPU_FREQ_MAPLE
 	  This adds support for frequency switching on Maple 970FX
 	  Evaluation Board and compatible boards (IBM JS2x blades).
 
-config PPC_CORENET_CPUFREQ
-	tristate "CPU frequency scaling driver for Freescale E500MC SoCs"
-	depends on PPC_E500MC && OF && COMMON_CLK
+config QORIQ_CPUFREQ
+	tristate "CPU frequency scaling driver for Freescale QorIQ SoCs"
+	depends on OF && COMMON_CLK
 	select CLK_PPC_CORENET
 	help
-	  This adds the CPUFreq driver support for Freescale e500mc,
-	  e5500 and e6500 series SoCs which are capable of changing
-	  the CPU's frequency dynamically.
+	  This adds the CPUFreq driver support for Freescale QorIQ SoCs
+	  which are capable of changing the CPU's frequency dynamically.
 
 config CPU_FREQ_PMAC
 	bool "Support for Apple PowerBooks"
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 40c53dc..0020049 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -84,7 +84,7 @@ obj-$(CONFIG_CPU_FREQ_CBE)		+= ppc-cbe-cpufreq.o
 ppc-cbe-cpufreq-y			+= ppc_cbe_cpufreq_pervasive.o ppc_cbe_cpufreq.o
 obj-$(CONFIG_CPU_FREQ_CBE_PMI)		+= ppc_cbe_cpufreq_pmi.o
 obj-$(CONFIG_CPU_FREQ_MAPLE)		+= maple-cpufreq.o
-obj-$(CONFIG_PPC_CORENET_CPUFREQ)   += ppc-corenet-cpufreq.o
+obj-$(CONFIG_QORIQ_CPUFREQ)   		+= qoriq-cpufreq.o
 obj-$(CONFIG_CPU_FREQ_PMAC)		+= pmac32-cpufreq.o
 obj-$(CONFIG_CPU_FREQ_PMAC64)		+= pmac64-cpufreq.o
 obj-$(CONFIG_PPC_PASEMI_CPUFREQ)	+= pasemi-cpufreq.o
diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/qoriq-cpufreq.c
similarity index 72%
rename from drivers/cpufreq/ppc-corenet-cpufreq.c
rename to drivers/cpufreq/qoriq-cpufreq.c
index bee5df7..80def0c 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/qoriq-cpufreq.c
@@ -1,7 +1,7 @@
 /*
  * Copyright 2013 Freescale Semiconductor, Inc.
  *
- * CPU Frequency Scaling driver for Freescale PowerPC corenet SoCs.
+ * CPU Frequency Scaling driver for Freescale QorIQ SoCs.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -20,7 +20,6 @@
 #include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
-#include <sysdev/fsl_soc.h>
 
 /**
  * struct cpu_data - per CPU data struct
@@ -69,9 +68,6 @@ static const u32 *fmask;
 
 static DEFINE_PER_CPU(struct cpu_data *, cpu_data);
 
-/* cpumask in a cluster */
-static DEFINE_PER_CPU(cpumask_var_t, cpu_mask);
-
 #ifndef CONFIG_SMP
 static inline const struct cpumask *cpu_core_mask(int cpu)
 {
@@ -79,6 +75,79 @@ static inline const struct cpumask *cpu_core_mask(int cpu)
 }
 #endif
 
+#if defined(CONFIG_PPC_E500MC)
+static int get_cpu_physical_id(int cpu)
+{
+	return get_hard_smp_processor_id(cpu);
+}
+#elif defined(CONFIG_ARM)
+static int get_cpu_physical_id(int cpu)
+{
+	return topology_core_id(cpu);
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
 /* reduce the duplicated frequencies in frequency table */
 static void freq_table_redup(struct cpufreq_frequency_table *freq_table,
 		int count)
@@ -105,6 +174,7 @@ static void freq_table_sort(struct cpufreq_frequency_table *freq_table,
 	int i, j, ind;
 	unsigned int freq, max_freq;
 	struct cpufreq_frequency_table table;
+
 	for (i = 0; i < count - 1; i++) {
 		max_freq = freq_table[i].frequency;
 		ind = i;
@@ -129,7 +199,7 @@ static void freq_table_sort(struct cpufreq_frequency_table *freq_table,
 	}
 }
 
-static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
+static int qoriq_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
 	struct device_node *np;
 	int i, count, ret;
@@ -145,10 +215,8 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return -ENODEV;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		pr_err("%s: no memory\n", __func__);
+	if (!data)
 		goto err_np;
-	}
 
 	policy->clk = of_clk_get(np, 0);
 	if (IS_ERR(policy->clk)) {
@@ -170,7 +238,7 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	}
 
 	if (fmask)
-		mask = fmask[get_hard_smp_processor_id(cpu)];
+		mask = fmask[get_cpu_physical_id(cpu)];
 	else
 		mask = 0x0;
 
@@ -201,13 +269,13 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	data->table = table;
 
 	/* update ->cpus if we have cluster, no harm if not */
-	cpumask_copy(policy->cpus, per_cpu(cpu_mask, cpu));
-	for_each_cpu(i, per_cpu(cpu_mask, cpu))
+	set_affected_cpus(policy);
+	for_each_cpu(i, policy->cpus)
 		per_cpu(cpu_data, i) = data;
 
 	/* Minimum transition latency is 12 platform clocks */
 	u64temp = 12ULL * NSEC_PER_SEC;
-	do_div(u64temp, fsl_get_sys_freq());
+	do_div(u64temp, get_bus_freq());
 	policy->cpuinfo.transition_latency = u64temp + 1;
 
 	of_node_put(np);
@@ -227,7 +295,7 @@ err_np:
 	return -ENODEV;
 }
 
-static int __exit corenet_cpufreq_cpu_exit(struct cpufreq_policy *policy)
+static int __exit qoriq_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 {
 	struct cpu_data *data = per_cpu(cpu_data, policy->cpu);
 	unsigned int cpu;
@@ -236,13 +304,13 @@ static int __exit corenet_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 	kfree(data->table);
 	kfree(data);
 
-	for_each_cpu(cpu, per_cpu(cpu_mask, policy->cpu))
+	for_each_cpu(cpu, policy->cpus)
 		per_cpu(cpu_data, cpu) = NULL;
 
 	return 0;
 }
 
-static int corenet_cpufreq_target(struct cpufreq_policy *policy,
+static int qoriq_cpufreq_target(struct cpufreq_policy *policy,
 		unsigned int index)
 {
 	struct clk *parent;
@@ -252,18 +320,18 @@ static int corenet_cpufreq_target(struct cpufreq_policy *policy,
 	return clk_set_parent(policy->clk, parent);
 }
 
-static struct cpufreq_driver ppc_corenet_cpufreq_driver = {
-	.name		= "ppc_cpufreq",
+static struct cpufreq_driver qoriq_cpufreq_driver = {
+	.name		= "qoriq_cpufreq",
 	.flags		= CPUFREQ_CONST_LOOPS,
-	.init		= corenet_cpufreq_cpu_init,
-	.exit		= __exit_p(corenet_cpufreq_cpu_exit),
+	.init		= qoriq_cpufreq_cpu_init,
+	.exit		= __exit_p(qoriq_cpufreq_cpu_exit),
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_index	= corenet_cpufreq_target,
+	.target_index	= qoriq_cpufreq_target,
 	.get		= cpufreq_generic_get,
 	.attr		= cpufreq_generic_attr,
 };
 
-static const struct of_device_id node_matches[] __initdata = {
+static const struct of_device_id node_matches[] __initconst = {
 	{ .compatible = "fsl,p2041-clockgen", .data = &sdata[0], },
 	{ .compatible = "fsl,p3041-clockgen", .data = &sdata[0], },
 	{ .compatible = "fsl,p5020-clockgen", .data = &sdata[1], },
@@ -273,61 +341,43 @@ static const struct of_device_id node_matches[] __initdata = {
 	{}
 };
 
-static int __init ppc_corenet_cpufreq_init(void)
+static int __init qoriq_cpufreq_init(void)
 {
 	int ret;
 	struct device_node  *np;
 	const struct of_device_id *match;
 	const struct soc_data *data;
-	unsigned int cpu;
 
 	np = of_find_matching_node(NULL, node_matches);
 	if (!np)
 		return -ENODEV;
 
-	for_each_possible_cpu(cpu) {
-		if (!alloc_cpumask_var(&per_cpu(cpu_mask, cpu), GFP_KERNEL))
-			goto err_mask;
-		cpumask_copy(per_cpu(cpu_mask, cpu), cpu_core_mask(cpu));
-	}
-
 	match = of_match_node(node_matches, np);
 	data = match->data;
 	if (data) {
 		if (data->flag)
 			fmask = data->freq_mask;
-		min_cpufreq = fsl_get_sys_freq();
+		min_cpufreq = get_bus_freq();
 	} else {
-		min_cpufreq = fsl_get_sys_freq() / 2;
+		min_cpufreq = get_bus_freq() / 2;
 	}
 
 	of_node_put(np);
 
-	ret = cpufreq_register_driver(&ppc_corenet_cpufreq_driver);
+	ret = cpufreq_register_driver(&qoriq_cpufreq_driver);
 	if (!ret)
-		pr_info("Freescale PowerPC corenet CPU frequency scaling driver\n");
+		pr_info("Freescale QorIQ CPU frequency scaling driver\n");
 
 	return ret;
-
-err_mask:
-	for_each_possible_cpu(cpu)
-		free_cpumask_var(per_cpu(cpu_mask, cpu));
-
-	return -ENOMEM;
 }
-module_init(ppc_corenet_cpufreq_init);
+module_init(qoriq_cpufreq_init);
 
-static void __exit ppc_corenet_cpufreq_exit(void)
+static void __exit qoriq_cpufreq_exit(void)
 {
-	unsigned int cpu;
-
-	for_each_possible_cpu(cpu)
-		free_cpumask_var(per_cpu(cpu_mask, cpu));
-
-	cpufreq_unregister_driver(&ppc_corenet_cpufreq_driver);
+	cpufreq_unregister_driver(&qoriq_cpufreq_driver);
 }
-module_exit(ppc_corenet_cpufreq_exit);
+module_exit(qoriq_cpufreq_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tang Yuantian <Yuantian.Tang@freescale.com>");
-MODULE_DESCRIPTION("cpufreq driver for Freescale e500mc series SoCs");
+MODULE_DESCRIPTION("cpufreq driver for Freescale QorIQ series SoCs");
-- 
2.1.0.27.g96db324

