Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbaFRXvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:51:37 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46374 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496AbaFRXvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:51:35 -0400
Date: Wed, 18 Jun 2014 16:51:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140618235131.GA25946@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <539B594C.8070004@intel.com>
 <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
 <20140618001836.GV4669@linux.vnet.ibm.com>
 <53A132D4.60408@intel.com>
 <20140618125831.GB4669@linux.vnet.ibm.com>
 <53A1CE19.7040103@intel.com>
 <20140618203052.GT4669@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618203052.GT4669@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061823-0928-0000-0000-000002BF8079
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 01:30:52PM -0700, Paul E. McKenney wrote:
> On Wed, Jun 18, 2014 at 10:36:25AM -0700, Dave Hansen wrote:
> > On 06/18/2014 05:58 AM, Paul E. McKenney wrote:
> > >> > This is the previous kernel, plus RCU tracing, so it's not 100%
> > >> > apples-to-apples (and it peaks a bit lower than the other kernel).  But
> > >> > here's the will-it-scale open1 throughput on the y axis vs
> > >> > RCU_COND_RESCHED_EVERY_THIS_JIFFIES on x:
> > >> > 
> > >> > 	http://sr71.net/~dave/intel/jiffies-vs-openops.png
> > >> > 
> > >> > This was a quick and dirty single run with very little averaging, so I
> > >> > expect there to be a good amount of noise.  I ran it from 1->100, but it
> > >> > seemed to peak at about 30.
> > > OK, so a default setting on the order of 20-30 jiffies looks promising.
> > 
> > For the biggest machine I have today, yeah.  But, we need to be a bit
> > careful here.  The CPUs I'm running it on were released 3 years ago and
> > I think we need to be planning at _least_ for today's large systems.  I
> > would guess that by raising ...EVERY_THIS_JIFFIES, we're shifting this
> > curve out to the right:
> > 
> > 	http://sr71.net/~dave/intel/3.16-open1regression-0.png
> > 
> > so that we're _just_ before the regression hits us.  But that just
> > guarantees I'll hit this again when I get new CPUs. :)
> 
> Understood.  One approach would be to scale this in a manner similar
> to the scaling of the delay from the beginning of the grace period
> to the start of quiescent-state forcing, which is about three jiffies
> on small systems scaling up to about 20 jiffies on large systems.
> 
> > If we go this route, I think we should probably take it up in to the
> > 100-200 range, or even scale it to something on the order of what the
> > rcu stall timeout is.  Other than the stall detector, is there some
> > other reason to be forcing frequent quiescent states?
> 
> Yep.  CONFIG_NO_HZ_FULL+nohz_full kernels running in kernel mode don't
> progress RCU grace periods.  But they should not need to be all that
> frequent.

Here is an early version of a patch, which looks promising on short
rcutorture tests.  It does not yet have control of the holdoff time
(I intend to add a module parameter for this), but it also avoids ever
having cond_resched() do a quiescent state if there is no grace period in
progress or if the current grace period is less than seven jiffies old.
(The constant "7" is the thing that will be made into a module parameter.)
These restrictions lead me to believe that "7" will perform well in your
tests, because normal workloads would almost never have cond_resched()
do anything other than a test of a per-CPU variable.  But of course your
tests are the final judges of that.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Reduce overhead of cond_resched() checks for RCU

Commit ac1bea85781e (Make cond_resched() report RCU quiescent states)
fixed a problem where a CPU looping in the kernel with but one runnable
task would give RCU CPU stall warnings, even if the in-kernel loop
contained cond_resched() calls.  Unfortunately, in so doing, it introduced
performance regressions in Anton Blanchard's will-it-scale "open1" test.
The problem appears to be not so much the increased cond_resched() path
length as an increase in the rate at which grace periods complete, which
increased per-update grace-period overhead.

