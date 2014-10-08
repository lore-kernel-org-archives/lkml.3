Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbaJHGrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:47:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50484 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaJHGrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:47:47 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 8 Oct 2014 15:48:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: karam.lee@lge.com
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH] zram: implement rw_page operation of zram block device
 operation
Message-ID: <20141008064810.GA14960@bbox>
References: <1412573465-28286-1-git-send-email-karam.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412573465-28286-1-git-send-email-karam.lee@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Karam,

On Mon, Oct 06, 2014 at 02:31:05PM +0900, karam.lee@lge.com wrote:
> From: "karam.lee" <karam.lee@lge.com>
> 
> Recently rw_page block device operation is added.
> This patch implements rw_page operation for zram block device so
> zram can process page sized I/O without bio.

It's a performance enhance patch? If you had, pz, inclulde the result
in the description.

> ---
> ---
>  drivers/block/zram/zram_drv.c |   60 +++++++++++++++++++++++++++++++++++------
>  1 file changed, 52 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 48eccb3..b76a5dc 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -368,7 +368,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>  }
>  
>  static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> -			  u32 index, int offset, struct bio *bio)
> +			  u32 index, int offset)

Isn't it cleanup? Please, separate it into another patch.

>  {
>  	int ret;
>  	struct page *page;
> @@ -535,14 +535,13 @@ out:
>  }
>  
>  static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
> -			int offset, struct bio *bio)
> +			int offset, int rw)
>  {
>  	int ret;
> -	int rw = bio_data_dir(bio);
>  
>  	if (rw == READ) {
>  		atomic64_inc(&zram->stats.num_reads);
> -		ret = zram_bvec_read(zram, bvec, index, offset, bio);
> +		ret = zram_bvec_read(zram, bvec, index, offset);
>  	} else {
>  		atomic64_inc(&zram->stats.num_writes);
>  		ret = zram_bvec_write(zram, bvec, index, offset);
> @@ -718,7 +717,7 @@ out:
>  
>  static void __zram_make_request(struct zram *zram, struct bio *bio)
>  {
> -	int offset;
> +	int offset, rw;
>  	u32 index;
>  	struct bio_vec bvec;
>  	struct bvec_iter iter;
> @@ -733,6 +732,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
>  		return;
>  	}
>  
> +	rw = bio_data_dir(bio);
>  	bio_for_each_segment(bvec, bio, iter) {
>  		int max_transfer_size = PAGE_SIZE - offset;
>  
> @@ -747,15 +747,15 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
>  			bv.bv_len = max_transfer_size;
>  			bv.bv_offset = bvec.bv_offset;
>  
> -			if (zram_bvec_rw(zram, &bv, index, offset, bio) < 0)
> +			if (zram_bvec_rw(zram, &bv, index, offset, rw) < 0)
>  				goto out;
>  
>  			bv.bv_len = bvec.bv_len - max_transfer_size;
>  			bv.bv_offset += max_transfer_size;
> -			if (zram_bvec_rw(zram, &bv, index + 1, 0, bio) < 0)
> +			if (zram_bvec_rw(zram, &bv, index + 1, 0, rw) < 0)
>  				goto out;
>  		} else
> -			if (zram_bvec_rw(zram, &bvec, index, offset, bio) < 0)
> +			if (zram_bvec_rw(zram, &bvec, index, offset, rw) < 0)
>  				goto out;
>  
>  		update_position(&index, &offset, &bvec);
> @@ -810,8 +810,52 @@ static void zram_slot_free_notify(struct block_device *bdev,
>  	atomic64_inc(&zram->stats.notify_free);
>  }
>  
> +static int zram_rw_page(struct block_device *bdev, sector_t sector,
> +		       struct page *page, int rw)
> +{
> +	int offset, ret = 1;
> +	u32 index;
> +	u64 start, end, bound;
> +	struct zram *zram;
> +	struct bio_vec bv;
> +
> +	zram = bdev->bd_disk->private_data;
> +
> +	if (unlikely(sector&
> +			(ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
> +		goto out;
> +
> +	start = sector;
> +	end = start + (PAGE_SIZE >> SECTOR_SHIFT);
> +	bound = zram->disksize >> SECTOR_SHIFT;
> +	if (unlikely(start >= bound || end > bound || start > end))
> +		goto out;

Please modify valid_io_request to used for your purpose and share it
with zram_make_request.

And please include Jerome because I'd like to confirm this patch in
partial_io system for just in case.

> +
> +	down_read(&zram->init_lock);
> +	if (unlikely(!init_done(zram))) {
> +		ret = -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +	index = sector >> SECTORS_PER_PAGE_SHIFT;
> +	offset = sector & (SECTORS_PER_PAGE - 1) << SECTOR_SHIFT;
> +
> +	bv.bv_page = page;
> +	bv.bv_len = PAGE_SIZE;
> +	bv.bv_offset = 0;
> +
> +	ret = zram_bvec_rw(zram, &bv, index, offset, rw);
> +	page_endio(page, rw, ret);
> +
> +out_unlock:
> +	up_read(&zram->init_lock);
> +out:
> +	return ret;
> +}
> +
>  static const struct block_device_operations zram_devops = {
>  	.swap_slot_free_notify = zram_slot_free_notify,
> +	.rw_page = zram_rw_page,
>  	.owner = THIS_MODULE
>  };
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
