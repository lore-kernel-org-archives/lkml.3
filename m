Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3CKVWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:22:01 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33540 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab3CKVPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:37 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 44/44] tty: Early-out tardy ldsem readers
Date: Mon, 11 Mar 2013 16:45:04 -0400
Message-Id: <1363034704-28036-45-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as there are no other waiters, read locks should early out.
Otherwise, a reader can end up sleeping while readers are already
running and there are no waiting writers.
This can happen in the following scenario:

  CPU 0                               |  CPU 1
                                      |
                                      | down_write()

... CPU 1 has the write lock for the semaphore.
    Meanwhile, 1 or more down_read(s) are attempted and fail;
    these are put on the wait list. Then ...

down_read()                           | up_write()
  local = atomic_update(+read_bias)   |
  local <= 0?                         |   local = atomic_update(-write_bias)
  if (true)                           |   local < 0?
     down_read_failed()               |   if (true)
                                      |      wake()
                                      |         grab wait_lock
        wait for wait_lock            |         wake all readers
                                      |         release wait_lock

... At this point, sem->count > 0 and the wait list is empty,
    but down_read_failed() will sleep the reader.

Instead, try to reverse the down_read() attempt, but if the count has
changed so that reversing fails, check if there are no other waiters
and early-out if not.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldsem.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index 84ea8a7..2f35661 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -191,23 +191,34 @@ static void ldsem_wake(struct ld_semaphore *sem)
  * wait for the read lock to be granted
  */
 static struct ld_semaphore __sched *
-down_read_failed(struct ld_semaphore *sem, long timeout)
+down_read_failed(struct ld_semaphore *sem, long count, long timeout)
 {
 	struct ldsem_waiter waiter;
 	long adjust = -LDSEM_ACTIVE_BIAS + LDSEM_WAIT_BIAS;
 
 	/* set up my own style of waitqueue */
 	raw_spin_lock_irq(&sem->wait_lock);
+
+	/* Try to reverse the lock attempt but if the count has changed
+	 * so that reversing fails, check if there are are no waiters,
+	 * and early-out if not */
+	do {
+		if (ldsem_cmpxchg(&count, count + adjust, sem))
+			break;
+		if (count > 0) {
+			raw_spin_unlock_irq(&sem->wait_lock);
+			return sem;
+		}
+	} while (1);
+
 	list_add_tail(&waiter.list, &sem->read_wait);
 	sem->wait_readers++;
 
 	waiter.task = current;
 	get_task_struct(current);
 
-	/* change the lock attempt to a wait --
-	 * if there are no active locks, wake the new lock owner(s)
-	 */
-	if ((ldsem_atomic_update(adjust, sem) & LDSEM_ACTIVE_MASK) == 0)
+	/* if there are no active locks, wake the new lock owner(s) */
+	if ((count & LDSEM_ACTIVE_MASK) == 0)
 		__ldsem_wake(sem);
 
 	raw_spin_unlock_irq(&sem->wait_lock);
@@ -304,11 +315,14 @@ down_write_failed(struct ld_semaphore *sem, long count, long timeout)
 static inline int __ldsem_down_read_nested(struct ld_semaphore *sem,
 					   int subclass, long timeout)
 {
+	long count;
+
 	lockdep_acquire_read(sem, subclass, 0, _RET_IP_);
 
-	if (ldsem_atomic_update(LDSEM_READ_BIAS, sem) <= 0) {
+	count = ldsem_atomic_update(LDSEM_READ_BIAS, sem);
+	if (count <= 0) {
 		lock_stat(sem, contended);
-		if (!down_read_failed(sem, timeout)) {
+		if (!down_read_failed(sem, count, timeout)) {
 			lockdep_release(sem, 1, _RET_IP_);
 			return 0;
 		}
-- 
1.8.1.2

