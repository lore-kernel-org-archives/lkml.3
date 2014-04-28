Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbaD1Vd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:33:29 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:37894 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074AbaD1VdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:33:09 -0400
Message-Id: <20140428213301.507657833@openvz.org>
User-Agent: quilt/0.60-1
Date: Tue, 29 Apr 2014 01:25:20 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: shawn@churchofgit.com, tglx@linutronix.de, akpm@linux-foundation.org,
        avagin@openvz.org, xemul@parallels.com, gorcunov@openvz.org,
        vdavydov@parallels.com
Subject: [patch 3/3] timerfd: Implement write method
References: <20140428212517.200264067@openvz.org>
Content-Disposition: inline; filename=timerfd-write-ticks
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
CC: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/timerfd.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6.git/fs/timerfd.c
===================================================================
--- linux-2.6.git.orig/fs/timerfd.c
+++ linux-2.6.git/fs/timerfd.c
@@ -311,10 +311,31 @@ static int timerfd_show(struct seq_file
 			  (unsigned long long)t.it_interval.tv_nsec);
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

