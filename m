Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaKFP4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:56:39 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:59801 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750955AbaKFP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:56:37 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/1] tty: warn on deprecated serial flags
Date: Thu,  6 Nov 2014 16:56:33 +0100
Message-Id: <1415289393-30008-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When somebody calls TIOCSSERIAL ioctl with serial flags to set one of
* ASYNC_SESSION_LOCKOUT
* ASYNC_PGRP_LOCKOUT
* ASYNC_CALLOUT_NOHUP
* ASYNC_AUTOPROBE
nothing happens. We actually ignore the flags for over a decade at
least (I checked 2.6.0).

So start yelling at users who use those flags, that they shouldn't.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
---
 drivers/tty/tty_io.c           | 21 +++++++++++++++++++++
 include/uapi/linux/tty_flags.h |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 1107398a545c..95f330282046 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2728,6 +2728,24 @@ struct tty_struct *tty_pair_get_pty(struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_pair_get_pty);
 
+static void tty_warn_deprecated_flags(struct serial_struct __user *ss)
+{
+	static DEFINE_RATELIMIT_STATE(depr_flags,
+			DEFAULT_RATELIMIT_INTERVAL,
+			DEFAULT_RATELIMIT_BURST);
+	char comm[TASK_COMM_LEN];
+	int flags;
+
+	if (get_user(flags, &ss->flags))
+		return;
+
+	flags &= ASYNC_DEPRECATED;
+
+	if (flags && __ratelimit(&depr_flags))
+		pr_warning("%s: '%s' is using deprecated serial flags (with no effect): %.8x\n",
+				__func__, get_task_comm(comm, current), flags);
+}
+
 /*
  * Split this up, as gcc can choke on it otherwise..
  */
@@ -2859,6 +2877,9 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			break;
 		}
 		break;
+	case TIOCSSERIAL:
+		tty_warn_deprecated_flags(p);
+		break;
 	}
 	if (tty->ops->ioctl) {
 		retval = (tty->ops->ioctl)(tty, cmd, arg);
diff --git a/include/uapi/linux/tty_flags.h b/include/uapi/linux/tty_flags.h
index eefcb483a2c0..879b91713e7c 100644
--- a/include/uapi/linux/tty_flags.h
+++ b/include/uapi/linux/tty_flags.h
@@ -59,6 +59,8 @@
 #define ASYNC_AUTOPROBE		(1U << ASYNCB_AUTOPROBE)
 
 #define ASYNC_FLAGS		((1U << (ASYNCB_LAST_USER + 1)) - 1)
+#define ASYNC_DEPRECATED	(ASYNC_SESSION_LOCKOUT | ASYNC_PGRP_LOCKOUT | \
+		ASYNC_CALLOUT_NOHUP | ASYNC_AUTOPROBE)
 #define ASYNC_USR_MASK		(ASYNC_SPD_MASK|ASYNC_CALLOUT_NOHUP| \
 		ASYNC_LOW_LATENCY)
 #define ASYNC_SPD_CUST		(ASYNC_SPD_HI|ASYNC_SPD_VHI)
-- 
2.1.2

