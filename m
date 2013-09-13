Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab3IMNSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:18:08 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:57412 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933479Ab3IMNSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:18:03 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 127/228] cpufreq: create cpufreq_generic_init() routine
Date: Fri, 13 Sep 2013 18:31:13 +0530
Message-Id: <ed142d4ec15206f4249e2cd851dbe8da7bfc06d4.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many CPUFreq drivers for SMP system (where all cores share same clock lines), do
similar stuff in their ->init() part.

This patch creates a generic routine in cpufreq core which can be used by these
so that we can remove some redundant code.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/Kconfig   |  1 +
 drivers/cpufreq/cpufreq.c | 31 +++++++++++++++++++++++++++++++
 include/linux/cpufreq.h   |  3 +++
 3 files changed, 35 insertions(+)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 534fcb8..2d06754 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -2,6 +2,7 @@ menu "CPU Frequency scaling"
 
 config CPU_FREQ
 	bool "CPU Frequency scaling"
+	select CPU_FREQ_TABLE
 	help
 	  CPU Frequency scaling allows you to change the clock speed of 
 	  CPUs on the fly. This is a nice method to save power, because 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1e6b602..c4d89c5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -183,6 +183,37 @@ u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy)
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
index 57d2907..c2184c6 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -438,6 +438,9 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu);
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

