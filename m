Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3CFMVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 07:21:49 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:43068 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab3CFMVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 07:21:43 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 4/5] tty: Signal foreground group processes in hangup
Date: Wed,  6 Mar 2013 07:20:56 -0500
Message-Id: <1362572457-29993-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
References: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the session leader is exiting, signal the foreground group
processes as part of the hangup sequence, instead of after the
hangup is complete. This prepares for hanging up the
line discipline _after_ signalling processes which
may be blocking on ldisc i/o.

Parameterize __tty_hangup() to distinguish between when the
session leader is exiting and all other hangups; signal the
foreground group after signalling the session leader and its
process group, which preserves the original signal order.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 65 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 40d3a7a..cc6727e 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -534,18 +534,21 @@ EXPORT_SYMBOL_GPL(tty_wakeup);
 
 /**
  *	tty_signal_session_leader	- sends SIGHUP to session leader
+ *	@tty		controlling tty
+ *	@exit_session	if non-zero, signal all foreground group processes
  *
- *	Send SIGHUP and SIGCONT to the session leader and its
- *	process group.
+ *	Send SIGHUP and SIGCONT to the session leader and its process group.
+ *	Optionally, signal all processes in the foreground process group.
  *
  *	Returns the number of processes in the session with this tty
  *	as their controlling terminal. This value is used to drop
  *	tty references for those processes.
  */
-static int tty_signal_session_leader(struct tty_struct *tty)
+static int tty_signal_session_leader(struct tty_struct *tty, int exit_session)
 {
 	struct task_struct *p;
 	int refs = 0;
+	struct pid *tty_pgrp = NULL;
 
 	read_lock(&tasklist_lock);
 	if (tty->session) {
@@ -565,6 +568,7 @@ static int tty_signal_session_leader(struct tty_struct *tty)
 			__group_send_sig_info(SIGCONT, SEND_SIG_PRIV, p);
 			put_pid(p->signal->tty_old_pgrp);  /* A noop */
 			spin_lock(&tty->ctrl_lock);
+			tty_pgrp = get_pid(tty->pgrp);
 			if (tty->pgrp)
 				p->signal->tty_old_pgrp = get_pid(tty->pgrp);
 			spin_unlock(&tty->ctrl_lock);
@@ -573,6 +577,12 @@ static int tty_signal_session_leader(struct tty_struct *tty)
 	}
 	read_unlock(&tasklist_lock);
 
+	if (tty_pgrp) {
+		if (exit_session)
+			kill_pgrp(tty_pgrp, SIGHUP, exit_session);
+		put_pid(tty_pgrp);
+	}
+
 	return refs;
 }
 
@@ -598,7 +608,7 @@ static int tty_signal_session_leader(struct tty_struct *tty)
  *		  tasklist_lock to walk task list for hangup event
  *		    ->siglock to protect ->signal/->sighand
  */
-static void __tty_hangup(struct tty_struct *tty)
+static void __tty_hangup(struct tty_struct *tty, int exit_session)
 {
 	struct file *cons_filp = NULL;
 	struct file *filp, *f = NULL;
@@ -647,7 +657,7 @@ static void __tty_hangup(struct tty_struct *tty)
 	 */
 	tty_ldisc_hangup(tty);
 
-	refs = tty_signal_session_leader(tty);
+	refs = tty_signal_session_leader(tty, exit_session);
 	/* Account for the p->signal references we killed */
 	while (refs--)
 		tty_kref_put(tty);
@@ -695,7 +705,7 @@ static void do_tty_hangup(struct work_struct *work)
 	struct tty_struct *tty =
 		container_of(work, struct tty_struct, hangup_work);
 
-	__tty_hangup(tty);
+	__tty_hangup(tty, 0);
 }
 
 /**
@@ -733,7 +743,7 @@ void tty_vhangup(struct tty_struct *tty)
 
 	printk(KERN_DEBUG "%s vhangup...\n", tty_name(tty, buf));
 #endif
-	__tty_hangup(tty);
+	__tty_hangup(tty, 0);
 }
 
 EXPORT_SYMBOL(tty_vhangup);
@@ -757,6 +767,27 @@ void tty_vhangup_self(void)
 }
 
 /**
+ *	tty_vhangup_session		-	hangup session leader exit
+ *	@tty: tty to hangup
+ *
+ *	The session leader is exiting and hanging up its controlling terminal.
+ *	Every process in the foreground process group is signalled SIGHUP.
+ *
+ *	We do this synchronously so that when the syscall returns the process
+ *	is complete. That guarantee is necessary for security reasons.
+ */
+
+void tty_vhangup_session(struct tty_struct *tty)
+{
+#ifdef TTY_DEBUG_HANGUP
+	char	buf[64];
+
+	printk(KERN_DEBUG "%s vhangup session...\n", tty_name(tty, buf));
+#endif
+	__tty_hangup(tty, 1);
+}
+
+/**
  *	tty_hung_up_p		-	was tty hung up
  *	@filp: file pointer of tty
  *
@@ -813,18 +844,18 @@ void disassociate_ctty(int on_exit)
 
 	tty = get_current_tty();
 	if (tty) {
-		struct pid *tty_pgrp = get_pid(tty->pgrp);
-		if (on_exit) {
-			if (tty->driver->type != TTY_DRIVER_TYPE_PTY)
-				tty_vhangup(tty);
-		}
-		tty_kref_put(tty);
-		if (tty_pgrp) {
-			kill_pgrp(tty_pgrp, SIGHUP, on_exit);
-			if (!on_exit)
+		if (on_exit && tty->driver->type != TTY_DRIVER_TYPE_PTY) {
+			tty_vhangup_session(tty);
+		} else {
+			struct pid *tty_pgrp = tty_get_pgrp(tty);
+			if (tty_pgrp) {
+				kill_pgrp(tty_pgrp, SIGHUP, on_exit);
 				kill_pgrp(tty_pgrp, SIGCONT, on_exit);
-			put_pid(tty_pgrp);
+				put_pid(tty_pgrp);
+			}
 		}
+		tty_kref_put(tty);
+
 	} else if (on_exit) {
 		struct pid *old_pgrp;
 		spin_lock_irq(&current->sighand->siglock);
-- 
1.8.1.2

