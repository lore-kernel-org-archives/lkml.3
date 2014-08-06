Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaHGGpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:45:22 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36354 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbaHGGo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:44:58 -0400
Date: Wed, 6 Aug 2014 15:45:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140806224518.GA8101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140801150926.GA845@redhat.com>
 <20140801183251.GJ4784@linux.vnet.ibm.com>
 <20140801194417.GA27141@linux.vnet.ibm.com>
 <20140802144719.GA18018@redhat.com>
 <20140802225857.GC8101@linux.vnet.ibm.com>
 <20140805205711.7a52076c@gandalf.local.home>
 <20140806012139.GY8101@linux.vnet.ibm.com>
 <20140806084708.GR9918@twins.programming.kicks-ass.net>
 <20140806120958.GZ8101@linux.vnet.ibm.com>
 <20140806163035.GG19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806163035.GG19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080706-1542-0000-0000-000003D1BB98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 06:30:35PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 06, 2014 at 05:09:59AM -0700, Paul E. McKenney wrote:
> 
> > > Or you could shoot all CPUs with resched_cpu() which would have them
> > > cycle through schedule() even if there's nothing but the idle thread to
> > > run. That guarantees they'll go to sleep again in a !trampoline.
> > 
> > Good point, that would be an easier way to handle the idle threads than
> > messing with rcu_tasks_kthread()'s affinity.  Thank you!
> 
> One issue though, resched_cpu() doesn't wait for that to complete. We'd
> need something that would guarantee the remote CPU has actually
> completed execution.

Not a problem in the idle case.  Forcing the CPU out of the idle loop
will invoke rcu_idle_exit(), which will increment ->dynticks, which
will be visible to RCU-tasks.

> > > But I still very much hate the polling stuff...

The nice thing about the polling approach is minimal overhead in the
common case where RCU-tasks is not in use.

> > > Can't we abuse the preempt notifiers? Say we make it possible to install
> > > preemption notifiers cross-task, then the task-rcu can install a
> > > preempt-out notifier which completes the rcu-task wait.
> > > 
> > > After all, since we tagged it it was !running, and being scheduled out
> > > means it ran (once) and therefore isn't on a trampoline anymore.
> > 
> > Maybe I am being overly paranoid, but couldn't the task be preempted
> > in a trampoline, be resumed, execute one instruction (still in the
> > tramopoline) and be preempted again?
> 
> Ah, what I failed to state was we should check the sleep condition. So
> 'voluntary' schedule() calls.

OK, but I already catch this via the ->nvcsw counter.  See patch below.

> Of course if we'd made something specific to the trampoline thing and
> not 'task'-rcu we could simply check if the IP was inside a trampoline
> or not.

Of course.  I suspect that there are devils in those details as well.  ;-)

> > > And the tick, which checks to see if the task got to userspace can do
> > > the same, remove the notifier and then complete.
> > 
> > My main concern with this sort of approach is that I have to deal
> > with full-up concurrency (200 CPUs all complete tasks concurrently,
> > for example), which would make for a much larger and more complex patch.
> > Now, I do admit that it is quite possible that I will end up there anyway,
> > for example, if more people start using RCU-tasks, but I see no need to
> > hurry this process.  ;-)
> 
> You mean cacheline contention on the struct completion? I'd first make
> it simple and only fix it if/when it becomes a problem.
> 
> 200 CPUs contending on a single cacheline _once_ is annoying, but
> probably still lots cheaper than polling state for at least that many
> tasks.

On larger systems, memory contention can reportedly be more than merely
annoying.

							Thanx, Paul

------------------------------------------------------------------------

 include/linux/rcupdate.h |    6 +++---
 include/linux/rcutiny.h  |    6 +++++-
 include/linux/rcutree.h  |    2 ++
 include/linux/sched.h    |    1 +
 kernel/rcu/tree.c        |   10 ++++++++++
 kernel/rcu/tree.h        |    4 ++--
 kernel/rcu/tree_plugin.h |    4 ++--
 kernel/rcu/update.c      |   27 ++++++++++++++++++++++-----
 8 files changed, 47 insertions(+), 13 deletions(-)

rcu: Make RCU-tasks wait for idle tasks

Because idle-task code may need to be patched, RCU-tasks need to wait
for idle tasks to schedule.  This commit therefore detects this case
via RCU's dyntick-idle counters.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 0294fc180508..70f2b953c392 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1138,14 +1138,14 @@ static inline void rcu_sysidle_force_exit(void)
 
 #endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 
-#if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
+#if defined(CONFIG_TASKS_RCU) && !defined(CONFIG_TINY_RCU)
 struct task_struct *rcu_dynticks_task_cur(int cpu);
-#else /* #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
+#else /* #if defined(CONFIG_TASKS_RCU) && !defined(CONFIG_TINY_RCU) */
 static inline struct task_struct *rcu_dynticks_task_cur(int cpu)
 {
 	return NULL;
 }
-#endif /* #else #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
+#endif /* #else #if defined(CONFIG_TASKS_RCU) && !defined(CONFIG_TINY_RCU) */
 
 
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index d40a6a451330..b882c27cd314 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -154,7 +154,11 @@ static inline bool rcu_is_watching(void)
 	return true;
 }
 
-
 #endif /* #else defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
 
