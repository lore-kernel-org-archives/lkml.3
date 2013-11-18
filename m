Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3KRWDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:03:04 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:38637 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3KRWDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:03:00 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] Optimize RCU_FAST_NO_HZ for RCU_NOCB_CPU_ALL
Date: Mon, 18 Nov 2013 14:02:51 -0800
Message-Id: <1384812171-23935-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384812171-23935-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131118220220.GA23353@linux.vnet.ibm.com>
 <1384812171-23935-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111822-1344-0000-0000-0000035A7FF9
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
index 57d98aa2bd21..d87493bf66e3 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1647,7 +1647,7 @@ extern int tick_nohz_enabled;
  * only if it has been awhile since the last time we did so.  Afterwards,
  * if there are any callbacks ready for immediate invocation, return true.
  */
-static bool rcu_try_advance_all_cbs(void)
+static bool __maybe_unused rcu_try_advance_all_cbs(void)
 {
 	bool cbs_ready = false;
 	struct rcu_data *rdp;
@@ -1732,6 +1732,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
  */
 static void rcu_prepare_for_idle(int cpu)
 {
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 	struct rcu_data *rdp;
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
 	struct rcu_node *rnp;
@@ -1782,6 +1783,7 @@ static void rcu_prepare_for_idle(int cpu)
 		rcu_accelerate_cbs(rsp, rnp, rdp);
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 }
 
 /*
@@ -1791,11 +1793,12 @@ static void rcu_prepare_for_idle(int cpu)
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

