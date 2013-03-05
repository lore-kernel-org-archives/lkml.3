Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab3CECRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:17:35 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:44649 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab3CECR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:17:29 -0500
From: Michel Lespinasse <walken@google.com>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paulmck@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
        rostedt@goodmis.org, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] lockdep: introduce lock_acquire_exclusive/shared helper macros
Date: Mon,  4 Mar 2013 18:17:24 -0800
Message-Id: <1362449845-7492-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362449845-7492-1-git-send-email-walken@google.com>
References: <1362449845-7492-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In lockdep.h, the spinlock/mutex/rwsem/rwlock/lock_map acquire macros
have different definitions based on the value of CONFIG_PROVE_LOCKING.
We have separate ifdefs for each of these definitions, which seems
redundant.

Introduce lock_acquire_{exclusive,shared,shared_recursive} helpers
which will have different definitions based on CONFIG_PROVE_LOCKING.
Then all other helper macros can be defined based on the above ones,
which reduces the amount of ifdefined code.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 include/linux/lockdep.h | 92 +++++++++++++------------------------------------
 1 file changed, 23 insertions(+), 69 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index f1e877b79ed8..cfc2f119779a 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -365,7 +365,7 @@ extern void lockdep_trace_alloc(gfp_t mask);
 
 #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
 
-#else /* !LOCKDEP */
+#else /* !CONFIG_LOCKDEP */
 
 static inline void lockdep_off(void)
 {
@@ -479,82 +479,36 @@ static inline void print_irqtrace_events(struct task_struct *curr)
  * on the per lock-class debug mode:
  */
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
-# else
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
-# endif
-# define spin_release(l, n, i)			lock_release(l, n, i)
+#ifdef CONFIG_PROVE_LOCKING
+ #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
+ #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
+ #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)
 #else
-# define spin_acquire(l, s, t, i)		do { } while (0)
-# define spin_release(l, n, i)			do { } while (0)
+ #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
+ #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
+ #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
 #endif
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
-# else
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
-# endif
-# define rwlock_release(l, n, i)		lock_release(l, n, i)
-#else
-# define rwlock_acquire(l, s, t, i)		do { } while (0)
-# define rwlock_acquire_read(l, s, t, i)	do { } while (0)
-# define rwlock_release(l, n, i)		do { } while (0)
-#endif
+#define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
+#define spin_release(l, n, i)			lock_release(l, n, i)
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
-# else
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
-# endif
-# define mutex_release(l, n, i)			lock_release(l, n, i)
-#else
-# define mutex_acquire(l, s, t, i)		do { } while (0)
-# define mutex_acquire_nest(l, s, t, n, i)	do { } while (0)
-# define mutex_release(l, n, i)			do { } while (0)
-#endif
+#define rwlock_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_recursive(l, s, t, NULL, i)
+#define rwlock_release(l, n, i)			lock_release(l, n, i)
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
-# else
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
-# endif
+#define mutex_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define mutex_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
+#define mutex_release(l, n, i)			lock_release(l, n, i)
+
+#define rwsem_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
+#define rwsem_acquire_read(l, s, t, i)		lock_acquire_shared(l, s, t, NULL, i)
 # define rwsem_release(l, n, i)			lock_release(l, n, i)
-#else
-# define rwsem_acquire(l, s, t, i)		do { } while (0)
-# define rwsem_acquire_nest(l, s, t, n, i)	do { } while (0)
-# define rwsem_acquire_read(l, s, t, i)		do { } while (0)
-# define rwsem_release(l, n, i)			do { } while (0)
-#endif
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
-#  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 2, NULL, _THIS_IP_)
-# else
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
-#  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 1, NULL, _THIS_IP_)
-# endif
+#define lock_map_acquire(l)			lock_acquire_exclusive(l, 0, 0, NULL, _THIS_IP_)
+#define lock_map_acquire_read(l)		lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
 # define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
-#else
-# define lock_map_acquire(l)			do { } while (0)
-# define lock_map_acquire_read(l)		do { } while (0)
-# define lock_map_release(l)			do { } while (0)
-#endif
 
 #ifdef CONFIG_PROVE_LOCKING
 # define might_lock(lock) 						\
-- 
1.8.1.3
