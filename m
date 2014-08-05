Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbaHESoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:44:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaHESOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        roma1390@gmail.com, Anssi Hannula <anssi.hannula@iki.fi>,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.15 22/42] dm cache: fix race affecting dirty block count
Date: Tue,  5 Aug 2014 11:13:36 -0700
Message-Id: <20140805181321.681131953@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181321.018370988@linuxfoundation.org>
References: <20140805181321.018370988@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -231,7 +231,7 @@ struct cache {
 	/*
 	 * cache_size entries, dirty if set
 	 */
-	dm_cblock_t nr_dirty;
+	atomic_t nr_dirty;
 	unsigned long *dirty_bitset;
 
 	/*
@@ -492,7 +492,7 @@ static bool is_dirty(struct cache *cache
 static void set_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cblock)
 {
 	if (!test_and_set_bit(from_cblock(cblock), cache->dirty_bitset)) {
-		cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) + 1);
+		atomic_inc(&cache->nr_dirty);
 		policy_set_dirty(cache->policy, oblock);
 	}
 }
@@ -501,8 +501,7 @@ static void clear_dirty(struct cache *ca
 {
 	if (test_and_clear_bit(from_cblock(cblock), cache->dirty_bitset)) {
 		policy_clear_dirty(cache->policy, oblock);
-		cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) - 1);
-		if (!from_cblock(cache->nr_dirty))
+		if (atomic_dec_return(&cache->nr_dirty) == 0)
 			dm_table_event(cache->ti->table);
 	}
 }
@@ -2269,7 +2268,7 @@ static int cache_create(struct cache_arg
 	atomic_set(&cache->quiescing_ack, 0);
 
 	r = -ENOMEM;
-	cache->nr_dirty = 0;
+	atomic_set(&cache->nr_dirty, 0);
 	cache->dirty_bitset = alloc_bitset(from_cblock(cache->cache_size));
 	if (!cache->dirty_bitset) {
 		*error = "could not allocate dirty bitset";
@@ -2808,7 +2807,7 @@ static void cache_status(struct dm_targe
 
 		residency = policy_residency(cache->policy);
 
-		DMEMIT("%u %llu/%llu %u %llu/%llu %u %u %u %u %u %u %llu ",
+		DMEMIT("%u %llu/%llu %u %llu/%llu %u %u %u %u %u %u %lu ",
 		       (unsigned)(DM_CACHE_METADATA_BLOCK_SIZE >> SECTOR_SHIFT),
 		       (unsigned long long)(nr_blocks_metadata - nr_free_blocks_metadata),
 		       (unsigned long long)nr_blocks_metadata,
@@ -2821,7 +2820,7 @@ static void cache_status(struct dm_targe
 		       (unsigned) atomic_read(&cache->stats.write_miss),
 		       (unsigned) atomic_read(&cache->stats.demotion),
 		       (unsigned) atomic_read(&cache->stats.promotion),
-		       (unsigned long long) from_cblock(cache->nr_dirty));
+		       (unsigned long) atomic_read(&cache->nr_dirty));
 
 		if (writethrough_mode(&cache->features))
 			DMEMIT("1 writethrough ");


