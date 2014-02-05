Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaBEVpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:45:04 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:3786 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaBEVo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:44:59 -0500
Message-ID: <52F2B0C2.8040408@hp.com>
Date: Wed, 05 Feb 2014 16:44:34 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jason Low <jason.low2@hp.com>, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to spin_on_owner
 if need_resched() triggered while queued
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com> <1390936396-3962-6-git-send-email-jason.low2@hp.com> <20140128210753.GJ11314@laptop.programming.kicks-ass.net> <1390949495.2807.52.camel@j-VirtualBox> <20140129115142.GE9636@twins.programming.kicks-ass.net>
In-Reply-To: <20140129115142.GE9636@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2014 06:51 AM, Peter Zijlstra wrote:
> On Tue, Jan 28, 2014 at 02:51:35PM -0800, Jason Low wrote:
>>> But urgh, nasty problem. Lemme ponder this a bit.
> OK, please have a very careful look at the below. It survived a boot
> with udev -- which usually stresses mutex contention enough to explode
> (in fact it did a few time when I got the contention/cancel path wrong),
> however I have not ran anything else on it.
>
> The below is an MCS variant that allows relatively cheap unqueueing. But
> its somewhat tricky and I might have gotten a case wrong, esp. the
> double concurrent cancel case got my head hurting (I didn't attempt a
> tripple unqueue).
>
> Applies to tip/master but does generate a few (harmless) compile
> warnings because I didn't fully clean up the mcs_spinlock vs m_spinlock
> thing.
>
> Also, there's a comment in the slowpath that bears consideration.
>
>

I have an alternative way of breaking out of the MCS lock waiting queue 
when need_resched() is set. I overload the locked flag to indicate a 
skipped node if negative. I run the patch through the AIM7 high-systime 
workload on a 4-socket server and it seemed to run fine.

Please check the following POC patch to see if you have any comment.
diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
index e9a4d74..84a0b32 100644
--- a/include/linux/mcs_spinlock.h
+++ b/include/linux/mcs_spinlock.h
@@ -14,17 +14,45 @@

  struct mcs_spinlock {
      struct mcs_spinlock *next;
-    int locked; /* 1 if lock acquired */
+    int locked; /* 1 if lock acquired, -1 if skipping node */
  };

+/*
+ * The node skipping feature requires the MCS node to be persistent,
+ * i.e. not allocated on stack. In addition, the MCS node cannot be
+ * reused until after the locked flag is cleared. The mcs_skip_node()
+ * macro must be defined before including this header file.
+ */
+#ifdef mcs_skip_node
+#undef arch_mcs_spin_lock_contended
+#undef arch_mcs_spin_unlock_contended
+
+#define    arch_mcs_spin_lock_contended(n)                    \
+do {                                    \
+    while (!smp_load_acquire(&(n)->locked)) {            \
+        if (mcs_skip_node(n)) {                    \
+            if (cmpxchg(&(n)->locked, 0, -1) == 0)        \
+                return;                    \
+        }                            \
+        arch_mutex_cpu_relax();                    \
+    };                                \
+} while (0)
+
+#define    arch_mcs_spin_unlock_contended(n)                \
+    if (cmpxchg(&(n)->locked, 0, 1) == 0)                \
+        return
+
+#define mcs_set_locked(n, v)    (n)->locked = (v)
+#else    /* mcs_skip_node */
+
  #ifndef arch_mcs_spin_lock_contended
  /*
   * Using smp_load_acquire() provides a memory barrier that ensures
   * subsequent operations happen after the lock is acquired.
   */
-#define arch_mcs_spin_lock_contended(l)                    \
+#define arch_mcs_spin_lock_contended(n)                    \
  do {                                    \
-    while (!(smp_load_acquire(l)))                    \
+    while (!(smp_load_acquire(&(n)->locked)))            \
          arch_mutex_cpu_relax();                    \
  } while (0)
  #endif
@@ -35,9 +63,12 @@ do {                                \
   * operations in the critical section has been completed before
   * unlocking.
   */
-#define arch_mcs_spin_unlock_contended(l)                \
-    smp_store_release((l), 1)
+#define arch_mcs_spin_unlock_contended(n)                \
+    smp_store_release(&(n)->locked, 1)
+
+#define mcs_set_locked(n, v)
  #endif
+#endif    /* mcs_skip_node */

  /*
   * Note: the smp_load_acquire/smp_store_release pair is not
@@ -77,12 +108,13 @@ void mcs_spin_lock(struct mcs_spinlock **lock, 
struct mcs_spinlock *node)
           * value won't be used. If a debug mode is needed to
           * audit lock status, then set node->locked value here.
           */
+        mcs_set_locked(node, 1);
          return;
      }
      ACCESS_ONCE(prev->next) = node;

      /* Wait until the lock holder passes the lock down. */
