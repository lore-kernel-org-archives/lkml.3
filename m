Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaBQJZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:25:36 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:33764 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaBQJZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:25:30 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, jinchoi@broadcom.com,
        tianyu.lan@intel.com, sebastian.capella@linaro.org,
        jhbird.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V6 1/7] cpufreq: suspend governors on system suspend/hibernate
Date: Mon, 17 Feb 2014 14:55:07 +0530
Message-Id: <25e47f456d94292786a5fec6d5e646e630ecfa94.1392629003.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1392629003.git.viresh.kumar@linaro.org>
References: <cover.1392629003.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1392629003.git.viresh.kumar@linaro.org>
References: <cover.1392629003.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds cpufreq suspend/resume calls to dpm_{suspend|resume}_noirq() for
handling suspend/resume of cpufreq governors.

Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found an issue where tunables
configuration for clusters/sockets with non-boot CPUs was getting lost after
suspend/resume, as we were notifying governors with CPUFREQ_GOV_POLICY_EXIT on
removal of the last cpu for that policy and so deallocating memory for tunables.
This is fixed by this patch as we don't allow any operation on governors after
device suspend and before device resume now.

Reported-and-tested-by: Lan Tianyu <tianyu.lan@intel.com>
Reported-by: Jinhyuk Choi <jinchoi@broadcom.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/base/power/main.c |  3 +++
 drivers/cpufreq/cpufreq.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h   |  8 ++++++
 3 files changed, 74 insertions(+)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index deb4e02..da49882 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -29,6 +29,7 @@
 #include <linux/async.h>
 #include <linux/suspend.h>
 #include <trace/events/power.h>
+#include <linux/cpufreq.h>
 #include <linux/cpuidle.h>
 #include <linux/timer.h>
 
@@ -581,6 +582,7 @@ static void dpm_resume_noirq(pm_message_t state)
 	dpm_show_time(starttime, state, "noirq");
 	resume_device_irqs();
 	cpuidle_resume();
+	cpufreq_resume();
 }
 
 /**
@@ -1061,6 +1063,7 @@ static int dpm_suspend_noirq(pm_message_t state)
 	ktime_t starttime = ktime_get();
 	int error = 0;
 
+	cpufreq_suspend();
 	cpuidle_pause();
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index cb003a6..4ca2297 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 #include <linux/tick.h>
 #include <trace/events/power.h>
@@ -47,6 +48,9 @@ static LIST_HEAD(cpufreq_policy_list);
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 
+/* Flag to suspend/resume CPUFreq governors */
+static bool cpufreq_suspended;
+
 static inline bool has_target(void)
 {
 	return cpufreq_driver->target_index || cpufreq_driver->target;
@@ -1576,6 +1580,61 @@ static struct subsys_interface cpufreq_interface = {
 };
 
 /**
+ * cpufreq_suspend() - Suspend CPUFreq governors
+ *
+ * Called during system wide Suspend/Hibernate cycles for suspending governors
+ * as some platforms can't change frequency after this point in suspend cycle.
+ * Because some of the devices (like: i2c, regulators, etc) they use for
+ * changing frequency are suspended quickly after this point.
+ */
+void cpufreq_suspend(void)
+{
+	struct cpufreq_policy *policy;
+
+	if (!cpufreq_driver)
+		return;
+
+	if (!has_target())
+		return;
+
+	pr_debug("%s: Suspending Governors\n", __func__);
+
+	list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
+		if (__cpufreq_governor(policy, CPUFREQ_GOV_STOP))
+			pr_err("%s: Failed to stop governor for policy: %p\n",
+				__func__, policy);
+
+	cpufreq_suspended = true;
+}
+
+/**
+ * cpufreq_resume() - Resume CPUFreq governors
+ *
+ * Called during system wide Suspend/Hibernate cycle for resuming governors that
+ * are suspended with cpufreq_suspend().
+ */
+void cpufreq_resume(void)
+{
+	struct cpufreq_policy *policy;
+
+	if (!cpufreq_driver)
+		return;
+
+	if (!has_target())
+		return;
+
+	pr_debug("%s: Resuming Governors\n", __func__);
+
+	cpufreq_suspended = false;
+
+	list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
+		if (__cpufreq_governor(policy, CPUFREQ_GOV_START)
+		    || __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))
+			pr_err("%s: Failed to start governor for policy: %p\n",
+				__func__, policy);
+}
+
+/**
  * cpufreq_bp_suspend - Prepare the boot CPU for system suspend.
  *
  * This function is only executed for the boot processor.  The other CPUs
@@ -1868,6 +1927,10 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 	struct cpufreq_governor *gov = NULL;
 #endif
 
+	/* Don't start any governor operations if we are entering suspend */
+	if (cpufreq_suspended)
+		return 0;
+
 	if (policy->governor->max_transition_latency &&
 	    policy->cpuinfo.transition_latency >
 	    policy->governor->max_transition_latency) {
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4d89e0e..94ed907 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -296,6 +296,14 @@ cpufreq_verify_within_cpu_limits(struct cpufreq_policy *policy)
 			policy->cpuinfo.max_freq);
 }
 
+#ifdef CONFIG_CPU_FREQ
+void cpufreq_suspend(void);
+void cpufreq_resume(void);
+#else
+static inline void cpufreq_suspend(void) {}
+static inline void cpufreq_resume(void) {}
+#endif
+
 /*********************************************************************
  *                     CPUFREQ NOTIFIER INTERFACE                    *
  *********************************************************************/
-- 
1.7.12.rc2.18.g61b472e

