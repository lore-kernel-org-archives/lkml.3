Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaJVH0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:26:43 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52012 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaJVH0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:26:42 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 22 Oct 2014 16:27:06 +0900
From: Minchan Kim <minchan@kernel.org>
To: karam.lee@lge.com
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        matthew.r.wilcox@intel.com, jmarchan@redhat.com, seungho1.park@lge.com
Subject: Re: [PATCH v4 3/3] zram: implement rw_page operation of zram
Message-ID: <20141022072706.GE21620@bbox>
References: <1413961454-13479-1-git-send-email-karam.lee@lge.com>
 <1413961454-13479-4-git-send-email-karam.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1413961454-13479-4-git-send-email-karam.lee@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi karam,

On Wed, Oct 22, 2014 at 04:04:14PM +0900, karam.lee@lge.com wrote:
> From: "karam.lee" <karam.lee@lge.com>
> 
> This patch implements rw_page operation for zram block device.
> 
> I implemented the feature in zram and tested it.
> Test bed was the G2, LG electronic mobile device, whtich has msm8974
> processor and 2GB memory.
> With a memory allocation test program consuming memory, the system
> generates swap.
> And operating time of swap_write_page() was measured.
> 
> --------------------------------------------------
> |             |   operating time   | improvement |
> |             |  (20 runs average) |             |
> --------------------------------------------------
> |with patch   |    1061.15 us      |    +2.4%    |
> --------------------------------------------------
> |without patch|    1087.35 us      |             |
> --------------------------------------------------
> 
> Each test(with paged_io,with BIO) result set shows normal distribution
> and has equal variance.
> I mean the two values are valid result to compare.
> I can say operation with paged I/O(without BIO) is faster 2.4% with
> confidence level 95%.
> 
> Signed-off-by: karam.lee <karam.lee@lge.com>
> ---
>  drivers/block/zram/zram_drv.c |   38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 4565fdc..8bbd4f2 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -810,8 +810,46 @@ static void zram_slot_free_notify(struct block_device *bdev,
>  	atomic64_inc(&zram->stats.notify_free);
>  }
>  
> +static int zram_rw_page(struct block_device *bdev, sector_t sector,
> +		       struct page *page, int rw)
> +{
> +	int offset, ret;
> +	u32 index;
> +	struct zram *zram;
> +	struct bio_vec bv;
> +
> +	zram = bdev->bd_disk->private_data;
> +	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
> +		atomic64_inc(&zram->stats.invalid_io);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	down_read(&zram->init_lock);
> +	if (unlikely(!init_done(zram))) {
> +		ret = -ENOMEM;

Why is it -ENOMEM?
I think EIO is better like bio_io_error.

-- 
Kind regards,
Minchan Kim
