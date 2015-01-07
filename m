Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbbAGSU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:20:29 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:39525 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbbAGSTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:53 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/12] rcutorture: Check from beginning to end of grace period
Date: Wed,  7 Jan 2015 10:19:34 -0800
Message-Id: <1420654779-11213-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107181915.GA7803@linux.vnet.ibm.com>
 <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-0009-0000-0000-000007C69343
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, rcutorture's Reader Batch checks measure from the end of
the previous grace period to the end of the current one.  This commit
tightens up these checks by measuring from the start and end of the same
grace period.  This involves adding rcu_batches_started() and friends
corresponding to the existing rcu_batches_completed() and friends.

We leave SRCU alone for the moment, as it does not yet have a way of
tracking both ends of its grace periods.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutiny.h  | 30 +++++++++++++++++++++++++++---
 include/linux/rcutree.h  |  3 +++
 kernel/rcu/rcutorture.c  | 37 +++++++++++++++++++++++++++----------
 kernel/rcu/tree.c        | 40 ++++++++++++++++++++++++++++++++++++++--
 kernel/rcu/tree_plugin.h | 28 ----------------------------
 5 files changed, 95 insertions(+), 43 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 1ce2d6b8f0c3..984192160e9b 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -92,7 +92,31 @@ static inline void rcu_virt_note_context_switch(int cpu)
 }
 
 /*
- * Return the number of grace periods.
+ * Return the number of grace periods started.
+ */
+static inline unsigned long rcu_batches_started(void)
+{
+	return 0;
+}
+
+/*
+ * Return the number of bottom-half grace periods started.
+ */
+static inline unsigned long rcu_batches_started_bh(void)
+{
+	return 0;
+}
+
+/*
+ * Return the number of sched grace periods started.
+ */
+static inline unsigned long rcu_batches_started_sched(void)
+{
+	return 0;
+}
+
+/*
+ * Return the number of grace periods completed.
  */
 static inline unsigned long rcu_batches_completed(void)
 {
@@ -100,7 +124,7 @@ static inline unsigned long rcu_batches_completed(void)
 }
 
 /*
- * Return the number of bottom-half grace periods.
+ * Return the number of bottom-half grace periods completed.
  */
 static inline unsigned long rcu_batches_completed_bh(void)
 {
@@ -108,7 +132,7 @@ static inline unsigned long rcu_batches_completed_bh(void)
 }
 
 /*
- * Return the number of sched grace periods.
+ * Return the number of sched grace periods completed.
  */
 static inline unsigned long rcu_batches_completed_sched(void)
 {
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 9885bfb6b123..c0dd124e69ec 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -81,6 +81,9 @@ void cond_synchronize_rcu(unsigned long oldstate);
 
 extern unsigned long rcutorture_testseq;
 extern unsigned long rcutorture_vernum;
+unsigned long rcu_batches_started(void);
+unsigned long rcu_batches_started_bh(void);
+unsigned long rcu_batches_started_sched(void);
 unsigned long rcu_batches_completed(void);
 unsigned long rcu_batches_completed_bh(void);
 unsigned long rcu_batches_completed_sched(void);
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index aadbc072ccf4..24142c200901 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -244,6 +244,7 @@ struct rcu_torture_ops {
 	int (*readlock)(void);
 	void (*read_delay)(struct torture_random_state *rrsp);
 	void (*readunlock)(int idx);
+	unsigned long (*started)(void);
 	unsigned long (*completed)(void);
 	void (*deferred_free)(struct rcu_torture *p);
 	void (*sync)(void);
@@ -372,6 +373,7 @@ static struct rcu_torture_ops rcu_ops = {
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,
 	.readunlock	= rcu_torture_read_unlock,
+	.started	= rcu_batches_started,
 	.completed	= rcu_batches_completed,
 	.deferred_free	= rcu_torture_deferred_free,
 	.sync		= synchronize_rcu,
@@ -413,6 +415,7 @@ static struct rcu_torture_ops rcu_bh_ops = {
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_bh_torture_read_unlock,
+	.started	= rcu_batches_started_bh,
 	.completed	= rcu_batches_completed_bh,
 	.deferred_free	= rcu_bh_torture_deferred_free,
 	.sync		= synchronize_rcu_bh,
@@ -456,6 +459,7 @@ static struct rcu_torture_ops rcu_busted_ops = {
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= rcu_torture_read_unlock,
+	.started	= rcu_no_completed,
 	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_busted_torture_deferred_free,
 	.sync		= synchronize_rcu_busted,
@@ -554,6 +558,7 @@ static struct rcu_torture_ops srcu_ops = {
 	.readlock	= srcu_torture_read_lock,
 	.read_delay	= srcu_read_delay,
 	.readunlock	= srcu_torture_read_unlock,
+	.started	= NULL,
 	.completed	= srcu_torture_completed,
 	.deferred_free	= srcu_torture_deferred_free,
 	.sync		= srcu_torture_synchronize,
@@ -590,6 +595,7 @@ static struct rcu_torture_ops sched_ops = {
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= sched_torture_read_unlock,
+	.started	= rcu_batches_started_sched,
 	.completed	= rcu_batches_completed_sched,
 	.deferred_free	= rcu_sched_torture_deferred_free,
 	.sync		= synchronize_sched,
@@ -628,6 +634,7 @@ static struct rcu_torture_ops tasks_ops = {
 	.readlock	= tasks_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock	= tasks_torture_read_unlock,
+	.started	= rcu_no_completed,
 	.completed	= rcu_no_completed,
 	.deferred_free	= rcu_tasks_torture_deferred_free,
 	.sync		= synchronize_rcu_tasks,
@@ -1005,8 +1012,8 @@ static void rcutorture_trace_dump(void)
 static void rcu_torture_timer(unsigned long unused)
 {
 	int idx;
+	unsigned long started;
 	unsigned long completed;
-	unsigned long completed_end;
 	static DEFINE_TORTURE_RANDOM(rand);
 	static DEFINE_SPINLOCK(rand_lock);
 	struct rcu_torture *p;
@@ -1014,7 +1021,10 @@ static void rcu_torture_timer(unsigned long unused)
 	unsigned long long ts;
 
 	idx = cur_ops->readlock();
-	completed = cur_ops->completed();
+	if (cur_ops->started)
+		started = cur_ops->started();
+	else
+		started = cur_ops->completed();
 	ts = rcu_trace_clock_local();
 	p = rcu_dereference_check(rcu_torture_current,
 				  rcu_read_lock_bh_held() ||
@@ -1037,14 +1047,16 @@ static void rcu_torture_timer(unsigned long unused)
 		/* Should not happen, but... */
 		pipe_count = RCU_TORTURE_PIPE_LEN;
 	}
-	completed_end = cur_ops->completed();
+	completed = cur_ops->completed();
 	if (pipe_count > 1) {
 		do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu, ts,
-					  completed, completed_end);
+					  started, completed);
 		rcutorture_trace_dump();
 	}
 	__this_cpu_inc(rcu_torture_count[pipe_count]);
-	completed = completed_end - completed;
+	completed = completed - started;
+	if (cur_ops->started)
+		completed++;
 	if (completed > RCU_TORTURE_PIPE_LEN) {
 		/* Should not happen, but... */
 		completed = RCU_TORTURE_PIPE_LEN;
@@ -1063,8 +1075,8 @@ static void rcu_torture_timer(unsigned long unused)
 static int
 rcu_torture_reader(void *arg)
 {
+	unsigned long started;
 	unsigned long completed;
-	unsigned long completed_end;
 	int idx;
 	DEFINE_TORTURE_RANDOM(rand);
 	struct rcu_torture *p;
@@ -1083,7 +1095,10 @@ rcu_torture_reader(void *arg)
 				mod_timer(&t, jiffies + 1);
 		}
 		idx = cur_ops->readlock();
-		completed = cur_ops->completed();
+		if (cur_ops->started)
+			started = cur_ops->started();
+		else
+			started = cur_ops->completed();
 		ts = rcu_trace_clock_local();
 		p = rcu_dereference_check(rcu_torture_current,
 					  rcu_read_lock_bh_held() ||
@@ -1104,14 +1119,16 @@ rcu_torture_reader(void *arg)
 			/* Should not happen, but... */
 			pipe_count = RCU_TORTURE_PIPE_LEN;
 		}
-		completed_end = cur_ops->completed();
+		completed = cur_ops->completed();
 		if (pipe_count > 1) {
 			do_trace_rcu_torture_read(cur_ops->name, &p->rtort_rcu,
-						  ts, completed, completed_end);
+						  ts, started, completed);
 			rcutorture_trace_dump();
 		}
 		__this_cpu_inc(rcu_torture_count[pipe_count]);
-		completed = completed_end - completed;
+		completed = completed - started;
+		if (cur_ops->started)
+			completed++;
 		if (completed > RCU_TORTURE_PIPE_LEN) {
 			/* Should not happen, but... */
 			completed = RCU_TORTURE_PIPE_LEN;
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index e26d78712e16..c0faad51ae87 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -315,7 +315,43 @@ static void force_quiescent_state(struct rcu_state *rsp);
 static int rcu_pending(void);
 
 /*
- * Return the number of RCU-sched batches processed thus far for debug & stats.
+ * Return the number of RCU batches started thus far for debug & stats.
+ */
+unsigned long rcu_batches_started(void)
+{
+	return rcu_state_p->gpnum;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_started);
+
+/*
+ * Return the number of RCU-sched batches started thus far for debug & stats.
+ */
+unsigned long rcu_batches_started_sched(void)
+{
+	return rcu_sched_state.gpnum;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_started_sched);
+
+/*
+ * Return the number of RCU BH batches started thus far for debug & stats.
+ */
+unsigned long rcu_batches_started_bh(void)
+{
+	return rcu_bh_state.gpnum;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_started_bh);
+
+/*
+ * Return the number of RCU batches completed thus far for debug & stats.
+ */
+unsigned long rcu_batches_completed(void)
+{
+	return rcu_state_p->completed;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed);
+
+/*
+ * Return the number of RCU-sched batches completed thus far for debug & stats.
  */
 unsigned long rcu_batches_completed_sched(void)
 {
@@ -324,7 +360,7 @@ unsigned long rcu_batches_completed_sched(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed_sched);
 
 /*
- * Return the number of RCU BH batches processed thus far for debug & stats.
+ * Return the number of RCU BH batches completed thus far for debug & stats.
  */
 unsigned long rcu_batches_completed_bh(void)
 {
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index f69300d4a51f..07e61a04de1d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -114,25 +114,6 @@ static void __init rcu_bootup_announce(void)
 }
 
 /*
- * Return the number of RCU-preempt batches processed thus far
- * for debug and statistics.
- */
-static unsigned long rcu_batches_completed_preempt(void)
-{
-	return rcu_preempt_state.completed;
-}
-EXPORT_SYMBOL_GPL(rcu_batches_completed_preempt);
-
-/*
- * Return the number of RCU batches processed thus far for debug & stats.
- */
-unsigned long rcu_batches_completed(void)
-{
-	return rcu_batches_completed_preempt();
-}
-EXPORT_SYMBOL_GPL(rcu_batches_completed);
-
-/*
  * Record a preemptible-RCU quiescent state for the specified CPU.  Note
  * that this just means that the task currently running on the CPU is
  * not in a quiescent state.  There might be any number of tasks blocked
@@ -933,15 +914,6 @@ static void __init rcu_bootup_announce(void)
 }
 
 /*
- * Return the number of RCU batches processed thus far for debug & stats.
- */
-unsigned long rcu_batches_completed(void)
-{
-	return rcu_batches_completed_sched();
-}
-EXPORT_SYMBOL_GPL(rcu_batches_completed);
-
-/*
  * Because preemptible RCU does not exist, we never have to check for
  * CPUs being in quiescent states.
  */
-- 
1.8.1.5

