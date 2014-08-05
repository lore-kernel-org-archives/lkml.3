Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaHEVzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:55:18 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36817 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbaHEVzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:55:16 -0400
Date: Tue, 5 Aug 2014 14:55:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140805215510.GT8101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53DEE1CD.4000705@cn.fujitsu.com>
 <20140804074620.GH9918@twins.programming.kicks-ass.net>
 <53DF41ED.2020508@cn.fujitsu.com>
 <20140804115043.GA31903@linux.vnet.ibm.com>
 <20140804122515.GR19379@twins.programming.kicks-ass.net>
 <20140804145648.GE3588@twins.programming.kicks-ass.net>
 <53E029BB.2010200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E029BB.2010200@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080521-6688-0000-0000-000003CACC23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 08:47:55AM +0800, Lai Jiangshan wrote:
> On 08/04/2014 10:56 PM, Peter Zijlstra wrote:
> > On Mon, Aug 04, 2014 at 02:25:15PM +0200, Peter Zijlstra wrote:
> >> On Mon, Aug 04, 2014 at 04:50:44AM -0700, Paul E. McKenney wrote:
> >>> OK, I will bite...
> >>>
> >>> What kinds of tasks are on a runqueue, but neither ->on_cpu nor
> >>> PREEMPT_ACTIVE?
> >>
> >> Userspace tasks, they don't necessarily get PREEMPT_ACTIVE when
> >> preempted. Now obviously you're not _that_ interested in userspace tasks
> >> for this, so that might be ok.
> >>
> >> But the main point was, you cannot use ->on_cpu or PREEMPT_ACTIVE
> >> without holding rq->lock.
> > 
> > Hmm, maybe you can, we have the context switch in between setting
> > ->on_cpu and clearing PREEMPT_ACTIVE and vice-versa.
> > 
> > The context switch (obviously) provides a full barrier, so we might be
> > able to -- with careful consideration -- read these two separate values
> > and construct something usable from them.
> > 
> > Something like:
> > 
> > 	task_preempt_count(tsk) & PREEMPT_ACTIVE
> 	the @tsk is running on_cpu, the above result is false.
> > 	smp_rmb();
> > 	tsk->on_cpu
> 	now the @tsk is preempted, the above result also is false.
> 
> 	so it is useless if we fetch the preempt_count and on_cpu in two separated
> instructions.  Maybe it would work if we also take tsk->nivcsw in consideration.
> (I just noticed that tsk->n[i]vcsw are the version numbers for the tsk->on_cpu)
> 
> bool task_on_cpu_or_preempted(tsk)
> {
> 	unsigned long saved_nivcsw;
> 
> 	saved_nivcsw = task->nivcsw;
> 	if (tsk->on_cpu)
> 		return true;
> 
> 	smp_rmb();
> 
> 	if (task_preempt_count(tsk) & PREEMPT_ACTIVE)
> 		return true;
> 
> 	smp_rmb();
> 
> 	if (tsk->on_cpu || task->nivcsw != saved_nivcsw)
> 		return true;
> 
> 	return false;
> }
> 
> > 
> > And because we set PREEMPT_ACTIVE before clearing on_cpu, this should
> > race the right way (err towards the inclusive side).
> > 
> > Obviously that wants a big fat comment...

How about the following?  Non-nohz_full userspace tasks are already covered
courtesy of scheduling-clock interrupts, and this handles nohz_full usermode
tasks.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Make TASKS_RCU handle nohx_full= CPUs

Currently TASKS_RCU would ignore a CPU running a task in nohz_full=
usermode execution.  There would be neither a context switch nor a
scheduling-clock interrupt to tell TASKS_RCU that the task in question
had passed through a quiescent state.  The grace period would therefore
extend indefinitely.  This commit therefore makes RCU's dyntick-idle
subsystem record the task_struct structure of the task that is running
in dyntick-idle mode on each CPU.  The TASKS_RCU grace period can
then access this information and record a quiescent state on
behalf of any CPU running in dyntick-idle usermode.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index f504f797c9c8..777aac3a34c0 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1140,5 +1140,14 @@ static inline void rcu_sysidle_force_exit(void)
 
 #endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 
