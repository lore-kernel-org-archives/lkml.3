Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162389Ab3DER7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:59:14 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:56320 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1162211Ab3DER7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:59:12 -0400
Message-ID: <1365184746.874.103.camel@Wailaba2>
Subject: [PATCH] process cputimer is moving faster than its corresponding
 clock
From: Olivier Langlois <olivier@trillion01.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        fweisbec@gmail.com, schwidefsky@de.ibm.com, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Date: Fri, 05 Apr 2013 13:59:06 -0400
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Process timers are moving fasters than their corresponding
 cpu clock for various reasons:

1. There is a race condition when getting a timer sample that makes the sample
   be smaller than it should leading to setting the timer expiration to soon.
2. When initializing the cputimer, by including tasks deltas in the initial
   timer value, it makes them be counted twice.
3. When a thread autoreap itself when exiting, the last context switch update
   will update the cputimer and not the overall process values stored in
   signal.

I have also removed to erractic cputimer start/stop. I am guessing that it
was done to 'resync' once in a while the cputimer with the clock but
you could start the cputimer by calling timer_settimer that finally
do not end up by arming a new posix timer so you could have the cputimer
running with 0 armed timers or have 1 periodic process timer.

every time the periodic timer is moved to the timer list to be fire,
the cputimer is stopped to be restarted immediately after when it
is rescheduled. This lead to unnecessary lock retention, IMO.

With this patch, the glibc/rt unit tests pass with a 100% success rate.
I have been hammered it with invoking tst-cputimer1 in an infinite loop.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 include/linux/kernel_stat.h |  1 +
 include/linux/sched.h       |  5 +++
 kernel/posix-cpu-timers.c   | 93 +++++++++++++++++++++++++++++++++------------
 kernel/sched/core.c         | 22 +++++++++--
 kernel/sched/cputime.c      | 47 ++++++++++++++++++++---
 kernel/sched/fair.c         | 11 +++++-
 6 files changed, 144 insertions(+), 35 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index ed5f6ed..9f38c80 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -121,6 +121,7 @@ static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
  * Lock/unlock the current runqueue - to extract task statistics:
  */
 extern unsigned long long task_delta_exec(struct task_struct *);
+extern unsigned long long group_delta_exec(struct task_struct *);
 
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..8666632 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2003,6 +2003,9 @@ static inline void disable_sched_clock_irqtime(void) {}
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
 
+extern unsigned long long
+task_sched_runtime_nodelta(struct task_struct *task, unsigned long long *delta);
+
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
 extern void sched_exec(void);
@@ -2625,6 +2628,8 @@ static inline int spin_needbreak(spinlock_t *lock)
  * Thread group CPU time accounting.
  */
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
+void thread_group_cputime_nodelta(struct task_struct *tsk, struct task_cputime *times,
+				   unsigned long long *delta);
 void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8fd709c..0d4a841 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -226,6 +226,9 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 	return 0;
 }
 
+/*
+ * Ensure the timer monotonicity.
+ */
 static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 {
 	if (b->utime > a->utime)
@@ -238,29 +241,75 @@ static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 		a->sum_exec_runtime = b->sum_exec_runtime;
 }
 
-void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
+/*
+ * Fetch the thread group cputime and the group tasks delta sum
+ * atomically when initializing the timer or make sure that the
+ * race condition does not make timers fire earlier than specified
+ * by having the timer sample earlier than its corresponding clock.
+ *
+ * Except when initializing the cputimer, it is not always necessary
+ * to fetch the delta. It is mandatory only when setting a timer
+ * to avoid shooting it before its time. So enhance the sample
+ * accurary when getting the delta is free or when really needed.
+ */
+#define CPUTIMER_NEED_DELTA 1
+#define CPUTIMER_NO_DELTA   0
+
+static void thread_group_cputimer_withdelta(struct task_struct *tsk,
+					    struct task_cputime *times,
+					    unsigned long long *delta)
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 	struct task_cputime sum;
 	unsigned long flags;
 
