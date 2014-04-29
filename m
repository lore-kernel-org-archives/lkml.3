Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbaD2Ad7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:33:59 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37399 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004AbaD2AZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 27/45] rcutorture: Export RCU grace-period kthread wait state to rcutorture
Date: Mon, 28 Apr 2014 17:25:15 -0700
Message-Id: <1398731133-18925-27-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-7164-0000-0000-0000015FD2DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit allows rcutorture to print additional state for the
RCU grace-period kthreads in cases where RCU seems reluctant to
start a new grace period.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutiny.h |  4 ++++
 include/linux/rcutree.h |  1 +
 kernel/rcu/rcutorture.c |  1 +
 kernel/rcu/tree.c       | 17 +++++++++++++++++
 kernel/rcu/tree.h       |  8 +++++++-
 5 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 425c659d54e5..d40a6a451330 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -119,6 +119,10 @@ static inline void rcu_sched_force_quiescent_state(void)
 {
 }
 
+static inline void show_rcu_gp_kthreads(void)
+{
+}
+
 static inline void rcu_cpu_stall_reset(void)
 {
 }
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index a59ca05fd4e3..3e2f5d432743 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -84,6 +84,7 @@ extern unsigned long rcutorture_vernum;
 long rcu_batches_completed(void);
 long rcu_batches_completed_bh(void);
 long rcu_batches_completed_sched(void);
+void show_rcu_gp_kthreads(void);
 
 void rcu_force_quiescent_state(void);
 void rcu_bh_force_quiescent_state(void);
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 50c26a7b6d97..15af04177e7e 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1033,6 +1033,7 @@ rcu_torture_printk(char *page)
 				"??? Writer stall state %d g%lu c%lu f%#x\n",
 				rcu_torture_writer_state,
 				gpnum, completed, flags);
+		show_rcu_gp_kthreads();
 		rcutorture_trace_dump();
 	}
 	rtcv_snap = rcu_torture_current_version;
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 032106df7391..3107bd935b2b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -280,6 +280,21 @@ void rcu_bh_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
 
 /*
+ * Show the state of the grace-period kthreads.
+ */
+void show_rcu_gp_kthreads(void)
+{
+	struct rcu_state *rsp;
+
+	for_each_rcu_flavor(rsp) {
+		pr_info("%s: wait state: %d ->state: %#lx\n",
+			rsp->name, rsp->gp_state, rsp->gp_kthread->state);
+		/* sched_show_task(rsp->gp_kthread); */
+	}
+}
+EXPORT_SYMBOL_GPL(show_rcu_gp_kthreads);
+
+/*
  * Record the number of times rcutorture tests have been initiated and
  * terminated.  This information allows the debugfs tracing stats to be
  * correlated to the rcutorture messages, even when the rcutorture module
@@ -1611,6 +1626,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			trace_rcu_grace_period(rsp->name,
 					       ACCESS_ONCE(rsp->gpnum),
 					       TPS("reqwait"));
+			rsp->gp_state = RCU_GP_WAIT_GPS;
 			wait_event_interruptible(rsp->gp_wq,
 						 ACCESS_ONCE(rsp->gp_flags) &
 						 RCU_GP_FLAG_INIT);
@@ -1638,6 +1654,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			trace_rcu_grace_period(rsp->name,
 					       ACCESS_ONCE(rsp->gpnum),
 					       TPS("fqswait"));
+			rsp->gp_state = RCU_GP_WAIT_FQS;
 			ret = wait_event_interruptible_timeout(rsp->gp_wq,
 					((gf = ACCESS_ONCE(rsp->gp_flags)) &
 					 RCU_GP_FLAG_FQS) ||
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 75dc3c39a02a..c2fd1e722879 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -406,7 +406,8 @@ struct rcu_state {
 	unsigned long completed;		/* # of last completed gp. */
 	struct task_struct *gp_kthread;		/* Task for grace periods. */
 	wait_queue_head_t gp_wq;		/* Where GP task waits. */
-	int gp_flags;				/* Commands for GP task. */
+	short gp_flags;				/* Commands for GP task. */
+	short gp_state;				/* GP kthread sleep state. */
 
 	/* End of fields guarded by root rcu_node's lock. */
 
@@ -469,6 +470,11 @@ struct rcu_state {
 #define RCU_GP_FLAG_INIT 0x1	/* Need grace-period initialization. */
 #define RCU_GP_FLAG_FQS  0x2	/* Need grace-period quiescent-state forcing. */
 
+/* Values for rcu_state structure's gp_flags field. */
+#define RCU_GP_WAIT_INIT 0	/* Initial state. */
+#define RCU_GP_WAIT_GPS  1	/* Wait for grace-period start. */
+#define RCU_GP_WAIT_FQS  2	/* Wait for force-quiescent-state time. */
+
 extern struct list_head rcu_struct_flavors;
 
 /* Sequence through rcu_state structures for each RCU flavor. */
-- 
1.8.1.5

