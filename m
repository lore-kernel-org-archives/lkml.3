Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbaEFUmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:42:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbaEFUmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:42:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Hurley <peter@hurleysoftware.com>, Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 1/3] n_tty: Fix n_tty_write crash when echoing in raw mode
Date: Tue,  6 May 2014 13:42:18 -0700
Message-Id: <1399408940-22784-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399408940-22784-1-git-send-email-kamal@canonical.com>
References: <1399408940-22784-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/n_tty.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 4c10837..86093e2 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2345,8 +2345,12 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			if (tty->ops->flush_chars)
 				tty->ops->flush_chars(tty);
 		} else {
+			struct n_tty_data *ldata = tty->disc_data;
+
 			while (nr > 0) {
+				mutex_lock(&ldata->output_lock);
 				c = tty->ops->write(tty, b, nr);
+				mutex_unlock(&ldata->output_lock);
 				if (c < 0) {
 					retval = c;
 					goto break_out;
-- 
1.9.1

