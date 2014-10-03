Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaJCFai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:30:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60957 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaJCFad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:30:33 -0400
Date: Thu, 2 Oct 2014 22:29:34 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-8acd91e8620836a56ff62028ed28ba629f2881a0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com, tglx@linutronix.de
In-Reply-To: <20140930132600.GA7444@worktop.programming.kicks-ass.net>
References: <20140930132600.GA7444@worktop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/lockdep: Revert qrwlock recusive stuff
Git-Commit-ID: 8acd91e8620836a56ff62028ed28ba629f2881a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8acd91e8620836a56ff62028ed28ba629f2881a0
Gitweb:     http://git.kernel.org/tip/8acd91e8620836a56ff62028ed28ba629f2881a0
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 30 Sep 2014 15:26:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 3 Oct 2014 06:09:30 +0200

locking/lockdep: Revert qrwlock recusive stuff

Commit f0bab73cb539 ("locking/lockdep: Restrict the use of recursive
read_lock() with qrwlock") changed lockdep to try and conform to the
qrwlock semantics which differ from the traditional rwlock semantics.

In particular qrwlock is fair outside of interrupt context, but in
interrupt context readers will ignore all fairness.

The problem modeling this is that read and write side have different
lock state (interrupts) semantics but we only have a single
representation of these. Therefore lockdep will get confused, thinking
the lock can cause interrupt lock inversions.

So revert it for now; the old rwlock semantics were already imperfectly
modeled and the qrwlock extra won't fit either.

If we want to properly fix this, I think we need to resurrect the work
by Gautham did a few years ago that split the read and write state of
locks:

   http://lwn.net/Articles/332801/

FWIW the locking selftest that would've failed (and was reported by
Borislav earlier) is something like:

  RL(X1);	/* IRQ-ON */
  LOCK(A);
  UNLOCK(A);
  RU(X1);

  IRQ_ENTER();
  RL(X1);	/* IN-IRQ */
  RU(X1);
  IRQ_EXIT();

At which point it would report that because A is an IRQ-unsafe lock we
can suffer the following inversion:

	CPU0		CPU1

	lock(A)
			lock(X1)
			lock(A)
	<IRQ>
	 lock(X1)

And this is 'wrong' because X1 can recurse (assuming the above lock are
in fact read-lock) but lockdep doesn't know about this.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Waiman Long <Waiman.Long@hp.com>
Cc: ego@linux.vnet.ibm.com
Cc: bp@alien8.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20140930132600.GA7444@worktop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/lockdep.h  | 10 +--------
 kernel/locking/lockdep.c |  6 ------
 lib/locking-selftest.c   | 56 ++++++------------------------------------------
 3 files changed, 8 insertions(+), 64 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index b5a84b62..f388481 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
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
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 420ba68..88d0d44 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
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
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 62af709..872a15a 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -267,46 +267,19 @@ GENERATE_TESTCASE(AA_rsem)
 #undef E
 
 /*
- * Special-case for read-locking, they are not allowed to
- * recurse on the same lock class except under interrupt context:
+ * Special-case for read-locking, they are
+ * allowed to recurse on the same lock class:
  */
 static void rlock_AA1(void)
 {
 	RL(X1);
-	RL(X1); // this one should fail
+	RL(X1); // this one should NOT fail
 }
 
 static void rlock_AA1B(void)
 {
 	RL(X1);
-	RL(X2); // this one should fail
-}
-
-static void rlock_AHA1(void)
-{
-	RL(X1);
-	HARDIRQ_ENTER();
-	RL(X1);	// this one should NOT fail
-	HARDIRQ_EXIT();
-}
-
-static void rlock_AHA1B(void)
-{
-	RL(X1);
-	HARDIRQ_ENTER();
-	RL(X2);	// this one should NOT fail
-	HARDIRQ_EXIT();
-}
-
-static void rlock_ASAHA1(void)
-{
-	RL(X1);
-	SOFTIRQ_ENTER();
-	RL(X1);	// this one should NOT fail
-	HARDIRQ_ENTER();
-	RL(X1);	// this one should NOT fail
-	HARDIRQ_EXIT();
-	SOFTIRQ_EXIT();
+	RL(X2); // this one should NOT fail
 }
 
 static void rsem_AA1(void)
@@ -1096,7 +1069,7 @@ static inline void print_testname(const char *testname)
 	print_testname(desc);					\
 	dotest(name##_spin, FAILURE, LOCKTYPE_SPIN);		\
 	dotest(name##_wlock, FAILURE, LOCKTYPE_RWLOCK);		\
-	dotest(name##_rlock, FAILURE, LOCKTYPE_RWLOCK);		\
+	dotest(name##_rlock, SUCCESS, LOCKTYPE_RWLOCK);		\
 	dotest(name##_mutex, FAILURE, LOCKTYPE_MUTEX);		\
 	dotest(name##_wsem, FAILURE, LOCKTYPE_RWSEM);		\
 	dotest(name##_rsem, FAILURE, LOCKTYPE_RWSEM);		\
@@ -1857,14 +1830,14 @@ void locking_selftest(void)
 	printk("  --------------------------------------------------------------------------\n");
 	print_testname("recursive read-lock");
 	printk("             |");
-	dotest(rlock_AA1, FAILURE, LOCKTYPE_RWLOCK);
+	dotest(rlock_AA1, SUCCESS, LOCKTYPE_RWLOCK);
 	printk("             |");
 	dotest(rsem_AA1, FAILURE, LOCKTYPE_RWSEM);
 	printk("\n");
 
 	print_testname("recursive read-lock #2");
 	printk("             |");
-	dotest(rlock_AA1B, FAILURE, LOCKTYPE_RWLOCK);
+	dotest(rlock_AA1B, SUCCESS, LOCKTYPE_RWLOCK);
 	printk("             |");
 	dotest(rsem_AA1B, FAILURE, LOCKTYPE_RWSEM);
 	printk("\n");
@@ -1883,21 +1856,6 @@ void locking_selftest(void)
 	dotest(rsem_AA3, FAILURE, LOCKTYPE_RWSEM);
 	printk("\n");
 
-	print_testname("recursive rlock with interrupt");
-	printk("             |");
-	dotest(rlock_AHA1, SUCCESS, LOCKTYPE_RWLOCK);
-	printk("\n");
-
-	print_testname("recursive rlock with interrupt #2");
-	printk("             |");
-	dotest(rlock_AHA1B, SUCCESS, LOCKTYPE_RWLOCK);
-	printk("\n");
-
-	print_testname("recursive rlock with interrupt #3");
-	printk("             |");
-	dotest(rlock_ASAHA1, SUCCESS, LOCKTYPE_RWLOCK);
-	printk("\n");
-
 	printk("  --------------------------------------------------------------------------\n");
 
 	/*
