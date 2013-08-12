Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3HLGOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 02:14:17 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:64020 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3HLGOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 02:14:02 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-5b-52087d2615ce
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Jiang Liu <jiang.liu@huawei.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] zram: don't grab mutex in zram_slot_free_noity
Date: Mon, 12 Aug 2013 15:13:56 +0900
Message-Id: <1376288036-14628-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376288036-14628-1-git-send-email-minchan@kernel.org>
References: <1376288036-14628-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] introduced down_write in zram_slot_free_notify to prevent race
between zram_slot_free_notify and zram_bvec_[read|write]. The race
could happen if somebody who has right permission to open swap device
is reading swap device while it is used by swap in parallel.

However, zram_slot_free_notify is called with holding spin_lock of
swap layer so we shouldn't avoid holing mutex. Otherwise, lockdep
warns it.

This patch adds new list to handle free slot and workqueue
so zram_slot_free_notify just registers slot index to be freed and
registers the request to workqueue. If workqueue is expired,
it holds mutex_lock so there is no problem any more.

If any I/O is issued, zram handles pending slot-free request
caused by zram_slot_free_notify right before handling issued
request because workqueue wouldn't be expired yet so zram I/O
request handling function can miss it.

Lastly, when zram is reset, flush_work could handle all of pending
free request so we shouldn't have memory leak.

NOTE: If zram_slot_free_notify's kmalloc with GFP_ATOMIC would be
failed, the slot will be freed when next write I/O write the slot.

[1] [57ab0485, zram: use zram->lock to protect zram_free_page()
    in swap free notify path]

* from v2
  * refactoring

* from v1
  * totally redesign

Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/zram_drv.c |   60 +++++++++++++++++++++++++++++++++++++--
 drivers/staging/zram/zram_drv.h |   10 +++++++
 2 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index ebf9d6c..10b9c77 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -440,6 +440,14 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto out;
 	}
 
+	/*
+	 * zram_slot_free_notify could miss free so that let's
+	 * double check.
+	 */
+	if (unlikely(meta->table[index].handle ||
+			zram_test_flag(meta, index, ZRAM_ZERO)))
+		zram_free_page(zram, index);
+
 	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
 			       meta->compress_workmem);
 
@@ -505,6 +513,20 @@ out:
 	return ret;
 }
 
+static void handle_pending_slot_free(struct zram *zram)
+{
+	struct zram_slot_free *free_rq;
+
+	spin_lock(&zram->slot_free_lock);
+	while (zram->slot_free_rq) {
+		free_rq = zram->slot_free_rq;
+		zram->slot_free_rq = free_rq->next;
+		zram_free_page(zram, free_rq->index);
+		kfree(free_rq);
+	}
+	spin_unlock(&zram->slot_free_lock);
+}
+
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 			int offset, struct bio *bio, int rw)
 {
@@ -512,10 +534,12 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	if (rw == READ) {
 		down_read(&zram->lock);
+		handle_pending_slot_free(zram);
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
 		up_read(&zram->lock);
 	} else {
 		down_write(&zram->lock);
+		handle_pending_slot_free(zram);
 		ret = zram_bvec_write(zram, bvec, index, offset);
 		up_write(&zram->lock);
 	}
@@ -528,6 +552,8 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 	size_t index;
 	struct zram_meta *meta;
 
+	flush_work(&zram->free_work);
+
 	down_write(&zram->init_lock);
 	if (!zram->init_done) {
 		up_write(&zram->init_lock);
@@ -722,16 +748,40 @@ error:
 	bio_io_error(bio);
 }
 
+static void zram_slot_free(struct work_struct *work)
+{
+	struct zram *zram;
+
+	zram = container_of(work, struct zram, free_work);
+	down_write(&zram->lock);
+	handle_pending_slot_free(zram);
+	up_write(&zram->lock);
+}
+
+static void add_slot_free(struct zram *zram, struct zram_slot_free *free_rq)
+{
+	spin_lock(&zram->slot_free_lock);
+	free_rq->next = zram->slot_free_rq;
+	zram->slot_free_rq = free_rq;
+	spin_unlock(&zram->slot_free_lock);
+}
+
 static void zram_slot_free_notify(struct block_device *bdev,
 				unsigned long index)
 {
 	struct zram *zram;
+	struct zram_slot_free *free_rq;
 
 	zram = bdev->bd_disk->private_data;
-	down_write(&zram->lock);
-	zram_free_page(zram, index);
-	up_write(&zram->lock);
 	atomic64_inc(&zram->stats.notify_free);
+
+	free_rq = kmalloc(sizeof(struct zram_slot_free), GFP_ATOMIC);
+	if (!free_rq)
+		return;
+
+	free_rq->index = index;
+	add_slot_free(zram, free_rq);
+	schedule_work(&zram->free_work);
 }
 
 static const struct block_device_operations zram_devops = {
@@ -778,6 +828,10 @@ static int create_device(struct zram *zram, int device_id)
 	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
 
+	INIT_WORK(&zram->free_work, zram_slot_free);
+	spin_lock_init(&zram->slot_free_lock);
+	zram->slot_free_rq = NULL;
+
 	zram->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 9e57bfb..97a3acf 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -94,11 +94,20 @@ struct zram_meta {
 	struct zs_pool *mem_pool;
 };
 
+struct zram_slot_free {
+	unsigned long index;
+	struct zram_slot_free *next;
+};
+
 struct zram {
 	struct zram_meta *meta;
 	struct rw_semaphore lock; /* protect compression buffers, table,
 				   * 32bit stat counters against concurrent
 				   * notifications, reads and writes */
+
+	struct work_struct free_work;  /* handle pending free request */
+	struct zram_slot_free *slot_free_rq; /* list head of free request */
+
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;
@@ -109,6 +118,7 @@ struct zram {
 	 * we can store in a disk.
 	 */
 	u64 disksize;	/* bytes */
+	spinlock_t slot_free_lock;
 
 	struct zram_stats stats;
 };
-- 
1.7.9.5

