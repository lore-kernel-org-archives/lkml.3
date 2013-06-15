Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3FOO3c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:29:32 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40633 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3FOO14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:27:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 20/20] tty: Remove extra wakeup from pty write() path
Date: Sat, 15 Jun 2013 10:21:36 -0400
Message-Id: <1371306096-5571-21-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
References: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
 <1371306096-5571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acquiring the write_wait queue spin lock now accounts for the largest
slice of cpu time on the tty write path. Two factors contribute to
this situation; a overly-pessimistic line discipline write loop which
_always_ sets up a wait loop even if i/o will immediately succeed, and
on ptys, a wakeup storm from reads and writes.

Writer wakeup does not need to be performed by the pty driver.
Firstly, since the actual i/o is performed within the write, the
line discipline write loop will continue while space remains in
the flip buffers. Secondly, when space becomes avail in the
line discipline receive buffer (and thus also in the flip buffers),
the pty unthrottle re-wakes the writer (non-flow-controlled line
disciplines unconditionally unthrottle the driver when data is
received). Thus, existing in-kernel i/o is guaranteed to advance.
Finally, writer wakeup occurs at the conclusion of the line discipline
write (in tty_write_unlock()). This guarantees that any user-space write
waiters are woken to continue additional i/o.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 0634dd9..b9bc5be 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -121,10 +121,8 @@ static int pty_write(struct tty_struct *tty, const unsigned char *buf, int c)
 		/* Stuff the data into the input queue of the other end */
 		c = tty_insert_flip_string(to->port, buf, c);
 		/* And shovel */
-		if (c) {
+		if (c)
 			tty_flip_buffer_push(to->port);
-			tty_wakeup(tty);
-		}
 	}
 	return c;
 }
-- 
1.8.1.2

