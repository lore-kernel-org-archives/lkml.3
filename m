Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaJPTAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:00:48 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37340 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751960AbaJPTAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:00:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 02/10] tty: Reorder proc_set_tty() and related fns
Date: Thu, 16 Oct 2014 14:59:42 -0400
Message-Id: <1413485990-16855-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
References: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the controlling tty-related functions and remove forward
declarations for __proc_set_tty() and proc_set_tty().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 125 +++++++++++++++++++++++++--------------------------
 1 file changed, 62 insertions(+), 63 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 274e386..012647b 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -153,8 +153,6 @@ static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 static int __tty_fasync(int fd, struct file *filp, int on);
 static int tty_fasync(int fd, struct file *filp, int on);
 static void release_tty(struct tty_struct *tty, int idx);
-static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
-static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 
 /**
  *	free_tty_struct		-	free a disused tty
@@ -492,6 +490,68 @@ static const struct file_operations hung_up_tty_fops = {
 static DEFINE_SPINLOCK(redirect_lock);
 static struct file *redirect;
 
+
+void proc_clear_tty(struct task_struct *p)
+{
+	unsigned long flags;
+	struct tty_struct *tty;
+	spin_lock_irqsave(&p->sighand->siglock, flags);
+	tty = p->signal->tty;
+	p->signal->tty = NULL;
+	spin_unlock_irqrestore(&p->sighand->siglock, flags);
+	tty_kref_put(tty);
+}
+
+/* Called under the sighand lock */
+
+static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+{
+	if (tty) {
+		unsigned long flags;
+		/* We should not have a session or pgrp to put here but.... */
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
+		put_pid(tty->session);
+		put_pid(tty->pgrp);
+		tty->pgrp = get_pid(task_pgrp(tsk));
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		tty->session = get_pid(task_session(tsk));
+		if (tsk->signal->tty) {
+			printk(KERN_DEBUG "tty not NULL!!\n");
+			tty_kref_put(tsk->signal->tty);
+		}
+	}
+	put_pid(tsk->signal->tty_old_pgrp);
+	tsk->signal->tty = tty_kref_get(tty);
+	tsk->signal->tty_old_pgrp = NULL;
+}
+
+static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
+{
+	spin_lock_irq(&tsk->sighand->siglock);
+	__proc_set_tty(tsk, tty);
+	spin_unlock_irq(&tsk->sighand->siglock);
+}
+
+struct tty_struct *get_current_tty(void)
+{
+	struct tty_struct *tty;
+	unsigned long flags;
+
+	spin_lock_irqsave(&current->sighand->siglock, flags);
+	tty = tty_kref_get(current->signal->tty);
+	spin_unlock_irqrestore(&current->sighand->siglock, flags);
+	return tty;
+}
+EXPORT_SYMBOL_GPL(get_current_tty);
+
+static void session_clear_tty(struct pid *session)
+{
+	struct task_struct *p;
+	do_each_pid_task(session, PIDTYPE_SID, p) {
+		proc_clear_tty(p);
+	} while_each_pid_task(session, PIDTYPE_SID, p);
+}
+
 /**
  *	tty_wakeup	-	request more data
  *	@tty: terminal
@@ -792,14 +852,6 @@ int tty_hung_up_p(struct file *filp)
 
 EXPORT_SYMBOL(tty_hung_up_p);
 
-static void session_clear_tty(struct pid *session)
-{
-	struct task_struct *p;
-	do_each_pid_task(session, PIDTYPE_SID, p) {
-		proc_clear_tty(p);
-	} while_each_pid_task(session, PIDTYPE_SID, p);
-}
-
 /**
  *	disassociate_ctty	-	disconnect controlling tty
  *	@on_exit: true if exiting so need to "hang up" the session
@@ -3433,59 +3485,6 @@ dev_t tty_devnum(struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_devnum);
 
-void proc_clear_tty(struct task_struct *p)
-{
-	unsigned long flags;
-	struct tty_struct *tty;
-	spin_lock_irqsave(&p->sighand->siglock, flags);
-	tty = p->signal->tty;
-	p->signal->tty = NULL;
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	tty_kref_put(tty);
-}
-
-/* Called under the sighand lock */
-
-static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
-{
-	if (tty) {
-		unsigned long flags;
-		/* We should not have a session or pgrp to put here but.... */
-		spin_lock_irqsave(&tty->ctrl_lock, flags);
-		put_pid(tty->session);
-		put_pid(tty->pgrp);
-		tty->pgrp = get_pid(task_pgrp(tsk));
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
-		tty->session = get_pid(task_session(tsk));
-		if (tsk->signal->tty) {
-			printk(KERN_DEBUG "tty not NULL!!\n");
-			tty_kref_put(tsk->signal->tty);
-		}
-	}
-	put_pid(tsk->signal->tty_old_pgrp);
-	tsk->signal->tty = tty_kref_get(tty);
-	tsk->signal->tty_old_pgrp = NULL;
-}
-
-static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
-{
-	spin_lock_irq(&tsk->sighand->siglock);
-	__proc_set_tty(tsk, tty);
-	spin_unlock_irq(&tsk->sighand->siglock);
-}
-
-struct tty_struct *get_current_tty(void)
-{
-	struct tty_struct *tty;
-	unsigned long flags;
-
-	spin_lock_irqsave(&current->sighand->siglock, flags);
-	tty = tty_kref_get(current->signal->tty);
-	spin_unlock_irqrestore(&current->sighand->siglock, flags);
-	return tty;
-}
-EXPORT_SYMBOL_GPL(get_current_tty);
-
 void tty_default_fops(struct file_operations *fops)
 {
 	*fops = tty_fops;
-- 
2.1.1

