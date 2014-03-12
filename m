Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaCLUdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:33:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaCLUdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:33:20 -0400
Date: Wed, 12 Mar 2014 13:33:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v3] zram: support REQ_DISCARD
Message-Id: <20140312133318.60c5e63ba26e9bf71098cc6e@linux-foundation.org>
In-Reply-To: <1394611269-7582-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1394611269-7582-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 17:01:09 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> zram is ram based block device and can be used by backend of filesystem.
> When filesystem deletes a file, it normally doesn't do anything on data
> block of that file. It just marks on metadata of that file. This behavior
> has no problem on disk based block device, but has problems on ram based
> block device, since we can't free memory used for data block. To overcome
> this disadvantage, there is REQ_DISCARD functionality. If block device
> support REQ_DISCARD and filesystem is mounted with discard option,
> filesystem sends REQ_DISCARD to block device whenever some data blocks are
> discarded. All we have to do is to handle this request.
> 
> This patch implements to flag up QUEUE_FLAG_DISCARD and handle this
> REQ_DISCARD request. With it, we can free memory used by zram if it isn't
> used.
> 
> ...
>
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -541,6 +541,33 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
>  	return ret;
>  }
>  
> +static void zram_bio_discard(struct zram *zram, u32 index,
> +			     int offset, struct bio *bio)

A little bit of documentation here wouldn't hurt.  "index" and "offset"
are pretty vague identifiers.  What do these args represent and what
are their units.

> +{
> +	size_t n = bio->bi_iter.bi_size;
> +
> +	/*
> +	 * On some arch, logical block (4096) aligned request couldn't be
> +	 * aligned to PAGE_SIZE, since their PAGE_SIZE aren't 4096.
> +	 * Therefore we should handle this misaligned case here.
> +	 */
> +	if (offset) {
> +		if (n < offset)
> +			return;
> +
> +		n -= offset;
> +		index++;
> +	}
> +
> +	while (n >= PAGE_SIZE) {
> +		write_lock(&zram->meta->tb_lock);
> +		zram_free_page(zram, index);
> +		write_unlock(&zram->meta->tb_lock);
> +		index++;
> +		n -= PAGE_SIZE;
> +	}

We could take the lock a single time rather than once per page.  Was
there a reason for doing it this way?  If so, that should be documented
as well please - there is no way a reader can know the reason from this
code.


> +}
> +
>  static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  {
>  	size_t index;
> @@ -676,6 +703,12 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
>  	offset = (bio->bi_iter.bi_sector &
>  		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
>  
> +	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
> +		zram_bio_discard(zram, index, offset, bio);
> +		bio_endio(bio, 0);
> +		return;
> +	}
> +
>  	bio_for_each_segment(bvec, bio, iter) {
>  		int max_transfer_size = PAGE_SIZE - offset;
>  
> @@ -845,6 +878,17 @@ static int create_device(struct zram *zram, int device_id)
>  					ZRAM_LOGICAL_BLOCK_SIZE);
>  	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
>  	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
> +	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
> +	zram->disk->queue->limits.max_discard_sectors = UINT_MAX;
> +	/*
> +	 * We will skip to discard mis-aligned range, so we can't ensure
> +	 * whether discarded region is zero or not.
> +	 */

That's a bit hard to follow.  What is it that is misaligned, relative
to what?

And where does this skipping occur?  zram_bio_discard() avoids
discarding partial pages at the start and end of the bio (I think).  Is
that what we're referring to here?  If so, what about the complete
pages between the two partial pages - they are zeroed on read.  Will
the code end up having to rezero those?

As you can tell, I'm struggling to understand what's going on here ;)
Some additional description of how it all works would be nice.  Perferably
as code comments so the information is permanent.

> +	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
> +		zram->disk->queue->limits.discard_zeroes_data = 1;
> +	else
> +		zram->disk->queue->limits.discard_zeroes_data = 0;
> +	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, zram->disk->queue);
>  
>  	add_disk(zram->disk);

