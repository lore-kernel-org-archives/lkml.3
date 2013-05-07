Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab3EGE0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:26:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426Ab3EGEZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:48 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=EcZNaj2my8UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=McHrYNOiYHoA:10 a=ag1SF4gXAAAA:8 a=Z4Rwk6OoAAAA:8 a=UiGBu5yWjQUROtlgEygA:9 a=1TSTQ8KKaH4A:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035856.682670331@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [094/126] TTY: fix atime/mtime regression
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0094-TTY-fix-atime-mtime-regression.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 37b7f3c76595e23257f61bd80b223de8658617ee ]

In commit b0de59b5733d ("TTY: do not update atime/mtime on read/write")
we removed timestamps from tty inodes to fix a security issue and waited
if something breaks.  Well, 'w', the utility to find out logged users
and their inactivity time broke.  It shows that users are inactive since
the time they logged in.

To revert to the old behaviour while still preventing attackers to
guess the password length, we update the timestamps in one-minute
intervals by this patch.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/tty_io.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index e0767b7..95a37fa 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -939,6 +939,14 @@ void start_tty(struct tty_struct *tty)
 
 EXPORT_SYMBOL(start_tty);
 
+static void tty_update_time(struct timespec *time)
+{
+	unsigned long sec = get_seconds();
+	sec -= sec % 60;
+	if ((long)(sec - time->tv_sec) > 0)
+		time->tv_sec = sec;
+}
+
 /**
  *	tty_read	-	read method for tty device files
  *	@file: pointer to tty file
@@ -976,6 +984,9 @@ static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 		i = -EIO;
 	tty_ldisc_deref(ld);
 
+	if (i > 0)
+		tty_update_time(&inode->i_atime);
+
 	return i;
 }
 
@@ -1076,8 +1087,11 @@ static inline ssize_t do_tty_write(
 			break;
 		cond_resched();
 	}
-	if (written)
+	if (written) {
+		struct inode *inode = file->f_path.dentry->d_inode;
+		tty_update_time(&inode->i_mtime);
 		ret = written;
+	}
 out:
 	tty_write_unlock(tty);
 	return ret;
-- 
1.7.10.4


