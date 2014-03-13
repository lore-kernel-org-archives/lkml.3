Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaCMEXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 00:23:20 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50381 "EHLO
	lgeamrelo05.lge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750754AbaCMEXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 00:23:18 -0400
X-Original-SENDERIP: 10.177.220.200
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 13 Mar 2014 13:23:26 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH v3] zram: support REQ_DISCARD
Message-ID: <20140313042326.GA5153@lge.com>
References: <1394611269-7582-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20140312133318.60c5e63ba26e9bf71098cc6e@linux-foundation.org>
 <20140313024617.GA4900@lge.com>
 <20140312200303.7abc49b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312200303.7abc49b0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 08:03:03PM -0700, Andrew Morton wrote:
> On Thu, 13 Mar 2014 11:46:17 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > +	while (n >= PAGE_SIZE) {
> > +		/*
> > +		 * discard request can be too large so that the zram can
> > +		 * be stucked for a long time if we handle the request
> > +		 * at once. So handle the request by PAGE_SIZE unit at a time.
> > +		 */
> > +		write_lock(&zram->meta->tb_lock);
> > +		zram_free_page(zram, index);
> > +		write_unlock(&zram->meta->tb_lock);
> > +		index++;
> > +		n -= PAGE_SIZE;
> > +	}
> 
> Well, you could use something like
> 
> 	if (need_resched()) {
> 		unlock()
> 		schedule()
> 		lock()
> 	}
> 
> here, or free 100 pages at a time or something silly like that.  I
> guess we retain these as options if/when that lock turns out to be
> contended.

Okay! I postpone this until that lock turns out to be contented.
Here goes new one.

Thanks.

-------------->8-----------------------
>From 81f1be2f095c175ad29505344f11eb86f51fdc93 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Mon, 24 Feb 2014 14:30:43 +0900
Subject: [PATCH v5] zram: support REQ_DISCARD

zram is ram based block device and can be used by backend of filesystem.
When filesystem deletes a file, it normally doesn't do anything on data
block of that file. It just marks on metadata of that file. This behavior
has no problem on disk based block device, but has problems on ram based
block device, since we can't free memory used for data block. To overcome
this disadvantage, there is REQ_DISCARD functionality. If block device
support REQ_DISCARD and filesystem is mounted with discard option,
filesystem sends REQ_DISCARD to block device whenever some data blocks are
discarded. All we have to do is to handle this request.

This patch implements to flag up QUEUE_FLAG_DISCARD and handle this
REQ_DISCARD request. With it, we can free memory used by zram if it isn't
used.

v2: handle unaligned case commented by Jerome
v3: conditionally set zero to discard_zeroes_data commented by Minchan
    reuse index, offset in __zram_make_request() commented by Sergey.
v4: replenish code comments suggested by Andrew.
v5: handle all range of discard request at once suggested by Andrew.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 7631ef0..1118086 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -541,6 +541,43 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 	return ret;
 }
 
+/*
+ * zram_bio_discard - handler on discard request
+ * @index: physical block index by PAGE_SIZE unit
+ * @offset: offset within physical block
+ */
+static void zram_bio_discard(struct zram *zram, u32 index,
+			     int offset, struct bio *bio)
+{
+	size_t n = bio->bi_iter.bi_size;
+
+	/*
+	 * zram manages data by physical block size unit. Because logical block
+	 * size isn't identical with physical block size on some arch, we
+	 * could get discard request pointing to specific offset within certain
+	 * physical block. Although we can handle this request by reading that
+	 * physiclal block and decompressing and partially zeroing and
+	 * re-compressing and then re-storing it, it isn't reasonable because
+	 * our intention of handling discard request is to save memory.
+	 * So skipping this logical block is approriate here.
+	 */
+	if (offset) {
+		if (n < offset)
+			return;
+
+		n -= offset;
+		index++;
+	}
+
+	write_lock(&zram->meta->tb_lock);
+	while (n >= PAGE_SIZE) {
+		zram_free_page(zram, index);
+		index++;
+		n -= PAGE_SIZE;
+	}
+	write_unlock(&zram->meta->tb_lock);
+}
+
 static void zram_reset_device(struct zram *zram, bool reset_capacity)
 {
 	size_t index;
@@ -676,6 +713,12 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 	offset = (bio->bi_iter.bi_sector &
 		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
 
+	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
+		zram_bio_discard(zram, index, offset, bio);
+		bio_endio(bio, 0);
+		return;
+	}
+
 	bio_for_each_segment(bvec, bio, iter) {
 		int max_transfer_size = PAGE_SIZE - offset;
 
@@ -845,6 +888,20 @@ static int create_device(struct zram *zram, int device_id)
 					ZRAM_LOGICAL_BLOCK_SIZE);
 	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
 	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
+	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
+	zram->disk->queue->limits.max_discard_sectors = UINT_MAX;
+	/*
+	 * zram_bio_discard() will clear all logical blocks if logical block
+	 * size is identical with physical block size(PAGE_SIZE). But if it is
+	 * different, we will skip to discard some parts of logical blocks in
+	 * whole request range which isn't aligned to physical block size.
+	 * So we can't ensure that some discarded logical block is zeroed.
+	 */
+	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
+		zram->disk->queue->limits.discard_zeroes_data = 1;
+	else
+		zram->disk->queue->limits.discard_zeroes_data = 0;
+	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, zram->disk->queue);
 
 	add_disk(zram->disk);
 
-- 
1.7.9.5