+#if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
+struct task_struct *rcu_dynticks_task_cur(int cpu);
+#else /* #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
+static inline struct task_struct *rcu_dynticks_task_cur(int cpu)
+{
+	return NULL;
+}
+#endif /* #else #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
+
 
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 645a33efc0d4..86a0a7d5bbbd 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -526,6 +526,7 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 	atomic_inc(&rdtp->dynticks);
 	smp_mb__after_atomic();  /* Force ordering with next sojourn. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+	rcu_dynticks_task_enter(rdtp, current);
 
 	/*
 	 * It is illegal to enter an extended quiescent state while
@@ -642,6 +643,7 @@ void rcu_irq_exit(void)
 static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
 			       int user)
 {
+	rcu_dynticks_task_exit(rdtp);
 	smp_mb__before_atomic();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 0f69a79c5b7d..1e79fa1b7cbf 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -88,6 +88,9 @@ struct rcu_dynticks {
 				    /* Process level is worth LLONG_MAX/2. */
 	int dynticks_nmi_nesting;   /* Track NMI nesting level. */
 	atomic_t dynticks;	    /* Even value for idle, else odd. */
+#if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
+	struct task_struct *dynticks_tsk;
+#endif /* #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
 	long long dynticks_idle_nesting;
 				    /* irq/process nesting level from idle. */
@@ -579,6 +582,9 @@ static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 static void rcu_bind_gp_kthread(void);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
 static bool rcu_nohz_full_cpu(struct rcu_state *rsp);
+static void rcu_dynticks_task_enter(struct rcu_dynticks *rdtp,
+				    struct task_struct *t);
+static void rcu_dynticks_task_exit(struct rcu_dynticks *rdtp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a86a363ea453..442d62edc564 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2852,3 +2852,29 @@ static void rcu_bind_gp_kthread(void)
 		set_cpus_allowed_ptr(current, cpumask_of(cpu));
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 }
+
+/* Record the current task on dyntick-idle entry. */
+static void rcu_dynticks_task_enter(struct rcu_dynticks *rdtp,
+				    struct task_struct *t)
+{
+#if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
+	ACCESS_ONCE(rdtp->dynticks_tsk) = t;
+#endif /* #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
+}
+
+/* Record no current task on dyntick-idle exit. */
+static void rcu_dynticks_task_exit(struct rcu_dynticks *rdtp)
+{
+	rcu_dynticks_task_enter(rdtp, NULL);
+}
+
+#if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
+struct task_struct *rcu_dynticks_task_cur(int cpu)
+{
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+	struct task_struct *t = ACCESS_ONCE(rdtp->dynticks_tsk);
+
+	smp_read_barrier_depends(); /* Dereferences after fetch of "t". */
+	return t;
+}
+#endif /* #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index ad2a8df43757..6ad6af2ab028 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -481,6 +481,28 @@ static void check_holdout_task(struct task_struct *t,
 	sched_show_task(current);
 }
 
+/* Check for nohz_full CPUs executing in userspace. */
+static void check_no_hz_full_tasks(void)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	int cpu;
+	struct task_struct *t;
+
+	for_each_online_cpu(cpu) {
+		cond_resched();
+		rcu_read_lock();
+		t = rcu_dynticks_task_cur(cpu);
+		if (t == NULL || is_idle_task(t)) {
+			rcu_read_unlock();
+			continue;
+		}
+		if (ACCESS_ONCE(t->rcu_tasks_holdout))
+			ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
+		rcu_read_unlock();
+	}
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+}
+
 /* RCU-tasks kthread that detects grace periods and invokes callbacks. */
 static int __noreturn rcu_tasks_kthread(void *arg)
 {
@@ -584,6 +606,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 				lastreport = jiffies;
 			firstreport = true;
 			WARN_ON(signal_pending(current));
+			check_no_hz_full_tasks();
 			rcu_read_lock();
 			list_for_each_entry_rcu(t, &rcu_tasks_holdouts,
 						rcu_tasks_holdout_list)

