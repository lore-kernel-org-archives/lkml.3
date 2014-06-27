Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaF0OUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:20:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55325 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbaF0OUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:20:46 -0400
Date: Fri, 27 Jun 2014 07:20:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, riel@redhat.com
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140627142038.GA22942@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062714-9332-0000-0000-00000137DF5C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An 80-CPU system with a context-switch-heavy workload can require so
many NOCB kthread wakeups that the RCU grace-period kthreads spend several
tens of percent of a CPU just awakening things.  This clearly will not
scale well: If you add enough CPUs, the RCU grace-period kthreads would
get behind, increasing grace-period latency.

To avoid this problem, this commit divides the NOCB kthreads into leaders
and followers, where the grace-period kthreads awaken the leaders each of
whom in turn awakens its followers.  By default, the number of groups of
kthreads is the square root of the number of CPUs, but this default may
be overridden using the rcutree.rcu_nocb_leader_stride boot parameter.
This reduces the number of wakeups done per grace period by the RCU
grace-period kthread by the square root of the number of CPUs, but of
course by shifting those wakeups to the leaders.  In addition, because
the leaders do grace periods on behalf of their respective followers,
the number of wakeups of the followers decreases by up to a factor of two.
Instead of being awakened once when new callbacks arrive and again
at the end of the grace period, the followers are awakened only at
the end of the grace period.

For a numerical example, in a 4096-CPU system, the grace-period kthread
would awaken 64 leaders, each of which would awaken its 63 followers
at the end of the grace period.  This compares favorably with the 79
wakeups for the grace-period kthread on an 80-CPU system.

Reported-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6eaa9cdb7094..affed6434ec8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2796,6 +2796,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			quiescent states.  Units are jiffies, minimum
 			value is one, and maximum value is HZ.
 
+	rcutree.rcu_nocb_leader_stride= [KNL]
+			Set the number of NOCB kthread groups, which
+			defaults to the square root of the number of
+			CPUs.  Larger numbers reduces the wakeup overhead
+			on the per-CPU grace-period kthreads, but increases
+			that same overhead on each group's leader.
+
 	rcutree.qhimark= [KNL]
 			Set threshold of queued RCU callbacks beyond which
 			batch limiting is disabled.
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index bf2c1e669691..de12fa5a860b 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -331,11 +331,29 @@ struct rcu_data {
 	struct rcu_head **nocb_tail;
 	atomic_long_t nocb_q_count;	/* # CBs waiting for kthread */
 	atomic_long_t nocb_q_count_lazy; /*  (approximate). */
+	struct rcu_head *nocb_follower_head; /* CBs ready to invoke. */
+	struct rcu_head **nocb_follower_tail;
+	atomic_long_t nocb_follower_count; /* # CBs ready to invoke. */
+	atomic_long_t nocb_follower_count_lazy; /*  (approximate). */
 	int nocb_p_count;		/* # CBs being invoked by kthread */
 	int nocb_p_count_lazy;		/*  (approximate). */
 	wait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
 	struct task_struct *nocb_kthread;
 	bool nocb_defer_wakeup;		/* Defer wakeup of nocb_kthread. */
+
+	/* The following fields are used by the leader, hence own cacheline. */
+	struct rcu_head *nocb_gp_head ____cacheline_internodealigned_in_smp;
+					/* CBs waiting for GP. */
+	struct rcu_head **nocb_gp_tail;
+	long nocb_gp_count;
+	long nocb_gp_count_lazy;
+	bool nocb_leader_wake;		/* Is the nocb leader thread awake? */
+	struct rcu_data *nocb_next_follower;
+					/* Next follower in wakeup chain. */
+
+	/* The following fields are used by the follower, hence new cachline. */
+	struct rcu_data *nocb_leader ____cacheline_internodealigned_in_smp;
+					/* Leader CPU takes GP-end wakeups. */
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 	/* 8) RCU CPU stall data. */
@@ -583,8 +601,14 @@ static bool rcu_nohz_full_cpu(struct rcu_state *rsp);
 /* Sum up queue lengths for tracing. */
 static inline void rcu_nocb_q_lengths(struct rcu_data *rdp, long *ql, long *qll)
 {
-	*ql = atomic_long_read(&rdp->nocb_q_count) + rdp->nocb_p_count;
-	*qll = atomic_long_read(&rdp->nocb_q_count_lazy) + rdp->nocb_p_count_lazy;
+	*ql = atomic_long_read(&rdp->nocb_q_count) +
+	      rdp->nocb_p_count +
+	      atomic_long_read(&rdp->nocb_follower_count) +
+	      rdp->nocb_p_count + rdp->nocb_gp_count;
+	*qll = atomic_long_read(&rdp->nocb_q_count_lazy) +
+	       rdp->nocb_p_count_lazy +
+	       atomic_long_read(&rdp->nocb_follower_count_lazy) +
+	       rdp->nocb_p_count_lazy + rdp->nocb_gp_count_lazy;
 }
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 static inline void rcu_nocb_q_lengths(struct rcu_data *rdp, long *ql, long *qll)
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index cbc2c45265e2..58fbb8204d15 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2060,6 +2060,22 @@ bool rcu_is_nocb_cpu(int cpu)
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 
 /*
+ * Kick the leader kthread for this NOCB group.
+ */
+static void wake_nocb_leader(struct rcu_data *rdp, bool force)
+{
+	struct rcu_data *rdp_leader = rdp->nocb_leader;
+
+	if (!ACCESS_ONCE(rdp_leader->nocb_kthread))
+		return;
+	if (!ACCESS_ONCE(rdp_leader->nocb_leader_wake) || force) {
+		/* Prior xchg orders against prior callback enqueue. */
+		ACCESS_ONCE(rdp_leader->nocb_leader_wake) = true;
+		wake_up(&rdp_leader->nocb_wq);
+	}
+}
+
+/*
  * Enqueue the specified string of rcu_head structures onto the specified
  * CPU's no-CBs lists.  The CPU is specified by rdp, the head of the
  * string by rhp, and the tail of the string by rhtp.  The non-lazy/lazy
@@ -2093,7 +2109,8 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 	len = atomic_long_read(&rdp->nocb_q_count);
 	if (old_rhpp == &rdp->nocb_head) {
 		if (!irqs_disabled_flags(flags)) {
-			wake_up(&rdp->nocb_wq); /* ... if queue was empty ... */
+			/* ... if queue was empty ... */
+			wake_nocb_leader(rdp, false);
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 					    TPS("WakeEmpty"));
 		} else {
@@ -2103,7 +2120,8 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 		}
 		rdp->qlen_last_fqs_check = 0;
 	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
