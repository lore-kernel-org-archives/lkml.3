Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3LPKkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:40:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44096 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3LPKkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:40:13 -0500
Date: Mon, 16 Dec 2013 02:39:35 -0800
From: "tip-bot for Paul E. McKenney" <tipbot@zytor.com>
Message-ID: <tip-2ecf810121c7eae34473b8fa108112036bc61127@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de, josh@joshtriplett.org, linux-arch@vger.kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        josh@joshtriplett.org, tglx@linutronix.de, linux-arch@vger.kernel.org
In-Reply-To: <1386799151-2219-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1386799151-2219-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] Documentation/memory-barriers.txt:
  Add needed ACCESS_ONCE() calls to memory-barriers.txt
Git-Commit-ID: 2ecf810121c7eae34473b8fa108112036bc61127
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 02:39:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ecf810121c7eae34473b8fa108112036bc61127
Gitweb:     http://git.kernel.org/tip/2ecf810121c7eae34473b8fa108112036bc61127
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 11 Dec 2013 13:59:04 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 16 Dec 2013 11:36:08 +0100

Documentation/memory-barriers.txt: Add needed ACCESS_ONCE() calls to memory-barriers.txt

The Documentation/memory-barriers.txt file was written before
the need for ACCESS_ONCE() was fully appreciated.  It therefore
contains no ACCESS_ONCE() calls, which can be a problem when
people lift examples from it.  This commit therefore adds
ACCESS_ONCE() calls.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <linux-arch@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1386799151-2219-1-git-send-email-paulmck@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/memory-barriers.txt | 206 +++++++++++++++++++++++---------------
 1 file changed, 126 insertions(+), 80 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 020cccd..1d06723 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -194,18 +194,22 @@ There are some minimal guarantees that may be expected of a CPU:
  (*) On any given CPU, dependent memory accesses will be issued in order, with
      respect to itself.  This means that for:
 
-	Q = P; D = *Q;
+	ACCESS_ONCE(Q) = P; smp_read_barrier_depends(); D = ACCESS_ONCE(*Q);
 
      the CPU will issue the following memory operations:
 
 	Q = LOAD P, D = LOAD *Q
 
-     and always in that order.
+     and always in that order.  On most systems, smp_read_barrier_depends()
+     does nothing, but it is required for DEC Alpha.  The ACCESS_ONCE()
+     is required to prevent compiler mischief.  Please note that you
+     should normally use something like rcu_dereference() instead of
+     open-coding smp_read_barrier_depends().
 
  (*) Overlapping loads and stores within a particular CPU will appear to be
      ordered within that CPU.  This means that for:
 
-	a = *X; *X = b;
+	a = ACCESS_ONCE(*X); ACCESS_ONCE(*X) = b;
 
      the CPU will only issue the following sequence of memory operations:
 
@@ -213,7 +217,7 @@ There are some minimal guarantees that may be expected of a CPU:
 
      And for:
 
-	*X = c; d = *X;
+	ACCESS_ONCE(*X) = c; d = ACCESS_ONCE(*X);
 
      the CPU will only issue:
 
@@ -224,6 +228,41 @@ There are some minimal guarantees that may be expected of a CPU:
 
 And there are a number of things that _must_ or _must_not_ be assumed:
 
+ (*) It _must_not_ be assumed that the compiler will do what you want with
+     memory references that are not protected by ACCESS_ONCE().  Without
+     ACCESS_ONCE(), the compiler is within its rights to do all sorts
+     of "creative" transformations:
+
+     (-) Repeat the load, possibly getting a different value on the second
+         and subsequent loads.  This is especially prone to happen when
+	 register pressure is high.
+
+     (-) Merge adjacent loads and stores to the same location.  The most
+         familiar example is the transformation from:
+
+		while (a)
+			do_something();
+
+         to something like:
+
+		if (a)
+			for (;;)
+				do_something();
+
+         Using ACCESS_ONCE() as follows prevents this sort of optimization:
+
+		while (ACCESS_ONCE(a))
+			do_something();
+
+     (-) "Store tearing", where a single store in the source code is split
+         into smaller stores in the object code.  Note that gcc really
+	 will do this on some architectures when storing certain constants.
+	 It can be cheaper to do a series of immediate stores than to
+	 form the constant in a register and then to store that register.
+
+     (-) "Load tearing", which splits loads in a manner analogous to
+     	 store tearing.
+
  (*) It _must_not_ be assumed that independent loads and stores will be issued
      in the order given.  This means that for:
 
@@ -450,14 +489,14 @@ The usage requirements of data dependency barriers are a little subtle, and
 it's not always obvious that they're needed.  To illustrate, consider the
 following sequence of events:
 
-	CPU 1		CPU 2
-	===============	===============
+	CPU 1		      CPU 2
+	===============	      ===============
 	{ A == 1, B == 2, C = 3, P == &A, Q == &C }
 	B = 4;
 	<write barrier>
