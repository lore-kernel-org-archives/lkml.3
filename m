Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3LFPYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:24:03 -0500
Received: from mail.windriver.com ([147.11.1.11]:41965 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3LFPYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:24:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC 0/1] wait queue head; locking considerations
Date: Fri, 6 Dec 2013 10:19:21 -0500
Message-ID: <1386343162-53574-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.rc3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter pointed out[1] that the simple wait queues in RT could
run any number of wakeups with the wait queue head lock held.

It turns out that this isnt really specific to RT, but it is
mainline too -- all the __wake_up_XYZ that in turn use the
__wake_up_common boiler plate end up looping over all the
callbacks (normally ttwu) while holding the head lock.

I'm not sure exactly whether contention is a serious issue,
but the possibility exists for someone to use a non-default
callback (i.e. not ttwu) and have some considerable amount
of computation going on while holding the head lock.

I entertained several ideas, none of which I am really
happy with (except perhaps #4).

1) Limit the number of callbacks; via a MAX_WORK or similar.
   This would require bubbling up return values (some of which
   were just recently removed) and relying on the holder of
   the lock to take appropriate action (unlock, breathe, restart.)
   Plus, it doesn't really solve anything if someone installs
   a non default callback that takes forever.

2) Try and defer the callbacks temporarily somehow until the
   waitqueue head lock is released.  I experimented with this,
   via creating a snapshot of the waiters, and running that
   on the next head unlock, but it was ugly, lockdep didn't
   like it at all, etc.  Plus it isn't clear we can delay
   any without causing additional latency.

3) Declare locked wake ups evil, and try and determine if
   we can somehow fix the users in a way that we can phase
   them out. Perhaps by somehow cascading the head lock
   down into the individual waitqueue_t elements?

4) Do nothing.  It isn't really a significant problem.

In any case, while attempting #2, I did abstract out the
locking and unlocking.  Maybe this makes sense regardless,
since we already hide the spinlock init in wait queue
head init; we don't use raw list operations, but instead
use add_to_waitqueue() abstractions.  In fact it seems
only the locking doesn't have waitq in its function name.

It does help highlight those users who are manually
manipulating their waitq head lock, and perhaps slightly
improve readability.  It passes x86/_64 allmodconfig, but
if we think we want to use this, I'll need to build test
the other arches too.

Thoughts?

Paul.
--
[1] http://marc.info/?l=linux-kernel&m=138089860308430&w=2


Paul Gortmaker (1):
  waitq: abstract out locking/unlocking waitq head operations

 drivers/gpu/drm/radeon/radeon_sa.c                 | 18 ++++-----
 drivers/iio/industrialio-event.c                   | 26 ++++++-------
 .../lustre/lustre/libcfs/linux/linux-prim.c        |  4 +-
 drivers/usb/gadget/f_fs.c                          | 42 ++++++++++-----------
 fs/eventfd.c                                       | 32 ++++++++--------
 fs/eventpoll.c                                     |  4 +-
 fs/nilfs2/segment.c                                |  4 +-
 fs/timerfd.c                                       | 26 ++++++-------
 include/linux/wait.h                               | 36 +++++++++++++++---
 kernel/sched/completion.c                          | 24 ++++++------
 kernel/sched/core.c                                |  8 ++--
 kernel/sched/wait.c                                | 44 +++++++++++-----------
 mm/filemap.c                                       |  4 +-
 net/sunrpc/sched.c                                 |  4 +-
 14 files changed, 150 insertions(+), 126 deletions(-)

-- 
1.8.5.rc3

