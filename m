Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaHCCAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 22:00:14 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:46545 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaHCCAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 22:00:13 -0400
Message-ID: <53DD97B0.8040001@gmail.com>
Date: Sat, 02 Aug 2014 22:00:16 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: annsi.hannula@iki.fr
CC: ejt@redhat.com, snitzer@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] dm cache: fix race affecting dirty block count
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Anssi, Joe, Mike,

I just found your patch in the latest rc and wanted to ask a few
questions. I am not sure how this patch helps at all other than luck in
that dm_cblock_t type is of type int32_t, which should guarantee that it
is atomic on most platforms. Which begs the question, what platform did
you encounter this problem?

The patch purports to solve a race condition by making use of atomic_t.
I am not sure that is enough. If indeed there is a race you need to use
smp_mb__{before/after}_atomic() for both your uses of atomic_inc() and
atomic_set(). 

Also I have a concern about why this mail was not CC'ed on LKML. I had
to go to some difficulty in finding this patch. So please CC LKML for
such patches.

Thanks,
-- 
Pranith

-- Begin forwarded Message --


nr_dirty is updated without locking, causing it to drift so that it is
non-zero (either a small positive integer, or a very large one when an
underflow occurs) even when there are no actual dirty blocks.

Fix that by using an atomic type for nr_dirty.

Signed-off-by: Anssi Hannula <anssi hannula iki fi>
Cc: Joe Thornber <ejt redhat com>
Cc: stable vger kernel org

---

So here's a patch for the issue I reported a few days ago.

I'm not sure what the actual effects of having wrong nr_dirty are
beyond the wrong value reported to userspace. Having wrong nr_dirty
causes dm_table_event(cache->ti->table) to be called at incorrect times,
but I'm not sure what the implications of that are.

So someone more knowledged should really amend my commit message
accordingly so that it explains the user-visible issues :)

I did notice that after a reboot (after having incorrect nr_dirty) the
entire cache was considered to be dirty and a full writeback occurred,
but I don't know if that was related at all.


 drivers/md/dm-cache-target.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 0df3ec085ebb..83a7eb5ef113 100644
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
@@ -403,7 +403,7 @@ static bool is_dirty(struct cache *cache, dm_cblock_t b)
 static void set_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cblock)
 {
 	if (!test_and_set_bit(from_cblock(cblock), cache->dirty_bitset)) {
-		cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) + 1);
+		atomic_inc(&cache->nr_dirty);
 		policy_set_dirty(cache->policy, oblock);
 	}
 }
@@ -412,8 +412,7 @@ static void clear_dirty(struct cache *cache, dm_oblock_t oblock, dm_cblock_t cbl
 {
 	if (test_and_clear_bit(from_cblock(cblock), cache->dirty_bitset)) {
 		policy_clear_dirty(cache->policy, oblock);
-		cache->nr_dirty = to_cblock(from_cblock(cache->nr_dirty) - 1);
-		if (!from_cblock(cache->nr_dirty))
+		if (atomic_dec_return(&cache->nr_dirty) == 0)
 			dm_table_event(cache->ti->table);
 	}
 }
@@ -2003,7 +2002,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	init_waitqueue_head(&cache->migration_wait);
 
 	r = -ENOMEM;
-	cache->nr_dirty = 0;
+	atomic_set(&cache->nr_dirty, 0);
 	cache->dirty_bitset = alloc_bitset(from_cblock(cache->cache_size));
 	if (!cache->dirty_bitset) {
 		*error = "could not allocate dirty bitset";
@@ -2513,7 +2512,7 @@ static void cache_status(struct dm_target *ti, status_type_t type,
 		       (unsigned) atomic_read(&cache->stats.demotion),
 		       (unsigned) atomic_read(&cache->stats.promotion),
 		       (unsigned long long) from_cblock(residency),
-		       cache->nr_dirty);
+		       (unsigned) atomic_read(&cache->nr_dirty));
 
 		if (cache->features.write_through)
 			DMEMIT("1 writethrough ");
-- 
1.8.4.5

-- End forwarded Message --

