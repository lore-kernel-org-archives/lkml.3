Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab3EJOjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:39:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57104 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914Ab3EJOU5 (ORCPT
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
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Simon Kirby" <sim@hostway.ca>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.961534784@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [076/118] tty: fix up atime/mtime mess, take three
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/pty.c    |    3 +++
 drivers/tty/tty_io.c |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -669,6 +669,9 @@ static int ptmx_open(struct inode *inode
 
 	nonseekable_open(inode, filp);
 
+	/* We refuse fsnotify events on ptmx, since it's a shared resource */
+	filp->f_mode |= FMODE_NONOTIFY;
+
 	retval = tty_alloc_file(filp);
 	if (retval)
 		return retval;
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -940,10 +940,10 @@ void start_tty(struct tty_struct *tty)
 
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

