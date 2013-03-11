Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab3CKVXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:23:10 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33513 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab3CKVPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:34 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH v5 40/44] tty: Simplify lock taking for waiting writers
Date: Mon, 11 Mar 2013 16:45:00 -0400
Message-Id: <1363034704-28036-41-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than granting the lock from the wakeup thread,
have the woken thread claim the lock instead. This may
delay the taking of the lock by the waiting writer
(readers may have bumped the semaphore but can't reverse it
because they need to acquire the wait_lock to put themselves
on the read_wait list). However, this step is necessary to
implement write lock stealing.

Derived from Michel Lespinasse's write lock stealing work on
rwsem.

Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldsem.c | 52 +++++++++++++++----------------------------------
 1 file changed, 16 insertions(+), 36 deletions(-)

diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index 48f1ce8..372e897 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -163,23 +163,9 @@ static inline int writer_trylock(struct ld_semaphore *sem)
 static void __ldsem_wake_writer(struct ld_semaphore *sem)
 {
 	struct ldsem_waiter *waiter;
-	struct task_struct *tsk;
 
 	waiter = list_entry(sem->write_wait.next, struct ldsem_waiter, list);
-
-	if (!writer_trylock(sem))
-		return;
-
-	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
-	 * It is an allocated on the waiter's stack and may become invalid at
-	 * any time after that point (due to a wakeup from another source).
-	 */
-	list_del(&waiter->list);
-	tsk = waiter->task;
-	smp_mb();
-	waiter->task = NULL;
-	wake_up_process(tsk);
-	put_task_struct(tsk);
+	wake_up_process(waiter->task);
 }
 
 /*
@@ -271,6 +257,7 @@ down_write_failed(struct ld_semaphore *sem, long timeout)
 {
 	struct ldsem_waiter waiter;
 	long adjust = -LDSEM_ACTIVE_BIAS;
+	int locked = 0;
 
 	/* set up my own style of waitqueue */
 	raw_spin_lock_irq(&sem->wait_lock);
@@ -285,36 +272,29 @@ down_write_failed(struct ld_semaphore *sem, long timeout)
 	if ((ldsem_atomic_update(adjust, sem) & LDSEM_ACTIVE_MASK) == 0)
 		__ldsem_wake(sem);
 
-	raw_spin_unlock_irq(&sem->wait_lock);
-
-	/* wait to be given the lock */
+	set_current_state(TASK_UNINTERRUPTIBLE);
 	for (;;) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-
-		if (!waiter.task)
-			break;
 		if (!timeout)
 			break;
+		raw_spin_unlock_irq(&sem->wait_lock);
 		timeout = schedule_timeout(timeout);
+		raw_spin_lock_irq(&sem->wait_lock);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if ((locked = writer_trylock(sem)))
+			break;
 	}
 
+	list_del(&waiter.list);
+	raw_spin_unlock_irq(&sem->wait_lock);
+	put_task_struct(waiter.task);
+
 	__set_current_state(TASK_RUNNING);
 
-	if (!timeout) {
-		/* lock timed out but check if this task was just
-		 * granted lock ownership - if so, pretend there
-		 * was no timeout; otherwise, cleanup lock wait */
-		raw_spin_lock_irq(&sem->wait_lock);
-		if (waiter.task) {
-			ldsem_atomic_update(-LDSEM_WAIT_BIAS, sem);
-			list_del(&waiter.list);
-			put_task_struct(waiter.task);
-			raw_spin_unlock_irq(&sem->wait_lock);
-			return NULL;
-		}
-		raw_spin_unlock_irq(&sem->wait_lock);
+	/* lock wait may have timed out */
+	if (!locked) {
+		ldsem_atomic_update(-LDSEM_WAIT_BIAS, sem);
+		return NULL;
 	}
-
 	return sem;
 }
 
-- 
1.8.1.2

