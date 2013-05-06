Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018Ab3EGACG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:02:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478Ab3EFW47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:56:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Kirby <sim@hostway.ca>, Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 18/63] tty: fix up atime/mtime mess, take three
Date: Mon,  6 May 2013 15:55:56 -0700
Message-Id: <20130506225319.385016629@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225314.802167948@linuxfoundation.org>
References: <20130506225314.802167948@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/pty.c    |    3 +++
 drivers/tty/tty_io.c |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -607,6 +607,9 @@ static int ptmx_open(struct inode *inode
 
 	nonseekable_open(inode, filp);
 
+	/* We refuse fsnotify events on ptmx, since it's a shared resource */
+	filp->f_mode |= FMODE_NONOTIFY;
+
 	retval = tty_alloc_file(filp);
 	if (retval)
 		return retval;
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -938,10 +938,10 @@ void start_tty(struct tty_struct *tty)
 
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


