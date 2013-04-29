Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658Ab3D2TDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:03:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759276Ab3D2TC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [ 02/34] TTY: do not update atime/mtime on read/write
Date: Mon, 29 Apr 2013 12:02:09 -0700
Message-Id: <20130429184701.149261120@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/tty_io.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -974,8 +974,7 @@ static ssize_t tty_read(struct file *fil
 	else
 		i = -EIO;
 	tty_ldisc_deref(ld);
-	if (i > 0)
-		inode->i_atime = current_fs_time(inode->i_sb);
+
 	return i;
 }
 
@@ -1076,11 +1075,8 @@ static inline ssize_t do_tty_write(
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


