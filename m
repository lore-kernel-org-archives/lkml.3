Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3F1UKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:10:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38408 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab3F1UKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:10:46 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC nohz_full v2 6/7] nohz_full: Add full-system-idle state machine
Date: Fri, 28 Jun 2013 13:10:21 -0700
Message-Id: <1372450222-19420-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062820-4834-0000-0000-000008865583
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds the state machine that takes the per-CPU idle data
as input and produces a full-system-idle indication as output.  This
state machine is driven out of RCU's quiescent-state-forcing
mechanism, which invokes rcu_sysidle_check_cpu() to collect per-CPU
idle state and then rcu_sysidle_report() to drive the state machine.

The full-system-idle state is sampled using rcu_sys_is_idle(), which
also drives the state machine if RCU is idle (and does so by forcing
RCU to become non-idle).  This function returns true if all but the
timekeeping CPU (tick_do_timer_cpu) are idle and have been idle long
enough to avoid memory contention on the full_sysidle_state state
variable.  The rcu_sysidle_force_exit() may be called externally
to reset the state machine back into non-idle state.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>

Conflicts:

	kernel/rcutree.h
	kernel/rcutree_plugin.h
---
 include/linux/rcupdate.h |  18 ++++
 kernel/rcutree.c         |  16 ++-
 kernel/rcutree.h         |   5 +
 kernel/rcutree_plugin.h  | 263 ++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 295 insertions(+), 7 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 48f1ef9..1aa8d8c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1011,4 +1011,22 @@ static inline bool rcu_is_nocb_cpu(int cpu) { return false; }
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
 
 
+/* Only for use by adaptive-ticks code. */
+#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
+extern bool rcu_sys_is_idle(void);
+extern void rcu_sysidle_force_exit(void);
+#else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+
+static inline bool rcu_sys_is_idle(void)
+{
+	return false;
+}
+
+static inline void rcu_sysidle_force_exit(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 9971f86..06cfd75 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -718,6 +718,7 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp,
 					 bool *isidle, unsigned long *maxj)
 {
 	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
+	rcu_sysidle_check_cpu(rdp, isidle, maxj);
 	return (rdp->dynticks_snap & 0x1) == 0;
 }
 
@@ -1356,11 +1357,17 @@ int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 	rsp->n_force_qs++;
 	if (fqs_state == RCU_SAVE_DYNTICK) {
 		/* Collect dyntick-idle snapshots. */
+		if (is_sysidle_rcu_state(rsp)) {
+			isidle = 1;
+			maxj = jiffies - ULONG_MAX / 4;
+		}
 		force_qs_rnp(rsp, dyntick_save_progress_counter,
 			     &isidle, &maxj);
+		rcu_sysidle_report(rsp, isidle, maxj);
 		fqs_state = RCU_FORCE_QS;
 	} else {
 		/* Handle dyntick-idle and offline CPUs. */
+		isidle = 0;
 		force_qs_rnp(rsp, rcu_implicit_dynticks_qs, &isidle, &maxj);
 	}
 	/* Clear flag to prevent immediate re-entry. */
@@ -2087,9 +2094,12 @@ static void force_qs_rnp(struct rcu_state *rsp,
 		cpu = rnp->grplo;
 		bit = 1;
 		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
-			if ((rnp->qsmask & bit) != 0 &&
-			    f(per_cpu_ptr(rsp->rda, cpu), isidle, maxj))
-				mask |= bit;
+			if ((rnp->qsmask & bit) != 0) {
+				if ((rnp->qsmaskinit & bit) != 0)
+					*isidle = 0;
+				if (f(per_cpu_ptr(rsp->rda, cpu), isidle, maxj))
+					mask |= bit;
+			}
 		}
 		if (mask != 0) {
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 1895043..7326a3c 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -555,6 +555,11 @@ static void rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
 static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
 static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq);
