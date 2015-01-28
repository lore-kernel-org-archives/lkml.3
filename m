Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbbA2JAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:38 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756097AbbA2JAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 149/176] dm cache: fix problematic dual use of a single migration count variable
Date: Wed, 28 Jan 2015 15:29:39 +0100
Message-Id: <930a0efdcff8eadc3ad094a5851e0ed030e7db68.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a59db67656021fa212e9b95a583f13c34eb67cd9 upstream.

Introduce a new variable to count the number of allocated migration
structures.  The existing variable cache->nr_migrations became
overloaded.  It was used to:

 i) track of the number of migrations in flight for the purposes of
    quiescing during suspend.

 ii) to estimate the amount of background IO occuring.

Recent discard changes meant that REQ_DISCARD bios are processed with
a migration.  Discards are not background IO so nr_migrations was not
incremented.  However this could cause quiescing to complete early.

(i) is now handled with a new variable cache->nr_allocated_migrations.
cache->nr_migrations has been renamed cache->nr_io_migrations.
cleanup_migration() is now called free_io_migration(), since it
decrements that variable.

Also, remove the unused cache->next_migration variable that got replaced
with with prealloc_structs a while ago.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-cache-target.c | 87 +++++++++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 38 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 843af26e9050..17718456587c 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -146,7 +146,13 @@ struct cache {
 	struct list_head need_commit_migrations;
 	sector_t migration_threshold;
 	wait_queue_head_t migration_wait;
-	atomic_t nr_migrations;
+	atomic_t nr_allocated_migrations;
+
+	/*
+	 * The number of in flight migrations that are performing
+	 * background io. eg, promotion, writeback.
+	 */
+	atomic_t nr_io_migrations;
 
 	wait_queue_head_t quiescing_wait;
 	atomic_t quiescing_ack;
@@ -182,7 +188,6 @@ struct cache {
 	struct dm_deferred_set *all_io_ds;
 
 	mempool_t *migration_pool;
-	struct dm_cache_migration *next_migration;
 
 	struct dm_cache_policy *policy;
 	unsigned policy_nr_args;
@@ -265,10 +270,31 @@ static void free_prison_cell(struct cache *cache, struct dm_bio_prison_cell *cel
 	dm_bio_prison_free_cell(cache->prison, cell);
 }
 
+static struct dm_cache_migration *alloc_migration(struct cache *cache)
+{
+	struct dm_cache_migration *mg;
+
+	mg = mempool_alloc(cache->migration_pool, GFP_NOWAIT);
+	if (mg) {
+		mg->cache = cache;
+		atomic_inc(&mg->cache->nr_allocated_migrations);
+	}
+
+	return mg;
+}
+
+static void free_migration(struct dm_cache_migration *mg)
+{
+	if (atomic_dec_and_test(&mg->cache->nr_allocated_migrations))
+		wake_up(&mg->cache->migration_wait);
+
+	mempool_free(mg, mg->cache->migration_pool);
+}
+
 static int prealloc_data_structs(struct cache *cache, struct prealloc *p)
 {
 	if (!p->mg) {
-		p->mg = mempool_alloc(cache->migration_pool, GFP_NOWAIT);
+		p->mg = alloc_migration(cache);
 		if (!p->mg)
 			return -ENOMEM;
 	}
@@ -297,7 +323,7 @@ static void prealloc_free_structs(struct cache *cache, struct prealloc *p)
 		free_prison_cell(cache, p->cell1);
 
 	if (p->mg)
-		mempool_free(p->mg, cache->migration_pool);
+		free_migration(p->mg);
 }
 
 static struct dm_cache_migration *prealloc_get_migration(struct prealloc *p)
@@ -708,24 +734,14 @@ static void remap_to_origin_then_cache(struct cache *cache, struct bio *bio,
  * Migration covers moving data from the origin device to the cache, or
  * vice versa.
  *--------------------------------------------------------------*/
-static void free_migration(struct dm_cache_migration *mg)
-{
-	mempool_free(mg, mg->cache->migration_pool);
-}
-
-static void inc_nr_migrations(struct cache *cache)
+static void inc_io_migrations(struct cache *cache)
 {
-	atomic_inc(&cache->nr_migrations);
+	atomic_inc(&cache->nr_io_migrations);
 }
 
-static void dec_nr_migrations(struct cache *cache)
+static void dec_io_migrations(struct cache *cache)
 {
-	atomic_dec(&cache->nr_migrations);
-
-	/*
-	 * Wake the worker in case we're suspending the target.
-	 */
-	wake_up(&cache->migration_wait);
+	atomic_dec(&cache->nr_io_migrations);
 }
 
 static void __cell_defer(struct cache *cache, struct dm_bio_prison_cell *cell,
@@ -748,11 +764,10 @@ static void cell_defer(struct cache *cache, struct dm_bio_prison_cell *cell,
 	wake_worker(cache);
 }
 
-static void cleanup_migration(struct dm_cache_migration *mg)
+static void free_io_migration(struct dm_cache_migration *mg)
 {
-	struct cache *cache = mg->cache;
+	dec_io_migrations(mg->cache);
 	free_migration(mg);
-	dec_nr_migrations(cache);
 }
 
 static void migration_failure(struct dm_cache_migration *mg)
@@ -777,7 +792,7 @@ static void migration_failure(struct dm_cache_migration *mg)
 		cell_defer(cache, mg->new_ocell, 1);
 	}
 
-	cleanup_migration(mg);
+	free_io_migration(mg);
 }
 
 static void migration_success_pre_commit(struct dm_cache_migration *mg)
@@ -788,7 +803,7 @@ static void migration_success_pre_commit(struct dm_cache_migration *mg)
 	if (mg->writeback) {
 		clear_dirty(cache, mg->old_oblock, mg->cblock);
 		cell_defer(cache, mg->old_ocell, false);
-		cleanup_migration(mg);
+		free_io_migration(mg);
 		return;
 
 	} else if (mg->demote) {
@@ -798,14 +813,14 @@ static void migration_success_pre_commit(struct dm_cache_migration *mg)
 					     mg->old_oblock);
 			if (mg->promote)
 				cell_defer(cache, mg->new_ocell, true);
-			cleanup_migration(mg);
+			free_io_migration(mg);
 			return;
 		}
 	} else {
 		if (dm_cache_insert_mapping(cache->cmd, mg->cblock, mg->new_oblock)) {
 			DMWARN_LIMIT("promotion failed; couldn't update on disk metadata");
 			policy_remove_mapping(cache->policy, mg->new_oblock);
-			cleanup_migration(mg);
+			free_io_migration(mg);
 			return;
 		}
 	}
