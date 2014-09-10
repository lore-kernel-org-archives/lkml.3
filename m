Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaIJTpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:45:22 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40343 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753342AbaIJTpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:45:18 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 12/14] tty: Move and rename send_prio_char() as tty_send_xchar()
Date: Wed, 10 Sep 2014 15:06:34 -0400
Message-Id: <1410375996-4693-13-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relocate the file-scope function, send_prio_char(), as a global
helper tty_send_xchar(). Remove the global declarations for
tty_write_lock()/tty_write_unlock(), as these are file-scope only now.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c    | 33 +++++++++++++++++++++++++++++++--
 drivers/tty/tty_ioctl.c | 33 ++-------------------------------
 include/linux/tty.h     |  3 +--
 3 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 55b9103..54e359b 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1037,14 +1037,14 @@ static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 	return i;
 }
 
-void tty_write_unlock(struct tty_struct *tty)
+static void tty_write_unlock(struct tty_struct *tty)
 	__releases(&tty->atomic_write_lock)
 {
 	mutex_unlock(&tty->atomic_write_lock);
 	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
 }
 
-int tty_write_lock(struct tty_struct *tty, int ndelay)
+static int tty_write_lock(struct tty_struct *tty, int ndelay)
 	__acquires(&tty->atomic_write_lock)
 {
 	if (!mutex_trylock(&tty->atomic_write_lock)) {
@@ -1231,6 +1231,35 @@ ssize_t redirected_tty_write(struct file *file, const char __user *buf,
 	return tty_write(file, buf, count, ppos);
 }
 
+/**
+ *	tty_send_xchar	-	send priority character
+ *
+ *	Send a high priority character to the tty even if stopped
+ *
+ *	Locking: none for xchar method, write ordering for write method.
+ */
+
+int tty_send_xchar(struct tty_struct *tty, char ch)
+{
+	int	was_stopped = tty->stopped;
+
+	if (tty->ops->send_xchar) {
+		tty->ops->send_xchar(tty, ch);
+		return 0;
+	}
+
+	if (tty_write_lock(tty, 0) < 0)
+		return -ERESTARTSYS;
+
+	if (was_stopped)
+		start_tty(tty);
+	tty->ops->write(tty, &ch, 1);
+	if (was_stopped)
+		stop_tty(tty);
+	tty_write_unlock(tty);
+	return 0;
+}
+
 static char ptychar[] = "pqrstuvwxyzabcde";
 
 /**
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index ffed466..14d9002 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -912,35 +912,6 @@ static int set_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 #endif
 
 /**
- *	send_prio_char		-	send priority character
- *
- *	Send a high priority character to the tty even if stopped
- *
- *	Locking: none for xchar method, write ordering for write method.
- */
-
-static int send_prio_char(struct tty_struct *tty, char ch)
-{
-	int	was_stopped = tty->stopped;
-
-	if (tty->ops->send_xchar) {
-		tty->ops->send_xchar(tty, ch);
-		return 0;
-	}
-
-	if (tty_write_lock(tty, 0) < 0)
-		return -ERESTARTSYS;
-
-	if (was_stopped)
-		start_tty(tty);
-	tty->ops->write(tty, &ch, 1);
-	if (was_stopped)
-		stop_tty(tty);
-	tty_write_unlock(tty);
-	return 0;
-}
-
-/**
  *	tty_change_softcar	-	carrier change ioctl helper
  *	@tty: tty to update
  *	@arg: enable/disable CLOCAL
@@ -1194,11 +1165,11 @@ int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 			break;
 		case TCIOFF:
 			if (STOP_CHAR(tty) != __DISABLED_CHAR)
-				return send_prio_char(tty, STOP_CHAR(tty));
+				return tty_send_xchar(tty, STOP_CHAR(tty));
 			break;
 		case TCION:
 			if (START_CHAR(tty) != __DISABLED_CHAR)
-				return send_prio_char(tty, START_CHAR(tty));
+				return tty_send_xchar(tty, START_CHAR(tty));
 			break;
 		default:
 			return -EINVAL;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 377896d..3c1276b 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -418,6 +418,7 @@ extern void tty_unregister_device(struct tty_driver *driver, unsigned index);
 extern int tty_read_raw_data(struct tty_struct *tty, unsigned char *bufp,
 			     int buflen);
 extern void tty_write_message(struct tty_struct *tty, char *msg);
+extern int tty_send_xchar(struct tty_struct *tty, char ch);
 extern int tty_put_char(struct tty_struct *tty, unsigned char c);
 extern int tty_chars_in_buffer(struct tty_struct *tty);
 extern int tty_write_room(struct tty_struct *tty);
@@ -504,8 +505,6 @@ extern struct tty_struct *tty_pair_get_pty(struct tty_struct *tty);
 extern struct mutex tty_mutex;
 extern spinlock_t tty_files_lock;
 
-extern void tty_write_unlock(struct tty_struct *tty);
-extern int tty_write_lock(struct tty_struct *tty, int ndelay);
 #define tty_is_writelocked(tty)  (mutex_is_locked(&tty->atomic_write_lock))
 
 extern void tty_port_init(struct tty_port *port);
-- 
2.1.0

