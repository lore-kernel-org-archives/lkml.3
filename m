Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab3ILKLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:11:30 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54480 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007Ab3ILKLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:11:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] cpufreq: make sure frequency transitions are serialized
Date: Thu, 12 Sep 2013 15:40:46 +0530
Message-Id: <793a5fadad931d04c2adb3a61c64063b7e62d083.1378979483.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <a0cad3326c6a6c8f0517332dd2230edaf67268e7.1378979483.git.viresh.kumar@linaro.org>
References: <a0cad3326c6a6c8f0517332dd2230edaf67268e7.1378979483.git.viresh.kumar@linaro.org>
In-Reply-To: <a0cad3326c6a6c8f0517332dd2230edaf67268e7.1378979483.git.viresh.kumar@linaro.org>
References: <a0cad3326c6a6c8f0517332dd2230edaf67268e7.1378979483.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some part of this patch was pushed in mainline earlier but was then removed due
to loopholes in the patch. Those are now fixed and this patch is tested by the
people who reported these problems.

Whenever we are changing frequency of a cpu, we are calling PRECHANGE and
POSTCHANGE notifiers. They must be serialized. i.e. PRECHANGE or POSTCHANGE
shouldn't be called twice contiguously. Also, calls to cpufreq_driver_target()
or cpufreq_driver->target() must also be serialized. Following examples show why
this is important:

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

Where would we break then?: adjust_jiffies() in cpufreq.c,
cpufreq_callback() in arch/arm/kernel/smp.c (which is also adjusting
jiffies).. All loops_per_jiffy based stuff is broken..

Scenario 2:
-----------
Governor is changing freq and has called __cpufreq_driver_target(). At the same
time we are changing scaling_{min|max}_freq from sysfs, which would eventually
end up calling governor's: CPUFREQ_GOV_LIMITS notification, that will also call:
__cpufreq_driver_target().. And hence concurrent calls to ->target()

And Platform have something like this in their ->target()
(Like: cpufreq-cpu0, omap, exynos, etc)

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

We ended up setting a freq which is not supported by the voltage we have
set.. That will probably make clock to CPU unstable and system wouldn't
be workable anymore...

This patch adds some protection against to make transitions serialized.

Tested-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c            | 83 ++++++++++++++++++++++++++++++++++++
 drivers/cpufreq/exynos5440-cpufreq.c |  3 ++
 include/linux/cpufreq.h              |  1 +
 3 files changed, 87 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 43c24aa..f8b0889 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -268,6 +268,8 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, unsigned int state)
 {
+	unsigned long flags;
+
 	BUG_ON(irqs_disabled());
 
 	if (cpufreq_disabled())
@@ -280,6 +282,17 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 	switch (state) {
 
 	case CPUFREQ_PRECHANGE:
+		write_lock_irqsave(&cpufreq_driver_lock, flags);
+		if (WARN(policy->transition_ongoing >
+					cpumask_weight(policy->cpus),
+				"In middle of another frequency transition\n")) {
+			write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			return;
+		}
+
+		policy->transition_ongoing++;
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 		/* detect if the driver reported a value as "old frequency"
 		 * which is not equal to what the cpufreq core thinks is
 		 * "old frequency".
@@ -299,6 +312,16 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		break;
 
 	case CPUFREQ_POSTCHANGE:
+		write_lock_irqsave(&cpufreq_driver_lock, flags);
+		if (WARN(policy->transition_ongoing < 2,
+				"No frequency transition in progress\n")) {
+			write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			return;
+		}
+
+		policy->transition_ongoing--;
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
 		pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
 			(unsigned long)freqs->cpu);
@@ -324,6 +347,20 @@ void cpufreq_notify_transition(struct cpufreq_policy *policy,
 {
 	for_each_cpu(freqs->cpu, policy->cpus)
 		__cpufreq_notify_transition(policy, freqs, state);
+
+	if ((cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION)
+			&& (state == CPUFREQ_POSTCHANGE)) {
+		unsigned long flags;
+
+		/*
+		 * Some drivers don't send POSTCHANGE notification from their
+		 * ->target() but from some kind of bottom half and so we are
+		 * ending transaction here..
+		 */
+		write_lock_irqsave(&cpufreq_driver_lock, flags);
+		policy->transition_ongoing--;
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	}
 }
 EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
 
@@ -1369,8 +1406,33 @@ static void cpufreq_out_of_sync(unsigned int cpu, unsigned int old_freq,
 	policy = per_cpu(cpufreq_cpu_data, cpu);
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	/*
+	 * The role of this function is to make sure that the CPU frequency we
+	 * use is the same as the CPU is actually running at. Therefore, if a
+	 * CPU frequency change notification is in progress, it will do the
+	 * update anyway, so we have nothing to do here in that case.
+	 */
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	if (policy->transition_ongoing) {
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		return;
+	}
+	policy->transition_ongoing++;
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+
+	/*
+	 * For drivers with CPUFREQ_ASYNC_NOTIFICATION flag set, we decrement
+	 * transition_ongoing from POSTCHANGE notifiers.
+	 */
+	if (cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION)
+		return;
+
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	policy->transition_ongoing--;
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 }
 
 /**
@@ -1656,6 +1718,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 {
 	int retval = -EINVAL;
 	unsigned int old_target_freq = target_freq;
+	unsigned long flags;
 
 	if (cpufreq_disabled())
 		return -ENODEV;
@@ -1672,9 +1735,29 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 	if (target_freq == policy->cur)
 		return 0;
 
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	if (policy->transition_ongoing) {
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		return -EBUSY;
+	}
+	policy->transition_ongoing++;
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 	if (cpufreq_driver->target)
 		retval = cpufreq_driver->target(policy, target_freq, relation);
 
+	/*
+	 * For drivers with CPUFREQ_ASYNC_NOTIFICATION flag set, we decrement
+	 * transition_ongoing from POSTCHANGE notifiers.
+	 */
+	if ((cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION)
+			&& (retval == -EINPROGRESS))
+		return retval;
+
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	policy->transition_ongoing--;
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 	return retval;
 }
 EXPORT_SYMBOL_GPL(__cpufreq_driver_target);
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index f44664a..1e391ac 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -251,6 +251,9 @@ static int exynos_target(struct cpufreq_policy *policy,
 
 		__raw_writel(tmp, dvfs_info->base + XMU_C0_3_PSTATE + i * 4);
 	}
+
+	/* Mark transition as In-progress */
+	ret = -EINPROGRESS;
 out:
 	mutex_unlock(&cpufreq_lock);
 	return ret;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 3cefb7b..c770bc0 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -85,6 +85,7 @@ struct cpufreq_policy {
 	struct list_head        policy_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
+	int			transition_ongoing; /* Tracks transition status */
 };
 
 /* Only for ACPI */
-- 
1.7.12.rc2.18.g61b472e

