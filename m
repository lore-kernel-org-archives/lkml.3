Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbaD2Ahx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:37:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48543 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948AbaD2AZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:46 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/45] rcutorture: Add forward-progress checking for writer
Date: Mon, 28 Apr 2014 17:24:49 -0700
Message-Id: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140429002455.GA15461@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-1542-0000-0000-00000169D2FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcutorture output currently does not distinguish between stalls in
the RCU implementation and stalls in the rcu_torture_writer() kthreads.
This commit therefore adds some diagnostics to help distinguish between
these two conditions, at least for the non-SRCU implementations.  (SRCU
does not provide evidence of update-side forward progress by design.)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 19 +++++++++++++++++++
 kernel/rcu/rcutorture.c  | 37 +++++++++++++++++++++++++++++++++++++
 kernel/rcu/tree.c        | 18 ++++++++++++++++++
 3 files changed, 74 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 00a7fd61b3c6..a6c3898e141e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -51,7 +51,17 @@ extern int rcu_expedited; /* for sysctl */
 extern int rcutorture_runnable; /* for sysctl */
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
+enum rcutorture_type {
+	RTORT_BUSTED,
+	RTORT_RCU,
+	RTORT_RCU_BH,
+	RTORT_RCU_SCHED,
+	RTORT_SRCU
+};
+
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+void rcutorture_get_gp_data(enum rcutorture_type test_type, int *flags,
+			    unsigned long *gpnum, unsigned long *completed);
 void rcutorture_record_test_transition(void);
 void rcutorture_record_progress(unsigned long vernum);
 void do_trace_rcu_torture_read(const char *rcutorturename,
@@ -60,6 +70,15 @@ void do_trace_rcu_torture_read(const char *rcutorturename,
 			       unsigned long c_old,
 			       unsigned long c);
 #else
+static inline void rcutorture_get_gp_data(enum rcutorture_type test_type,
+					  int *flags,
+					  unsigned long *gpnum,
+					  unsigned long *completed)
+{
+	*flags = 0;
+	*gpnum = 0;
+	*completed = 0;
+}
 static inline void rcutorture_record_test_transition(void)
 {
 }
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index bd30bc61bc05..1110db210318 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -138,6 +138,15 @@ static long n_barrier_attempts;
 static long n_barrier_successes;
 static struct list_head rcu_torture_removed;
 
+static int rcu_torture_writer_state;
+#define RTWS_FIXED_DELAY	0
+#define RTWS_DELAY		1
+#define RTWS_REPLACE		2
+#define RTWS_DEF_FREE		3
+#define RTWS_EXP_SYNC		4
+#define RTWS_STUTTER		5
+#define RTWS_STOPPING		6
+
 #if defined(MODULE) || defined(CONFIG_RCU_TORTURE_TEST_RUNNABLE)
 #define RCUTORTURE_RUNNABLE_INIT 1
 #else
@@ -214,6 +223,7 @@ rcu_torture_free(struct rcu_torture *p)
  */
 
 struct rcu_torture_ops {
+	int ttype;
 	void (*init)(void);
 	int (*readlock)(void);
 	void (*read_delay)(struct torture_random_state *rrsp);
@@ -312,6 +322,7 @@ static void rcu_sync_torture_init(void)
 }
 
 static struct rcu_torture_ops rcu_ops = {
+	.ttype		= RTORT_RCU,
 	.init		= rcu_sync_torture_init,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,
@@ -355,6 +366,7 @@ static void rcu_bh_torture_deferred_free(struct rcu_torture *p)
 }
 
 static struct rcu_torture_ops rcu_bh_ops = {
+	.ttype		= RTORT_RCU_BH,
 	.init		= rcu_sync_torture_init,
 	.readlock	= rcu_bh_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
@@ -397,6 +409,7 @@ call_rcu_busted(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 
 static struct rcu_torture_ops rcu_busted_ops = {
+	.ttype		= RTORT_BUSTED,
 	.init		= rcu_sync_torture_init,
 	.readlock	= rcu_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
@@ -492,6 +505,7 @@ static void srcu_torture_synchronize_expedited(void)
 }
 
 static struct rcu_torture_ops srcu_ops = {
+	.ttype		= RTORT_SRCU,
 	.init		= rcu_sync_torture_init,
 	.readlock	= srcu_torture_read_lock,
 	.read_delay	= srcu_read_delay,
@@ -527,6 +541,7 @@ static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
 }
 
 static struct rcu_torture_ops sched_ops = {
+	.ttype		= RTORT_RCU_SCHED,
 	.init		= rcu_sync_torture_init,
 	.readlock	= sched_torture_read_lock,
 	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
@@ -699,12 +714,15 @@ rcu_torture_writer(void *arg)
 	set_user_nice(current, MAX_NICE);
 
 	do {
+		rcu_torture_writer_state = RTWS_FIXED_DELAY;
 		schedule_timeout_uninterruptible(1);
 		rp = rcu_torture_alloc();
 		if (rp == NULL)
 			continue;
 		rp->rtort_pipe_count = 0;
+		rcu_torture_writer_state = RTWS_DELAY;
 		udelay(torture_random(&rand) & 0x3ff);
+		rcu_torture_writer_state = RTWS_REPLACE;
 		old_rp = rcu_dereference_check(rcu_torture_current,
 					       current == writer_task);
 		rp->rtort_mbtest = 1;
@@ -721,8 +739,10 @@ rcu_torture_writer(void *arg)
 			else
 				exp = gp_exp;
 			if (!exp) {
+				rcu_torture_writer_state = RTWS_DEF_FREE;
 				cur_ops->deferred_free(old_rp);
 			} else {
+				rcu_torture_writer_state = RTWS_EXP_SYNC;
 				cur_ops->exp_sync();
 				list_add(&old_rp->rtort_free,
 					 &rcu_torture_removed);
@@ -743,8 +763,10 @@ rcu_torture_writer(void *arg)
 			}
 		}
 		rcutorture_record_progress(++rcu_torture_current_version);
+		rcu_torture_writer_state = RTWS_STUTTER;
 		stutter_wait("rcu_torture_writer");
 	} while (!torture_must_stop());
+	rcu_torture_writer_state = RTWS_STOPPING;
 	torture_kthread_stopping("rcu_torture_writer");
 	return 0;
 }
@@ -937,6 +959,7 @@ rcu_torture_printk(char *page)
 	int i;
 	long pipesummary[RCU_TORTURE_PIPE_LEN + 1] = { 0 };
 	long batchsummary[RCU_TORTURE_PIPE_LEN + 1] = { 0 };
+	static unsigned long rtcv_snap = ULONG_MAX;
 
 	for_each_possible_cpu(cpu) {
 		for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
@@ -997,6 +1020,20 @@ rcu_torture_printk(char *page)
 	page += sprintf(page, "\n");
 	if (cur_ops->stats)
 		cur_ops->stats(page);
+	if (rtcv_snap == rcu_torture_current_version &&
+	    rcu_torture_current != NULL) {
+		int __maybe_unused flags;
+		unsigned long __maybe_unused gpnum;
+		unsigned long __maybe_unused completed;
+
+		rcutorture_get_gp_data(cur_ops->ttype,
+				       &flags, &gpnum, &completed);
+		page += sprintf(page,
+				"??? Writer stall state %d g%lu c%lu f%#x\n",
+				rcu_torture_writer_state,
+				gpnum, completed, flags);
+	}
+	rtcv_snap = rcu_torture_current_version;
 }
 
 /*
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 0c47e300210a..032106df7391 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -294,6 +294,24 @@ void rcutorture_record_test_transition(void)
 EXPORT_SYMBOL_GPL(rcutorture_record_test_transition);
 
 /*
+ * Send along grace-period-related data for rcutorture diagnostics.
+ */
+void rcutorture_get_gp_data(enum rcutorture_type test_type, int *flags,
+			    unsigned long *gpnum, unsigned long *completed)
+{
+	if (test_type == RTORT_SRCU || test_type == RTORT_BUSTED) {
+		*flags = 0;
+		*gpnum = 0;
+		*completed = 0;
+		return;
+	}
+	*flags = ACCESS_ONCE(rcu_state->gp_flags);
+	*gpnum = ACCESS_ONCE(rcu_state->gpnum);
+	*completed = ACCESS_ONCE(rcu_state->completed);
+}
+EXPORT_SYMBOL_GPL(rcutorture_get_gp_data);
+
+/*
  * Record the number of writer passes through the current rcutorture test.
  * This is also used to correlate debugfs tracing stats with the rcutorture
  * messages.
-- 
1.8.1.5

