Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab3AOW0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:26:34 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49861 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab3AOW0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:26:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Bryan Mason <bmason@redhat.com>
Subject: [PATCH] TTY: do not reset master's packet mode
Date: Tue, 15 Jan 2013 23:26:22 +0100
Message-Id: <1358288782-2946-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that login from util-linux is forced to drop all references to a
TTY which it wants to hangup (to reach reference count 1) we are
seeing issues with telnet. When login closes its last reference to the
slave PTY, it also resets packet mode on the *master* side. And we
have a race here.

What telnet does is fork+exec of `login'. Then there are two
scenarios:
* `login' closes the slave TTY and resets thus master's packet mode,
  but even now telnet properly sets the mode, or
* `telnetd' sets packet mode on the master, `login' closes the slave
  TTY and resets master's packet mode.

The former case is OK. However the latter happens in much more cases,
by the order of magnitude to be precise. So when one tries to login to
such a messed telnet setup, they see the following:
inux login:
            ogin incorrect

Note the missing first letters -- telnet thinks it is still in the
packet mode, so when it receives "linux login" from `login', it
considers "l" as the type of the packet and strips it.

SuS does not mention how the implementation should behave. Both BSDs I
checked (Free and Net) do not reset the flag upon the last close.

By this I am resurrecting an old bug, see References. We are hitting
it regularly now, i.e. with updated util-linux, ergo login.

Here, I am changing a behavior introduced back in 2.1 times. It would
better have a long time testing before goes upstream.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Bryan Mason <bmason@redhat.com>
References: https://lkml.org/lkml/2009/11/11/223
References: https://bugzilla.redhat.com/show_bug.cgi?id=504703
References: https://bugzilla.novell.com/show_bug.cgi?id=797042
---
 drivers/tty/pty.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index d2fd6f0..d7690dcf 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -47,7 +47,6 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	/* Review - krefs on tty_link ?? */
 	if (!tty->link)
 		return;
-	tty->link->packet = 0;
 	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	wake_up_interruptible(&tty->link->read_wait);
 	wake_up_interruptible(&tty->link->write_wait);
-- 
1.8.1