-		wake_up_process(t); /* ... or if many callbacks queued. */
+		/* ... or if many callbacks queued. */
+		wake_nocb_leader(rdp, true);
 		rdp->qlen_last_fqs_check = LONG_MAX / 2;
 		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeOvf"));
 	} else {
@@ -2213,13 +2231,150 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 }
 
 /*
+ * Leaders come here to wait for additional callbacks to show up.
+ * This function does not return until callbacks appear.
+ */
+static void nocb_leader_wait(struct rcu_data *my_rdp)
+{
+	bool firsttime = true;
+	bool gotcbs;
+	struct rcu_data *rdp;
+	struct rcu_head **tail;
+
+wait_again:
+
+	/* Wait for callbacks to appear. */
+	if (!rcu_nocb_poll) {
+		trace_rcu_nocb_wake(my_rdp->rsp->name, my_rdp->cpu, "Sleep");
+		wait_event_interruptible(my_rdp->nocb_wq,
+					 ACCESS_ONCE(my_rdp->nocb_leader_wake));
+		/* Memory barrier handled by smp_mb() calls below and repoll. */
+	} else if (firsttime) {
+		firsttime = false; /* Don't drown trace log with "Poll"! */
+		trace_rcu_nocb_wake(my_rdp->rsp->name, my_rdp->cpu, "Poll");
+	}
+
+	/*
+	 * Each pass through the following loop checks a follower for CBs.
+	 * We are our own first follower.  Any CBs found are moved to
+	 * nocb_gp_head, where they await a grace period.
+	 */
+	gotcbs = false;
+	for (rdp = my_rdp; rdp; rdp = rdp->nocb_next_follower) {
+		rdp->nocb_gp_head = ACCESS_ONCE(rdp->nocb_head);
+		if (!rdp->nocb_gp_head)
+			continue;  /* No CBs here, try next follower. */
+
+		/* Move callbacks to wait-for-GP list, which is empty. */
+		ACCESS_ONCE(rdp->nocb_head) = NULL;
+		rdp->nocb_gp_tail = xchg(&rdp->nocb_tail, &rdp->nocb_head);
+		rdp->nocb_gp_count = atomic_xchg(&rdp->nocb_q_count, 0);
+		rdp->nocb_gp_count_lazy =
+			atomic_xchg(&rdp->nocb_q_count_lazy, 0);
+		gotcbs = true;
+	}
+
+	/*
+	 * If there were no callbacks, sleep a bit, rescan after a
+	 * memory barrier, and go retry.
+	 */
+	if (unlikely(!gotcbs)) {
+		if (!rcu_nocb_poll)
+			trace_rcu_nocb_wake(my_rdp->rsp->name, my_rdp->cpu,
+					    "WokeEmpty");
+		flush_signals(current);
+		schedule_timeout_interruptible(1);
+
+		/* Rescan in case we were a victim of memory ordering. */
+		my_rdp->nocb_leader_wake = false;
+		smp_mb();  /* Ensure _wake false before scan. */
+		for (rdp = my_rdp; rdp; rdp = rdp->nocb_next_follower)
+			if (ACCESS_ONCE(rdp->nocb_head)) {
+				/* Found CB, so short-circuit next wait. */
+				my_rdp->nocb_leader_wake = true;
+				break;
+			}
+		goto wait_again;
+	}
+
+	/* Wait for one grace period. */
+	rcu_nocb_wait_gp(my_rdp);
+
+	/*
+	 * We left ->nocb_leader_wake set to reduce cache thrashing.
+	 * We clear it now, but recheck for new callbacks while
+	 * traversing our follower list.
+	 */
+	my_rdp->nocb_leader_wake = false;
+	smp_mb(); /* Ensure _wake false before scan of ->nocb_head. */
+
+	/* Each pass through the following loop wakes a follower, if needed. */
+	for (rdp = my_rdp; rdp; rdp = rdp->nocb_next_follower) {
+		if (ACCESS_ONCE(rdp->nocb_head))
+			my_rdp->nocb_leader_wake = true; /* No need to wait. */
+		if (!rdp->nocb_gp_head)
+			continue; /* No CBs, so no need to wake follower. */
+
+		/* Append callbacks to follower's "done" list. */
+		tail = xchg(&rdp->nocb_follower_tail, rdp->nocb_gp_tail);
+		*tail = rdp->nocb_gp_head;
+		atomic_long_add(rdp->nocb_gp_count, &rdp->nocb_follower_count);
+		atomic_long_add(rdp->nocb_gp_count_lazy,
+				&rdp->nocb_follower_count_lazy);
+		if (rdp != my_rdp && tail == &rdp->nocb_follower_head) {
+			/*
+			 * List was empty, wake up the follower.
+			 * Memory barriers supplied by atomic_long_add().
+			 */
+			wake_up(&rdp->nocb_wq);
+		}
+	}
+
+	/* If we (the leader) don't have CBs, go wait some more. */
+	if (!my_rdp->nocb_follower_head)
+		goto wait_again;
+}
+
+/*
+ * Followers come here to wait for additional callbacks to show up.
+ * This function does not return until callbacks appear.
+ */
+static void nocb_follower_wait(struct rcu_data *rdp)
+{
+	bool firsttime = true;
+
+	for (;;) {
+		if (!rcu_nocb_poll) {
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    "FollowerSleep");
+			wait_event_interruptible(rdp->nocb_wq,
+						 ACCESS_ONCE(rdp->nocb_follower_head));
+		} else if (firsttime) {
+			/* Don't drown trace log with "Poll"! */
+			firsttime = false;
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, "Poll");
+		}
+		if (smp_load_acquire(&rdp->nocb_follower_head)) {
+			/* ^^^ Ensure CB invocation follows _head test. */
+			return;
+		}
+		if (!rcu_nocb_poll)
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    "WokeEmpty");
+		flush_signals(current);
+		schedule_timeout_interruptible(1);
+	}
+}
+
+/*
  * Per-rcu_data kthread, but only for no-CBs CPUs.  Each kthread invokes
- * callbacks queued by the corresponding no-CBs CPU.
+ * callbacks queued by the corresponding no-CBs CPU, however, there is
+ * an optional leader-follower relationship so that the grace-period
+ * kthreads don't have to do quite so many wakeups.
  */
 static int rcu_nocb_kthread(void *arg)
 {
 	int c, cl;
-	bool firsttime = 1;
 	struct rcu_head *list;
 	struct rcu_head *next;
 	struct rcu_head **tail;
@@ -2227,41 +2382,22 @@ static int rcu_nocb_kthread(void *arg)
 
 	/* Each pass through this loop invokes one batch of callbacks */
 	for (;;) {
-		/* If not polling, wait for next batch of callbacks. */
-		if (!rcu_nocb_poll) {
-			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
-					    TPS("Sleep"));
-			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
-			/* Memory barrier provide by xchg() below. */
-		} else if (firsttime) {
-			firsttime = 0;
-			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
-					    TPS("Poll"));
-		}
-		list = ACCESS_ONCE(rdp->nocb_head);
-		if (!list) {
-			if (!rcu_nocb_poll)
-				trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
-						    TPS("WokeEmpty"));
-			schedule_timeout_interruptible(1);
-			flush_signals(current);
-			continue;
-		}
-		firsttime = 1;
-		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
-				    TPS("WokeNonEmpty"));
-
-		/*
-		 * Extract queued callbacks, update counts, and wait
-		 * for a grace period to elapse.
-		 */
-		ACCESS_ONCE(rdp->nocb_head) = NULL;
-		tail = xchg(&rdp->nocb_tail, &rdp->nocb_head);
-		c = atomic_long_xchg(&rdp->nocb_q_count, 0);
-		cl = atomic_long_xchg(&rdp->nocb_q_count_lazy, 0);
-		ACCESS_ONCE(rdp->nocb_p_count) += c;
-		ACCESS_ONCE(rdp->nocb_p_count_lazy) += cl;
-		rcu_nocb_wait_gp(rdp);
+		/* Wait for callbacks. */
+		if (rdp->nocb_leader == rdp)
+			nocb_leader_wait(rdp);
+		else
+			nocb_follower_wait(rdp);
+
+		/* Pull the ready-to-invoke callbacks onto local list. */
+		list = ACCESS_ONCE(rdp->nocb_follower_head);
+		BUG_ON(!list);
+		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, "WokeNonEmpty");
+		ACCESS_ONCE(rdp->nocb_follower_head) = NULL;
+		tail = xchg(&rdp->nocb_follower_tail, &rdp->nocb_follower_head);
+		c = atomic_long_xchg(&rdp->nocb_follower_count, 0);
+		cl = atomic_long_xchg(&rdp->nocb_follower_count_lazy, 0);
+		rdp->nocb_p_count += c;
+		rdp->nocb_p_count_lazy += cl;
 
 		/* Each pass through the following loop invokes a callback. */
 		trace_rcu_batch_start(rdp->rsp->name, cl, c, -1);
