Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaELBmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:42:22 -0400
Received: from 1wt.eu ([62.212.114.60]:34515 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbaELBmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:18 -0400
Message-Id: <20140512003206.005845696@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Peter Hurley <peter@hurleysoftware.com>, Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 128/143] n_tty: Fix n_tty_write crash when echoing in raw mode
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 4291086b1f081b869c6d79e5b7441633dc3ace00)
[wt: 2.6.32 has no n_tty_data, so output_lock is in tty, not tty->disc_data]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/n_tty.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 2e50f4d..5269fa0 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1969,7 +1969,9 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 				tty->ops->flush_chars(tty);
 		} else {
 			while (nr > 0) {
+				mutex_lock(&tty->output_lock);
 				c = tty->ops->write(tty, b, nr);
+				mutex_unlock(&tty->output_lock);
 				if (c < 0) {
 					retval = c;
 					goto break_out;
-- 
1.7.12.2.21.g234cd45.dirty



