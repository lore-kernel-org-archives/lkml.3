Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbaCUFhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 01:37:52 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47041 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121AbaCUFht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 01:37:49 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 1/3] cpufreq: Make sure frequency transitions are serialized
Date: Fri, 21 Mar 2014 11:04:30 +0530
Message-Id: <f6116069b730c0c3a74ff627fa818b98dc4f1491.1395379422.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395379422.git.viresh.kumar@linaro.org>
References: <cover.1395379422.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395379422.git.viresh.kumar@linaro.org>
References: <cover.1395379422.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

Whenever we change the frequency of a CPU, we call the PRECHANGE and POSTCHANGE
notifiers. They must be serialized, i.e. PRECHANGE and POSTCHANGE notifiers
should strictly alternate, thereby preventing two different sets of PRECHANGE or
POSTCHANGE notifiers from interleaving arbitrarily.

The following examples illustrate why this is important:

Scenario 1:
-----------
A thread reading the value of cpuinfo_cur_freq, will call
__cpufreq_cpu_get()->cpufreq_out_of_sync()->cpufreq_notify_transition()

The ondemand governor can decide to change the frequency of the CPU at the same
time and hence it can end up sending the notifications via ->target().

If the notifiers are not serialized, the following sequence can occur:
- PRECHANGE Notification for freq A (from cpuinfo_cur_freq)
- PRECHANGE Notification for freq B (from target())
- Freq changed by target() to B
- POSTCHANGE Notification for freq B
- POSTCHANGE Notification for freq A

We can see from the above that the last POSTCHANGE Notification happens for freq
A but the hardware is set to run at freq B.

Where would we break then?: adjust_jiffies() in cpufreq.c & cpufreq_callback()
in arch/arm/kernel/smp.c (which also adjusts the jiffies). All the
loops_per_jiffy calculations will get messed up.

Scenario 2:
-----------
The governor calls __cpufreq_driver_target() to change the frequency. At the
same time, if we change scaling_{min|max}_freq from sysfs, it will end up
calling the governor's CPUFREQ_GOV_LIMITS notification, which will also call
__cpufreq_driver_target(). And hence we end up issuing concurrent calls to
->target().

Typically, platforms have the following logic in their ->target() routines:
(Eg: cpufreq-cpu0, omap, exynos, etc)

A. If new freq is more than old: Increase voltage
B. Change freq
C. If new freq is less than old: decrease voltage

Now, if the two concurrent calls to ->target() are X and Y, where X is trying to
increase the freq and Y is trying to decrease it, we get the following race
condition:

X.A: voltage gets increased for larger freq
Y.A: nothing happens
Y.B: freq gets decreased
Y.C: voltage gets decreased
X.B: freq gets increased
X.C: nothing happens

Thus we can end up setting a freq which is not supported by the voltage we have
set. That will probably make the clock to the CPU unstable and the system might
not work properly anymore.

This patch introduces a set of synchronization primitives to serialize frequency
transitions, which are to be used as shown below:

cpufreq_freq_transition_begin();

//Perform the frequency change

cpufreq_freq_transition_end();

The _begin() call sends the PRECHANGE notification whereas the _end() call sends
the POSTCHANGE notification. Also, all the necessary synchronization is handled
within these calls. In particular, even drivers which set the ASYNC_NOTIFICATION
flag can also use these APIs for performing frequency transitions (ie., you can
call _begin() from one task, and call the corresponding _end() from a different
task).

The actual synchronization underneath is not that complicated:

The key challenge is to allow drivers to begin the transition from one thread
and end it in a completely different thread (this is to enable drivers that do
asynchronous POSTCHANGE notification from bottom-halves, to also use the same
interface).

To achieve this, a 'transition_ongoing' flag, a 'transition_lock' spinlock and a
wait-queue are added per-policy. The flag and the wait-queue are used in
conjunction to create an "uninterrupted flow" from _begin() to _end(). The
spinlock is used to ensure that only one such "flow" is in flight at any given
time. Put together, this provides us all the necessary synchronization.

Based-on-patch-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

I have kept your Authorship for this patch as is and did few modifications:
-  removed 'state' parameter from begin/end routines.
- added 'trasition_failed' parameter to end routine.
- changed mutex with spinlock as discussed earlier.
- Added WARN_ON() as discussed.
- Exported these new routines.
- Removed locks from end.

 drivers/cpufreq/cpufreq.c | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h   | 10 ++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index b349406..4279cc9 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -353,6 +353,41 @@ void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
 
+void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs)
+{
+wait:
+	wait_event(policy->transition_wait, !policy->transition_ongoing);
+
+	spin_lock(&policy->transition_lock);
+
+	if (unlikely(policy->transition_ongoing)) {
+		spin_unlock(&policy->transition_lock);
+		goto wait;
+	}
+
+	policy->transition_ongoing = true;
+
+	spin_unlock(&policy->transition_lock);
+
+	cpufreq_notify_transition(policy, freqs, CPUFREQ_PRECHANGE);
+}
+EXPORT_SYMBOL_GPL(cpufreq_freq_transition_begin);
+
+void cpufreq_freq_transition_end(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs, int transition_failed)
+{
+	if (unlikely(WARN_ON(!policy->transition_ongoing)))
+		return;
+
+	cpufreq_notify_post_transition(policy, freqs, transition_failed);
+
+	policy->transition_ongoing = false;
+
+	wake_up(&policy->transition_wait);
+}
+EXPORT_SYMBOL_GPL(cpufreq_freq_transition_end);
+
 
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
@@ -982,6 +1017,8 @@ static struct cpufreq_policy *cpufreq_policy_alloc(void)
 
 	INIT_LIST_HEAD(&policy->policy_list);
 	init_rwsem(&policy->rwsem);
+	spin_lock_init(&policy->transition_lock);
+	init_waitqueue_head(&policy->transition_wait);
 
 	return policy;
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 70929bc..263173d 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -16,6 +16,7 @@
 #include <linux/completion.h>
 #include <linux/kobject.h>
 #include <linux/notifier.h>
+#include <linux/spinlock.h>
 #include <linux/sysfs.h>
 
 /*********************************************************************
@@ -104,6 +105,11 @@ struct cpufreq_policy {
 	 *     __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
 	 */
 	struct rw_semaphore	rwsem;
+
+	/* Synchronization for frequency transitions */
+	bool			transition_ongoing; /* Tracks transition status */
+	spinlock_t		transition_lock;
+	wait_queue_head_t	transition_wait;
 };
 
 /* Only for ACPI */
@@ -336,6 +342,10 @@ void cpufreq_notify_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, unsigned int state);
 void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, int transition_failed);
+void cpufreq_freq_transition_begin(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs);
+void cpufreq_freq_transition_end(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs, int transition_failed);
 
 #else /* CONFIG_CPU_FREQ */
 static inline int cpufreq_register_notifier(struct notifier_block *nb,
-- 
1.7.12.rc2.18.g61b472e

