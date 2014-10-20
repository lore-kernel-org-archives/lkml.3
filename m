Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaJTJmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:42:04 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58178 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaJTJlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:41:50 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 20 Oct 2014 18:42:02 +0900
From: Minchan Kim <minchan@kernel.org>
To: karam.lee@lge.com
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        matthew.r.wilcox@intel.com, jmarchan@redhat.com, seungho1.park@lge.com
Subject: Re: [PATCH v2 3/3] zram: implement rw_page operation of zram
Message-ID: <20141020094202.GC5330@bbox>
References: <1413190542-23960-1-git-send-email-karam.lee@lge.com>
 <1413190542-23960-4-git-send-email-karam.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1413190542-23960-4-git-send-email-karam.lee@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 05:55:42PM +0900, karam.lee@lge.com wrote:
> From: "karam.lee" <karam.lee@lge.com>
> 
> This patch implements rw_page operation for zram block device.

The description is not good. I know you added lots of words in
cover-letter but this patch is key so it should include more words
as well as cover-letter.

> 
> Signed-off-by: karam.lee <karam.lee@lge.com>
> ---
>  drivers/block/zram/zram_drv.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index b0c3a20..a44aab0 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -810,8 +810,45 @@ static void zram_slot_free_notify(struct block_device *bdev,
>  	atomic64_inc(&zram->stats.notify_free);
>  }
>  
> +static int zram_rw_page(struct block_device *bdev, sector_t sector,
> +		       struct page *page, int rw)
> +{
> +	int offset, ret = 1;
> +	u32 index;
> +	struct zram *zram;
> +	struct bio_vec bv;
> +
> +	zram = bdev->bd_disk->private_data;
> +	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
> +		atomic64_inc(&zram->stats.invalid_io);

-EINVAL?

Otherwise, looks good to me.

Acked-by: Minchan Kim <minchan@kernel.org>


> +		goto out;
> +	}
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
