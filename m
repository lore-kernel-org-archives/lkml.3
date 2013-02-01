Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964787Ab3BAK61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:58:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:56541 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161013Ab3BAK6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:58:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="251349742"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        David Howells <dhowells@redhat.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH v2] rwsem-spinlock: let rwsem write lock stealable
Date: Fri,  1 Feb 2013 18:59:16 +0800
Message-Id: <1359716356-23865-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We(Linux Kernel Performance project) found a regression introduced by
commit 5a50508, which just convert all mutex lock to rwsem write lock.
The semantics is same, but the results is quite huge in some cases.
After investigation, we found the root cause: mutex support lock
stealing. Here is the link for the detailed regression report:
    https://lkml.org/lkml/2013/1/29/84

Ingo suggests to add write lock stealing to rwsem as well:
    "I think we should allow lock-steal between rwsem writers - that
     will not hurt fairness as most rwsem fairness concerns relate to
     reader vs. writer fairness"

And here is the rwsem-spinlock version.

With this patch, we got a double performance increase in one test box
with following aim7 workfile:
    FILESIZE: 1M
    POOLSIZE: 10M
    10 fork_test

some /usr/bin/time output w/o patch      some /usr/bin/time_output with patch
----------------------------------------------------------------------------
Percent of CPU this job got: 369%        Percent of CPU this job got: 537%
Voluntary context switches: 640595016    Voluntary context switches: 157915561
----------------------------------------------------------------------------
You will see we got a 45% increase of CPU usage and saves about 3/4
voluntary context switches.

Here is the .nr_running filed for all CPUs from /proc/sched_debug.

output w/o this patch:
----------------------
cpu 00:   0   0   ...   0   0   0   0   0   0   0   1   0   1 .... 0   0
cpu 01:   0   0   ...   1   0   0   0   0   0   1   1   0   1 .... 0   0
cpu 02:   0   0   ...   1   1   0   0   0   1   0   0   1   0 .... 1   1
cpu 03:   0   0   ...   0   1   0   0   0   1   1   0   1   1 .... 0   0
cpu 04:   0   1   ...   0   0   2   1   1   2   1   0   1   0 .... 1   0
cpu 05:   0   1   ...   0   0   2   1   1   2   1   1   1   1 .... 0   0
cpu 06:   0   0   ...   2   0   0   1   0   0   1   0   0   0 .... 0   0
cpu 07:   0   0   ...   2   0   0   0   1   0   1   1   0   0 .... 1   0
cpu 08:   0   0   ...   1   0   0   0   1   0   0   1   0   0 .... 0   1
cpu 09:   0   0   ...   1   0   0   0   1   0   0   1   0   0 .... 0   1
cpu 10:   0   0   ...   0   0   0   2   0   0   1   0   1   1 .... 1   2
cpu 11:   0   0   ...   0   0   0   2   2   0   1   0   1   0 .... 1   2
cpu 12:   0   0   ...   2   0   0   0   1   1   3   1   1   1 .... 1   0
cpu 13:   0   0   ...   2   0   0   0   1   1   3   1   1   0 .... 1   1
cpu 14:   0   0   ...   0   0   0   2   0   0   1   1   0   0 .... 1   0
cpu 15:   0   0   ...   1   0   0   2   0   0   1   1   0   0 .... 0   0

output with this patch:
-----------------------
cpu 00:   0   0   ...   1   1   2   1   1   1   2   1   1   1 .... 1   3
cpu 01:   0   0   ...   1   1   1   1   1   1   2   1   1   1 .... 1   3
cpu 02:   0   0   ...   2   2   3   2   0   2   1   2   1   1 .... 1   1
cpu 03:   0   0   ...   2   2   3   2   1   2   1   2   1   1 .... 1   1
cpu 04:   0   1   ...   2   0   0   1   0   1   3   1   1   1 .... 1   1
cpu 05:   0   1   ...   2   0   1   1   0   1   2   1   1   1 .... 1   1
cpu 06:   0   0   ...   2   1   1   2   0   1   2   1   1   1 .... 2   1
cpu 07:   0   0   ...   2   1   1   2   0   1   2   1   1   1 .... 2   1
cpu 08:   0   0   ...   1   1   1   1   1   1   1   1   1   1 .... 0   0
cpu 09:   0   0   ...   1   1   1   1   1   1   1   1   1   1 .... 0   0
cpu 10:   0   0   ...   1   1   1   0   0   1   1   1   1   1 .... 0   0
cpu 11:   0   0   ...   1   1   1   0   0   1   1   1   1   2 .... 1   0
cpu 12:   0   0   ...   1   1   1   0   1   1   0   0   0   1 .... 2   1
cpu 13:   0   0   ...   1   1   1   0   1   1   1   0   1   2 .... 2   0
cpu 14:   0   0   ...   2   0   0   0   0   1   1   1   1   1 .... 2   2
cpu 15:   0   0   ...   2   0   0   1   0   1   1   1   1   1 .... 2   2
------------------------------------------------------------------------
Where you can see that CPU is much busier with this patch.

