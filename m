Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaAOBKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:10:37 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58308 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaAOBKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:10:32 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-ee-52d5e002c036
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v2 3/4] zram: remove workqueue for freeing removed pending slot
Date: Wed, 15 Jan 2014 10:11:09 +0900
Message-Id: <1389748270-15618-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389748270-15618-1-git-send-email-minchan@kernel.org>
References: <1389748270-15618-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] introduced free request pending code to avoid scheduling
by mutex under spinlock and it was a mess which made code
lenghty and increased overhead.

Now, we don't need zram->lock any more to free slot so
this patch reverts it and then, tb_lock should protect it.

[1] a0c516c, zram: don't grab mutex in zram_slot_free_noity
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/zram_drv.c | 54 +++++------------------------------------
 drivers/staging/zram/zram_drv.h | 10 --------
 2 files changed, 6 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 8636f8511518..cdc8697476b3 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -521,20 +521,6 @@ out:
 	return ret;
 }
 
-static void handle_pending_slot_free(struct zram *zram)
-{
-	struct zram_slot_free *free_rq;
-
-	spin_lock(&zram->slot_free_lock);
-	while (zram->slot_free_rq) {
-		free_rq = zram->slot_free_rq;
-		zram->slot_free_rq = free_rq->next;
-		zram_free_page(zram, free_rq->index);
-		kfree(free_rq);
-	}
-	spin_unlock(&zram->slot_free_lock);
-}
-
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 			int offset, struct bio *bio, int rw)
 {
@@ -546,7 +532,6 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 		up_read(&zram->lock);
 	} else {
 		down_write(&zram->lock);
-		handle_pending_slot_free(zram);
 		ret = zram_bvec_write(zram, bvec, index, offset);
 		up_write(&zram->lock);
 	}
@@ -565,8 +550,6 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 		return;
 	}
 
-	flush_work(&zram->free_work);
-
 	meta = zram->meta;
 	zram->init_done = 0;
 
@@ -766,40 +749,19 @@ error:
 	bio_io_error(bio);
 }
 
-static void zram_slot_free(struct work_struct *work)
-{
-	struct zram *zram;
-
-	zram = container_of(work, struct zram, free_work);
-	down_write(&zram->lock);
-	handle_pending_slot_free(zram);
-	up_write(&zram->lock);
-}
-
-static void add_slot_free(struct zram *zram, struct zram_slot_free *free_rq)
-{
-	spin_lock(&zram->slot_free_lock);
-	free_rq->next = zram->slot_free_rq;
-	zram->slot_free_rq = free_rq;
-	spin_unlock(&zram->slot_free_lock);
-}
-
 static void zram_slot_free_notify(struct block_device *bdev,
 				unsigned long index)
 {
 	struct zram *zram;
-	struct zram_slot_free *free_rq;
+	struct zram_meta *meta;
 
 	zram = bdev->bd_disk->private_data;
-	atomic64_inc(&zram->stats.notify_free);
-
-	free_rq = kmalloc(sizeof(struct zram_slot_free), GFP_ATOMIC);
-	if (!free_rq)
-		return;
+	meta = zram->meta;
 
-	free_rq->index = index;
-	add_slot_free(zram, free_rq);
-	schedule_work(&zram->free_work);
+	write_lock(&meta->tb_lock);
+	zram_free_page(zram, index);
+	write_unlock(&meta->tb_lock);
+	atomic64_inc(&zram->stats.notify_free);
 }
 
 static const struct block_device_operations zram_devops = {
@@ -846,10 +808,6 @@ static int create_device(struct zram *zram, int device_id)
 	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
 
-	INIT_WORK(&zram->free_work, zram_slot_free);
-	spin_lock_init(&zram->slot_free_lock);
-	zram->slot_free_rq = NULL;
-
 	zram->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index cf64bea3f7cc..b371ae23421a 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -91,20 +91,11 @@ struct zram_meta {
 	struct zs_pool *mem_pool;
 };
 
-struct zram_slot_free {
-	unsigned long index;
-	struct zram_slot_free *next;
-};
-
 struct zram {
 	struct zram_meta *meta;
 	struct rw_semaphore lock; /* protect compression buffers,
 				   * reads and writes
 				   */
-
-	struct work_struct free_work;  /* handle pending free request */
-	struct zram_slot_free *slot_free_rq; /* list head of free request */
-
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;
@@ -115,7 +106,6 @@ struct zram {
 	 * we can store in a disk.
 	 */
 	u64 disksize;	/* bytes */
-	spinlock_t slot_free_lock;
 
 	struct zram_stats stats;
 };
-- 
1.8.5.2

