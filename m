Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3LRVPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:15:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3LRVOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.12 090/118] dm thin: always fallback the pool mode if commit fails
Date: Wed, 18 Dec 2013 13:12:07 -0800
Message-Id: <20131218211222.004512096@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 020cc3b5e28c2e24f59f53a9154faf08564f308e upstream.

Rename commit_or_fallback() to commit().  Now all previous calls to
commit() will trigger the pool mode to fallback if the commit fails.

Also, check the error returned from commit() in alloc_data_block().

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -883,32 +883,23 @@ static void schedule_zero(struct thin_c
 	}
 }
 
-static int commit(struct pool *pool)
-{
-	int r;
-
-	r = dm_pool_commit_metadata(pool->pmd);
-	if (r)
-		DMERR_LIMIT("%s: commit failed: error = %d",
-			    dm_device_name(pool->pool_md), r);
-
-	return r;
-}
-
 /*
  * A non-zero return indicates read_only or fail_io mode.
  * Many callers don't care about the return value.
  */
-static int commit_or_fallback(struct pool *pool)
+static int commit(struct pool *pool)
 {
 	int r;
 
 	if (get_pool_mode(pool) != PM_WRITE)
 		return -EINVAL;
 
-	r = commit(pool);
-	if (r)
+	r = dm_pool_commit_metadata(pool->pmd);
+	if (r) {
+		DMERR_LIMIT("%s: dm_pool_commit_metadata failed: error = %d",
+			    dm_device_name(pool->pool_md), r);
 		set_pool_mode(pool, PM_READ_ONLY);
+	}
 
 	return r;
 }
@@ -945,7 +936,9 @@ static int alloc_data_block(struct thin_
 		 * Try to commit to see if that will free up some
 		 * more space.
 		 */
-		(void) commit_or_fallback(pool);
+		r = commit(pool);
+		if (r)
+			return r;
 
 		r = dm_pool_get_free_block_count(pool->pmd, &free_blocks);
 		if (r)
@@ -1359,7 +1352,7 @@ static void process_deferred_bios(struct
 	if (bio_list_empty(&bios) && !need_commit_due_to_time(pool))
 		return;
 
-	if (commit_or_fallback(pool)) {
+	if (commit(pool)) {
 		while ((bio = bio_list_pop(&bios)))
 			bio_io_error(bio);
 		return;
@@ -2276,7 +2269,7 @@ static int pool_preresume(struct dm_targ
 		return r;
 
 	if (need_commit1 || need_commit2)
-		(void) commit_or_fallback(pool);
+		(void) commit(pool);
 
 	return 0;
 }
@@ -2303,7 +2296,7 @@ static void pool_postsuspend(struct dm_t
 
 	cancel_delayed_work(&pool->waker);
 	flush_workqueue(pool->wq);
-	(void) commit_or_fallback(pool);
+	(void) commit(pool);
 }
 
 static int check_arg_count(unsigned argc, unsigned args_required)
@@ -2437,7 +2430,7 @@ static int process_reserve_metadata_snap
 	if (r)
 		return r;
 
-	(void) commit_or_fallback(pool);
+	(void) commit(pool);
 
 	r = dm_pool_reserve_metadata_snap(pool->pmd);
 	if (r)
@@ -2499,7 +2492,7 @@ static int pool_message(struct dm_target
 		DMWARN("Unrecognised thin pool target message received: %s", argv[0]);
 
 	if (!r)
-		(void) commit_or_fallback(pool);
+		(void) commit(pool);
 
 	return r;
 }
@@ -2554,7 +2547,7 @@ static void pool_status(struct dm_target
 
 		/* Commit to ensure statistics aren't out-of-date */
 		if (!(status_flags & DM_STATUS_NOFLUSH_FLAG) && !dm_suspended(ti))
-			(void) commit_or_fallback(pool);
+			(void) commit(pool);
 
 		r = dm_pool_get_metadata_transaction_id(pool->pmd, &transaction_id);
 		if (r) {


