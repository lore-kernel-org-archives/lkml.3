Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaK1JkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:40:05 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:38238 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751819AbaK1JkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:40:01 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44143284"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH 1/2] record rcu_bh quiescent state in RCU_SOFTIRQ
Date: Fri, 28 Nov 2014 17:43:32 +0800
Message-ID: <1417167813-11963-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1417167813-11963-1-git-send-email-laijs@cn.fujitsu.com>
References: <1417167813-11963-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For rcu_bh in UP, rcu_process_callbacks() == a bh == QS == GP
so we can pass rcu_bh-QS and advance GP(and callbacks) in
rcu_process_callbacks().

After doing so, rcu_bh_qs() is useless since its work is handled
by rcu_process_callbacks(). So we make it as empty-function and
raise RCU_SOFTIRQ directly in call_rcu_bh().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/rcu/tiny.c |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index 805b6d5..f8e19ac 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -72,7 +72,7 @@ static void rcu_idle_enter_common(long long newval)
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
-	rcu_sched_qs(); /* implies rcu_bh_inc() */
+	rcu_sched_qs();
 	barrier();
 	rcu_dynticks_nesting = newval;
 }
@@ -186,49 +186,43 @@ EXPORT_SYMBOL(__rcu_is_watching);
 #endif /* defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
 
 /*
- * Helper function for rcu_sched_qs() and rcu_bh_qs().
+ * Helper function for rcu_sched_ctrlblk and rcu_bh_ctrlblk.
  * Also irqs are disabled to avoid confusion due to interrupt handlers
  * invoking call_rcu().
  */
 static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	RCU_TRACE(reset_cpu_stall_ticks(rcp));
 	if (rcp->rcucblist != NULL &&
 	    rcp->donetail != rcp->curtail) {
 		rcp->donetail = rcp->curtail;
+		local_irq_restore(flags);
 		return 1;
 	}
+	local_irq_restore(flags);
 
 	return 0;
 }
 
 /*
- * Record an rcu quiescent state.  And an rcu_bh quiescent state while we
- * are at it, given that any rcu quiescent state is also an rcu_bh
- * quiescent state.  Use "+" instead of "||" to defeat short circuiting.
+ * Record an rcu quiescent state.
  */
 void rcu_sched_qs(void)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
-	    rcu_qsctr_help(&rcu_bh_ctrlblk))
+	if (rcu_qsctr_help(&rcu_sched_ctrlblk))
 		raise_softirq(RCU_SOFTIRQ);
-	local_irq_restore(flags);
 }
 
 /*
  * Record an rcu_bh quiescent state.
+ * Do nothing, since this quiescent state is temporary useless until
+ * RCU_SOFTIRQ, and RCU_SOFTIRQ will really record the quiescent state.
  */
 void rcu_bh_qs(void)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
-		raise_softirq(RCU_SOFTIRQ);
-	local_irq_restore(flags);
 }
 
 /*
@@ -240,12 +234,10 @@ void rcu_bh_qs(void)
 void rcu_check_callbacks(int user)
 {
 	RCU_TRACE(check_cpu_stalls());
-	if (user)
+	if (user) {
 		rcu_sched_qs();
-	else if (!in_softirq())
-		rcu_bh_qs();
-	if (user)
 		rcu_note_voluntary_context_switch(current);
+	}
 }
 
 /*
@@ -303,6 +295,9 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	__rcu_process_callbacks(&rcu_sched_ctrlblk);
+
+	/* Here is quiescent state for rcu_bh */
+	rcu_qsctr_help(&rcu_bh_ctrlblk);
 	__rcu_process_callbacks(&rcu_bh_ctrlblk);
 }
 
@@ -367,6 +362,7 @@ EXPORT_SYMBOL_GPL(call_rcu_sched);
 void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
 	__call_rcu(head, func, &rcu_bh_ctrlblk);
+	raise_softirq(RCU_SOFTIRQ);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
-- 
1.7.4.4

