Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaJ1W1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:27:05 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60929 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaJ1W1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:27:02 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/7] rcu: Move RCU_BOOST variable declarations, eliminating #ifdef
Date: Tue, 28 Oct 2014 15:22:57 -0700
Message-Id: <1414534982-29203-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028222224.GA28263@linux.vnet.ibm.com>
 <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0029-0000-0000-000000F5063D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

There are some RCU_BOOST-specific per-CPU variable declarations that
are needlessly defined under #ifdef in kernel/rcu/tree.c.  This commit
therefore moves these declarations into a pre-existing #ifdef in
kernel/rcu/tree_plugin.h.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        | 13 -------------
 kernel/rcu/tree_plugin.h | 17 +++++++++++++++--
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 9815447d22e0..7f73c5edf8cf 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -152,19 +152,6 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
  */
 static int rcu_scheduler_fully_active __read_mostly;
 
-#ifdef CONFIG_RCU_BOOST
-
-/*
- * Control variables for per-CPU and per-rcu_node kthreads.  These
- * handle all flavors of RCU.
- */
-static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
-DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
-DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
-DEFINE_PER_CPU(char, rcu_cpu_has_work);
-
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index c1d7f27bd38f..357891104ea0 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -33,11 +33,24 @@
 #define RCU_KTHREAD_PRIO 1
 
 #ifdef CONFIG_RCU_BOOST
+
 #include "../locking/rtmutex_common.h"
 #define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
-#else
+
+/*
+ * Control variables for per-CPU and per-rcu_node kthreads.  These
+ * handle all flavors of RCU.
+ */
+static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
+DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
+DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
+DEFINE_PER_CPU(char, rcu_cpu_has_work);
+
+#else /* #ifdef CONFIG_RCU_BOOST */
+
 #define RCU_BOOST_PRIO RCU_KTHREAD_PRIO
-#endif
+
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
 
 #ifdef CONFIG_RCU_NOCB_CPU
 static cpumask_var_t rcu_nocb_mask; /* CPUs to have callbacks offloaded. */
-- 
1.8.1.5

