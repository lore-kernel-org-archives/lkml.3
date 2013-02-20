Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935263Ab3BTUEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:04:51 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:53921 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935196Ab3BTUEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:04:43 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 00/32] ldisc patchset
Date: Wed, 20 Feb 2013 15:02:47 -0500
Message-Id: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[-cc Alan Cox]

Sebastian, please re-test your g_nokia+dummy_hcd testcase with
this series.

Sasha and Dave, my trinity testbeds die in other areas right now;
I would really appreciate if you would please re-test this series.

Michael and Shawn, I'd appreciate if you test with this series
although I know it won't WARN because this patchset removes it.




Back in early December I realized that a classic recursive
read/write semaphore with writer priority was the ideal mechanism
for handling the line discipline referencing.

Line discipline references act as "readers"; closing or changing the
line discipline is prevented while these references are outstanding.
Conversely, line discipline references should not be granted while
the line discipline is closing or changing; these are the "writers".

Unfortunately, the existing rwsem does not allowed recursive
read acquire, uses a FIFO priority for waiting threads, and does
not support timeouts.

So this implements just that: a read-recursive, writer-priority
read/write semaphore with timed waits.

Read recursion is handled with a small (192-bit) bitmap indexed
by a prime modulo-reduced 'current' value. When a read lock is
obtained, the corresponding bit is set. If a write lock is
waiting when a subsequent read lock is tried, before waiting
the read lock, the bitmap is tested to determine if this
thread already owns a read lock. This approach may allow a
non-recursive read lock (if, for example, 2 thread ptrs hash
to the same value) which is not an error; it simply delays
the waiting writer further. More importantly, this approach
will not mistakenly wait a recursive read, which will end in
deadlock.

Note for the following discussion: the existing code livelocks
under _any_ recursive tty_ldisc_ref_wait() call when the
line discipline is halted.
This is the hangup livelock first observed by Sasha Levin.

Two weaknesses exist in this implementation of recursion
testing:
1) the bitmap may not be large enough to avoid a
   'thundering herd' livelock. For example, say 1000 processes
   all have the same tty open and are always reading from it.
   These 1000 processes will saturate the bitmap so it will
   appear as if every process is recursively reading so a
   read lock will always be granted. Thus the write lock will
   never be granted.
2) the bitmap is only cleared once a write lock is granted.
   So a tty that never closes will, over time, develop a
   saturated bitmap of apparent recursive reads even though
   those read locks were released.
   This needs to be addressed, perhaps by periodically
   attempting a dummy write lock.

Initially, it was my intention to have this in 2 patchsets but
since the v2 and v3 patchsets were pushed back, this ends up
being an all-in-one :)

Other changes in v4 from v3:

-  From Jiri's review of v3:

'tty: Add diagnostic for halted line discipline' was split:
   the function relocation is now in a separate patch,
   'tty: Relocate tty_ldisc_halt() to avoid forward declaration'

'n_tty: Factor packet mode status change for reuse':
   packet_mode_flush() was renamed n_tty_packet_mode_flush()

'tty: Refactor wait for ldisc refs out of tty_ldisc_hangup()':
   the parentheses were removed in the return value conversion.

'tty: Strengthen no-subsequent-use guarantee of tty_ldisc_halt()':
   although addressed in the follow-on patch, the timeout values
   are now identical so as to avoid confusion in reviewing.

'tty: Kick waiters _after_ the ldisc is locked' was dropped:
   although my logic is solid, this change made the conversion
   to a r/w semaphore awkward-looking. I think it makes sense to
   fix this separately in n_tty anyway.

'tty: Remove unnecessary buffer work flush' was merged with
   new patch 'tty: Complete ownership transfer of flip buffers'

Patches 19-31 implement the switch to ldsem.

Patch 32 removes the 'tty is NULL' diagnostic. The logic supporting
this change is in the commit message but I'll repeat it here:

Now that the driver i/o path is separate from tty lifetimes
(implemented in Jiri's last patch series, soon to be in 3.9-rc1),
a driver may unknowingly submit i/o to a tty that no longer exists.
There is little sense in WARNing about an expected outcome.

Patch 14/32 'tty: Complete ownership transfer of flip buffers' ensures
that no bad will come of the superfluous work -- other than that work for
no-good-reason was submitted in the first place -- by waiting for
work that may have retrieved what will soon be a stale tty value
and by cancelling outstanding work before the port is destroyed
(the work is owned by the port and contained within its structure).

As before, this series passes the stress tests that Ilya wrote plus some
new ones that I have written. Unfortunately, there is no platform that
I can run trinity on that doesn't blow up on other 'next' bugs.


Peter Hurley (32):
  tty: Add diagnostic for halted line discipline
  n_tty: Factor packet mode status change for reuse
  n_tty: Don't flush buffer when closing ldisc
  tty: Refactor wait for ldisc refs out of tty_ldisc_hangup()
  tty: Remove unnecessary re-test of ldisc ref count
  tty: Fix ldisc halt sequence on hangup
  tty: Relocate tty_ldisc_halt() to avoid forward declaration
  tty: Strengthen no-subsequent-use guarantee of tty_ldisc_halt()
  tty: Halt both ldiscs concurrently
  tty: Wait for SAK work before waiting for hangup work
  n_tty: Correct unthrottle-with-buffer-flush comments
  n_tty: Fully initialize ldisc before restarting buffer work
  tty: Don't reenable already enabled ldisc
  tty: Complete ownership transfer of flip buffers
  tty: Make core responsible for synchronizing its work
  tty: Fix 'deferred reopen' ldisc comment
  tty: Bracket ldisc release with TTY_DEBUG_HANGUP messages
  tty: Add ldisc hangup debug messages
  tty: Don't protect atomic operation with mutex
  tty: Separate release semantics of ldisc reference
  tty: Document unsafe ldisc reference acquire
  tty: Fold one-line assign function into callers
  tty: Locate get/put ldisc functions together
  tty: Remove redundant tty_wait_until_sent()
  tty: Add read-recursive, writer-prioritized rw semaphore
  tty: Add lock/unlock ldisc pair functions
  tty: Replace ldisc locking with ldisc_sem
  tty: Clarify ldisc variable
  tty: Fix hangup race with TIOCSETD ioctl
  tty: Clarify multiple-references comment in TIOCSETD ioctl
  tty: Fix tty_ldisc_lock name collision
  tty: Drop "tty is NULL" flip buffer diagnostic

 drivers/tty/Makefile      |   2 +-
 drivers/tty/n_tty.c       |  62 +++---
 drivers/tty/tty_buffer.c  |   4 +-
 drivers/tty/tty_io.c      |  33 ++-
 drivers/tty/tty_ldisc.c   | 551 ++++++++++++++++------------------------------
 drivers/tty/tty_ldsem.c   | 507 ++++++++++++++++++++++++++++++++++++++++++
 drivers/tty/tty_port.c    |   1 +
 include/linux/tty.h       |   7 +-
 include/linux/tty_ldisc.h |  50 ++++-
 9 files changed, 816 insertions(+), 401 deletions(-)
 create mode 100644 drivers/tty/tty_ldsem.c

-- 
1.8.1.2

