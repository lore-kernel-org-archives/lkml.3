Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab3BSNtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:49:51 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:56973 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795Ab3BSNts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:49:48 -0500
Date: Tue, 19 Feb 2013 14:49:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.9
Message-ID: <20130219134943.GA12141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   HEAD: ac0e32024b8f40987b3db7d2defdc6b5153ba354 Merge branch 'rcu/srcu' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

SRCU changes:

  - These include debugging aids, updates that move towards 
    the goal of permitting srcu_read_lock() and 
    srcu_read_unlock() to be used from idle and offline CPUs, 
    and a few small fixes.

Changes to rcutorture and to RCU documentation:

  - Posted to LKML at https://lkml.org/lkml/2013/1/26/188
    
Enhancements to uniprocessor handling in tiny RCU:

  - Posted to LKML at https://lkml.org/lkml/2013/1/27/2
    
Tag RCU callbacks with grace-period number to simplify callback 
advancement:

  - Posted to LKML at https://lkml.org/lkml/2013/1/26/203

Miscellaneous fixes:

  - Posted to LKML at https://lkml.org/lkml/2013/1/26/204


 Thanks,

	Ingo

------------------>
Cody P Schafer (1):
      rcu: Correct 'optimized' to 'optimize' in header comment

Dave Hansen (1):
      rcu: Consolidate debugging Kconfig options

Frederic Weisbecker (1):
      context_tracking: Add comments on interface and internals

Josh Triplett (1):
      rcu: Make rcu_is_cpu_rrupt_from_idle helper functions static

Lai Jiangshan (8):
      srcu: Simplify __srcu_read_unlock() via this_cpu_dec()
      srcu: Add might_sleep() annotation to synchronize_srcu()
      srcu: Simple cleanup for cleanup_srcu_struct()
      srcu: Remove checks preventing offline CPUs from calling srcu_read_lock()
      srcu: Remove checks preventing idle CPUs from calling srcu_read_lock()
      srcu: Update synchronize_srcu()'s comments
      srcu: Update synchronize_srcu_expedited()'s comments
      srcu: use ACCESS_ONCE() to access sp->completed in srcu_read_lock()

Li Zhong (2):
      rcu: Use new nesting value for rcu_dyntick trace in rcu_eqs_enter_common
      rcu: Remove unused code originally used for context tracking

Paul E. McKenney (10):
      tracing: Export trace_clock_local()
      rcu: Reduce rcutorture tracing
      rcu: Fix blimit type for trace_rcu_batch_start()
      rcu: Silence compiler array out-of-bounds false positive
      rcu: Tag callback lists with corresponding grace-period number
      rcu: Trace callback acceleration
      rcu: Remove obsolete Kconfig option from comment
      rcu: Provide RCU CPU stall warnings for tiny RCU
      rcu: Allow TREE_PREEMPT_RCU on UP systems
      rcu: Make rcutorture's shuffler task shuffle recently added tasks

Paul Gortmaker (2):
      rcu: Prevent soft-lockup complaints about no-CBs CPUs
      rcu: Make rcu_nocb_poll an early_param instead of module_param

Richard Braun (1):
      Documentation: Memory barrier semantics of atomic_xchg()

Sasha Levin (1):
      rcutorture: Don't compare ptr with 0

Steven Rostedt (1):
      rcu: Allow rcutorture to be built at low optimization levels


 Documentation/atomic_ops.txt        |   2 +
 Documentation/kernel-parameters.txt |   2 +-
 Documentation/memory-barriers.txt   |   1 +
 include/linux/rcupdate.h            |  15 ++-
 include/linux/srcu.h                |  26 +---
 include/trace/events/rcu.h          |  31 +++--
 init/Kconfig                        |  12 +-
 kernel/context_tracking.c           |  75 +++++++++--
 kernel/rcu.h                        |   7 +
 kernel/rcupdate.c                   |  60 ++++++++-
 kernel/rcutiny.c                    |   8 +-
 kernel/rcutiny_plugin.h             |  56 ++++++++
 kernel/rcutorture.c                 |  66 +++++++--
 kernel/rcutree.c                    | 260 +++++++++++++++++++++++++-----------
 kernel/rcutree.h                    |  11 +-
 kernel/rcutree_plugin.h             |  13 +-
 kernel/srcu.c                       |  37 +++--
 kernel/trace/trace_clock.c          |   1 +
 lib/Kconfig.debug                   | 117 ++++++++--------
 19 files changed, 567 insertions(+), 233 deletions(-)

diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index 27f2b21..d9ca5be 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -253,6 +253,8 @@ This performs an atomic exchange operation on the atomic variable v, setting
 the given new value.  It returns the old value that the atomic variable v had
 just before the operation.
 
+atomic_xchg requires explicit memory barriers around the operation.
+
 	int atomic_cmpxchg(atomic_t *v, int old, int new);
 
 This performs an atomic compare exchange operation on the atomic value v,
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 363e348..6c72381 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2438,7 +2438,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			real-time workloads.  It can also improve energy
 			efficiency for asymmetric multiprocessors.
 
-	rcu_nocbs_poll	[KNL,BOOT]
+	rcu_nocb_poll	[KNL,BOOT]
 			Rather than requiring that offloaded CPUs
 			(specified by rcu_nocbs= above) explicitly
 			awaken the corresponding "rcuoN" kthreads,
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 3c4e1b3..fa5d8a9 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1685,6 +1685,7 @@ explicit lock operations, described later).  These include:
 
 	xchg();
 	cmpxchg();
+	atomic_xchg();
 	atomic_cmpxchg();
 	atomic_inc_return();
 	atomic_dec_return();
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 275aa3f..b758ce1 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -53,7 +53,10 @@ extern int rcutorture_runnable; /* for sysctl */
 extern void rcutorture_record_test_transition(void);
 extern void rcutorture_record_progress(unsigned long vernum);
 extern void do_trace_rcu_torture_read(char *rcutorturename,
-				      struct rcu_head *rhp);
+				      struct rcu_head *rhp,
+				      unsigned long secs,
+				      unsigned long c_old,
+				      unsigned long c);
 #else
 static inline void rcutorture_record_test_transition(void)
 {
@@ -63,9 +66,13 @@ static inline void rcutorture_record_progress(unsigned long vernum)
 }
 #ifdef CONFIG_RCU_TRACE
 extern void do_trace_rcu_torture_read(char *rcutorturename,
-				      struct rcu_head *rhp);
+				      struct rcu_head *rhp,
+				      unsigned long secs,
+				      unsigned long c_old,
+				      unsigned long c);
 #else
-#define do_trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
+#define do_trace_rcu_torture_read(rcutorturename, rhp, secs, c_old, c) \
+	do { } while (0)
 #endif
 #endif
 
@@ -749,7 +756,7 @@ static inline void rcu_preempt_sleep_check(void)
  * preemptible RCU implementations (TREE_PREEMPT_RCU and TINY_PREEMPT_RCU)
  * in CONFIG_PREEMPT kernel builds, RCU read-side critical sections may
  * be preempted, but explicit blocking is illegal.  Finally, in preemptible
- * RCU implementations in real-time (CONFIG_PREEMPT_RT) kernel builds,
+ * RCU implementations in real-time (with -rt patchset) kernel builds,
  * RCU read-side critical sections may be preempted and they may also
  * block, but only when acquiring spinlocks that are subject to priority
  * inheritance.
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 6eb691b..04f4121 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -151,30 +151,14 @@ void srcu_barrier(struct srcu_struct *sp);
  * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
  *
