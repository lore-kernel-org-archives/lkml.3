Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbaD2ABW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:01:22 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43919 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbaD1X4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:43 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        Andreea-Cristina Bernat <bernat.ada@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/19] rcu: Consolidate kfree_call_rcu() to use rcu_state pointer
Date: Mon, 28 Apr 2014 16:56:25 -0700
Message-Id: <1398729392-15087-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-1344-0000-0000-00000134CB15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreea-Cristina Bernat <bernat.ada@gmail.com>

kfree_call_rcu is defined two times. When defined under CONFIG_TREE_PREEMPT_RCU,
it uses rcu_preempt_state. Otherwise, it uses rcu_sched_state.
This patch uses the rcu_state_pointer to combine the two definitions into one.
The resulting function is placed after the closing of the preprocessor
conditional CONFIG_TREE_PREEMPT_RCU.

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        | 14 ++++++++++++++
 kernel/rcu/tree_plugin.h | 30 ------------------------------
 2 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 6724bd98da7d..f3317c18b354 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2598,6 +2598,20 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
 /*
+ * Queue an RCU callback for lazy invocation after a grace period.
+ * This will likely be later named something like "call_rcu_lazy()",
+ * but this change will require some way of tagging the lazy RCU
+ * callbacks in the list of pending callbacks. Until then, this
+ * function may only be called from __kfree_rcu().
+ */
+void kfree_call_rcu(struct rcu_head *head,
+		    void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, rcu_state, -1, 1);
+}
+EXPORT_SYMBOL_GPL(kfree_call_rcu);
+
+/*
  * Because a context switch is a grace period for RCU-sched and RCU-bh,
  * any blocking grace-period wait automatically implies a grace period
  * if there is only one CPU online at any point time during execution
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 0cb0816036c5..4918a1243efb 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -688,20 +688,6 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
-/*
- * Queue an RCU callback for lazy invocation after a grace period.
- * This will likely be later named something like "call_rcu_lazy()",
- * but this change will require some way of tagging the lazy RCU
- * callbacks in the list of pending callbacks.  Until then, this
- * function may only be called from __kfree_rcu().
- */
-void kfree_call_rcu(struct rcu_head *head,
-		    void (*func)(struct rcu_head *rcu))
-{
-	__call_rcu(head, func, &rcu_preempt_state, -1, 1);
-}
-EXPORT_SYMBOL_GPL(kfree_call_rcu);
-
 /**
  * synchronize_rcu - wait until a grace period has elapsed.
  *
@@ -1080,22 +1066,6 @@ static void rcu_preempt_check_callbacks(int cpu)
 }
 
 /*
- * Queue an RCU callback for lazy invocation after a grace period.
- * This will likely be later named something like "call_rcu_lazy()",
- * but this change will require some way of tagging the lazy RCU
- * callbacks in the list of pending callbacks.  Until then, this
- * function may only be called from __kfree_rcu().
- *
- * Because there is no preemptible RCU, we use RCU-sched instead.
- */
-void kfree_call_rcu(struct rcu_head *head,
-		    void (*func)(struct rcu_head *rcu))
-{
-	__call_rcu(head, func, &rcu_sched_state, -1, 1);
-}
-EXPORT_SYMBOL_GPL(kfree_call_rcu);
-
-/*
  * Wait for an rcu-preempt grace period, but make it happen quickly.
  * But because preemptible RCU does not exist, map to rcu-sched.
  */
-- 
1.8.1.5

