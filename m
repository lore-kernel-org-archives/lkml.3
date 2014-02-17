Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaBQVky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:40:54 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60215 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbaBQVki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:40:38 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] rcu: Optimize RCU_FAST_NO_HZ for RCU_NOCB_CPU_ALL
Date: Mon, 17 Feb 2014 13:40:27 -0800
Message-Id: <1392673227-7066-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392673227-7066-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217214007.GA6609@linux.vnet.ibm.com>
 <1392673227-7066-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-1542-0000-0000-000006529DB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

If CONFIG_RCU_NOCB_CPU_ALL=y, then no CPU will ever have RCU callbacks
because these callbacks will instead be handled by the rcuo kthreads.
However, the current version of RCU_FAST_NO_HZ nevertheless checks for RCU
callbacks.  This commit therefore creates static inline implementations
of rcu_prepare_for_idle() and rcu_cleanup_after_idle() that are no-ops
when CONFIG_RCU_NOCB_CPU_ALL=y.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 820b06aefbee..41afc3fbfb6c 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1658,7 +1658,7 @@ extern int tick_nohz_active;
  * only if it has been awhile since the last time we did so.  Afterwards,
  * if there are any callbacks ready for immediate invocation, return true.
  */
-static bool rcu_try_advance_all_cbs(void)
+static bool __maybe_unused rcu_try_advance_all_cbs(void)
 {
 	bool cbs_ready = false;
 	struct rcu_data *rdp;
@@ -1743,6 +1743,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
  */
 static void rcu_prepare_for_idle(int cpu)
 {
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 	struct rcu_data *rdp;
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
 	struct rcu_node *rnp;
@@ -1794,6 +1795,7 @@ static void rcu_prepare_for_idle(int cpu)
 		rcu_accelerate_cbs(rsp, rnp, rdp);
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 }
 
 /*
@@ -1803,11 +1805,12 @@ static void rcu_prepare_for_idle(int cpu)
  */
 static void rcu_cleanup_after_idle(int cpu)
 {
-
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 	if (rcu_is_nocb_cpu(cpu))
 		return;
 	if (rcu_try_advance_all_cbs())
 		invoke_rcu_core();
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 }
 
 /*
-- 
1.8.1.5

