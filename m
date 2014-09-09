Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaIIF0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:26:40 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35705 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaIIF0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:26:38 -0400
From: John Sung <penmount.touch@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: penmount.touch@gmail.com
Subject: [PATCH v2] Input: serport: Add compat_ioctl routine to support 32bit inputattach in 64bit systems
Date: Tue,  9 Sep 2014 13:20:28 +0800
Message-Id: <1410240028-9377-1-git-send-email-penmount.touch@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running a 32-bit inputattach utility in a 64-bit system, there will be error code "inputattach: can't set device type". This is caused by the serport device driver not supporting compat_ioctl, so that SPIOCSTYPE ioctl fails.

Changes in v2:
(1) Codes of the compat_ioctl are protected by #ifdef CONFIG_COMPAT.
(2) Add a new function serport_set_type() for common codes used by serport_ldisc_ioctl() and serport_ldisc_compat_ioctl().

Signed-off-by: John Sung <penmount.touch@gmail.com>
---
 drivers/input/serio/serport.c |   57 +++++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 0cb7ef5..1decaa2 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -22,6 +22,10 @@
 #include <linux/serio.h>
 #include <linux/tty.h>
 
+#ifdef CONFIG_COMPAT
+#include <linux/compat.h>
+#endif
+
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Input device TTY line discipline");
 MODULE_LICENSE("GPL");
@@ -40,6 +44,30 @@ struct serport {
 	unsigned long flags;
 };
 
+#ifdef CONFIG_COMPAT
+#define SPIOCSTYPE32 (_IOW('q', 0x01, compat_ulong_t))
+#endif
+
+/*
+ * serport_set_type() is called by serport_ldisc_ioctl() and
+ * serport_ldisc_compat_ioctl() to set up the serio_device_id values
+ */
+
+static int serport_set_type(struct tty_struct *tty, unsigned long arg)
+{
+	struct serport *serport = (struct serport *) tty->disc_data;
+	unsigned long type;
+
+	if (get_user(type, (unsigned long __user *) arg))
+		return -EFAULT;
+
+	serport->id.proto = type & 0x000000ff;
+	serport->id.id	  = (type & 0x0000ff00) >> 8;
+	serport->id.extra = (type & 0x00ff0000) >> 16;
+
+	return 0;
+}
+
 /*
  * Callback functions from the serio code.
  */
@@ -204,18 +232,8 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 
 static int serport_ldisc_ioctl(struct tty_struct * tty, struct file * file, unsigned int cmd, unsigned long arg)
 {
-	struct serport *serport = (struct serport*) tty->disc_data;
-	unsigned long type;
-
 	if (cmd == SPIOCSTYPE) {
-		if (get_user(type, (unsigned long __user *) arg))
-			return -EFAULT;
-
-		serport->id.proto = type & 0x000000ff;
-		serport->id.id	  = (type & 0x0000ff00) >> 8;
-		serport->id.extra = (type & 0x00ff0000) >> 16;
-
-		return 0;
+		return serport_set_type(tty, arg);
 	}
 
 	return -EINVAL;
@@ -232,6 +250,20 @@ static void serport_ldisc_write_wakeup(struct tty_struct * tty)
 	spin_unlock_irqrestore(&serport->lock, flags);
 }
 
+#ifdef CONFIG_COMPAT
+/*
+ * serport_ldisc_compat_ioctl() allows to set the port protocol, and device ID
+ */
+
+static long serport_ldisc_compat_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg)
+{
+	if (cmd == SPIOCSTYPE32)
+		return serport_set_type(tty, arg);
+
+	return -EINVAL;
+}
+#endif
+
 /*
  * The line discipline structure.
  */
@@ -243,6 +275,9 @@ static struct tty_ldisc_ops serport_ldisc = {
 	.close =	serport_ldisc_close,
 	.read =		serport_ldisc_read,
 	.ioctl =	serport_ldisc_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =	serport_ldisc_compat_ioctl,
+#endif
 	.receive_buf =	serport_ldisc_receive,
 	.write_wakeup =	serport_ldisc_write_wakeup
 };
-- 
1.7.9.5

