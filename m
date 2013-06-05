Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab3FEK00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 06:26:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab3FEK0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 06:26:24 -0400
Message-ID: <51AF1242.809@redhat.com>
Date: Wed, 05 Jun 2013 12:26:10 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/10] zram: use zram->lock to protect zram_free_page()
 in swap free notify path
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com> <1370361968-8764-3-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1370361968-8764-3-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 06:06 PM, Jiang Liu wrote:
> zram_free_page() is protected by down_write(&zram->lock) when called by
> zram_bvec_write(), but there's no such protection when called by
> zram_slot_free_notify(), which may cause wrong states to zram object.
> 
> There are two possible consequences of this issue:
> 1) It may cause invalid memory access if we read from a zram device used
>    as swap device. (Not sure whether it's legal to make read/write
>    requests to a zram device used as swap device.)

It's never a good idea to mess with a swap device in use, but AFAICT
nothing prevents it (save for file permissions and admin sanity).

Jerome

> 2) It may cause some fields (bad_compress, good_compress, pages_stored)
>    in zram->stats wrong if the swap layer makes concurrently call to
>    zram_slot_free_notify().
> 
> So enhance zram_slot_free_notify() to acquire writer lock on zram->lock
> before calling zram_free_page().
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
> 

