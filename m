Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaJPTgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:36:06 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33193 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751854AbaJPTdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:33:51 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 2/9] tty: Move pty-specific set_termios() handling to pty driver
Date: Thu, 16 Oct 2014 15:33:23 -0400
Message-Id: <1413488010-16885-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
References: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Packet mode is unique to the pty driver; move the packet mode state
change code from the generic tty ioctl handler to the pty driver.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c       | 28 ++++++++++++++++++++++++++++
 drivers/tty/tty_ioctl.c | 32 +-------------------------------
 2 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 6c76025..7f612c5 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -259,6 +259,34 @@ out:
 static void pty_set_termios(struct tty_struct *tty,
 					struct ktermios *old_termios)
 {
+	unsigned long flags;
+
+	/* See if packet mode change of state. */
+	if (tty->link && tty->link->packet) {
+		int extproc = (old_termios->c_lflag & EXTPROC) |
+				(tty->termios.c_lflag & EXTPROC);
+		int old_flow = ((old_termios->c_iflag & IXON) &&
+				(old_termios->c_cc[VSTOP] == '\023') &&
+				(old_termios->c_cc[VSTART] == '\021'));
+		int new_flow = (I_IXON(tty) &&
+				STOP_CHAR(tty) == '\023' &&
+				START_CHAR(tty) == '\021');
+		if ((old_flow != new_flow) || extproc) {
+			spin_lock_irqsave(&tty->ctrl_lock, flags);
+			if (old_flow != new_flow) {
+				tty->ctrl_status &= ~(TIOCPKT_DOSTOP | TIOCPKT_NOSTOP);
+				if (new_flow)
+					tty->ctrl_status |= TIOCPKT_DOSTOP;
+				else
+					tty->ctrl_status |= TIOCPKT_NOSTOP;
+			}
+			if (extproc)
+				tty->ctrl_status |= TIOCPKT_IOCTL;
+			spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+			wake_up_interruptible(&tty->link->read_wait);
+		}
+	}
+
 	tty->termios.c_cflag &= ~(CSIZE | PARENB);
 	tty->termios.c_cflag |= (CS8 | CREAD);
 }
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index f29e3d1..e2484e4 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -524,10 +524,7 @@ EXPORT_SYMBOL(tty_termios_hw_change);
  *	@tty: tty to update
  *	@new_termios: desired new value
  *
- *	Perform updates to the termios values set on this terminal. There
- *	is a bit of layering violation here with n_tty in terms of the
- *	internal knowledge of this function.
- *
+ *	Perform updates to the termios values set on this terminal.
  *	A master pty's termios should never be set.
  *
  *	Locking: termios_rwsem
@@ -537,7 +534,6 @@ int tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
 {
 	struct ktermios old_termios;
 	struct tty_ldisc *ld;
-	unsigned long flags;
 
 	WARN_ON(tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 		tty->driver->subtype == PTY_TYPE_MASTER);
@@ -553,32 +549,6 @@ int tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
 	tty->termios = *new_termios;
 	unset_locked_termios(&tty->termios, &old_termios, &tty->termios_locked);
 
-	/* See if packet mode change of state. */
-	if (tty->link && tty->link->packet) {
-		int extproc = (old_termios.c_lflag & EXTPROC) |
-				(tty->termios.c_lflag & EXTPROC);
-		int old_flow = ((old_termios.c_iflag & IXON) &&
-				(old_termios.c_cc[VSTOP] == '\023') &&
-				(old_termios.c_cc[VSTART] == '\021'));
-		int new_flow = (I_IXON(tty) &&
-				STOP_CHAR(tty) == '\023' &&
-				START_CHAR(tty) == '\021');
-		if ((old_flow != new_flow) || extproc) {
-			spin_lock_irqsave(&tty->ctrl_lock, flags);
-			if (old_flow != new_flow) {
-				tty->ctrl_status &= ~(TIOCPKT_DOSTOP | TIOCPKT_NOSTOP);
-				if (new_flow)
-					tty->ctrl_status |= TIOCPKT_DOSTOP;
-				else
-					tty->ctrl_status |= TIOCPKT_NOSTOP;
-			}
-			if (extproc)
-				tty->ctrl_status |= TIOCPKT_IOCTL;
-			spin_unlock_irqrestore(&tty->ctrl_lock, flags);
-			wake_up_interruptible(&tty->link->read_wait);
-		}
-	}
-
 	if (tty->ops->set_termios)
 		(*tty->ops->set_termios)(tty, &old_termios);
 	else
-- 
2.1.1

