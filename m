Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab3LBVA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:00:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3LBTNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.10 071/173] dm cache: fix a race condition between queuing new migrations and quiescing for a shutdown
Date: Mon,  2 Dec 2013 11:10:54 -0800
Message-Id: <20131202191151.152866932@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 66cb1910df17b38334153462ec8166e48058035f upstream.

The code that was trying to do this was inadequate.  The postsuspend
method (in ioctl context), needs to wait for the worker thread to
acknowledge the request to quiesce.  Otherwise the migration count may
drop to zero temporarily before the worker thread realises we're
quiescing.  In this case the target will be taken down, but the worker
thread may have issued a new migration, which will cause an oops when
it completes.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |   54 +++++++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 14 deletions(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -151,6 +151,9 @@ struct cache {
 	atomic_t nr_migrations;
 	wait_queue_head_t migration_wait;
 
+	wait_queue_head_t quiescing_wait;
+	atomic_t quiescing_ack;
+
 	/*
 	 * cache_size entries, dirty if set
 	 */
@@ -742,8 +745,9 @@ static void cell_defer(struct cache *cac
 
 static void cleanup_migration(struct dm_cache_migration *mg)
 {
-	dec_nr_migrations(mg->cache);
+	struct cache *cache = mg->cache;
 	free_migration(mg);
+	dec_nr_migrations(cache);
 }
 
 static void migration_failure(struct dm_cache_migration *mg)
@@ -1340,34 +1344,51 @@ static void writeback_some_dirty_blocks(
 /*----------------------------------------------------------------
  * Main worker loop
  *--------------------------------------------------------------*/
-static void start_quiescing(struct cache *cache)
+static bool is_quiescing(struct cache *cache)
 {
+	int r;
 	unsigned long flags;
 
 	spin_lock_irqsave(&cache->lock, flags);
-	cache->quiescing = 1;
+	r = cache->quiescing;
 	spin_unlock_irqrestore(&cache->lock, flags);
+
+	return r;
 }
 
-static void stop_quiescing(struct cache *cache)
+static void ack_quiescing(struct cache *cache)
+{
+	if (is_quiescing(cache)) {
+		atomic_inc(&cache->quiescing_ack);
+		wake_up(&cache->quiescing_wait);
+	}
+}
+
+static void wait_for_quiescing_ack(struct cache *cache)
+{
+	wait_event(cache->quiescing_wait, atomic_read(&cache->quiescing_ack));
+}
+
+static void start_quiescing(struct cache *cache)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cache->lock, flags);
-	cache->quiescing = 0;
+	cache->quiescing = true;
 	spin_unlock_irqrestore(&cache->lock, flags);
+
+	wait_for_quiescing_ack(cache);
 }
 
-static bool is_quiescing(struct cache *cache)
+static void stop_quiescing(struct cache *cache)
 {
-	int r;
 	unsigned long flags;
 
 	spin_lock_irqsave(&cache->lock, flags);
-	r = cache->quiescing;
+	cache->quiescing = false;
 	spin_unlock_irqrestore(&cache->lock, flags);
 
-	return r;
+	atomic_set(&cache->quiescing_ack, 0);
 }
 
 static void wait_for_migrations(struct cache *cache)
@@ -1414,16 +1435,15 @@ static void do_worker(struct work_struct
 	struct cache *cache = container_of(ws, struct cache, worker);
 
 	do {
-		if (!is_quiescing(cache))
+		if (!is_quiescing(cache)) {
+			writeback_some_dirty_blocks(cache);
+			process_deferred_writethrough_bios(cache);
 			process_deferred_bios(cache);
+		}
 
 		process_migrations(cache, &cache->quiesced_migrations, issue_copy);
 		process_migrations(cache, &cache->completed_migrations, complete_migration);
 
-		writeback_some_dirty_blocks(cache);
-
-		process_deferred_writethrough_bios(cache);
-
 		if (commit_if_needed(cache)) {
 			process_deferred_flush_bios(cache, false);
 
@@ -1436,6 +1456,9 @@ static void do_worker(struct work_struct
 			process_migrations(cache, &cache->need_commit_migrations,
 					   migration_success_post_commit);
 		}
+
+		ack_quiescing(cache);
+
 	} while (more_work(cache));
 }
 
@@ -1998,6 +2021,9 @@ static int cache_create(struct cache_arg
 	atomic_set(&cache->nr_migrations, 0);
 	init_waitqueue_head(&cache->migration_wait);
 
+	init_waitqueue_head(&cache->quiescing_wait);
+	atomic_set(&cache->quiescing_ack, 0);
+
 	r = -ENOMEM;
 	cache->nr_dirty = 0;
 	cache->dirty_bitset = alloc_bitset(from_cblock(cache->cache_size));


