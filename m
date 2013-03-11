Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab3CKVY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:24:59 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33488 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab3CKVPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:32 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH v5 36/44] tty: Inline ldsem down_failed() into down_{read,write}_failed()
Date: Mon, 11 Mar 2013 16:44:56 -0400
Message-Id: <1363034704-28036-37-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the read and write lock paths to simplify handling of
initial acquire failure.

Derived from Michel Lespinasse's write lock stealing work on rwsem.

Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldsem.c | 70 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index a60d7e3..d849fb85 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -220,12 +220,14 @@ static void ldsem_wake(struct ld_semaphore *sem)
 }
 
 /*
- * wait for a lock to be granted
+ * wait for the read lock to be granted
  */
 static struct ld_semaphore __sched *
-down_failed(struct ld_semaphore *sem, unsigned flags, long adjust, long timeout)
+down_read_failed(struct ld_semaphore *sem, long timeout)
 {
 	struct ldsem_waiter waiter;
+	long flags = LDSEM_READ_WAIT;
+	long adjust = -LDSEM_ACTIVE_BIAS + LDSEM_WAIT_BIAS;
 
 	/* set up my own style of waitqueue */
 	raw_spin_lock_irq(&sem->wait_lock);
@@ -279,22 +281,64 @@ down_failed(struct ld_semaphore *sem, unsigned flags, long adjust, long timeout)
 }
 
 /*
- * wait for the read lock to be granted
- */
-static struct ld_semaphore __sched *
-down_read_failed(struct ld_semaphore *sem, long timeout)
-{
-	return down_failed(sem, LDSEM_READ_WAIT,
-			   -LDSEM_ACTIVE_BIAS + LDSEM_WAIT_BIAS, timeout);
-}
-
-/*
  * wait for the write lock to be granted
  */
 static struct ld_semaphore __sched *
 down_write_failed(struct ld_semaphore *sem, long timeout)
 {
-	return down_failed(sem, LDSEM_WRITE_WAIT, -LDSEM_ACTIVE_BIAS, timeout);
+	struct ldsem_waiter waiter;
+	long flags = LDSEM_WRITE_WAIT;
+	long adjust = -LDSEM_ACTIVE_BIAS;
+
+	/* set up my own style of waitqueue */
+	raw_spin_lock_irq(&sem->wait_lock);
+
+	if (flags & LDSEM_READ_WAIT)
+		list_add_tail(&waiter.list, &sem->read_wait);
+	else
+		list_add_tail(&waiter.list, &sem->write_wait);
+
+	waiter.task = current;
+	waiter.flags = flags;
+	get_task_struct(current);
+
+	/* change the lock attempt to a wait --
+	 * if there are no active locks, wake the new lock owner(s)
+	 */
+	if ((ldsem_atomic_update(adjust, sem) & LDSEM_ACTIVE_MASK) == 0)
+		__ldsem_wake(sem, LDSEM_WAKE_NO_CHECK);
+
+	raw_spin_unlock_irq(&sem->wait_lock);
+
+	/* wait to be given the lock */
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+
+		if (!waiter.task)
+			break;
+		if (!timeout)
+			break;
+		timeout = schedule_timeout(timeout);
+	}
+
+	__set_current_state(TASK_RUNNING);
+
+	if (!timeout) {
+		/* lock timed out but check if this task was just
+		 * granted lock ownership - if so, pretend there
+		 * was no timeout; otherwise, cleanup lock wait */
+		raw_spin_lock_irq(&sem->wait_lock);
+		if (waiter.task) {
+			ldsem_atomic_update(-LDSEM_WAIT_BIAS, sem);
+			list_del(&waiter.list);
+			put_task_struct(waiter.task);
+			raw_spin_unlock_irq(&sem->wait_lock);
+			return NULL;
+		}
+		raw_spin_unlock_irq(&sem->wait_lock);
+	}
+
+	return sem;
 }
 
 
-- 
1.8.1.2

