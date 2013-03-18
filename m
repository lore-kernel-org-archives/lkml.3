Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3CRUze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:55:34 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44371 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3CRUzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:55:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] rcu: Documentation update
Date: Mon, 18 Mar 2013 13:55:08 -0700
Message-Id: <1363640108-15508-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363640108-15508-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1363640108-15508-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031820-5406-0000-0000-0000067EBB78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit applies a few updates based on a quick review of the RCU
documentations.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/checklist.txt  | 26 ++++++++++++++++----------
 Documentation/RCU/lockdep.txt    |  5 +++++
 Documentation/RCU/rcubarrier.txt | 15 ++++++++++++++-
 3 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 31ef8fe..79e789b8 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -217,9 +217,14 @@ over a rather long period of time, but improvements are always welcome!
 	whether the increased speed is worth it.
 
 8.	Although synchronize_rcu() is slower than is call_rcu(), it
-	usually results in simpler code.  So, unless update performance
-	is critically important or the updaters cannot block,
-	synchronize_rcu() should be used in preference to call_rcu().
+	usually results in simpler code.  So, unless update performance is
+	critically important, the updaters cannot block, or the latency of
+	synchronize_rcu() is visible from userspace, synchronize_rcu()
+	should be used in preference to call_rcu().  Furthermore,
+	kfree_rcu() usually results in even simpler code than does
+	synchronize_rcu() without synchronize_rcu()'s multi-millisecond
+	latency.  So please take advantage of kfree_rcu()'s "fire and
+	forget" memory-freeing capabilities where it applies.
 
 	An especially important property of the synchronize_rcu()
 	primitive is that it automatically self-limits: if grace periods
@@ -268,7 +273,8 @@ over a rather long period of time, but improvements are always welcome!
 	e.	Periodically invoke synchronize_rcu(), permitting a limited
 		number of updates per grace period.
 
-	The same cautions apply to call_rcu_bh() and call_rcu_sched().
+	The same cautions apply to call_rcu_bh(), call_rcu_sched(),
+	call_srcu(), and kfree_rcu().
 
 9.	All RCU list-traversal primitives, which include
 	rcu_dereference(), list_for_each_entry_rcu(), and
@@ -296,9 +302,9 @@ over a rather long period of time, but improvements are always welcome!
 	all currently executing rcu_read_lock()-protected RCU read-side
 	critical sections complete.  It does -not- necessarily guarantee
 	that all currently running interrupts, NMIs, preempt_disable()
-	code, or idle loops will complete.  Therefore, if you do not have
-	rcu_read_lock()-protected read-side critical sections, do -not-
-	use synchronize_rcu().
+	code, or idle loops will complete.  Therefore, if your
+	read-side critical sections are protected by something other
+	than rcu_read_lock(), do -not- use synchronize_rcu().
 
 	Similarly, disabling preemption is not an acceptable substitute
 	for rcu_read_lock().  Code that attempts to use preemption
@@ -401,9 +407,9 @@ over a rather long period of time, but improvements are always welcome!
 	read-side critical sections.  It is the responsibility of the
 	RCU update-side primitives to deal with this.
 
-17.	Use CONFIG_PROVE_RCU, CONFIG_DEBUG_OBJECTS_RCU_HEAD, and
-	the __rcu sparse checks to validate your RCU code.  These
-	can help find problems as follows:
+17.	Use CONFIG_PROVE_RCU, CONFIG_DEBUG_OBJECTS_RCU_HEAD, and the
+	__rcu sparse checks (enabled by CONFIG_SPARSE_RCU_POINTER) to
+	validate your RCU code.  These can help find problems as follows:
 
 	CONFIG_PROVE_RCU: check that accesses to RCU-protected data
 		structures are carried out under the proper RCU
diff --git a/Documentation/RCU/lockdep.txt b/Documentation/RCU/lockdep.txt
index a102d4b..cd83d23 100644
--- a/Documentation/RCU/lockdep.txt
+++ b/Documentation/RCU/lockdep.txt
@@ -64,6 +64,11 @@ checking of rcu_dereference() primitives:
 		but retain the compiler constraints that prevent duplicating
 		or coalescsing.  This is useful when when testing the
 		value of the pointer itself, for example, against NULL.
+	rcu_access_index(idx):
+		Return the value of the index and omit all barriers, but
+		retain the compiler constraints that prevent duplicating
+		or coalescsing.  This is useful when when testing the
+		value of the index itself, for example, against -1.
 
 The rcu_dereference_check() check expression can be any boolean
 expression, but would normally include a lockdep expression.  However,
diff --git a/Documentation/RCU/rcubarrier.txt b/Documentation/RCU/rcubarrier.txt
index 38428c1..2e319d1 100644
--- a/Documentation/RCU/rcubarrier.txt
+++ b/Documentation/RCU/rcubarrier.txt
@@ -79,7 +79,20 @@ complete. Pseudo-code using rcu_barrier() is as follows:
    2. Execute rcu_barrier().
    3. Allow the module to be unloaded.
 
-The rcutorture module makes use of rcu_barrier in its exit function
+There are also rcu_barrier_bh(), rcu_barrier_sched(), and srcu_barrier()
+functions for the other flavors of RCU, and you of course must match
+the flavor of rcu_barrier() with that of call_rcu().  If your module
+uses multiple flavors of call_rcu(), then it must also use multiple
+flavors of rcu_barrier() when unloading that module.  For example, if
+it uses call_rcu_bh(), call_srcu() on srcu_struct_1, and call_srcu() on
+srcu_struct_2(), then the following three lines of code will be required
+when unloading:
+
+ 1 rcu_barrier_bh();
+ 2 srcu_barrier(&srcu_struct_1);
+ 3 srcu_barrier(&srcu_struct_2);
+
+The rcutorture module makes use of rcu_barrier() in its exit function
 as follows:
 
  1 static void
-- 
1.8.1.5

