Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaHDTVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:21:51 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34434 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaHDTVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:21:06 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v4 tip/core/rcu 03/11] rcu: Add synchronous grace-period waiting for RCU-tasks
Date: Mon,  4 Aug 2014 12:20:46 -0700
Message-Id: <1407180054-19805-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407180054-19805-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140804192017.GA18337@linux.vnet.ibm.com>
 <1407180054-19805-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080419-1542-0000-0000-000003C08E29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

It turns out to be easier to add the synchronous grace-period waiting
functions to RCU-tasks than to work around their absense in rcutorture,
so this commit adds them.  The key point is that the existence of
call_rcu_tasks() means that rcutorture needs an rcu_barrier_tasks().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |  2 ++
 kernel/rcu/update.c      | 55 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ac87f587a1c1..1f073af940a5 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -216,6 +216,8 @@ void synchronize_sched(void);
  * memory ordering guarantees.
  */
 void call_rcu_tasks(struct rcu_head *head, void (*func)(struct rcu_head *head));
+void synchronize_rcu_tasks(void);
+void rcu_barrier_tasks(void);
 
 #ifdef CONFIG_PREEMPT_RCU
 
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index d9295de7b172..6c54c898a6f9 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -384,6 +384,61 @@ void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
 }
 EXPORT_SYMBOL_GPL(call_rcu_tasks);
 
+/**
+ * synchronize_rcu_tasks - wait until an rcu-tasks grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full rcu-tasks
+ * grace period has elapsed, in other words after all currently
+ * executing rcu-tasks read-side critical sections have elapsed.  These
+ * read-side critical sections are delimited by calls to schedule(),
+ * cond_resched_rcu_qs(), idle execution, userspace execution, calls
+ * to synchronize_rcu_tasks(), and (in theory, anyway) cond_resched().
+ *
+ * This is a very specialized primitive, intended only for a few uses in
+ * tracing and other situations requiring manipulation of function
+ * preambles and profiling hooks.  The synchronize_rcu_tasks() function
+ * is not (yet) intended for heavy use from multiple CPUs.
+ *
+ * Note that this guarantee implies further memory-ordering guarantees.
+ * On systems with more than one CPU, when synchronize_rcu_tasks() returns,
+ * each CPU is guaranteed to have executed a full memory barrier since the
+ * end of its last RCU-tasks read-side critical section whose beginning
+ * preceded the call to synchronize_rcu_tasks().  In addition, each CPU
+ * having an RCU-tasks read-side critical section that extends beyond
+ * the return from synchronize_rcu_tasks() is guaranteed to have executed
+ * a full memory barrier after the beginning of synchronize_rcu_tasks()
+ * and before the beginning of that RCU-tasks read-side critical section.
+ * Note that these guarantees include CPUs that are offline, idle, or
+ * executing in user mode, as well as CPUs that are executing in the kernel.
+ *
+ * Furthermore, if CPU A invoked synchronize_rcu_tasks(), which returned
+ * to its caller on CPU B, then both CPU A and CPU B are guaranteed
+ * to have executed a full memory barrier during the execution of
+ * synchronize_rcu_tasks() -- even if CPU A and CPU B are the same CPU
+ * (but again only if the system has more than one CPU).
+ */
+void synchronize_rcu_tasks(void)
+{
+	/* Complain if the scheduler has not started.  */
+	rcu_lockdep_assert(!rcu_scheduler_active,
+			   "synchronize_rcu_tasks called too soon");
+
+	/* Wait for the grace period. */
+	wait_rcu_gp(call_rcu_tasks);
+}
+
+/**
+ * rcu_barrier_tasks - Wait for in-flight call_rcu_tasks() callbacks.
+ *
+ * Although the current implementation is guaranteed to wait, it is not
+ * obligated to, for example, if there are no pending callbacks.
+ */
+void rcu_barrier_tasks(void)
+{
+	/* There is only one callback queue, so this is easy.  ;-) */
+	synchronize_rcu_tasks();
+}
+
 /* See if tasks are still holding out, complain if so. */
 static void check_holdout_task(struct task_struct *t)
 {
-- 
1.8.1.5

