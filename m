Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbaCEO5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:57:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443AbaCEO5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:57:20 -0500
Message-ID: <53173B43.2000609@redhat.com>
Date: Wed, 05 Mar 2014 15:57:07 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] zram: move comp allocation out of init_lock
References: <1393927856-23434-1-git-send-email-sergey.senozhatsky@gmail.com>
In-Reply-To: <1393927856-23434-1-git-send-email-sergey.senozhatsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 11:10 AM, Sergey Senozhatsky wrote:
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
> +		goto out_cleanup;
> +	}
> +

zcomp_create() could fail because of a failed allocation, in which case
ENOMEM would be more appropriate. I guess zcomp_create() should return
an errno in case of failure.
But that's an other problem than the one addressed in this patch:

Acked-by: Jerome Marchand <jmarchan@redhat.com>

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
> 

