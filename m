Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3CRPad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:30:33 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:48756 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3CRPab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:30:31 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 1/7] sched: Create sched_select_cpu() to give preferred CPU for power saving
Date: Mon, 18 Mar 2013 20:53:23 +0530
Message-Id: <9f0fd16f792b9f9b399a4c91c98de37c56067d47.1363617402.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to save power, it would be useful to schedule light weight work on cpus
that aren't IDLE instead of waking up an IDLE one.

By idle cpu (from scheduler's perspective) we mean:
- Current task is idle task
- nr_running == 0
- wake_list is empty

This is already implemented for timers as get_nohz_timer_target(). We can figure
out few more users of this feature, like workqueues.

This patch converts get_nohz_timer_target() into a generic API
sched_select_cpu() so that other frameworks (like workqueue) can also use it.

This routine returns the cpu which is non-idle. It accepts a bitwise OR of SD_*
flags present in linux/sched.h. If the local CPU isn't idle OR all cpus are
idle, local cpu is returned back. If local cpu is idle, then we must look for
another CPU which have all the flags passed as argument as set and isn't idle.

This patch reuses the code from get_nohz_timer_target() routine, which had
similar implementation.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/sched.h | 21 +++++++++++++++--
 kernel/sched/core.c   | 63 +++++++++++++++++++++++++++++----------------------
 2 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e20580d..216fa0d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -230,14 +230,31 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(int cpu);
 
-#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
+#ifdef CONFIG_SMP
+extern int sched_select_cpu(unsigned int sd_flags);
+
+#ifdef CONFIG_NO_HZ
 extern void nohz_balance_enter_idle(int cpu);
 extern void set_cpu_sd_state_idle(void);
-extern int get_nohz_timer_target(void);
+/*
+ * In the semi idle case, use the nearest busy cpu for migrating timers
+ * from an idle cpu.  This is good for power-savings.
+ *
+ * We don't do similar optimization for completely idle system, as
+ * selecting an idle cpu will add more delays to the timers than intended
+ * (as that cpu's timer base may not be uptodate wrt jiffies etc).
+ */
+#define get_nohz_timer_target() sched_select_cpu(0)
 #else
 static inline void nohz_balance_enter_idle(int cpu) { }
 static inline void set_cpu_sd_state_idle(void) { }
+
+static inline int sched_select_cpu(unsigned int sd_flags)
+{
+	return raw_smp_processor_id();
+}
 #endif
+#endif /* CONFIG_SMP */
 
 /*
  * Only dump TASK_* tasks. (0 for all tasks)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b36635e..ccd76d7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -551,33 +551,6 @@ void resched_cpu(int cpu)
 
 #ifdef CONFIG_NO_HZ
 /*
- * In the semi idle case, use the nearest busy cpu for migrating timers
- * from an idle cpu.  This is good for power-savings.
- *
- * We don't do similar optimization for completely idle system, as
- * selecting an idle cpu will add more delays to the timers than intended
- * (as that cpu's timer base may not be uptodate wrt jiffies etc).
- */
-int get_nohz_timer_target(void)
-{
-	int cpu = smp_processor_id();
-	int i;
-	struct sched_domain *sd;
-
-	rcu_read_lock();
-	for_each_domain(cpu, sd) {
-		for_each_cpu(i, sched_domain_span(sd)) {
-			if (!idle_cpu(i)) {
-				cpu = i;
-				goto unlock;
-			}
-		}
-	}
-unlock:
-	rcu_read_unlock();
-	return cpu;
-}
-/*
  * When add_timer_on() enqueues a timer into the timer wheel of an
  * idle CPU then this timer might expire before the next timer event
  * which is scheduled to wake up that CPU. In case of a completely
@@ -648,6 +621,42 @@ void sched_avg_update(struct rq *rq)
 	}
 }
 
+/*
+ * This routine returns the nearest non-idle cpu. It accepts a bitwise OR of
+ * SD_* flags present in linux/sched.h. If the local CPU isn't idle, it is
+ * returned back. If it is idle, then we must look for another CPU which have
+ * all the flags passed as argument as set.
+ */
+int sched_select_cpu(unsigned int sd_flags)
+{
+	struct sched_domain *sd;
+	int cpu = smp_processor_id();
+	int i;
+
+	/* If Current cpu isn't idle, don't migrate anything */
+	if (!idle_cpu(cpu))
+		return cpu;
+
+	rcu_read_lock();
+	for_each_domain(cpu, sd) {
+		 /* If sd doesnt' have sd_flags set skip sd. */
+		if ((sd->flags & sd_flags) != sd_flags)
+			continue;
+
+		for_each_cpu(i, sched_domain_span(sd)) {
+			if (i == cpu)
+				continue;
+			if (!idle_cpu(i)) {
+				cpu = i;
+				goto unlock;
+			}
+		}
+	}
+unlock:
+	rcu_read_unlock();
+	return cpu;
+}
+
 #else /* !CONFIG_SMP */
 void resched_task(struct task_struct *p)
 {
-- 
1.7.12.rc2.18.g61b472e

