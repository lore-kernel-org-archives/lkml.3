Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaCaSCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:02:41 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:58168 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaCaSCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:02:39 -0400
Date: Mon, 31 Mar 2014 22:02:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: shawn@churchofgit.com, tglx@linutronix.de, akpm@linux-foundation.org,
        avagin@openvz.org, xemul@parallels.com
Subject: [rfc ] timerfd: Implement write method
Message-ID: <20140331180237.GL4872@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The read() of timerfd files allows to fetch the number of
timer ticks while there is no way to set it back from userspace.

To restore the timer state as it was at checkpoint moment we need
a way to setup ticks back. So as a counterpart of read() the write()
takes ticks number from the userspace and updates internal timer
ticks accordingly.

CC: Shawn Landden <shawn@churchofgit.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andrey Vagin <avagin@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

This is a third patch in the series, I've screwed quilt mail command.

 fs/timerfd.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6.git/fs/timerfd.c
===================================================================
--- linux-2.6.git.orig/fs/timerfd.c
+++ linux-2.6.git/fs/timerfd.c
@@ -292,10 +292,31 @@ static int timerfd_show(struct seq_file
 			  ctx->clockid, (unsigned long long)ctx->ticks);
 }
 
+
+static ssize_t timerfd_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	u64 ticks = 0;
+
+	if (count < sizeof(ticks))
+		return -EINVAL;
+
+	if (get_user(ticks, (u64 __user *) buf))
+		return -EFAULT;
+
+	spin_lock_irq(&ctx->wqh.lock);
+	ctx->ticks = ticks;
+	spin_unlock_irq(&ctx->wqh.lock);
+
+	return sizeof(ticks);
+}
+
 static const struct file_operations timerfd_fops = {
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
+	.write		= timerfd_write,
 	.llseek		= noop_llseek,
 	.show_fdinfo	= timerfd_show,
 };
