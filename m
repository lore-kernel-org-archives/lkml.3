Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab3CFMWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 07:22:43 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:43047 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807Ab3CFMVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 07:21:36 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 1/5] tty: Refactor session leader SIGHUP from __tty_hangup()
Date: Wed,  6 Mar 2013 07:20:53 -0500
Message-Id: <1362572457-29993-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
References: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce complexity of __tty_hangup(); separate SIGHUP signalling
into tty_signal_session_leader().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 81 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 31 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index adc1d01..e454f1a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -533,6 +533,51 @@ void tty_wakeup(struct tty_struct *tty)
 EXPORT_SYMBOL_GPL(tty_wakeup);
 
 /**
+ *	tty_signal_session_leader	- sends SIGHUP to session leader
+ *
+ *	Send SIGHUP and SIGCONT to the session leader and its
+ *	process group.
+ *
+ *	Returns the number of processes in the session with this tty
+ *	as their controlling terminal. This value is used to drop
+ *	tty references for those processes.
+ */
+static int tty_signal_session_leader(struct tty_struct *tty)
+{
+	struct task_struct *p;
+	unsigned long flags;
+	int refs = 0;
+
+	read_lock(&tasklist_lock);
+	if (tty->session) {
+		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
+			spin_lock_irq(&p->sighand->siglock);
+			if (p->signal->tty == tty) {
+				p->signal->tty = NULL;
+				/* We defer the dereferences outside fo
+				   the tasklist lock */
+				refs++;
+			}
+			if (!p->signal->leader) {
+				spin_unlock_irq(&p->sighand->siglock);
+				continue;
+			}
+			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
+			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
+			put_pid(p->signal->tty_old_pgrp);  /* A noop */
+			spin_lock_irqsave(&tty->ctrl_lock, flags);
+			if (tty->pgrp)
+				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
+			spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+			spin_unlock_irq(&p->sighand->siglock);
+		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
+	}
+	read_unlock(&tasklist_lock);
+
+	return refs;
+}
+
+/**
  *	__tty_hangup		-	actual handler for hangup events
  *	@work: tty device
  *
@@ -558,11 +603,10 @@ static void __tty_hangup(struct tty_struct *tty)
 {
 	struct file *cons_filp = NULL;
 	struct file *filp, *f = NULL;
-	struct task_struct *p;
 	struct tty_file_private *priv;
 	int    closecount = 0, n;
 	unsigned long flags;
-	int refs = 0;
+	int refs;
 
 	if (!tty)
 		return;
@@ -605,31 +649,10 @@ static void __tty_hangup(struct tty_struct *tty)
 	 */
 	tty_ldisc_hangup(tty);
 
-	read_lock(&tasklist_lock);
-	if (tty->session) {
-		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
-			spin_lock_irq(&p->sighand->siglock);
-			if (p->signal->tty == tty) {
-				p->signal->tty = NULL;
-				/* We defer the dereferences outside fo
-				   the tasklist lock */
-				refs++;
-			}
-			if (!p->signal->leader) {
-				spin_unlock_irq(&p->sighand->siglock);
-				continue;
-			}
-			__group_send_sig_info(SIGHUP, SEND_SIG_PRIV, p);
-			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
-			put_pid(p->signal->tty_old_pgrp);  /* A noop */
-			spin_lock_irqsave(&tty->ctrl_lock, flags);
-			if (tty->pgrp)
-				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
-			spin_unlock_irqrestore(&tty->ctrl_lock, flags);
-			spin_unlock_irq(&p->sighand->siglock);
-		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
-	}
-	read_unlock(&tasklist_lock);
+	refs = tty_signal_session_leader(tty);
+	/* Account for the p->signal references we killed */
+	while (refs--)
+		tty_kref_put(tty);
 
 	spin_lock_irqsave(&tty->ctrl_lock, flags);
 	clear_bit(TTY_THROTTLED, &tty->flags);
@@ -642,10 +665,6 @@ static void __tty_hangup(struct tty_struct *tty)
 	tty->ctrl_status = 0;
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 
-	/* Account for the p->signal references we killed */
-	while (refs--)
-		tty_kref_put(tty);
-
 	/*
 	 * If one of the devices matches a console pointer, we
 	 * cannot just call hangup() because that will cause
-- 
1.8.1.2

