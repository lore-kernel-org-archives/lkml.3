Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbbAGRzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:55:07 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:35339 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbbAGRw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:52:58 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/10] rcu: Run grace-period kthreads at real-time priority
Date: Wed,  7 Jan 2015 09:52:44 -0800
Message-Id: <1420653168-6434-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107175225.GA4237@linux.vnet.ibm.com>
 <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0025-0000-0000-00000791FE26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This is a experimental commit that attempts to better handle high-load
situations.

Not-yet-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig             |  1 -
 kernel/rcu/tree.c        | 10 +++++++++-
 kernel/rcu/tree_plugin.h |  4 ----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 9afb971497f4..8787131d0f5c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -669,7 +669,6 @@ config RCU_BOOST
 config RCU_KTHREAD_PRIO
 	int "Real-time priority to use for RCU worker threads"
 	range 1 99
-	depends on RCU_BOOST
 	default 1
 	help
 	  This option specifies the SCHED_FIFO priority value that will be
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 5987fdc85fc4..7a8d7e0d23f6 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -156,6 +156,10 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
 
+/* rcuc/rcub kthread realtime priority */
+static int kthread_prio = CONFIG_RCU_KTHREAD_PRIO;
+module_param(kthread_prio, int, 0644);
+
 /*
  * Track the rcutorture test sequence number and the update version
  * number within a given test.  The rcutorture_testseq is incremented
@@ -3599,15 +3603,19 @@ static int __init rcu_spawn_gp_kthread(void)
 	unsigned long flags;
 	struct rcu_node *rnp;
 	struct rcu_state *rsp;
+	struct sched_param sp;
 	struct task_struct *t;
 
 	rcu_scheduler_fully_active = 1;
 	for_each_rcu_flavor(rsp) {
-		t = kthread_run(rcu_gp_kthread, rsp, "%s", rsp->name);
+		t = kthread_create(rcu_gp_kthread, rsp, "%s", rsp->name);
 		BUG_ON(IS_ERR(t));
 		rnp = rcu_get_root(rsp);
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rsp->gp_kthread = t;
+		sp.sched_priority = kthread_prio;
+		sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
+		wake_up_process(t);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 	rcu_spawn_nocb_kthreads();
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 81ff8b9a5a39..dcb32638f88b 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -34,10 +34,6 @@
 
 #include "../locking/rtmutex_common.h"
 
-/* rcuc/rcub kthread realtime priority */
-static int kthread_prio = CONFIG_RCU_KTHREAD_PRIO;
-module_param(kthread_prio, int, 0644);
-
 /*
  * Control variables for per-CPU and per-rcu_node kthreads.  These
  * handle all flavors of RCU.
-- 
1.8.1.5

