Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaJCALV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 20:11:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaJCALU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 20:11:20 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, gmazyland@gmail.com, agk@redhat.com, mpatocka@redhat.com
Subject: [PATCH] block: disable entropy contributions from nonrot devices
Date: Thu,  2 Oct 2014 20:11:14 -0400
Message-Id: <1412295074-4984-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce queue_flags_set_nonrot_clear_add_random() and convert all
block drivers that set QUEUE_FLAG_NONROT over to using it instead.

Historically, all block devices have automatically made entropy
contributions.  But as previously stated in commit e2e1a148 ("block: add
sysfs knob for turning off disk entropy contributions"):
    - On SSD disks, the completion times aren't as random as they
      are for rotational drives. So it's questionable whether they
      should contribute to the random pool in the first place.
    - Calling add_disk_randomness() has a lot of overhead.

There are more reliable sources for randomness than non-rotational block
devices.  From a security perspective it is better to err on the side of
caution than to allow entropy contributions from unreliable "random"
sources.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    2 +-
 drivers/block/nbd.c               |    2 +-
 drivers/block/null_blk.c          |    2 +-
 drivers/block/nvme-core.c         |    2 +-
 drivers/block/rsxx/dev.c          |    2 +-
 drivers/block/skd_main.c          |    2 +-
 drivers/block/zram/zram_drv.c     |    2 +-
 drivers/ide/ide-disk.c            |    2 +-
 drivers/md/bcache/super.c         |    2 +-
 drivers/mmc/card/queue.c          |    2 +-
 drivers/mtd/mtd_blkdevs.c         |    2 +-
 drivers/s390/block/scm_blk.c      |    2 +-
 drivers/s390/block/xpram.c        |    2 +-
 drivers/scsi/sd.c                 |    2 +-
 include/linux/blkdev.h            |    6 ++++++
 15 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 5c8e7fe..0de2620 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3950,7 +3950,7 @@ skip_create_disk:
 		goto start_service_thread;
 
 	/* Set device limits. */
-	set_bit(QUEUE_FLAG_NONROT, &dd->queue->queue_flags);
+	queue_flags_set_nonrot_clear_add_random(dd->queue);
 	blk_queue_max_segments(dd->queue, MTIP_MAX_SG);
 	blk_queue_physical_block_size(dd->queue, 4096);
 	blk_queue_max_hw_sectors(dd->queue, 0xffff);
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fb31b8e..8dbb842 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -846,7 +846,7 @@ static int __init nbd_init(void)
 		/*
 		 * Tell the block layer that we are not a rotational device
 		 */
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, disk->queue);
+		queue_flags_set_nonrot_clear_add_random(disk->queue);
 		disk->queue->limits.discard_granularity = 512;
 		disk->queue->limits.max_discard_sectors = UINT_MAX;
 		disk->queue->limits.discard_zeroes_data = 0;
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 00d469c..8d6eb15 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -517,7 +517,7 @@ static int null_add_dev(void)
 	}
 
 	nullb->q->queuedata = nullb;
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, nullb->q);
+	queue_flags_set_nonrot_clear_add_random(nullb->q);
 
 	disk = nullb->disk = alloc_disk_node(1, home_node);
 	if (!disk) {
diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 02351e2..8bf69ae 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1915,7 +1915,7 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, unsigned nsid,
 		goto out_free_ns;
 	ns->queue->queue_flags = QUEUE_FLAG_DEFAULT;
 	queue_flag_set_unlocked(QUEUE_FLAG_NOMERGES, ns->queue);
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, ns->queue);
+	queue_flags_set_nonrot_clear_add_random(ns->queue);
 	blk_queue_make_request(ns->queue, nvme_make_request);
 	ns->dev = dev;
 	ns->queue->queuedata = ns;
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index 2839d37..dc5b965 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -306,7 +306,7 @@ int rsxx_setup_dev(struct rsxx_cardinfo *card)
 	blk_queue_max_hw_sectors(card->queue, blkdev_max_hw_sectors);
 	blk_queue_physical_block_size(card->queue, RSXX_HW_BLK_SIZE);
 
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, card->queue);
+	queue_flags_set_nonrot_clear_add_random(card->queue);
 	if (rsxx_discard_supported(card)) {
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, card->queue);
 		blk_queue_max_discard_sectors(card->queue,
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 8fcdcfb..ba528db 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4425,7 +4425,7 @@ static int skd_cons_disk(struct skd_device *skdev)
 	q->limits.max_discard_sectors = UINT_MAX >> 9;
 	q->limits.discard_zeroes_data = 1;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+	queue_flags_set_nonrot_clear_add_random(q);
 
 	spin_lock_irqsave(&skdev->lock, flags);
 	pr_debug("%s:%s:%d stopping %s queue\n",
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d00831c..009d384 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -928,7 +928,7 @@ static int create_device(struct zram *zram, int device_id)
 	/* Actual capacity set using syfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
 	/* zram devices sort of resembles non-rotational disks */
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
+	queue_flags_set_nonrot_clear_add_random(zram->disk->queue);
 	/*
 	 * To ensure that we always get PAGE_SIZE aligned
 	 * and n*PAGE_SIZED sized I/O requests.
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index ee88038..e53b979 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -686,7 +686,7 @@ static void ide_disk_setup(ide_drive_t *drive)
 	       queue_max_sectors(q) / 2);
 
 	if (ata_id_is_ssd(id))
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+		queue_flags_set_nonrot_clear_add_random(q);
 
 	/* calculate drive capacity, and select LBA if possible */
 	ide_disk_get_capacity(drive);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d4713d0..8d76d34 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -841,8 +841,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 	q->limits.io_min		= block_size;
 	q->limits.logical_block_size	= block_size;
 	q->limits.physical_block_size	= block_size;
-	set_bit(QUEUE_FLAG_NONROT,	&d->disk->queue->queue_flags);
 	set_bit(QUEUE_FLAG_DISCARD,	&d->disk->queue->queue_flags);
+	queue_flags_set_nonrot_clear_add_random(d->disk->queue);
 
 	blk_queue_flush(q, REQ_FLUSH|REQ_FUA);
 
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 3e049c1..4ff7114 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -209,7 +209,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	mq->queue->queuedata = mq;
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
+	queue_flags_set_nonrot_clear_add_random(mq->queue);
 	if (mmc_can_erase(card))
 		mmc_queue_setup_discard(mq->queue, card);
 
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 43e3099..b15362e 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -416,7 +416,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	new->rq->queuedata = new;
 	blk_queue_logical_block_size(new->rq, tr->blksize);
 
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, new->rq);
+	queue_flags_set_nonrot_clear_add_random(new->rq);
 
 	if (tr->discard) {
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, new->rq);
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 76bed17..d68c2ea 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -385,7 +385,7 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
 	blk_queue_logical_block_size(rq, 1 << 12);
 	blk_queue_max_hw_sectors(rq, nr_max_blk << 3); /* 8 * 512 = blk_size */
 	blk_queue_max_segments(rq, nr_max_blk);
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, rq);
+	queue_flags_set_nonrot_clear_add_random(rq);
 	scm_blk_dev_cluster_setup(bdev);
 
 	bdev->gendisk = alloc_disk(SCM_NR_PARTS);
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index 6969d39..85b7b63 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -345,7 +345,7 @@ static int __init xpram_setup_blkdev(void)
 			put_disk(xpram_disks[i]);
 			goto out;
 		}
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, xpram_queues[i]);
+		queue_flags_set_nonrot_clear_add_random(xpram_queues[i]);
 		blk_queue_make_request(xpram_queues[i], xpram_make_request);
 		blk_queue_logical_block_size(xpram_queues[i], 4096);
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2c2041c..d2211b9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2661,7 +2661,7 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	rot = get_unaligned_be16(&buffer[4]);
 
 	if (rot == 1)
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, sdkp->disk->queue);
+		queue_flags_set_nonrot_clear_add_random(sdkp->disk->queue);
 
  out:
 	kfree(buffer);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 518b465..b732219 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -585,6 +585,12 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 	__clear_bit(flag, &q->queue_flags);
 }
 
+static inline void queue_flags_set_nonrot_clear_add_random(struct request_queue *q)
+{
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+	queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
+}
+
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_dying(q)	test_bit(QUEUE_FLAG_DYING, &(q)->queue_flags)
-- 
1.7.4.4

