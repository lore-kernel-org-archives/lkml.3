Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140Ab3EGEhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:37:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3EGEZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:48 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=RcbTupXiQcIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=8rneXe43vO4A:10 a=iZrv-Rh4AAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=DIF4VlSlHetk7qJ7wO8A:9 a=TEa492JxwlIA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035856.513353857@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [093/126] TTY: do not update atime/mtime on read/write
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0093-TTY-do-not-update-atime-mtime-on-read-write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit b0de59b5733d18b0d1974a060860a8b5c1b36a2e ]

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
Cc: stable <stable@vger.kernel.org> # after 3.9 is out
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/tty_io.c |    8 ++------
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
1.7.10.4


