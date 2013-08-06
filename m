Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab3HFRZC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:25:02 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:52822 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab3HFRY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:24:58 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 11/11] cpufreq: improve error checking on return values of __cpufreq_governor()
Date: Tue,  6 Aug 2013 22:53:13 +0530
Message-Id: <16cf42ac264fc8d0e7604807b01ae796ad6a77c0.1375809311.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpufreq_governor() function can fail in rare cases specially if there are bugs
in cpufreq driver. And so we must stop processing as soon as this routine fails,
otherwise it may result in undefined behavior.

And so this patch adds error checking code whenever this routine is called from
any place.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 48 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ccaf025..06f8671 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -874,8 +874,13 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 	int ret = 0, has_target = !!cpufreq_driver->target;
 	unsigned long flags;
 
-	if (has_target)
-		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
+	if (has_target) {
+		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
+		if (ret) {
+			pr_err("%s: Failed to stop governor\n", __func__);
+			return ret;
+		}
+	}
 
 	lock_policy_rwsem_write(policy->cpu);
 
@@ -889,8 +894,11 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 	unlock_policy_rwsem_write(policy->cpu);
 
 	if (has_target) {
-		__cpufreq_governor(policy, CPUFREQ_GOV_START);
-		__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
+		if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
+			(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
+			pr_err("%s: Failed to start governor\n", __func__);
+			return ret;
+		}
 	}
 
 	/* Don't touch sysfs links during light-weight init */
@@ -1171,7 +1179,7 @@ static int __cpufreq_remove_dev(struct device *dev,
 				struct subsys_interface *sif, bool frozen)
 {
 	unsigned int cpu = dev->id, cpus;
-	int new_cpu;
+	int new_cpu, ret;
 	unsigned long flags;
 	struct cpufreq_policy *policy;
 	struct kobject *kobj;
@@ -1195,8 +1203,13 @@ static int __cpufreq_remove_dev(struct device *dev,
 		return -EINVAL;
 	}
 
-	if (cpufreq_driver->target)
-		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
+	if (cpufreq_driver->target) {
+		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
+		if (ret) {
+			pr_err("%s: Failed to stop governor\n", __func__);
+			return ret;
+		}
+	}
 
 #ifdef CONFIG_HOTPLUG_CPU
 	if (!cpufreq_driver->setpolicy)
@@ -1230,8 +1243,15 @@ static int __cpufreq_remove_dev(struct device *dev,
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-		if (cpufreq_driver->target)
-			__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
+		if (cpufreq_driver->target) {
+			ret = __cpufreq_governor(policy,
+					CPUFREQ_GOV_POLICY_EXIT);
+			if (ret) {
+				pr_err("%s: Failed to exit governor\n",
+						__func__);
+				return ret;
+			}
+	}
 
 		if (!frozen) {
 			lock_policy_rwsem_read(cpu);
@@ -1262,8 +1282,12 @@ static int __cpufreq_remove_dev(struct device *dev,
 			cpufreq_policy_free(policy);
 	} else {
 		if (cpufreq_driver->target) {
-			__cpufreq_governor(policy, CPUFREQ_GOV_START);
-			__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
+			if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
+					(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
+				pr_err("%s: Failed to start governor\n",
+						__func__);
+				return ret;
+			}
 		}
 	}
 
@@ -1911,7 +1935,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *policy,
 			/* might be a policy change, too, so fall through */
 		}
 		pr_debug("governor: change or update limits\n");
-		__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
+		ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
 	}
 
 error_out:
-- 
1.7.12.rc2.18.g61b472e

