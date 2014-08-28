Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaH1SMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:12:41 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54062 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaH1SMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:12:38 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] memory-barriers: Fix description of 2-legged-if-based control dependencies
Date: Thu, 28 Aug 2014 11:12:30 -0700
Message-Id: <1409249550-23313-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409249550-23313-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828181208.GA22865@linux.vnet.ibm.com>
 <1409249550-23313-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-7164-0000-0000-0000042BCF4C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Sad to say, current compilers really will hoist identical stores from both
branches of an "if" statement to precede the conditional.  This commit
therefore updates the description of control dependencies to reflect this
ugly reality.

Reported-by: Pranith Kumar <bobby.prani@gmail.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/memory-barriers.txt | 103 ++++++++++++++++++--------------------
 1 file changed, 49 insertions(+), 54 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 600b45c6e2ad..22a969cdd476 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -574,30 +574,14 @@ However, stores are not speculated.  This means that ordering -is- provided
 in the following example:
 
 	q = ACCESS_ONCE(a);
-	if (ACCESS_ONCE(q)) {
-		ACCESS_ONCE(b) = p;
-	}
-
-Please note that ACCESS_ONCE() is not optional!  Without the ACCESS_ONCE(),
-the compiler is within its rights to transform this example:
-
-	q = a;
 	if (q) {
-		b = p;  /* BUG: Compiler can reorder!!! */
-		do_something();
-	} else {
-		b = p;  /* BUG: Compiler can reorder!!! */
-		do_something_else();
+		ACCESS_ONCE(b) = p;
 	}
 
-into this, which of course defeats the ordering:
-
-	b = p;
-	q = a;
-	if (q)
-		do_something();
-	else
-		do_something_else();
+Please note that ACCESS_ONCE() is not optional!  Without the
+ACCESS_ONCE(), might combine the load from 'a' with other loads from
+'a', and the store to 'b' with other stores to 'b', with possible highly
+counterintuitive effects on ordering.
 
 Worse yet, if the compiler is able to prove (say) that the value of
 variable 'a' is always non-zero, it would be well within its rights
@@ -605,11 +589,12 @@ to optimize the original example by eliminating the "if" statement
 as follows:
 
 	q = a;
-	b = p;  /* BUG: Compiler can reorder!!! */
-	do_something();
+	b = p;  /* BUG: Compiler and CPU can both reorder!!! */
 
-The solution is again ACCESS_ONCE() and barrier(), which preserves the
-ordering between the load from variable 'a' and the store to variable 'b':
+So don't leave out the ACCESS_ONCE().
+
+It is tempting to try to enforce ordering on identical stores on both
+branches of the "if" statement as follows:
 
 	q = ACCESS_ONCE(a);
 	if (q) {
@@ -622,18 +607,11 @@ ordering between the load from variable 'a' and the store to variable 'b':
 		do_something_else();
 	}
 
-The initial ACCESS_ONCE() is required to prevent the compiler from
-proving the value of 'a', and the pair of barrier() invocations are
-required to prevent the compiler from pulling the two identical stores
-to 'b' out from the legs of the "if" statement.
-
-It is important to note that control dependencies absolutely require a
-a conditional.  For example, the following "optimized" version of
-the above example breaks ordering, which is why the barrier() invocations
-are absolutely required if you have identical stores in both legs of
-the "if" statement:
+Unfortunately, current compilers will transform this as follows at high
+optimization levels:
 
 	q = ACCESS_ONCE(a);
+	barrier();
 	ACCESS_ONCE(b) = p;  /* BUG: No ordering vs. load from a!!! */
 	if (q) {
 		/* ACCESS_ONCE(b) = p; -- moved up, BUG!!! */
@@ -643,21 +621,36 @@ the "if" statement:
 		do_something_else();
 	}
 
-It is of course legal for the prior load to be part of the conditional,
-for example, as follows:
+Now there is no conditional between the load from 'a' and the store to
+'b', which means that the CPU is within its rights to reorder them:
+The conditional is absolutely required, and must be present in the
+assembly code even after all compiler optimizations have been applied.
+Therefore, if you need ordering in this example, you need explicit
+memory barriers, for example, smp_store_release():
 
-	if (ACCESS_ONCE(a) > 0) {
-		barrier();
-		ACCESS_ONCE(b) = q / 2;
+	q = ACCESS_ONCE(a);
+	if (q) {
+		smp_store_release(&b, p);
 		do_something();
 	} else {
-		barrier();
-		ACCESS_ONCE(b) = q / 3;
+		smp_store_release(&b, p);
+		do_something_else();
+	}
+
+In contrast, without explicit memory barriers, two-legged-if control
+ordering is guaranteed only when the stores differ, for example:
+
+	q = ACCESS_ONCE(a);
+	if (q) {
+		ACCESS_ONCE(b) = p;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = r;
 		do_something_else();
 	}
 
-This will again ensure that the load from variable 'a' is ordered before the
-stores to variable 'b'.
+The initial ACCESS_ONCE() is still required to prevent the compiler from
+proving the value of 'a'.
 
 In addition, you need to be careful what you do with the local variable 'q',
 otherwise the compiler might be able to guess the value and again remove
@@ -665,12 +658,10 @@ the needed conditional.  For example:
 
 	q = ACCESS_ONCE(a);
 	if (q % MAX) {
-		barrier();
 		ACCESS_ONCE(b) = p;
 		do_something();
 	} else {
-		barrier();
-		ACCESS_ONCE(b) = p;
+		ACCESS_ONCE(b) = r;
 		do_something_else();
 	}
 
@@ -679,15 +670,15 @@ equal to zero, in which case the compiler is within its rights to
 transform the above code into the following:
 
 	q = ACCESS_ONCE(a);
-	barrier();
 	ACCESS_ONCE(b) = p;
 	do_something_else();
 
-This transformation fails to require that the CPU respect the ordering
-between the load from variable 'a' and the store to variable 'b'.
-Yes, the barrier() is still there, but it affects only the compiler,
-not the CPU.  Therefore, if you are relying on this ordering, you should
-do something like the following:
+Given this transformation, the CPU is not required to respect the ordering
+between the load from variable 'a' and the store to variable 'b'.  It is
+tempting to add a barrier(), but this does not help.  The conditional
+is gone, and the barrier won't bring it back.  Therefore, if you are
+relying on this ordering, you should make sure that MAX is greater than
+one, perhaps as follows:
 
 	q = ACCESS_ONCE(a);
 	BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
@@ -695,10 +686,14 @@ do something like the following:
 		ACCESS_ONCE(b) = p;
 		do_something();
 	} else {
-		ACCESS_ONCE(b) = p;
+		ACCESS_ONCE(b) = r;
 		do_something_else();
 	}
 
+Please note once again that the stores to 'b' differ.  If they were
+identical, as noted earlier, the compiler could pull this store outside
+of the 'if' statement.
+
 Finally, control dependencies do -not- provide transitivity.  This is
 demonstrated by two related examples, with the initial values of
 x and y both being zero:
-- 
1.8.1.5

