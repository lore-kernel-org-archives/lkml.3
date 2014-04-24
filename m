Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaDXKDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:03:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46700 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaDXIyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:54:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 096/182] dm cache: prevent corruption caused by discard_block_size > cache_block_size
Date: Thu, 24 Apr 2014 09:50:21 +0100
Message-Id: <1398329507-5911-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit d132cc6d9e92424bb9d4fd35f5bd0e55d583f4be upstream.

If the discard block size is larger than the cache block size we will
not properly quiesce IO to a region that is about to be discarded.  This
results in a race between a cache migration where no copy is needed, and
a write to an adjacent cache block that's within the same large discard
block.

Workaround this by limiting the discard_block_size to cache_block_size.
Also limit the max_discard_sectors to cache_block_size.

A more comprehensive fix that introduces range locking support in the
bio_prison and proper quiescing of a discard range that spans multiple
cache blocks is already in development.

Reported-by: Morgan Mears <Morgan.Mears@netapp.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Acked-by: Heinz Mauelshagen <heinzm@redhat.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-cache-target.c | 37 +++----------------------------------
 1 file changed, 3 insertions(+), 34 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index a2d7e04..d00ae6f 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -163,7 +163,7 @@ struct cache {
 	/*
 	 * origin_blocks entries, discarded if set.
 	 */
-	uint32_t discard_block_size; /* a power of 2 times sectors per block */
+	uint32_t discard_block_size;
 	dm_dblock_t discard_nr_blocks;
 	unsigned long *discard_bitset;
 
@@ -1905,35 +1905,6 @@ static int create_cache_policy(struct cache *cache, struct cache_args *ca,
 	return 0;
 }
 
-/*
- * We want the discard block size to be a power of two, at least the size
- * of the cache block size, and have no more than 2^14 discard blocks
- * across the origin.
- */
-#define MAX_DISCARD_BLOCKS (1 << 14)
-
-static bool too_many_discard_blocks(sector_t discard_block_size,
-				    sector_t origin_size)
-{
-	(void) sector_div(origin_size, discard_block_size);
-
-	return origin_size > MAX_DISCARD_BLOCKS;
-}
-
-static sector_t calculate_discard_block_size(sector_t cache_block_size,
-					     sector_t origin_size)
-{
-	sector_t discard_block_size;
-
-	discard_block_size = roundup_pow_of_two(cache_block_size);
-
-	if (origin_size)
-		while (too_many_discard_blocks(discard_block_size, origin_size))
-			discard_block_size *= 2;
-
-	return discard_block_size;
-}
-
 #define DEFAULT_MIGRATION_THRESHOLD 2048
 
 static int cache_create(struct cache_args *ca, struct cache **result)
@@ -2038,9 +2009,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	}
 	clear_bitset(cache->dirty_bitset, from_cblock(cache->cache_size));
 
-	cache->discard_block_size =
-		calculate_discard_block_size(cache->sectors_per_block,
-					     cache->origin_sectors);
+	cache->discard_block_size = cache->sectors_per_block;
 	cache->discard_nr_blocks = oblock_to_dblock(cache, cache->origin_blocks);
 	cache->discard_bitset = alloc_bitset(from_dblock(cache->discard_nr_blocks));
 	if (!cache->discard_bitset) {
@@ -2627,7 +2596,7 @@ static void set_discard_limits(struct cache *cache, struct queue_limits *limits)
 	/*
 	 * FIXME: these limits may be incompatible with the cache device
 	 */
-	limits->max_discard_sectors = cache->discard_block_size * 1024;
+	limits->max_discard_sectors = cache->discard_block_size;
 	limits->discard_granularity = cache->discard_block_size << SECTOR_SHIFT;
 }
 
-- 
1.9.1

