Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaCNHoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 03:44:21 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:49649 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbaCNHoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 03:44:19 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC V2] cpufreq: make sure frequency transitions are serialized
Date: Fri, 14 Mar 2014 13:13:44 +0530
Message-Id: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever we are changing frequency of a cpu, we are calling PRECHANGE and
POSTCHANGE notifiers. They must be serialized. i.e. PRECHANGE or POSTCHANGE
shouldn't be called twice continuously. Following examples show why this is
important:

Scenario 1:
-----------
One thread reading value of cpuinfo_cur_freq, which will call
__cpufreq_cpu_get()->cpufreq_out_of_sync()->cpufreq_notify_transition()..

And ondemand governor trying to change freq of cpu at the same time and so
sending notification via ->target()..

Notifiers are not serialized and suppose this is what happened
- PRECHANGE Notification for freq A (from cpuinfo_cur_freq)
- PRECHANGE Notification for freq B (from target())
- Freq changed by target() to B
- POSTCHANGE Notification for freq B
- POSTCHANGE Notification for freq A

Now the last POSTCHANGE Notification happened for freq A and hardware is
currently running at freq B :)

Where would we break then?: adjust_jiffies() in cpufreq.c and cpufreq_callback()
in arch/arm/kernel/smp.c (which is also adjusting jiffies).. All loops_per_jiffy
based stuff is broken..

Scenario 2:
-----------
Governor is changing freq and has called __cpufreq_driver_target(). At the same
time we are changing scaling_{min|max}_freq from sysfs, which would eventually
end up calling governor's: CPUFREQ_GOV_LIMITS notification, that will also call:
__cpufreq_driver_target().. And hence concurrent calls to ->target()

And Platform have something like this in their ->target() (Like: cpufreq-cpu0,
omap, exynos, etc)

A. If new freq is more than old: Increase voltage
B. Change freq
C. If new freq is less than old: decrease voltage

Now, two concurrent calls to target are X and Y, where X is trying to increase
freq and Y is trying to decrease it..

And this is the sequence that followed due to races..

X.A: voltage increased for larger freq
Y.A: nothing happened here
Y.B: freq decreased
Y.C: voltage decreased
X.B: freq increased
X.C: nothing happened..

We ended up setting a freq which is not supported by the voltage we have set..
That will probably make clock to CPU unstable and system might not be workable
anymore...

This patch adds protection in cpufreq_notify_transition() to make transitions
serialized. It runs WARN() if POSTCHANGE notification is sent when we are not in
middle of a transition. And PRECHANGE notification is forced to wait while the
current transition is in progress.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

This was discussed earlier here:
https://lkml.org/lkml/2013/9/25/402

Where Rafael asked for better fix, as he called the V1 fixes: "quick and dirty".
This is another approach, much simpler than previous one. Please see if this
looks fine. There is a TODO note in there as I wanted some suggestions on how
exactly should we wait for a transition to get over.

 drivers/cpufreq/cpufreq.c | 39 +++++++++++++++++++++++++++++++++++++--
 include/linux/cpufreq.h   |  2 ++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2677ff1..66bdfff 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -324,6 +324,13 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 	}
 }
 
+static void notify_transition_for_each_cpu(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs, unsigned int state)
+{
+	for_each_cpu(freqs->cpu, policy->cpus)
+		__cpufreq_notify_transition(policy, freqs, state);
+}
+
 /**
  * cpufreq_notify_transition - call notifier chain and adjust_jiffies
  * on frequency transition.
@@ -335,8 +342,35 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 void cpufreq_notify_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, unsigned int state)
 {
-	for_each_cpu(freqs->cpu, policy->cpus)
-		__cpufreq_notify_transition(policy, freqs, state);
+	if ((state != CPUFREQ_PRECHANGE) && (state != CPUFREQ_POSTCHANGE))
+		return notify_transition_for_each_cpu(policy, freqs, state);
+
+	/* Serialize pre-post notifications */
+	mutex_lock(&policy->transition_lock);
+	if (unlikely(WARN_ON(!policy->transition_ongoing &&
+				(state == CPUFREQ_POSTCHANGE)))) {
+		mutex_unlock(&policy->transition_lock);
+		return;
+	}
+
+	if (state == CPUFREQ_PRECHANGE) {
+		while (policy->transition_ongoing) {
+			mutex_unlock(&policy->transition_lock);
+			/* TODO: Can we do something better here? */
+			cpu_relax();
+			mutex_lock(&policy->transition_lock);
+		}
+
+		policy->transition_ongoing = true;
+		mutex_unlock(&policy->transition_lock);
+	}
+
+	notify_transition_for_each_cpu(policy, freqs, state);
+
+	if (state == CPUFREQ_POSTCHANGE) {
+		policy->transition_ongoing = false;
+		mutex_unlock(&policy->transition_lock);
+	}
 }
 EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
 
@@ -983,6 +1017,7 @@ static struct cpufreq_policy *cpufreq_policy_alloc(void)
 
 	INIT_LIST_HEAD(&policy->policy_list);
 	init_rwsem(&policy->rwsem);
+	mutex_init(&policy->transition_lock);
 
 	return policy;
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 31c431e..e5cebce 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -104,6 +104,8 @@ struct cpufreq_policy {
 	 *     __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
 	 */
 	struct rw_semaphore	rwsem;
+	bool			transition_ongoing; /* Tracks transition status */
+	struct mutex		transition_lock;
 };
 
 /* Only for ACPI */
-- 
1.7.12.rc2.18.g61b472e

