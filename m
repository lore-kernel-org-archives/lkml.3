Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbaEMKLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933651AbaEMKLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3.12 126/182] n_tty: Fix n_tty_write crash when echoing in raw mode
Date: Tue, 13 May 2014 11:27:58 +0200
Message-Id: <49f309d3ada7e2d5bca1b274048f42c6f71e0b23.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/n_tty.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index d4a89db511b5..bd73dc25b41d 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2350,8 +2350,12 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
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
1.9.3

