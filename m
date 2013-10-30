Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3J3W5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:57:31 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:45095 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab3J3WwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:52:19 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, viresh.kumar@linaro.org
Subject: [PATCH V2 Resend 01/16] cpufreq: create cpufreq_generic_get() routine
Date: Thu, 31 Oct 2013 04:21:59 +0530
Message-Id: <1a672a5e0b0f6fa4e03646b5f124f68e13f079f2.1383173230.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1383173230.git.viresh.kumar@linaro.org>
References: <cover.1383173230.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1383173230.git.viresh.kumar@linaro.org>
References: <cover.1383173230.git.viresh.kumar@linaro.org>
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
index 02d534d..eb42edb 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -176,6 +176,20 @@ int cpufreq_generic_init(struct cpufreq_policy *policy,
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
@@ -1030,6 +1044,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
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
@@ -1062,11 +1081,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
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
@@ -1087,12 +1101,12 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
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
index 5bd6ab9..122d4cd 100644
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
@@ -447,6 +449,7 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu);
 int cpufreq_table_validate_and_show(struct cpufreq_policy *policy,
 				      struct cpufreq_frequency_table *table);
 
+unsigned int cpufreq_generic_get(unsigned int cpu);
 int cpufreq_generic_init(struct cpufreq_policy *policy,
 		struct cpufreq_frequency_table *table,
 		unsigned int transition_latency);
-- 
1.7.12.rc2.18.g61b472e