- * Note that if the CPU is in the idle loop from an RCU point of view
- * (ie: that we are in the section between rcu_idle_enter() and
- * rcu_idle_exit()) then srcu_read_lock_held() returns false even if
- * the CPU did an srcu_read_lock().  The reason for this is that RCU
- * ignores CPUs that are in such a section, considering these as in
- * extended quiescent state, so such a CPU is effectively never in an
- * RCU read-side critical section regardless of what RCU primitives it
- * invokes.  This state of affairs is required --- we need to keep an
- * RCU-free window in idle where the CPU may possibly enter into low
- * power mode. This way we can notice an extended quiescent state to
- * other CPUs that started a grace period. Otherwise we would delay any
- * grace period as long as we run in the idle task.
- *
- * Similarly, we avoid claiming an SRCU read lock held if the current
- * CPU is offline.
+ * Note that SRCU is based on its own statemachine and it doesn't
+ * relies on normal RCU, it can be called from the CPU which
+ * is in the idle loop from an RCU point of view or offline.
  */
 static inline int srcu_read_lock_held(struct srcu_struct *sp)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
-	if (rcu_is_cpu_idle())
-		return 0;
-	if (!rcu_lockdep_current_cpu_online())
-		return 0;
 	return lock_is_held(&sp->dep_map);
 }
 
@@ -236,8 +220,6 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 	int retval = __srcu_read_lock(sp);
 
 	rcu_lock_acquire(&(sp)->dep_map);
-	rcu_lockdep_assert(!rcu_is_cpu_idle(),
-			   "srcu_read_lock() used illegally while idle");
 	return retval;
 }
 
