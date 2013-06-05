Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab3FEG3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 02:29:39 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:64716 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3FEG3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 02:29:38 -0400
X-AuditID: 9c93017d-b7c30ae0000063eb-9c-51aedacf4101
Date: Wed, 5 Jun 2013 15:29:35 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/10] zram: use zram->lock to protect
 zram_free_page() in swap free notify path
Message-ID: <20130605062935.GC8732@blaptop>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
 <1370361968-8764-3-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370361968-8764-3-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 12:06:01AM +0800, Jiang Liu wrote:
> zram_free_page() is protected by down_write(&zram->lock) when called by
> zram_bvec_write(), but there's no such protection when called by
> zram_slot_free_notify(), which may cause wrong states to zram object.
> 
> There are two possible consequences of this issue:
> 1) It may cause invalid memory access if we read from a zram device used
>    as swap device. (Not sure whether it's legal to make read/write
>    requests to a zram device used as swap device.)

I think it's possible if the permission is allowed so we should take care
of that. But I'd like to clear your comment about "invalid memory access".

As I read the code, one of the problem we can encounter by race between
zram_bvec_read and zram_slot_free_notify is BUG_ON(!handle) on zs_map_object
or pr_err("Decompression failed xxxx) on zram_decompress_page.
Otherwise, it would be able to access different swap block with
user request's one.

Could you please expand your vague "invalid memory access"?


> 2) It may cause some fields (bad_compress, good_compress, pages_stored)
>    in zram->stats wrong if the swap layer makes concurrently call to
>    zram_slot_free_notify().
> 
> So enhance zram_slot_free_notify() to acquire writer lock on zram->lock
> before calling zram_free_page().

OK.

And please add the comment struct zram->lock feild, too.

Thanks.

> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/staging/zram/zram_drv.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 5a2f20b..847d207 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -582,7 +582,9 @@ static void zram_slot_free_notify(struct block_device *bdev,
>  	struct zram *zram;
>  
>  	zram = bdev->bd_disk->private_data;
> +	down_write(&zram->lock);
>  	zram_free_page(zram, index);
> +	up_write(&zram->lock);
>  	zram_stat64_inc(zram, &zram->stats.notify_free);
>  }
>  
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
