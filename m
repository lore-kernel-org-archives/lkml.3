Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab3EJOVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57101 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578Ab3EJOU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Slaby" <jslaby@suse.cz>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.312640195@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [074/118] TTY: do not update atime/mtime on read/write
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/tty_io.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -976,8 +976,7 @@ static ssize_t tty_read(struct file *fil
 	else
 		i = -EIO;
 	tty_ldisc_deref(ld);
-	if (i > 0)
-		inode->i_atime = current_fs_time(inode->i_sb);
+
 	return i;
 }
 
@@ -1078,11 +1077,8 @@ static inline ssize_t do_tty_write(
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

