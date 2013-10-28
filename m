Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab3J1PBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:01:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51139 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab3J1OtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 29/64] fs: buffer: move allocation failure loop into the allocator
Date: Mon, 28 Oct 2013 14:47:48 +0000
Message-Id: <1382971703-17393-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 84235de394d9775bfaa7fa9762a59d91fef0c1fc upstream.

Buffer allocation has a very crude indefinite loop around waking the
flusher threads and performing global NOFS direct reclaim because it can
not handle allocation failures.

The most immediate problem with this is that the allocation may fail due
to a memory cgroup limit, where flushers + direct reclaim might not make
any progress towards resolving the situation at all.  Because unlike the
global case, a memory cgroup may not have any cache at all, only
anonymous pages but no swap.  This situation will lead to a reclaim
livelock with insane IO from waking the flushers and thrashing unrelated
filesystem cache in a tight loop.

Use __GFP_NOFAIL allocations for buffers for now.  This makes sure that
any looping happens in the page allocator, which knows how to
orchestrate kswapd, direct reclaim, and the flushers sensibly.  It also
allows memory cgroups to detect allocations that can't handle failure
and will allow them to ultimately bypass the limit if reclaim can not
make progress.

Reported-by: azurIt <azurit@pobox.sk>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/buffer.c     | 14 ++++++++++++--
 mm/memcontrol.c |  2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 2c78739..2675e5a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -957,9 +957,19 @@ grow_dev_page(struct block_device *bdev, sector_t block,
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
index 226b63e..953bf3c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2405,6 +2405,8 @@ done:
 	return 0;
 nomem:
 	*ptr = NULL;
+	if (gfp_mask & __GFP_NOFAIL)
+		return 0;
 	return -ENOMEM;
 bypass:
 	*ptr = root_mem_cgroup;
-- 
1.8.3.2