@@ -251,8 +233,6 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__releases(sp)
 {
-	rcu_lockdep_assert(!rcu_is_cpu_idle(),
-			   "srcu_read_unlock() used illegally while idle");
 	rcu_lock_release(&(sp)->dep_map);
 	__srcu_read_unlock(sp, idx);
 }
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index d4f559b..1918e83 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -44,8 +44,10 @@ TRACE_EVENT(rcu_utilization,
  * of a new grace period or the end of an old grace period ("cpustart"
  * and "cpuend", respectively), a CPU passing through a quiescent
  * state ("cpuqs"), a CPU coming online or going offline ("cpuonl"
- * and "cpuofl", respectively), and a CPU being kicked for being too
- * long in dyntick-idle mode ("kick").
+ * and "cpuofl", respectively), a CPU being kicked for being too
+ * long in dyntick-idle mode ("kick"), a CPU accelerating its new
+ * callbacks to RCU_NEXT_READY_TAIL ("AccReadyCB"), and a CPU
+ * accelerating its new callbacks to RCU_WAIT_TAIL ("AccWaitCB").
  */
 TRACE_EVENT(rcu_grace_period,
 
@@ -393,7 +395,7 @@ TRACE_EVENT(rcu_kfree_callback,
  */
 TRACE_EVENT(rcu_batch_start,
 
-	TP_PROTO(char *rcuname, long qlen_lazy, long qlen, int blimit),
+	TP_PROTO(char *rcuname, long qlen_lazy, long qlen, long blimit),
 
 	TP_ARGS(rcuname, qlen_lazy, qlen, blimit),
 
@@ -401,7 +403,7 @@ TRACE_EVENT(rcu_batch_start,
 		__field(char *, rcuname)
 		__field(long, qlen_lazy)
 		__field(long, qlen)
-		__field(int, blimit)
+		__field(long, blimit)
 	),
 
 	TP_fast_assign(
@@ -411,7 +413,7 @@ TRACE_EVENT(rcu_batch_start,
 		__entry->blimit = blimit;
 	),
 
-	TP_printk("%s CBs=%ld/%ld bl=%d",
+	TP_printk("%s CBs=%ld/%ld bl=%ld",
 		  __entry->rcuname, __entry->qlen_lazy, __entry->qlen,
 		  __entry->blimit)
 );
@@ -523,22 +525,30 @@ TRACE_EVENT(rcu_batch_end,
  */
 TRACE_EVENT(rcu_torture_read,
 
-	TP_PROTO(char *rcutorturename, struct rcu_head *rhp),
+	TP_PROTO(char *rcutorturename, struct rcu_head *rhp,
+		 unsigned long secs, unsigned long c_old, unsigned long c),
 
-	TP_ARGS(rcutorturename, rhp),
+	TP_ARGS(rcutorturename, rhp, secs, c_old, c),
 
 	TP_STRUCT__entry(
 		__field(char *, rcutorturename)
 		__field(struct rcu_head *, rhp)
+		__field(unsigned long, secs)
+		__field(unsigned long, c_old)
+		__field(unsigned long, c)
 	),
 
 	TP_fast_assign(
 		__entry->rcutorturename = rcutorturename;
 		__entry->rhp = rhp;
+		__entry->secs = secs;
+		__entry->c_old = c_old;
+		__entry->c = c;
 	),
 
-	TP_printk("%s torture read %p",
-		  __entry->rcutorturename, __entry->rhp)
+	TP_printk("%s torture read %p %luus c: %lu %lu",
+		  __entry->rcutorturename, __entry->rhp,
+		  __entry->secs, __entry->c_old, __entry->c)
 );
 
 /*
@@ -608,7 +618,8 @@ TRACE_EVENT(rcu_barrier,
 #define trace_rcu_invoke_kfree_callback(rcuname, rhp, offset) do { } while (0)
 #define trace_rcu_batch_end(rcuname, callbacks_invoked, cb, nr, iit, risk) \
 	do { } while (0)
-#define trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
+#define trace_rcu_torture_read(rcutorturename, rhp, secs, c_old, c) \
+	do { } while (0)
 #define trace_rcu_barrier(name, s, cpu, cnt, done) do { } while (0)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
diff --git a/init/Kconfig b/init/Kconfig
index be8b7f5..b023334 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -453,7 +453,7 @@ config TREE_RCU
 
 config TREE_PREEMPT_RCU
 	bool "Preemptible tree-based hierarchical RCU"
-	depends on PREEMPT && SMP
+	depends on PREEMPT
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP systems with hundreds or
@@ -461,6 +461,8 @@ config TREE_PREEMPT_RCU
 	  is also required.  It also scales down nicely to
 	  smaller systems.
 
+	  Select this option if you are unsure.
+
 config TINY_RCU
 	bool "UP-only small-memory-footprint RCU"
 	depends on !PREEMPT && !SMP
@@ -486,6 +488,14 @@ config PREEMPT_RCU
 	  This option enables preemptible-RCU code that is common between
 	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
 
+config RCU_STALL_COMMON
+	def_bool ( TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE )
+	help
+	  This option enables RCU CPU stall code that is common between
+	  the TINY and TREE variants of RCU.  The purpose is to allow
+	  the tiny variants to disable RCU CPU stall warnings, while
+	  making these warnings mandatory for the tree variants.
+
 config CONTEXT_TRACKING
        bool
 
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index e0e07fd..d566aba 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -1,3 +1,19 @@
+/*
+ * Context tracking: Probe on high level context boundaries such as kernel
+ * and userspace. This includes syscalls and exceptions entry/exit.
+ *
+ * This is used by RCU to remove its dependency on the timer tick while a CPU
+ * runs in userspace.
+ *
+ *  Started by Frederic Weisbecker:
+ *
+ * Copyright (C) 2012 Red Hat, Inc., Frederic Weisbecker <fweisbec@redhat.com>
+ *
+ * Many thanks to Gilad Ben-Yossef, Paul McKenney, Ingo Molnar, Andrew Morton,
+ * Steven Rostedt, Peter Zijlstra for suggestions and improvements.
+ *
+ */
+
 #include <linux/context_tracking.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
@@ -6,8 +22,8 @@
 
 struct context_tracking {
 	/*
-	 * When active is false, hooks are not set to
-	 * minimize overhead: TIF flags are cleared
+	 * When active is false, probes are unset in order
+	 * to minimize overhead: TIF flags are cleared
 	 * and calls to user_enter/exit are ignored. This
 	 * may be further optimized using static keys.
 	 */
@@ -24,6 +40,15 @@ static DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
 #endif
 };
 
+/**
+ * user_enter - Inform the context tracking that the CPU is going to
+ *              enter userspace mode.
+ *
+ * This function must be called right before we switch from the kernel
+ * to userspace, when it's guaranteed the remaining kernel instructions
+ * to execute won't use any RCU read side critical section because this
+ * function sets RCU in extended quiescent state.
+ */
 void user_enter(void)
 {
 	unsigned long flags;
@@ -39,40 +64,70 @@ void user_enter(void)
 	if (in_interrupt())
 		return;
 
+	/* Kernel threads aren't supposed to go to userspace */
 	WARN_ON_ONCE(!current->mm);
 
 	local_irq_save(flags);
 	if (__this_cpu_read(context_tracking.active) &&
 	    __this_cpu_read(context_tracking.state) != IN_USER) {
 		__this_cpu_write(context_tracking.state, IN_USER);
+		/*
+		 * At this stage, only low level arch entry code remains and
+		 * then we'll run in userspace. We can assume there won't be
+		 * any RCU read-side critical section until the next call to
+		 * user_exit() or rcu_irq_enter(). Let's remove RCU's dependency
+		 * on the tick.
+		 */
 		rcu_user_enter();
 	}
 	local_irq_restore(flags);
 }
 
+
+/**
+ * user_exit - Inform the context tracking that the CPU is
+ *             exiting userspace mode and entering the kernel.
+ *
+ * This function must be called after we entered the kernel from userspace
+ * before any use of RCU read side critical section. This potentially include
+ * any high level kernel code like syscalls, exceptions, signal handling, etc...
+ *
+ * This call supports re-entrancy. This way it can be called from any exception
+ * handler without needing to know if we came from userspace or not.
+ */
 void user_exit(void)
 {
 	unsigned long flags;
 
-	/*
-	 * Some contexts may involve an exception occuring in an irq,
-	 * leading to that nesting:
-	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
-	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
-	 * helpers are enough to protect RCU uses inside the exception. So
-	 * just return immediately if we detect we are in an IRQ.
-	 */
 	if (in_interrupt())
 		return;
 
 	local_irq_save(flags);
 	if (__this_cpu_read(context_tracking.state) == IN_USER) {
 		__this_cpu_write(context_tracking.state, IN_KERNEL);
+		/*
+		 * We are going to run code that may use RCU. Inform
+		 * RCU core about that (ie: we may need the tick again).
+		 */
 		rcu_user_exit();
 	}
 	local_irq_restore(flags);
 }
 
+
+/**
+ * context_tracking_task_switch - context switch the syscall callbacks
+ * @prev: the task that is being switched out
+ * @next: the task that is being switched in
+ *
+ * The context tracking uses the syscall slow path to implement its user-kernel
+ * boundaries probes on syscalls. This way it doesn't impact the syscall fast
+ * path on CPUs that don't do context tracking.
+ *
+ * But we need to clear the flag on the previous task because it may later
+ * migrate to some CPU that doesn't do the context tracking. As such the TIF
+ * flag may not be desired there.
+ */
 void context_tracking_task_switch(struct task_struct *prev,
 			     struct task_struct *next)
 {
diff --git a/kernel/rcu.h b/kernel/rcu.h
index 20dfba5..7f8e759 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -111,4 +111,11 @@ static inline bool __rcu_reclaim(char *rn, struct rcu_head *head)
 
 extern int rcu_expedited;
 
+#ifdef CONFIG_RCU_STALL_COMMON
+
+extern int rcu_cpu_stall_suppress;
+int rcu_jiffies_till_stall_check(void);
+
+#endif /* #ifdef CONFIG_RCU_STALL_COMMON */
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a2cf761..48ab703 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -404,11 +404,65 @@ EXPORT_SYMBOL_GPL(rcuhead_debug_descr);
 #endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU) || defined(CONFIG_RCU_TRACE)
-void do_trace_rcu_torture_read(char *rcutorturename, struct rcu_head *rhp)
+void do_trace_rcu_torture_read(char *rcutorturename, struct rcu_head *rhp,
+			       unsigned long secs,
+			       unsigned long c_old, unsigned long c)
 {
-	trace_rcu_torture_read(rcutorturename, rhp);
+	trace_rcu_torture_read(rcutorturename, rhp, secs, c_old, c);
 }
 EXPORT_SYMBOL_GPL(do_trace_rcu_torture_read);
 #else
-#define do_trace_rcu_torture_read(rcutorturename, rhp) do { } while (0)
+#define do_trace_rcu_torture_read(rcutorturename, rhp, secs, c_old, c) \
+	do { } while (0)
 #endif
+
+#ifdef CONFIG_RCU_STALL_COMMON
+
+#ifdef CONFIG_PROVE_RCU
+#define RCU_STALL_DELAY_DELTA	       (5 * HZ)
+#else
+#define RCU_STALL_DELAY_DELTA	       0
+#endif
+
+int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
+int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
+
+module_param(rcu_cpu_stall_suppress, int, 0644);
+module_param(rcu_cpu_stall_timeout, int, 0644);
+
+int rcu_jiffies_till_stall_check(void)
+{
+	int till_stall_check = ACCESS_ONCE(rcu_cpu_stall_timeout);
+
+	/*
+	 * Limit check must be consistent with the Kconfig limits
+	 * for CONFIG_RCU_CPU_STALL_TIMEOUT.
+	 */
+	if (till_stall_check < 3) {
+		ACCESS_ONCE(rcu_cpu_stall_timeout) = 3;
+		till_stall_check = 3;
+	} else if (till_stall_check > 300) {
+		ACCESS_ONCE(rcu_cpu_stall_timeout) = 300;
+		till_stall_check = 300;
+	}
+	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
+}
+
+static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
+{
+	rcu_cpu_stall_suppress = 1;
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block rcu_panic_block = {
+	.notifier_call = rcu_panic,
+};
+
+static int __init check_cpu_stall_init(void)
+{
+	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
+	return 0;
+}
+early_initcall(check_cpu_stall_init);
+
+#endif /* #ifdef CONFIG_RCU_STALL_COMMON */
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index e7dce58..a0714a5 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -51,10 +51,10 @@ static void __call_rcu(struct rcu_head *head,
 		       void (*func)(struct rcu_head *rcu),
 		       struct rcu_ctrlblk *rcp);
 
-#include "rcutiny_plugin.h"
-
 static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
+#include "rcutiny_plugin.h"
+
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
 static void rcu_idle_enter_common(long long newval)
 {
@@ -193,7 +193,7 @@ EXPORT_SYMBOL(rcu_is_cpu_idle);
  * interrupts don't count, we must be running at the first interrupt
  * level.
  */
-int rcu_is_cpu_rrupt_from_idle(void)
+static int rcu_is_cpu_rrupt_from_idle(void)
 {
 	return rcu_dynticks_nesting <= 1;
 }
@@ -205,6 +205,7 @@ int rcu_is_cpu_rrupt_from_idle(void)
  */
 static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
 {
+	reset_cpu_stall_ticks(rcp);
 	if (rcp->rcucblist != NULL &&
 	    rcp->donetail != rcp->curtail) {
 		rcp->donetail = rcp->curtail;
@@ -251,6 +252,7 @@ void rcu_bh_qs(int cpu)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
+	check_cpu_stalls();
 	if (user || rcu_is_cpu_rrupt_from_idle())
 		rcu_sched_qs(cpu);
 	else if (!in_softirq())
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index f85016a..8a23300 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -33,6 +33,9 @@ struct rcu_ctrlblk {
 	struct rcu_head **donetail;	/* ->next pointer of last "done" CB. */
 	struct rcu_head **curtail;	/* ->next pointer of last CB. */
 	RCU_TRACE(long qlen);		/* Number of pending CBs. */
+	RCU_TRACE(unsigned long gp_start); /* Start time for stalls. */
+	RCU_TRACE(unsigned long ticks_this_gp); /* Statistic for stalls. */
+	RCU_TRACE(unsigned long jiffies_stall); /* Jiffies at next stall. */
 	RCU_TRACE(char *name);		/* Name of RCU type. */
 };
 
@@ -54,6 +57,51 @@ int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+#ifdef CONFIG_RCU_TRACE
+
+static void check_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	unsigned long j;
+	unsigned long js;
+
+	if (rcu_cpu_stall_suppress)
+		return;
+	rcp->ticks_this_gp++;
+	j = jiffies;
+	js = rcp->jiffies_stall;
+	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
+		pr_err("INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
+		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
+		       jiffies - rcp->gp_start, rcp->qlen);
+		dump_stack();
+	}
+	if (*rcp->curtail && ULONG_CMP_GE(j, js))
+		rcp->jiffies_stall = jiffies +
+			3 * rcu_jiffies_till_stall_check() + 3;
+	else if (ULONG_CMP_GE(j, js))
+		rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+}
+
+static void check_cpu_stall_preempt(void);
+
+#endif /* #ifdef CONFIG_RCU_TRACE */
+
+static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
+{
+#ifdef CONFIG_RCU_TRACE
+	rcp->ticks_this_gp = 0;
+	rcp->gp_start = jiffies;
+	rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+#endif /* #ifdef CONFIG_RCU_TRACE */
+}
+
+static void check_cpu_stalls(void)
+{
+	RCU_TRACE(check_cpu_stall(&rcu_bh_ctrlblk));
+	RCU_TRACE(check_cpu_stall(&rcu_sched_ctrlblk));
+	RCU_TRACE(check_cpu_stall_preempt());
+}
+
 #ifdef CONFIG_TINY_PREEMPT_RCU
 
 #include <linux/delay.h>
@@ -448,6 +496,7 @@ static void rcu_preempt_start_gp(void)
 		/* Official start of GP. */
 		rcu_preempt_ctrlblk.gpnum++;
 		RCU_TRACE(rcu_preempt_ctrlblk.n_grace_periods++);
+		reset_cpu_stall_ticks(&rcu_preempt_ctrlblk.rcb);
 
 		/* Any blocked RCU readers block new GP. */
 		if (rcu_preempt_blocked_readers_any())
@@ -1054,4 +1103,11 @@ MODULE_AUTHOR("Paul E. McKenney");
 MODULE_DESCRIPTION("Read-Copy Update tracing for tiny implementation");
 MODULE_LICENSE("GPL");
 
+static void check_cpu_stall_preempt(void)
+{
+#ifdef CONFIG_TINY_PREEMPT_RCU
+	check_cpu_stall(&rcu_preempt_ctrlblk.rcb);
+#endif /* #ifdef CONFIG_TINY_PREEMPT_RCU */
+}
+
 #endif /* #ifdef CONFIG_RCU_TRACE */
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 31dea01..e1f3a8c 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -46,6 +46,7 @@
 #include <linux/stat.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
+#include <linux/trace_clock.h>
 #include <asm/byteorder.h>
 
 MODULE_LICENSE("GPL");
@@ -207,6 +208,20 @@ MODULE_PARM_DESC(rcutorture_runnable, "Start rcutorture at boot");
 #define rcu_can_boost() 0
 #endif /* #else #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */
 
+#ifdef CONFIG_RCU_TRACE
+static u64 notrace rcu_trace_clock_local(void)
+{
+	u64 ts = trace_clock_local();
+	unsigned long __maybe_unused ts_rem = do_div(ts, NSEC_PER_USEC);
+	return ts;
+}
+#else /* #ifdef CONFIG_RCU_TRACE */
+static u64 notrace rcu_trace_clock_local(void)
+{
+	return 0ULL;
+}
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+
 static unsigned long shutdown_time;	/* jiffies to system shutdown. */
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
 DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
@@ -845,7 +860,7 @@ static int rcu_torture_boost(void *arg)
 		/* Wait for the next test interval. */
 		oldstarttime = boost_starttime;
 		while (ULONG_CMP_LT(jiffies, oldstarttime)) {
-			schedule_timeout_uninterruptible(1);
+			schedule_timeout_interruptible(oldstarttime - jiffies);
 			rcu_stutter_wait("rcu_torture_boost");
 			if (kthread_should_stop() ||
 			    fullstop != FULLSTOP_DONTSTOP)
@@ -1028,7 +1043,6 @@ void rcutorture_trace_dump(void)
 		return;
 	if (atomic_xchg(&beenhere, 1) != 0)
 		return;
-	do_trace_rcu_torture_read(cur_ops->name, (struct rcu_head *)~0UL);
 	ftrace_dump(DUMP_ALL);
 }
 
@@ -1042,13 +1056,16 @@ static void rcu_torture_timer(unsigned long unused)
 {
 	int idx;
 	int completed;
+	int completed_end;
 	static DEFINE_RCU_RANDOM(rand);
 	static DEFINE_SPINLOCK(rand_lock);
 	struct rcu_torture *p;
 	int pipe_count;
+	unsigned long long ts;
 
 	idx = cur_ops->readlock();
 	completed = cur_ops->completed();
+	ts = rcu_trace_clock_local();
 	p = rcu_dereference_check(rcu_torture_current,
 				  rcu_read_lock_bh_held() ||
 				  rcu_read_lock_sched_held() ||
@@ -1058,7 +1075,6 @@ static void rcu_torture_timer(unsigned long unused)
 		cur_ops->readunlock(idx);
 		return;
 	}
-	do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 	if (p->rtort_mbtest == 0)
 		atomic_inc(&n_rcu_torture_mberror);
 	spin_lock(&rand_lock);
@@ -1071,10 +1087,14 @@ static void rcu_torture_timer(unsigned long unused)
 		/* Should not happen, but... */
 		pipe_count = RCU_TORTURE_PIPE_LEN;
 	}
-	if (pipe_count > 1)
+	completed_end = cur_ops->completed();
+	if (pipe_count > 1) {
+		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu, ts,
+					  completed, completed_end);
 		rcutorture_trace_dump();
+	}
 	__this_cpu_inc(rcu_torture_count[pipe_count]);
-	completed = cur_ops->completed() - completed;
+	completed = completed_end - completed;
 	if (completed > RCU_TORTURE_PIPE_LEN) {
 		/* Should not happen, but... */
 		completed = RCU_TORTURE_PIPE_LEN;
@@ -1094,11 +1114,13 @@ static int
 rcu_torture_reader(void *arg)
 {
 	int completed;
+	int completed_end;
 	int idx;
 	DEFINE_RCU_RANDOM(rand);
 	struct rcu_torture *p;
 	int pipe_count;
 	struct timer_list t;
+	unsigned long long ts;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
@@ -1112,6 +1134,7 @@ rcu_torture_reader(void *arg)
 		}
 		idx = cur_ops->readlock();
 		completed = cur_ops->completed();
+		ts = rcu_trace_clock_local();
 		p = rcu_dereference_check(rcu_torture_current,
 					  rcu_read_lock_bh_held() ||
 					  rcu_read_lock_sched_held() ||
@@ -1122,7 +1145,6 @@ rcu_torture_reader(void *arg)
 			schedule_timeout_interruptible(HZ);
 			continue;
 		}
-		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu);
 		if (p->rtort_mbtest == 0)
 			atomic_inc(&n_rcu_torture_mberror);
 		cur_ops->read_delay(&rand);
@@ -1132,10 +1154,14 @@ rcu_torture_reader(void *arg)
 			/* Should not happen, but... */
 			pipe_count = RCU_TORTURE_PIPE_LEN;
 		}
-		if (pipe_count > 1)
+		completed_end = cur_ops->completed();
+		if (pipe_count > 1) {
+			do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu,
+						  ts, completed, completed_end);
 			rcutorture_trace_dump();
+		}
 		__this_cpu_inc(rcu_torture_count[pipe_count]);
-		completed = cur_ops->completed() - completed;
+		completed = completed_end - completed;
 		if (completed > RCU_TORTURE_PIPE_LEN) {
 			/* Should not happen, but... */
 			completed = RCU_TORTURE_PIPE_LEN;
@@ -1301,19 +1327,35 @@ static void rcu_torture_shuffle_tasks(void)
 				set_cpus_allowed_ptr(reader_tasks[i],
 						     shuffle_tmp_mask);
 	}
-
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++)
 			if (fakewriter_tasks[i])
 				set_cpus_allowed_ptr(fakewriter_tasks[i],
 						     shuffle_tmp_mask);
 	}
-
 	if (writer_task)
 		set_cpus_allowed_ptr(writer_task, shuffle_tmp_mask);
-
 	if (stats_task)
 		set_cpus_allowed_ptr(stats_task, shuffle_tmp_mask);
+	if (stutter_task)
+		set_cpus_allowed_ptr(stutter_task, shuffle_tmp_mask);
+	if (fqs_task)
+		set_cpus_allowed_ptr(fqs_task, shuffle_tmp_mask);
+	if (shutdown_task)
+		set_cpus_allowed_ptr(shutdown_task, shuffle_tmp_mask);
+#ifdef CONFIG_HOTPLUG_CPU
+	if (onoff_task)
+		set_cpus_allowed_ptr(onoff_task, shuffle_tmp_mask);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+	if (stall_task)
+		set_cpus_allowed_ptr(stall_task, shuffle_tmp_mask);
+	if (barrier_cbs_tasks)
+		for (i = 0; i < n_barrier_cbs; i++)
+			if (barrier_cbs_tasks[i])
+				set_cpus_allowed_ptr(barrier_cbs_tasks[i],
+						     shuffle_tmp_mask);
+	if (barrier_task)
+		set_cpus_allowed_ptr(barrier_task, shuffle_tmp_mask);
 
 	if (rcu_idle_cpu == -1)
 		rcu_idle_cpu = num_online_cpus() - 1;
@@ -1749,7 +1791,7 @@ static int rcu_torture_barrier_init(void)
 	barrier_cbs_wq =
 		kzalloc(n_barrier_cbs * sizeof(barrier_cbs_wq[0]),
 			GFP_KERNEL);
-	if (barrier_cbs_tasks == NULL || barrier_cbs_wq == 0)
+	if (barrier_cbs_tasks == NULL || !barrier_cbs_wq)
 		return -ENOMEM;
 	for (i = 0; i < n_barrier_cbs; i++) {
 		init_waitqueue_head(&barrier_cbs_wq[i]);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e441b77..5b8ad82 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -105,7 +105,7 @@ int rcu_num_nodes __read_mostly = NUM_RCU_NODES; /* Total # rcu_nodes in use. */
  * The rcu_scheduler_active variable transitions from zero to one just
  * before the first task is spawned.  So when this variable is zero, RCU
  * can assume that there is but one task, allowing RCU to (for example)
- * optimized synchronize_sched() to a simple barrier().  When this variable
+ * optimize synchronize_sched() to a simple barrier().  When this variable
  * is one, RCU must actually do all the hard work required to detect real
  * grace periods.  This variable is also used to suppress boot-time false
  * positives from lockdep-RCU error checking.
@@ -217,12 +217,6 @@ module_param(blimit, long, 0444);
 module_param(qhimark, long, 0444);
 module_param(qlowmark, long, 0444);
 
-int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
-int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
-
-module_param(rcu_cpu_stall_suppress, int, 0644);
-module_param(rcu_cpu_stall_timeout, int, 0644);
-
 static ulong jiffies_till_first_fqs = RCU_JIFFIES_TILL_FORCE_QS;
 static ulong jiffies_till_next_fqs = RCU_JIFFIES_TILL_FORCE_QS;
 
@@ -305,17 +299,27 @@ cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
 }
 
 /*
- * Does the current CPU require a yet-as-unscheduled grace period?
+ * Does the current CPU require a not-yet-started grace period?
+ * The caller must have disabled interrupts to prevent races with
+ * normal callback registry.
  */
 static int
 cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	struct rcu_head **ntp;
+	int i;
 
-	ntp = rdp->nxttail[RCU_DONE_TAIL +
-			   (ACCESS_ONCE(rsp->completed) != rdp->completed)];
-	return rdp->nxttail[RCU_DONE_TAIL] && ntp && *ntp &&
-	       !rcu_gp_in_progress(rsp);
+	if (rcu_gp_in_progress(rsp))
+		return 0;  /* No, a grace period is already in progress. */
+	if (!rdp->nxttail[RCU_NEXT_TAIL])
+		return 0;  /* No, this is a no-CBs (or offline) CPU. */
+	if (*rdp->nxttail[RCU_NEXT_READY_TAIL])
+		return 1;  /* Yes, this CPU has newly registered callbacks. */
+	for (i = RCU_WAIT_TAIL; i < RCU_NEXT_TAIL; i++)
+		if (rdp->nxttail[i - 1] != rdp->nxttail[i] &&
+		    ULONG_CMP_LT(ACCESS_ONCE(rsp->completed),
+				 rdp->nxtcompleted[i]))
+			return 1;  /* Yes, CBs for future grace period. */
+	return 0; /* No grace period needed. */
 }
 
 /*
@@ -336,7 +340,7 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 				bool user)
 {
-	trace_rcu_dyntick("Start", oldval, 0);
+	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
@@ -727,7 +731,7 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
  * interrupt from idle, return true.  The caller must have at least
  * disabled preemption.
  */
-int rcu_is_cpu_rrupt_from_idle(void)
+static int rcu_is_cpu_rrupt_from_idle(void)
 {
 	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
 }
@@ -793,28 +797,10 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	return 0;
 }
 
-static int jiffies_till_stall_check(void)
-{
-	int till_stall_check = ACCESS_ONCE(rcu_cpu_stall_timeout);
-
-	/*
-	 * Limit check must be consistent with the Kconfig limits
-	 * for CONFIG_RCU_CPU_STALL_TIMEOUT.
-	 */
-	if (till_stall_check < 3) {
-		ACCESS_ONCE(rcu_cpu_stall_timeout) = 3;
-		till_stall_check = 3;
-	} else if (till_stall_check > 300) {
-		ACCESS_ONCE(rcu_cpu_stall_timeout) = 300;
-		till_stall_check = 300;
-	}
-	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
-}
-
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
 	rsp->gp_start = jiffies;
-	rsp->jiffies_stall = jiffies + jiffies_till_stall_check();
+	rsp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
 }
 
 /*
@@ -857,7 +843,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
-	rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
+	rsp->jiffies_stall = jiffies + 3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
@@ -935,7 +921,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
 		rsp->jiffies_stall = jiffies +
-				     3 * jiffies_till_stall_check() + 3;
+				     3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	set_need_resched();  /* kick ourselves to get things going. */
@@ -966,12 +952,6 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 }
 
