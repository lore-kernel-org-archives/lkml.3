Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab3CKVPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:15:42 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33566 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab3CKVPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:40 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 37/44] tty: Drop ldsem wait type
Date: Mon, 11 Mar 2013 16:44:57 -0400
Message-Id: <1363034704-28036-38-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the lock failures are handled independently for reads and
writes, the wait flags are no longer necessary.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldsem.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index d849fb85..ddfbdfe 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -76,9 +76,6 @@
 struct ldsem_waiter {
 	struct list_head list;
 	struct task_struct *task;
-	unsigned int flags;
-#define LDSEM_READ_WAIT		0x00000001
-#define LDSEM_WRITE_WAIT	0x00000002
 };
 
 /* Wake types for __ldsem_wake().  Note: RWSEM_WAKE_NO_CHECK implies
@@ -226,19 +223,13 @@ static struct ld_semaphore __sched *
 down_read_failed(struct ld_semaphore *sem, long timeout)
 {
 	struct ldsem_waiter waiter;
-	long flags = LDSEM_READ_WAIT;
 	long adjust = -LDSEM_ACTIVE_BIAS + LDSEM_WAIT_BIAS;
 
 	/* set up my own style of waitqueue */
 	raw_spin_lock_irq(&sem->wait_lock);
-
-	if (flags & LDSEM_READ_WAIT)
-		list_add_tail(&waiter.list, &sem->read_wait);
-	else
-		list_add_tail(&waiter.list, &sem->write_wait);
+	list_add_tail(&waiter.list, &sem->read_wait);
 
 	waiter.task = current;
-	waiter.flags = flags;
 	get_task_struct(current);
 
 	/* change the lock attempt to a wait --
@@ -287,19 +278,13 @@ static struct ld_semaphore __sched *
 down_write_failed(struct ld_semaphore *sem, long timeout)
 {
 	struct ldsem_waiter waiter;
-	long flags = LDSEM_WRITE_WAIT;
 	long adjust = -LDSEM_ACTIVE_BIAS;
 
 	/* set up my own style of waitqueue */
 	raw_spin_lock_irq(&sem->wait_lock);
-
-	if (flags & LDSEM_READ_WAIT)
-		list_add_tail(&waiter.list, &sem->read_wait);
-	else
-		list_add_tail(&waiter.list, &sem->write_wait);
+	list_add_tail(&waiter.list, &sem->write_wait);
 
 	waiter.task = current;
-	waiter.flags = flags;
 	get_task_struct(current);
 
 	/* change the lock attempt to a wait --
-- 
1.8.1.2

