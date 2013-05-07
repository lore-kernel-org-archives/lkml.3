Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab3EGNky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:40:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42152 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598Ab3EGNku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 027/118] TTY: do not update atime/mtime on read/write
Date: Tue,  7 May 2013 14:37:53 +0100
Message-Id: <1367933964-1564-28-git-send-email-luis.henriques@canonical.com>
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

commit b0de59b5733d18b0d1974a060860a8b5c1b36a2e upstream.

On http://vladz.devzero.fr/013_ptmx-timing.php, we can see how to find
out length of a password using timestamps of /dev/ptmx. It is
documented in "Timing Analysis of Keystrokes and Timing Attacks on
SSH". To avoid that problem, do not update time when reading
from/writing to a TTY.

I am afraid of regressions as this is a behavior we have since 0.97
and apps may expect the time to be current, e.g. for monitoring
whether there was a change on the TTY. Now, there is no change. So
this would better have a lot of testing before it goes upstream.

References: CVE-2013-0160

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/tty_io.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b425c79..e0767b7 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -975,8 +975,7 @@ static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 	else
 		i = -EIO;
 	tty_ldisc_deref(ld);
-	if (i > 0)
-		inode->i_atime = current_fs_time(inode->i_sb);
+
 	return i;
 }
 
@@ -1077,11 +1076,8 @@ static inline ssize_t do_tty_write(
 			break;
 		cond_resched();
 	}
-	if (written) {
-		struct inode *inode = file->f_path.dentry->d_inode;
-		inode->i_mtime = current_fs_time(inode->i_sb);
+	if (written)
 		ret = written;
-	}
 out:
 	tty_write_unlock(tty);
 	return ret;
-- 
1.8.1.2

