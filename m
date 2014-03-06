Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaCFI0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:26:53 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56208 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbaCFI0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:26:52 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-dc-531831498e5b
Date: Thu, 6 Mar 2014 17:26:53 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] zram: move comp allocation out of init_lock
Message-ID: <20140306082653.GC14287@bbox>
References: <1393927856-23434-1-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393927856-23434-1-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergey,

On Tue, Mar 04, 2014 at 01:10:56PM +0300, Sergey Senozhatsky wrote:
> While fixing lockdep spew of ->init_lock reported by Sasha Levin [1], Minchan
> Kim noted [2] that it's better to move compression backend allocation (using
> GPF_KERNEL) out of the ->init_lock lock, same way as with zram_meta_alloc(),
> in order to prevent the same lockdep spew.
> 
> [1] https://lkml.org/lkml/2014/2/27/337
> [2] https://lkml.org/lkml/2014/3/3/32
> 
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Reported-by: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Thanks for looking.

> ---
>  drivers/block/zram/zram_drv.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 15d46f2..e4d536b 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -580,9 +580,10 @@ static ssize_t disksize_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t len)
>  {
>  	u64 disksize;
> +	struct zcomp *comp;
>  	struct zram_meta *meta;
>  	struct zram *zram = dev_to_zram(dev);
> -	int err;
> +	int err = -EINVAL;
>  
>  	disksize = memparse(buf, NULL);
>  	if (!disksize)
> @@ -593,30 +594,32 @@ static ssize_t disksize_store(struct device *dev,
>  	if (!meta)
>  		return -ENOMEM;
>  
> +	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
> +	if (!comp) {
> +		pr_info("Cannot initialise %s compressing backend\n",
> +				zram->compressor);

-ENOMEM?

Otherwise,
Acked-by: Minchan Kim <minchan@kernel.org>


> +		goto out_cleanup;
> +	}
> +
>  	down_write(&zram->init_lock);
>  	if (init_done(zram)) {
> +		up_write(&zram->init_lock);
>  		pr_info("Cannot change disksize for initialized device\n");
>  		err = -EBUSY;
> -		goto out_free_meta;
> -	}
> -
> -	zram->comp = zcomp_create(zram->compressor, zram->max_comp_streams);
> -	if (!zram->comp) {
> -		pr_info("Cannot initialise %s compressing backend\n",
> -				zram->compressor);
> -		err = -EINVAL;
> -		goto out_free_meta;
> +		goto out_cleanup;
>  	}
>  
>  	zram->meta = meta;
> +	zram->comp = comp;
>  	zram->disksize = disksize;
>  	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
>  	up_write(&zram->init_lock);
>  
>  	return len;
>  
> -out_free_meta:
> -	up_write(&zram->init_lock);
> +out_cleanup:
> +	if (comp)
> +		zcomp_destroy(comp);
>  	zram_meta_free(meta);
>  	return err;
>  }
> -- 
> 1.9.0.382.g7f3562c
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
