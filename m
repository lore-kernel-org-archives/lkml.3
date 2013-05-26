Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab3EZVg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:36:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57654 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3EZVgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:36:54 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 3/8] posix-cpu-timers: fix wrong timer initialization
Date: Sun, 26 May 2013 17:35:44 -0400
Message-Id: <1369604149-13016-6-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently glibc's rt/tst-cputimer1 testcase sporadically fails because
a timer created by timer_create() may fire earlier than specified.

posix_cpu_timer_set() uses "val" as current time for three purpose. 1)
initialize sig->cputimer. 2) calculation "old" val. 3) calculations an
expires.

(1) and (2) should only use committed time (i.e. without delta_exec)
because run_posix_cpu_timers() don't care of delta_exec and we need
consistency, but (3) need exact current time (aka cpu clock time) because
an expires should be "now + timeout" by definition.

This patch distinguishes between two kinds of "now".

Cc: Olivier Langlois <olivier@trillion01.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/kernel_stat.h |    5 -----
 kernel/posix-cpu-timers.c   |   14 ++++++++++++--
 kernel/sched/core.c         |   13 -------------
 3 files changed, 12 insertions(+), 20 deletions(-)

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
index 25447c5..d068808 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -652,7 +652,7 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
+		cpu->sched = cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
@@ -797,7 +797,17 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	}
 
 	if (new_expires.sched != 0 && !(flags & TIMER_ABSTIME)) {
-		cpu_time_add(timer->it_clock, &new_expires, val);
+		union cpu_time_count now;
+
+		/*
+		 * The expires is "now + timeout" by definition. So,
+		 * we need exact current time.
+		 */
+		if (CPUCLOCK_PERTHREAD(timer->it_clock))
+			now = val;
+		else
+			cpu_clock_sample_group(timer->it_clock, p, &now);
+		cpu_time_add(timer->it_clock, &new_expires, now);
 	}
 
 	/*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a1e823b..96512e9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2681,19 +2681,6 @@ static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
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

