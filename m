Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3BRQ0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:26:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34009 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab3BRQ0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:26:21 -0500
Date: Mon, 18 Feb 2013 08:25:02 -0800
From: tip-bot for Yuanhan Liu <tipbot@zytor.com>
Message-ID: <tip-5dae63c442131f1b0a66abd43fdc861031f13ca6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@kernel.org, arjan@linux.intel.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, alex.shi@intel.com,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de, walken@google.com,
        lkp@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, arjan@linux.intel.com, alex.shi@intel.com,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de, walken@google.com,
        lkp@linux.intel.com
In-Reply-To: <1359716356-23865-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1359716356-23865-1-git-send-email-yuanhan.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] rwsem-spinlock:
  Implement writer lock-stealing for better scalability
Git-Commit-ID: 5dae63c442131f1b0a66abd43fdc861031f13ca6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Feb 2013 08:25:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dae63c442131f1b0a66abd43fdc861031f13ca6
Gitweb:     http://git.kernel.org/tip/5dae63c442131f1b0a66abd43fdc861031f13ca6
Author:     Yuanhan Liu <yuanhan.liu@linux.intel.com>
AuthorDate: Fri, 1 Feb 2013 18:59:16 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Feb 2013 10:10:21 +0100

rwsem-spinlock: Implement writer lock-stealing for better scalability

We (Linux Kernel Performance project) found a regression
introduced by commit:

  5a505085f043 mm/rmap: Convert the struct anon_vma::mutex to an rwsem

which converted all anon_vma::mutex locks rwsem write locks.

The semantics are the same, but the behavioral difference is
quite huge in some cases. After investigating it we found the
root cause: mutexes support lock stealing while rwsems don't.

Here is the link for the detailed regression report:

  https://lkml.org/lkml/2013/1/29/84

Ingo suggested adding write lock stealing to rwsems:

    "I think we should allow lock-steal between rwsem writers - that
     will not hurt fairness as most rwsem fairness concerns relate to
     reader vs. writer fairness"

And here is the rwsem-spinlock version.

With this patch, we got a double performance increase in one
test box with following aim7 workfile:

    FILESIZE: 1M
    POOLSIZE: 10M
    10 fork_test

 /usr/bin/time output w/o patch                       /usr/bin/time_output with patch
 -- Percent of CPU this job got: 369%                 Percent of CPU this job got: 537%
 Voluntary context switches: 640595016                Voluntary context switches: 157915561

We got a 45% increase in CPU usage and saved about 3/4 voluntary context switches.

Reported-by: LKP project <lkp@linux.intel.com>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Alex Shi <alex.shi@intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: paul.gortmaker@windriver.com
Link: http://lkml.kernel.org/r/1359716356-23865-1-git-send-email-yuanhan.liu@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 lib/rwsem-spinlock.c | 69 ++++++++++++++++++----------------------------------
 1 file changed, 24 insertions(+), 45 deletions(-)

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
