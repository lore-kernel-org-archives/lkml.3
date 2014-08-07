Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaHGRsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:48:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40357 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaHGRsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:48:37 -0400
Date: Thu, 7 Aug 2014 10:48:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140807174825.GE5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140804074620.GH9918@twins.programming.kicks-ass.net>
 <53DF41ED.2020508@cn.fujitsu.com>
 <20140804115043.GA31903@linux.vnet.ibm.com>
 <20140804122515.GR19379@twins.programming.kicks-ass.net>
 <20140804145648.GE3588@twins.programming.kicks-ass.net>
 <53E029BB.2010200@cn.fujitsu.com>
 <20140805215510.GT8101@linux.vnet.ibm.com>
 <20140807084921.GK19379@twins.programming.kicks-ass.net>
 <20140807154358.GC5821@linux.vnet.ibm.com>
 <20140807163228.GX9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807163228.GX9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080717-1542-0000-0000-000003D55BCC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 06:32:28PM +0200, Peter Zijlstra wrote:
> On Thu, Aug 07, 2014 at 08:43:58AM -0700, Paul E. McKenney wrote:
> > On Thu, Aug 07, 2014 at 10:49:21AM +0200, Peter Zijlstra wrote:
> > > On Tue, Aug 05, 2014 at 02:55:10PM -0700, Paul E. McKenney wrote:
> > > > +/* Check for nohz_full CPUs executing in userspace. */
> > > > +static void check_no_hz_full_tasks(void)
> > > > +{
> > > > +#ifdef CONFIG_NO_HZ_FULL
> > > > +	int cpu;
> > > > +	struct task_struct *t;
> > > > +
> > > > +	for_each_online_cpu(cpu) {
> > > > +		cond_resched();
> > > > +		rcu_read_lock();
> > > > +		t = rcu_dynticks_task_cur(cpu);
> > > > +		if (t == NULL || is_idle_task(t)) {
> > > > +			rcu_read_unlock();
> > > > +			continue;
> > > > +		}
> > > > +		if (ACCESS_ONCE(t->rcu_tasks_holdout))
> > > > +			ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
> > > > +		rcu_read_unlock();
> > > > +	}
> > > > +#endif /* #ifdef CONFIG_NO_HZ_FULL */
> > > > +}
> > > 
> > > That's not hotplug safe afaict, and I've no idea if someone pointed that
> > > out already because people refuse to trim email and I can't be arsed to
> > > wade through pages and pages of quoting.
> > 
> > Hmmm...  That does look a bit suspicious, now that you mention it.
> > After all, if a CPU is offline, its idle tasks cannot be on a
> > trampoline.
> 
> But what about a CPU that in the process of getting on-line, it started
> when there still were trampolines but hasn't quite made it to full
> 'online' status when you do this check.

Well, one easy approach would be to exclude CPU hotplug during that time.

> Similar for going offline I suppose, we start to go offline when there
> were still trampolines and got missed in that check because we already
> cleared the 'online' bit but we're not quite dead yet.

Yep, same issue here.

> I couldn't find any serialization against either on or off lining of
> CPUs.

Yep, I need to fix this.  The most straightforward approach seems to be
use of cpu_maps_update_begin() like in the following patch.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Make RCU-tasks wait for idle tasks

Because idle-task code may need to be patched, RCU-tasks need to wait
for idle tasks to schedule.  This commit therefore detects this case
via RCU's dyntick-idle counters.  Block CPU hotplug during this time
to avoid sending IPIs to offline CPUs.

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
index 069c06fd6a79..637f8c7fc0c2 100644
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
@@ -578,6 +581,26 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 		rcu_read_unlock();
 
 		/*
+		 * Next, queue up any currently running idle tasks.
+		 * Exclude CPU hotplug during the time we are working
+		 * with idle tasks, as it is considered bad form to
+		 * send IPIs to offline CPUs.
+		 */
+		cpu_maps_update_begin();
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
+		/*
 		 * Wait for tasks that are in the process of exiting.
 		 * This does only part of the job, ensuring that all
 		 * tasks that were previously exiting reach the point
@@ -613,6 +636,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 				cond_resched();
 			}
 		}
+		cpu_maps_update_done();
 
 		/*
 		 * Because ->on_rq and ->nvcsw are not guaranteed

