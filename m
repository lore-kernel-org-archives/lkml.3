Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3LBGUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 01:20:37 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:37629 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab3LBGUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 01:20:31 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/3] cpufreq: add 'freq_table' in struct cpufreq_policy
Date: Mon,  2 Dec 2013 11:48:28 +0530
Message-Id: <bb01174d06a8c0a8171c3a9bfd03d5eef8c3fb12.1385964947.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1385964947.git.viresh.kumar@linaro.org>
References: <cover.1385964947.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1385964947.git.viresh.kumar@linaro.org>
References: <cover.1385964947.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

freq table is not per CPU but per policy and so it makes more sense to keep it
within struct cpufreq_policy instead of a per-cpu variable.

This patch does it. Over that there is no need to set policy->freq_table to NULL
in ->exit(), as policy structure is going to be freed soon.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c        |  1 -
 drivers/cpufreq/arm_big_little.c      |  1 -
 drivers/cpufreq/cpufreq.c             |  7 +++++-
 drivers/cpufreq/e_powersaver.c        |  1 -
 drivers/cpufreq/freq_table.c          | 46 ++++++-----------------------------
 drivers/cpufreq/ia64-acpi-cpufreq.c   |  1 -
 drivers/cpufreq/loongson2_cpufreq.c   |  1 -
 drivers/cpufreq/omap-cpufreq.c        |  1 -
 drivers/cpufreq/pasemi-cpufreq.c      |  1 -
 drivers/cpufreq/powernow-k6.c         |  1 -
 drivers/cpufreq/powernow-k7.c         |  2 --
 drivers/cpufreq/powernow-k8.c         |  2 --
 drivers/cpufreq/ppc-corenet-cpufreq.c |  1 -
 drivers/cpufreq/sh-cpufreq.c          |  1 -
 drivers/cpufreq/sparc-us2e-cpufreq.c  |  4 +--
 drivers/cpufreq/sparc-us3-cpufreq.c   |  4 +--
 drivers/cpufreq/speedstep-centrino.c  |  2 --
 drivers/cpufreq/tegra-cpufreq.c       |  1 -
 include/linux/cpufreq.h               |  6 +----
 19 files changed, 17 insertions(+), 67 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index caf41eb..e0425b3 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -872,7 +872,6 @@ static int acpi_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 	pr_debug("acpi_cpufreq_cpu_exit\n");
 
 	if (data) {
-		cpufreq_frequency_table_put_attr(policy->cpu);
 		per_cpu(acfreq_data, policy->cpu) = NULL;
 		acpi_processor_unregister_performance(data->acpi_data,
 						      policy->cpu);
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 5519933..9ef95c6 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -478,7 +478,6 @@ static int bL_cpufreq_exit(struct cpufreq_policy *policy)
 		return -ENODEV;
 	}
 
-	cpufreq_frequency_table_put_attr(policy->cpu);
 	put_cluster_clk_and_freq_table(cpu_dev);
 	dev_dbg(cpu_dev, "%s: Exited, cpu: %d\n", __func__, policy->cpu);
 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ae4923e..e7586e6 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -193,6 +193,12 @@ unsigned int cpufreq_generic_get(unsigned int cpu)
 }
 EXPORT_SYMBOL_GPL(cpufreq_generic_get);
 
+/* Only for cpufreq core internal use */
+struct cpufreq_policy *cpufreq_cpu_get_raw(unsigned int cpu)
+{
+	return per_cpu(cpufreq_cpu_data, cpu);
+}
+
 struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = NULL;
@@ -976,7 +982,6 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 
 	up_write(&policy->rwsem);
 
-	cpufreq_frequency_table_update_policy_cpu(policy);
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 			CPUFREQ_UPDATE_POLICY_CPU, policy);
 }
diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 9012b8b..a0d2a42 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -382,7 +382,6 @@ static int eps_cpu_exit(struct cpufreq_policy *policy)
 	unsigned int cpu = policy->cpu;
 
 	/* Bye */
-	cpufreq_frequency_table_put_attr(policy->cpu);
 	kfree(eps_cpu[cpu]);
 	eps_cpu[cpu] = NULL;
 	return 0;
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 0d6cc0e..9231303 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -87,8 +87,8 @@ int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_verify);
 
 /*
- * Generic routine to verify policy & frequency table, requires driver to call
- * cpufreq_frequency_table_get_attr() prior to it.
+ * Generic routine to verify policy & frequency table, requires driver to set
+ * policy->freq_table prior to it.
  */
 int cpufreq_generic_frequency_table_verify(struct cpufreq_policy *policy)
 {
@@ -201,23 +201,18 @@ int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_get_index);
 
