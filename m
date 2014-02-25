Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaBYKvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:51:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaBYKvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:51:20 -0500
Message-ID: <530C759B.10907@redhat.com>
Date: Tue, 25 Feb 2014 11:51:07 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] zram: delete zram_init_device() function
References: <1393290516-21158-1-git-send-email-minchan@kernel.org> <1393290516-21158-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1393290516-21158-2-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 02:08 AM, Minchan Kim wrote:
> From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> allocate new `zram_meta' in disksize_store() only for uninitialised
> zram device, saving a number of allocations and deallocations in case
> if disksize_store() was called on currently used device. at the same
> time zram_meta stack variable is not necessary, because we can set
> ->meta directly. there is also no need in setting QUEUE_FLAG_NONROT
> queue on every disksize_store(), set it once during device creation.
> 
> [minchan@kernel.org]: handled zram->meta alloc fail case.
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Jerome Marchand <jmarchan@redhat.com>

> ---
>  drivers/block/zram/zram_drv.c | 25 +++++++++----------------
>  1 file changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 21aee3edcb25..9baac5b76bfe 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -533,40 +533,32 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  	up_write(&zram->init_lock);
>  }
>  
> -static void zram_init_device(struct zram *zram, struct zram_meta *meta)
> -{
> -	/* zram devices sort of resembles non-rotational disks */
> -	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
> -	zram->meta = meta;
> -	pr_debug("Initialization done!\n");
> -}
> -
>  static ssize_t disksize_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t len)
>  {
>  	u64 disksize;
> -	struct zram_meta *meta;
>  	struct zram *zram = dev_to_zram(dev);
>  
>  	disksize = memparse(buf, NULL);
>  	if (!disksize)
>  		return -EINVAL;
>  
> -	disksize = PAGE_ALIGN(disksize);
> -	meta = zram_meta_alloc(disksize);
> -	if (!meta)
> -		return -ENOMEM;
>  	down_write(&zram->init_lock);
>  	if (init_done(zram)) {
>  		up_write(&zram->init_lock);
> -		zram_meta_free(meta);
>  		pr_info("Cannot change disksize for initialized device\n");
>  		return -EBUSY;
>  	}
>  
> +	disksize = PAGE_ALIGN(disksize);
> +	zram->meta = zram_meta_alloc(disksize);
> +	if (!zram->meta) {
> +		up_write(&zram->init_lock);
> +		return -ENOMEM;
> +	}
> +
>  	zram->disksize = disksize;
>  	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
> -	zram_init_device(zram, meta);
>  	up_write(&zram->init_lock);
>  
>  	return len;
> @@ -776,7 +768,8 @@ static int create_device(struct zram *zram, int device_id)
>  
>  	/* Actual capacity set using syfs (/sys/block/zram<id>/disksize */
>  	set_capacity(zram->disk, 0);
> -
> +	/* zram devices sort of resembles non-rotational disks */
> +	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
>  	/*
>  	 * To ensure that we always get PAGE_SIZE aligned
>  	 * and n*PAGE_SIZED sized I/O requests.
> 

