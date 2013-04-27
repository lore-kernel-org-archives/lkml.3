Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab3D0ElM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 00:41:12 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:35139 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752058Ab3D0ElJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 00:41:09 -0400
Message-ID: <1367037663.7911.68.camel@Wailaba2>
Subject: [PATCH v2 3/3] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 27 Apr 2013 00:41:03 -0400
In-Reply-To: <1367036552.7911.63.camel@Wailaba2>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>
	 <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
	 <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
	 <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
	 <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>
	 <517AD0AE.1030404@gmail.com> <1367036552.7911.63.camel@Wailaba2>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Add thread group delta to cpu timer sample when computing a timer expiration.

This is mandatory to make sure that the posix cpu timer does not fire too
soon relative to the process cpu clock which do include the task group delta.

test case to validate the patch is glibc-2.17/rt/tst-cputimer1.c

There is a race condition hard to fix that the code simply need to acknowledge
its presence and workaround.

thread 1:

1. Executing thread_group_cputimer_nodelta()
2. Acquire cputimer->lock.

thread 2:

1. Executing update_curr() (rq lock acquired)
2. waiting for cputimer->lock inside account_group_exec_runtime()

thread 1:

3. Get cputimer value
4. release cputimer->lock
5. call group_delta_exec()
6. Wait for thread 2 rq lock (and it will get it only after thread 2 reinitiazed its delta)

Now it should be clear why thread 2 delta will not appear anywhere in the cputimer sample.

Simply inversing the function calls in thread_group_cputimer_nodelta() that is
calling group_delta_exec() before getting the cputimer, eliminate the possibility
of missing a task delta. The opposite can happen, that is, having a delta be counted
twice but this is not having any serious consequences.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 kernel/posix-cpu-timers.c | 91 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 76 insertions(+), 15 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8fd709c..10d28cc 100644
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
@@ -233,34 +236,84 @@ static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 
        if (b->stime > a->stime)
                a->stime = b->stime;
-
-       if (b->sum_exec_runtime > a->sum_exec_runtime)
-               a->sum_exec_runtime = b->sum_exec_runtime;
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
+                                           struct task_cputime *times,
+                                           unsigned long long *delta)
 {
        struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
        struct task_cputime sum;
        unsigned long flags;
 
-       if (!cputimer->running) {
+       if (unlikely(!cputimer->running)) {
                /*
                 * The POSIX timer interface allows for absolute time expiry
                 * values through the TIMER_ABSTIME flag, therefore we have
                 * to synchronize the timer to the clock every time we start
                 * it.
+                *
+                * Exclude task deltas or else they will be accounted twice
+                * in the cputimer.
                 */
-               thread_group_cputime(tsk, &sum);
+               thread_group_cputime_nodelta(tsk, &sum, delta);
                raw_spin_lock_irqsave(&cputimer->lock, flags);
                cputimer->running = 1;
                update_gt_cputime(&cputimer->cputime, &sum);
-       } else
+       } else {
+               /*
+                * Ideally, you would expect to get:
+                *
+                * 1. delta = x, times->sum_exec_runtime = y or
+                * 2. delta = 0, times->sum_exec_runtime = y+x
+                *
+                * but because of the race condition between this function and
+                * update_curr(), it is possible to get:
+                *
+                * 3. delta = 0, times->sum_exec_runtime = y by fetching the
+                *    cputimer before delta or
+                * 4. delta = x, times->sum_exec_runtime = y+x by inverting the
+                *    sequence.
+                *
+                * Situation #3 is to be avoided or else it will make a timer being
+                * fired sooner than requested.
+                *
+                * Calling group_delta_exec() is required to guaranty accurate result
+                */
+               if (delta && *delta == CPUTIMER_NEED_DELTA) {
+                       /*
+                        * If rq lock contention is serious concern, the
+                        * following statement could be replaced with
+                        * *delta = task_delta_exec(tsk) + (NR_CPUS-1)*TICK_NSEC;
+                        * to trade accuracy for reduced rq locks contention.
+                        */
+                       *delta = group_delta_exec(tsk);
+               }
                raw_spin_lock_irqsave(&cputimer->lock, flags);
+       }
        *times = cputimer->cputime;
        raw_spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
+void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
+{
+       thread_group_cputimer_withdelta(tsk, times, NULL);
+}
+
 /*
  * Sample a process (thread group) clock for the given group_leader task.
  * Must be called with tasklist_lock held for reading.
@@ -615,22 +668,27 @@ static void cpu_timer_fire(struct k_itimer *timer)
  */
 static int cpu_timer_sample_group(const clockid_t which_clock,
                                  struct task_struct *p,
-                                 union cpu_time_count *cpu)
+                                 union cpu_time_count *cpu,
+                                 unsigned need_delta)
 {
        struct task_cputime cputime;
+       unsigned long long delta;
 
-       thread_group_cputimer(p, &cputime);
        switch (CPUCLOCK_WHICH(which_clock)) {
        default:
                return -EINVAL;
        case CPUCLOCK_PROF:
+               thread_group_cputimer_withdelta(p, &cputime, NULL);
                cpu->cpu = cputime.utime + cputime.stime;
                break;
        case CPUCLOCK_VIRT:
+               thread_group_cputimer_withdelta(p, &cputime, NULL);
                cpu->cpu = cputime.utime;
                break;
        case CPUCLOCK_SCHED:
-               cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
+               delta = need_delta;
+               thread_group_cputimer_withdelta(p, &cputime, &delta);
+               cpu->sched = cputime.sum_exec_runtime + delta;
                break;
        }
        return 0;
@@ -697,7 +755,8 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
        if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
                cpu_clock_sample(timer->it_clock, p, &val);
        } else {
-               cpu_timer_sample_group(timer->it_clock, p, &val);
+               cpu_timer_sample_group(timer->it_clock, p, &val,
+                                      CPUTIMER_NEED_DELTA);
        }
 
        if (old) {
@@ -845,7 +904,8 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
                        read_unlock(&tasklist_lock);
                        goto dead;
                } else {
-                       cpu_timer_sample_group(timer->it_clock, p, &now);
+                       cpu_timer_sample_group(timer->it_clock, p, &now,
+                                              CPUTIMER_NO_DELTA);
                        clear_dead = (unlikely(p->exit_state) &&
                                      thread_group_empty(p));
                }
@@ -1042,7 +1102,7 @@ static void check_process_timers(struct task_struct *tsk,
        /*
         * Collect the current process totals.
         */
-       thread_group_cputimer(tsk, &cputime);
+       thread_group_cputimer_withdelta(tsk, &cputime, NULL);
        utime = cputime.utime;
        ptime = utime + cputime.stime;
        sum_sched_runtime = cputime.sum_exec_runtime;
@@ -1182,7 +1242,8 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
                        goto out_unlock;
                }
                spin_lock(&p->sighand->siglock);
-               cpu_timer_sample_group(timer->it_clock, p, &now);
+               cpu_timer_sample_group(timer->it_clock, p, &now,
+                                      CPUTIMER_NO_DELTA);
                bump_cpu_timer(timer, now);
                /* Leave the tasklist_lock locked for the call below.  */
        }
@@ -1348,7 +1409,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
        union cpu_time_count now;
 
        BUG_ON(clock_idx == CPUCLOCK_SCHED);
-       cpu_timer_sample_group(clock_idx, tsk, &now);
+       cpu_timer_sample_group(clock_idx, tsk, &now, CPUTIMER_NEED_DELTA);
 
        if (oldval) {
                /*
-- 
1.8.2.1