-	P = &B
-			Q = P;
-			D = *Q;
+	ACCESS_ONCE(P) = &B
+			      Q = ACCESS_ONCE(P);
+			      D = *Q;
 
 There's a clear data dependency here, and it would seem that by the end of the
 sequence, Q must be either &A or &B, and that:
@@ -477,15 +516,15 @@ Alpha).
 To deal with this, a data dependency barrier or better must be inserted
 between the address load and the data load:
 
-	CPU 1		CPU 2
-	===============	===============
+	CPU 1		      CPU 2
+	===============	      ===============
 	{ A == 1, B == 2, C = 3, P == &A, Q == &C }
 	B = 4;
 	<write barrier>
-	P = &B
-			Q = P;
-			<data dependency barrier>
-			D = *Q;
+	ACCESS_ONCE(P) = &B
+			      Q = ACCESS_ONCE(P);
+			      <data dependency barrier>
+			      D = *Q;
 
 This enforces the occurrence of one of the two implications, and prevents the
 third possibility from arising.
@@ -504,21 +543,22 @@ Another example of where data dependency barriers might be required is where a
 number is read from memory and then used to calculate the index for an array
 access:
 
-	CPU 1		CPU 2
-	===============	===============
+	CPU 1		      CPU 2
+	===============	      ===============
 	{ M[0] == 1, M[1] == 2, M[3] = 3, P == 0, Q == 3 }
 	M[1] = 4;
 	<write barrier>
-	P = 1
-			Q = P;
-			<data dependency barrier>
-			D = M[Q];
+	ACCESS_ONCE(P) = 1
+			      Q = ACCESS_ONCE(P);
+			      <data dependency barrier>
+			      D = M[Q];
 
 
-The data dependency barrier is very important to the RCU system, for example.
-See rcu_dereference() in include/linux/rcupdate.h.  This permits the current
-target of an RCU'd pointer to be replaced with a new modified target, without
-the replacement target appearing to be incompletely initialised.
+The data dependency barrier is very important to the RCU system,
+for example.  See rcu_assign_pointer() and rcu_dereference() in
+include/linux/rcupdate.h.  This permits the current target of an RCU'd
+pointer to be replaced with a new modified target, without the replacement
+target appearing to be incompletely initialised.
 
 See also the subsection on "Cache Coherency" for a more thorough example.
 
@@ -530,22 +570,23 @@ A control dependency requires a full read memory barrier, not simply a data
 dependency barrier to make it work correctly.  Consider the following bit of
 code:
 
-	q = &a;
+	q = ACCESS_ONCE(a);
 	if (p) {
 		<data dependency barrier>
-		q = &b;
+		q = ACCESS_ONCE(b);
 	}
 	x = *q;
 
 This will not have the desired effect because there is no actual data
-dependency, but rather a control dependency that the CPU may short-circuit by
-attempting to predict the outcome in advance.  In such a case what's actually
-required is:
+dependency, but rather a control dependency that the CPU may short-circuit
+by attempting to predict the outcome in advance, so that other CPUs see
+the load from b as having happened before the load from a.  In such a
+case what's actually required is:
 
-	q = &a;
+	q = ACCESS_ONCE(a);
 	if (p) {
 		<read barrier>
-		q = &b;
+		q = ACCESS_ONCE(b);
 	}
 	x = *q;
 
@@ -561,23 +602,23 @@ barrier, though a general barrier would also be viable.  Similarly a read
 barrier or a data dependency barrier should always be paired with at least an
 write barrier, though, again, a general barrier is viable:
 
-	CPU 1		CPU 2
-	===============	===============
-	a = 1;
+	CPU 1		      CPU 2
+	===============	      ===============
+	ACCESS_ONCE(a) = 1;
 	<write barrier>
-	b = 2;		x = b;
-			<read barrier>
-			y = a;
+	ACCESS_ONCE(b) = 2;   x = ACCESS_ONCE(b);
+			      <read barrier>
+			      y = ACCESS_ONCE(a);
 
 Or:
 
-	CPU 1		CPU 2
-	===============	===============================
+	CPU 1		      CPU 2
+	===============	      ===============================
 	a = 1;
 	<write barrier>
-	b = &a;		x = b;
-			<data dependency barrier>
-			y = *x;
+	ACCESS_ONCE(b) = &a;  x = ACCESS_ONCE(b);
+			      <data dependency barrier>
+			      y = *x;
 
 Basically, the read barrier always has to be there, even though it can be of
 the "weaker" type.
@@ -586,13 +627,13 @@ the "weaker" type.
 match the loads after the read barrier or the data dependency barrier, and vice
 versa:
 