@@ -2305,7 +2441,7 @@ static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
 	if (!rcu_nocb_need_deferred_wakeup(rdp))
 		return;
 	ACCESS_ONCE(rdp->nocb_defer_wakeup) = false;
-	wake_up(&rdp->nocb_wq);
+	wake_nocb_leader(rdp, false);
 	trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("DeferredWakeEmpty"));
 }
 
@@ -2314,19 +2450,53 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 {
 	rdp->nocb_tail = &rdp->nocb_head;
 	init_waitqueue_head(&rdp->nocb_wq);
+	rdp->nocb_follower_tail = &rdp->nocb_follower_head;
 }
 
-/* Create a kthread for each RCU flavor for each no-CBs CPU. */
+/* How many follower CPU IDs per leader?  Default of -1 for sqrt(nr_cpu_ids). */
+static int rcu_nocb_leader_stride = -1;
+module_param(rcu_nocb_leader_stride, int, 0444);
+
+/*
+ * Create a kthread for each RCU flavor for each no-CBs CPU.
+ * Also initialize leader-follower relationships.
+ */
 static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 {
 	int cpu;
+	int ls = rcu_nocb_leader_stride;
+	int nl = 0;  /* Next leader. */
 	struct rcu_data *rdp;
+	struct rcu_data *rdp_leader = NULL;  /* Suppress misguided gcc warn. */
+	struct rcu_data *rdp_prev = NULL;
 	struct task_struct *t;
 
 	if (rcu_nocb_mask == NULL)
 		return;
+	if (ls == -1) {
+		ls = int_sqrt(nr_cpu_ids);
+		rcu_nocb_leader_stride = ls;
+	}
+
+	/*
+	 * Each pass through this loop sets up one rcu_data structure and
+	 * spawns one rcu_nocb_kthread().
+	 */
 	for_each_cpu(cpu, rcu_nocb_mask) {
 		rdp = per_cpu_ptr(rsp->rda, cpu);
+		if (rdp->cpu >= nl) {
+			/* New leader, set up for followers & next leader. */
+			nl = DIV_ROUND_UP(rdp->cpu + 1, ls) * ls;
+			rdp->nocb_leader = rdp;
+			rdp_leader = rdp;
+		} else {
+			/* Another follower, link to previous leader. */
+			rdp->nocb_leader = rdp_leader;
+			rdp_prev->nocb_next_follower = rdp;
+		}
+		rdp_prev = rdp;
+
+		/* Spawn the kthread for this CPU. */
 		t = kthread_run(rcu_nocb_kthread, rdp,
 				"rcuo%c/%d", rsp->abbr, cpu);
 		BUG_ON(IS_ERR(t));