-static DEFINE_PER_CPU(struct cpufreq_frequency_table *, cpufreq_show_table);
-
 /**
  * show_available_freqs - show available frequencies for the specified CPU
  */
 static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
 {
 	unsigned int i = 0;
-	unsigned int cpu = policy->cpu;
 	ssize_t count = 0;
-	struct cpufreq_frequency_table *table;
+	struct cpufreq_frequency_table *table = policy->freq_table;
 
-	if (!per_cpu(cpufreq_show_table, cpu))
+	if (!table)
 		return -ENODEV;
 
-	table = per_cpu(cpufreq_show_table, cpu);
-
 	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
 			continue;
@@ -243,49 +238,24 @@ struct freq_attr *cpufreq_generic_attr[] = {
 };
 EXPORT_SYMBOL_GPL(cpufreq_generic_attr);
 
-/*
- * if you use these, you must assure that the frequency table is valid
- * all the time between get_attr and put_attr!
- */
-void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
-				      unsigned int cpu)
-{
-	pr_debug("setting show_table for cpu %u to %p\n", cpu, table);
-	per_cpu(cpufreq_show_table, cpu) = table;
-}
-EXPORT_SYMBOL_GPL(cpufreq_frequency_table_get_attr);
-
-void cpufreq_frequency_table_put_attr(unsigned int cpu)
-{
-	pr_debug("clearing show_table for cpu %u\n", cpu);
-	per_cpu(cpufreq_show_table, cpu) = NULL;
-}
-EXPORT_SYMBOL_GPL(cpufreq_frequency_table_put_attr);
-
 int cpufreq_table_validate_and_show(struct cpufreq_policy *policy,
 				      struct cpufreq_frequency_table *table)
 {
 	int ret = cpufreq_frequency_table_cpuinfo(policy, table);
 
 	if (!ret)
-		cpufreq_frequency_table_get_attr(table, policy->cpu);
+		policy->freq_table = table;
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cpufreq_table_validate_and_show);
 
-void cpufreq_frequency_table_update_policy_cpu(struct cpufreq_policy *policy)
-{
-	pr_debug("Updating show_table for new_cpu %u from last_cpu %u\n",
-			policy->cpu, policy->last_cpu);
-	per_cpu(cpufreq_show_table, policy->cpu) = per_cpu(cpufreq_show_table,
-			policy->last_cpu);
-	per_cpu(cpufreq_show_table, policy->last_cpu) = NULL;
-}
+struct cpufreq_policy *cpufreq_cpu_get_raw(unsigned int cpu);
 
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu)
 {
-	return per_cpu(cpufreq_show_table, cpu);
+	struct cpufreq_policy *policy = cpufreq_cpu_get_raw(cpu);
+	return policy ? policy->freq_table : NULL;
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_get_table);
 
diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index 53c6ac6..a22b5d1 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -332,7 +332,6 @@ acpi_cpufreq_cpu_exit (
 	pr_debug("acpi_cpufreq_cpu_exit\n");
 
 	if (data) {
-		cpufreq_frequency_table_put_attr(policy->cpu);
 		acpi_io_data[policy->cpu] = NULL;
 		acpi_processor_unregister_performance(&data->acpi_data,
 		                                      policy->cpu);
diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index b6581ab..a3588d61 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -104,7 +104,6 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 static int loongson2_cpufreq_exit(struct cpufreq_policy *policy)
 {
-	cpufreq_frequency_table_put_attr(policy->cpu);
 	clk_put(policy->clk);
 	return 0;
 }
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index adc60ec..7c577e3 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -143,7 +143,6 @@ fail:
 
 static int omap_cpu_exit(struct cpufreq_policy *policy)
 {
-	cpufreq_frequency_table_put_attr(policy->cpu);
 	freq_table_free();
 	clk_put(policy->clk);
 	return 0;
diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index 0426008..6a2b7d3 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -234,7 +234,6 @@ static int pas_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 	if (sdcpwr_mapbase)
 		iounmap(sdcpwr_mapbase);
 
-	cpufreq_frequency_table_put_attr(policy->cpu);
 	return 0;
 }
 
diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 643e795..5a36e53 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -138,7 +138,6 @@ static int powernow_k6_cpu_exit(struct cpufreq_policy *policy)
 		if (i == max_multiplier)
 			powernow_k6_target(policy, i);
 	}
-	cpufreq_frequency_table_put_attr(policy->cpu);
 	return 0;
 }
 
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 946708a..0e68e02 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -664,8 +664,6 @@ static int powernow_cpu_init(struct cpufreq_policy *policy)
 
 static int powernow_cpu_exit(struct cpufreq_policy *policy)
 {
-	cpufreq_frequency_table_put_attr(policy->cpu);
-
 #ifdef CONFIG_X86_POWERNOW_K7_ACPI
 	if (acpi_processor_perf) {
 		acpi_processor_unregister_performance(acpi_processor_perf, 0);
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index e10b646..eccea0e 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1161,8 +1161,6 @@ static int powernowk8_cpu_exit(struct cpufreq_policy *pol)
 
 	powernow_k8_cpu_exit_acpi(data);
 
-	cpufreq_frequency_table_put_attr(pol->cpu);
-
 	kfree(data->powernow_table);
 	kfree(data);
 	per_cpu(powernow_data, pol->cpu) = NULL;
diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index 051000f..037949d 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -228,7 +228,6 @@ static int __exit corenet_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 	struct cpu_data *data = per_cpu(cpu_data, policy->cpu);
 	unsigned int cpu;
 
-	cpufreq_frequency_table_put_attr(policy->cpu);
 	of_node_put(data->parent);
 	kfree(data->table);
 	kfree(data);
diff --git a/drivers/cpufreq/sh-cpufreq.c b/drivers/cpufreq/sh-cpufreq.c
index 387af12..696170e 100644
--- a/drivers/cpufreq/sh-cpufreq.c
+++ b/drivers/cpufreq/sh-cpufreq.c
@@ -143,7 +143,6 @@ static int sh_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 	unsigned int cpu = policy->cpu;
 	struct clk *cpuclk = &per_cpu(sh_cpuclk, cpu);
 
-	cpufreq_frequency_table_put_attr(cpu);
 	clk_put(cpuclk);
 
 	return 0;
diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 62aa23e..b73feeb 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -301,10 +301,8 @@ static int __init us2e_freq_cpu_init(struct cpufreq_policy *policy)
 
 static int us2e_freq_cpu_exit(struct cpufreq_policy *policy)
 {
-	if (cpufreq_us2e_driver) {
-		cpufreq_frequency_table_put_attr(policy->cpu);
+	if (cpufreq_us2e_driver)
 		us2e_freq_target(policy, 0);
-	}
 
 	return 0;
 }
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index 724ffbd..9bb42ba 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -156,10 +156,8 @@ static int __init us3_freq_cpu_init(struct cpufreq_policy *policy)
 
 static int us3_freq_cpu_exit(struct cpufreq_policy *policy)
 {
-	if (cpufreq_us3_driver) {
-		cpufreq_frequency_table_put_attr(policy->cpu);
+	if (cpufreq_us3_driver)
 		us3_freq_target(policy, 0);
-	}
 
 	return 0;
 }
diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index 4e1daca..6723f03 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -406,8 +406,6 @@ static int centrino_cpu_exit(struct cpufreq_policy *policy)
 	if (!per_cpu(centrino_model, cpu))
 		return -ENODEV;
 
-	cpufreq_frequency_table_put_attr(cpu);
-
 	per_cpu(centrino_model, cpu) = NULL;
 
 	return 0;
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 9e4f0a2b..672b0b7 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -136,7 +136,6 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 
 static int tegra_cpu_exit(struct cpufreq_policy *policy)
 {
-	cpufreq_frequency_table_put_attr(policy->cpu);
 	clk_disable_unprepare(cpu_clk);
 	clk_disable_unprepare(emc_clk);
 	return 0;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ce6f06f..a98b4d4 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -85,6 +85,7 @@ struct cpufreq_policy {
 					 * called, but you're in IRQ context */
 
 	struct cpufreq_real_policy	user_policy;
+	struct cpufreq_frequency_table	*freq_table;
 
 	struct list_head        policy_list;
 	struct kobject		kobj;
@@ -457,7 +458,6 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 int cpufreq_frequency_table_get_index(struct cpufreq_policy *policy,
 		unsigned int freq);
 
-void cpufreq_frequency_table_update_policy_cpu(struct cpufreq_policy *policy);
 ssize_t cpufreq_show_cpus(const struct cpumask *mask, char *buf);
 
 /* the following funtion is for cpufreq core use only */
@@ -466,9 +466,6 @@ struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
 /* the following are really really optional */
 extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
 extern struct freq_attr *cpufreq_generic_attr[];
-void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
-				      unsigned int cpu);
-void cpufreq_frequency_table_put_attr(unsigned int cpu);
 int cpufreq_table_validate_and_show(struct cpufreq_policy *policy,
 				      struct cpufreq_frequency_table *table);
 
@@ -478,7 +475,6 @@ int cpufreq_generic_init(struct cpufreq_policy *policy,
 		unsigned int transition_latency);
 static inline int cpufreq_generic_exit(struct cpufreq_policy *policy)
 {
-	cpufreq_frequency_table_put_attr(policy->cpu);
 	return 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

