Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3KYNyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:54:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59013 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385Ab3KYNxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:44 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "azurIt" <azurit@pobox.sk>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Michal Hocko" <mhocko@suse.cz>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.232027452@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 73/87] fs: buffer: move allocation failure loop into
 the allocator
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/buffer.c     | 14 ++++++++++++--
 mm/memcontrol.c |  2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1007,9 +1007,19 @@ grow_dev_page(struct block_device *bdev,
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
 
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2406,6 +2406,8 @@ done:
 	return 0;
 nomem:
 	*ptr = NULL;
+	if (gfp_mask & __GFP_NOFAIL)
+		return 0;
 	return -ENOMEM;
 bypass:
 	*ptr = NULL;

