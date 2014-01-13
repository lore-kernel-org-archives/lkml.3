Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaAMLUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:20:01 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64779 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaAMLTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:19:36 -0500
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 6/7] zram: remove workqueue for freeing removed pending slot
Date: Mon, 13 Jan 2014 20:19:01 +0900
Message-Id: <1389611942-15544-7-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1389611942-15544-1-git-send-email-minchan@kernel.org>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
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
 drivers/block/zram/zram_drv.c | 54 +++++--------------------------------------
 drivers/block/zram/zram_drv.h | 10 --------
 2 files changed, 6 insertions(+), 58 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 24e6426..f1a3c95 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -522,20 +522,6 @@ out:
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
@@ -547,7 +533,6 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 		up_read(&zram->lock);
 	} else {
 		down_write(&zram->lock);
-		handle_pending_slot_free(zram);
 		ret = zram_bvec_write(zram, bvec, index, offset);
 		up_write(&zram->lock);
 	}
@@ -566,8 +551,6 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 		return;
 	}
 
-	flush_work(&zram->free_work);
-
 	meta = zram->meta;
 	zram->init_done = 0;
 
@@ -769,40 +752,19 @@ error:
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
@@ -849,10 +811,6 @@ static int create_device(struct zram *zram, int device_id)
 	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
 
-	INIT_WORK(&zram->free_work, zram_slot_free);
-	spin_lock_init(&zram->slot_free_lock);
-	zram->slot_free_rq = NULL;
-
 	zram->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index c3f453f..d876300 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -90,20 +90,11 @@ struct zram_meta {
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
@@ -114,7 +105,6 @@ struct zram {
 	 * we can store in a disk.
 	 */
 	u64 disksize;	/* bytes */
-	spinlock_t slot_free_lock;
 
 	struct zram_stats stats;
 };
-- 
1.8.4.3

