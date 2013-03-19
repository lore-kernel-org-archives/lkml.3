Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852Ab3CSW5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:57:09 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42288 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3CSW5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:57:07 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Min Zhang <mzhang@mvista.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 00/18] lockless n_tty receive path
Date: Tue, 19 Mar 2013 16:21:35 -0400
Message-Id: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements lockless receive from tty flip buffers
to the n_tty read buffer and lockless copy into the user-space
read buffer.

By lockless, I'm referring to the fine-grained read_lock formerly used
to serialize access to the shared n_tty read buffer (which wasn't being
used everywhere it should have been).

In the current n_tty, the read_lock is grabbed a minimum of
3 times per byte!

The read_lock is unnecessary to serialize access between the flip
buffer work and the single reader, as this is a
single-producer/single-consumer pattern.

However, other threads may attempt to read or modify the buffer indices,
notably for buffer flushing and for setting/resetting termios
(there are some others). In addition, termios changes can cause
havoc while the tty flip buffer work is pushing more data.
Read more about that here: https://lkml.org/lkml/2013/2/22/480

Both hurdles are overcome with the same mechanism: converting the
termios_mutex to a r/w semaphore (just a normal one :).

Both the receive_buf() path and the read() path claim a reader lock
on the termios_rwsem. This prevents concurrent changes to termios.
Also, flush_buffer() and TIOCINQ ioctl obtain a write lock on the
termios_rwsem to exclude the flip buffer work and user-space read
from accessing the buffer indices while resetting them.

This patchset also implements a block copy from the read_buf
into the user-space buffer in canonical mode (rather than the
current byte-by-byte method).



Greg,

Unfortunately, this series is dependent on the 'ldsem patchset'.
The reason is that this series abandons tty->receive_room as
a flow control mechanism (because that requires locking),
and the TIOCSETD ioctl _without ldsem_ uses tty->receive_room
to shutoff i/o.


Peter Hurley (18):
  tty: Don't change receive_room for ioctl(TIOCSETD)
  tty: Make ldisc input flow control concurrency-friendly
  tty: Simplify tty buffer/ldisc interface with helper function
  n_tty: Factor canonical mode copy from n_tty_read()
  n_tty: Line copy to user buffer in canonical mode
  n_tty: Split n_tty_chars_in_buffer() for reader-only interface
  tty: Deprecate ldisc .chars_in_buffer() method
  n_tty: Get read_cnt through accessor
  n_tty: Don't wrap input buffer indices at buffer size
  n_tty: Remove read_cnt
  tty: Convert termios_mutex to termios_rwsem
  n_tty: Access termios values safely
  n_tty: Replace canon_data with index comparison
  n_tty: Make N_TTY ldisc receive path lockless
  n_tty: Reset lnext if canonical mode changes
  n_tty: Fix type mismatches in receive_buf raw copy
  n_tty: Don't wait for buffer work in read() loop
  n_tty: Separate buffer indices to prevent cache-line sharing

 drivers/net/irda/irtty-sir.c |   8 +-
 drivers/tty/n_tty.c          | 550 +++++++++++++++++++++++++++----------------
 drivers/tty/pty.c            |   4 +-
 drivers/tty/tty_buffer.c     |  26 +-
 drivers/tty/tty_io.c         |  14 +-
 drivers/tty/tty_ioctl.c      |  90 +++----
 drivers/tty/tty_ldisc.c      |  13 +-
 drivers/tty/vt/vt.c          |   4 +-
 include/linux/tty.h          |   7 +-
 include/linux/tty_ldisc.h    |   8 +
 10 files changed, 437 insertions(+), 287 deletions(-)

-- 
1.8.1.2

