Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbaJIVYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:24:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59479 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702AbaJIVK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: John Sung <penmount.touch@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 048/163] Input: serport - add compat handling for SPIOCSTYPE ioctl
Date: Thu,  9 Oct 2014 14:01:13 -0700
Message-Id: <1412888588-26755-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Sung <penmount.touch@gmail.com>

commit a80d8b02751060a178bb1f7a6b7a93645a7a308b upstream.

When running a 32-bit inputattach utility in a 64-bit system, there will be
error code "inputattach: can't set device type". This is caused by the
serport device driver not supporting compat_ioctl, so that SPIOCSTYPE ioctl
fails.

Signed-off-by: John Sung <penmount.touch@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/serio/serport.c | 45 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 8755f5f..e4ecf3b 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/serio.h>
 #include <linux/tty.h>
+#include <linux/compat.h>
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Input device TTY line discipline");
@@ -196,28 +197,55 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 	return 0;
 }
 
+static void serport_set_type(struct tty_struct *tty, unsigned long type)
+{
+	struct serport *serport = tty->disc_data;
+
+	serport->id.proto = type & 0x000000ff;
+	serport->id.id    = (type & 0x0000ff00) >> 8;
+	serport->id.extra = (type & 0x00ff0000) >> 16;
+}
+
 /*
  * serport_ldisc_ioctl() allows to set the port protocol, and device ID
  */
 
-static int serport_ldisc_ioctl(struct tty_struct * tty, struct file * file, unsigned int cmd, unsigned long arg)
+static int serport_ldisc_ioctl(struct tty_struct *tty, struct file *file,
+			       unsigned int cmd, unsigned long arg)
 {
-	struct serport *serport = (struct serport*) tty->disc_data;
-	unsigned long type;
-
 	if (cmd == SPIOCSTYPE) {
+		unsigned long type;
+
 		if (get_user(type, (unsigned long __user *) arg))
 			return -EFAULT;
 
-		serport->id.proto = type & 0x000000ff;
-		serport->id.id	  = (type & 0x0000ff00) >> 8;
-		serport->id.extra = (type & 0x00ff0000) >> 16;
+		serport_set_type(tty, type);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+#ifdef CONFIG_COMPAT
+#define COMPAT_SPIOCSTYPE	_IOW('q', 0x01, compat_ulong_t)
+static long serport_ldisc_compat_ioctl(struct tty_struct *tty,
+				       struct file *file,
+				       unsigned int cmd, unsigned long arg)
+{
+	if (cmd == COMPAT_SPIOCSTYPE) {
+		void __user *uarg = compat_ptr(arg);
+		compat_ulong_t compat_type;
+
+		if (get_user(compat_type, (compat_ulong_t __user *)uarg))
+			return -EFAULT;
 
+		serport_set_type(tty, compat_type);
 		return 0;
 	}
 
 	return -EINVAL;
 }
+#endif
 
 static void serport_ldisc_write_wakeup(struct tty_struct * tty)
 {
@@ -241,6 +269,9 @@ static struct tty_ldisc_ops serport_ldisc = {
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
1.9.1

