Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab3LPKl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:41:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3LPKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:40:47 -0500
Date: Mon, 16 Dec 2013 02:39:54 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-18c03c61444a211237f3d4782353cb38dba795df@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, josh@joshtriplett.org,
        linux-arch@vger.kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
        linux-arch@vger.kernel.org
In-Reply-To: <1386799151-2219-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1386799151-2219-3-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] Documentation/memory-barriers.txt:
  Prohibit speculative writes
Git-Commit-ID: 18c03c61444a211237f3d4782353cb38dba795df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 02:40:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18c03c61444a211237f3d4782353cb38dba795df
Gitweb:     http://git.kernel.org/tip/18c03c61444a211237f3d4782353cb38dba795df
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 11 Dec 2013 13:59:06 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 16 Dec 2013 11:36:11 +0100

Documentation/memory-barriers.txt: Prohibit speculative writes

No SMP architecture currently supporting Linux allows
speculative writes, so this commit updates
Documentation/memory-barriers.txt to prohibit them in Linux core
code.  It also records restrictions on their use.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <linux-arch@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1386799151-2219-3-git-send-email-paulmck@linux.vnet.ibm.com
[ Paul modified the original patch from Peter. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/memory-barriers.txt | 183 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 175 insertions(+), 8 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 2d22da0..deafa36 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -571,11 +571,10 @@ dependency barrier to make it work correctly.  Consider the following bit of
 code:
 
 	q = ACCESS_ONCE(a);
-	if (p) {
-		<data dependency barrier>
-		q = ACCESS_ONCE(b);
+	if (q) {
+		<data dependency barrier>  /* BUG: No data dependency!!! */
+		p = ACCESS_ONCE(b);
 	}
-	x = *q;
 
 This will not have the desired effect because there is no actual data
 dependency, but rather a control dependency that the CPU may short-circuit
@@ -584,11 +583,176 @@ the load from b as having happened before the load from a.  In such a
 case what's actually required is:
 
 	q = ACCESS_ONCE(a);
-	if (p) {
+	if (q) {
 		<read barrier>
-		q = ACCESS_ONCE(b);
+		p = ACCESS_ONCE(b);
 	}
-	x = *q;
+
+However, stores are not speculated.  This means that ordering -is- provided
+in the following example:
+
+	q = ACCESS_ONCE(a);
+	if (ACCESS_ONCE(q)) {
+		ACCESS_ONCE(b) = p;
+	}
+
+Please note that ACCESS_ONCE() is not optional!  Without the ACCESS_ONCE(),
+the compiler is within its rights to transform this example:
+
+	q = a;
+	if (q) {
+		b = p;  /* BUG: Compiler can reorder!!! */
+		do_something();
+	} else {
+		b = p;  /* BUG: Compiler can reorder!!! */
+		do_something_else();
+	}
+
+into this, which of course defeats the ordering:
+
+	b = p;
+	q = a;
+	if (q)
+		do_something();
+	else
+		do_something_else();
+
+Worse yet, if the compiler is able to prove (say) that the value of
+variable 'a' is always non-zero, it would be well within its rights
+to optimize the original example by eliminating the "if" statement
+as follows:
+
+	q = a;
+	b = p;  /* BUG: Compiler can reorder!!! */
+	do_something();
+
+The solution is again ACCESS_ONCE(), which preserves the ordering between
+the load from variable 'a' and the store to variable 'b':
+
+	q = ACCESS_ONCE(a);
+	if (q) {
+		ACCESS_ONCE(b) = p;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = p;
+		do_something_else();
+	}
+
+You could also use barrier() to prevent the compiler from moving
+the stores to variable 'b', but barrier() would not prevent the
+compiler from proving to itself that a==1 always, so ACCESS_ONCE()
+is also needed.
+
+It is important to note that control dependencies absolutely require a
+a conditional.  For example, the following "optimized" version of
+the above example breaks ordering:
+
+	q = ACCESS_ONCE(a);
+	ACCESS_ONCE(b) = p;  /* BUG: No ordering vs. load from a!!! */
+	if (q) {
+		/* ACCESS_ONCE(b) = p; -- moved up, BUG!!! */
+		do_something();
+	} else {
+		/* ACCESS_ONCE(b) = p; -- moved up, BUG!!! */
+		do_something_else();
+	}
+
+It is of course legal for the prior load to be part of the conditional,
+for example, as follows:
+
+	if (ACCESS_ONCE(a) > 0) {
+		ACCESS_ONCE(b) = q / 2;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = q / 3;
+		do_something_else();
+	}
+
+This will again ensure that the load from variable 'a' is ordered before the
+stores to variable 'b'.
+
+In addition, you need to be careful what you do with the local variable 'q',
+otherwise the compiler might be able to guess the value and again remove
+the needed conditional.  For example:
+
+	q = ACCESS_ONCE(a);
+	if (q % MAX) {
+		ACCESS_ONCE(b) = p;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = p;
+		do_something_else();
+	}
+
+If MAX is defined to be 1, then the compiler knows that (q % MAX) is
+equal to zero, in which case the compiler is within its rights to
+transform the above code into the following:
+
+	q = ACCESS_ONCE(a);
+	ACCESS_ONCE(b) = p;
+	do_something_else();
+
+This transformation loses the ordering between the load from variable 'a'
+and the store to variable 'b'.  If you are relying on this ordering, you
+should do something like the following:
+
+	q = ACCESS_ONCE(a);
+	BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
+	if (q % MAX) {
+		ACCESS_ONCE(b) = p;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = p;
+		do_something_else();
+	}
+
+Finally, control dependencies do -not- provide transitivity.  This is
+demonstrated by two related examples:
+
+	CPU 0                     CPU 1
+	=====================     =====================
+	r1 = ACCESS_ONCE(x);      r2 = ACCESS_ONCE(y);
+	if (r1 >= 0)              if (r2 >= 0)
+	  ACCESS_ONCE(y) = 1;       ACCESS_ONCE(x) = 1;
+
+	assert(!(r1 == 1 && r2 == 1));
+
+The above two-CPU example will never trigger the assert().  However,
+if control dependencies guaranteed transitivity (which they do not),
+then adding the following two CPUs would guarantee a related assertion:
+
+	CPU 2                     CPU 3
+	=====================     =====================
+	ACCESS_ONCE(x) = 2;       ACCESS_ONCE(y) = 2;
+
+	assert(!(r1 == 2 && r2 == 2 && x == 1 && y == 1)); /* FAILS!!! */
+
+But because control dependencies do -not- provide transitivity, the
+above assertion can fail after the combined four-CPU example completes.
+If you need the four-CPU example to provide ordering, you will need
+smp_mb() between the loads and stores in the CPU 0 and CPU 1 code fragments.
+
+In summary:
+
+  (*) Control dependencies can order prior loads against later stores.
+      However, they do -not- guarantee any other sort of ordering:
+      Not prior loads against later loads, nor prior stores against
+      later anything.  If you need these other forms of ordering,
+      use smb_rmb(), smp_wmb(), or, in the case of prior stores and
+      later loads, smp_mb().
+
+  (*) Control dependencies require at least one run-time conditional
+      between the prior load and the subsequent store.  If the compiler
+      is able to optimize the conditional away, it will have also
+      optimized away the ordering.  Careful use of ACCESS_ONCE() can
+      help to preserve the needed conditional.
+
+  (*) Control dependencies require that the compiler avoid reordering the
+      dependency into nonexistence.  Careful use of ACCESS_ONCE() or
+      barrier() can help to preserve your control dependency.
+
+  (*) Control dependencies do -not- provide transitivity.  If you
+      need transitivity, use smp_mb().
 
 
 SMP BARRIER PAIRING
@@ -1083,7 +1247,10 @@ compiler from moving the memory accesses either side of it to the other side:
 
 	barrier();
 
-This is a general barrier - lesser varieties of compiler barrier do not exist.
+This is a general barrier -- there are no read-read or write-write variants
+of barrier().  Howevever, ACCESS_ONCE() can be thought of as a weak form
+for barrier() that affects only the specific accesses flagged by the
+ACCESS_ONCE().
 
 The compiler barrier has no direct effect on the CPU, which may then reorder
 things however it wishes.
