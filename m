Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3HEQ0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:26:50 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38795 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3HEQ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:26:48 -0400
Date: Tue, 6 Aug 2013 01:26:34 +0900
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>,
        Nitin Gupta <ngupta@vflare.org>, stable@vger.kernel.org
Subject: Re: [PATCH] zram: bug fix: delay lock holding in zram_slot_free_noity
Message-ID: <20130805162634.GA25045@gmail.com>
References: <1375687114-4001-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375687114-4001-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 04:18:34PM +0900, Minchan Kim wrote:
> I was preparing to promote zram and it was almost done.
> Before sending patch, I tried to test and eyebrows went up.
> 
> [1] introduced down_write in zram_slot_free_notify to prevent race
> between zram_slot_free_notify and zram_bvec_[read|write]. The race
> could happen if somebody who has right permission to open swap device
> is reading swap device while it is used by swap in parallel.
> 
> However, zram_slot_free_notify is called with holding spin_lock of
> swap layer so we shouldn't avoid holing mutex. Otherwise, lockdep
> warns it.
> 
> I guess, best solution is to redesign zram lock scheme totally but
> we are on the verge of promoting so it's not desirable to change a lot
> critical code and such big change isn't good shape for backporting to
> stable trees so I think the simple patch is best at the moment.
> 
> [1] [57ab0485, zram: use zram->lock to protect zram_free_page()
>     in swap free notify path]
> 
> Cc: Jiang Liu <jiang.liu@huawei.com>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zram/zram_drv.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 7ebf91d..7b574c4 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -440,6 +440,13 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  		goto out;
>  	}
>  
> +	/*
> +	 * zram_slot_free_notify could miss free so that let's
> +	 * double check.
> +	 */
> +	if (unlikely(meta->table[index].handle))
> +		zram_free_page(zram, index);
> +
>  	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
>  			       meta->compress_workmem);
>  
> @@ -727,7 +734,13 @@ static void zram_slot_free_notify(struct block_device *bdev,
>  	struct zram *zram;
>  
>  	zram = bdev->bd_disk->private_data;
> -	down_write(&zram->lock);
> +	/*
> +	 * The function is called in atomic context so down_write should
> +	 * be prohibited. If we couldn't hold a mutex, the free could be
> +	 * handled by zram_bvec_write later when same index is overwritten.
> +	 */
> +	if (!down_write_trylock(&zram->lock))
> +		return;
>  	zram_free_page(zram, index);
>  	up_write(&zram->lock);
>  	atomic64_inc(&zram->stats.notify_free);
> -- 
> 1.7.9.5
> 

How about this version?

>From a447aac3cd451058baf42c9d6dca3197893f4d65 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Mon, 5 Aug 2013 23:53:05 +0900
Subject: [PATCH v2] zram: bug fix: don't grab mutex in zram_slot_free_noity

[1] introduced down_write in zram_slot_free_notify to prevent race
between zram_slot_free_notify and zram_bvec_[read|write]. The race
could happen if somebody who has right permission to open swap device
is reading swap device while it is used by swap in parallel.

However, zram_slot_free_notify is called with holding spin_lock of
swap layer so we shouldn't avoid holing mutex. Otherwise, lockdep
warns it.

This patch adds new list to handle free object and workqueue
so zram_slot_free_notify just registers index to be freed and
queue works. If workqueue is expired, it could hold mutex_lock
and spinlock so there isn't no race between them.

If any I/O is issued, zram handles pending free request caused
by zram_slot_free_notify right before hanling issued request
because workqueue wouldn't handle pending requests yet.

Lastly, when zram is reset, flush_work could handle all of pending
free request so we shouldn't have memory leak.

NOTE: If zram_slot_free_notify's kmalloc with GFP_ATOMIC would be
failed, the slot will be freed when next write I/O write the slot.

[1] [57ab0485, zram: use zram->lock to protect zram_free_page()
    in swap free notify path]
 
* from v1
  * totally redesign

Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/zram_drv.c | 60 ++++++++++++++++++++++++++++++++++++++---
 drivers/staging/zram/zram_drv.h |  8 ++++++
 2 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 7ebf91d..ec881e0 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -440,6 +440,14 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto out;
 	}
 
