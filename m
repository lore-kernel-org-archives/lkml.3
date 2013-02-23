Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab3BWDBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 22:01:25 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:60976 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab3BWDBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 22:01:23 -0500
Date: Fri, 22 Feb 2013 19:00:34 -0800 (PST)
From: Min Zhang <mzhang@mvista.com>
X-X-Sender: mzhang@linux-acr3.site
To: gregkh@linuxfoundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tty: fix ldisc flush and termios setting race
Message-ID: <alpine.LNX.2.00.1302221848440.15944@linux-acr3.site>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Min Zhang <mzhang@mvista.com>

A race condition can clear tty ldisc icanon bit unintentionally which 
could stop n_tty from processing received characters. It can occur when
tty receiver buffer was full, e.g. 4096 chars received, 8250 serial driver
interrupt tried to flush_to_ldisc them, but other shell thread tried
to change_termios the tty setting too. Then n_tty_receive_char and
n_tty_set_termios both tried to modify n_tty_data fields.

Specifically the icanon and its neighbor fields are defines as bits:

    unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;

However they are not atomically accessed in the follow race condition:

serial8250_handle_irq
  serail8250_rx_chars
    tty_flip_buffer_push
      schdule_work -------> flush_to_ldisc
                              n_tty_receive_buf
                                n_tty_receive_char
                                  (holds no lock)
ioctl
  set_termios
    tty_set_termios
      n_tty_set_termios
        (holds termios_mutex)

The patch let change_termios to use TTY_LDISC_FLUSHING to prevent
flush_to_ldisc from running, and flush_to_ldisc use TTY_FLUSHING
to make change_termios wait until the flag is cleared.

The patch also replaces flush_to_ldisc's wake_up with wake_up_all,
because it can now wake up both TTY_FLUSHING and TTY_FLUSHPENDING
on the same tty->read_wait queue. Event waiters need check which event.

Signed-off-by: Min Zhang <mzhang@mvista.com>
---
 drivers/tty/tty_buffer.c |   12 +++++++++++-
 drivers/tty/tty_ioctl.c  |   27 ++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 45d9161..37f4818 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -482,6 +482,13 @@ static void flush_to_ldisc(struct work_struct *work)
 
 	spin_lock_irqsave(&buf->lock, flags);
 
+	/* Ldisc change by change_termios can race with ldisc receive_buf, esp
+	   to access N_TTY line discipline field in tty_struct, so we defer */
+	if (test_bit(TTY_LDISC_CHANGING, &tty->flags)) {
+		schedule_delayed_work(&buf->work, 1);
+		goto out;
+	}
+
 	if (!test_and_set_bit(TTYP_FLUSHING, &port->iflags)) {
 		struct tty_buffer *head;
 		while ((head = buf->head) != NULL) {
@@ -522,8 +529,11 @@ static void flush_to_ldisc(struct work_struct *work)
 	if (test_bit(TTYP_FLUSHPENDING, &port->iflags)) {
 		__tty_buffer_flush(port);
 		clear_bit(TTYP_FLUSHPENDING, &port->iflags);
-		wake_up(&tty->read_wait);
 	}
+
+	/* wake up tasks waiting for TTYP_FLUSHING or TTYP_FLUSHPENDING */
+	wake_up_all(&tty->read_wait);
+out:
 	spin_unlock_irqrestore(&buf->lock, flags);
 
 	tty_ldisc_deref(disc);
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 8481b29..36a1bfa 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -546,8 +546,33 @@ int tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
 
 	ld = tty_ldisc_ref(tty);
 	if (ld != NULL) {
-		if (ld->ops->set_termios)
+		unsigned long 	flags;
+		struct tty_port *port = tty->port;
+		struct tty_bufhead *buf = &port->buf;
+		if (!ld->ops->set_termios)
+			goto no_set_termios;
+
+		/* Wait if the data is being pushed to the tty layer */
+		spin_lock_irqsave(&buf->lock, flags);
+		while (test_bit(TTYP_FLUSHING, &port->iflags)) {
+			spin_unlock_irqrestore(&buf->lock, flags);
+			printk(KERN_CRIT "%s flushing\n", __FUNCTION__);
+			wait_event(tty->read_wait,
+				   test_bit(TTYP_FLUSHING, &port->iflags) == 0);
+			spin_lock_irqsave(&buf->lock, flags);
+		}
+		printk(KERN_CRIT "%s survived flushing\n", __FUNCTION__);
+
+		/* Prevent future flush_to_ldisc while we are setting */
+		if (!test_and_set_bit(TTY_LDISC_CHANGING, &tty->flags)) {
+			spin_unlock_irqrestore(&buf->lock, flags);
 			(ld->ops->set_termios)(tty, &old_termios);
+			spin_lock_irqsave(&buf->lock, flags);
+			clear_bit(TTY_LDISC_CHANGING, &tty->flags);
+		}
+		spin_unlock_irqrestore(&buf->lock, flags);
+
+no_set_termios:
 		tty_ldisc_deref(ld);
 	}
 	mutex_unlock(&tty->termios_mutex);
-- 
1.7.7.4

