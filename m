Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaBUNy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:54:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaBUNyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:54:23 -0500
Message-ID: <1392990852.5451.178.camel@marge.simpson.net>
Subject: Re: [PATCH RT] fs: jbd2: pull your plug when waiting for space
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>, tglx@linutronix.de
Date: Fri, 21 Feb 2014 14:54:12 +0100
In-Reply-To: <20140221123253.GA12822@linutronix.de>
References: <20140221123253.GA12822@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:UTcZ8SkIWnVW5Ws7eDO71T0mCroKsdlTO63aBJ3Ih2K
 WWVTGqmoUA8EZp4VJj1kWUTVUu8o4tkdqufMZ3WdTfL9zvJ8EX
 CZhBRjmIUAy4brJwus/ol+jQI5o1XOF5cim0D7RxYK+G0dJ06B
 uKTMY1v9cA4T6+vXEL0bLFqgI1b8gnrqnoL6UXTTqq7C18JvBI
 FTmELeRcSJiBBzjFvWRPlIQMOctShAv69dr2lwiyWUlirGVoyG
 XWKIkfICZcLXxl6Axf58wC8reY+Vmg2tKKnRlry638ijAspaFL
 HRqeU6wYDbnJzzXN0iR1r99kNjamq6CEQX+BY8LuAqgaPXZmW9
 a43fX6gAMscdCZO2OrTe8+O9nhClm1ok2RDhr1AuZdqv3JQ7mZ
 mqEvBhf5yAr6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 13:32 +0100, Sebastian Andrzej Siewior wrote: 
> Two cps in parallel managed to stall the the ext4 fs. It seems that
> journal code is either waiting for locks or sleeping waiting for
> something to happen. This seems similar to what Mike observed on ext3,
> here is his description:
> 
> |With an -rt kernel, and a heavy sync IO load, tasks can jam
> |up on journal locks without unplugging, which can lead to
> |terminal IO starvation.  Unplug and schedule when waiting
> |for space.
> 
> This is on v3.2-RT. This cp testcase triggers about once in four runs.
> It did not trigger once in 20 runs on v3.12-RT.

In 3.0-rt, it could take ages to hit an IO deadlock.
> This brings me to the question: could it been fixed in the meantime and
> we not need the jbd patches in latest -RT is there a better testcase?

Dunno, suse QA does a simple but heavy dbench async then sync stress
test, which would eventually lead to IO deadlock in 3.0-rt.  I dumped
the pull your plug for jbd only patch in favor of the (stunningly
beautiful) patch below, because XFS and others eventually deadlocked
with crossed IO [ABBAXYZ] dependencies as well.

I haven't had time to do massive IO pounding in 3.12-rt yet, but the
below got 3.0-rt over the IO hurdle, along with the one below that for
btrfs, which lasted for about, oh, 2us without it.

Subject: rt: pull your plug before blocking

Queued IO can lead to IO deadlock should a task require wakeup from as task
which is blocked on that queued IO.

ext3: dbench1 queues a buffer, blocks on journal mutex, it's plug is not
pulled.  dbench2 mutex owner is waiting for kjournald, who is waiting for
the buffer queued by dbench1.  Game over.

Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 kernel/rtmutex.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -22,6 +22,7 @@
 #include <linux/sched/rt.h>
 #include <linux/timer.h>
 #include <linux/ww_mutex.h>
+#include <linux/blkdev.h>
 
 #include "rtmutex_common.h"
 
@@ -674,8 +675,18 @@ static inline void rt_spin_lock_fastlock
 
 	if (likely(rt_mutex_cmpxchg(lock, NULL, current)))
 		rt_mutex_deadlock_account_lock(lock, current);
-	else
+	else {
+		/*
+		 * We can't pull the plug if we're already holding a lock
+		 * else we can deadlock.  eg, if we're holding slab_lock,
+		 * ksoftirqd can block while processing BLOCK_SOFTIRQ after
+		 * having acquired q->queue_lock.  If _we_ then block on
+		 * that q->queue_lock while flushing our plug, deadlock.
+		 */
+		if (__migrate_disabled(current) < 2 && blk_needs_flush_plug(current))
+			blk_schedule_flush_plug(current);
 		slowfn(lock);
+	}
 }
 
 static inline void rt_spin_lock_fastunlock(struct rt_mutex *lock,
@@ -1275,8 +1286,11 @@ rt_mutex_fastlock(struct rt_mutex *lock,
 	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
 		rt_mutex_deadlock_account_lock(lock, current);
 		return 0;
-	} else
+	} else {
+		if (blk_needs_flush_plug(current))
+			blk_schedule_flush_plug(current);
 		return slowfn(lock, state, NULL, detect_deadlock, ww_ctx);
+	}
 }
 
 static inline int



Subject: rt,fs,btrfs: fix rt deadlock on extent_buffer->lock

Trivially repeatable deadlock is cured by enabling lockdep code in
btrfs_clear_path_blocking() as suggested by Chris Mason.  He also
suggested restricting blocking reader count to one, and not allowing
a spinning reader while blocking reader exists.  This has proven to
be unnecessary, the strict lock order enforcement is enough.. or
rather that's my box's opinion after long hours of hard pounding.

Note: extent-tree.c bit is additional recommendation from Chris
      Mason, split into a separate patch after discussion.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Chris Mason <chris.mason@fusionio.com>
---
fs/btrfs/ctree.c       |    4 ++--
fs/btrfs/extent-tree.c |    8 --------
2 files changed, 2 insertions(+), 10 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -81,7 +81,7 @@ noinline void btrfs_clear_path_blocking(
{
int i;

-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#if (defined(CONFIG_DEBUG_LOCK_ALLOC) ||
defined(CONFIG_PREEMPT_RT_BASE))
/* lockdep really cares that we take all of these spinlocks
* in the right order.  If any of the locks in the path are not
* currently blocking, it is going to complain.  So, make really
@@ -108,7 +108,7 @@ noinline void btrfs_clear_path_blocking(
}
}

-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#if (defined(CONFIG_DEBUG_LOCK_ALLOC) ||
defined(CONFIG_PREEMPT_RT_BASE))
if (held)
btrfs_clear_lock_blocking_rw(held, held_rw);
#endif
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6899,14 +6899,6 @@ use_block_rsv(struct btrfs_trans_handle
goto again;
}

- if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
- static DEFINE_RATELIMIT_STATE(_rs,
- DEFAULT_RATELIMIT_INTERVAL * 10,
- /*DEFAULT_RATELIMIT_BURST*/ 1);
- if (__ratelimit(&_rs))
- WARN(1, KERN_DEBUG
- "btrfs: block rsv returned %d\n", ret);
- }
try_reserve:
ret = reserve_metadata_bytes(root, block_rsv, blocksize,
     BTRFS_RESERVE_NO_FLUSH);