This commit takes a different approach to fixing this bug, mainly by
avoiding having cond_resched() do an RCU-visible quiescent state unless
there is a grace period that has been in flight for a significant period
of time.  This commit also reduces the common-case cond_resched() overhead
to a check of a single per-CPU variable.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 063a6bf1a2b6..d5e40a42cc43 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -300,41 +300,6 @@ bool __rcu_is_watching(void);
 #endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
 
 /*
- * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
- */
-
-#define RCU_COND_RESCHED_LIM 256	/* ms vs. 100s of ms. */
-DECLARE_PER_CPU(int, rcu_cond_resched_count);
-void rcu_resched(void);
-
-/*
- * Is it time to report RCU quiescent states?
- *
- * Note unsynchronized access to rcu_cond_resched_count.  Yes, we might
- * increment some random CPU's count, and possibly also load the result from
- * yet another CPU's count.  We might even clobber some other CPU's attempt
- * to zero its counter.  This is all OK because the goal is not precision,
- * but rather reasonable amortization of rcu_note_context_switch() overhead
- * and extremely high probability of avoiding RCU CPU stall warnings.
- * Note that this function has to be preempted in just the wrong place,
- * many thousands of times in a row, for anything bad to happen.
- */
-static inline bool rcu_should_resched(void)
-{
-	return raw_cpu_inc_return(rcu_cond_resched_count) >=
-	       RCU_COND_RESCHED_LIM;
-}
-
-/*
- * Report quiscent states to RCU if it is time to do so.
- */
-static inline void rcu_cond_resched(void)
-{
-	if (unlikely(rcu_should_resched()))
-		rcu_resched();
-}
-
-/*
  * Infrastructure to implement the synchronize_() primitives in
  * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
  */
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index d40a6a451330..ff2ede319890 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -83,6 +83,19 @@ static inline void rcu_note_context_switch(int cpu)
 	rcu_sched_qs(cpu);
 }
 
+static inline bool rcu_should_resched(void)
+{
+	return false;
+}
+
+static inline void rcu_cond_resched(void)
+{
+}
+
+static inline void rcu_resched(void)
+{
+}
+
 /*
  * Take advantage of the fact that there is only one CPU, which
  * allows us to ignore virtualization-based context switches.
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3e2f5d432743..16780fed7155 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -46,6 +46,22 @@ static inline void rcu_virt_note_context_switch(int cpu)
 	rcu_note_context_switch(cpu);
 }
 
+DECLARE_PER_CPU(int, rcu_cond_resched_mask);
+void rcu_resched(void);
+
+/* Is it time to report RCU quiescent states? */
+static inline bool rcu_should_resched(void)
+{
+	return raw_cpu_read(rcu_cond_resched_mask);
+}
+
+/* Report quiescent states to RCU if it is time to do so. */
+static inline void rcu_cond_resched(void)
+{
+	if (unlikely(rcu_should_resched()))
+		rcu_resched();
+}
+
 void synchronize_rcu_bh(void);
 void synchronize_sched_expedited(void);
 void synchronize_rcu_expedited(void);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 777624e1329b..8c47d04ecdea 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -229,6 +229,58 @@ static DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 #endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 };
 
+/*
+ * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
+ */
+
+DEFINE_PER_CPU(int, rcu_cond_resched_mask);
+
+/*
+ * Let the RCU core know that this CPU has gone through a cond_resched(),
+ * which is a quiescent state.
+ */
+void rcu_resched(void)
+{
+	unsigned long flags;
+	struct rcu_data *rdp;
+	struct rcu_dynticks *rdtp;
+	int resched_mask;
+	struct rcu_state *rsp;
+
+	local_irq_save(flags);
+
+	/*
+	 * Yes, we can lose flag-setting operations.  This is OK, because
+	 * the flag will be set again after some delay.
+	 */
+	resched_mask = raw_cpu_read(rcu_cond_resched_mask);
+	raw_cpu_write(rcu_cond_resched_mask, 0);
+
+	/* Find the flavor that needs a quiescent state. */
+	for_each_rcu_flavor(rsp) {
+		rdp = raw_cpu_ptr(rsp->rda);
+		if (!(resched_mask & rsp->flavor_mask))
+			continue;
+		smp_mb(); /* ->flavor_mask before ->cond_resched_completed. */
+		if (ACCESS_ONCE(rdp->mynode->completed) !=
+		    ACCESS_ONCE(rdp->cond_resched_completed))
+			continue;
+
+		/*
+		 * Pretend to be momentarily idle for the quiescent state.
+		 * This allows the grace-period kthread to record the
+		 * quiescent state, with no need for this CPU to do anything
+		 * further.
+		 */
+		rdtp = this_cpu_ptr(&rcu_dynticks);
+		smp_mb__before_atomic(); /* Earlier stuff before QS. */
+		atomic_add(2, &rdtp->dynticks);  /* QS. */
+		smp_mb__after_atomic(); /* Later stuff after QS. */
+		break;
+	}
+	local_irq_restore(flags);
+}
+
 static long blimit = 10;	/* Maximum callbacks per rcu_do_batch. */
 static long qhimark = 10000;	/* If this many pending, ignore blimit. */
 static long qlowmark = 100;	/* Once only this many pending, use blimit. */
