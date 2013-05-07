Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab3EGNk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:40:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42157 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab3EGNkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 028/118] TTY: fix atime/mtime regression
Date: Tue,  7 May 2013 14:37:54 +0100
Message-Id: <1367933964-1564-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 37b7f3c76595e23257f61bd80b223de8658617ee upstream.

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
[ luis: backport to 3.5: don't use file_inode() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/tty_io.c | 16 +++++++++++++++-
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
1.8.1.2

