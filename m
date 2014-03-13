Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaCMCqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 22:46:12 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56339 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaCMCqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 22:46:10 -0400
X-AuditID: 9c93017e-b7cf9ae000004b4b-0c-53211bef0859
Date: Thu, 13 Mar 2014 11:46:17 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH v3] zram: support REQ_DISCARD
Message-ID: <20140313024617.GA4900@lge.com>
References: <1394611269-7582-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20140312133318.60c5e63ba26e9bf71098cc6e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312133318.60c5e63ba26e9bf71098cc6e@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 01:33:18PM -0700, Andrew Morton wrote:
> On Wed, 12 Mar 2014 17:01:09 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > zram is ram based block device and can be used by backend of filesystem.
> > When filesystem deletes a file, it normally doesn't do anything on data
> > block of that file. It just marks on metadata of that file. This behavior
> > has no problem on disk based block device, but has problems on ram based
> > block device, since we can't free memory used for data block. To overcome
> > this disadvantage, there is REQ_DISCARD functionality. If block device
> > support REQ_DISCARD and filesystem is mounted with discard option,
> > filesystem sends REQ_DISCARD to block device whenever some data blocks are
> > discarded. All we have to do is to handle this request.
> > 
> > This patch implements to flag up QUEUE_FLAG_DISCARD and handle this
> > REQ_DISCARD request. With it, we can free memory used by zram if it isn't
> > used.
> > 
> > ...
> >
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -541,6 +541,33 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  	return ret;
> >  }
> >  
> > +static void zram_bio_discard(struct zram *zram, u32 index,
> > +			     int offset, struct bio *bio)
> 
> A little bit of documentation here wouldn't hurt.  "index" and "offset"
> are pretty vague identifiers.  What do these args represent and what
> are their units.
> 
> > +{
> > +	size_t n = bio->bi_iter.bi_size;
> > +
> > +	/*
> > +	 * On some arch, logical block (4096) aligned request couldn't be
> > +	 * aligned to PAGE_SIZE, since their PAGE_SIZE aren't 4096.
> > +	 * Therefore we should handle this misaligned case here.
> > +	 */
> > +	if (offset) {
> > +		if (n < offset)
> > +			return;
> > +
> > +		n -= offset;
> > +		index++;
> > +	}
> > +
> > +	while (n >= PAGE_SIZE) {
> > +		write_lock(&zram->meta->tb_lock);
> > +		zram_free_page(zram, index);
> > +		write_unlock(&zram->meta->tb_lock);
> > +		index++;
> > +		n -= PAGE_SIZE;
> > +	}
> 
> We could take the lock a single time rather than once per page.  Was
> there a reason for doing it this way?  If so, that should be documented
> as well please - there is no way a reader can know the reason from this
> code.
> 
> 
> > +}
> > +
> >  static void zram_reset_device(struct zram *zram, bool reset_capacity)
> >  {
> >  	size_t index;
> > @@ -676,6 +703,12 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
> >  	offset = (bio->bi_iter.bi_sector &
> >  		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
> >  
> > +	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
> > +		zram_bio_discard(zram, index, offset, bio);
> > +		bio_endio(bio, 0);
> > +		return;
> > +	}
> > +
> >  	bio_for_each_segment(bvec, bio, iter) {
> >  		int max_transfer_size = PAGE_SIZE - offset;
> >  
> > @@ -845,6 +878,17 @@ static int create_device(struct zram *zram, int device_id)
> >  					ZRAM_LOGICAL_BLOCK_SIZE);
> >  	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
> >  	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
> > +	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
> > +	zram->disk->queue->limits.max_discard_sectors = UINT_MAX;
> > +	/*
> > +	 * We will skip to discard mis-aligned range, so we can't ensure
> > +	 * whether discarded region is zero or not.
> > +	 */
> 
> That's a bit hard to follow.  What is it that is misaligned, relative
> to what?
> 
> And where does this skipping occur?  zram_bio_discard() avoids
> discarding partial pages at the start and end of the bio (I think).  Is
> that what we're referring to here?  If so, what about the complete
> pages between the two partial pages - they are zeroed on read.  Will
> the code end up having to rezero those?
> 
> As you can tell, I'm struggling to understand what's going on here ;)
> Some additional description of how it all works would be nice.  Perferably
> as code comments so the information is permanent.

Hello, Andrew.

I applied all your comments in below patch. :)
Thanks for comment.

------------->8---------------
>From f77b0a5ad9bc27d5b3bc0b21ed1e98de51c62f1f Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Mon, 24 Feb 2014 14:30:43 +0900
Subject: [PATCH v4] zram: support REQ_DISCARD

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

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 7631ef0..e3700cb 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -541,6 +541,48 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
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
+	while (n >= PAGE_SIZE) {
+		/*
+		 * discard request can be too large so that the zram can
+		 * be stucked for a long time if we handle the request
+		 * at once. So handle the request by PAGE_SIZE unit at a time.
+		 */
+		write_lock(&zram->meta->tb_lock);
+		zram_free_page(zram, index);
+		write_unlock(&zram->meta->tb_lock);
+		index++;
+		n -= PAGE_SIZE;
+	}
+}
+
 static void zram_reset_device(struct zram *zram, bool reset_capacity)
 {
 	size_t index;
@@ -676,6 +718,12 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
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
 
@@ -845,6 +893,20 @@ static int create_device(struct zram *zram, int device_id)
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

