Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaEPMt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:49:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49661 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbaEPMsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "" <stable@vger.kernel.org>, "Jiri Slaby" <jslaby@suse.cz>,
        "Peter Hurley" <peter@hurleysoftware.com>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.938704882@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 32/34] n_tty: Fix n_tty_write crash when echoing in
 raw mode
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: output_lock is a member of struct tty_struct]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/n_tty.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1997,7 +1997,9 @@ static ssize_t n_tty_write(struct tty_st
 				tty->ops->flush_chars(tty);
 		} else {
 			while (nr > 0) {
+				mutex_lock(&tty->output_lock);
 				c = tty->ops->write(tty, b, nr);
+				mutex_unlock(&tty->output_lock);
 				if (c < 0) {
 					retval = c;
 					goto break_out;

