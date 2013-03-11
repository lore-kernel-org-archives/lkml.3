Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab3CKVYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:24:35 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33501 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab3CKVPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:33 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH v5 38/44] tty: Drop wake type optimization
Date: Mon, 11 Mar 2013 16:44:58 -0400
Message-Id: <1363034704-28036-39-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare to implement write lock stealing. Since a writer might
grab the lock from waiting readers, the LDSEM_WAKE_NO_CHECK
optimization is no longer safe. Instead, waiting readers must be
granted the lock in a similar fashion to the other lock grants;
ie., the sem count is optimistically updated and if the result
shows the lock was granted, the readers are woken. If the result
shows the lock was not granted, the grant is reversed.

Derived from Michel Lespinasse's write lock stealing work on rwsem.

Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldsem.c   | 56 +++++++++++++++++------------------------------
 include/linux/tty_ldisc.h |  1 +
 2 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index ddfbdfe..d2f091a 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -78,12 +78,6 @@ struct ldsem_waiter {
 	struct task_struct *task;
 };
 
-/* Wake types for __ldsem_wake().  Note: RWSEM_WAKE_NO_CHECK implies
- * the spinlock must have been kept held since the ldsem value was observed.
- */
-#define LDSEM_WAKE_NORMAL	0 /* All race conditions checked */
-#define LDSEM_WAKE_NO_CHECK	1 /* Reader wakeup can skip race checking  */
-
 static inline long ldsem_atomic_update(long delta, struct ld_semaphore *sem)
 {
 	return atomic_long_add_return(delta, (atomic_long_t *)&sem->count);
@@ -104,44 +98,32 @@ void __init_ldsem(struct ld_semaphore *sem, const char *name,
 	lockdep_init_map(&sem->dep_map, name, key, 0);
 #endif
 	sem->count = LDSEM_UNLOCKED;
+	sem->wait_readers = 0;
 	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->read_wait);
 	INIT_LIST_HEAD(&sem->write_wait);
 }
 
-static void __ldsem_wake_readers(struct ld_semaphore *sem, int wake_type)
+static void __ldsem_wake_readers(struct ld_semaphore *sem)
 {
 	struct ldsem_waiter *waiter, *next;
 	struct task_struct *tsk;
 	long adjust;
 
-	/* If we come here from up_xxxx(), another thread might have reached
-	 * down_failed() before we acquired the spinlock and
-	 * woken up a waiter, making it now active.  We prefer to check for
-	 * this first in order to not spend too much time with the spinlock
-	 * held if we're not going to be able to wake up readers in the end.
-	 *
-	 * Note that we do not need to update the ldsem count: any writer
-	 * trying to acquire ldsem will run down_write_failed() due
-	 * to the waiting threads and block trying to acquire the spinlock.
-	 *
-	 * We use a dummy atomic update in order to acquire the cache line
-	 * exclusively since we expect to succeed and run the final ldsem
-	 * count adjustment pretty soon.
-	 */
-	if (wake_type == LDSEM_WAKE_NORMAL &&
-	    (ldsem_atomic_update(0, sem) & LDSEM_ACTIVE_MASK) != 0)
-		/* Someone grabbed the sem for write already */
-		return;
-
-	/* Grant read locks to all readers on the read wait list.
+	/* Try to grant read locks to all readers on the read wait list.
 	 * Note the 'active part' of the count is incremented by
 	 * the number of readers before waking any processes up.
 	 */
-	adjust = 0;
-	list_for_each_entry(waiter, &sem->read_wait, list)
-		adjust += LDSEM_ACTIVE_BIAS - LDSEM_WAIT_BIAS;
-	ldsem_atomic_update(adjust, sem);
+	adjust = sem->wait_readers * (LDSEM_ACTIVE_BIAS - LDSEM_WAIT_BIAS);
+	do {
+		long count;
+		count = ldsem_atomic_update(adjust, sem);
+		if (count > 0)
+			break;
+		count = ldsem_atomic_update(-adjust, sem);
+		if (count + adjust < 0)
+			return;
+	} while (1);
 
 	list_for_each_entry_safe(waiter, next, &sem->read_wait, list) {
 		tsk = waiter->task;
@@ -151,6 +133,7 @@ static void __ldsem_wake_readers(struct ld_semaphore *sem, int wake_type)
 		put_task_struct(tsk);
 	}
 	INIT_LIST_HEAD(&sem->read_wait);
+	sem->wait_readers = 0;
 }
 
 static void __ldsem_wake_writer(struct ld_semaphore *sem)
@@ -199,12 +182,12 @@ static void __ldsem_wake_writer(struct ld_semaphore *sem)
  * - the spinlock must be held by the caller
  * - woken process blocks are discarded from the list after having task zeroed
  */
-static void __ldsem_wake(struct ld_semaphore *sem, int wake_type)
+static void __ldsem_wake(struct ld_semaphore *sem)
 {
 	if (!list_empty(&sem->write_wait))
 		__ldsem_wake_writer(sem);
 	else if (!list_empty(&sem->read_wait))
-		__ldsem_wake_readers(sem, wake_type);
+		__ldsem_wake_readers(sem);
 }
 
 static void ldsem_wake(struct ld_semaphore *sem)
@@ -212,7 +195,7 @@ static void ldsem_wake(struct ld_semaphore *sem)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
-	__ldsem_wake(sem, LDSEM_WAKE_NORMAL);
+	__ldsem_wake(sem);
 	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 }
 
@@ -228,6 +211,7 @@ down_read_failed(struct ld_semaphore *sem, long timeout)
 	/* set up my own style of waitqueue */
 	raw_spin_lock_irq(&sem->wait_lock);
 	list_add_tail(&waiter.list, &sem->read_wait);
+	sem->wait_readers++;
 
 	waiter.task = current;
 	get_task_struct(current);
@@ -236,7 +220,7 @@ down_read_failed(struct ld_semaphore *sem, long timeout)
 	 * if there are no active locks, wake the new lock owner(s)
 	 */
 	if ((ldsem_atomic_update(adjust, sem) & LDSEM_ACTIVE_MASK) == 0)
-		__ldsem_wake(sem, LDSEM_WAKE_NO_CHECK);
+		__ldsem_wake(sem);
 
 	raw_spin_unlock_irq(&sem->wait_lock);
 
@@ -291,7 +275,7 @@ down_write_failed(struct ld_semaphore *sem, long timeout)
 	 * if there are no active locks, wake the new lock owner(s)
 	 */
 	if ((ldsem_atomic_update(adjust, sem) & LDSEM_ACTIVE_MASK) == 0)
-		__ldsem_wake(sem, LDSEM_WAKE_NO_CHECK);
+		__ldsem_wake(sem);
 
 	raw_spin_unlock_irq(&sem->wait_lock);
 
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 6ee666f..272075e 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -117,6 +117,7 @@
 struct ld_semaphore {
 	long			count;
 	raw_spinlock_t		wait_lock;
+	unsigned int		wait_readers;
 	struct list_head	read_wait;
 	struct list_head	write_wait;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-- 
1.8.1.2

