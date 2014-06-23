Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbaFWTEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:04:01 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:32907 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbaFWTD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:03:58 -0400
Message-Id: <20140623190345.499956567@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jun 2014 22:54:34 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 3/4] timerfd: Implement timerfd_ioctl method to restore timerfd_ctx::ticks
References: <20140623185431.396309193@openvz.org>
Content-Disposition: inline; filename=timerfd-ticks-ioctl-3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The read() of timerfd files allows to fetch the number of timer ticks
while there is no way to set it back from userspace.

To restore the timer's state as it was at checkpoint moment we need
a path to bring @ticks back. Initially I thought about writing ticks
back via write() interface but it seems such API is somehow obscure.

Instead implement timerfd_ioctl() method with TFD_IOC_SET_TICKS
command which allows to adjust @ticks into non-zero value waking
up the waiters. The reason to forbid from 

I wrapped code with CONFIG_CHECKPOINT_RESTORE which can be
dropped off if there users except c/r camp appear.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andrey Vagin <avagin@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/timerfd.c            |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/timerfd.h |    5 +++++
 2 files changed, 42 insertions(+)

Index: linux-2.6.git/fs/timerfd.c
===================================================================
--- linux-2.6.git.orig/fs/timerfd.c
+++ linux-2.6.git/fs/timerfd.c
@@ -313,11 +313,48 @@ static int timerfd_show(struct seq_file
 }
 #endif
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static long timerfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	int ret = 0;
+
+	switch (cmd) {
+	case TFD_IOC_SET_TICKS: {
+		u64 ticks;
+
+		if (get_user(ticks, (u64 __user *)arg))
+			return -EFAULT;
+		if (!ticks)
+			return -EINVAL;
+
+		spin_lock_irq(&ctx->wqh.lock);
+		if (!timerfd_canceled(ctx)) {
+			ctx->ticks = ticks;
+			if (ticks)
+				wake_up_locked(&ctx->wqh);
+		} else
+			ret = -ECANCELED;
+		spin_unlock_irq(&ctx->wqh.lock);
+		break;
+	}
+	default:
+		ret = -ENOTTY;
+		break;
+	}
+
+	return ret;
+}
+#endif
+
 static const struct file_operations timerfd_fops = {
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
 	.llseek		= noop_llseek,
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	.unlocked_ioctl	= timerfd_ioctl,
+#endif
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	= timerfd_show,
 #endif
Index: linux-2.6.git/include/linux/timerfd.h
===================================================================
--- linux-2.6.git.orig/include/linux/timerfd.h
+++ linux-2.6.git/include/linux/timerfd.h
@@ -11,6 +11,9 @@
 /* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 
+/* For _IO helpers */
+#include <linux/ioctl.h>
+
 /*
  * CAREFUL: Check include/asm-generic/fcntl.h when defining
  * new flags, since they might collide with O_* ones. We want
@@ -29,4 +32,6 @@
 /* Flags for timerfd_settime.  */
 #define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET)
 
+#define TFD_IOC_SET_TICKS	_IOW('T', 0, u64)
+
 #endif /* _LINUX_TIMERFD_H */

