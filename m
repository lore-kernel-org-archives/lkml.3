Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaJPTd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:33:57 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:60920 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752596AbaJPTdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:33:52 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 4/9] tty: Use spin_lock_irq() for ctrl_lock when interrupts enabled
Date: Thu, 16 Oct 2014 15:33:25 -0400
Message-Id: <1413488010-16885-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
References: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupts are enabled in the n_tty_read() loop, ioctl(TIOCPKT)
and pty driver flush_buffer() routine; no need to save and restore
local interrupt state.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c |  5 ++---
 drivers/tty/pty.c   | 10 ++++------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index f44f1ba..53cdfbe 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2128,7 +2128,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	int minimum, time;
 	ssize_t retval = 0;
 	long timeout;
-	unsigned long flags;
 	int packet;
 
 	c = job_control(tty, file);
@@ -2174,10 +2173,10 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 			unsigned char cs;
 			if (b != buf)
 				break;
-			spin_lock_irqsave(&tty->link->ctrl_lock, flags);
+			spin_lock_irq(&tty->link->ctrl_lock);
 			cs = tty->link->ctrl_status;
 			tty->link->ctrl_status = 0;
-			spin_unlock_irqrestore(&tty->link->ctrl_lock, flags);
+			spin_unlock_irq(&tty->link->ctrl_lock);
 			if (tty_put_user(tty, cs, b++)) {
 				retval = -EFAULT;
 				b--;
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 3943747..29b5eeb 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -178,13 +178,12 @@ static int pty_get_lock(struct tty_struct *tty, int __user *arg)
 /* Set the packet mode on a pty */
 static int pty_set_pktmode(struct tty_struct *tty, int __user *arg)
 {
-	unsigned long flags;
 	int pktmode;
 
 	if (get_user(pktmode, arg))
 		return -EFAULT;
 
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	spin_lock_irq(&tty->ctrl_lock);
 	if (pktmode) {
 		if (!tty->packet) {
 			tty->packet = 1;
@@ -192,7 +191,7 @@ static int pty_set_pktmode(struct tty_struct *tty, int __user *arg)
 		}
 	} else
 		tty->packet = 0;
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	spin_unlock_irq(&tty->ctrl_lock);
 
 	return 0;
 }
@@ -221,16 +220,15 @@ static int pty_signal(struct tty_struct *tty, int sig)
 static void pty_flush_buffer(struct tty_struct *tty)
 {
 	struct tty_struct *to = tty->link;
-	unsigned long flags;
 
 	if (!to)
 		return;
 	/* tty_buffer_flush(to); FIXME */
 	if (to->packet) {
-		spin_lock_irqsave(&tty->ctrl_lock, flags);
+		spin_lock_irq(&tty->ctrl_lock);
 		tty->ctrl_status |= TIOCPKT_FLUSHWRITE;
 		wake_up_interruptible(&to->read_wait);
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		spin_unlock_irq(&tty->ctrl_lock);
 	}
 }
 
-- 
2.1.1

