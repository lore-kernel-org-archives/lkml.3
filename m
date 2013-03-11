Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab3CKVTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:19:36 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33556 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3CKVPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:39 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Michel Lespinasse <walken@google.com>
Subject: [PATCH v5 39/44] tty: Factor ldsem writer trylock
Date: Mon, 11 Mar 2013 16:44:59 -0400
Message-Id: <1363034704-28036-40-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare to simplify lock acquistion by waiting writer.

Derived from Michel Lespinasse's write lock stealing work on rwsem.

Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldsem.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index d2f091a..48f1ce8 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -136,13 +136,8 @@ static void __ldsem_wake_readers(struct ld_semaphore *sem)
 	sem->wait_readers = 0;
 }
 
-static void __ldsem_wake_writer(struct ld_semaphore *sem)
+static inline int writer_trylock(struct ld_semaphore *sem)
 {
-	struct ldsem_waiter *waiter;
-	struct task_struct *tsk;
-
-	waiter = list_entry(sem->write_wait.next, struct ldsem_waiter, list);
-
 	/* only wake this writer if the active part of the count can be
 	 * transitioned from 0 -> 1
 	 */
@@ -159,9 +154,22 @@ static void __ldsem_wake_writer(struct ld_semaphore *sem)
 		 */
 		count = ldsem_atomic_update(-LDSEM_ACTIVE_BIAS, sem);
 		if (count & LDSEM_ACTIVE_MASK)
-			return;
+			return 0;
 	} while (1);
 
+	return 1;
+}
+
+static void __ldsem_wake_writer(struct ld_semaphore *sem)
+{
+	struct ldsem_waiter *waiter;
+	struct task_struct *tsk;
+
+	waiter = list_entry(sem->write_wait.next, struct ldsem_waiter, list);
+
+	if (!writer_trylock(sem))
+		return;
+
 	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
 	 * It is an allocated on the waiter's stack and may become invalid at
 	 * any time after that point (due to a wakeup from another source).
-- 
1.8.1.2

