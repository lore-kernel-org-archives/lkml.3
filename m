Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaANJlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 04:41:22 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:33189 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaANJlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 04:41:14 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 1/3] zram: drop `init_done' struct zram member
Date: Tue, 14 Jan 2014 12:37:38 +0300
Message-Id: <1389692260-4421-2-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.2.487.g7559984
In-Reply-To: <1389692260-4421-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1389692260-4421-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce init_done() helper function which allows us to drop
`init_done' struct zram member. init_done() uses the fact that
->init_done == 1 equals to ->meta != NULL.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c | 21 +++++++++++----------
 drivers/block/zram/zram_drv.h |  1 -
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 011e55d..c323e05 100644
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
 
@@ -546,14 +551,12 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 	struct zram_meta *meta;
 
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
@@ -594,8 +597,6 @@ static void zram_init_device(struct zram *zram, struct zram_meta *meta)
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
 
 	zram->meta = meta;
-	zram->init_done = 1;
-
 	pr_debug("Initialization done!\n");
 }
 
@@ -613,7 +614,7 @@ static ssize_t disksize_store(struct device *dev,
 	disksize = PAGE_ALIGN(disksize);
 	meta = zram_meta_alloc(disksize);
 	down_write(&zram->init_lock);
-	if (zram->init_done) {
+	if (init_done(zram)) {
 		up_write(&zram->init_lock);
 		zram_meta_free(meta);
 		pr_info("Cannot change disksize for initialized device\n");
@@ -734,7 +735,7 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 	struct zram *zram = queue->queuedata;
 
 	down_read(&zram->init_lock);
-	if (unlikely(!zram->init_done))
+	if (unlikely(!init_done(zram)))
 		goto error;
 
 	if (!valid_io_request(zram, bio)) {
@@ -857,7 +858,7 @@ static int create_device(struct zram *zram, int device_id)
 		goto out_free_disk;
 	}
 
-	zram->init_done = 0;
+	zram->meta = NULL;
 	return 0;
 
 out_free_disk:
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index ad8aa35..e81e9cd 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -95,7 +95,6 @@ struct zram {
 	struct zram_meta *meta;
 	struct request_queue *queue;
 	struct gendisk *disk;
-	int init_done;
 	/* Prevent concurrent execution of device init, reset and R/W request */
 	struct rw_semaphore init_lock;
 	/*
-- 
1.8.5.2.487.g7559984

