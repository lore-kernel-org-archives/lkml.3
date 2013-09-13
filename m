Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3IMM77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:59:59 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48908 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3IMM7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:59:55 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: Create cpufreq_transition_complete()
Date: Fri, 13 Sep 2013 18:29:38 +0530
Message-Id: <3909d90dbf22749188b27d080a52775b92da6f71.1379062834.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379062834.git.viresh.kumar@linaro.org>
References: <cover.1379062834.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379062834.git.viresh.kumar@linaro.org>
References: <cover.1379062834.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch "cpufreq: make sure frequency transitions are serialized"
guarantees that we don't have any races while changing cpu frequency or sending
notifications. It handled a special case with CPUFREQ_ASYNC_NOTIFICATION flag
for drivers that don't complete their freq change from ->target() and exynos5440
driver is well adopted to it as well..

There is one more driver powernow-k8 that has similar implementation, schedules
a work for doing transitions. All is good if that work function does
notifications on every call to it and so the transition_ongoing count stays
stable. But there are chances that the work function may return without actually
doing the notifications, in which case transition_ongoing count will not be set
to zero and so no transitions would be possible after that.

This patch adds another routine cpufreq_transition_complete() which would be
used by powernow-k8 (or even exynos5440 if required), that will be used to mark
end of transition in such cases.

Later patch will change powernow-k8 to use this routine.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 25 +++++++++++++------------
 include/linux/cpufreq.h   |  7 +++++++
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index f8b0889..cf283f3 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -265,6 +265,16 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 }
 #endif
 
+void cpufreq_transition_complete(struct cpufreq_policy *policy)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	policy->transition_ongoing--;
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+}
+EXPORT_SYMBOL_GPL(cpufreq_transition_complete);
+
 static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, unsigned int state)
 {
@@ -350,16 +360,12 @@ void cpufreq_notify_transition(struct cpufreq_policy *policy,
 
 	if ((cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION)
 			&& (state == CPUFREQ_POSTCHANGE)) {
-		unsigned long flags;
-
 		/*
 		 * Some drivers don't send POSTCHANGE notification from their
 		 * ->target() but from some kind of bottom half and so we are
 		 * ending transaction here..
 		 */
-		write_lock_irqsave(&cpufreq_driver_lock, flags);
-		policy->transition_ongoing--;
-		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		cpufreq_transition_complete(policy);
 	}
 }
 EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
@@ -1430,9 +1436,7 @@ static void cpufreq_out_of_sync(unsigned int cpu, unsigned int old_freq,
 	if (cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION)
 		return;
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	policy->transition_ongoing--;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	cpufreq_transition_complete(policy);
 }
 
 /**
@@ -1754,10 +1758,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			&& (retval == -EINPROGRESS))
 		return retval;
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	policy->transition_ongoing--;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
+	cpufreq_transition_complete(policy);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(__cpufreq_driver_target);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index c770bc0..10ab22d 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -231,6 +231,13 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
 
 const char *cpufreq_get_current_driver(void);
 
+/*
+ * Only for drivers which have CPUFREQ_ASYNC_NOTIFICATION flag set and they need
+ * to mark transaction over before starting any notifications, otherwise the
+ * POSTCHANGE notification already does this.
+ */
+void cpufreq_transition_complete(struct cpufreq_policy *policy);
+
 static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy,
 		unsigned int min, unsigned int max)
 {
-- 
1.7.12.rc2.18.g61b472e