@@ -836,12 +851,12 @@ static void migration_success_post_commit(struct dm_cache_migration *mg)
 			spin_unlock_irqrestore(&cache->lock, flags);
 
 		} else
-			cleanup_migration(mg);
+			free_io_migration(mg);
 
 	} else {
 		clear_dirty(cache, mg->new_oblock, mg->cblock);
 		cell_defer(cache, mg->new_ocell, true);
-		cleanup_migration(mg);
+		free_io_migration(mg);
 	}
 }
 
@@ -1002,7 +1017,7 @@ static void promote(struct cache *cache, struct prealloc *structs,
 	mg->new_ocell = cell;
 	mg->start_jiffies = jiffies;
 
-	inc_nr_migrations(cache);
+	inc_io_migrations(cache);
 	quiesce_migration(mg);
 }
 
@@ -1023,7 +1038,7 @@ static void writeback(struct cache *cache, struct prealloc *structs,
 	mg->new_ocell = NULL;
 	mg->start_jiffies = jiffies;
 
-	inc_nr_migrations(cache);
+	inc_io_migrations(cache);
 	quiesce_migration(mg);
 }
 
@@ -1047,7 +1062,7 @@ static void demote_then_promote(struct cache *cache, struct prealloc *structs,
 	mg->new_ocell = new_ocell;
 	mg->start_jiffies = jiffies;
 
-	inc_nr_migrations(cache);
+	inc_io_migrations(cache);
 	quiesce_migration(mg);
 }
 
@@ -1108,7 +1123,7 @@ static void process_discard_bio(struct cache *cache, struct bio *bio)
 
 static bool spare_migration_bandwidth(struct cache *cache)
 {
-	sector_t current_volume = (atomic_read(&cache->nr_migrations) + 1) *
+	sector_t current_volume = (atomic_read(&cache->nr_io_migrations) + 1) *
 		cache->sectors_per_block;
 	return current_volume < cache->migration_threshold;
 }
@@ -1399,7 +1414,7 @@ static void stop_quiescing(struct cache *cache)
 
 static void wait_for_migrations(struct cache *cache)
 {
-	wait_event(cache->migration_wait, !atomic_read(&cache->nr_migrations));
+	wait_event(cache->migration_wait, !atomic_read(&cache->nr_allocated_migrations));
 }
 
 static void stop_worker(struct cache *cache)
@@ -1508,9 +1523,6 @@ static void destroy(struct cache *cache)
 {
 	unsigned i;
 
-	if (cache->next_migration)
-		mempool_free(cache->next_migration, cache->migration_pool);
-
 	if (cache->migration_pool)
 		mempool_destroy(cache->migration_pool);
 
@@ -1998,7 +2010,8 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	INIT_LIST_HEAD(&cache->quiesced_migrations);
 	INIT_LIST_HEAD(&cache->completed_migrations);
 	INIT_LIST_HEAD(&cache->need_commit_migrations);
-	atomic_set(&cache->nr_migrations, 0);
+	atomic_set(&cache->nr_allocated_migrations, 0);
+	atomic_set(&cache->nr_io_migrations, 0);
 	init_waitqueue_head(&cache->migration_wait);
 
 	init_waitqueue_head(&cache->quiescing_wait);
@@ -2057,8 +2070,6 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 		goto bad;
 	}
 
-	cache->next_migration = NULL;
-
 	cache->need_tick_bio = true;
 	cache->sized = false;
 	cache->quiescing = false;
-- 
2.2.2

