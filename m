Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161941Ab3DEIrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 04:47:41 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:40504 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3DEIrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 04:47:31 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Miller <davem@davemloft.net>, stable@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] posix-cpu-timers: fix counting delta_exec twice
Date: Sat,  6 Apr 2013 11:47:08 -0400
Message-Id: <1365263228-9373-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently glibc rt/cpuclock2 test(*) sporadically fail. The
pseudo test code is here.

 t0 = clock_gettime()
 abs = t0 + sleeptime;
 clock_nanosleep(TIMER_ABSTIME, abs)
 t1 = clock_gettime()
 assert(t1-t0 > sleeptime)
 assert(t1 > abs)

Because current signal->cputimer->cputime logic can add delta_exec
twice wrongly. The first is in initialization, thread_group_cputimer()
call thread_group_cputime() and it adds delta_exec. and later,
update_curr() adds delta_exec again.

Finally, clock_nanosleep() wakes up slightly before than passed argument and it is posix violation.

This issue was introduced by commit d670ec1317 (posix-cpu-timers:
Cure SMP wobbles).

(*) http://sourceware.org/git/?p=glibc.git;a=blob;f=rt/tst-cpuclock2.c;h=6752721717f959e89c0d692b3f1ee082d507eec2;hb=HEAD

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: stable@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/binfmt_elf.c           |    2 +-
 fs/binfmt_elf_fdpic.c     |    2 +-
 include/linux/sched.h     |    4 ++--
 kernel/posix-cpu-timers.c |   10 +++++-----
 kernel/sched/core.c       |    6 ++++--
 kernel/sched/cputime.c    |    8 ++++----
 6 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 3939829..e139e18 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1321,7 +1321,7 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
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
index d35d2b6..deb49f3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2001,7 +2001,7 @@ static inline void disable_sched_clock_irqtime(void) {}
 #endif
 
 extern unsigned long long
-task_sched_runtime(struct task_struct *task);
+task_sched_runtime(struct task_struct *task, bool use_delta);
 
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
@@ -2624,7 +2624,7 @@ static inline int spin_needbreak(spinlock_t *lock)
 /*
  * Thread group CPU time accounting.
  */
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
+void thread_group_cputime(struct task_struct *tsk, bool use_delta, struct task_cputime *times);
 void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8fd709c..948004d 100644
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
@@ -251,7 +251,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 		 * to synchronize the timer to the clock every time we start
 		 * it.
 		 */
-		thread_group_cputime(tsk, &sum);
+		thread_group_cputime(tsk, false, &sum);
 		raw_spin_lock_irqsave(&cputimer->lock, flags);
 		cputimer->running = 1;
 		update_gt_cputime(&cputimer->cputime, &sum);
@@ -275,15 +275,15 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
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
index 7f12624..b2c78e1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2662,14 +2662,16 @@ unsigned long long task_delta_exec(struct task_struct *p)
  * In case the task is currently running, return the runtime plus current's
  * pending runtime that have not been accounted yet.
  */
-unsigned long long task_sched_runtime(struct task_struct *p)
+unsigned long long task_sched_runtime(struct task_struct *p, bool use_delta)
 {
 	unsigned long flags;
 	struct rq *rq;
 	u64 ns = 0;
 
 	rq = task_rq_lock(p, &flags);
-	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+	ns = p->se.sum_exec_runtime;
+	if (use_delta)
+		ns += do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, p, &flags);
 
 	return ns;
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index e93cca9..ee72d31 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -293,7 +293,7 @@ static __always_inline bool steal_account_process_tick(void)
  * Accumulate raw cputime values of dead tasks (sig->[us]time) and live
  * tasks (sum on group iteration) belonging to @tsk's group.
  */
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+void thread_group_cputime(struct task_struct *tsk, bool use_delta, struct task_cputime *times)
 {
 	struct signal_struct *sig = tsk->signal;
 	cputime_t utime, stime;
@@ -313,7 +313,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 		task_cputime(t, &utime, &stime);
 		times->utime += utime;
 		times->stime += stime;
-		times->sum_exec_runtime += task_sched_runtime(t);
+		times->sum_exec_runtime += task_sched_runtime(t, use_delta);
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

