Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3EJOVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57100 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289Ab3EJOU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jiri Slaby" <jslaby@suse.cz>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.220465964@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [075/118] TTY: fix atime/mtime regression
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: For 3.2, use Greg's backported version]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/tty_io.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -940,6 +940,14 @@ void start_tty(struct tty_struct *tty)
 
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
@@ -977,6 +985,9 @@ static ssize_t tty_read(struct file *fil
 		i = -EIO;
 	tty_ldisc_deref(ld);
 
+	if (i > 0)
+		tty_update_time(&inode->i_atime);
+
 	return i;
 }
 
@@ -1077,8 +1088,11 @@ static inline ssize_t do_tty_write(
 			break;
 		cond_resched();
 	}
-	if (written)
+	if (written) {
+               struct inode *inode = file->f_path.dentry->d_inode;
+		tty_update_time(&inode->i_mtime);
 		ret = written;
+	}
 out:
 	tty_write_unlock(tty);
 	return ret;

