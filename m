Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab3CGMOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:14:52 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49723 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/16] TTY: do not warn about setting speed via SPD_*
Date: Thu,  7 Mar 2013 13:12:27 +0100
Message-Id: <1362658360-26629-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warning is there since 2.1.69 and we have not seen anybody
reporting it in the past decade. Remove the warning now.

tty_get_baud_rate can now be inline. This gives us one less
EXPORT_SYMBOL.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_ioctl.c | 28 ----------------------------
 include/linux/tty.h     | 18 ++++++++++++++++--
 2 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index d58b92c..20db217 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -415,34 +415,6 @@ void tty_encode_baud_rate(struct tty_struct *tty, speed_t ibaud, speed_t obaud)
 EXPORT_SYMBOL_GPL(tty_encode_baud_rate);
 
 /**
- *	tty_get_baud_rate	-	get tty bit rates
- *	@tty: tty to query
- *
- *	Returns the baud rate as an integer for this terminal. The
- *	termios lock must be held by the caller and the terminal bit
- *	flags may be updated.
- *
- *	Locking: none
- */
-
-speed_t tty_get_baud_rate(struct tty_struct *tty)
-{
-	speed_t baud = tty_termios_baud_rate(&tty->termios);
-
-	if (baud == 38400 && tty->alt_speed) {
-		if (!tty->warned) {
-			printk(KERN_WARNING "Use of setserial/setrocket to "
-					    "set SPD_* flags is deprecated\n");
-			tty->warned = 1;
-		}
-		baud = tty->alt_speed;
-	}
-
-	return baud;
-}
-EXPORT_SYMBOL(tty_get_baud_rate);
-
-/**
  *	tty_termios_copy_hw	-	copy hardware settings
  *	@new: New termios
  *	@old: Old termios
diff --git a/include/linux/tty.h b/include/linux/tty.h
index c75d886..4c6a079 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -255,7 +255,6 @@ struct tty_struct {
 	int count;
 	struct winsize winsize;		/* termios mutex */
 	unsigned char stopped:1, hw_stopped:1, flow_stopped:1, packet:1;
-	unsigned char warned:1;
 	unsigned char ctrl_status;	/* ctrl_lock */
 	unsigned int receive_room;	/* Bytes free for queue */
 
@@ -419,13 +418,28 @@ extern void tty_flush_to_ldisc(struct tty_struct *tty);
 extern void tty_buffer_free_all(struct tty_port *port);
 extern void tty_buffer_flush(struct tty_struct *tty);
 extern void tty_buffer_init(struct tty_port *port);
-extern speed_t tty_get_baud_rate(struct tty_struct *tty);
 extern speed_t tty_termios_baud_rate(struct ktermios *termios);
 extern speed_t tty_termios_input_baud_rate(struct ktermios *termios);
 extern void tty_termios_encode_baud_rate(struct ktermios *termios,
 						speed_t ibaud, speed_t obaud);
 extern void tty_encode_baud_rate(struct tty_struct *tty,
 						speed_t ibaud, speed_t obaud);
+
+/**
+ *	tty_get_baud_rate	-	get tty bit rates
+ *	@tty: tty to query
+ *
+ *	Returns the baud rate as an integer for this terminal. The
+ *	termios lock must be held by the caller and the terminal bit
+ *	flags may be updated.
+ *
+ *	Locking: none
+ */
+static inline speed_t tty_get_baud_rate(struct tty_struct *tty)
+{
+	return tty_termios_baud_rate(&tty->termios);
+}
+
 extern void tty_termios_copy_hw(struct ktermios *new, struct ktermios *old);
 extern int tty_termios_hw_change(struct ktermios *a, struct ktermios *b);
 extern int tty_set_termios(struct tty_struct *tty, struct ktermios *kt);
-- 
1.8.1.4


