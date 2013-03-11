Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3CKVRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:17:47 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33606 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab3CKVPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:46 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 28/44] tty: Remove ldsem recursion support
Date: Mon, 11 Mar 2013 16:44:48 -0400
Message-Id: <1363034704-28036-29-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read lock recursion is no longer required for ldisc references;
remove mechanism.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldsem.c   | 83 +++++------------------------------------------
 include/linux/tty_ldisc.h |  2 --
 2 files changed, 8 insertions(+), 77 deletions(-)

diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index c162295..a60d7e3 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -3,28 +3,14 @@
  *
  * The ldisc semaphore is semantically a rw_semaphore but which enforces
  * an alternate policy, namely:
- *   1) Recursive read locking is allowed
- *   2) Supports lock wait timeouts
- *   3) Write waiter has priority, even if lock is already read owned, except:
- *   4) Write waiter does not prevent recursive locking
- *   5) Downgrading is not supported (because of #3 & #4 above)
+ *   1) Supports lock wait timeouts
+ *   2) Write waiter has priority
+ *   3) Downgrading is not supported
  *
  * Implementation notes:
  *   1) Upper half of semaphore count is a wait count (differs from rwsem
  *	in that rwsem normalizes the upper half to the wait bias)
  *   2) Lacks overflow checking
- *   3) Read recursion is tracked with a bitmap indexed by hashed 'current'
- *	This approach results in some false positives; ie, a non-recursive
- *	read lock may be granted while a write lock is waited.
- *	However, this approach does not produce false-negatives
- *	(ie. not granting a read lock to a recursive attempt) which might
- *	deadlock.
- *	Testing the bitmap need not be atomic wrt. setting the bitmap
- *	(as the 'current' thread cannot contend with itself); however,
- *	since the bitmap is cleared when write lock is granted.
- *	Note: increasing the bitmap size reduces the probability of false
- *	positives, and thus the probability of granting a non-recursive
- *	read lock with writer(s) waiting.
  *
  * The generic counting was copied and modified from include/asm-generic/rwsem.h
  * by Paul Mackerras <paulus@samba.org>.
@@ -53,12 +39,12 @@
 # ifdef CONFIG_PROVE_LOCKING
 #  define lockdep_acquire(l, s, t, i)		__acq(l, s, t, 0, 2, NULL, i)
 #  define lockdep_acquire_nest(l, s, t, n, i)	__acq(l, s, t, 0, 2, n, i)
-#  define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 2, 2, NULL, i)
+#  define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 1, 2, NULL, i)
 #  define lockdep_release(l, n, i)		__rel(l, n, i)
 # else
 #  define lockdep_acquire(l, s, t, i)		__acq(l, s, t, 0, 1, NULL, i)
 #  define lockdep_acquire_nest(l, s, t, n, i)	__acq(l, s, t, 0, 1, n, i)
-#  define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 2, 1, NULL, i)
+#  define lockdep_acquire_read(l, s, t, i)	__acq(l, s, t, 1, 1, NULL, i)
 #  define lockdep_release(l, n, i)		__rel(l, n, i)
 # endif
 #else
@@ -107,26 +93,6 @@ static inline long ldsem_atomic_update(long delta, struct ld_semaphore *sem)
 }
 
 
-static inline unsigned long __hash_current(void)
-{
-	return (unsigned long)current % TASK_MAP_BITS;
-}
-
-static inline void ldsem_clear_task_map(struct ld_semaphore *sem)
-{
-	bitmap_zero(sem->task_map, TASK_MAP_BITS);
-}
-
-static inline void ldsem_update_task_map(struct ld_semaphore *sem)
-{
-	__set_bit(__hash_current(), sem->task_map);
-}
-
-static inline int ldsem_lock_recursion(struct ld_semaphore *sem)
-{
-	return test_bit(__hash_current(), sem->task_map);
-}
-
 /*
  * Initialize an ldsem:
  */
@@ -144,7 +110,6 @@ void __init_ldsem(struct ld_semaphore *sem, const char *name,
 	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->read_wait);
 	INIT_LIST_HEAD(&sem->write_wait);
