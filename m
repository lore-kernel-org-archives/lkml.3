Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3I3QIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:08:48 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:40951 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3I3QIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:08:47 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@linaro.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v2] rwsem: reduce spinlock contention in wakeup code path
Date: Mon, 30 Sep 2013 12:08:04 -0400
Message-Id: <1380557284-60784-1-git-send-email-Waiman.Long@hp.com>
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
those functions. There is no size increase in 64-bit systems and a
4 bytes size increase in 32-bit systems.

By checking if the wakeup flag is set, a thread can exit rwsem_wake()
immediately if another thread is pending to do the wakeup instead of
waiting to get the spinlock and find out that nothing need to be done.

The setting of the wakeup flag may not be visible on all processors in
some architectures. However, this won't affect program correctness. The
clearing of the wakeup flag before spin_unlock and other barrier-type
atomic instructions will ensure that it is visible to all processors.

With this patch, the performance improvement on jobs per minute
(JPM) of an sample run of the high_systime workload (at 1500 users)
was as follows:

HT	JPM w/o patch	JPM with patch	% Change
--	-------------	--------------	--------
off	   148265	   170896	 +15.3%
on	   140078	   159319	 +13.7%

The new perf profile (HT off) was as follows:

  2.96%   reaim  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
             |--0.94%-- rwsem_wake
  1.00%   reaim  [kernel.kallsyms]   [k] _raw_spin_lock_irq
             |--88.70%-- rwsem_down_write_failed

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/rwsem.h |    2 ++
 lib/rwsem.c           |   29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

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
index 19c5fa9..ded30f8 100644
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
@@ -75,6 +77,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 			 * will block as they will notice the queued writer.
 			 */
 			wake_up_process(waiter->task);
+		sem->wakeup = 0;	/* Wakeup done */
 		goto out;
 	}
 
@@ -83,6 +86,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 	 * so we can bail out early if a writer stole the lock.
 	 */
 	adjustment = 0;
+	sem->wakeup = 0;
 	if (wake_type != RWSEM_WAKE_READ_OWNED) {
 		adjustment = RWSEM_ACTIVE_READ_BIAS;
  try_reader_grant:
@@ -256,11 +260,36 @@ struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
+	if (sem->wakeup)
+		return sem;	/* Waking up in progress already */
+	/*
+	 * Optimistically set the wakeup flag to indicate that the current
+	 * thread is going to wakeup the sleeping waiters so that the
+	 * following threads don't need to wait for doing the wakeup call.
+	 * It is perfectly fine if another thread clears the flag. It just
+	 * leads to one more thread waiting to call __rwsem_do_wake().
+	 *
+	 * Writer lock stealing is not an issue for writers which are
+	 * unconditionally woken up. The woken writer is synchronized with
+	 * the waker via the spinlock. So the writer can't start doing
+	 * anything before the spinlock is released. For readers, the
+	 * situation is more complicated. The write lock stealer or the
+	 * woken readers are not synchronized with the waker. So they may
+	 * finish before the waker clears the wakeup flag. To prevent this
+	 * situation, the wakeup flag is cleared before the atomic update
+	 * of the count which also acts as a barrier.
+	 *
+	 * The spin_unlock() call at the end will force the just-cleared
+	 * wakeup flag to be visible to all the processors.
+	 */
+	sem->wakeup = 1;
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
+	else
+		sem->wakeup = 0;	/* Make sure wakeup flag is cleared */
 
 	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 
-- 
1.7.1

