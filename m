Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbaJCW7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:59:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830AbaJCW7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:59:03 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, gmazyland@gmail.com, agk@redhat.com, mpatocka@redhat.com
Subject: [PATCH v2] block: disable entropy contributions for nonrot devices
Date: Fri,  3 Oct 2014 18:58:56 -0400
Message-Id: <1412377136-15392-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <542F1284.2070702@kernel.dk>
References: <542F1284.2070702@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear QUEUE_FLAG_ADD_RANDOM in all block drivers that set
QUEUE_FLAG_NONROT.

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
 drivers/block/mtip32xx/mtip32xx.c |    1 +
 drivers/block/nbd.c               |    1 +
 drivers/block/null_blk.c          |    1 +
 drivers/block/nvme-core.c         |    1 +
 drivers/block/rsxx/dev.c          |    1 +
 drivers/block/skd_main.c          |    1 +
 drivers/block/zram/zram_drv.c     |    1 +
 drivers/ide/ide-disk.c            |    4 +++-
 drivers/md/bcache/super.c         |    1 +
 drivers/mmc/card/queue.c          |    1 +
 drivers/mtd/mtd_blkdevs.c         |    1 +
 drivers/s390/block/scm_blk.c      |    1 +
 drivers/s390/block/xpram.c        |    1 +
 drivers/scsi/sd.c                 |    4 +++-
 14 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 5c8e7fe..6134caf 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3951,6 +3951,7 @@ skip_create_disk:
 
 	/* Set device limits. */
 	set_bit(QUEUE_FLAG_NONROT, &dd->queue->queue_flags);
+	clear_bit(QUEUE_FLAG_ADD_RANDOM, &dd->queue->queue_flags);
 	blk_queue_max_segments(dd->queue, MTIP_MAX_SG);
 	blk_queue_physical_block_size(dd->queue, 4096);
 	blk_queue_max_hw_sectors(dd->queue, 0xffff);
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fb31b8e..4bc2a5c 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -847,6 +847,7 @@ static int __init nbd_init(void)
 		 * Tell the block layer that we are not a rotational device
 		 */
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, disk->queue);
+		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, disk->queue);
 		disk->queue->limits.discard_granularity = 512;
 		disk->queue->limits.max_discard_sectors = UINT_MAX;
 		disk->queue->limits.discard_zeroes_data = 0;
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 00d469c..c71e1b0 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -518,6 +518,7 @@ static int null_add_dev(void)
 
 	nullb->q->queuedata = nullb;
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, nullb->q);
+	queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, nullb->q);
 
 	disk = nullb->disk = alloc_disk_node(1, home_node);
 	if (!disk) {
diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 02351e2..e2bb8af 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1916,6 +1916,7 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, unsigned nsid,
 	ns->queue->queue_flags = QUEUE_FLAG_DEFAULT;
 	queue_flag_set_unlocked(QUEUE_FLAG_NOMERGES, ns->queue);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, ns->queue);
+	queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, ns->queue);
 	blk_queue_make_request(ns->queue, nvme_make_request);
 	ns->dev = dev;
 	ns->queue->queuedata = ns;
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index 2839d37..40ee770 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -307,6 +307,7 @@ int rsxx_setup_dev(struct rsxx_cardinfo *card)
 	blk_queue_physical_block_size(card->queue, RSXX_HW_BLK_SIZE);
 
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, card->queue);
+	queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, card->queue);
 	if (rsxx_discard_supported(card)) {
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, card->queue);
 		blk_queue_max_discard_sectors(card->queue,
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 8fcdcfb..1e46eb2 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4426,6 +4426,7 @@ static int skd_cons_disk(struct skd_device *skdev)
 	q->limits.discard_zeroes_data = 1;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+	queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
 
 	spin_lock_irqsave(&skdev->lock, flags);
 	pr_debug("%s:%s:%d stopping %s queue\n",
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index d00831c..0e0f51c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -929,6 +929,7 @@ static int create_device(struct zram *zram, int device_id)
 	set_capacity(zram->disk, 0);
 	/* zram devices sort of resembles non-rotational disks */
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
+	queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, zram->disk->queue);
 	/*
 	 * To ensure that we always get PAGE_SIZE aligned
 	 * and n*PAGE_SIZED sized I/O requests.
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index ee88038..56b9708 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -685,8 +685,10 @@ static void ide_disk_setup(ide_drive_t *drive)
 	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name,
 	       queue_max_sectors(q) / 2);
 
-	if (ata_id_is_ssd(id))
+	if (ata_id_is_ssd(id)) {
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
+	}
 
 	/* calculate drive capacity, and select LBA if possible */
 	ide_disk_get_capacity(drive);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d4713d0..4dd2bb7 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -842,6 +842,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 	q->limits.logical_block_size	= block_size;
 	q->limits.physical_block_size	= block_size;
 	set_bit(QUEUE_FLAG_NONROT,	&d->disk->queue->queue_flags);
+	clear_bit(QUEUE_FLAG_ADD_RANDOM, &d->disk->queue->queue_flags);
 	set_bit(QUEUE_FLAG_DISCARD,	&d->disk->queue->queue_flags);
 
 	blk_queue_flush(q, REQ_FLUSH|REQ_FUA);
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 3e049c1..c19bfc1 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -210,6 +210,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
+	queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, mq->queue);
 	if (mmc_can_erase(card))
 		mmc_queue_setup_discard(mq->queue, card);
 
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 43e3099..d08229e 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -417,6 +417,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	blk_queue_logical_block_size(new->rq, tr->blksize);
 
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, new->rq);
+	queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, new->rq);
 
 	if (tr->discard) {
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, new->rq);
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 76bed17..56046ab 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -386,6 +386,7 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
 	blk_queue_max_hw_sectors(rq, nr_max_blk << 3); /* 8 * 512 = blk_size */
 	blk_queue_max_segments(rq, nr_max_blk);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, rq);
+	queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, rq);
 	scm_blk_dev_cluster_setup(bdev);
 
 	bdev->gendisk = alloc_disk(SCM_NR_PARTS);
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index 6969d39..9e0de9c 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -346,6 +346,7 @@ static int __init xpram_setup_blkdev(void)
 			goto out;
 		}
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, xpram_queues[i]);
+		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, xpram_queues[i]);
 		blk_queue_make_request(xpram_queues[i], xpram_make_request);
 		blk_queue_logical_block_size(xpram_queues[i], 4096);
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2c2041c..fe67f5c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2660,8 +2660,10 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 
 	rot = get_unaligned_be16(&buffer[4]);
 
-	if (rot == 1)
+	if (rot == 1) {
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, sdkp->disk->queue);
+		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, sdkp->disk->queue);
+	}
 
  out:
 	kfree(buffer);
-- 
1.7.4.4

