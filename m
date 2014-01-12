Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaALRpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:45:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaALRpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:45:46 -0500
Date: Sun, 12 Jan 2014 18:45:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/1] lockdep: Kill held_lock->check and "int check" arg of
	__lock_acquire()
Message-ID: <20140112174554.GB12147@redhat.com>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net> <20140109163120.GA8038@redhat.com> <20140109170823.GF7572@laptop.programming.kicks-ass.net> <20140112094041.GB31809@gmail.com> <20140112174532.GA12147@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140112174532.GA12147@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "int check" argument of lock_acquire() and held_lock->check
are misleading and unneeded. This is only used as a boolean, 2
denotes "true", everything else is "false". And this boolean is
always equal to prove_locking.

The only exception is __lockdep_no_validate__ which should make
this condition "false" in validate_chain().

This patch kills this member and removes the argument from
__lock_acquire(), the next patch will remove the now unused arg
from lock_acquire() and update its callers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/lockdep.h  |    1 -
 kernel/locking/lockdep.c |   22 ++++++++--------------
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 92b1bfc..13bd13d 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -252,7 +252,6 @@ struct held_lock {
 	unsigned int trylock:1;						/* 16 bits */
 
 	unsigned int read:2;        /* see lock_acquire() comment */
-	unsigned int check:2;       /* see lock_acquire() comment */
 	unsigned int hardirqs_off:1;
 	unsigned int references:11;					/* 32 bits */
 };
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 576ba75..32ba948 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2096,7 +2096,8 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 	 * (If lookup_chain_cache() returns with 1 it acquires
 	 * graph_lock for us)
 	 */
-	if (!hlock->trylock && (hlock->check == 2) &&
+	if (!hlock->trylock && prove_locking &&
+	    hlock_class(hlock)->key != __lockdep_no_validate__.subkeys &&
 	    lookup_chain_cache(curr, hlock, chain_key)) {
 		/*
 		 * Check whether last held lock:
@@ -3041,7 +3042,7 @@ static int __lock_is_held(struct lockdep_map *lock);
  * We maintain the dependency maps and validate the locking attempt:
  */
 static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			  int trylock, int read, int check, int hardirqs_off,
+			  int trylock, int read, int hardirqs_off,
 			  struct lockdep_map *nest_lock, unsigned long ip,
 			  int references)
 {
@@ -3053,9 +3054,6 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	int class_idx;
 	u64 chain_key;
 
-	if (!prove_locking)
-		check = 1;
-
 	if (unlikely(!debug_locks))
 		return 0;
 
@@ -3067,9 +3065,6 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
 
-	if (lock->key == &__lockdep_no_validate__)
-		check = 1;
-
 	if (subclass < NR_LOCKDEP_CACHING_CLASSES)
 		class = lock->class_cache[subclass];
 	/*
@@ -3128,7 +3123,6 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->nest_lock = nest_lock;
 	hlock->trylock = trylock;
 	hlock->read = read;
-	hlock->check = check;
 	hlock->hardirqs_off = !!hardirqs_off;
 	hlock->references = references;
 #ifdef CONFIG_LOCK_STAT
@@ -3136,7 +3130,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->holdtime_stamp = lockstat_clock();
 #endif
 
-	if (check == 2 && !mark_irqflags(curr, hlock))
+	if (prove_locking && !mark_irqflags(curr, hlock))
 		return 0;
 
 	/* mark it as used: */
@@ -3338,7 +3332,7 @@ found_it:
 		hlock = curr->held_locks + i;
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
-				hlock->read, hlock->check, hlock->hardirqs_off,
+				hlock->read, hlock->hardirqs_off,
 				hlock->nest_lock, hlock->acquire_ip,
 				hlock->references))
 			return 0;
@@ -3422,7 +3416,7 @@ found_it:
 		hlock = curr->held_locks + i;
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
-				hlock->read, hlock->check, hlock->hardirqs_off,
+				hlock->read, hlock->hardirqs_off,
 				hlock->nest_lock, hlock->acquire_ip,
 				hlock->references))
 			return 0;
@@ -3598,8 +3592,8 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 	current->lockdep_recursion = 1;
 	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
-	__lock_acquire(lock, subclass, trylock, read, check,
-		       irqs_disabled_flags(flags), nest_lock, ip, 0);
+	__lock_acquire(lock, subclass, trylock, read,
+			irqs_disabled_flags(flags), nest_lock, ip, 0);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-- 
1.5.5.1


