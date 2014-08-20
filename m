Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaHTMLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:11:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58880 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anssi Hannula <anssi.hannula@iki.fi>,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 016/104] dm cache: fix race affecting dirty block count
Date: Wed, 20 Aug 2014 13:42:39 +0200
Message-Id: <49cbb95e7c78ca45aad2d985fc7f186ec6020dbc.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anssi Hannula <anssi.hannula@iki.fi>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-cache-target.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 0cf3700bfe9e..4c0b921ab5b3 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -154,7 +154,7 @@ struct cache {
 	/*
 	 * cache_size entries, dirty if set
 	 */
-	dm_cblock_t nr_dirty;
+	atomic_t nr_dirty;
 	unsigned long *dirty_bitset;
 
 	/*
@@ -408,7 +408,7 @@ static bool is_dirty(struct cache *cache, dm_cblock_t b)
 static void set_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cblock)
 {
 	if (!test_and_set_bit(from_cblock(cblock), cache->dirty_bitset)) {
-		cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) + 1);
+		atomic_inc(&cache->nr_dirty);
 		policy_set_dirty(cache->policy, oblock);
 	}
 }
@@ -417,8 +417,7 @@ static void clear_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cbl
 {
 	if (test_and_clear_bit(from_cblock(cblock), cache->dirty_bitset)) {
 		policy_clear_dirty(cache->policy, oblock);
-		cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) - 1);
-		if (!from_cblock(cache->nr_dirty))
+		if (atomic_dec_return(&cache->nr_dirty) == 0)
 			dm_table_event(cache->ti->table);
 	}
 }
@@ -2006,7 +2005,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	atomic_set(&cache->quiescing_ack, 0);
 
 	r = -ENOMEM;
-	cache->nr_dirty = 0;
+	atomic_set(&cache->nr_dirty, 0);
 	cache->dirty_bitset = alloc_bitset(from_cblock(cache->cache_size));
 	if (!cache->dirty_bitset) {
 		*error = "could not allocate dirty bitset";
@@ -2502,7 +2501,7 @@ static void cache_status(struct dm_target *ti, status_type_t type,
 
 		residency = policy_residency(cache->policy);
 
-		DMEMIT("%llu/%llu %u %u %u %u %u %u %llu %u ",
+		DMEMIT("%llu/%llu %u %u %u %u %u %u %llu %lu ",
 		       (unsigned long long)(nr_blocks_metadata - nr_free_blocks_metadata),
 		       (unsigned long long)nr_blocks_metadata,
 		       (unsigned) atomic_read(&cache->stats.read_hit),
@@ -2512,7 +2511,7 @@ static void cache_status(struct dm_target *ti, status_type_t type,
 		       (unsigned) atomic_read(&cache->stats.demotion),
 		       (unsigned) atomic_read(&cache->stats.promotion),
 		       (unsigned long long) from_cblock(residency),
-		       cache->nr_dirty);
+		       (unsigned long) atomic_read(&cache->nr_dirty));
 
 		if (cache->features.write_through)
 			DMEMIT("1 writethrough ");
-- 
2.0.4

