Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbaEPWwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:52:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428AbaEPWw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:52:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>, Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.4 2/9] n_tty: Fix n_tty_write crash when echoing in raw mode
Date: Fri, 16 May 2014 15:55:25 -0700
Message-Id: <20140516225458.704630668@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140516225458.512693003@linuxfoundation.org>
References: <20140516225458.512693003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

commit 4291086b1f081b869c6d79e5b7441633dc3ace00 upstream.

The tty atomic_write_lock does not provide an exclusion guarantee for
the tty driver if the termios settings are LECHO & !OPOST.  And since
it is unexpected and not allowed to call TTY buffer helpers like
tty_insert_flip_string concurrently, this may lead to crashes when
concurrect writers call pty_write. In that case the following two
writers:
* the ECHOing from a workqueue and
* pty_write from the process
race and can overflow the corresponding TTY buffer like follows.

If we look into tty_insert_flip_string_fixed_flag, there is:
  int space = __tty_buffer_request_room(port, goal, flags);
  struct tty_buffer *tb = port->buf.tail;
  ...
  memcpy(char_buf_ptr(tb, tb->used), chars, space);
  ...
  tb->used += space;

so the race of the two can result in something like this:
              A                                B
__tty_buffer_request_room
                                  __tty_buffer_request_room
memcpy(buf(tb->used), ...)
tb->used += space;
                                  memcpy(buf(tb->used), ...) ->BOOM

B's memcpy is past the tty_buffer due to the previous A's tb->used
increment.

Since the N_TTY line discipline input processing can output
concurrently with a tty write, obtain the N_TTY ldisc output_lock to
serialize echo output with normal tty writes.  This ensures the tty
buffer helper tty_insert_flip_string is not called concurrently and
everything is fine.

Note that this is nicely reproducible by an ordinary user using
forkpty and some setup around that (raw termios + ECHO). And it is
present in kernels at least after commit
d945cb9cce20ac7143c2de8d88b187f62db99bdc (pty: Rework the pty layer to
use the normal buffering logic) in 2.6.31-rc3.

js: add more info to the commit log
js: switch to bool
js: lock unconditionally
js: lock only the tty->ops->write call

References: CVE-2014-0196
Reported-and-tested-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: output_lock is a member of struct tty_struct]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/n_tty.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1996,7 +1996,9 @@ static ssize_t n_tty_write(struct tty_st
 				tty->ops->flush_chars(tty);
 		} else {
 			while (nr > 0) {
+				mutex_lock(&tty->output_lock);
 				c = tty->ops->write(tty, b, nr);
+				mutex_unlock(&tty->output_lock);
 				if (c < 0) {
 					retval = c;
 					goto break_out;


