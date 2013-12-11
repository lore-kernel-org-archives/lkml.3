Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab3LKWAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:00:06 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:45885 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3LKV7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:59:25 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v6 tip/core/locking 6/8] Documentation/memory-barriers.txt: Downgrade UNLOCK+LOCK
Date: Wed, 11 Dec 2013 13:59:09 -0800
Message-Id: <1386799151-2219-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386799151-2219-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131211215850.GA810@linux.vnet.ibm.com>
 <1386799151-2219-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121121-7164-0000-0000-000004261797
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Historically, an UNLOCK+LOCK pair executed by one CPU, by one task,
or on a given lock variable has implied a full memory barrier.  In a
recent LKML thread, the wisdom of this historical approach was called
into question: http://www.spinics.net/lists/linux-mm/msg65653.html,
in part due to the memory-order complexities of low-handoff-overhead
queued locks on x86 systems.

This patch therefore removes this guarantee from the documentation, and
further documents how to restore it via a new smp_mb__after_unlock_lock()
primitive.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <waiman.long@hp.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 Documentation/memory-barriers.txt | 84 ++++++++++++++++++++++++++++++++-------
 1 file changed, 69 insertions(+), 15 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 8d4e34239d8d..033e7d67806a 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -402,12 +402,18 @@ And a couple of implicit varieties:
      Memory operations that occur after an UNLOCK operation may appear to
      happen before it completes.
 
-     LOCK and UNLOCK operations are guaranteed to appear with respect to each
-     other strictly in the order specified.
-
      The use of LOCK and UNLOCK operations generally precludes the need for
      other sorts of memory barrier (but note the exceptions mentioned in the
-     subsection "MMIO write barrier").
+     subsection "MMIO write barrier").  In addition, an UNLOCK+LOCK pair
+     is -not- guaranteed to act as a full memory barrier.  However,
+     after a LOCK on a given lock variable, all memory accesses preceding any
+     prior UNLOCK on that same variable are guaranteed to be visible.
+     In other words, within a given lock variable's critical section,
+     all accesses of all previous critical sections for that lock variable
+     are guaranteed to have completed.
+
+     This means that LOCK acts as a minimal "acquire" operation and
+     UNLOCK acts as a minimal "release" operation.
 
 
 Memory barriers are only required where there's a possibility of interaction
@@ -1633,8 +1639,12 @@ for each construct.  These operations all imply certain barriers:
      Memory operations issued after the LOCK will be completed after the LOCK
      operation has completed.
 
-     Memory operations issued before the LOCK may be completed after the LOCK
-     operation has completed.
+     Memory operations issued before the LOCK may be completed after the
+     LOCK operation has completed.  An smp_mb__before_spinlock(), combined
+     with a following LOCK, orders prior loads against subsequent stores
+     and stores and prior stores against subsequent stores.  Note that
+     this is weaker than smp_mb()!  The smp_mb__before_spinlock()
+     primitive is free on many architectures.
 
  (2) UNLOCK operation implication:
 
@@ -1654,9 +1664,6 @@ for each construct.  These operations all imply certain barriers:
      All LOCK operations issued before an UNLOCK operation will be completed
      before the UNLOCK operation.
 
-     All UNLOCK operations issued before a LOCK operation will be completed
-     before the LOCK operation.
-
  (5) Failed conditional LOCK implication:
 
      Certain variants of the LOCK operation may fail, either due to being
@@ -1664,9 +1671,6 @@ for each construct.  These operations all imply certain barriers:
      signal whilst asleep waiting for the lock to become available.  Failed
      locks do not imply any sort of barrier.
 
-Therefore, from (1), (2) and (4) an UNLOCK followed by an unconditional LOCK is
-equivalent to a full barrier, but a LOCK followed by an UNLOCK is not.
-
 [!] Note: one of the consequences of LOCKs and UNLOCKs being only one-way
     barriers is that the effects of instructions outside of a critical section
     may seep into the inside of the critical section.
@@ -1677,13 +1681,57 @@ LOCK, and an access following the UNLOCK to happen before the UNLOCK, and the
 two accesses can themselves then cross:
 
 	*A = a;
-	LOCK
-	UNLOCK
+	LOCK M
+	UNLOCK M
 	*B = b;
 
 may occur as:
 
-	LOCK, STORE *B, STORE *A, UNLOCK
+	LOCK M, STORE *B, STORE *A, UNLOCK M
+
+This same reordering can of course occur if the LOCK and UNLOCK are
+to the same lock variable, but only from the perspective of another
+CPU not holding that lock.
+
+In short, an UNLOCK followed by a LOCK may -not- be assumed to be a full
+memory barrier because it is possible for a preceding UNLOCK to pass a
+later LOCK from the viewpoint of the CPU, but not from the viewpoint
+of the compiler.  Note that deadlocks cannot be introduced by this
+interchange because if such a deadlock threatened, the UNLOCK would
+simply complete.
+
+If it is necessary for an UNLOCK-LOCK pair to produce a full barrier,
+the LOCK can be followed by an smp_mb__after_unlock_lock() invocation.
+This will produce a full barrier if either (a) the UNLOCK and the LOCK
+are executed by the same CPU or task, or (b) the UNLOCK and LOCK act
+on the same lock variable.  The smp_mb__after_unlock_lock() primitive
+is free on many architectures.  Without smp_mb__after_unlock_lock(),
+the critical sections corresponding to the UNLOCK and the LOCK can cross:
+
+	*A = a;
+	UNLOCK M
+	LOCK N
+	*B = b;
+
+could occur as:
+
+	LOCK N, STORE *B, STORE *A, UNLOCK M
+
+With smp_mb__after_unlock_lock(), they cannot, so that:
+
+	*A = a;
+	UNLOCK M
+	LOCK N
+	smp_mb__after_unlock_lock();
+	*B = b;
+
+will always occur as either of the following:
+
+	STORE *A, UNLOCK, LOCK, STORE *B
+	STORE *A, LOCK, UNLOCK, STORE *B
+
+If the UNLOCK and LOCK were instead both operating on the same lock
+variable, only the first of these two alternatives can occur.
 
 Locks and semaphores may not provide any guarantee of ordering on UP compiled
 systems, and so cannot be counted on in such a situation to actually achieve
@@ -1911,6 +1959,7 @@ However, if the following occurs:
 	UNLOCK M	     [1]
 	ACCESS_ONCE(*D) = d;		ACCESS_ONCE(*E) = e;
 					LOCK M		     [2]
+					smp_mb__after_unlock_lock();
 					ACCESS_ONCE(*F) = f;
 					ACCESS_ONCE(*G) = g;
 					UNLOCK M	     [2]
@@ -1928,6 +1977,11 @@ But assuming CPU 1 gets the lock first, CPU 3 won't see any of:
 	*F, *G or *H preceding LOCK M [2]
 	*A, *B, *C, *E, *F or *G following UNLOCK M [2]
 
+Note that the smp_mb__after_unlock_lock() is critically important
+here: Without it CPU 3 might see some of the above orderings.
+Without smp_mb__after_unlock_lock(), the accesses are not guaranteed
+to be seen in order unless CPU 3 holds lock M.
+
 
 LOCKS VS I/O ACCESSES
 ---------------------
-- 
1.8.1.5

