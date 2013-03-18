Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab3CRVVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:21:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671Ab3CRVKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Bryan Mason <bmason@redhat.com>
Subject: [ 14/40] TTY: do not reset masters packet mode
Date: Mon, 18 Mar 2013 14:10:52 -0700
Message-Id: <20130318211017.284127513@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit b81273a132177edd806476b953f6afeb17b786d5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/pty.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -49,7 +49,6 @@ static void pty_close(struct tty_struct
 	tty->packet = 0;
 	if (!tty->link)
 		return;
-	tty->link->packet = 0;
 	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	wake_up_interruptible(&tty->link->read_wait);
 	wake_up_interruptible(&tty->link->write_wait);


