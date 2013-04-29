Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab3D2SEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:04:24 -0400
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:49841 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757720Ab3D2SEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:04:21 -0400
Message-ID: <1367258658.8833.20.camel@Wailaba2>
Subject: [PATCH v3 2/3] posix_timers: sched API modif required for
 posix-cpu-timer fix.
From: Olivier Langlois <olivier@olivierlanglois.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 29 Apr 2013 14:04:18 -0400
References: <1367257428.8833.18.camel@Wailaba2>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:olivierlanglois.net} {sentby:smtp auth 173.178.230.31 authed with olivier@olivierlanglois.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modify CFS API to be able to fetch separately a thread group cputime and its
tasks delta. This is needed by the third part of this patch.

Note that the new function group_delta_exec() is not absolutely required as
you could get the group delta by calling the modified task_sched_runtime().

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 include/linux/kernel_stat.h |  1 +
 include/linux/sched.h       |  5 +++++
 kernel/sched/core.c         | 22 +++++++++++++++++----
 kernel/sched/cputime.c      | 47 +++++++++++++++++++++++++++++++++++++++------
 4 files changed, 65 insertions(+), 10 deletions(-)

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
index e692a02..d0b5104 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2004,6 +2004,9 @@ static inline void disable_sched_clock_irqtime(void) {}
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
 
+extern unsigned long long
+task_sched_runtime_nodelta(struct task_struct *task, unsigned long long *delta);
+
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
 extern void sched_exec(void);
@@ -2626,6 +2629,8 @@ static inline int spin_needbreak(spinlock_t *lock)
  * Thread group CPU time accounting.
  */
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
+void thread_group_cputime_nodelta(struct task_struct *tsk, struct task_cputime *times,
+                                  unsigned long long *delta);
 void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 67d0465..fe330f7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2661,23 +2661,37 @@ unsigned long long task_delta_exec(struct task_struct *p)
 
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
-       ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+       ns = p->se.sum_exec_runtime;
+       *delta = do_task_delta_exec(p, rq);
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
+       unsigned long long delta;
+       u64 ns = task_sched_runtime_nodelta(p, &delta);
+       ns += delta;
+       return ns;
+}
+
+/*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
  */
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index e93cca9..1217eca 100644
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
+                                 unsigned long long *delta)
 {
        struct signal_struct *sig = tsk->signal;
        cputime_t utime, stime;
        struct task_struct *t;
+       unsigned long long d = 0;
+       unsigned long long td;
 
        times->utime = sig->utime;
        times->stime = sig->stime;
@@ -313,10 +312,46 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
                task_cputime(t, &utime, &stime);
                times->utime += utime;
                times->stime += stime;
-               times->sum_exec_runtime += task_sched_runtime(t);
+               times->sum_exec_runtime += task_sched_runtime_nodelta(t, &td);
+               d += td;
        } while_each_thread(tsk, t);
 out:
        rcu_read_unlock();
+
+       if (delta)
+               *delta = d;
+}
+
+/*
+ * Accumulate raw cputime values of dead tasks (sig->[us]time) and live
+ * tasks (sum on group iteration) belonging to @tsk's group.
+ */
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+{
+       unsigned long long d;
+       thread_group_cputime_nodelta(tsk, times, &d);
+       times->sum_exec_runtime += d;
+}
+
+
+unsigned long long group_delta_exec(struct task_struct *tsk)
+{
+       unsigned long long ns = 0;
+       struct task_struct *t;
+
+       rcu_read_lock();
+       /* make sure we can trust tsk->thread_group list */
+       if (!likely(pid_alive(tsk)))
+               goto out;
+
+       t = tsk;
+       do {
+               ns += task_delta_exec(t);
+       } while_each_thread(tsk, t);
+out:
+       rcu_read_unlock();
+
+       return ns;
 }
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
-- 
1.8.2.1


