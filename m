Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaAINAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:00:49 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:49853 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaAINAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:00:41 -0500
Date: Thu, 9 Jan 2014 15:57:46 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -next] zram: drop `init_done' zram member
Message-ID: <20140109125746.GA2246@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce init_done() helper function which allows us to drop
`init_done' struct zram member. init_done() uses the fact that
->init_done == 1 equals to ->meta != NULL.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/block/zram/zram_drv.c | 21 +++++++++++----------
 drivers/block/zram/zram_drv.h | 12 +++++-------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 108f273..833d24f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -42,6 +42,11 @@ static struct zram *zram_devices;
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
+static inline int init_done(struct zram *zram)
+{
+	return zram->meta != NULL;
+}
+
 static inline struct zram *dev_to_zram(struct device *dev)
 {
 	return (struct zram *)dev_to_disk(dev)->private_data;
@@ -60,7 +65,7 @@ static ssize_t initstate_show(struct device *dev,
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%u\n", zram->init_done);
+	return sprintf(buf, "%u\n", init_done(zram));
 }
 
 static ssize_t num_reads_show(struct device *dev,
@@ -133,7 +138,7 @@ static ssize_t mem_used_total_show(struct device *dev,
 	struct zram_meta *meta = zram->meta;
 
 	down_read(&zram->init_lock);
-	if (zram->init_done)
+	if (init_done(zram))
 		val = zs_get_total_size_bytes(meta->mem_pool);
 	up_read(&zram->init_lock);
 
@@ -556,14 +561,12 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 	flush_work(&zram->free_work);
 
 	down_write(&zram->init_lock);
-	if (!zram->init_done) {
+	if (!init_done(zram)) {
 		up_write(&zram->init_lock);
 		return;
 	}
 
 	meta = zram->meta;
-	zram->init_done = 0;
-
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
 		unsigned long handle = meta->table[index].handle;
@@ -604,8 +607,6 @@ static void zram_init_device(struct zram *zram, struct zram_meta *meta)
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
 
 	zram->meta = meta;
-	zram->init_done = 1;
-
 	pr_debug("Initialization done!\n");
 }
 
@@ -623,7 +624,7 @@ static ssize_t disksize_store(struct device *dev,
 	disksize = PAGE_ALIGN(disksize);
 	meta = zram_meta_alloc(disksize);
 	down_write(&zram->init_lock);
-	if (zram->init_done) {
+	if (init_done(zram)) {
 		up_write(&zram->init_lock);
 		zram_meta_free(meta);
 		pr_info("Cannot change disksize for initialized device\n");
@@ -744,7 +745,7 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 	struct zram *zram = queue->queuedata;
 
 	down_read(&zram->init_lock);
-	if (unlikely(!zram->init_done))
+	if (unlikely(!init_done(zram)))
 		goto error;
 
 	if (!valid_io_request(zram, bio)) {
@@ -893,7 +894,7 @@ static int create_device(struct zram *zram, int device_id)
 		goto out_free_disk;
 	}
 
-	zram->init_done = 0;
+	zram->meta = NULL;
 	return 0;
 
 out_free_disk:
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index d8f6596..1388bad 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -99,26 +99,24 @@ struct zram_slot_free {
 };
 
 struct zram {
+	/* Prevent concurrent execution of device init, reset and R/W request */
+	struct rw_semaphore init_lock;
 	struct zram_meta *meta;
+
 	struct rw_semaphore lock; /* protect compression buffers, table,
 				   * 32bit stat counters against concurrent
 				   * notifications, reads and writes */
-
-	struct work_struct free_work;  /* handle pending free request */
 	struct zram_slot_free *slot_free_rq; /* list head of free request */
+	spinlock_t slot_free_lock;
+	struct work_struct free_work;  /* handle pending free request */
 
 	struct request_queue *queue;
 	struct gendisk *disk;
-	int init_done;
-	/* Prevent concurrent execution of device init, reset and R/W request */
-	struct rw_semaphore init_lock;
 	/*
 	 * This is the limit on amount of *uncompressed* worth of data
 	 * we can store in a disk.
 	 */
 	u64 disksize;	/* bytes */
-	spinlock_t slot_free_lock;
-
 	struct zram_stats stats;
 };
 #endif
