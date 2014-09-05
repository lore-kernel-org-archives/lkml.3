Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbaIENFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:05:31 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62964 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbaIENF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:05:29 -0400
From: John Sung <penmount.touch@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: penmount.touch@gmail.com
Subject: [PATCH] Input: serport: Add compat_ioctl routine to support 32bit inputtattach in 64bit systems
Date: Fri,  5 Sep 2014 21:04:37 +0800
Message-Id: <1409922277-4497-1-git-send-email-penmount.touch@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running a 32-bit inputattach utility in a 64-bit system, there will be error code "inputattach: can't set device type". This is caused by the serport device driver not supporting compat_ioctl, so that SPIOCSTYPE ioctl fails.

Signed-off-by: John Sung <penmount.touch@gmail.com>
---
 drivers/input/serio/serport.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 0cb7ef5..4b68c29 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -22,6 +22,8 @@
 #include <linux/serio.h>
 #include <linux/tty.h>
 
+#include <asm/compat.h>
+
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Input device TTY line discipline");
 MODULE_LICENSE("GPL");
@@ -31,6 +33,8 @@ MODULE_ALIAS_LDISC(N_MOUSE);
 #define SERPORT_ACTIVE	2
 #define SERPORT_DEAD	3
 
+#define SPIOCSTYPE32 (_IOW('q', 0x01, compat_ulong_t))
+
 struct serport {
 	struct tty_struct *tty;
 	wait_queue_head_t wait;
@@ -221,6 +225,25 @@ static int serport_ldisc_ioctl(struct tty_struct * tty, struct file * file, unsi
 	return -EINVAL;
 }
 
+static long serport_ldisc_compat_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct serport *serport = (struct serport*) tty->disc_data;
+	unsigned long type;
+
+	if (cmd == SPIOCSTYPE32) {
+		if (get_user(type, (unsigned long __user *) arg))
+			return -EFAULT;
+
+		serport->id.proto = type & 0x000000ff;
+		serport->id.id	  = (type & 0x0000ff00) >> 8;
+		serport->id.extra = (type & 0x00ff0000) >> 16;
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static void serport_ldisc_write_wakeup(struct tty_struct * tty)
 {
 	struct serport *serport = (struct serport *) tty->disc_data;
@@ -243,6 +266,7 @@ static struct tty_ldisc_ops serport_ldisc = {
 	.close =	serport_ldisc_close,
 	.read =		serport_ldisc_read,
 	.ioctl =	serport_ldisc_ioctl,
+	.compat_ioctl =	serport_ldisc_compat_ioctl,
 	.receive_buf =	serport_ldisc_receive,
 	.write_wakeup =	serport_ldisc_write_wakeup
 };
-- 
1.7.9.5

