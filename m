Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaG1W5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:57:55 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49238 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaG1W42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:56:28 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 5/9] rcutorture: Add torture tests for RCU-tasks
Date: Mon, 28 Jul 2014 15:56:16 -0700
Message-Id: <1406588180-21933-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072822-9332-0000-0000-00000186F320
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds torture tests for RCU-tasks.  It also fixes a bug that
would segfault for an RCU flavor lacking a callback-barrier function.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |  1 +
 kernel/rcu/rcutorture.c  | 40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 17c7e25c38be..ecb2198849e0 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -55,6 +55,7 @@ enum rcutorture_type {
 	RCU_FLAVOR,
 	RCU_BH_FLAVOR,
 	RCU_SCHED_FLAVOR,
+	RCU_TASKS_FLAVOR,
 	SRCU_FLAVOR,
 	INVALID_RCU_FLAVOR
 };
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index febe07062ac5..6d12ab6675bc 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -602,6 +602,42 @@ static struct rcu_torture_ops sched_ops = {
 };
 
 /*
+ * Definitions for RCU-tasks torture testing.
+ */
+
+static int tasks_torture_read_lock(void)
+{
+	return 0;
+}
+
+static void tasks_torture_read_unlock(int idx)
+{
+}
+
+static void rcu_tasks_torture_deferred_free(struct rcu_torture *p)
+{
+	call_rcu_tasks(&p->rtort_rcu, rcu_torture_cb);
+}
+
+static struct rcu_torture_ops tasks_ops = {
+	.ttype		= RCU_TASKS_FLAVOR,
+	.init		= rcu_sync_torture_init,
+	.readlock	= tasks_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= tasks_torture_read_unlock,
+	.completed	= rcu_no_completed,
+	.deferred_free	= rcu_tasks_torture_deferred_free,
+	.sync		= synchronize_rcu_tasks,
+	.exp_sync	= synchronize_rcu_tasks,
+	.call		= call_rcu_tasks,
+	.cb_barrier	= rcu_barrier_tasks,
+	.fqs		= NULL,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "tasks"
+};
+
+/*
  * RCU torture priority-boost testing.  Runs one real-time thread per
  * CPU for moderate bursts, repeatedly registering RCU callbacks and
  * spinning waiting for them to be invoked.  If a given callback takes
@@ -1295,7 +1331,8 @@ static int rcu_torture_barrier_cbs(void *arg)
 		if (atomic_dec_and_test(&barrier_cbs_count))
 			wake_up(&barrier_wq);
 	} while (!torture_must_stop());
-	cur_ops->cb_barrier();
+	if (cur_ops->cb_barrier != NULL)
+		cur_ops->cb_barrier();
 	destroy_rcu_head_on_stack(&rcu);
 	torture_kthread_stopping("rcu_torture_barrier_cbs");
 	return 0;
@@ -1534,6 +1571,7 @@ rcu_torture_init(void)
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] = {
 		&rcu_ops, &rcu_bh_ops, &rcu_busted_ops, &srcu_ops, &sched_ops,
+		&tasks_ops,
 	};
 
 	if (!torture_init_begin(torture_type, verbose, &rcutorture_runnable))
-- 
1.8.1.5