-static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
-{
-	rcu_cpu_stall_suppress = 1;
-	return NOTIFY_DONE;
-}
-
 /**
  * rcu_cpu_stall_reset - prevent further stall warnings in current grace period
  *
@@ -989,15 +969,6 @@ void rcu_cpu_stall_reset(void)
 		rsp->jiffies_stall = jiffies + ULONG_MAX / 2;
 }
 
-static struct notifier_block rcu_panic_block = {
-	.notifier_call = rcu_panic,
-};
-
-static void __init check_cpu_stall_init(void)
-{
-	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
-}
-
 /*
  * Update CPU-local rcu_data state to record the newly noticed grace period.
  * This is used both when we started the grace period and when we notice
@@ -1071,6 +1042,145 @@ static void init_callback_list(struct rcu_data *rdp)
 }
 
 /*
+ * Determine the value that ->completed will have at the end of the
+ * next subsequent grace period.  This is used to tag callbacks so that
+ * a CPU can invoke callbacks in a timely fashion even if that CPU has
+ * been dyntick-idle for an extended period with callbacks under the
+ * influence of RCU_FAST_NO_HZ.
+ *
+ * The caller must hold rnp->lock with interrupts disabled.
+ */
+static unsigned long rcu_cbs_completed(struct rcu_state *rsp,
+				       struct rcu_node *rnp)
+{
+	/*
+	 * If RCU is idle, we just wait for the next grace period.
+	 * But we can only be sure that RCU is idle if we are looking
+	 * at the root rcu_node structure -- otherwise, a new grace
+	 * period might have started, but just not yet gotten around
+	 * to initializing the current non-root rcu_node structure.
+	 */
+	if (rcu_get_root(rsp) == rnp && rnp->gpnum == rnp->completed)
+		return rnp->completed + 1;
+
+	/*
+	 * Otherwise, wait for a possible partial grace period and
+	 * then the subsequent full grace period.
+	 */
+	return rnp->completed + 2;
+}
+
+/*
+ * If there is room, assign a ->completed number to any callbacks on
+ * this CPU that have not already been assigned.  Also accelerate any
+ * callbacks that were previously assigned a ->completed number that has
+ * since proven to be too conservative, which can happen if callbacks get
+ * assigned a ->completed number while RCU is idle, but with reference to
+ * a non-root rcu_node structure.  This function is idempotent, so it does
+ * not hurt to call it repeatedly.
+ *
+ * The caller must hold rnp->lock with interrupts disabled.
+ */
+static void rcu_accelerate_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
+			       struct rcu_data *rdp)
+{
+	unsigned long c;
+	int i;
+
+	/* If the CPU has no callbacks, nothing to do. */
+	if (!rdp->nxttail[RCU_NEXT_TAIL] || !*rdp->nxttail[RCU_DONE_TAIL])
+		return;
+
+	/*
+	 * Starting from the sublist containing the callbacks most
+	 * recently assigned a ->completed number and working down, find the
+	 * first sublist that is not assignable to an upcoming grace period.
+	 * Such a sublist has something in it (first two tests) and has
+	 * a ->completed number assigned that will complete sooner than
+	 * the ->completed number for newly arrived callbacks (last test).
+	 *
+	 * The key point is that any later sublist can be assigned the
+	 * same ->completed number as the newly arrived callbacks, which
+	 * means that the callbacks in any of these later sublist can be
+	 * grouped into a single sublist, whether or not they have already
+	 * been assigned a ->completed number.
+	 */
+	c = rcu_cbs_completed(rsp, rnp);
+	for (i = RCU_NEXT_TAIL - 1; i > RCU_DONE_TAIL; i--)
+		if (rdp->nxttail[i] != rdp->nxttail[i - 1] &&
+		    !ULONG_CMP_GE(rdp->nxtcompleted[i], c))
+			break;
+
+	/*
+	 * If there are no sublist for unassigned callbacks, leave.
+	 * At the same time, advance "i" one sublist, so that "i" will
+	 * index into the sublist where all the remaining callbacks should
+	 * be grouped into.
+	 */
+	if (++i >= RCU_NEXT_TAIL)
+		return;
+
+	/*
+	 * Assign all subsequent callbacks' ->completed number to the next
+	 * full grace period and group them all in the sublist initially
+	 * indexed by "i".
+	 */
+	for (; i <= RCU_NEXT_TAIL; i++) {
+		rdp->nxttail[i] = rdp->nxttail[RCU_NEXT_TAIL];
+		rdp->nxtcompleted[i] = c;
+	}
+
+	/* Trace depending on how much we were able to accelerate. */
+	if (!*rdp->nxttail[RCU_WAIT_TAIL])
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, "AccWaitCB");
+	else
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, "AccReadyCB");
+}
+
+/*
+ * Move any callbacks whose grace period has completed to the
+ * RCU_DONE_TAIL sublist, then compact the remaining sublists and
+ * assign ->completed numbers to any callbacks in the RCU_NEXT_TAIL
+ * sublist.  This function is idempotent, so it does not hurt to
+ * invoke it repeatedly.  As long as it is not invoked -too- often...
+ *
+ * The caller must hold rnp->lock with interrupts disabled.
+ */
+static void rcu_advance_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
+			    struct rcu_data *rdp)
+{
+	int i, j;
+
+	/* If the CPU has no callbacks, nothing to do. */
+	if (!rdp->nxttail[RCU_NEXT_TAIL] || !*rdp->nxttail[RCU_DONE_TAIL])
+		return;
+
+	/*
+	 * Find all callbacks whose ->completed numbers indicate that they
+	 * are ready to invoke, and put them into the RCU_DONE_TAIL sublist.
+	 */
+	for (i = RCU_WAIT_TAIL; i < RCU_NEXT_TAIL; i++) {
+		if (ULONG_CMP_LT(rnp->completed, rdp->nxtcompleted[i]))
+			break;
+		rdp->nxttail[RCU_DONE_TAIL] = rdp->nxttail[i];
+	}
+	/* Clean up any sublist tail pointers that were misordered above. */
+	for (j = RCU_WAIT_TAIL; j < i; j++)
+		rdp->nxttail[j] = rdp->nxttail[RCU_DONE_TAIL];
+
+	/* Copy down callbacks to fill in empty sublists. */
+	for (j = RCU_WAIT_TAIL; i < RCU_NEXT_TAIL; i++, j++) {
+		if (rdp->nxttail[j] == rdp->nxttail[RCU_NEXT_TAIL])
+			break;
+		rdp->nxttail[j] = rdp->nxttail[i];
+		rdp->nxtcompleted[j] = rdp->nxtcompleted[i];
+	}
+
+	/* Classify any remaining callbacks. */
+	rcu_accelerate_cbs(rsp, rnp, rdp);
+}
+
+/*
  * Advance this CPU's callbacks, but only if the current grace period
  * has ended.  This may be called only from the CPU to whom the rdp
  * belongs.  In addition, the corresponding leaf rcu_node structure's
@@ -1080,12 +1190,15 @@ static void
 __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
 {
 	/* Did another grace period end? */
