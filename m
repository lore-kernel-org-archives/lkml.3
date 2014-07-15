Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbaGOVcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:32:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53965 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbaGOVcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:32:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Chinner <dchinner@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 103/198] xfs: block allocation work needs to be kswapd aware
Date: Tue, 15 Jul 2014 14:29:33 -0700
Message-Id: <1405459868-15089-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 1f6d64829db78a7e1d63e15c9f48f0a5d2b5a679 upstream.

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

To avoid issues with int->char conversion of flag fields (as noticed
in v1 of this patch) convert the flag fields in the struct
xfs_bmalloca to bool types. pahole indicates these variables are
still single byte variables, so no extra space is consumed by this
change.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/xfs/xfs_bmap_util.c | 16 +++++++++++++---
 fs/xfs/xfs_bmap_util.h | 13 +++++++------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 82e0dab..035d06a 100644
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
index 900747b..f33711d 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -50,12 +50,13 @@ struct xfs_bmalloca {
 	xfs_extlen_t		total;	/* total blocks needed for xaction */
 	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
 	xfs_extlen_t		minleft; /* amount must be left after alloc */
-	char			eof;	/* set if allocating past last extent */
-	char			wasdel;	/* replacing a delayed allocation */
-	char			userdata;/* set if is user data */
-	char			aeof;	/* allocated space at eof */
-	char			conv;	/* overwriting unwritten extents */
-	char			stack_switch;
+	bool			eof;	/* set if allocating past last extent */
+	bool			wasdel;	/* replacing a delayed allocation */
+	bool			userdata;/* set if is user data */
+	bool			aeof;	/* allocated space at eof */
+	bool			conv;	/* overwriting unwritten extents */
+	bool			stack_switch;
+	bool			kswapd;	/* allocation in kswapd context */
 	int			flags;
 	struct completion	*done;
 	struct work_struct	work;
-- 
1.9.1