+static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
+				  unsigned long *maxj);
+static bool is_sysidle_rcu_state(struct rcu_state *rsp);
+static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
+			       unsigned long maxj);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a4b2c09..9b60df5 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -28,7 +28,7 @@
 #include <linux/gfp.h>
 #include <linux/oom.h>
 #include <linux/smpboot.h>
-#include <linux/tick.h>
+#include "time/tick-internal.h"
 
 #define RCU_KTHREAD_PRIO 1
 
@@ -2395,12 +2395,12 @@ static void rcu_kick_nohz_cpu(int cpu)
  * most active flavor of RCU.
  */
 #ifdef CONFIG_PREEMPT_RCU
-static struct rcu_state __maybe_unused *rcu_sysidle_state = &rcu_preempt_state;
+static struct rcu_state *rcu_sysidle_state = &rcu_preempt_state;
 #else /* #ifdef CONFIG_PREEMPT_RCU */
-static struct rcu_state __maybe_unused *rcu_sysidle_state = &rcu_sched_state;
+static struct rcu_state *rcu_sysidle_state = &rcu_sched_state;
 #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
-static int __maybe_unused full_sysidle_state; /* Current system-idle state. */
+static int full_sysidle_state;		/* Current system-idle state. */
 #define RCU_SYSIDLE_NOT		0	/* Some CPU is not idle. */
 #define RCU_SYSIDLE_SHORT	1	/* All CPUs idle for brief period. */
 #define RCU_SYSIDLE_FULL	2	/* All CPUs idle, ready for sysidle. */
