Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaJPUZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:25:48 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41295 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752479AbaJPUZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:25:46 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 00/27] tty locking changes
Date: Thu, 16 Oct 2014 16:24:58 -0400
Message-Id: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch series has 3 major changes to how tty locking behaves:
1. the lock order of tty_lock() and tty->ldisc_sem is reversed;
   this eliminates a bunch of lock drop/reacquire which, in turn,
   eliminates tty state tracking that can no longer be observed.
   This also allows the pty driver to wait for input processing to
   complete while closing before setting TTY_OTHER_CLOSED (which
   eliminates the ugliness of checking input twice in n_tty_read() and
   n_tty_poll()).
2. the footprint of tty_mutex is reduced to only adding and removing
   ttys and is no longer held to acquire the tty_lock() in tty_open();
   this allows for multiple ttys to be opened concurrently, even if
   one open stalls waiting for its tty_lock().
3. pty pair locking is reordered to master first, then slave, rather
   than by address. This works because, while releasing the master pty,
   the slave tty count needs to be changed, whereas, when releasing the
   slave, the master pty does not need to be accessed.
   This furthur eliminates more lock drop/reacquire.

The longer-term goals, which this series builds towards, is:
1. simplifying the tty open/close behavior
2. eliminating the ASYNC_CLOSING code without breaking existing userspace
3. eliminating returning -EIO from tty_open(). Not sure if this is possible yet.

Regards,

Peter Hurley (27):
  tty: Don't hold tty_lock for ldisc release
  tty: Invert tty_lock/ldisc_sem lock order
  tty: Remove TTY_HUPPING
  tty: Clarify re-open behavior of master ptys
  tty: Check tty->count instead of TTY_CLOSING in tty_reopen()
  pty: Always return -EIO if slave BSD pty opened first
  tty: Re-open /dev/tty without tty_mutex
  tty: Drop tty_mutex before tty reopen
  tty: Remove TTY_CLOSING
  tty: Don't take tty_mutex for tty count changes
  tty: Don't release tty locks for wait queue sanity check
  tty: Document check_tty_count() requires tty_lock held
  tty: Simplify pty pair teardown logic
  tty: Fold pty pair handling into tty_flush_works()
  tty: Simplify tty_ldisc_release() interface
  tty: Simplify tty_release_checks() interface
  tty: Simplify tty_release() state checks
  tty: Change tty lock order to master->slave
  tty: Remove tty_unhangup() declaration
  tty: Refactor __tty_hangup to enable lockdep annotation
  pty: Don't drop pty master tty lock to hangup slave
  tty: Document hangup call tree
  pty, n_tty: Simplify input processing on final close
  tty: Prefix tty_ldisc_{lock,lock_nested,unlock} functions
  tty: Fix hung task on pty hangup
  tty: Fix timeout on pty set ldisc
  tty: Flush ldisc buffer atomically with tty flip buffers

 drivers/tty/n_tty.c      |  46 ++++----
 drivers/tty/pty.c        |  12 +-
 drivers/tty/tty_buffer.c |  10 +-
 drivers/tty/tty_io.c     | 279 ++++++++++++++++++++++++-----------------------
 drivers/tty/tty_ldisc.c  | 106 +++++++++---------
 drivers/tty/tty_mutex.c  |  32 +++---
 include/linux/tty.h      |  15 +--
 7 files changed, 250 insertions(+), 250 deletions(-)

-- 
2.1.1