-	CPU 1                           CPU 2
-	===============                 ===============
-	a = 1;           }----   --->{  v = c
-	b = 2;           }    \ /    {  w = d
-	<write barrier>        \        <read barrier>
-	c = 3;           }    / \    {  x = a;
-	d = 4;           }----   --->{  y = b;
+	CPU 1                               CPU 2
+	===================                 ===================
+	ACCESS_ONCE(a) = 1;  }----   --->{  v = ACCESS_ONCE(c);
+	ACCESS_ONCE(b) = 2;  }    \ /    {  w = ACCESS_ONCE(d);
+	<write barrier>            \        <read barrier>
+	ACCESS_ONCE(c) = 3;  }    / \    {  x = ACCESS_ONCE(a);
+	ACCESS_ONCE(d) = 4;  }----   --->{  y = ACCESS_ONCE(b);
 
 
 EXAMPLES OF MEMORY BARRIER SEQUENCES
@@ -1435,12 +1476,12 @@ three CPUs; then should the following sequence of events occur:
 
 	CPU 1				CPU 2
 	===============================	===============================
-	*A = a;				*E = e;
+	ACCESS_ONCE(*A) = a;		ACCESS_ONCE(*E) = e;
 	LOCK M				LOCK Q
-	*B = b;				*F = f;
-	*C = c;				*G = g;
+	ACCESS_ONCE(*B) = b;		ACCESS_ONCE(*F) = f;
+	ACCESS_ONCE(*C) = c;		ACCESS_ONCE(*G) = g;
 	UNLOCK M			UNLOCK Q
-	*D = d;				*H = h;
+	ACCESS_ONCE(*D) = d;		ACCESS_ONCE(*H) = h;
 
 Then there is no guarantee as to what order CPU 3 will see the accesses to *A
 through *H occur in, other than the constraints imposed by the separate locks
@@ -1460,17 +1501,17 @@ However, if the following occurs:
 
 	CPU 1				CPU 2
 	===============================	===============================
-	*A = a;
-	LOCK M		[1]
-	*B = b;
-	*C = c;
-	UNLOCK M	[1]
-	*D = d;				*E = e;
-					LOCK M		[2]
-					*F = f;
-					*G = g;
-					UNLOCK M	[2]
-					*H = h;
+	ACCESS_ONCE(*A) = a;
+	LOCK M		     [1]
+	ACCESS_ONCE(*B) = b;
+	ACCESS_ONCE(*C) = c;
+	UNLOCK M	     [1]
+	ACCESS_ONCE(*D) = d;		ACCESS_ONCE(*E) = e;
+					LOCK M		     [2]
+					ACCESS_ONCE(*F) = f;
+					ACCESS_ONCE(*G) = g;
+					UNLOCK M	     [2]
+					ACCESS_ONCE(*H) = h;
 
 CPU 3 might see:
 
@@ -2177,11 +2218,11 @@ A programmer might take it for granted that the CPU will perform memory
 operations in exactly the order specified, so that if the CPU is, for example,
 given the following piece of code to execute:
 
-	a = *A;
-	*B = b;
-	c = *C;
-	d = *D;
-	*E = e;
+	a = ACCESS_ONCE(*A);
+	ACCESS_ONCE(*B) = b;
+	c = ACCESS_ONCE(*C);
+	d = ACCESS_ONCE(*D);
+	ACCESS_ONCE(*E) = e;
 
 they would then expect that the CPU will complete the memory operation for each
 instruction before moving on to the next one, leading to a definite sequence of
@@ -2228,12 +2269,12 @@ However, it is guaranteed that a CPU will be self-consistent: it will see its
 _own_ accesses appear to be correctly ordered, without the need for a memory
 barrier.  For instance with the following code:
 
-	U = *A;
-	*A = V;
-	*A = W;
-	X = *A;
-	*A = Y;
-	Z = *A;
+	U = ACCESS_ONCE(*A);
+	ACCESS_ONCE(*A) = V;
+	ACCESS_ONCE(*A) = W;
+	X = ACCESS_ONCE(*A);
+	ACCESS_ONCE(*A) = Y;
+	Z = ACCESS_ONCE(*A);
 
 and assuming no intervention by an external influence, it can be assumed that
 the final result will appear to be:
@@ -2250,7 +2291,12 @@ accesses:
 
 in that order, but, without intervention, the sequence may have almost any
 combination of elements combined or discarded, provided the program's view of
-the world remains consistent.
+the world remains consistent.  Note that ACCESS_ONCE() is -not- optional
+in the above example, as there are architectures where a given CPU might
+interchange successive loads to the same location.  On such architectures,
+ACCESS_ONCE() does whatever is necessary to prevent this, for example, on
+Itanium the volatile casts used by ACCESS_ONCE() cause GCC to emit the
+special ld.acq and st.rel instructions that prevent such reordering.
 
 The compiler may also combine, discard or defer elements of the sequence before
 the CPU even sees them.
@@ -2264,13 +2310,13 @@ may be reduced to:
 
 	*A = W;
 
-since, without a write barrier, it can be assumed that the effect of the
-storage of V to *A is lost.  Similarly:
+since, without either a write barrier or an ACCESS_ONCE(), it can be
+assumed that the effect of the storage of V to *A is lost.  Similarly:
 
 	*A = Y;
 	Z = *A;
 
-may, without a memory barrier, be reduced to:
+may, without a memory barrier or an ACCESS_ONCE(), be reduced to:
 
 	*A = Y;
 	Z = Y;
