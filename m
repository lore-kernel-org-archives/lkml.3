Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbaHHUxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:53:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41256 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983AbaHHUxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anssi Hannula <anssi.hannula@iki.fi>, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 201/259] dm cache: fix race affecting dirty block count
Date: Fri,  8 Aug 2014 13:40:24 -0700
Message-Id: <1407530482-4483-202-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anssi Hannula <anssi.hannula@iki.fi>

commit 44fa816bb778edbab6b6ddaaf24908dd6295937e upstream.

nr_dirty is updated without locking, causing it to drift so that it is
non-zero (either a small positive integer, or a very large one when an
underflow occurs) even when there are no actual dirty blocks.  This was
due to a race between the workqueue and map function accessing nr_dirty
in parallel without proper protection.

People were seeing under runs due to a race on increment/decrement of
nr_dirty, see: https://lkml.org/lkml/2014/6/3/648

Fix this by using an atomic_t for nr_dirty.

Reported-by: roma1390@gmail.com
Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-cache-target.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index fd92101..ae73ee5 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -225,7 +225,7 @@ struct cache {
 	/*
 	 * cache_size entries, dirty if set
 	 */
-	dm_cblock_t nr_dirty;
+	atomic_t nr_dirty;
 	unsigned long *dirty_bitset;
 
 	/*
@@ -487,7 +487,7 @@ static bool is_dirty(struct cache *cache, dm_cblock_t b)
 static void set_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cblock)
 {
 	if (!test_and_set_bit(from_cblock(cblock), cache->dirty_bitset)) {
-		cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) + 1);
+		atomic_inc(&cache->nr_dirty);
 		policy_set_dirty(cache->policy, oblock);
 	}
 }
@@ -496,8 +496,7 @@ static void clear_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cbl
 {
 	if (test_and_clear_bit(from_cblock(cblock), cache->dirty_bitset)) {
 		policy_clear_dirty(cache->policy, oblock);
-		cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) - 1);
-		if (!from_cblock(cache->nr_dirty))
+		if (atomic_dec_return(&cache->nr_dirty) == 0)
 			dm_table_event(cache->ti->table);
 	}
 }
@@ -2275,7 +2274,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	atomic_set(&cache->quiescing_ack, 0);
 
 	r = -ENOMEM;
-	cache->nr_dirty = 0;
+	atomic_set(&cache->nr_dirty, 0);
 	cache->dirty_bitset = alloc_bitset(from_cblock(cache->cache_size));
 	if (!cache->dirty_bitset) {
 		*error = "could not allocate dirty bitset";
@@ -2816,7 +2815,7 @@ static void cache_status(struct dm_target *ti, status_type_t type,
 
 		residency = policy_residency(cache->policy);
 
-		DMEMIT("%llu/%llu %u %u %u %u %u %u %llu %u ",
+		DMEMIT("%llu/%llu %u %u %u %u %u %u %llu %lu ",
 		       (unsigned long long)(nr_blocks_metadata - nr_free_blocks_metadata),
 		       (unsigned long long)nr_blocks_metadata,
 		       (unsigned) atomic_read(&cache->stats.read_hit),
@@ -2826,7 +2825,7 @@ static void cache_status(struct dm_target *ti, status_type_t type,
 		       (unsigned) atomic_read(&cache->stats.demotion),
 		       (unsigned) atomic_read(&cache->stats.promotion),
 		       (unsigned long long) from_cblock(residency),
-		       cache->nr_dirty);
+		       (unsigned long) atomic_read(&cache->nr_dirty));
 
 		if (writethrough_mode(&cache->features))
 			DMEMIT("1 writethrough ");
-- 
1.9.1