-    arch_mcs_spin_lock_contended(&node->locked);
+    arch_mcs_spin_lock_contended(node);
  }

  /*
@@ -94,19 +126,35 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, 
struct mcs_spinlock *node)
  {
      struct mcs_spinlock *next = ACCESS_ONCE(node->next);

+#ifdef mcs_skip_node
+check_next_node:
+#endif
      if (likely(!next)) {
          /*
           * Release the lock by setting it to NULL
           */
-        if (likely(cmpxchg(lock, node, NULL) == node))
+        if (likely(cmpxchg(lock, node, NULL) == node)) {
+            mcs_set_locked(node, 0);
              return;
+        }
          /* Wait until the next pointer is set */
          while (!(next = ACCESS_ONCE(node->next)))
              arch_mutex_cpu_relax();
      }
+    /* Clear the lock flag to indicate the node can be used again. */
+    mcs_set_locked(node, 0);

      /* Pass lock to next waiter. */
-    arch_mcs_spin_unlock_contended(&next->locked);
+    arch_mcs_spin_unlock_contended(next);
+
+#ifdef mcs_skip_node
+    /*
+     * The next node should be skipped
+     */
+    node = next;
+    next = ACCESS_ONCE(node->next);
+    goto check_next_node;
+#endif
  }

  #endif /* __LINUX_MCS_SPINLOCK_H */
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 45fe1b5..6351eca 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -25,6 +25,10 @@
  #include <linux/spinlock.h>
  #include <linux/interrupt.h>
  #include <linux/debug_locks.h>
+/*
+ * Allowed an MCS node to be skipped if need_resched() is true.
+ */
+#define mcs_skip_node(n)    need_resched()
  #include <linux/mcs_spinlock.h>

  /*
@@ -45,6 +49,13 @@
   */
  #define    MUTEX_SHOW_NO_WAITER(mutex)    
(atomic_read(&(mutex)->count) >= 0)

+/*
+ * Using a single mcs node per CPU is safe because mutex_lock() should 
not be
+ * called from interrupt context and we have preemption disabled over 
the mcs
+ * lock usage.
+ */
+static DEFINE_PER_CPU(struct mcs_spinlock, m_node);
+
  void
  __mutex_init(struct mutex *lock, const char *name, struct 
lock_class_key *key)
  {
@@ -166,6 +177,9 @@ static inline int mutex_can_spin_on_owner(struct 
mutex *lock)
      struct task_struct *owner;
      int retval = 1;

+    if (need_resched())
+        return 0;
+
      rcu_read_lock();
      owner = ACCESS_ONCE(lock->owner);
      if (owner)
@@ -370,6 +384,7 @@ __mutex_lock_common(struct mutex *lock, long state, 
unsigned int subclass,
      struct mutex_waiter waiter;
      unsigned long flags;
      int ret;
+    struct mcs_spinlock  *node;

      preempt_disable();
      mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
@@ -400,9 +415,13 @@ __mutex_lock_common(struct mutex *lock, long state, 
unsigned int subclass,
      if (!mutex_can_spin_on_owner(lock))
          goto slowpath;

+    node = this_cpu_ptr(&m_node);
+    if (node->locked < 0)
+        /* MCS node not available yet */
+        goto slowpath;
+
      for (;;) {
          struct task_struct *owner;
-        struct mcs_spinlock  node;

          if (use_ww_ctx && ww_ctx->acquired > 0) {
              struct ww_mutex *ww;
@@ -424,10 +443,15 @@ __mutex_lock_common(struct mutex *lock, long 
state, unsigned int subclass,
           * If there's an owner, wait for it to either
           * release the lock or go to sleep.
           */
-        mcs_spin_lock(&lock->mcs_lock, &node);
+        mcs_spin_lock(&lock->mcs_lock, node);
+        if (node->locked < 0)
+            /*
+             * need_resched() true, no unlock needed
+             */
+            goto slowpath;
          owner = ACCESS_ONCE(lock->owner);
          if (owner && !mutex_spin_on_owner(lock, owner)) {
-            mcs_spin_unlock(&lock->mcs_lock, &node);
+            mcs_spin_unlock(&lock->mcs_lock, node);
              goto slowpath;
          }

@@ -442,11 +466,11 @@ __mutex_lock_common(struct mutex *lock, long 
state, unsigned int subclass,
              }

              mutex_set_owner(lock);
-            mcs_spin_unlock(&lock->mcs_lock, &node);
+            mcs_spin_unlock(&lock->mcs_lock, node);
              preempt_enable();
              return 0;
          }
-        mcs_spin_unlock(&lock->mcs_lock, &node);
+        mcs_spin_unlock(&lock->mcs_lock, node);

          /*
           * When there's no owner, we might have preempted between the