-	if (!cputimer->running) {
+	if (unlikely(!cputimer->running)) {
 		/*
 		 * The POSIX timer interface allows for absolute time expiry
 		 * values through the TIMER_ABSTIME flag, therefore we have
 		 * to synchronize the timer to the clock every time we start
 		 * it.
+		 *
+		 * Exclude task deltas or else they will be accounted twice
+		 * in the cputimer.
 		 */
-		thread_group_cputime(tsk, &sum);
+		thread_group_cputime_nodelta(tsk, &sum, delta);
 		raw_spin_lock_irqsave(&cputimer->lock, flags);
 		cputimer->running = 1;
 		update_gt_cputime(&cputimer->cputime, &sum);
-	} else
+	} else {
+		/*
+		 * Ideally, you would expect to get:
+		 *
+		 * 1. delta = x, times->sum_exec_runtime = y or
+		 * 2. delta = 0, times->sum_exec_runtime = y+x
+		 *
+		 * but because of the race condition between this function and
+		 * update_curr(), it is possible to get:
+		 *
+		 * 3. delta = 0, times->sum_exec_runtime = y by fetching the
+		 *    cputimer before delta or
+		 * 4. delta = x, times->sum_exec_runtime = y+x by inverting the
+		 *    sequence.
+		 *
+		 * Situation #3 is to be avoided or else it will make a timer being
+		 * fired sooner than requested.
+		 *
+		 * Calling group_delta_exec() is required to guaranty accurate result
+		 */
+		if (delta && *delta == CPUTIMER_NEED_DELTA)
+			*delta = group_delta_exec(tsk);
 		raw_spin_lock_irqsave(&cputimer->lock, flags);
+	}
 	*times = cputimer->cputime;
 	raw_spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
+void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
+{
+	thread_group_cputimer_withdelta(tsk, times, NULL);
+}
+
 /*
  * Sample a process (thread group) clock for the given group_leader task.
  * Must be called with tasklist_lock held for reading.
@@ -615,22 +664,27 @@ static void cpu_timer_fire(struct k_itimer *timer)
  */
 static int cpu_timer_sample_group(const clockid_t which_clock,
 				  struct task_struct *p,
-				  union cpu_time_count *cpu)
+				  union cpu_time_count *cpu,
+				  unsigned need_delta)
 {
 	struct task_cputime cputime;
+	unsigned long long delta;
 
-	thread_group_cputimer(p, &cputime);
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
+		thread_group_cputimer_withdelta(p, &cputime, NULL);
 		cpu->cpu = cputime.utime + cputime.stime;
 		break;
 	case CPUCLOCK_VIRT:
+		thread_group_cputimer_withdelta(p, &cputime, NULL);
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
+		delta = need_delta;
+		thread_group_cputimer_withdelta(p, &cputime, &delta);
+		cpu->sched = cputime.sum_exec_runtime + delta;
 		break;
 	}
 	return 0;
@@ -697,7 +751,8 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &val);
 	} else {
-		cpu_timer_sample_group(timer->it_clock, p, &val);
+		cpu_timer_sample_group(timer->it_clock, p, &val,
+				       CPUTIMER_NEED_DELTA);
 	}
 
 	if (old) {
@@ -845,7 +900,8 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 			read_unlock(&tasklist_lock);
 			goto dead;
 		} else {
-			cpu_timer_sample_group(timer->it_clock, p, &now);
+			cpu_timer_sample_group(timer->it_clock, p, &now,
+					       CPUTIMER_NO_DELTA);
 			clear_dead = (unlikely(p->exit_state) &&
 				      thread_group_empty(p));
 		}
@@ -967,16 +1023,6 @@ static void check_thread_timers(struct task_struct *tsk,
 	}
 }
 
-static void stop_process_timers(struct signal_struct *sig)
-{
-	struct thread_group_cputimer *cputimer = &sig->cputimer;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&cputimer->lock, flags);
-	cputimer->running = 0;
-	raw_spin_unlock_irqrestore(&cputimer->lock, flags);
-}
-
 static u32 onecputick;
 
 static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
@@ -1042,7 +1088,7 @@ static void check_process_timers(struct task_struct *tsk,
 	/*
 	 * Collect the current process totals.
 	 */
-	thread_group_cputimer(tsk, &cputime);
+	thread_group_cputimer_withdelta(tsk, &cputime, NULL);
 	utime = cputime.utime;
 	ptime = utime + cputime.stime;
 	sum_sched_runtime = cputime.sum_exec_runtime;
@@ -1130,8 +1176,6 @@ static void check_process_timers(struct task_struct *tsk,
 	sig->cputime_expires.prof_exp = prof_expires;
 	sig->cputime_expires.virt_exp = virt_expires;
 	sig->cputime_expires.sched_exp = sched_expires;
-	if (task_cputime_zero(&sig->cputime_expires))
-		stop_process_timers(sig);
 }
 
 /*
@@ -1182,7 +1226,8 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			goto out_unlock;
 		}
 		spin_lock(&p->sighand->siglock);
-		cpu_timer_sample_group(timer->it_clock, p, &now);
+		cpu_timer_sample_group(timer->it_clock, p, &now,
+				       CPUTIMER_NO_DELTA);
 		bump_cpu_timer(timer, now);
 		/* Leave the tasklist_lock locked for the call below.  */
 	}
