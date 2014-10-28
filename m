Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaJ1WAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:00:16 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50006 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbaJ1V5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:57:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/10] rcu: Remove "cpu" argument to rcu_preempt_check_callbacks()
Date: Tue, 28 Oct 2014 14:53:32 -0700
Message-Id: <1414533217-24910-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215140.GA23970@linux.vnet.ibm.com>
 <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102821-0033-0000-0000-000002803DA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because rcu_preempt_check_callbacks()'s argument is guaranteed to
always be the current CPU, drop the argument and replace per_cpu()
with __this_cpu_read().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        | 2 +-
 kernel/rcu/tree.h        | 2 +-
 kernel/rcu/tree_plugin.h | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 0670ba3a65d3..1af5e2cdcbeb 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2420,7 +2420,7 @@ void rcu_check_callbacks(int user)
 
 		rcu_bh_qs();
 	}
-	rcu_preempt_check_callbacks(smp_processor_id());
+	rcu_preempt_check_callbacks();
 	if (rcu_pending())
 		invoke_rcu_core();
 	if (user)
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 8e90562010ec..94a26e330c1b 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -561,7 +561,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 				     struct rcu_node *rnp,
 				     struct rcu_data *rdp);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
-static void rcu_preempt_check_callbacks(int cpu);
+static void rcu_preempt_check_callbacks(void);
 void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU)
 static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 09547143628a..7158814b7b4a 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -621,7 +621,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
  *
  * Caller must disable hard irqs.
  */
-static void rcu_preempt_check_callbacks(int cpu)
+static void rcu_preempt_check_callbacks(void)
 {
 	struct task_struct *t = current;
 
@@ -630,8 +630,8 @@ static void rcu_preempt_check_callbacks(int cpu)
 		return;
 	}
 	if (t->rcu_read_lock_nesting > 0 &&
-	    per_cpu(rcu_preempt_data, cpu).qs_pending &&
-	    !per_cpu(rcu_preempt_data, cpu).passed_quiesce)
+	    __this_cpu_read(rcu_preempt_data.qs_pending) &&
+	    !__this_cpu_read(rcu_preempt_data.passed_quiesce))
 		t->rcu_read_unlock_special.b.need_qs = true;
 }
 
@@ -1017,7 +1017,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
  * Because preemptible RCU does not exist, it never has any callbacks
  * to check.
  */
-static void rcu_preempt_check_callbacks(int cpu)
+static void rcu_preempt_check_callbacks(void)
 {
 }
 
-- 
1.8.1.5

