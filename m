Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3CKUpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:45:46 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:59104 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab3CKUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:45:43 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 00/44] ldisc patchset
Date: Mon, 11 Mar 2013 16:44:20 -0400
Message-Id: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,
This patchset includes
  'tty: Drop lock contention stat from ldsem trylocks'
so no need to apply that on this series. Also, I noticed you
kept the 'tty is NULL' removal on a different branch so I left
my patch in this series that removes it.

This series applies cleanly to tty-next.

v5 changes:

After completing an audit of the recursive use of ldisc
references, I discovered the _blocking_ recursive acquisition
of ldisc references was limited to line disciplines misusing
the tty_perform_flush() function.
With that now resolved in,
  'tty: Fix recursive deadlock in tty_perform_flush()'
the recursion design in ldsem has been removed.

The recursion removal is in its own patch,
  'tty: Remove ldsem recursion support'
to ease review for those that have already reviewed the
ldsem implementation.

In addition, this patchset implements lock stealing derived
from the work of Michel Lespinasse <walken@google.com> on
writer lock stealing in rwsem.

Although the rwsem write lock stealing changes are motivated
by performance criteria, these changes are motivated by reduced
code line count and simplicity of design.


*** Edited below to remove recursion discussion ***

Back in early December I realized that a classic read/write semaphore
with writer priority was the ideal mechanism for handling the
line discipline referencing.

Line discipline references act as "readers"; closing or changing the
line discipline is prevented while these references are outstanding.
Conversely, line discipline references should not be granted while
the line discipline is closing or changing; these are the "writers".

Unfortunately, the existing rwsem uses a FIFO priority for
waiting threads and does not support timeouts.

So this implements just that: a writer-priority
read/write semaphore with timed waits.

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
new ones that I have written.


Peter Hurley (44):
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
  tty: Fix recursive deadlock in tty_perform_flush()
  tty: Add read-recursive, writer-prioritized rw semaphore
  tty: Drop lock contention stat from ldsem trylocks
  tty: Remove ldsem recursion support
  tty: Add lock/unlock ldisc pair functions
  tty: Replace ldisc locking with ldisc_sem
  tty: Clarify ldisc variable
  tty: Fix hangup race with TIOCSETD ioctl
  tty: Clarify multiple-references comment in TIOCSETD ioctl
  tty: Fix tty_ldisc_lock name collision
  tty: Drop "tty is NULL" flip buffer diagnostic
  tty: Inline ldsem down_failed() into down_{read,write}_failed()
  tty: Drop ldsem wait type
  tty: Drop wake type optimization
  tty: Factor ldsem writer trylock
  tty: Simplify lock taking for waiting writers
  tty: Implement ldsem fast path write lock stealing
  tty: Reduce and simplify ldsem atomic ops
  tty: Early-out ldsem write lock stealing
  tty: Early-out tardy ldsem readers

 drivers/net/ppp/ppp_async.c   |   2 +-
 drivers/net/ppp/ppp_synctty.c |   2 +-
 drivers/tty/Makefile          |   2 +-
 drivers/tty/n_tty.c           |  62 +++--
 drivers/tty/tty_buffer.c      |   4 +-
 drivers/tty/tty_io.c          |  33 ++-
 drivers/tty/tty_ioctl.c       |  28 ++-
 drivers/tty/tty_ldisc.c       | 551 +++++++++++++++---------------------------
 drivers/tty/tty_ldsem.c       | 450 ++++++++++++++++++++++++++++++++++
 drivers/tty/tty_port.c        |   1 +
 include/linux/tty.h           |   7 +-
 include/linux/tty_ldisc.h     |  49 +++-
 12 files changed, 779 insertions(+), 412 deletions(-)
 create mode 100644 drivers/tty/tty_ldsem.c

-- 
1.8.1.2