@@ -1348,7 +1393,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 	union cpu_time_count now;
 
 	BUG_ON(clock_idx == CPUCLOCK_SCHED);
-	cpu_timer_sample_group(clock_idx, tsk, &now);
+	cpu_timer_sample_group(clock_idx, tsk, &now, CPUTIMER_NEED_DELTA);
 
 	if (oldval) {
 		/*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..bf73b57 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2659,23 +2659,37 @@ unsigned long long task_delta_exec(struct task_struct *p)
 
 /*
  * Return accounted runtime for the task.
- * In case the task is currently running, return the runtime plus current's
- * pending runtime that have not been accounted yet.
+ * Return separately the current's pending runtime that have not been
+ * accounted yet.
  */
-unsigned long long task_sched_runtime(struct task_struct *p)
+unsigned long long task_sched_runtime_nodelta(struct task_struct *p, unsigned long long *delta)
 {
 	unsigned long flags;
 	struct rq *rq;
 	u64 ns = 0;
 
 	rq = task_rq_lock(p, &flags);
-	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+	ns = p->se.sum_exec_runtime;
+	*delta = do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
 
 /*
+ * Return accounted runtime for the task.
+ * In case the task is currently running, return the runtime plus current's
+ * pending runtime that have not been accounted yet.
+ */
+unsigned long long task_sched_runtime(struct task_struct *p)
+{
+	unsigned long long delta;
+	u64 ns = task_sched_runtime_nodelta(p, &delta);
+	ns += delta;
+	return ns;
+}
+
+/*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
  */
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ed12cbb..69836c9 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -289,15 +289,14 @@ static __always_inline bool steal_account_process_tick(void)
 	return false;
 }
 
-/*
- * Accumulate raw cputime values of dead tasks (sig->[us]time) and live
- * tasks (sum on group iteration) belonging to @tsk's group.
- */
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+void thread_group_cputime_nodelta(struct task_struct *tsk, struct task_cputime *times,
+				  unsigned long long *delta)
 {
 	struct signal_struct *sig = tsk->signal;
 	cputime_t utime, stime;
 	struct task_struct *t;
+	unsigned long long d = 0;
+	unsigned long long td;
 
 	times->utime = sig->utime;
 	times->stime = sig->stime;
@@ -313,10 +312,46 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 		task_cputime(tsk, &utime, &stime);
 		times->utime += utime;
 		times->stime += stime;
-		times->sum_exec_runtime += task_sched_runtime(t);
+		times->sum_exec_runtime += task_sched_runtime_nodelta(t, &td);
+		d += td;
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
+
+	if (delta)
+		*delta = d;
+}
+
+/*
+ * Accumulate raw cputime values of dead tasks (sig->[us]time) and live
+ * tasks (sum on group iteration) belonging to @tsk's group.
+ */
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+{
+	unsigned long long d;
+	thread_group_cputime_nodelta(tsk, times, &d);
+	times->sum_exec_runtime += d;
+}
+
+
+unsigned long long group_delta_exec(struct task_struct *tsk)
+{
+	unsigned long long ns = 0;
+	struct task_struct *t;
+
+	rcu_read_lock();
+	/* make sure we can trust tsk->thread_group list */
+	if (!likely(pid_alive(tsk)))
+		goto out;
+
+	t = tsk;
+	do {
+		ns += task_delta_exec(t);
+	} while_each_thread(tsk, t);
+out:
+	rcu_read_unlock();
+
+	return ns;
 }
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..b82d070 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -708,7 +708,16 @@ static void update_curr(struct cfs_rq *cfs_rq)
 
 		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
 		cpuacct_charge(curtask, delta_exec);
-		account_group_exec_runtime(curtask, delta_exec);
+
+		/*
+		 * Do not update the cputimer if the task is already released by
+		 * release_task().
+		 *
+		 * it would preferable to defer the autoreap release_task
+		 * after the last context switch but harder to do.
+		 */
+		if (likely(curtask->sighand))
+			account_group_exec_runtime(curtask, delta_exec);
 	}
 
 	account_cfs_rq_runtime(cfs_rq, delta_exec);
-- 
1.8.2


