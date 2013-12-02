Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab3LBVNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:13:31 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:51335 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759372Ab3LBVMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:12:32 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 2/4] tty: Add flush_nested() tty driver method and accessor
Date: Mon,  2 Dec 2013 16:12:03 -0500
Message-Id: <1386018725-4781-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>
References: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid a lock inversion deadlock, the pty driver must distinguish
when the flush_buffer() caller already holds its own tty_buffer buf->lock
(currently only in N_TTY's receive_buf() path when handling signals).

Extend tty_driver ops interface with the flush_nested() method.
Add the tty_driver_flush_nested() accessor which uses flush_nested()
(if the driver declares it); otherwise, uses tty_driver_flush_buffer().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c        |  4 ++--
 drivers/tty/tty_ioctl.c    | 21 +++++++++++++++++++++
 include/linux/tty.h        |  1 +
 include/linux/tty_driver.h |  1 +
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index bd01d97..72a5c32 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1191,7 +1191,7 @@ static void n_tty_receive_break(struct tty_struct *tty)
 			/* flushing needs exclusive termios_rwsem */
 			up_read(&tty->termios_rwsem);
 			n_tty_flush_buffer(tty);
-			tty_driver_flush_buffer(tty);
+			tty_driver_flush_nested(tty);
 			down_read(&tty->termios_rwsem);
 		}
 		return;
@@ -1271,7 +1271,7 @@ n_tty_receive_signal_char(struct tty_struct *tty, int signal, unsigned char c)
 		/* flushing needs exclusive termios_rwsem */
 		up_read(&tty->termios_rwsem);
 		n_tty_flush_buffer(tty);
-		tty_driver_flush_buffer(tty);
+		tty_driver_flush_nested(tty);
 		down_read(&tty->termios_rwsem);
 	}
 	if (I_IXON(tty))
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 6fd60fe..e64eb23 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -90,6 +90,27 @@ void tty_driver_flush_buffer(struct tty_struct *tty)
 EXPORT_SYMBOL(tty_driver_flush_buffer);
 
 /**
+ *	tty_driver_flush_nested	-	discard internal buffer
+ *	@tty: terminal
+ *
+ *	Line disciplines must call this flavor of tty_driver_flush_buffer()
+ *	if calling from their .receive_buf() method. The pty driver
+ *	in particular requires special handling to avoid a lock inversion
+ *	deadlock (see tty_buffer_flush_nested()).
+ *
+ *	A normal flush_buffer() is performed for drivers without this
+ *	extension.
+ */
+void tty_driver_flush_nested(struct tty_struct *tty)
+{
+	if (tty->ops->flush_nested)
+		tty->ops->flush_nested(tty);
+	else
+		tty_driver_flush_buffer(tty);
+}
+EXPORT_SYMBOL(tty_driver_flush_nested);
+
+/**
  *	tty_throttle		-	flow control
  *	@tty: terminal
  *
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 9d234dc..de1f85f 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -414,6 +414,7 @@ extern int tty_put_char(struct tty_struct *tty, unsigned char c);
 extern int tty_chars_in_buffer(struct tty_struct *tty);
 extern int tty_write_room(struct tty_struct *tty);
 extern void tty_driver_flush_buffer(struct tty_struct *tty);
+extern void tty_driver_flush_nested(struct tty_struct *tty);
 extern void tty_throttle(struct tty_struct *tty);
 extern void tty_unthrottle(struct tty_struct *tty);
 extern int tty_throttle_safe(struct tty_struct *tty);
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 756a609..4937e16 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -269,6 +269,7 @@ struct tty_operations {
 	void (*hangup)(struct tty_struct *tty);
 	int (*break_ctl)(struct tty_struct *tty, int state);
 	void (*flush_buffer)(struct tty_struct *tty);
+	void (*flush_nested)(struct tty_struct *tty);
 	void (*set_ldisc)(struct tty_struct *tty);
 	void (*wait_until_sent)(struct tty_struct *tty, int timeout);
 	void (*send_xchar)(struct tty_struct *tty, char ch);
-- 
1.8.1.2

