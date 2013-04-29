Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3D2G0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 02:26:23 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:34386 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3D2G0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 02:26:13 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/2] posix-cpu-timers: fix wrong timer initialization
Date: Mon, 29 Apr 2013 02:26:02 -0400
Message-Id: <1367216762-3933-2-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently glibc's rt/tst-cputimer1 testcase is spradically fail because
a timer created by timer_create() may faire earlier than an argument.

There are two faults. 1) cpu_timer_sample_group() adds task_delta_exec(current).
But it is definity silly idea especially when multi thread. cputimer should
be initialized by committed exec runtime. i.e. it should not be added
scheduler delta. 2) expire time should be current time + timeout. In the other
words, expire calculation should take care scheduler delta.

Cc: Olivier Langlois <olivier@trillion01.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/kernel_stat.h |    5 -----
 kernel/posix-cpu-timers.c   |   33 +++++++++++++++++++++++----------
 kernel/sched/core.c         |   13 -------------
 3 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index ed5f6ed..f5d4fdf 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -117,11 +117,6 @@ static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
 	return kstat_cpu(cpu).irqs_sum;
 }
 
-/*
- * Lock/unlock the current runqueue - to extract task statistics:
- */
-extern unsigned long long task_delta_exec(struct task_struct *);
-
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
 extern void account_steal_time(cputime_t);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index e56be4c..dc61bc3 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -203,12 +203,10 @@ posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *tp)
 	return error;
 }
 
-
-/*
- * Sample a per-thread clock for the given task.
- */
-static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
-			    union cpu_time_count *cpu)
+static int do_cpu_clock_sample(const clockid_t which_clock,
+			       struct task_struct *p,
+			       bool add_delta,
+			       union cpu_time_count *cpu)
 {
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
@@ -220,12 +218,21 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 		cpu->cpu = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = task_sched_runtime(p, true);
+		cpu->sched = task_sched_runtime(p, add_delta);
 		break;
 	}
 	return 0;
 }
 
+/*
+ * Sample a per-thread clock for the given task.
+ */
+static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
+			    union cpu_time_count *cpu)
+{
+	return do_cpu_clock_sample(which_clock, p, true, cpu);
+}
+
 static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 {
 	if (b->utime > a->utime)
@@ -635,7 +642,7 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
+		cpu->sched = cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
@@ -700,7 +707,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	 * check if it's already passed.  In short, we need a sample.
 	 */
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
-		cpu_clock_sample(timer->it_clock, p, &val);
+		do_cpu_clock_sample(timer->it_clock, p, false, &val);
 	} else {
 		cpu_timer_sample_group(timer->it_clock, p, &val);
 	}
@@ -749,7 +756,13 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	}
 
 	if (new_expires.sched != 0 && !(flags & TIMER_ABSTIME)) {
-		cpu_time_add(timer->it_clock, &new_expires, val);
+		union cpu_time_count now;
+
+		if (CPUCLOCK_PERTHREAD(timer->it_clock))
+			cpu_clock_sample(timer->it_clock, p, &now);
+		else
+			cpu_clock_sample_group(timer->it_clock, p, &now);
+		cpu_time_add(timer->it_clock, &new_expires, now);
 	}
 
 	/*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ad3339f..b817e6d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2646,19 +2646,6 @@ static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
 	return ns;
 }
 
-unsigned long long task_delta_exec(struct task_struct *p)
-{
-	unsigned long flags;
-	struct rq *rq;
-	u64 ns = 0;
-
-	rq = task_rq_lock(p, &flags);
-	ns = do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, p, &flags);
-
-	return ns;
-}
-
 /*
  * Return accounted runtime for the task.
  * In case the task is currently running, return the runtime plus current's
-- 
1.7.1

