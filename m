Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3DLPzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:55:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56003 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3DLPzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:55:31 -0400
Message-ID: <1365782115.17140.68.camel@laptop>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Peter Zijlstra <peterz@infradead.org>
To: Olivier Langlois <olivier@trillion01.com>
Cc: mingo@redhat.com, tglx@linutronix.de, fweisbec@gmail.com,
        schwidefsky@de.ibm.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Apr 2013 17:55:15 +0200
In-Reply-To: <1365763837.17140.52.camel@laptop>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365763837.17140.52.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-12 at 12:50 +0200, Peter Zijlstra wrote:

> I'll try and dig through the rest of your email later.. sorry for
> being
> a tad slow etc.


So at thread_group_cputimer() we initialize the cputimer->cputime state
by using thread_group_cputime() which iterates all tasks of the process
and calls task_sched_runtime() upon them (which includes the current
delta).

Upon subsequent account_group_exec_runtime() calls (from all schedule
events and timer ticks) we add the current delta to cputimer->cputime.

However since we already added the first (or part thereof) delta to the
initial state, we account this double. Thus we can be up to
NR_CPUS*TICK_NSEC ahead.

On every timer tick we evaluate the cputimer state using
cpu_timer_sample_group() which adds the current tasks delta. This can
thus be up to (NR_CPUS-1)*TICK_NSEC behind.

The combination of the timeline behind ahead and the sample being
behind make it a virtual guarantee we'll hit early by almost
2*NR_CPUS*TICK_NSEC.

This is what you've been saying right?


So how about we do not include the deltas into the initial sum, so that
we're up to NR_CPUS*TICK_NSEC behind. That way, with the sample up to
(NR_CPUS-1)*TICK_NSEC behind, we're in the order of TICK_NSEC late with
firing.

Hmm?

---
 include/linux/sched.h     |  5 +++--
 kernel/posix-cpu-timers.c | 15 ++++++++++-----
 kernel/sched/core.c       |  6 ++++--
 kernel/sched/cputime.c    |  8 ++++----
 4 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 88ec7f4..abe5870 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1832,7 +1832,7 @@ static inline void disable_sched_clock_irqtime(void) {}
 #endif
 
 extern unsigned long long
-task_sched_runtime(struct task_struct *task);
+task_sched_runtime(struct task_struct *task, bool add_delta);
 
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
@@ -2496,7 +2496,8 @@ static inline void current_clr_polling(void) { }
 /*
  * Thread group CPU time accounting.
  */
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times,
+			  bool add_delta);
 void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8fd709c..d8133ad 100644
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
+		 * Do no add the current delta, because
+		 * account_group_exec_runtime() will also add this delta and we
+		 * wouldn't want to double account time and get ahead of
+		 * ourselves.
 		 */
-		thread_group_cputime(tsk, &sum);
+		thread_group_cputime(tsk, &sum, false);
 		raw_spin_lock_irqsave(&cputimer->lock, flags);
 		cputimer->running = 1;
 		update_gt_cputime(&cputimer->cputime, &sum);
@@ -275,15 +280,15 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, &cputime, true);
 		cpu->cpu = cputime.utime + cputime.stime;
 		break;
 	case CPUCLOCK_VIRT:
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, &cputime, true);
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, &cputime, true);
 		cpu->sched = cputime.sum_exec_runtime;
 		break;
 	}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e8167e3..704fa44 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2677,14 +2677,16 @@ unsigned long long task_delta_exec(struct task_struct *p)
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
+        if (add_delta)
+		ns += do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, p, &flags);
 
 	return ns;
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ea32f02..c3495e1 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -277,7 +277,7 @@ static __always_inline bool steal_account_process_tick(void)
  * Accumulate raw cputime values of dead tasks (sig->[us]time) and live
  * tasks (sum on group iteration) belonging to @tsk's group.
  */
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times, bool add_delta)
 {
 	struct signal_struct *sig = tsk->signal;
 	cputime_t utime, stime;
@@ -297,7 +297,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 		task_cputime(t, &utime, &stime);
 		times->utime += utime;
 		times->stime += stime;
-		times->sum_exec_runtime += task_sched_runtime(t);
+		times->sum_exec_runtime += task_sched_runtime(t, add_delta);
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
@@ -444,7 +444,7 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 {
 	struct task_cputime cputime;
 
-	thread_group_cputime(p, &cputime);
+	thread_group_cputime(p, &cputime, true);
 
 	*ut = cputime.utime;
 	*st = cputime.stime;
@@ -606,7 +606,7 @@ void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime
 {
 	struct task_cputime cputime;
 
-	thread_group_cputime(p, &cputime);
+	thread_group_cputime(p, &cputime, true);
 	cputime_adjust(&cputime, &p->signal->prev_cputime, ut, st);
 }
 #endif /* !CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */


