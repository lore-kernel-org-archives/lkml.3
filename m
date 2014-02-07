Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaBGLrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:47:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41416 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaBGLrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:47:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 010/233] dm thin: always fallback the pool mode if commit fails
Date: Fri,  7 Feb 2014 11:43:49 +0000
Message-Id: <1391773652-25214-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 020cc3b5e28c2e24f59f53a9154faf08564f308e upstream.

Rename commit_or_fallback() to commit().  Now all previous calls to
commit() will trigger the pool mode to fallback if the commit fails.

Also, check the error returned from commit() in alloc_data_block().

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-thin.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 49ec256..38c8a5f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -883,31 +883,23 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	}
 }
 
-static int commit(struct pool *pool)
-{
-	int r;
-
-	r = dm_pool_commit_metadata(pool->pmd);
-	if (r)
-		DMERR_LIMIT("commit failed: error = %d", r);
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
@@ -940,7 +932,9 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 			 * Try to commit to see if that will free up some
 			 * more space.
 			 */
-			(void) commit_or_fallback(pool);
+			r = commit(pool);
+			if (r)
+				return r;
 
 			r = dm_pool_get_free_block_count(pool->pmd, &free_blocks);
 			if (r)
@@ -1350,7 +1344,7 @@ static void process_deferred_bios(struct pool *pool)
 	if (bio_list_empty(&bios) && !need_commit_due_to_time(pool))
 		return;
 
-	if (commit_or_fallback(pool)) {
+	if (commit(pool)) {
 		while ((bio = bio_list_pop(&bios)))
 			bio_io_error(bio);
 		return;
@@ -2267,7 +2261,7 @@ static int pool_preresume(struct dm_target *ti)
 		return r;
 
 	if (need_commit1 || need_commit2)
-		(void) commit_or_fallback(pool);
+		(void) commit(pool);
 
 	return 0;
 }
@@ -2294,7 +2288,7 @@ static void pool_postsuspend(struct dm_target *ti)
 
 	cancel_delayed_work(&pool->waker);
 	flush_workqueue(pool->wq);
-	(void) commit_or_fallback(pool);
+	(void) commit(pool);
 }
 
 static int check_arg_count(unsigned argc, unsigned args_required)
@@ -2428,7 +2422,7 @@ static int process_reserve_metadata_snap_mesg(unsigned argc, char **argv, struct
 	if (r)
 		return r;
 
-	(void) commit_or_fallback(pool);
+	(void) commit(pool);
 
 	r = dm_pool_reserve_metadata_snap(pool->pmd);
 	if (r)
@@ -2490,7 +2484,7 @@ static int pool_message(struct dm_target *ti, unsigned argc, char **argv)
 		DMWARN("Unrecognised thin pool target message received: %s", argv[0]);
 
 	if (!r)
-		(void) commit_or_fallback(pool);
+		(void) commit(pool);
 
 	return r;
 }
@@ -2545,7 +2539,7 @@ static void pool_status(struct dm_target *ti, status_type_t type,
 
 		/* Commit to ensure statistics aren't out-of-date */
 		if (!(status_flags & DM_STATUS_NOFLUSH_FLAG) && !dm_suspended(ti))
-			(void) commit_or_fallback(pool);
+			(void) commit(pool);
 
 		r = dm_pool_get_metadata_transaction_id(pool->pmd, &transaction_id);
 		if (r) {
-- 
1.8.3.2

