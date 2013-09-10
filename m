Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3IJXV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:21:29 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38694 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3IJXV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:21:28 -0400
Date: Wed, 11 Sep 2013 02:19:28 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        driverdev-devel@linuxdriverproject.org,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: zram: remove init_done from zram struct (v3)
Message-ID: <20130910231928.GB2450@swordfish>
References: <20130906151255.GE2238@swordfish.minsk.epam.com>
 <20130909123329.GZ19256@mwanda>
 <20130909124942.GA2221@swordfish.minsk.epam.com>
 <20130909132124.GY6329@mwanda>
 <522DD125.1030607@redhat.com>
 <522DF2DF.5060407@redhat.com>
 <20130910143416.GC2270@swordfish>
 <20130910145802.GD19256@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910145802.GD19256@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`zram->init_done' in fact mimics `zram->meta != NULL' value.
Introduce init_done() function that checks zram->meta (iow,
checks if initialisation was performed), so `zram->init_done'
can be removed.

v3: init_done() in handle_pending_slot_free()
v2: introduce init_done()

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/staging/zram/zram_drv.c | 23 ++++++++++++-----------
 drivers/staging/zram/zram_drv.h |  1 -
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 7a2d4de..dcfe07c 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
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
 
@@ -521,7 +526,7 @@ static void handle_pending_slot_free(struct zram *zram)
 	while (zram->slot_free_rq) {
 		free_rq = zram->slot_free_rq;
 		zram->slot_free_rq = free_rq->next;
-		if (zram->init_done)
+		if (init_done(zram))
 			zram_free_page(zram, free_rq->index);
 		kfree(free_rq);
 	}
@@ -553,14 +558,12 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
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
@@ -599,9 +602,7 @@ static void zram_init_device(struct zram *zram, struct zram_meta *meta)
 
 	/* zram devices sort of resembles non-rotational disks */
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
-
 	zram->meta = meta;
-	zram->init_done = 1;
 
 	pr_debug("Initialization done!\n");
 }
@@ -620,7 +621,7 @@ static ssize_t disksize_store(struct device *dev,
 	disksize = PAGE_ALIGN(disksize);
 	meta = zram_meta_alloc(disksize);
 	down_write(&zram->init_lock);
-	if (zram->init_done) {
+	if (init_done(zram)) {
 		up_write(&zram->init_lock);
 		zram_meta_free(meta);
 		pr_info("Cannot change disksize for initialized device\n");
@@ -728,7 +729,7 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 	struct zram *zram = queue->queuedata;
 
 	down_read(&zram->init_lock);
-	if (unlikely(!zram->init_done))
+	if (unlikely(!init_done(zram)))
 		goto error;
 
 	if (!valid_io_request(zram, bio)) {
@@ -876,7 +877,7 @@ static int create_device(struct zram *zram, int device_id)
 		goto out_free_disk;
 	}
 
-	zram->init_done = 0;
+	zram->meta = NULL;
 	return 0;
 
 out_free_disk:
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 97a3acf..b1100cf 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -110,7 +110,6 @@ struct zram {
 
 	struct request_queue *queue;
 	struct gendisk *disk;
-	int init_done;
 	/* Prevent concurrent execution of device init, reset and R/W request */
 	struct rw_semaphore init_lock;
 	/*