-	if (rdp->completed != rnp->completed) {
+	if (rdp->completed == rnp->completed) {
 
-		/* Advance callbacks.  No harm if list empty. */
-		rdp->nxttail[RCU_DONE_TAIL] = rdp->nxttail[RCU_WAIT_TAIL];
-		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_READY_TAIL];
-		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+		/* No, so just accelerate recent callbacks. */
+		rcu_accelerate_cbs(rsp, rnp, rdp);
+
+	} else {
+
+		/* Advance callbacks. */
+		rcu_advance_cbs(rsp, rnp, rdp);
 
 		/* Remember that we saw this grace-period completion. */
 		rdp->completed = rnp->completed;
@@ -1392,17 +1505,10 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	/*
 	 * Because there is no grace period in progress right now,
 	 * any callbacks we have up to this point will be satisfied
-	 * by the next grace period.  So promote all callbacks to be
-	 * handled after the end of the next grace period.  If the
-	 * CPU is not yet aware of the end of the previous grace period,
-	 * we need to allow for the callback advancement that will
-	 * occur when it does become aware.  Deadlock prevents us from
-	 * making it aware at this point: We cannot acquire a leaf
-	 * rcu_node ->lock while holding the root rcu_node ->lock.
+	 * by the next grace period.  So this is a good place to
+	 * assign a grace period number to recently posted callbacks.
 	 */
-	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-	if (rdp->completed == rsp->completed)
-		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	rcu_accelerate_cbs(rsp, rnp, rdp);
 
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
 	raw_spin_unlock(&rnp->lock); /* Interrupts remain disabled. */
@@ -1527,7 +1633,7 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 		 * This GP can't end until cpu checks in, so all of our
 		 * callbacks can be processed during the next GP.
 		 */
-		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+		rcu_accelerate_cbs(rsp, rnp, rdp);
 
 		rcu_report_qs_rnp(mask, rsp, rnp, flags); /* rlses rnp->lock */
 	}