@@ -2442,6 +2442,38 @@ static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
 }
 
 /*
+ * Unconditionally force exit from full system-idle state.  This is
+ * invoked when a normal CPU exits idle, but must be called separately
+ * for the timekeeping CPU (tick_do_timer_cpu).  The reason for this
+ * is that the timekeeping CPU is permitted to take scheduling-clock
+ * interrupts while the system is in system-idle state, and of course
+ * rcu_sysidle_exit() has no way of distinguishing a scheduling-clock
+ * interrupt from any other type of interrupt.
+ */
+void rcu_sysidle_force_exit(void)
+{
+	int oldstate = ACCESS_ONCE(full_sysidle_state);
+	int newoldstate;
+
+	/*
+	 * Each pass through the following loop attempts to exit full
+	 * system-idle state.  If contention proves to be a problem,
+	 * a trylock-based contention tree could be used here.
+	 */
+	while (oldstate > RCU_SYSIDLE_SHORT) {
+		newoldstate = cmpxchg(&full_sysidle_state,
+				      oldstate, RCU_SYSIDLE_NOT);
+		if (oldstate == newoldstate &&
+		    oldstate == RCU_SYSIDLE_FULL_NOTED) {
+			rcu_kick_nohz_cpu(tick_do_timer_cpu);
+			return; /* We cleared it, done! */
+		}
+		oldstate = newoldstate;
+	}
+	smp_mb(); /* Order initial oldstate fetch vs. later non-idle work. */
+}
+
+/*
  * Invoked to note entry to irq or task transition from idle.  Note that
  * usermode execution does -not- count as idle here!  The caller must
  * have disabled interrupts.
@@ -2474,6 +2506,214 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
 	atomic_inc(&rdtp->dynticks_idle);
 	smp_mb__after_atomic_inc();
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks_idle) & 0x1));
+
+	/*
+	 * If we are the timekeeping CPU, we are permitted to be non-idle
+	 * during a system-idle state.  This must be the case, because
+	 * the timekeeping CPU has to take scheduling-clock interrupts
+	 * during the time that the system is transitioning to full
+	 * system-idle state.  This means that the timekeeping CPU must
+	 * invoke rcu_sysidle_force_exit() directly if it does anything
+	 * more than take a scheduling-clock interrupt.
+	 */
+	if (smp_processor_id() == tick_do_timer_cpu)
+		return;
+
+	/* Update system-idle state: We are clearly no longer fully idle! */
+	rcu_sysidle_force_exit();
+}
+
+/*
+ * Check to see if the current CPU is idle.  Note that usermode execution
+ * does not count as idle.  The caller must have disabled interrupts.
+ */
+static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
+				  unsigned long *maxj)
+{
+	int cur;
+	int curnmi;
+	unsigned long j;
+	struct rcu_dynticks *rdtp = rdp->dynticks;
+
+	/*
+	 * If some other CPU has already reported non-idle, if this is
+	 * not the flavor of RCU that tracks sysidle state, or if this
+	 * is an offline or the timekeeping CPU, nothing to do.
+	 */
+	if (!*isidle || rdp->rsp != rcu_sysidle_state ||
+	    cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
+		return;
+	/* WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu); */
+
+	/*
+	 * Pick up current idle and NMI-nesting counters, check.  We check
+	 * for NMIs using RCU's main ->dynticks counter.  This works because
+	 * any time ->dynticks has its low bit set, ->dynticks_idle will
+	 * too -- unless the only reason that ->dynticks's low bit is set
+	 * is due to an NMI from idle.  Which is exactly the case we need
+	 * to account for.
+	 */
+	cur = atomic_read(&rdtp->dynticks_idle);
+	curnmi = atomic_read(&rdtp->dynticks);
+	if ((cur & 0x1) || (curnmi & 0x1)) {
+		*isidle = 0; /* We are not idle! */
+		return;
+	}
+	smp_mb(); /* Read counters before timestamps. */
+
+	/* Pick up timestamps. */
+	j = ACCESS_ONCE(rdtp->dynticks_idle_jiffies);
+	/* If this CPU entered idle more recently, update maxj timestamp. */
+	if (ULONG_CMP_LT(*maxj, j))
+		*maxj = j;
+}
+
+/*
+ * Is this the flavor of RCU that is handling full-system idle?
+ */
+static bool is_sysidle_rcu_state(struct rcu_state *rsp)
+{
+	return rsp == rcu_sysidle_state;
+}
+
+/*
+ * Return a delay in jiffies based on the number of CPUs, rcu_node
+ * leaf fanout, and jiffies tick rate.  The idea is to allow larger
+ * systems more time to transition to full-idle state in order to
+ * avoid the cache thrashing that otherwise occur on the state variable.
+ * Really small systems (less than a couple of tens of CPUs) should
+ * instead use a single global atomically incremented counter, and later
+ * versions of this will automatically reconfigure themselves accordingly.
+ */
+static unsigned long rcu_sysidle_delay(void)
+{
+	if (nr_cpu_ids <= RCU_SYSIDLE_SMALL)
+		return 0;
+	return DIV_ROUND_UP(nr_cpu_ids * HZ, rcu_fanout_leaf * 1000);
+}
+
+/*
+ * Advance the full-system-idle state.  This is invoked when all of
+ * the non-timekeeping CPUs are idle.
+ */
+static void rcu_sysidle(unsigned long j)
+{
+	/* Check the current state. */
+	switch (ACCESS_ONCE(full_sysidle_state)) {
+	case RCU_SYSIDLE_NOT:
+
+		/* First time all are idle, so note a short idle period. */
+		ACCESS_ONCE(full_sysidle_state) = RCU_SYSIDLE_SHORT;
+		break;
+
+	case RCU_SYSIDLE_SHORT:
+
+		/*
+		 * Idle for a bit, time to advance to next state?
+		 * cmpxchg failure means race with non-idle, let them win.
+		 */
+		if (ULONG_CMP_GE(jiffies, j + rcu_sysidle_delay()))
+			(void)cmpxchg(&full_sysidle_state,
+				      RCU_SYSIDLE_SHORT, RCU_SYSIDLE_FULL);
+		break;
+
+	default:
+		break;
+	}
+}
+
+/*
+ * Found a non-idle non-timekeeping CPU, so kick the system-idle state
+ * back to the beginning.
+ */
+static void rcu_sysidle_cancel(void)
+{
+	smp_mb();
+	ACCESS_ONCE(full_sysidle_state) = RCU_SYSIDLE_NOT;
+}
+
+/*
+ * Update the sysidle state based on the results of a force-quiescent-state
+ * scan of the CPUs' dyntick-idle state.
+ */
+static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
+			       unsigned long maxj)
+{
+	if (rsp != rcu_sysidle_state)
+		return;  /* Wrong flavor, ignore. */
+	if (isidle)
+		rcu_sysidle(maxj);    /* More idle! */
+	else
+		rcu_sysidle_cancel(); /* Idle is over. */
+}
+
+/* Callback and function for forcing an RCU grace period. */
+struct rcu_sysidle_head {
+	struct rcu_head rh;
+	int inuse;
+};
+
+static void rcu_sysidle_cb(struct rcu_head *rhp)
+{
+	struct rcu_sysidle_head *rshp;
+
+	smp_mb();  /* grace period precedes setting inuse. */
+	rshp = container_of(rhp, struct rcu_sysidle_head, rh);
+	ACCESS_ONCE(rshp->inuse) = 0;
+}
+
+/*
+ * Check to see if the system is fully idle, other than the timekeeping CPU.
+ * The caller must have disabled interrupts.
+ */
+bool rcu_sys_is_idle(void)
+{
+	static struct rcu_sysidle_head rsh;
+	int rss = ACCESS_ONCE(full_sysidle_state);
+
+	WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);
+
+	/* Handle small-system case by doing a full scan of CPUs. */
+	if (nr_cpu_ids <= RCU_SYSIDLE_SMALL && rss < RCU_SYSIDLE_FULL) {
+		int cpu;
+		bool isidle = true;
+		unsigned long maxj = jiffies - ULONG_MAX / 4;
+		struct rcu_data *rdp;
+
+		/* Scan all the CPUs looking for nonidle CPUs. */
+		for_each_possible_cpu(cpu) {
+			rdp = per_cpu_ptr(rcu_sysidle_state->rda, cpu);
+			rcu_sysidle_check_cpu(rdp, &isidle, &maxj);
+			if (!isidle)
+				break;
+		}
+		rcu_sysidle_report(rcu_sysidle_state, isidle, maxj);
+		rss = ACCESS_ONCE(full_sysidle_state);
+	}
+
+	/* If this is the first observation of an idle period, record it. */
+	if (rss == RCU_SYSIDLE_FULL) {
+		rss = cmpxchg(&full_sysidle_state,
+			      RCU_SYSIDLE_FULL, RCU_SYSIDLE_FULL_NOTED);
+		return rss == RCU_SYSIDLE_FULL;
+	}
+
+	smp_mb(); /* ensure rss load happens before later caller actions. */
+
+	/* If already fully idle, tell the caller (in case of races). */
+	if (rss == RCU_SYSIDLE_FULL_NOTED)
+		return true;
+
+	/*
+	 * If we aren't there yet, and a grace period is not in flight,
+	 * initiate a grace period.  Either way, tell the caller that
+	 * we are not there yet.
+	 */
+	if (nr_cpu_ids > RCU_SYSIDLE_SMALL &&
+	    !rcu_gp_in_progress(rcu_sysidle_state) &&
+	    !rsh.inuse && xchg(&rsh.inuse, 1) == 0)
+		call_rcu(&rsh.rh, rcu_sysidle_cb);
+	return false;
 }
 
 /*
@@ -2494,6 +2734,21 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
 {
 }
 
+static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
+				  unsigned long *maxj)
+{
+}
+
+static bool is_sysidle_rcu_state(struct rcu_state *rsp)
+{
+	return false;
+}
+
+static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
+			       unsigned long maxj)
+{
+}
+
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
 {
 }
-- 
1.8.1.5

