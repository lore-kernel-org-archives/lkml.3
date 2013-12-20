Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3LTP4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:56:13 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34031 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab3LTP4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:56:10 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH Resend] cpufreq: remove sysfs files for CPU which failed to come back after resume
Date: Fri, 20 Dec 2013 21:26:02 +0530
Message-Id: <610b63b7594e5cd364c498f60e69b9e174db9257.1387554926.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases where cpufreq_add_dev() may fail for some CPUs during resume.
With the current code we will still have sysfs cpufreq files for such CPUs, and
struct cpufreq_policy would be already freed for them. Hence any operation on
those sysfs files would result in kernel warnings.

To fix this, lets remove those sysfs files or put the associated kobject in case
of such errors. Also, to make it simple lets remove the sysfs links from all the
CPUs (except policy->cpu) during suspend as that operation wouldn't result with a
loss of sysfs file permissions. And so we will create those links during resume
as well.

Reported-and-tested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 63 +++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 02d534d..fab042e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -845,8 +845,7 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
-				  unsigned int cpu, struct device *dev,
-				  bool frozen)
+				  unsigned int cpu, struct device *dev)
 {
 	int ret = 0;
 	unsigned long flags;
@@ -877,11 +876,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 		}
 	}
 
-	/* Don't touch sysfs links during light-weight init */
-	if (!frozen)
-		ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
-
-	return ret;
+	return sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
 }
 #endif
 
@@ -926,6 +921,27 @@ err_free_policy:
 	return NULL;
 }
 
+static void cpufreq_policy_put_kobj(struct cpufreq_policy *policy)
+{
+	struct kobject *kobj;
+	struct completion *cmp;
+
+	down_read(&policy->rwsem);
+	kobj = &policy->kobj;
+	cmp = &policy->kobj_unregister;
+	up_read(&policy->rwsem);
+	kobject_put(kobj);
+
+	/*
+	 * We need to make sure that the underlying kobj is
+	 * actually not referenced anymore by anybody before we
+	 * proceed with unloading.
+	 */
+	pr_debug("waiting for dropping of refcount\n");
+	wait_for_completion(cmp);
+	pr_debug("wait complete\n");
+}
+
 static void cpufreq_policy_free(struct cpufreq_policy *policy)
 {
 	free_cpumask_var(policy->related_cpus);
@@ -986,7 +1002,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	list_for_each_entry(tpolicy, &cpufreq_policy_list, policy_list) {
 		if (cpumask_test_cpu(cpu, tpolicy->related_cpus)) {
 			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-			ret = cpufreq_add_policy_cpu(tpolicy, cpu, dev, frozen);
+			ret = cpufreq_add_policy_cpu(tpolicy, cpu, dev);
 			up_read(&cpufreq_rwsem);
 			return ret;
 		}
@@ -1096,7 +1112,10 @@ err_get_freq:
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 err_set_policy_cpu:
+	if (frozen)
+		cpufreq_policy_put_kobj(policy);
 	cpufreq_policy_free(policy);
+
 nomem_out:
 	up_read(&cpufreq_rwsem);
 
@@ -1118,7 +1137,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 }
 
 static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
-					   unsigned int old_cpu, bool frozen)
+					   unsigned int old_cpu)
 {
 	struct device *cpu_dev;
 	int ret;
@@ -1126,10 +1145,6 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 	/* first sibling now owns the new sysfs dir */
 	cpu_dev = get_cpu_device(cpumask_any_but(policy->cpus, old_cpu));
 
-	/* Don't touch sysfs files during light-weight tear-down */
-	if (frozen)
-		return cpu_dev->id;
-
 	sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
 	ret = kobject_move(&policy->kobj, &cpu_dev->kobj);
 	if (ret) {
@@ -1196,7 +1211,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		if (!frozen)
 			sysfs_remove_link(&dev->kobj, "cpufreq");
 	} else if (cpus > 1) {
-		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);
+		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu);
 		if (new_cpu >= 0) {
 			update_policy_cpu(policy, new_cpu);
 
@@ -1218,8 +1233,6 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 	int ret;
 	unsigned long flags;
 	struct cpufreq_policy *policy;
-	struct kobject *kobj;
-	struct completion *cmp;
 
 	read_lock_irqsave(&cpufreq_driver_lock, flags);
 	policy = per_cpu(cpufreq_cpu_data, cpu);
@@ -1249,22 +1262,8 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 			}
 		}
 
-		if (!frozen) {
-			down_read(&policy->rwsem);
-			kobj = &policy->kobj;
-			cmp = &policy->kobj_unregister;
-			up_read(&policy->rwsem);
-			kobject_put(kobj);
-
-			/*
-			 * We need to make sure that the underlying kobj is
-			 * actually not referenced anymore by anybody before we
-			 * proceed with unloading.
-			 */
-			pr_debug("waiting for dropping of refcount\n");
-			wait_for_completion(cmp);
-			pr_debug("wait complete\n");
-		}
+		if (!frozen)
+			cpufreq_policy_put_kobj(policy);
 
 		/*
 		 * Perform the ->exit() even during light-weight tear-down,
-- 
1.7.12.rc2.18.g61b472e

