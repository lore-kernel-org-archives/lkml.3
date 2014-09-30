Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaI3MsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:48:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35740 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaI3MsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:48:15 -0400
Date: Tue, 30 Sep 2014 14:48:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, ego@linux.vnet.ibm.com, bp@alien8.de,
        Waiman.Long@hp.com
Subject: locking/lockdep: Revert qrwlock recusive stuff
Message-ID: <20140930124807.GA4241@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit f0bab73cb539 ("locking/lockdep: Restrict the use of recursive
read_lock() with qrwlock") changed lockdep to try and conform to the
qrwlock semantics which differ from the traditional rwlock semantics.

In particular qrwlock is fair outside of interrupt context, but in
interrupt context readers will ignore all fairness.

The problem modeling this is that read and write side have different
lock state (interrupts) semantics but we only have a single
representation of these. Therefore lockdep will get confused, thinking
the lock can cause interrupt lock inversions.

So revert for now; the old rwlock semantics were already imperfectly
modeled and the qrwlock extra won't fit either.

If we want to properly fix this, I think we need to resurrect the work
Gautham did a few years ago that split the read and write state of
locks:

   http://lwn.net/Articles/332801/

Cc: ego@linux.vnet.ibm.com
Cc: bp@alien8.de
Cc: Waiman.Long@hp.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
diff --git b/include/linux/lockdep.h a/include/linux/lockdep.h
index b5a84b62fb84..f388481201cd 100644
--- b/include/linux/lockdep.h
+++ a/include/linux/lockdep.h
@@ -478,24 +478,16 @@ static inline void print_irqtrace_events(struct task_struct *curr)
  * on the per lock-class debug mode:
  */
 
-/*
- * Read states in the 2-bit held_lock:read field:
- *  0: Exclusive lock
- *  1: Shareable lock, cannot be recursively called
- *  2: Shareable lock, can be recursively called
- *  3: Shareable lock, cannot be recursively called except in interrupt context
- */
 #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
 #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
 #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
-#define lock_acquire_shared_irecursive(l, s, t, n, i)	lock_acquire(l, s, t, 3, 1, n, i)
 
 #define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
 #define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
 #define spin_release(l, n, i)			lock_release(l, n, i)
 
 #define rwlock_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
-#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_irecursive(l, s, t, NULL, i)
+#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_recursive(l, s, t, NULL, i)
 #define rwlock_release(l, n, i)			lock_release(l, n, i)
 
 #define seqcount_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
diff --git b/kernel/locking/lockdep.c a/kernel/locking/lockdep.c
index 420ba685c4e5..88d0d4420ad2 100644
--- b/kernel/locking/lockdep.c
+++ a/kernel/locking/lockdep.c
@@ -3597,12 +3597,6 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	raw_local_irq_save(flags);
 	check_flags(flags);
 
-	/*
-	 * An interrupt recursive read in interrupt context can be considered
-	 * to be the same as a recursive read from checking perspective.
-	 */
-	if ((read == 3) && in_interrupt())
-		read = 2;
 	current->lockdep_recursion = 1;
 	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
 	__lock_acquire(lock, subclass, trylock, read, check,