@@ -853,6 +905,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 				    bool *isidle, unsigned long *maxj)
 {
 	unsigned int curr;
+	int *rcrmp;
 	unsigned int snap;
 
 	curr = (unsigned int)atomic_add_return(0, &rdp->dynticks->dynticks);
@@ -893,13 +946,20 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 	}
 
 	/*
-	 * There is a possibility that a CPU in adaptive-ticks state
-	 * might run in the kernel with the scheduling-clock tick disabled
-	 * for an extended time period.  Invoke rcu_kick_nohz_cpu() to
-	 * force the CPU to restart the scheduling-clock tick in this
-	 * CPU is in this state.
+	 * A CPU running for an extended time within the kernel can
+	 * delay RCU grace periods.  When the CPU is in NO_HZ_FULL mode,
+	 * even context-switching back and forth between a pair of
+	 * in-kernel CPU-bound tasks cannot advance grace periods.
+	 * So if the grace period is old enough, make the CPU pay attention.
 	 */
-	rcu_kick_nohz_cpu(rdp->cpu);
+	if (ULONG_CMP_GE(jiffies, rdp->rsp->gp_start + 7)) {
+		rcrmp = &per_cpu(rcu_cond_resched_mask, rdp->cpu);
+		ACCESS_ONCE(rdp->cond_resched_completed) =
+			ACCESS_ONCE(rdp->mynode->completed);
+		smp_mb(); /* ->cond_resched_completed before *rcrmp. */
+		ACCESS_ONCE(*rcrmp) =
+			ACCESS_ONCE(*rcrmp) + rdp->rsp->flavor_mask;
+	}
 
 	/*
 	 * Alternatively, the CPU might be running in the kernel
@@ -3504,6 +3564,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 		"rcu_node_fqs_1",
 		"rcu_node_fqs_2",
 		"rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
+	static u8 fl_mask = 0x1;
 	int cpustride = 1;
 	int i;
 	int j;
@@ -3522,6 +3583,8 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 	for (i = 1; i < rcu_num_lvls; i++)
 		rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
 	rcu_init_levelspread(rsp);
+	rsp->flavor_mask = fl_mask;
+	fl_mask <<= 1;
 
 	/* Initialize the elements themselves, starting from the leaves. */
 
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index db3f096ed80b..60fb0eaa2d16 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -315,6 +315,9 @@ struct rcu_data {
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
 	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
 	unsigned long offline_fqs;	/* Kicked due to being offline. */
+	unsigned long cond_resched_completed;
+					/* Grace period that needs help */
+					/*  from cond_resched(). */
 
 	/* 5) __rcu_pending() statistics. */
 	unsigned long n_rcu_pending;	/* rcu_pending() calls since boot. */
@@ -400,6 +403,7 @@ struct rcu_state {
 	struct rcu_node *level[RCU_NUM_LVLS];	/* Hierarchy levels. */
 	u32 levelcnt[MAX_RCU_LVLS + 1];		/* # nodes in each level. */
 	u8 levelspread[RCU_NUM_LVLS];		/* kids/node in each level. */
+	u8 flavor_mask;				/* bit in flavor mask. */
 	struct rcu_data __percpu *rda;		/* pointer of percu rcu_data. */
 	void (*call)(struct rcu_head *head,	/* call_rcu() flavor. */
 		     void (*func)(struct rcu_head *head));
@@ -571,7 +575,7 @@ static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
 static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
-static void rcu_kick_nohz_cpu(int cpu);
+static void __maybe_unused rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
 static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
 static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 695ecf19dfc6..569b390daa15 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2422,7 +2422,7 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
  * if an adaptive-ticks CPU is failing to respond to the current grace
  * period and has not be idle from an RCU perspective, kick it.
  */
-static void rcu_kick_nohz_cpu(int cpu)
+static void __maybe_unused rcu_kick_nohz_cpu(int cpu)
 {
 #ifdef CONFIG_NO_HZ_FULL
 	if (tick_nohz_full_cpu(cpu))
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index a2aeb4df0f60..d22309cae9f5 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -350,21 +350,3 @@ static int __init check_cpu_stall_init(void)
 early_initcall(check_cpu_stall_init);
 
 #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
-
-/*
- * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
- */
-
-DEFINE_PER_CPU(int, rcu_cond_resched_count);
-
-/*
- * Report a set of RCU quiescent states, for use by cond_resched()
- * and friends.  Out of line due to being called infrequently.
- */
-void rcu_resched(void)
-{
-	preempt_disable();
-	__this_cpu_write(rcu_cond_resched_count, 0);
-	rcu_note_context_switch(smp_processor_id());
-	preempt_enable();
-}

