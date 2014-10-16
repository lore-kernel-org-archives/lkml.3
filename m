Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaJPTAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:00:37 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:39552 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752192AbaJPTAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:00:04 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 03/10] tty: Remove tsk parameter from proc_set_tty()
Date: Thu, 16 Oct 2014 14:59:43 -0400
Message-Id: <1413485990-16855-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
References: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only the current task itself can set its controlling tty (other
than before the task has been forked). Equivalent to existing usage.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 012647b..272d977 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -504,7 +504,7 @@ void proc_clear_tty(struct task_struct *p)
 
 /* Called under the sighand lock */
 
-static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+static void __proc_set_tty(struct tty_struct *tty)
 {
 	if (tty) {
 		unsigned long flags;
@@ -512,24 +512,24 @@ static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		put_pid(tty->session);
 		put_pid(tty->pgrp);
-		tty->pgrp = get_pid(task_pgrp(tsk));
+		tty->pgrp = get_pid(task_pgrp(current));
 		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
-		tty->session = get_pid(task_session(tsk));
-		if (tsk->signal->tty) {
+		tty->session = get_pid(task_session(current));
+		if (current->signal->tty) {
 			printk(KERN_DEBUG "tty not NULL!!\n");
-			tty_kref_put(tsk->signal->tty);
+			tty_kref_put(current->signal->tty);
 		}
 	}
-	put_pid(tsk->signal->tty_old_pgrp);
-	tsk->signal->tty = tty_kref_get(tty);
-	tsk->signal->tty_old_pgrp = NULL;
+	put_pid(current->signal->tty_old_pgrp);
+	current->signal->tty = tty_kref_get(tty);
+	current->signal->tty_old_pgrp = NULL;
 }
 
-static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+static void proc_set_tty(struct tty_struct *tty)
 {
-	spin_lock_irq(&tsk->sighand->siglock);
-	__proc_set_tty(tsk, tty);
-	spin_unlock_irq(&tsk->sighand->siglock);
+	spin_lock_irq(&current->sighand->siglock);
+	__proc_set_tty(tty);
+	spin_unlock_irq(&current->sighand->siglock);
 }
 
 struct tty_struct *get_current_tty(void)
@@ -2164,7 +2164,7 @@ retry_open:
 	    current->signal->leader &&
 	    !current->signal->tty &&
 	    tty->session == NULL)
-		__proc_set_tty(current, tty);
+		__proc_set_tty(tty);
 	spin_unlock_irq(&current->sighand->siglock);
 	tty_unlock(tty);
 	mutex_unlock(&tty_mutex);
@@ -2489,7 +2489,7 @@ static int tiocsctty(struct tty_struct *tty, int arg)
 			goto unlock;
 		}
 	}
-	proc_set_tty(current, tty);
+	proc_set_tty(tty);
 unlock:
 	mutex_unlock(&tty_mutex);
 	return ret;
-- 
2.1.1

