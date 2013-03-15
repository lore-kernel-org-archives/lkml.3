Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3COK5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:57:11 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46275 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab3COKyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:54:38 -0400
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/13] rwsem: move rwsem_down_failed_common code into rwsem_down_{read,write}_failed
Date: Fri, 15 Mar 2013 03:54:19 -0700
Message-Id: <1363344869-15732-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363344869-15732-1-git-send-email-walken@google.com>
References: <1363344869-15732-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the rwsem_down_failed_common function and replace it with two
identical copies of its code in rwsem_down_{read,write}_failed.

This is because we want to make different optimizations in
rwsem_down_{read,write}_failed; we are adding this pure-duplication
step as a separate commit in order to make it easier to check the
following steps.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 lib/rwsem.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 57 insertions(+), 15 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 40636454cf3c..fb658af1c12c 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -178,12 +178,12 @@ try_again_write:
 }
 
 /*
- * wait for a lock to be granted
+ * wait for the read lock to be granted
  */
-static struct rw_semaphore __sched *
-rwsem_down_failed_common(struct rw_semaphore *sem,
-			 enum rwsem_waiter_type type, signed long adjustment)
+struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
+	enum rwsem_waiter_type type = RWSEM_WAITING_FOR_READ;
+	signed long adjustment = -RWSEM_ACTIVE_READ_BIAS;
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
 	signed long count;
@@ -238,21 +238,63 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 }
 
 /*
- * wait for the read lock to be granted
- */
-struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
-{
-	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_READ,
-					-RWSEM_ACTIVE_READ_BIAS);
-}
-
-/*
  * wait for the write lock to be granted
  */
 struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
-	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_WRITE,
-					-RWSEM_ACTIVE_WRITE_BIAS);
+	enum rwsem_waiter_type type = RWSEM_WAITING_FOR_WRITE;
+	signed long adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
+	struct rwsem_waiter waiter;
+	struct task_struct *tsk = current;
+	signed long count;
+
+	/* set up my own style of waitqueue */
+	waiter.task = tsk;
+	waiter.type = type;
+	get_task_struct(tsk);
+
+	raw_spin_lock_irq(&sem->wait_lock);
+	if (list_empty(&sem->wait_list))
+		adjustment += RWSEM_WAITING_BIAS;
+	list_add_tail(&waiter.list, &sem->wait_list);
+
+	/* we're now waiting on the lock, but no longer actively locking */
+	count = rwsem_atomic_update(adjustment, sem);
+
+	/* If there are no active locks, wake the front queued process(es) up.
+	 *
+	 * Alternatively, if we're called from a failed down_write(), there
+	 * were already threads queued before us and there are no active
+	 * writers, the lock must be read owned; so we try to wake any read
+	 * locks that were queued ahead of us. */
+	if (count == RWSEM_WAITING_BIAS)
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_NO_ACTIVE);
+	else if (count > RWSEM_WAITING_BIAS &&
+		 adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
+
+	raw_spin_unlock_irq(&sem->wait_lock);
+
+	/* wait to be given the lock */
+	while (true) {
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		if (!waiter.task)
+			break;
+
+		raw_spin_lock_irq(&sem->wait_lock);
+		/* Try to get the writer sem, may steal from the head writer: */
+		if (type == RWSEM_WAITING_FOR_WRITE)
+			if (try_get_writer_sem(sem, &waiter)) {
+				raw_spin_unlock_irq(&sem->wait_lock);
+				return sem;
+			}
+		raw_spin_unlock_irq(&sem->wait_lock);
+		schedule();
+	}
+
+	tsk->state = TASK_RUNNING;
+
+	return sem;
 }
 
 /*
-- 
1.8.1.3
