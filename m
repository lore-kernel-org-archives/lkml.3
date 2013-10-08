Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab3JHU60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:58:26 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:56667 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab3JHU6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:58:23 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/2] fs: buffer: move allocation failure loop into the allocator
Date: Tue,  8 Oct 2013 16:58:10 -0400
Message-Id: <1381265890-11333-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381265890-11333-1-git-send-email-hannes@cmpxchg.org>
References: <1381265890-11333-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buffer allocation has a very crude indefinite loop around waking the
flusher threads and performing global NOFS direct reclaim because it
can not handle allocation failures.

The most immediate problem with this is that the allocation may fail
due to a memory cgroup limit, where flushers + direct reclaim might
not make any progress towards resolving the situation at all.  Because
unlike the global case, a memory cgroup may not have any cache at all,
only anonymous pages but no swap.  This situation will lead to a
reclaim livelock with insane IO from waking the flushers and thrashing
unrelated filesystem cache in a tight loop.

Use __GFP_NOFAIL allocations for buffers for now.  This makes sure
that any looping happens in the page allocator, which knows how to
orchestrate kswapd, direct reclaim, and the flushers sensibly.  It
also allows memory cgroups to detect allocations that can't handle
failure and will allow them to ultimately bypass the limit if reclaim
can not make progress.

Reported-by: azurIt <azurit@pobox.sk>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@kernel.org
---
 fs/buffer.c     | 14 ++++++++++++--
 mm/memcontrol.c |  2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 4d74335..6024877 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1005,9 +1005,19 @@ grow_dev_page(struct block_device *bdev, sector_t block,
 	struct buffer_head *bh;
 	sector_t end_block;
 	int ret = 0;		/* Will call free_more_memory() */
+	gfp_t gfp_mask;
 
-	page = find_or_create_page(inode->i_mapping, index,
-		(mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS)|__GFP_MOVABLE);
+	gfp_mask = mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
+	gfp_mask |= __GFP_MOVABLE;
+	/*
+	 * XXX: __getblk_slow() can not really deal with failure and
+	 * will endlessly loop on improvised global reclaim.  Prefer
+	 * looping in the allocator rather than here, at least that
+	 * code knows what it's doing.
+	 */
+	gfp_mask |= __GFP_NOFAIL;
+
+	page = find_or_create_page(inode->i_mapping, index, gfp_mask);
 	if (!page)
 		return ret;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b39dfac..e233aa1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2764,6 +2764,8 @@ done:
 	return 0;
 nomem:
 	*ptr = NULL;
+	if (gfp_mask & __GFP_NOFAIL)
+		return 0;
 	return -ENOMEM;
 bypass:
 	*ptr = root_mem_cgroup;
-- 
1.8.4

