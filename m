Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898AbaD1X6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:58:00 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55921 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbaD1X4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:44 -0400
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
Subject: [PATCH tip/core/rcu 13/19] rcu: Merge rcu_sched_force_quiescent_state() with rcu_force_quiescent_state()
Date: Mon, 28 Apr 2014 16:56:26 -0700
Message-Id: <1398729392-15087-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-7164-0000-0000-0000015FB501
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreea-Cristina Bernat <bernat.ada@gmail.com>

This patch merges the function rcu_force_quiescent_state() with
rcu_sched_force_quiescent_state(), using the rcu_state pointer.  Firstly,
the rcu_sched_force_quiescent_state() function is deleted from the file
kernel/rcu/tree.c. Also, the rcu_force_quiescent_state() function that was
calling force_quiescent_state with the argument rcu_preempt_state pointer
was deleted as well.  The new function that combines the old ones uses
the rcu_state pointer and is located after rcu_batches_completed_bh()
in kernel/rcu/tree.c.

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        |  9 +++++++++
 kernel/rcu/tree_plugin.h | 19 -------------------
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f3317c18b354..dbf43f5c86fa 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -271,6 +271,15 @@ long rcu_batches_completed_bh(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
 
 /*
+ * Force a quiescent state.
+ */
+void rcu_force_quiescent_state(void)
+{
+	force_quiescent_state(rcu_state);
+}
+EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
+
+/*
  * Force a quiescent state for RCU BH.
  */
 void rcu_bh_force_quiescent_state(void)
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 4918a1243efb..1af19e006899 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -149,15 +149,6 @@ long rcu_batches_completed(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
 /*
- * Force a quiescent state for preemptible RCU.
- */
-void rcu_force_quiescent_state(void)
-{
-	force_quiescent_state(&rcu_preempt_state);
-}
-EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
-
-/*
  * Record a preemptible-RCU quiescent state for the specified CPU.  Note
  * that this just means that the task currently running on the CPU is
  * not in a quiescent state.  There might be any number of tasks blocked
@@ -977,16 +968,6 @@ long rcu_batches_completed(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
 /*
- * Force a quiescent state for RCU, which, because there is no preemptible
- * RCU, becomes the same as rcu-sched.
- */
-void rcu_force_quiescent_state(void)
-{
-	rcu_sched_force_quiescent_state();
-}
-EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
-
-/*
  * Because preemptible RCU does not exist, we never have to check for
  * CPUs being in quiescent states.
  */
-- 
1.8.1.5

