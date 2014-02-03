Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaBCQKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:10:37 -0500
Received: from churchofgit.com ([198.20.106.155]:40431 "EHLO
	www.churchofgit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaBCQKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:10:35 -0500
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Feb 2014 11:10:35 EST
From: Shawn Landden <shawn@churchofgit.com>
Cc: criu@openvz.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, avagin@gmail.com,
        Shawn Landden <shawn@churchofgit.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] timerfd: show procfs fdinfo helper, and now accepts write()
Date: Mon,  3 Feb 2014 08:01:13 -0800
Message-Id: <1391443273-2031-1-git-send-email-shawn@churchofgit.com>
X-Mailer: git-send-email 1.8.5.2.297.g3e57c29
In-Reply-To: <20140203104430.GA21968@paralelels.com>
References: <20140203104430.GA21968@paralelels.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| pos:	0
| flags:	02004002
| clockid:	0
| ticks:        6

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Shawn Landden <shawn@churchofgit.com>
---
 fs/timerfd.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 9293121..2e81bdb 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -25,6 +25,7 @@
 #include <linux/syscalls.h>
 #include <linux/compat.h>
 #include <linux/rcupdate.h>
+#include <linux/seq_file.h>
 
 struct timerfd_ctx {
 	union {
@@ -284,10 +285,73 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 	return res;
 }
 
+#ifdef CONFIG_PROC_FS
+static int timerfd_show_fdinfo(struct seq_file *m, struct file *f)
+{
+	struct timerfd_ctx *ctx = f->private_data;
+
+	seq_printf(m, "clockid:\t%d\n"
+		      "ticks:\t%llu\n", ctx->clockid, ctx->ticks);
+
+	return 0;
+}
+#endif
+
+static ssize_t timerfd_write(struct file *file, const char __user *buf, size_t count,
+			 loff_t *ppos)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	ssize_t res;
+	__u64 ucnt;
+	DECLARE_WAITQUEUE(wait, current);
+
+	if (count < sizeof(ucnt))
+		return -EINVAL;
+	if (copy_from_user(&ucnt, buf, sizeof(ucnt)))
+		return -EFAULT;
+	if (ucnt == ULLONG_MAX)
+		return -EINVAL;
+	spin_lock_irq(&ctx->wqh.lock);
+	res = -EAGAIN;
+	if (ULLONG_MAX - ctx->ticks > ucnt)
+		res = sizeof(ucnt);
+	else if (!(file->f_flags & O_NONBLOCK)) {
+		__add_wait_queue(&ctx->wqh, &wait);
+		for (res = 0;;) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (ULLONG_MAX - ctx->ticks > ucnt) {
+				res = sizeof(ucnt);
+				break;
+			}
+			if (signal_pending(current)) {
+				res = -ERESTARTSYS;
+				break;
+			}
+			spin_unlock_irq(&ctx->wqh.lock);
+			schedule();
+			spin_lock_irq(&ctx->wqh.lock);
+		}
+		__remove_wait_queue(&ctx->wqh, &wait);
+		__set_current_state(TASK_RUNNING);
+	}
+	if (likely(res > 0)) {
+		ctx->ticks += ucnt;
+		if (waitqueue_active(&ctx->wqh))
+			wake_up_locked_poll(&ctx->wqh, POLLIN);
+	}
+	spin_unlock_irq(&ctx->wqh.lock);
+
+	return res;
+}
+
 static const struct file_operations timerfd_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= timerfd_show_fdinfo,
+#endif
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
+	.write		= timerfd_write,
 	.llseek		= noop_llseek,
 };
 
-- 
1.8.5.2.297.g3e57c29

