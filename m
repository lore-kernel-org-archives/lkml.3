Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964975Ab3GLNcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:32:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59740 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964884Ab3GLNca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:32:30 -0400
Date: Fri, 12 Jul 2013 06:29:18 -0700
From: tip-bot for Michel Lespinasse <tipbot@zytor.com>
Message-ID: <tip-a51805efae5dda0da66f79268ffcf0715f9dbea4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, rostedt@goodmis.org,
        paulmck@us.ibm.com, akpm@linux-foundation.org, ak@linux.intel.com,
        tglx@linutronix.de, oleg@redhat.com, walken@google.com,
        laijs@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, akpm@linux-foundation.org,
        rostedt@goodmis.org, paulmck@us.ibm.com, ak@linux.intel.com,
        oleg@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
        walken@google.com
In-Reply-To: <20130708212350.6DD1931C15E@corp2gmr1-1.hot.corp.google.com>
References: <20130708212350.6DD1931C15E@corp2gmr1-1.hot.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Introduce lock_acquire_exclusive()/
 shared() helper macros
Git-Commit-ID: a51805efae5dda0da66f79268ffcf0715f9dbea4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 06:29:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a51805efae5dda0da66f79268ffcf0715f9dbea4
Gitweb:     http://git.kernel.org/tip/a51805efae5dda0da66f79268ffcf0715f9dbea4
Author:     Michel Lespinasse <walken@google.com>
AuthorDate: Mon, 8 Jul 2013 14:23:49 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Jul 2013 13:51:18 +0200

lockdep: Introduce lock_acquire_exclusive()/shared() helper macros

In lockdep.h, the spinlock/mutex/rwsem/rwlock/lock_map acquire macros have
different definitions based on the value of CONFIG_PROVE_LOCKING.  We have
separate ifdefs for each of these definitions, which seems redundant.

Introduce lock_acquire_{exclusive,shared,shared_recursive} helpers which
will have different definitions based on CONFIG_PROVE_LOCKING.  Then all
other helper macros can be defined based on the above ones, which reduces
the amount of ifdefined code.

Signed-off-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20130708212350.6DD1931C15E@corp2gmr1-1.hot.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/lockdep.h | 92 +++++++++++++------------------------------------
 1 file changed, 23 insertions(+), 69 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index f1e877b..cfc2f11 100644
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
