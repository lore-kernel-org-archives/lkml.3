Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbaGRJxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:53:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36341 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761232AbaGRJw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:52:57 -0400
Date: Fri, 18 Jul 2014 02:52:34 -0700
From: tip-bot for Cyrill Gorcunov <tipbot@zytor.com>
Message-ID: <tip-5442e9fbd7c23172a1c9bc736629cd123a9923f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gorcunov@openvz.org, xemul@parallels.com, avagin@openvz.org,
        cov@codeaurora.org, arnd@arndb.de, akpm@linux-foundation.org,
        tglx@linutronix.de, vdavydov@parallels.com, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, xemul@parallels.com, avagin@openvz.org,
        cov@codeaurora.org, arnd@arndb.de, akpm@linux-foundation.org,
        tglx@linutronix.de, vdavydov@parallels.com, mtk.manpages@gmail.com
In-Reply-To: <20140715215703.285617923@openvz.org>
References: <20140715215703.285617923@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timerfd:
  Implement timerfd_ioctl method to restore timerfd_ctx::ticks, v3
Git-Commit-ID: 5442e9fbd7c23172a1c9bc736629cd123a9923f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5442e9fbd7c23172a1c9bc736629cd123a9923f0
Gitweb:     http://git.kernel.org/tip/5442e9fbd7c23172a1c9bc736629cd123a9923f0
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 16 Jul 2014 01:54:54 +0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 18 Jul 2014 11:49:57 +0200

timerfd: Implement timerfd_ioctl method to restore timerfd_ctx::ticks, v3

The read() of timerfd files allows to fetch the number of timer ticks
while there is no way to set it back from userspace.

To restore the timer's state as it was at checkpoint moment we need
a path to bring @ticks back. Initially I thought about writing ticks
back via write() interface but it seems such API is somehow obscure.

Instead implement timerfd_ioctl() method with TFD_IOC_SET_TICKS
command which allows to adjust @ticks into non-zero value waking
up the waiters.

I wrapped code with CONFIG_CHECKPOINT_RESTORE which can be
dropped off if there users except c/r camp appear.

v2 (by akpm@):
 - Use define timerfd_ioctl NULL for non c/r config

v3:
 - Use copy_from_user for @ticks fetching since
   not all arch support get_user for 8 byte argument

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christopher Covington <cov@codeaurora.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Link: http://lkml.kernel.org/r/20140715215703.285617923@openvz.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/timerfd.c            | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/timerfd.h |  5 +++++
 2 files changed, 42 insertions(+)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 77183f0..709603c 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -315,12 +315,49 @@ static int timerfd_show(struct seq_file *m, struct file *file)
 #define timerfd_show NULL
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
+		if (copy_from_user(&ticks, (u64 __user *)arg, sizeof(ticks)))
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
+#else
+#define timerfd_ioctl NULL
+#endif
+
 static const struct file_operations timerfd_fops = {
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
 	.llseek		= noop_llseek,
 	.show_fdinfo	= timerfd_show,
+	.unlocked_ioctl	= timerfd_ioctl,
 };
 
 static int timerfd_fget(int fd, struct fd *p)
diff --git a/include/linux/timerfd.h b/include/linux/timerfd.h
index d3b57fa..bd36ce4 100644
--- a/include/linux/timerfd.h
+++ b/include/linux/timerfd.h
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
