Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3IFOQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:16:50 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:41949 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3IFOQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:16:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130906135258.GB2238@swordfish.minsk.epam.com>
References: <20130906135258.GB2238@swordfish.minsk.epam.com>
Date: Fri, 6 Sep 2013 18:16:48 +0400
Message-ID: <CAHj3AVnLATbM0ijrDSBW82-vnZUnLx695hZMf1_mY=XLqWUSMQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: zram: remove init_done from zram struct
From: Denis Kirjanov <kirjanov@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Minchan Kim <minchan@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not familiar with the zram code, but looking through the code and
init_done flag it's obvious what is going on rather then looking at
zram->meta field checks.

On 9/6/13, Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> `zram->init_done != 0' equals to `zram->meta != NULL', so init_done
> can be removed.
>
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>
> ---
>
>  drivers/staging/zram/zram_drv.c | 18 +++++++-----------
>  drivers/staging/zram/zram_drv.h |  1 -
>  2 files changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_drv.c
> b/drivers/staging/zram/zram_drv.c
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
> @@ -556,14 +556,12 @@ static void zram_reset_device(struct zram *zram, bool
> reset_capacity)
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
> @@ -573,7 +571,7 @@ static void zram_reset_device(struct zram *zram, bool
> reset_capacity)
>  		zs_free(meta->mem_pool, handle);
>  	}
>
> -	zram_meta_free(zram->meta);
> +	zram_meta_free(meta);
>  	zram->meta = NULL;
>  	/* Reset stats */
>  	memset(&zram->stats, 0, sizeof(zram->stats));
> @@ -602,9 +600,7 @@ static void zram_init_device(struct zram *zram, struct
> zram_meta *meta)
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
> @@ -731,7 +727,7 @@ static void zram_make_request(struct request_queue
> *queue, struct bio *bio)
>  	struct zram *zram = queue->queuedata;
>
>  	down_read(&zram->init_lock);
> -	if (unlikely(!zram->init_done))
> +	if (unlikely(!zram->meta))
>  		goto error;
>
>  	if (!valid_io_request(zram, bio)) {
> @@ -880,7 +876,7 @@ static int create_device(struct zram *zram, int
> device_id)
>  		goto out_free_disk;
>  	}
>
> -	zram->init_done = 0;
> +	zram->meta = NULL;
>  	return 0;
>
>  out_free_disk:
> diff --git a/drivers/staging/zram/zram_drv.h
> b/drivers/staging/zram/zram_drv.h
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
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
>


-- 
Regards,
Denis
