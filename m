Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaHDTXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:23:22 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34420 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaHDTVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:21:04 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v4 tip/core/rcu 11/11] rcu: Defer rcu_tasks_kthread() creation till first call_rcu_tasks()
Date: Mon,  4 Aug 2014 12:20:54 -0700
Message-Id: <1407180054-19805-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407180054-19805-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140804192017.GA18337@linux.vnet.ibm.com>
 <1407180054-19805-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080419-1542-0000-0000-000003C08E2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

It is expected that many sites will have CONFIG_TASKS_RCU=y, but
will never actually invoke call_rcu_tasks().  For such sites, creating
rcu_tasks_kthread() at boot is wasteful.  This commit therefore defers
creation of this kthread until the time of the first call_rcu_tasks().

This of course means that the first call_rcu_tasks() must be invoked
from process context after the scheduler is fully operational.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/update.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 1ac99efc17aa..ad2a8df43757 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -378,7 +378,12 @@ DEFINE_SRCU(tasks_rcu_exit_srcu);
 static int rcu_task_stall_timeout __read_mostly = HZ * 60 * 3;
 module_param(rcu_task_stall_timeout, int, 0644);
 
-/* Post an RCU-tasks callback. */
+static void rcu_spawn_tasks_kthread(void);
+
+/*
+ * Post an RCU-tasks callback.  First call must be from process context
+ * after the scheduler if fully operational.
+ */
 void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
 {
 	unsigned long flags;
@@ -391,8 +396,10 @@ void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
 	*rcu_tasks_cbs_tail = rhp;
 	rcu_tasks_cbs_tail = &rhp->next;
 	raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
-	if (needwake)
+	if (needwake) {
+		rcu_spawn_tasks_kthread();
 		wake_up(&rcu_tasks_cbs_wq);
+	}
 }
 EXPORT_SYMBOL_GPL(call_rcu_tasks);
 
@@ -619,15 +626,27 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 	}
 }
 
-/* Spawn rcu_tasks_kthread() at boot time. */
-static int __init rcu_spawn_tasks_kthread(void)
+/* Spawn rcu_tasks_kthread() at first call to call_rcu_tasks(). */
+static void rcu_spawn_tasks_kthread(void)
 {
-	struct task_struct __maybe_unused *t;
+	static DEFINE_MUTEX(rcu_tasks_kthread_mutex);
+	static struct task_struct *rcu_tasks_kthread_ptr;
+	struct task_struct *t;
 
+	if (ACCESS_ONCE(rcu_tasks_kthread_ptr)) {
+		smp_mb(); /* Ensure caller sees full kthread. */
+		return;
+	}
+	mutex_lock(&rcu_tasks_kthread_mutex);
+	if (rcu_tasks_kthread_ptr) {
+		mutex_unlock(&rcu_tasks_kthread_mutex);
+		return;
+	}
 	t = kthread_run(rcu_tasks_kthread, NULL, "rcu_tasks_kthread");
 	BUG_ON(IS_ERR(t));
-	return 0;
+	smp_mb(); /* Ensure others see full kthread. */
+	ACCESS_ONCE(rcu_tasks_kthread_ptr) = t;
+	mutex_unlock(&rcu_tasks_kthread_mutex);
 }
-early_initcall(rcu_spawn_tasks_kthread);
 
 #endif /* #ifdef CONFIG_TASKS_RCU */
-- 
1.8.1.5

