Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbaKERNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:13:34 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33380 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753303AbaKERNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:13:30 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 00/26] tty locking changes
Date: Wed,  5 Nov 2014 12:12:43 -0500
Message-Id: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
* New patch 19 ('tty: Preset lock subclass for nested tty locks') makes
  passing the tty_lock subclass at lock time unnecessary; regular ttys and
  master ptys use subclass 0 and slave ptys use subclass 1. The expected
  lock order is first subclass 0 then subclass 1. Lockdep will warn if
  the reverse order is used.

* That makes introducing tty_hangup_slave and refactoring tty_hangup et al
  unnecessary, so the previous patch 20 ('tty: Refactor __tty_hangup to
  enable lockdep annotation') was removed, along with 'tty: Document hangup
  call tree'.

* Added Alan's Reviewed-by tag to the patches Alan already reviewed,
  which just leaves the following patches needing re-review:
     19/26 tty: Preset lock subclass for nested tty locks
     21/26 pty: Don't drop pty master tty lock to hangup slave

I forgot to point this out in v1; this series depends on
'tty: Fix high cpu load if tty is unreleasable'
'tty: Prevent "read/write wait queue active!" log flooding'

==
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

Peter Hurley (26):
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
  tty: Preset lock subclass for nested tty locks
  tty: Remove tty_unhangup() declaration
  pty: Don't drop pty master tty lock to hangup slave
  pty, n_tty: Simplify input processing on final close
  tty: Prefix tty_ldisc_{lock,lock_nested,unlock} functions
  tty: Fix hung task on pty hangup
  tty: Fix timeout on pty set ldisc
  tty: Flush ldisc buffer atomically with tty flip buffers

 drivers/tty/n_tty.c      |  46 +++++------
 drivers/tty/pty.c        |  12 ++-
 drivers/tty/tty_buffer.c |  10 ++-
 drivers/tty/tty_io.c     | 195 ++++++++++++++++++++---------------------------
 drivers/tty/tty_ldisc.c  | 106 +++++++++++++-------------
 drivers/tty/tty_mutex.c  |  49 +++++-------
 include/linux/tty.h      |  15 ++--
 7 files changed, 196 insertions(+), 237 deletions(-)

-- 
2.1.3

