Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaBJNeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:34:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33385 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaBJNd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:33:59 -0500
Date: Mon, 10 Feb 2014 05:32:57 -0800
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-fb9edbe98493fcd9df66de926ae9157cbe0e4dcd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, stern@rowland.harvard.edu,
        torvalds@linux-foundation.org, peterz@infradead.org, davej@redhat.com,
        gregkh@linuxfoundation.org, paulmck@linux.vnet.ibm.com,
        rostedt@goodmis.org, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        torvalds@linux-foundation.org, peterz@infradead.org, davej@redhat.com,
        paulmck@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        rostedt@goodmis.org, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20140120182006.GA26495@redhat.com>
References: <20140120182006.GA26495@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Make held_lock->check and "int check"
  argument bool
Git-Commit-ID: fb9edbe98493fcd9df66de926ae9157cbe0e4dcd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:33:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb9edbe98493fcd9df66de926ae9157cbe0e4dcd
Gitweb:     http://git.kernel.org/tip/fb9edbe98493fcd9df66de926ae9157cbe0e4dcd
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 20 Jan 2014 19:20:06 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 21:18:54 +0100

lockdep: Make held_lock->check and "int check" argument bool

The "int check" argument of lock_acquire() and held_lock->check are
misleading. This is actually a boolean: 2 means "true", everything
else is "false".

And there is no need to pass 1 or 0 to lock_acquire() depending on
CONFIG_PROVE_LOCKING, __lock_acquire() checks prove_locking at the
start and clears "check" if !CONFIG_PROVE_LOCKING.

Note: probably we can simply kill this member/arg. The only explicit
user of check => 0 is rcu_lock_acquire(), perhaps we can change it to
use lock_acquire(trylock =>, read => 2). __lockdep_no_validate means
check => 0 implicitly, but we can change validate_chain() to check
hlock->instance->key instead. Not to mention it would be nice to get
rid of lockdep_set_novalidate_class().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140120182006.GA26495@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/tty/tty_ldsem.c  | 15 ++++-----------
 include/linux/lockdep.h  | 25 +++++++++----------------
 include/linux/rcupdate.h |  2 +-
 kernel/locking/lockdep.c | 11 ++++-------
 4 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index d8a55e8..0ffb0cb 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -39,17 +39,10 @@
 				lock_acquire(&(l)->dep_map, s, t, r, c, n, i)
 # define __rel(l, n, i)				\
 				lock_release(&(l)->dep_map, n, i)
-# ifdef CONFIG_PROVE_LOCKING
-#  define lockdep_acquire(l, s, t, i)		__acq(l, s, t, 0, 2, NULL, i)
-#  define lockdep_acquire_nest(l, s, t, n, i)	__acq(l, s, t, 0, 2, n, i)
-#  define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 1, 2, NULL, i)
-#  define lockdep_release(l, n, i)		__rel(l, n, i)
-# else
-#  define lockdep_acquire(l, s, t, i)		__acq(l, s, t, 0, 1, NULL, i)
-#  define lockdep_acquire_nest(l, s, t, n, i)	__acq(l, s, t, 0, 1, n, i)
-#  define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 1, 1, NULL, i)
-#  define lockdep_release(l, n, i)		__rel(l, n, i)
-# endif
+#define lockdep_acquire(l, s, t, i)		__acq(l, s, t, 0, 1, NULL, i)
+#define lockdep_acquire_nest(l, s, t, n, i)	__acq(l, s, t, 0, 1, n, i)
+#define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 1, 1, NULL, i)
+#define lockdep_release(l, n, i)		__rel(l, n, i)
 #else
 # define lockdep_acquire(l, s, t, i)		do { } while (0)
 # define lockdep_acquire_nest(l, s, t, n, i)	do { } while (0)
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 92b1bfc..1626047 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -252,9 +252,9 @@ struct held_lock {
 	unsigned int trylock:1;						/* 16 bits */
 
 	unsigned int read:2;        /* see lock_acquire() comment */
-	unsigned int check:2;       /* see lock_acquire() comment */
+	unsigned int check:1;       /* see lock_acquire() comment */
 	unsigned int hardirqs_off:1;
-	unsigned int references:11;					/* 32 bits */
+	unsigned int references:12;					/* 32 bits */
 };
 
 /*
@@ -326,9 +326,8 @@ static inline int lockdep_match_key(struct lockdep_map *lock,
  *
  * Values for check:
  *
- *   0: disabled
- *   1: simple checks (freeing, held-at-exit-time, etc.)
- *   2: full validation
+ *   0: simple checks (freeing, held-at-exit-time, etc.)
+ *   1: full validation
  */
 extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			 int trylock, int read, int check,
@@ -479,15 +478,9 @@ static inline void print_irqtrace_events(struct task_struct *curr)
  * on the per lock-class debug mode:
  */
 
-#ifdef CONFIG_PROVE_LOCKING
- #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
- #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
- #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)
-#else
- #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
- #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
- #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
-#endif
+#define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
+#define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
+#define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
 
 #define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
 #define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
@@ -518,13 +511,13 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 # define might_lock(lock) 						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 0, 2, NULL, _THIS_IP_);	\
+	lock_acquire(&(lock)->dep_map, 0, 0, 0, 1, NULL, _THIS_IP_);	\
 	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
 } while (0)
 # define might_lock_read(lock) 						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 1, 2, NULL, _THIS_IP_);	\
+	lock_acquire(&(lock)->dep_map, 0, 0, 1, 1, NULL, _THIS_IP_);	\
 	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
 } while (0)
 #else
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 72bf3a0..adff3c9 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -314,7 +314,7 @@ static inline bool rcu_lockdep_current_cpu_online(void)
 
 static inline void rcu_lock_acquire(struct lockdep_map *map)
 {
-	lock_acquire(map, 0, 0, 2, 1, NULL, _THIS_IP_);
+	lock_acquire(map, 0, 0, 2, 0, NULL, _THIS_IP_);
 }
 
 static inline void rcu_lock_release(struct lockdep_map *map)
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index eb8a547..8c85a0d 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2098,7 +2098,7 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 	 * (If lookup_chain_cache() returns with 1 it acquires
 	 * graph_lock for us)
 	 */
-	if (!hlock->trylock && (hlock->check == 2) &&
+	if (!hlock->trylock && hlock->check &&
 	    lookup_chain_cache(curr, hlock, chain_key)) {
 		/*
 		 * Check whether last held lock:
@@ -3055,9 +3055,6 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	int class_idx;
 	u64 chain_key;
 
-	if (!prove_locking)
-		check = 1;
-
 	if (unlikely(!debug_locks))
 		return 0;
 
@@ -3069,8 +3066,8 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
 
-	if (lock->key == &__lockdep_no_validate__)
-		check = 1;
+	if (!prove_locking || lock->key == &__lockdep_no_validate__)
+		check = 0;
 
 	if (subclass < NR_LOCKDEP_CACHING_CLASSES)
 		class = lock->class_cache[subclass];
@@ -3138,7 +3135,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->holdtime_stamp = lockstat_clock();
 #endif
 
-	if (check == 2 && !mark_irqflags(curr, hlock))
+	if (check && !mark_irqflags(curr, hlock))
 		return 0;
 
 	/* mark it as used: */
