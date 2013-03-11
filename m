Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab3CKVPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:15:46 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33588 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab3CKVPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:43 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH v5 43/44] tty: Early-out ldsem write lock stealing
Date: Mon, 11 Mar 2013 16:45:03 -0400
Message-Id: <1363034704-28036-44-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If, when attempting to reverse the count bump, the writer discovers
the lock is unclaimed, try to immediately steal the lock.

Derived from Michel Lespinasse's write lock stealing work on
rwsem.

Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldsem.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index e750ac3..84ea8a7 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -247,7 +247,7 @@ down_read_failed(struct ld_semaphore *sem, long timeout)
  * wait for the write lock to be granted
  */
 static struct ld_semaphore __sched *
-down_write_failed(struct ld_semaphore *sem, long timeout)
+down_write_failed(struct ld_semaphore *sem, long count, long timeout)
 {
 	struct ldsem_waiter waiter;
 	long adjust = -LDSEM_ACTIVE_BIAS;
@@ -255,17 +255,24 @@ down_write_failed(struct ld_semaphore *sem, long timeout)
 
 	/* set up my own style of waitqueue */
 	raw_spin_lock_irq(&sem->wait_lock);
+
+	/* Try to reverse the lock attempt but if the count has changed
+	 * so that reversing fails, check if the lock is now owned,
+	 * and early-out if so */
+	do {
+		if (ldsem_cmpxchg(&count, count + adjust, sem))
+			break;
+		if ((count & LDSEM_ACTIVE_MASK) == LDSEM_ACTIVE_BIAS) {
+			raw_spin_unlock_irq(&sem->wait_lock);
+			return sem;
+		}
+	} while (1);
+
 	list_add_tail(&waiter.list, &sem->write_wait);
 
 	waiter.task = current;
 	get_task_struct(current);
 
-	/* change the lock attempt to a wait --
-	 * if there are no active locks, wake the new lock owner(s)
-	 */
-	if ((ldsem_atomic_update(adjust, sem) & LDSEM_ACTIVE_MASK) == 0)
-		__ldsem_wake(sem);
-
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	for (;;) {
 		if (!timeout)
@@ -320,7 +327,7 @@ static inline int __ldsem_down_write_nested(struct ld_semaphore *sem,
 	count = ldsem_atomic_update(LDSEM_WRITE_BIAS, sem);
 	if ((count & LDSEM_ACTIVE_MASK) != LDSEM_ACTIVE_BIAS) {
 		lock_stat(sem, contended);
-		if (!down_write_failed(sem, timeout)) {
+		if (!down_write_failed(sem, count, timeout)) {
 			lockdep_release(sem, 1, _RET_IP_);
 			return 0;
 		}
-- 
1.8.1.2

