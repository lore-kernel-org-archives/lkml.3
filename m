Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3DOPT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:19:57 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:44709 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab3DOPTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:19:55 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 00/24] lockless n_tty receive path
Date: Mon, 15 Apr 2013 11:19:04 -0400
Message-Id: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is now the 1st of 4 patchsets which implements an almost
entirely lockless receive path from driver to user-space.

Non-rigorous performance measurements show a 9~15x speed improvement
on SMP in end-to-end copying with all 4 patchsets applied.

** v3 changes **
- Instead of a new receive_room() ldisc method which requires acquiring
  the termios_rwsem twice for every flip buffer received, this patchset
  version adds an alternate receive_buf2() ldisc method for use with
  flow-controlled line disciplines (like N_TTY). This also fixes a
  race when termios can be changed between computing the receive space
  available and the subsequent receive_buf().
- Converts vt paste_selection() to use a helper function for this new
  ldisc method.
- Protects the n_tty_write() path from termios changes.
- Optimizes the N_TTY throttle/unthrottle by only offering termios
  read-safety to the driver throttle()/unthrottle() methods.
- Special-casing pty throttle/unthrottle to avoid multiple atomic
  operations for every read.

** v2 changes **
- Rebased on top of 'tty: Fix race condition if flushing tty flip buffers'
- I forgot to mention; this is ~35% faster on end-to-end tests on SMP.


This patchset implements lockless receive from tty flip buffers
to the n_tty read buffer and lockless copy into the user-space
read buffer.

By lockless, I'm referring to the fine-grained read_lock formerly used
to serialize access to the shared n_tty read buffer (which wasn't being
used everywhere it should have been).

In the current n_tty, the read_lock is grabbed a minimum of
3 times per byte!
- ^^^^
- should say 2 times per byte!

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

Peter Hurley (24):
  tty: Don't change receive_room for ioctl(TIOCSETD)
  tty: Simplify tty buffer/ldisc interface with helper function
  tty: Make ldisc input flow control concurrency-friendly
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
  tty: Only guarantee termios read safety for throttle/unthrottle
  n_tty: Move chars_in_buffer() to factor throttle/unthrottle
  n_tty: Factor throttle/unthrottle into helper functions
  n_tty: Move n_tty_write_wakeup() to avoid forward declaration
  n_tty: Special case pty flow control
  n_tty: Queue buffer work on any available cpu

 drivers/net/irda/irtty-sir.c |   8 +-
 drivers/tty/n_tty.c          | 662 ++++++++++++++++++++++++++-----------------
 drivers/tty/pty.c            |   4 +-
 drivers/tty/tty_buffer.c     |  34 ++-
 drivers/tty/tty_io.c         |  15 +-
 drivers/tty/tty_ioctl.c      |  90 +++---
 drivers/tty/tty_ldisc.c      |  13 +-
 drivers/tty/vt/selection.c   |   4 +-
 drivers/tty/vt/vt.c          |   4 +-
 include/linux/tty.h          |  21 +-
 include/linux/tty_ldisc.h    |  13 +
 11 files changed, 530 insertions(+), 338 deletions(-)

-- 
1.8.1.2

