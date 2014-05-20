Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaETApI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:45:08 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:64038 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741AbaETApF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:45:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkHAHGkelN5LL1s/2dsb2JhbABZgwaDQac7AQEBAQEBBpopAYEYF3SCJQEBBAEnExwjBQsIAw4DAwECAQklDwUlAxMOE4g5B9JIFxaFP4h6B4MrgRUEmVmLEogJg0krgTEk
Date: Tue, 20 May 2014 10:44:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: riel@redhat.com, kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] mm/vmscan: Do not block forever at
 shrink_inactive_list().
Message-ID: <20140520004449.GE18954@dastard>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc xfs@oss.sgi.com]

On Mon, May 19, 2014 at 11:40:46PM +0900, Tetsuo Handa wrote:
> >From f016db5d7f84d6321132150b13c5888ef67d694f Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 19 May 2014 23:24:11 +0900
> Subject: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
> 
> I can observe that commit 35cd7815 "vmscan: throttle direct reclaim when
> too many pages are isolated already" causes RHEL7 environment to stall with
> 0% CPU usage when a certain type of memory pressure is given.
> 
> Upon memory pressure, kswapd calls xfs_vm_writepage() from shrink_page_list().
> xfs_vm_writepage() eventually calls wait_for_completion() which waits for
> xfs_bmapi_allocate_worker().
> 
> Then, a kernel worker thread calls xfs_bmapi_allocate_worker() and
> xfs_bmapi_allocate_worker() eventually calls xfs_btree_lookup_get_block().
> xfs_btree_lookup_get_block() eventually calls alloc_page().
> alloc_page() eventually calls shrink_inactive_list().
> 
> The stack trace showed that the kernel worker thread which the kswapd is
> waiting for was looping at a while loop in shrink_inactive_list().

[snip stack traces indicating XFS is deferring allocation work to the
allocation workqueue on behalf of kswapd]

> Since the kernel worker thread needs to escape from the while loop so that
> alloc_page() can allocate memory (and eventually allow xfs_vm_writepage()
> to release memory), I think that we should not block forever. This patch
> introduces 30 seconds timeout for userspace processes and 5 seconds timeout
> for kernel processes.

That's like trying to swat a fly with a runaway train. Eventually
you'll hit the fly with the train....

Q: What is missing from the workqueue context that results
in the workqueue being blocked in memory reclaim on congestion?

Hint: XFS is deferring allocation on behalf of kswapd to a
workqueue.

A: PF_KSWAPD.  shrink_inactive_list() has this guard:

        /*
         * Stall direct reclaim for IO completions if underlying BDIs or zone
         * is congested. Allow kswapd to continue until it starts encountering
         * unqueued dirty pages or cycling through the LRU too quickly.
         */
        if (!sc->hibernation_mode && !current_is_kswapd())
                wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);


So, XFS should be passing kswapd context to the workqueue allocation
context. The patch below does this.

Tetsuo-san, when it comes to problems involving XFS, you should
really CC xfs@oss.sgi.com because very few people really know how
XFS works and even fewer still know how it is supposed to interact
with memory reclaim....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: block allocation work needs to be kswapd aware

From: Dave Chinner <dchinner@redhat.com>

Upon memory pressure, kswapd calls xfs_vm_writepage() from
shrink_page_list(). This can result in delayed allocation occurring
and that gets deferred to the the allocation workqueue.

The allocation then runs outside kswapd context, which means if it
needs memory (and it does to demand page metadata from disk) it can
block in shrink_inactive_list() waiting for IO congestion. These
blocking waits are normally avoiding in kswapd context, so under
memory pressure writeback from kswapd can be arbitrarily delayed by
memory reclaim.

To avoid this, pass the kswapd context to the allocation being done
by the workqueue, so that memory reclaim understands correctly that
the work is being done for kswapd and therefore it is not blocked
and does not delay memory reclaim.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 16 +++++++++++++---
 fs/xfs/xfs_bmap_util.h |  1 +
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 057f671..703b3ec 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -258,14 +258,23 @@ xfs_bmapi_allocate_worker(
 	struct xfs_bmalloca	*args = container_of(work,
 						struct xfs_bmalloca, work);
 	unsigned long		pflags;
+	unsigned long		new_pflags = PF_FSTRANS;
 
-	/* we are in a transaction context here */
-	current_set_flags_nested(&pflags, PF_FSTRANS);
+	/*
+	 * we are in a transaction context here, but may also be doing work
+	 * in kswapd context, and hence we may need to inherit that state
+	 * temporarily to ensure that we don't block waiting for memory reclaim
+	 * in any way.
+	 */
+	if (args->kswapd)
+		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
+
+	current_set_flags_nested(&pflags, new_pflags);
 
 	args->result = __xfs_bmapi_allocate(args);
 	complete(args->done);
 
-	current_restore_flags_nested(&pflags, PF_FSTRANS);
+	current_restore_flags_nested(&pflags, new_pflags);
 }
 
 /*
@@ -284,6 +293,7 @@ xfs_bmapi_allocate(
 
 
 	args->done = &done;
+	args->kswapd = current_is_kswapd();
 	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
 	queue_work(xfs_alloc_wq, &args->work);
 	wait_for_completion(&done);
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 935ed2b..d227f9d 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -56,6 +56,7 @@ struct xfs_bmalloca {
 	char			aeof;	/* allocated space at eof */
 	char			conv;	/* overwriting unwritten extents */
 	char			stack_switch;
+	char			kswapd;	/* allocation in kswapd context */
 	int			flags;
 	struct completion	*done;
 	struct work_struct	work;
