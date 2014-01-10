Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaAJHKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:10:10 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44630 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaAJHKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:10:08 -0500
X-AuditID: 9c93017d-b7b41ae000004b3e-ff-52cf9ccdfa33
Date: Fri, 10 Jan 2014 16:10:34 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] zram: drop `init_done' zram member
Message-ID: <20140110071034.GJ1992@bbox>
References: <20140109125746.GA2246@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109125746.GA2246@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergey,

On Thu, Jan 09, 2014 at 03:57:46PM +0300, Sergey Senozhatsky wrote:
> Introduce init_done() helper function which allows us to drop
> `init_done' struct zram member. init_done() uses the fact that
> ->init_done == 1 equals to ->meta != NULL.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

It would be good without any harm but I'm just considering to
change the lock with rcu with atomic variable.
Please give me a time and feedback to you in next week.

Thanks.

> 
> ---
> 
>  drivers/block/zram/zram_drv.c | 21 +++++++++++----------
>  drivers/block/zram/zram_drv.h | 12 +++++-------
>  2 files changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 108f273..833d24f 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -42,6 +42,11 @@ static struct zram *zram_devices;
>  /* Module params (documentation at end) */
>  static unsigned int num_devices = 1;
>  
> +static inline int init_done(struct zram *zram)
> +{
> +	return zram->meta != NULL;
> +}
> +
>  static inline struct zram *dev_to_zram(struct device *dev)
>  {
>  	return (struct zram *)dev_to_disk(dev)->private_data;
> @@ -60,7 +65,7 @@ static ssize_t initstate_show(struct device *dev,
>  {
>  	struct zram *zram = dev_to_zram(dev);
>  
> -	return sprintf(buf, "%u\n", zram->init_done);
> +	return sprintf(buf, "%u\n", init_done(zram));
>  }
>  
>  static ssize_t num_reads_show(struct device *dev,
> @@ -133,7 +138,7 @@ static ssize_t mem_used_total_show(struct device *dev,
>  	struct zram_meta *meta = zram->meta;
>  
>  	down_read(&zram->init_lock);
> -	if (zram->init_done)
> +	if (init_done(zram))
>  		val = zs_get_total_size_bytes(meta->mem_pool);
>  	up_read(&zram->init_lock);
>  
> @@ -556,14 +561,12 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  	flush_work(&zram->free_work);
>  
>  	down_write(&zram->init_lock);
> -	if (!zram->init_done) {
> +	if (!init_done(zram)) {
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
> @@ -604,8 +607,6 @@ static void zram_init_device(struct zram *zram, struct zram_meta *meta)
>  	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
>  
>  	zram->meta = meta;
> -	zram->init_done = 1;
> -
>  	pr_debug("Initialization done!\n");
>  }
>  
> @@ -623,7 +624,7 @@ static ssize_t disksize_store(struct device *dev,
>  	disksize = PAGE_ALIGN(disksize);
>  	meta = zram_meta_alloc(disksize);
>  	down_write(&zram->init_lock);
> -	if (zram->init_done) {
> +	if (init_done(zram)) {
>  		up_write(&zram->init_lock);
>  		zram_meta_free(meta);
>  		pr_info("Cannot change disksize for initialized device\n");
> @@ -744,7 +745,7 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
>  	struct zram *zram = queue->queuedata;
>  
>  	down_read(&zram->init_lock);
> -	if (unlikely(!zram->init_done))
> +	if (unlikely(!init_done(zram)))
>  		goto error;
>  
>  	if (!valid_io_request(zram, bio)) {
> @@ -893,7 +894,7 @@ static int create_device(struct zram *zram, int device_id)
>  		goto out_free_disk;
>  	}
>  
> -	zram->init_done = 0;
> +	zram->meta = NULL;
>  	return 0;
>  
>  out_free_disk:
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index d8f6596..1388bad 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -99,26 +99,24 @@ struct zram_slot_free {
>  };
>  
>  struct zram {
> +	/* Prevent concurrent execution of device init, reset and R/W request */
> +	struct rw_semaphore init_lock;
>  	struct zram_meta *meta;
> +
>  	struct rw_semaphore lock; /* protect compression buffers, table,
>  				   * 32bit stat counters against concurrent
>  				   * notifications, reads and writes */
> -
> -	struct work_struct free_work;  /* handle pending free request */
>  	struct zram_slot_free *slot_free_rq; /* list head of free request */
> +	spinlock_t slot_free_lock;
> +	struct work_struct free_work;  /* handle pending free request */
>  
>  	struct request_queue *queue;
>  	struct gendisk *disk;
> -	int init_done;
> -	/* Prevent concurrent execution of device init, reset and R/W request */
> -	struct rw_semaphore init_lock;
>  	/*
>  	 * This is the limit on amount of *uncompressed* worth of data
>  	 * we can store in a disk.
>  	 */
>  	u64 disksize;	/* bytes */
> -	spinlock_t slot_free_lock;
> -
>  	struct zram_stats stats;
>  };
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
