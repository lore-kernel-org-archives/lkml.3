Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3I0TBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:01:22 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:32342 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab3I0TBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:01:20 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH] rwsem: reduce spinlock contention in wakeup code path
Date: Fri, 27 Sep 2013 15:00:24 -0400
Message-Id: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the 3.12-rc2 kernel, there is sizable spinlock contention on
the rwsem wakeup code path when running AIM7's high_systime workload
on a 8-socket 80-core DL980 (HT off) as reported by perf:

  7.64%   reaim  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
             |--41.77%-- rwsem_wake
  1.61%   reaim  [kernel.kallsyms]   [k] _raw_spin_lock_irq
             |--92.37%-- rwsem_down_write_failed

That was 4.7% of recorded CPU cycles.

On a large NUMA machine, it is entirely possible that a fairly large
number of threads are queuing up in the ticket spinlock queue to do
the wakeup operation. In fact, only one will be needed.  This patch
tries to reduce spinlock contention by doing just that.

A new wakeup field is added to the rwsem structure. This field is
set on entry to rwsem_wake() and __rwsem_do_wake() to mark that a
thread is pending to do the wakeup call. It is cleared on exit from
those functions.

By checking if the wakeup flag is set, a thread can exit rwsem_wake()
immediately if another thread is pending to do the wakeup instead of
waiting to get the spinlock and find out that nothing need to be done.

The setting of the wakeup flag may not be visible on all processors in
some architectures. However, this won't affect program correctness. The
clearing of the wakeup flag before spin_unlock will ensure that it is
visible to all processors.

With this patch, the performance improvement on jobs per minute (JPM)
of the high_systime workload (at 1500 users) was as follows:

HT	JPM w/o patch	JPM with patch	% Change
--	-------------	--------------	--------
off	   128466	   150000	 +16.8%
on	   121606	   146778	 +20.7%

The new perf profile (HT off) was as follows:

  2.96%   reaim  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
             |--0.94%-- rwsem_wake
  1.00%   reaim  [kernel.kallsyms]   [k] _raw_spin_lock_irq
             |--88.70%-- rwsem_down_write_failed

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/rwsem.h |    2 ++
 lib/rwsem.c           |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 0616ffe..e25792e 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -25,6 +25,7 @@ struct rw_semaphore;
 struct rw_semaphore {
 	long			count;
 	raw_spinlock_t		wait_lock;
+	int			wakeup;	/* Waking-up in progress flag */
 	struct list_head	wait_list;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
@@ -58,6 +59,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 #define __RWSEM_INITIALIZER(name)			\
 	{ RWSEM_UNLOCKED_VALUE,				\
 	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
+	  0,						\
 	  LIST_HEAD_INIT((name).wait_list)		\
 	  __RWSEM_DEP_MAP_INIT(name) }
 
diff --git a/lib/rwsem.c b/lib/rwsem.c
index 19c5fa9..39290a5 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -25,6 +25,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	lockdep_init_map(&sem->dep_map, name, key, 0);
 #endif
 	sem->count = RWSEM_UNLOCKED_VALUE;
+	sem->wakeup = 0;
 	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
 }
@@ -66,6 +67,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 	struct list_head *next;
 	long oldcount, woken, loop, adjustment;
 
+	sem->wakeup = 1;	/* Waking up in progress */
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
 		if (wake_type == RWSEM_WAKE_ANY)
@@ -137,6 +139,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 	next->prev = &sem->wait_list;
 
  out:
+	sem->wakeup = 0;
 	return sem;
 }
 
@@ -256,11 +259,27 @@ struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
+	if (sem->wakeup)
+		return sem;	/* Waking up in progress already */
+	/*
+	 * Optimistically set the wakeup flag to indicate that the current
+	 * flag is going to wakeup the sleeping waiters so that the
+	 * following threads don't need to wait for doing the wakeup.
+	 * It is perfectly fine if another thread resets the flag. It just
+	 * leads to another thread waiting to call __rwsem_do_wake().
+	 */
+	sem->wakeup = 1;
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
+	else
+		sem->wakeup = 0;	/* Make sure wakeup flag is reset */
+	/*
+	 * The spin_unlock() call will force the nulled wakeup flag to
+	 * be visible to all the processors.
+	 */
 
 	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 
-- 
1.7.1

