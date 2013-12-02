Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab3LBFyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:54:32 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:58320 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab3LBFwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:52:49 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, swarren@wwwdotorg.org,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, tianyu.lan@intel.com,
        jhbird.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 2/6] cpufreq: call driver's suspend/resume for each policy
Date: Mon,  2 Dec 2013 11:22:32 +0530
Message-Id: <7e336f59970b44b7c999671ed8df5bdf7af73761.1385962528.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1385962528.git.viresh.kumar@linaro.org>
References: <cover.1385962528.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1385962528.git.viresh.kumar@linaro.org>
References: <cover.1385962528.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier cpufreq suspend/resume callbacks into drivers were getting called only
for the boot CPU, as by the time callbacks were called non-boot CPUs were
already removed. Because we might still need driver specific actions on
suspend/resume, its better to use earlier infrastructure from the early
suspend/late resume calls.

In effect, we call suspend/resume for each policy. The resume part also takes
care of synchronising frequency for boot CPU, which might turn out be different
than what cpufreq core believes.

Hence, the earlier syscore infrastructure is getting removed now.

Tested-by: Lan Tianyu <tianyu.lan@intel.com>
Tested-by: Nishanth Menon <nm@ti.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 112 +++++++++++++---------------------------------
 1 file changed, 32 insertions(+), 80 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a7fcb84..443c053 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -27,7 +27,6 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
-#include <linux/syscore_ops.h>
 #include <linux/tick.h>
 #include <trace/events/power.h>
 
@@ -1531,6 +1530,14 @@ static struct subsys_interface cpufreq_interface = {
 	.remove_dev	= cpufreq_remove_dev,
 };
 
+/**
+ * cpufreq_suspend() - Suspend CPUFreq governors
+ *
+ * Called during system wide Suspend/Hibernate cycles for suspending governors
+ * as some platforms can't change frequency after this point in suspend cycle.
+ * Because some of the devices (like: i2c, regulators, etc) they use for
+ * changing frequency are suspended quickly after this point.
+ */
 void cpufreq_suspend(void)
 {
 	struct cpufreq_policy *policy;
@@ -1540,14 +1547,25 @@ void cpufreq_suspend(void)
 
 	pr_debug("%s: Suspending Governors\n", __func__);
 
-	list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
+	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
 		if (__cpufreq_governor(policy, CPUFREQ_GOV_STOP))
 			pr_err("%s: Failed to stop governor for policy: %p\n",
 				__func__, policy);
+		else if (cpufreq_driver->suspend
+		    && cpufreq_driver->suspend(policy))
+			pr_err("%s: Failed to suspend driver: %p\n", __func__,
+				policy);
+	}
 
 	cpufreq_suspended = true;
 }
 
+/**
+ * cpufreq_resume() - Resume CPUFreq governors
+ *
+ * Called during system wide Suspend/Hibernate cycle for resuming governors that
+ * are suspended with cpufreq_suspend().
+ */
 void cpufreq_resume(void)
 {
 	struct cpufreq_policy *policy;
@@ -1559,91 +1577,26 @@ void cpufreq_resume(void)
 
 	cpufreq_suspended = false;
 
-	list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
+	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
 		if (__cpufreq_governor(policy, CPUFREQ_GOV_START)
 		    || __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))
 			pr_err("%s: Failed to start governor for policy: %p\n",
 				__func__, policy);
-}
-
-/**
- * cpufreq_bp_suspend - Prepare the boot CPU for system suspend.
- *
- * This function is only executed for the boot processor.  The other CPUs
- * have been put offline by means of CPU hotplug.
- */
-static int cpufreq_bp_suspend(void)
-{
-	int ret = 0;
-
-	int cpu = smp_processor_id();
-	struct cpufreq_policy *policy;
-
-	pr_debug("suspending cpu %u\n", cpu);
-
-	/* If there's no policy for the boot CPU, we have nothing to do. */
-	policy = cpufreq_cpu_get(cpu);
-	if (!policy)
-		return 0;
-
-	if (cpufreq_driver->suspend) {
-		ret = cpufreq_driver->suspend(policy);
-		if (ret)
-			printk(KERN_ERR "cpufreq: suspend failed in ->suspend "
-					"step on CPU %u\n", policy->cpu);
-	}
-
-	cpufreq_cpu_put(policy);
-	return ret;
-}
-
-/**
- * cpufreq_bp_resume - Restore proper frequency handling of the boot CPU.
- *
- *	1.) resume CPUfreq hardware support (cpufreq_driver->resume())
- *	2.) schedule call cpufreq_update_policy() ASAP as interrupts are
- *	    restored. It will verify that the current freq is in sync with
- *	    what we believe it to be. This is a bit later than when it
- *	    should be, but nonethteless it's better than calling
- *	    cpufreq_driver->get() here which might re-enable interrupts...
- *
- * This function is only executed for the boot CPU.  The other CPUs have not
- * been turned on yet.
- */
-static void cpufreq_bp_resume(void)
-{
-	int ret = 0;
-
-	int cpu = smp_processor_id();
-	struct cpufreq_policy *policy;
-
-	pr_debug("resuming cpu %u\n", cpu);
-
-	/* If there's no policy for the boot CPU, we have nothing to do. */
-	policy = cpufreq_cpu_get(cpu);
-	if (!policy)
-		return;
+		else if (cpufreq_driver->resume
+		    && cpufreq_driver->resume(policy))
+			pr_err("%s: Failed to resume driver: %p\n", __func__,
+				policy);
 
-	if (cpufreq_driver->resume) {
-		ret = cpufreq_driver->resume(policy);
-		if (ret) {
-			printk(KERN_ERR "cpufreq: resume failed in ->resume "
-					"step on CPU %u\n", policy->cpu);
-			goto fail;
-		}
+		/*
+		 * schedule call cpufreq_update_policy() for boot CPU, i.e. last
+		 * policy in list. It will verify that the current freq is in
+		 * sync with what we believe it to be.
+		 */
+		if (list_is_last(&policy->policy_list, &cpufreq_policy_list))
+			schedule_work(&policy->update);
 	}
-
-	schedule_work(&policy->update);
-
-fail:
-	cpufreq_cpu_put(policy);
 }
 
-static struct syscore_ops cpufreq_syscore_ops = {
-	.suspend	= cpufreq_bp_suspend,
-	.resume		= cpufreq_bp_resume,
-};
-
 /**
  *	cpufreq_get_current_driver - return current driver's name
  *
@@ -2320,7 +2273,6 @@ static int __init cpufreq_core_init(void)
 
 	cpufreq_global_kobject = kobject_create();
 	BUG_ON(!cpufreq_global_kobject);
-	register_syscore_ops(&cpufreq_syscore_ops);
 
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