-	ldsem_clear_task_map(sem);
 }
 
 static void __ldsem_wake_readers(struct ld_semaphore *sem, int wake_type)
@@ -217,9 +182,6 @@ static void __ldsem_wake_writer(struct ld_semaphore *sem)
 			return;
 	} while (1);
 
-	/* reset read lock recursion map */
-	ldsem_clear_task_map(sem);
-
 	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
 	 * It is an allocated on the waiter's stack and may become invalid at
 	 * any time after that point (due to a wakeup from another source).
@@ -268,17 +230,9 @@ down_failed(struct ld_semaphore *sem, unsigned flags, long adjust, long timeout)
 	/* set up my own style of waitqueue */
 	raw_spin_lock_irq(&sem->wait_lock);
 
-	if (flags & LDSEM_READ_WAIT) {
-		/* Handle recursive read locking -- if the reader already has
-		 * a read lock then allow lock acquire without waiting
-		 * but also without waking other waiters
-		 */
-		if (ldsem_lock_recursion(sem)) {
-			raw_spin_unlock_irq(&sem->wait_lock);
-			return sem;
-		}
+	if (flags & LDSEM_READ_WAIT)
 		list_add_tail(&waiter.list, &sem->read_wait);
-	} else
+	else
 		list_add_tail(&waiter.list, &sem->write_wait);
 
 	waiter.task = current;
@@ -358,9 +312,6 @@ static inline int __ldsem_down_read_nested(struct ld_semaphore *sem,
 		}
 	}
 	lock_stat(sem, acquired);
-
-	/* used for read lock recursion test */
-	ldsem_update_task_map(sem);
 	return 1;
 }
 
@@ -371,17 +322,9 @@ static inline int __ldsem_down_write_nested(struct ld_semaphore *sem,
 
 	lockdep_acquire(sem, subclass, 0, _RET_IP_);
 
-	raw_spin_lock_irq(&sem->wait_lock);
-
 	count = atomic_long_add_return(LDSEM_WRITE_BIAS,
 				       (atomic_long_t *)&sem->count);
-	if (count == LDSEM_WRITE_BIAS) {
-		/* reset read lock recursion map */
-		ldsem_clear_task_map(sem);
-		raw_spin_unlock_irq(&sem->wait_lock);
-	} else {
-		raw_spin_unlock_irq(&sem->wait_lock);
-
+	if (count != LDSEM_WRITE_BIAS) {
 		lock_stat(sem, contended);
 		if (!down_write_failed(sem, timeout)) {
 			lockdep_release(sem, 1, _RET_IP_);
@@ -414,8 +357,6 @@ int ldsem_down_read_trylock(struct ld_semaphore *sem)
 						 count + LDSEM_READ_BIAS)) {
 			lockdep_acquire_read(sem, 0, 1, _RET_IP_);
 			lock_stat(sem, acquired);
-
-			ldsem_update_task_map(sem);
 			return 1;
 		}
 	}
@@ -438,21 +379,13 @@ int ldsem_down_write_trylock(struct ld_semaphore *sem)
 {
 	long count;
 
-	raw_spin_lock_irq(&sem->wait_lock);
-
 	count = atomic_long_cmpxchg(&sem->count, LDSEM_UNLOCKED,
 				    LDSEM_WRITE_BIAS);
 	if (count == LDSEM_UNLOCKED) {
-		/* reset read lock recursion map */
-		ldsem_clear_task_map(sem);
-
-		raw_spin_unlock_irq(&sem->wait_lock);
-
 		lockdep_acquire(sem, 0, 1, _RET_IP_);
 		lock_stat(sem, acquired);
 		return 1;
 	}
-	raw_spin_unlock_irq(&sem->wait_lock);
 	return 0;
 }
 
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index bbefe71..bfbe41a 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -122,8 +122,6 @@ struct ld_semaphore {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
-#define TASK_MAP_BITS		157
-	DECLARE_BITMAP(task_map, TASK_MAP_BITS);
 };
 
 extern void __init_ldsem(struct ld_semaphore *sem, const char *name,
-- 
1.8.1.2

