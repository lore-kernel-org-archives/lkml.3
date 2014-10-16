Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaJPTdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:33:54 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:55403 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752192AbaJPTdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:33:52 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 3/9] pty: Use spin_lock_irq() for pty_set_termios()
Date: Thu, 16 Oct 2014 15:33:24 -0400
Message-Id: <1413488010-16885-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
References: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty driver's set_termios() method is called with interrupts
enabled; there is no need to save and restore the local interrupt state.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 7f612c5..3943747 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -259,8 +259,6 @@ out:
 static void pty_set_termios(struct tty_struct *tty,
 					struct ktermios *old_termios)
 {
-	unsigned long flags;
-
 	/* See if packet mode change of state. */
 	if (tty->link && tty->link->packet) {
 		int extproc = (old_termios->c_lflag & EXTPROC) |
@@ -272,7 +270,7 @@ static void pty_set_termios(struct tty_struct *tty,
 				STOP_CHAR(tty) == '\023' &&
 				START_CHAR(tty) == '\021');
 		if ((old_flow != new_flow) || extproc) {
-			spin_lock_irqsave(&tty->ctrl_lock, flags);
+			spin_lock_irq(&tty->ctrl_lock);
 			if (old_flow != new_flow) {
 				tty->ctrl_status &= ~(TIOCPKT_DOSTOP | TIOCPKT_NOSTOP);
 				if (new_flow)
@@ -282,7 +280,7 @@ static void pty_set_termios(struct tty_struct *tty,
 			}
 			if (extproc)
 				tty->ctrl_status |= TIOCPKT_IOCTL;
-			spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+			spin_unlock_irq(&tty->ctrl_lock);
 			wake_up_interruptible(&tty->link->read_wait);
 		}
 	}
-- 
2.1.1

