Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab3ERC02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:26:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3ERCQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:50 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=gwxVV7jKYfcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=oxUd5eQyvA0A:10 a=Z4Rwk6OoAAAA:8 a=ag1SF4gXAAAA:8 a=VwQbUJbxAAAA:8 a=yfpj6zPZQAq4tnQM2tIA:9 a=jbrJJM5MRmoA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021646.223356880@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Simon Kirby <sim@hostway.ca>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 028/136 ] tty: fix up atime/mtime mess, take three
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0028-tty-fix-up-atime-mtime-mess-take-three.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit b0b885657b6c8ef63a46bc9299b2a7715d19acde ]

We first tried to avoid updating atime/mtime entirely (commit
b0de59b5733d: "TTY: do not update atime/mtime on read/write"), and then
limited it to only update it occasionally (commit 37b7f3c76595: "TTY:
fix atime/mtime regression"), but it turns out that this was both
insufficient and overkill.

It was insufficient because we let people attach to the shared ptmx node
to see activity without even reading atime/mtime, and it was overkill
because the "only once a minute" means that you can't really tell an
idle person from an active one with 'w'.

So this tries to fix the problem properly.  It marks the shared ptmx
node as un-notifiable, and it lowers the "only once a minute" to a few
seconds instead - still long enough that you can't time individual
keystrokes, but short enough that you can tell whether somebody is
active or not.

Reported-by: Simon Kirby <sim@hostway.ca>
Acked-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/pty.c    |    3 +++
 drivers/tty/tty_io.c |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 5505ffc..c2e6fd4 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -617,6 +617,9 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	nonseekable_open(inode, filp);
 
+	/* We refuse fsnotify events on ptmx, since it's a shared resource */
+	filp->f_mode |= FMODE_NONOTIFY;
+
 	retval = tty_alloc_file(filp);
 	if (retval)
 		return retval;
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 95a37fa..67ea9cf 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -939,10 +939,10 @@ void start_tty(struct tty_struct *tty)
 
 EXPORT_SYMBOL(start_tty);
 
+/* We limit tty time update visibility to every 8 seconds or so. */
 static void tty_update_time(struct timespec *time)
 {
-	unsigned long sec = get_seconds();
-	sec -= sec % 60;
+	unsigned long sec = get_seconds() & ~7;
 	if ((long)(sec - time->tv_sec) > 0)
 		time->tv_sec = sec;
 }
-- 
1.7.10.4