@@ -1779,7 +1885,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	long bl, count, count_lazy;
 	int i;
 
-	/* If no callbacks are ready, just return.*/
+	/* If no callbacks are ready, just return. */
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
 		trace_rcu_batch_start(rsp->name, rdp->qlen_lazy, rdp->qlen, 0);
 		trace_rcu_batch_end(rsp->name, 0, !!ACCESS_ONCE(rdp->nxtlist),
@@ -2008,19 +2114,19 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
-	/*
-	 * Advance callbacks in response to end of earlier grace
-	 * period that some other CPU ended.
-	 */
+	/* Handle the end of a grace period that some other CPU ended.  */
 	rcu_process_gp_end(rsp, rdp);
 
 	/* Update RCU state based on any recent quiescent states. */
 	rcu_check_quiescent_state(rsp, rdp);
 
 	/* Does this CPU require a not-yet-started grace period? */
+	local_irq_save(flags);
 	if (cpu_needs_another_gp(rsp, rdp)) {
-		raw_spin_lock_irqsave(&rcu_get_root(rsp)->lock, flags);
+		raw_spin_lock(&rcu_get_root(rsp)->lock); /* irqs disabled. */
 		rcu_start_gp(rsp, flags);  /* releases above lock */
+	} else {
+		local_irq_restore(flags);
 	}
 
 	/* If there are callbacks ready, invoke them. */
@@ -2719,9 +2825,6 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
 	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
-#ifdef CONFIG_RCU_USER_QS
-	WARN_ON_ONCE(rdp->dynticks->in_user);
-#endif
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
 	rcu_boot_init_nocb_percpu_data(rdp);
@@ -2938,6 +3041,10 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 
 	BUILD_BUG_ON(MAX_RCU_LVLS > ARRAY_SIZE(buf));  /* Fix buf[] init! */
 
+	/* Silence gcc 4.8 warning about array index out of range. */
+	if (rcu_num_lvls > RCU_NUM_LVLS)
+		panic("rcu_init_one: rcu_num_lvls overflow");
+
 	/* Initialize the level-tracking arrays. */
 
 	for (i = 0; i < rcu_num_lvls; i++)
@@ -3074,7 +3181,6 @@ void __init rcu_init(void)
 	cpu_notifier(rcu_cpu_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
-	check_cpu_stall_init();
 }
 
 #include "rcutree_plugin.h"
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4b69291..c896b50 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -102,10 +102,6 @@ struct rcu_dynticks {
 				    /* idle-period nonlazy_posted snapshot. */
 	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
 #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
-#ifdef CONFIG_RCU_USER_QS
-	bool ignore_user_qs;	    /* Treat userspace as extended QS or not */
-	bool in_user;		    /* Is the CPU in userland from RCU POV? */
-#endif
 };
 
 /* RCU's kthread states for tracing. */
@@ -282,6 +278,8 @@ struct rcu_data {
 	 */
 	struct rcu_head *nxtlist;
 	struct rcu_head **nxttail[RCU_NEXT_SIZE];
+	unsigned long	nxtcompleted[RCU_NEXT_SIZE];
+					/* grace periods for sublists. */
 	long		qlen_lazy;	/* # of lazy queued callbacks */
 	long		qlen;		/* # of queued callbacks, incl lazy */
 	long		qlen_last_fqs_check;
@@ -343,11 +341,6 @@ struct rcu_data {
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
 
-#ifdef CONFIG_PROVE_RCU
-#define RCU_STALL_DELAY_DELTA	       (5 * HZ)
-#else
-#define RCU_STALL_DELAY_DELTA	       0
-#endif
 #define RCU_STALL_RAT_DELAY		2	/* Allow other CPUs time */
 						/*  to take at least one */
 						/*  scheduling clock irq */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f6e5ec2..c1cc7e1 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -40,8 +40,7 @@
 #ifdef CONFIG_RCU_NOCB_CPU
 static cpumask_var_t rcu_nocb_mask; /* CPUs to have callbacks offloaded. */
 static bool have_rcu_nocb_mask;	    /* Was rcu_nocb_mask allocated? */
-static bool rcu_nocb_poll;	    /* Offload kthread are to poll. */
-module_param(rcu_nocb_poll, bool, 0444);
+static bool __read_mostly rcu_nocb_poll;    /* Offload kthread are to poll. */
 static char __initdata nocb_buf[NR_CPUS * 5];
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
@@ -2159,6 +2158,13 @@ static int __init rcu_nocb_setup(char *str)
 }
 __setup("rcu_nocbs=", rcu_nocb_setup);
 
+static int __init parse_rcu_nocb_poll(char *arg)
+{
+	rcu_nocb_poll = 1;
+	return 0;
+}
+early_param("rcu_nocb_poll", parse_rcu_nocb_poll);
+
 /* Is the specified CPU a no-CPUs CPU? */
 static bool is_nocb_cpu(int cpu)
 {
@@ -2366,10 +2372,11 @@ static int rcu_nocb_kthread(void *arg)
 	for (;;) {
 		/* If not polling, wait for next batch of callbacks. */
 		if (!rcu_nocb_poll)
-			wait_event(rdp->nocb_wq, rdp->nocb_head);
+			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
 		list = ACCESS_ONCE(rdp->nocb_head);
 		if (!list) {
 			schedule_timeout_interruptible(1);
+			flush_signals(current);
 			continue;
 		}
 
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 2b85982..01d5ccb 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -282,12 +282,8 @@ static int srcu_readers_active(struct srcu_struct *sp)
  */
 void cleanup_srcu_struct(struct srcu_struct *sp)
 {
-	int sum;
-
-	sum = srcu_readers_active(sp);
-	WARN_ON(sum);  /* Leakage unless caller handles error. */
-	if (sum != 0)
-		return;
+	if (WARN_ON(srcu_readers_active(sp)))
+		return; /* Leakage unless caller handles error. */
 	free_percpu(sp->per_cpu_ref);
 	sp->per_cpu_ref = NULL;
 }
@@ -302,9 +298,8 @@ int __srcu_read_lock(struct srcu_struct *sp)
 {
 	int idx;
 
+	idx = ACCESS_ONCE(sp->completed) & 0x1;
 	preempt_disable();
-	idx = rcu_dereference_index_check(sp->completed,
-					  rcu_read_lock_sched_held()) & 0x1;
 	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 1;
 	smp_mb(); /* B */  /* Avoid leaking the critical section. */
 	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->seq[idx]) += 1;
@@ -321,10 +316,8 @@ EXPORT_SYMBOL_GPL(__srcu_read_lock);
  */
 void __srcu_read_unlock(struct srcu_struct *sp, int idx)
 {
-	preempt_disable();
 	smp_mb(); /* C */  /* Avoid leaking the critical section. */
-	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) -= 1;
-	preempt_enable();
+	this_cpu_dec(sp->per_cpu_ref->c[idx]);
 }
 EXPORT_SYMBOL_GPL(__srcu_read_unlock);
 
@@ -423,6 +416,7 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
 			   !lock_is_held(&rcu_sched_lock_map),
 			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
 
+	might_sleep();
 	init_completion(&rcu.completion);
 
 	head->next = NULL;
@@ -455,10 +449,12 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
  * synchronize_srcu - wait for prior SRCU read-side critical-section completion
  * @sp: srcu_struct with which to synchronize.
  *
- * Flip the completed counter, and wait for the old count to drain to zero.
- * As with classic RCU, the updater must use some separate means of
- * synchronizing concurrent updates.  Can block; must be called from
- * process context.
+ * Wait for the count to drain to zero of both indexes. To avoid the
+ * possible starvation of synchronize_srcu(), it waits for the count of
+ * the index=((->completed & 1) ^ 1) to drain to zero at first,
+ * and then flip the completed and wait for the count of the other index.
+ *
+ * Can block; must be called from process context.
  *
  * Note that it is illegal to call synchronize_srcu() from the corresponding
  * SRCU read-side critical section; doing so will result in deadlock.
@@ -480,12 +476,11 @@ EXPORT_SYMBOL_GPL(synchronize_srcu);
  * Wait for an SRCU grace period to elapse, but be more aggressive about
  * spinning rather than blocking when waiting.
  *
- * Note that it is illegal to call this function while holding any lock
- * that is acquired by a CPU-hotplug notifier.  It is also illegal to call
- * synchronize_srcu_expedited() from the corresponding SRCU read-side
- * critical section; doing so will result in deadlock.  However, it is
- * perfectly legal to call synchronize_srcu_expedited() on one srcu_struct
- * from some other srcu_struct's read-side critical section, as long as
+ * Note that it is also illegal to call synchronize_srcu_expedited()
+ * from the corresponding SRCU read-side critical section;
+ * doing so will result in deadlock.  However, it is perfectly legal
+ * to call synchronize_srcu_expedited() on one srcu_struct from some
+ * other srcu_struct's read-side critical section, as long as
  * the resulting graph of srcu_structs is acyclic.
  */
 void synchronize_srcu_expedited(struct srcu_struct *sp)
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 3947835..1bbb1b2 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -44,6 +44,7 @@ u64 notrace trace_clock_local(void)
 
 	return clock;
 }
+EXPORT_SYMBOL_GPL(trace_clock_local);
 
 /*
  * trace_clock(): 'between' trace clock. Not completely serialized,
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 67604e5..a1714c8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -605,61 +605,6 @@ config PROVE_LOCKING
 
 	 For more details, see Documentation/lockdep-design.txt.
 
-config PROVE_RCU
-	bool "RCU debugging: prove RCU correctness"
-	depends on PROVE_LOCKING
-	default n
-	help
-	 This feature enables lockdep extensions that check for correct
-	 use of RCU APIs.  This is currently under development.  Say Y
-	 if you want to debug RCU usage or help work on the PROVE_RCU
-	 feature.
-
-	 Say N if you are unsure.
-
-config PROVE_RCU_REPEATEDLY
-	bool "RCU debugging: don't disable PROVE_RCU on first splat"
-	depends on PROVE_RCU
-	default n
-	help
-	 By itself, PROVE_RCU will disable checking upon issuing the
-	 first warning (or "splat").  This feature prevents such
-	 disabling, allowing multiple RCU-lockdep warnings to be printed
-	 on a single reboot.
-
-	 Say Y to allow multiple RCU-lockdep warnings per boot.
-
-	 Say N if you are unsure.
-
-config PROVE_RCU_DELAY
-	bool "RCU debugging: preemptible RCU race provocation"
-	depends on DEBUG_KERNEL && PREEMPT_RCU
-	default n
-	help
-	 There is a class of races that involve an unlikely preemption
-	 of __rcu_read_unlock() just after ->rcu_read_lock_nesting has
-	 been set to INT_MIN.  This feature inserts a delay at that
-	 point to increase the probability of these races.
-
-	 Say Y to increase probability of preemption of __rcu_read_unlock().
-
-	 Say N if you are unsure.
-
-config SPARSE_RCU_POINTER
-	bool "RCU debugging: sparse-based checks for pointer usage"
-	default n
-	help
-	 This feature enables the __rcu sparse annotation for
-	 RCU-protected pointers.  This annotation will cause sparse
-	 to flag any non-RCU used of annotated pointers.  This can be
-	 helpful when debugging RCU usage.  Please note that this feature
-	 is not intended to enforce code cleanliness; it is instead merely
-	 a debugging aid.
-
-	 Say Y to make sparse flag questionable use of RCU-protected pointers
-
-	 Say N if you are unsure.
-
 config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
@@ -937,6 +882,63 @@ config BOOT_PRINTK_DELAY
 	  BOOT_PRINTK_DELAY also may cause LOCKUP_DETECTOR to detect
 	  what it believes to be lockup conditions.
 
+menu "RCU Debugging"
+
+config PROVE_RCU
+	bool "RCU debugging: prove RCU correctness"
+	depends on PROVE_LOCKING
+	default n
+	help
+	 This feature enables lockdep extensions that check for correct
+	 use of RCU APIs.  This is currently under development.  Say Y
+	 if you want to debug RCU usage or help work on the PROVE_RCU
+	 feature.
+
+	 Say N if you are unsure.
+
+config PROVE_RCU_REPEATEDLY
+	bool "RCU debugging: don't disable PROVE_RCU on first splat"
+	depends on PROVE_RCU
+	default n
+	help
+	 By itself, PROVE_RCU will disable checking upon issuing the
+	 first warning (or "splat").  This feature prevents such
+	 disabling, allowing multiple RCU-lockdep warnings to be printed
+	 on a single reboot.
+
+	 Say Y to allow multiple RCU-lockdep warnings per boot.
+
+	 Say N if you are unsure.
+
+config PROVE_RCU_DELAY
+	bool "RCU debugging: preemptible RCU race provocation"
+	depends on DEBUG_KERNEL && PREEMPT_RCU
+	default n
+	help
+	 There is a class of races that involve an unlikely preemption
+	 of __rcu_read_unlock() just after ->rcu_read_lock_nesting has
+	 been set to INT_MIN.  This feature inserts a delay at that
+	 point to increase the probability of these races.
+
+	 Say Y to increase probability of preemption of __rcu_read_unlock().
+
+	 Say N if you are unsure.
+
+config SPARSE_RCU_POINTER
+	bool "RCU debugging: sparse-based checks for pointer usage"
+	default n
+	help
+	 This feature enables the __rcu sparse annotation for
+	 RCU-protected pointers.  This annotation will cause sparse
+	 to flag any non-RCU used of annotated pointers.  This can be
+	 helpful when debugging RCU usage.  Please note that this feature
+	 is not intended to enforce code cleanliness; it is instead merely
+	 a debugging aid.
+
+	 Say Y to make sparse flag questionable use of RCU-protected pointers
+
+	 Say N if you are unsure.
+
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
@@ -970,7 +972,7 @@ config RCU_TORTURE_TEST_RUNNABLE
 
 config RCU_CPU_STALL_TIMEOUT
 	int "RCU CPU stall timeout in seconds"
-	depends on TREE_RCU || TREE_PREEMPT_RCU
+	depends on RCU_STALL_COMMON
 	range 3 300
 	default 21
 	help
@@ -1008,6 +1010,7 @@ config RCU_CPU_STALL_INFO
 config RCU_TRACE
 	bool "Enable tracing for RCU"
 	depends on DEBUG_KERNEL
+	select TRACE_CLOCK
 	help
 	  This option provides tracing in RCU which presents stats
 	  in debugfs for debugging RCU implementation.
@@ -1015,6 +1018,8 @@ config RCU_TRACE
 	  Say Y here if you want to enable RCU tracing
 	  Say N if you are unsure.
 
+endmenu # "RCU Debugging"
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
