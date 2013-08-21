Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3HUOmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:42:50 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41117 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3HUOms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:42:48 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 01/14] cpufreq: create cpufreq_generic_init() routine
Date: Wed, 21 Aug 2013 20:12:20 +0530
Message-Id: <b8c04a2952e9df555443773b63fa8793968d38a2.1377093938.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many CPUFreq drivers for SMP system (where all cores share same clock lines), do
similar stuff in their ->init() part.

This patch creates a generic routine in cpufreq core which can be used by these
so that we can remove some redundant code.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 31 +++++++++++++++++++++++++++++++
 include/linux/cpufreq.h   |  3 +++
 2 files changed, 34 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 556a8c5..5fc9c6b 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -188,6 +188,37 @@ u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy)
 }
 EXPORT_SYMBOL_GPL(get_cpu_idle_time);
 
+/*
+ * This is a generic cpufreq init() routine which can be used by cpufreq
+ * drivers of SMP systems. It will do following:
+ * - validate & show freq table passed
+ * - set policies transition latency
+ * - policy->cpus with all possible CPUs
+ */
+int cpufreq_generic_init(struct cpufreq_policy *policy,
+		struct cpufreq_frequency_table *table,
+		unsigned int transition_latency)
+{
+	int ret;
+
+	ret = cpufreq_table_validate_and_show(policy, table);
+	if (ret) {
+		pr_err("%s: invalid frequency table: %d\n", __func__, ret);
+		return ret;
+	}
+
+	policy->cpuinfo.transition_latency = transition_latency;
+
+	/*
+	 * The driver only supports the SMP configuartion where all processors
+	 * share the clock and voltage and clock.
+	 */
+	cpumask_setall(policy->cpus);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cpufreq_generic_init);
+
 struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = NULL;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index b4ad9b5..6adea26 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -424,6 +424,9 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu);
 int cpufreq_table_validate_and_show(struct cpufreq_policy *policy,
 				      struct cpufreq_frequency_table *table);
 
+int cpufreq_generic_init(struct cpufreq_policy *policy,
+		struct cpufreq_frequency_table *table,
+		unsigned int transition_latency);
 static inline int cpufreq_generic_exit(struct cpufreq_policy *policy)
 {
 	cpufreq_frequency_table_put_attr(policy->cpu);
-- 
1.7.12.rc2.18.g61b472e

