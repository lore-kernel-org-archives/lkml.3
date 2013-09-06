Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab3IFOvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:51:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab3IFOvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:51:47 -0400
Message-ID: <5229EB9E.7040609@redhat.com>
Date: Fri, 06 Sep 2013 16:50:06 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: zram: remove init_done from zram struct
References: <20130906135258.GB2238@swordfish.minsk.epam.com>
In-Reply-To: <20130906135258.GB2238@swordfish.minsk.epam.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2013 03:52 PM, Sergey Senozhatsky wrote:
> `zram->init_done != 0' equals to `zram->meta != NULL', so init_done
> can be removed.

The name init_done is self explanatory, meta isn't. You could for
instance write a function with an explicit name to test for
initialization.

Jerome

> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  drivers/staging/zram/zram_drv.c | 18 +++++++-----------
>  drivers/staging/zram/zram_drv.h |  1 -
>  2 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 17386e2..34b72ea 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -60,7 +60,7 @@ static ssize_t initstate_show(struct device *dev,
>  {
>  	struct zram *zram = dev_to_zram(dev);
>  
> -	return sprintf(buf, "%u\n", zram->init_done);
> +	return sprintf(buf, "%u\n", zram->meta != NULL);
>  }
>  
>  static ssize_t num_reads_show(struct device *dev,
> @@ -133,7 +133,7 @@ static ssize_t mem_used_total_show(struct device *dev,
>  	struct zram_meta *meta = zram->meta;
>  
>  	down_read(&zram->init_lock);
> -	if (zram->init_done)
> +	if (meta)
>  		val = zs_get_total_size_bytes(meta->mem_pool);
>  	up_read(&zram->init_lock);
>  
> @@ -556,14 +556,12 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  	flush_work(&zram->free_work);
>  
>  	down_write(&zram->init_lock);
> -	if (!zram->init_done) {
> +	if (!zram->meta) {
>  		up_write(&zram->init_lock);
>  		return;
>  	}
>  
>  	meta = zram->meta;
> -	zram->init_done = 0;
> -
>  	/* Free all pages that are still in this zram device */
>  	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
>  		unsigned long handle = meta->table[index].handle;
> @@ -573,7 +571,7 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  		zs_free(meta->mem_pool, handle);
>  	}
>  
> -	zram_meta_free(zram->meta);
> +	zram_meta_free(meta);
>  	zram->meta = NULL;
>  	/* Reset stats */
>  	memset(&zram->stats, 0, sizeof(zram->stats));
> @@ -602,9 +600,7 @@ static void zram_init_device(struct zram *zram, struct zram_meta *meta)
>  
>  	/* zram devices sort of resembles non-rotational disks */
>  	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
> -
>  	zram->meta = meta;
> -	zram->init_done = 1;
>  
>  	pr_debug("Initialization done!\n");
>  }
> @@ -623,7 +619,7 @@ static ssize_t disksize_store(struct device *dev,
>  	disksize = PAGE_ALIGN(disksize);
>  	meta = zram_meta_alloc(disksize);
>  	down_write(&zram->init_lock);
> -	if (zram->init_done) {
> +	if (zram->meta) {
>  		up_write(&zram->init_lock);
>  		zram_meta_free(meta);
>  		pr_info("Cannot change disksize for initialized device\n");
> @@ -731,7 +727,7 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
>  	struct zram *zram = queue->queuedata;
>  
>  	down_read(&zram->init_lock);
> -	if (unlikely(!zram->init_done))
> +	if (unlikely(!zram->meta))
>  		goto error;
>  
>  	if (!valid_io_request(zram, bio)) {
> @@ -880,7 +876,7 @@ static int create_device(struct zram *zram, int device_id)
>  		goto out_free_disk;
>  	}
>  
> -	zram->init_done = 0;
> +	zram->meta = NULL;
>  	return 0;
>  
>  out_free_disk:
> diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
> index 97a3acf..b1100cf 100644
> --- a/drivers/staging/zram/zram_drv.h
> +++ b/drivers/staging/zram/zram_drv.h
> @@ -110,7 +110,6 @@ struct zram {
>  
>  	struct request_queue *queue;
>  	struct gendisk *disk;
> -	int init_done;
>  	/* Prevent concurrent execution of device init, reset and R/W request */
>  	struct rw_semaphore init_lock;
>  	/*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