+static inline unsigned int rcu_dynticks_ctr(int cpu)
+{
+	return 0;
+}
+
 #endif /* __LINUX_RCUTINY_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3e2f5d432743..0d8fdfcb4f0b 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -97,4 +97,6 @@ extern int rcu_scheduler_active __read_mostly;
 
 bool rcu_is_watching(void);
 
+unsigned int rcu_dynticks_ctr(int cpu);
+
 #endif /* __LINUX_RCUTREE_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3cf124389ec7..db4e6cb8fb77 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1277,6 +1277,7 @@ struct task_struct {
 	unsigned long rcu_tasks_nvcsw;
 	int rcu_tasks_holdout;
 	struct list_head rcu_tasks_holdout_list;
+	unsigned int rcu_tasks_dynticks;
 #endif /* #ifdef CONFIG_TASKS_RCU */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 86a0a7d5bbbd..6298a66118e5 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -493,6 +493,16 @@ cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
+ * rcu_dynticks_ctr - return value of the specified CPU's dynticks counter
+ */
+unsigned int rcu_dynticks_ctr(int cpu)
+{
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+
+	return atomic_add_return(0, &rdtp->dynticks);
+}
+
+/*
  * rcu_eqs_enter_common - current CPU is moving towards extended quiescent state
  *
  * If the new value of the ->dynticks_nesting counter now is zero,
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 1e79fa1b7cbf..e373f8ddc60a 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -88,9 +88,9 @@ struct rcu_dynticks {
 				    /* Process level is worth LLONG_MAX/2. */
 	int dynticks_nmi_nesting;   /* Track NMI nesting level. */
 	atomic_t dynticks;	    /* Even value for idle, else odd. */
-#if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
+#if defined(CONFIG_TASKS_RCU)
 	struct task_struct *dynticks_tsk;
-#endif /* #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
+#endif /* #if defined(CONFIG_TASKS_RCU) */
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
 	long long dynticks_idle_nesting;
 				    /* irq/process nesting level from idle. */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 442d62edc564..381cb93ad3fa 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2868,7 +2868,7 @@ static void rcu_dynticks_task_exit(struct rcu_dynticks *rdtp)
 	rcu_dynticks_task_enter(rdtp, NULL);
 }
 
-#if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
+#if defined(CONFIG_TASKS_RCU) && !defined(CONFIG_TINY_RCU)
 struct task_struct *rcu_dynticks_task_cur(int cpu)
 {
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
@@ -2877,4 +2877,4 @@ struct task_struct *rcu_dynticks_task_cur(int cpu)
 	smp_read_barrier_depends(); /* Dereferences after fetch of "t". */
 	return t;
 }
-#endif /* #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
+#endif /* #if defined(CONFIG_TASKS_RCU) && !defined(CONFIG_TINY_RCU) */
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 069c06fd6a79..6a6a4c80c553 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -48,6 +48,7 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/kthread.h>
+#include "../sched/sched.h" /* cpu_rq()->idle */
 
 #define CREATE_TRACE_POINTS
 
@@ -484,7 +485,6 @@ static void check_holdout_task(struct task_struct *t,
 /* Check for nohz_full CPUs executing in userspace. */
 static void check_no_hz_full_tasks(void)
 {
-#ifdef CONFIG_NO_HZ_FULL
 	int cpu;
 	struct task_struct *t;
 
@@ -492,7 +492,11 @@ static void check_no_hz_full_tasks(void)
 		cond_resched();
 		rcu_read_lock();
 		t = rcu_dynticks_task_cur(cpu);
-		if (t == NULL || is_idle_task(t)) {
+		if (t == NULL ||
+		    (is_idle_task(t) &&
+		     t->rcu_tasks_dynticks == rcu_dynticks_ctr(cpu))) {
+			if (t != NULL)
+				resched_cpu(cpu); /* Kick idle task. */
 			rcu_read_unlock();
 			continue;
 		}
@@ -500,12 +504,12 @@ static void check_no_hz_full_tasks(void)
 			ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
 		rcu_read_unlock();
 	}
-#endif /* #ifdef CONFIG_NO_HZ_FULL */
 }
 
 /* RCU-tasks kthread that detects grace periods and invokes callbacks. */
 static int __noreturn rcu_tasks_kthread(void *arg)
 {
+	int cpu;
 	unsigned long flags;
 	struct task_struct *g, *t;
 	unsigned long lastreport;
@@ -566,8 +570,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 		 */
 		rcu_read_lock();
 		for_each_process_thread(g, t) {
-			if (t != current && ACCESS_ONCE(t->on_rq) &&
-			    !is_idle_task(t)) {
+			if (t != current && ACCESS_ONCE(t->on_rq)) {
 				get_task_struct(t);
 				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
 				ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
@@ -577,6 +580,20 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 		}
 		rcu_read_unlock();
 
+		/* Next, queue up any currently running idle tasks. */
+		for_each_online_cpu(cpu) {
+			t = cpu_rq(cpu)->idle;
+			if (t == rcu_dynticks_task_cur(cpu)) {
+				list_add(&t->rcu_tasks_holdout_list,
+					 &rcu_tasks_holdouts);
+				t->rcu_tasks_dynticks = rcu_dynticks_ctr(cpu);
+				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
+				ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
+				list_add(&t->rcu_tasks_holdout_list,
+					 &rcu_tasks_holdouts);
+			}
+		}
+
 		/*
 		 * Wait for tasks that are in the process of exiting.
 		 * This does only part of the job, ensuring that all

