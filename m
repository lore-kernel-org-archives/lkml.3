Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab3EGNmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:42:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42639 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933420Ab3EGNmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 115/118] tty: fix up atime/mtime mess, take three
Date: Tue,  7 May 2013 14:39:21 +0100
Message-Id: <1367933964-1564-116-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit b0b885657b6c8ef63a46bc9299b2a7715d19acde upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/pty.c    | 3 +++
 drivers/tty/tty_io.c | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index ce53594..33b1526 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -616,6 +616,9 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
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
1.8.1.2

