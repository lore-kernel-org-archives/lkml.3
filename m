Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3D2G0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 02:26:14 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:52181 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3D2G0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 02:26:11 -0400
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
Subject: [PATCH 1/2] posix-cpu-timers: fix acounting delta_exec twice
Date: Mon, 29 Apr 2013 02:26:01 -0400
Message-Id: <1367216762-3933-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently glibc rt/tst-cpuclock2 test(*) sporadically fail. Because
scheduler delta can be accounted twice from thread_group_cputimer()
and account_group_exec_runtime().

Finally, clock_nanosleep() wakes up before an argument. And that is
posix violation. This issue was introduced by commit d670ec1317
(posix-cpu-timers: Cure SMP wobbles).

(*) http://sourceware.org/git/?p=glibc.git;a=blob;f=rt/tst-cpuclock2.c;h=6752721717f959e89c0d692b3f1ee082d507eec2;hb=HEAD

Cc: Olivier Langlois <olivier@trillion01.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/binfmt_elf.c           |    2 +-
 fs/binfmt_elf_fdpic.c     |    2 +-
 include/linux/sched.h     |    4 ++--
 kernel/posix-cpu-timers.c |   15 ++++++++++-----
 kernel/sched/core.c       |    6 ++++--
 kernel/sched/cputime.c    |    8 ++++----
 6 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 86af964..fea51e7 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1322,7 +1322,7 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		 * This is the record for the group leader.  It shows the
 		 * group-wide total, not its individual thread total.
 		 */
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, true, &cputime);
 		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
 		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 9c13e02..ab5b508 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1371,7 +1371,7 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		 * This is the record for the group leader.  It shows the
 		 * group-wide total, not its individual thread total.
 		 */
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, true, &cputime);
 		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
 		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e692a02..7863d4b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2002,7 +2002,7 @@ static inline void disable_sched_clock_irqtime(void) {}
 #endif
 
 extern unsigned long long
-task_sched_runtime(struct task_struct *task);
+task_sched_runtime(struct task_struct *task, bool add_delta);
 
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
@@ -2625,7 +2625,7 @@ static inline int spin_needbreak(spinlock_t *lock)
 /*
  * Thread group CPU time accounting.
  */
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
+void thread_group_cputime(struct task_struct *tsk, bool add_delta, struct task_cputime *times);
 void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8fd709c..e56be4c 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -220,7 +220,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 		cpu->cpu = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = task_sched_runtime(p);
+		cpu->sched = task_sched_runtime(p, true);
 		break;
 	}
 	return 0;
@@ -250,8 +250,13 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 		 * values through the TIMER_ABSTIME flag, therefore we have
 		 * to synchronize the timer to the clock every time we start
 		 * it.
+		 *
+		 * Do not add the current delta, because
+		 * account_group_exec_runtime() will also this delta and we
+		 * wouldn't want to double account time and get ahead of
+		 * ourselves.
 		 */
-		thread_group_cputime(tsk, &sum);
+		thread_group_cputime(tsk, false, &sum);
 		raw_spin_lock_irqsave(&cputimer->lock, flags);
 		cputimer->running = 1;
 		update_gt_cputime(&cputimer->cputime, &sum);
@@ -275,15 +280,15 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, true, &cputime);
 		cpu->cpu = cputime.utime + cputime.stime;
 		break;
 	case CPUCLOCK_VIRT:
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, true, &cputime);
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, true, &cputime);
 		cpu->sched = cputime.sum_exec_runtime;
 		break;
 	}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 67d0465..ad3339f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2664,14 +2664,16 @@ unsigned long long task_delta_exec(struct task_struct *p)
  * In case the task is currently running, return the runtime plus current's
  * pending runtime that have not been accounted yet.
  */
-unsigned long long task_sched_runtime(struct task_struct *p)
+unsigned long long task_sched_runtime(struct task_struct *p, bool add_delta)
 {
 	unsigned long flags;
 	struct rq *rq;
 	u64 ns = 0;
 
 	rq = task_rq_lock(p, &flags);
-	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+	ns = p->se.sum_exec_runtime;
+	if (add_delta)
+		ns += do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, p, &flags);
 
 	return ns;
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index e93cca9..69d3f6c 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -293,7 +293,7 @@ static __always_inline bool steal_account_process_tick(void)
  * Accumulate raw cputime values of dead tasks (sig->[us]time) and live
  * tasks (sum on group iteration) belonging to @tsk's group.
  */
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+void thread_group_cputime(struct task_struct *tsk, bool add_delta, struct task_cputime *times)
 {
 	struct signal_struct *sig = tsk->signal;
 	cputime_t utime, stime;
@@ -313,7 +313,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 		task_cputime(t, &utime, &stime);
 		times->utime += utime;
 		times->stime += stime;
-		times->sum_exec_runtime += task_sched_runtime(t);
+		times->sum_exec_runtime += task_sched_runtime(t, add_delta);
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
@@ -459,7 +459,7 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 {
 	struct task_cputime cputime;
 
-	thread_group_cputime(p, &cputime);
+	thread_group_cputime(p, true, &cputime);
 
 	*ut = cputime.utime;
 	*st = cputime.stime;
@@ -594,7 +594,7 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 {
 	struct task_cputime cputime;
 
-	thread_group_cputime(p, &cputime);
+	thread_group_cputime(p, true, &cputime);
 	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
 }
 #endif /* !CONFIG_VIRT_CPU_ACCOUNTING */
-- 
1.7.1

