Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab3IMN22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:28:28 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57637 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab3IMN2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:28:24 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 213/228] cpufreq: create cpufreq_generic_get() routine
Date: Fri, 13 Sep 2013 18:32:39 +0530
Message-Id: <4ed298916d96d41c4a9e221ac71aa1dfc74dbffe.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFreq drivers that use clock frameworks interface,i.e. clk_get_rate(), to get
CPUs clk rate, has similar sort of code used for most of them.

This patch adds a generic ->get() which will do the same thing for them. All
those drivers are required to now is to set .get to cpufreq_generic_get() and
set their clk pointer in policy->clk during ->init().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 26 ++++++++++++++++++++------
 include/linux/cpufreq.h   |  3 +++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 79f89c3..2c1ae708 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -219,6 +219,20 @@ int cpufreq_generic_init(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_generic_init);
 
+unsigned int cpufreq_generic_get(unsigned int cpu)
+{
+	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
+
+	if (!policy || IS_ERR(policy->clk)) {
+		pr_err("%s: No %s associated to cpu: %d\n", __func__,
+				policy ? "clk" : "policy", cpu);
+		return 0;
+	}
+
+	return clk_get_rate(policy->clk) / 1000;
+}
+EXPORT_SYMBOL_GPL(cpufreq_generic_get);
+
 struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = NULL;
@@ -1115,6 +1129,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		goto err_set_policy_cpu;
 	}
 
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	for_each_cpu(j, policy->cpus)
+		per_cpu(cpufreq_cpu_data, j) = policy;
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 	if (cpufreq_driver->get) {
 		policy->cur = cpufreq_driver->get(policy->cpu);
 		if (!policy->cur) {
@@ -1147,11 +1166,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	}
 #endif
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus)
-		per_cpu(cpufreq_cpu_data, j) = policy;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
 	if (!frozen) {
 		ret = cpufreq_add_dev_interface(policy, dev);
 		if (ret)
@@ -1172,12 +1186,12 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	return 0;
 
 err_out_unregister:
+err_get_freq:
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-err_get_freq:
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 err_set_policy_cpu:
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index f13beec..d396fba 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -11,6 +11,7 @@
 #ifndef _LINUX_CPUFREQ_H
 #define _LINUX_CPUFREQ_H
 
+#include <linux/clk.h>
 #include <linux/cpumask.h>
 #include <linux/completion.h>
 #include <linux/kobject.h>
@@ -66,6 +67,7 @@ struct cpufreq_policy {
 	unsigned int		cpu;    /* cpu nr of CPU managing this policy */
 	unsigned int		last_cpu; /* cpu nr of previous CPU that managed
 					   * this policy */
+	struct clk		*clk;
 	struct cpufreq_cpuinfo	cpuinfo;/* see above */
 
 	unsigned int		min;    /* in kHz */
@@ -440,6 +442,7 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu);
 int cpufreq_table_validate_and_show(struct cpufreq_policy *policy,
 				      struct cpufreq_frequency_table *table);
 
+unsigned int cpufreq_generic_get(unsigned int cpu);
 int cpufreq_generic_init(struct cpufreq_policy *policy,
 		struct cpufreq_frequency_table *table,
 		unsigned int transition_latency);
-- 
1.7.12.rc2.18.g61b472e

