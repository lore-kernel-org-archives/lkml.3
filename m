Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaH1S3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:29:11 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34225 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaH1S0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:26:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/15] rcu: Break more call_rcu() deadlock involving scheduler and perf
Date: Thu, 28 Aug 2014 11:26:30 -0700
Message-Id: <1409250394-25159-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828182614.GA23877@linux.vnet.ibm.com>
 <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-7164-0000-0000-0000042BFEE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Commit 96d3fd0d315a9 (rcu: Break call_rcu() deadlock involving scheduler
and perf) covered the case where __call_rcu_nocb_enqueue() needs to wake
the rcuo kthread due to the queue being initially empty, but did not
do anything for the case where the queue was overflowing.  This commit
therefore also defers wakeup for the overflow case.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h |  3 +++
 kernel/rcu/tree.h          |  9 +++++++--
 kernel/rcu/tree_plugin.h   | 26 ++++++++++++++++++--------
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index aca382266411..9b56f37148cf 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -180,9 +180,12 @@ TRACE_EVENT(rcu_grace_period_init,
  * argument is a string as follows:
  *
  *	"WakeEmpty": Wake rcuo kthread, first CB to empty list.
+ *	"WakeEmptyIsDeferred": Wake rcuo kthread later, first CB to empty list.
  *	"WakeOvf": Wake rcuo kthread, CB list is huge.
+ *	"WakeOvfIsDeferred": Wake rcuo kthread later, CB list is huge.
  *	"WakeNot": Don't wake rcuo kthread.
  *	"WakeNotPoll": Don't wake rcuo kthread because it is polling.
+ *	"DeferredWake": Carried out the "IsDeferred" wakeup.
  *	"Poll": Start of new polling cycle for rcu_nocb_poll.
  *	"Sleep": Sleep waiting for CBs for !rcu_nocb_poll.
  *	"WokeEmpty": rcuo kthread woke to find empty list.
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 71e64c718f75..0abc1a5c63f9 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -350,7 +350,7 @@ struct rcu_data {
 	int nocb_p_count_lazy;		/*  (approximate). */
 	wait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
 	struct task_struct *nocb_kthread;
-	bool nocb_defer_wakeup;		/* Defer wakeup of nocb_kthread. */
+	int nocb_defer_wakeup;		/* Defer wakeup of nocb_kthread. */
 
 	/* The following fields are used by the leader, hence own cacheline. */
 	struct rcu_head *nocb_gp_head ____cacheline_internodealigned_in_smp;
@@ -383,6 +383,11 @@ struct rcu_data {
 #define RCU_FORCE_QS		3	/* Need to force quiescent state. */
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
 
+/* Values for nocb_defer_wakeup field in struct rcu_data. */
+#define RCU_NOGP_WAKE_NOT	0
+#define RCU_NOGP_WAKE		1
+#define RCU_NOGP_WAKE_FORCE	2
+
 #define RCU_JIFFIES_TILL_FORCE_QS (1 + (HZ > 250) + (HZ > 500))
 					/* For jiffies_till_first_fqs and */
 					/*  and jiffies_till_next_fqs. */
@@ -589,7 +594,7 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 				      struct rcu_data *rdp,
 				      unsigned long flags);
-static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
+static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
 static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index b6acb9340192..a1af86099a67 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2121,16 +2121,23 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 					    TPS("WakeEmpty"));
 		} else {
-			rdp->nocb_defer_wakeup = true;
+			rdp->nocb_defer_wakeup = RCU_NOGP_WAKE;
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 					    TPS("WakeEmptyIsDeferred"));
 		}
 		rdp->qlen_last_fqs_check = 0;
 	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
 		/* ... or if many callbacks queued. */
-		wake_nocb_leader(rdp, true);
+		if (!irqs_disabled_flags(flags)) {
+			wake_nocb_leader(rdp, true);
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    TPS("WakeOvf"));
+		} else {
+			rdp->nocb_defer_wakeup = RCU_NOGP_WAKE_FORCE;
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    TPS("WakeOvfIsDeferred"));
+		}
 		rdp->qlen_last_fqs_check = LONG_MAX / 2;
-		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeOvf"));
 	} else {
 		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeNot"));
 	}
@@ -2438,7 +2445,7 @@ static int rcu_nocb_kthread(void *arg)
 }
 
 /* Is a deferred wakeup of rcu_nocb_kthread() required? */
-static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
+static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
 {
 	return ACCESS_ONCE(rdp->nocb_defer_wakeup);
 }
@@ -2446,11 +2453,14 @@ static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
 /* Do a deferred wakeup of rcu_nocb_kthread(). */
 static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
+	int ndw;
+
 	if (!rcu_nocb_need_deferred_wakeup(rdp))
 		return;
-	ACCESS_ONCE(rdp->nocb_defer_wakeup) = false;
-	wake_nocb_leader(rdp, false);
-	trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("DeferredWakeEmpty"));
+	ndw = ACCESS_ONCE(rdp->nocb_defer_wakeup);
+	ACCESS_ONCE(rdp->nocb_defer_wakeup) = RCU_NOGP_WAKE_NOT;
+	wake_nocb_leader(rdp, ndw == RCU_NOGP_WAKE_FORCE);
+	trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("DeferredWake"));
 }
 
 /* Initialize per-rcu_data variables for no-CBs CPUs. */
@@ -2557,7 +2567,7 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 {
 }
 
-static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
+static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
 {
 	return false;
 }
-- 
1.8.1.5