v2: make it stealable at __down_write_trylock as well, pointed by Michel

Reported-by: LKP project <lkp@linux.intel.com>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 lib/rwsem-spinlock.c |   69 +++++++++++++++++--------------------------------
 1 files changed, 24 insertions(+), 45 deletions(-)

diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index 7e0d6a5..7542afb 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -73,20 +73,13 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 		goto dont_wake_writers;
 	}
 
-	/* if we are allowed to wake writers try to grant a single write lock
-	 * if there's a writer at the front of the queue
-	 * - we leave the 'waiting count' incremented to signify potential
-	 *   contention
+	/*
+	 * as we support write lock stealing, we can't set sem->activity
+	 * to -1 here to indicate we get the lock. Instead, we wake it up
+	 * to let it go get it again.
 	 */
 	if (waiter->flags & RWSEM_WAITING_FOR_WRITE) {
-		sem->activity = -1;
-		list_del(&waiter->list);
-		tsk = waiter->task;
-		/* Don't touch waiter after ->task has been NULLed */
-		smp_mb();
-		waiter->task = NULL;
-		wake_up_process(tsk);
-		put_task_struct(tsk);
+		wake_up_process(waiter->task);
 		goto out;
 	}
 
@@ -121,18 +114,10 @@ static inline struct rw_semaphore *
 __rwsem_wake_one_writer(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter *waiter;
-	struct task_struct *tsk;
-
-	sem->activity = -1;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	list_del(&waiter->list);
+	wake_up_process(waiter->task);
 
-	tsk = waiter->task;
-	smp_mb();
-	waiter->task = NULL;
-	wake_up_process(tsk);
-	put_task_struct(tsk);
 	return sem;
 }
 
@@ -204,7 +189,6 @@ int __down_read_trylock(struct rw_semaphore *sem)
 
 /*
  * get a write lock on the semaphore
- * - we increment the waiting count anyway to indicate an exclusive lock
  */
 void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
@@ -214,37 +198,32 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
-	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
-		/* granted */
-		sem->activity = -1;
-		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-		goto out;
-	}
-
-	tsk = current;
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-
 	/* set up my own style of waitqueue */
+	tsk = current;
 	waiter.task = tsk;
 	waiter.flags = RWSEM_WAITING_FOR_WRITE;
-	get_task_struct(tsk);
-
 	list_add_tail(&waiter.list, &sem->wait_list);
 
-	/* we don't need to touch the semaphore struct anymore */
-	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
-
-	/* wait to be given the lock */
+	/* wait for someone to release the lock */
 	for (;;) {
-		if (!waiter.task)
+		/*
+		 * That is the key to support write lock stealing: allows the
+		 * task already on CPU to get the lock soon rather than put
+		 * itself into sleep and waiting for system woke it or someone
+		 * else in the head of the wait list up.
+		 */
+		if (sem->activity == 0)
 			break;
-		schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
+		schedule();
+		raw_spin_lock_irqsave(&sem->wait_lock, flags);
 	}
+	/* got the lock */
+	sem->activity = -1;
+	list_del(&waiter.list);
 
-	tsk->state = TASK_RUNNING;
- out:
-	;
+	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 }
 
 void __sched __down_write(struct rw_semaphore *sem)
@@ -262,8 +241,8 @@ int __down_write_trylock(struct rw_semaphore *sem)
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
-	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
-		/* granted */
+	if (sem->activity == 0) {
+		/* got the lock */
 		sem->activity = -1;
 		ret = 1;
 	}
-- 
1.7.7.6

