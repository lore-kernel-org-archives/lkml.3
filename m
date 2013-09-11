Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3IKIms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:42:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab3IKImq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:42:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [146/251] zram: use zram->lock to protect zram_free_page() in swap free notify path
References: <20130911042707.738353451@goodmis.org>
	<20130911042916.643722187@goodmis.org>
Date: Wed, 11 Sep 2013 09:42:42 +0100
In-Reply-To: <20130911042916.643722187@goodmis.org> (Steven Rostedt's message
	of "Wed, 11 Sep 2013 00:29:33 -0400")
Message-ID: <87y573rbp9.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> 3.6.11.9-rc1 stable review patch.
> If anyone has any objections, please let me know.

This commit seems to cause regressions [1].  There's a fix for it with
commit a0c516cbfc7452c8cbd564525fef66d9f20b46d1 but it doesn't apply
cleanly (it probably requires several other commits to be
backported).  Thus, I am reverting it from the 3.5 extended stable
kernel.

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1215513

Cheers,
-- 
Luis


>
> ------------------
>
> From: Jiang Liu <liuj97@gmail.com>
>
> [ Upstream commit 57ab048532c0d975538cebd4456491b5c34248f4 ]
>
> zram_slot_free_notify() is free-running without any protection from
> concurrent operations. So there are race conditions between
> zram_bvec_read()/zram_bvec_write() and zram_slot_free_notify(),
> and possible consequences include:
> 1) Trigger BUG_ON(!handle) on zram_bvec_write() side.
> 2) Access to freed pages on zram_bvec_read() side.
> 3) Break some fields (bad_compress, good_compress, pages_stored)
>    in zram->stats if the swap layer makes concurrently call to
>    zram_slot_free_notify().
>
> So enhance zram_slot_free_notify() to acquire writer lock on zram->lock
> before calling zram_free_page().
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  drivers/staging/zram/zram_drv.c |    2 ++
>  drivers/staging/zram/zram_drv.h |    5 +++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 38a1b44..4322baf 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -622,7 +622,9 @@ static void zram_slot_free_notify(struct block_device *bdev,
>  	struct zram *zram;
>  
>  	zram = bdev->bd_disk->private_data;
> +	down_write(&zram->lock);
>  	zram_free_page(zram, index);
> +	up_write(&zram->lock);
>  	zram_stat64_inc(zram, &zram->stats.notify_free);
>  }
>  
> diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
> index 572c0b1..a6eb5d9 100644
> --- a/drivers/staging/zram/zram_drv.h
> +++ b/drivers/staging/zram/zram_drv.h
> @@ -92,8 +92,9 @@ struct zram {
>  	void *compress_buffer;
>  	struct table *table;
>  	spinlock_t stat64_lock;	/* protect 64-bit stats */
> -	struct rw_semaphore lock; /* protect compression buffers and table
> -				   * against concurrent read and writes */
> +	struct rw_semaphore lock; /* protect compression buffers, table,
> +				   * 32bit stat counters against concurrent
> +				   * notifications, reads and writes */
>  	struct request_queue *queue;
>  	struct gendisk *disk;
>  	int init_done;
