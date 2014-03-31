Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaCaSAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:00:07 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:54961 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbaCaSAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:00:00 -0400
Message-Id: <20140331175957.509391054@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 31 Mar 2014 21:54:08 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: shawn@churchofgit.com, tglx@linutronix.de, akpm@linux-foundation.org,
        avagin@openvz.org, xemul@parallels.com, gorcunov@openvz.org
Subject: [rfc 1/2] timerfd: Implement show_fdinfo method
References: <20140331175407.400476950@openvz.org>
Content-Disposition: inline; filename=timerfd-show-fdinfo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For checkpoint/restore of timerfd files we need to know the clock
type being used on timerfd creation. Thus implement show_fdinfo
method where we print out the type.

Also to minimize the number of calls print out the ticks as well
(thus one read of fdinfo entry would eliminate the need of doing
 read() over timerfd itself).

CC: Shawn Landden <shawn@churchofgit.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andrey Vagin <avagin@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/timerfd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.git/fs/timerfd.c
===================================================================
--- linux-2.6.git.orig/fs/timerfd.c
+++ linux-2.6.git/fs/timerfd.c
@@ -284,11 +284,20 @@ static ssize_t timerfd_read(struct file
 	return res;
 }
 
+static int timerfd_show(struct seq_file *m, struct file *file)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+
+	return seq_printf(m, "clockid: %d ticks: %llu\n",
+			  ctx->clockid, (unsigned long long)ctx->ticks);
+}
+
 static const struct file_operations timerfd_fops = {
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
 	.llseek		= noop_llseek,
+	.show_fdinfo	= timerfd_show,
 };
 
 static int timerfd_fget(int fd, struct fd *p)

