Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab3D2TtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:49:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761Ab3D2TC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 03/42] TTY: fix atime/mtime regression
Date: Mon, 29 Apr 2013 12:01:45 -0700
Message-Id: <20130429184752.796052982@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_io.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -941,6 +941,14 @@ void start_tty(struct tty_struct *tty)
 
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
@@ -978,6 +986,9 @@ static ssize_t tty_read(struct file *fil
 		i = -EIO;
 	tty_ldisc_deref(ld);
 
+	if (i > 0)
+		tty_update_time(&inode->i_atime);
+
 	return i;
 }
 
@@ -1078,8 +1089,11 @@ static inline ssize_t do_tty_write(
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