+	/*
+	 * zram_slot_free_notify could miss free so that let's
+	 * double check.
+	 */
+	if (unlikely(meta->table[index].handle ||
+			zram_test_flag(meta, index, ZRAM_ZERO)))
+		zram_free_page(zram, index);
+
 	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
 			       meta->compress_workmem);
 
@@ -505,6 +513,20 @@ out:
 	return ret;
 }
 
+static void free_pending_rq(struct zram *zram)
+{
+	struct zram_free_rq *free_rq;
+
+	spin_lock(&zram->free_rq_lock);
+	while (zram->free_rq_head) {
+		free_rq = zram->free_rq_head;
+		zram->free_rq_head = free_rq->next;
+		zram_free_page(zram, free_rq->index);
+		kfree(free_rq);
+	}
+	spin_unlock(&zram->free_rq_lock);
+}
+
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 			int offset, struct bio *bio, int rw)
 {
@@ -512,10 +534,12 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	if (rw == READ) {
 		down_read(&zram->lock);
+		free_pending_rq(zram);
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
 		up_read(&zram->lock);
 	} else {
 		down_write(&zram->lock);
+		free_pending_rq(zram);
 		ret = zram_bvec_write(zram, bvec, index, offset);
 		up_write(&zram->lock);
 	}
@@ -528,6 +552,8 @@ static void zram_reset_device(struct zram *zram)
 	size_t index;
 	struct zram_meta *meta;
 
+	flush_work(&zram->work);
+
 	down_write(&zram->init_lock);
 	if (!zram->init_done) {
 		up_write(&zram->init_lock);
@@ -721,16 +747,40 @@ error:
 	bio_io_error(bio);
 }
 
+static void handle_pend_free_rq(struct work_struct *work)
+{
+	struct zram *zram;
+
+	zram = container_of(work, struct zram, work);
+	down_write(&zram->lock);
+	free_pending_rq(zram);
+	up_write(&zram->lock);
+}
+
+static void add_free_rq(struct zram *zram, struct zram_free_rq *free_rq)
+{
+	spin_lock(&zram->free_rq_lock);
+	free_rq->next = zram->free_rq_head;
+	zram->free_rq_head = free_rq;
+	spin_unlock(&zram->free_rq_lock);
+}
+
 static void zram_slot_free_notify(struct block_device *bdev,
 				unsigned long index)
 {
 	struct zram *zram;
+	struct zram_free_rq *free_rq;
 
 	zram = bdev->bd_disk->private_data;
-	down_write(&zram->lock);
-	zram_free_page(zram, index);
-	up_write(&zram->lock);
 	atomic64_inc(&zram->stats.notify_free);
+
+	free_rq = kmalloc(sizeof(struct zram_free_rq), GFP_ATOMIC);
+	if (!free_rq)
+		return;
+
+	free_rq->index = index;
+	add_free_rq(zram, free_rq);
+	schedule_work(&zram->work);
 }
 
 static const struct block_device_operations zram_devops = {
@@ -777,6 +827,10 @@ static int create_device(struct zram *zram, int device_id)
 	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
 
+	INIT_WORK(&zram->work, handle_pend_free_rq);
+	spin_lock_init(&zram->free_rq_lock);
+	zram->free_rq_head = NULL;
+
 	zram->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 9e57bfb..dec6241 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -94,12 +94,20 @@ struct zram_meta {
 	struct zs_pool *mem_pool;
 };
 
+struct zram_free_rq {
+	unsigned long index;
+	struct zram_free_rq *next;
+};
+
 struct zram {
 	struct zram_meta *meta;
 	struct rw_semaphore lock; /* protect compression buffers, table,
 				   * 32bit stat counters against concurrent
 				   * notifications, reads and writes */
+	struct work_struct work;  /* handle pending free request */
+	void *free_rq_head;	  /* list head of free request */
 	struct request_queue *queue;
+	spinlock_t free_rq_lock;
 	struct gendisk *disk;
 	int init_done;
 	/* Prevent concurrent execution of device init, reset and R/W request */
-- 
1.8.3.2

-- 
Kind regards,
Minchan Kim
