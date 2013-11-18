Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3KRWDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:03:08 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58874 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3KRWDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:03:04 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] rcu: Optimize rcu_is_nocb_cpu() for RCU_NOCB_CPU_ALL
Date: Mon, 18 Nov 2013 14:02:49 -0800
Message-Id: <1384812171-23935-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20131118220220.GA23353@linux.vnet.ibm.com>
References: <20131118220220.GA23353@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111822-6688-0000-0000-000003A43892
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

If CONFIG_RCU_NOCB_CPU_ALL=y, then rcu_is_nocb_cpu() will always
return true, however, the current version nevertheless checks
rcu_nocb_mask.  This commit therefore creates a static inline
implementation of rcu_is_nocb_cpu() that unconditionally returns
true when CONFIG_RCU_NOCB_CPU_ALL=y.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 4 ++++
 kernel/rcu/tree_plugin.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 380910aa4e47..277d3697f2f3 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1028,7 +1028,11 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
 
 #ifdef CONFIG_RCU_NOCB_CPU
+#ifdef CONFIG_RCU_NOCB_CPU_ALL
+static inline bool rcu_is_nocb_cpu(int cpu) { return true; }
+#else /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
 bool rcu_is_nocb_cpu(int cpu);
+#endif /* #else #ifdef CONFIG_RCU_NOCB_CPU_ALL */
 #else
 static inline bool rcu_is_nocb_cpu(int cpu) { return false; }
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 1aa33a59fadc..5e7305b40a27 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2089,6 +2089,7 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
 	init_waitqueue_head(&rnp->nocb_gp_wq[1]);
 }
 
+#ifndef CONFIG_RCU_NOCB_CPU_ALL
 /* Is the specified CPU a no-CPUs CPU? */
 bool rcu_is_nocb_cpu(int cpu)
 {
@@ -2096,6 +2097,7 @@ bool rcu_is_nocb_cpu(int cpu)
 		return cpumask_test_cpu(cpu, rcu_nocb_mask);
 	return false;
 }
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 
 /*
  * Enqueue the specified string of rcu_head structures onto the specified
-- 
1.8.1.5

