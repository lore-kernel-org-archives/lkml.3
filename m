Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbbA2EVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 23:21:19 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60278 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbbA2EVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 23:21:17 -0500
Date: Thu, 29 Jan 2015 13:21:15 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH v2] zram: free meta table in zram_meta_free
Message-ID: <20150129042115.GB2555@swordfish>
References: <1421711028-5553-1-git-send-email-opensource.ganesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421711028-5553-1-git-send-email-opensource.ganesh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/20/15 07:43), Ganesh Mahendran wrote:
> zram_meta_alloc() and zram_meta_free() are a pair.
> In zram_meta_alloc(), meta table is allocated. So it it better to free
> it in zram_meta_free().
> 
> Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>


Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss

> ---
> v2: use zram->disksize to get num of pages - Sergey
> ---
>  drivers/block/zram/zram_drv.c |   33 ++++++++++++++++-----------------
>  1 file changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 9250b3f..aa5a4c5 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -307,8 +307,21 @@ static inline int valid_io_request(struct zram *zram,
>  	return 1;
>  }
>  
> -static void zram_meta_free(struct zram_meta *meta)
> +static void zram_meta_free(struct zram_meta *meta, u64 disksize)
>  {
> +	size_t num_pages = disksize >> PAGE_SHIFT;
> +	size_t index;
> +
> +	/* Free all pages that are still in this zram device */
> +	for (index = 0; index < num_pages; index++) {
> +		unsigned long handle = meta->table[index].handle;
> +
> +		if (!handle)
> +			continue;
> +
> +		zs_free(meta->mem_pool, handle);
> +	}
> +
>  	zs_destroy_pool(meta->mem_pool);
>  	vfree(meta->table);
>  	kfree(meta);
> @@ -706,9 +719,6 @@ static void zram_bio_discard(struct zram *zram, u32 index,
>  
>  static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  {
> -	size_t index;
> -	struct zram_meta *meta;
> -
>  	down_write(&zram->init_lock);
>  
>  	zram->limit_pages = 0;
> @@ -718,20 +728,9 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  		return;
>  	}
>  
> -	meta = zram->meta;
> -	/* Free all pages that are still in this zram device */
> -	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
> -		unsigned long handle = meta->table[index].handle;
> -		if (!handle)
> -			continue;
> -
> -		zs_free(meta->mem_pool, handle);
> -	}
> -
>  	zcomp_destroy(zram->comp);
>  	zram->max_comp_streams = 1;
> -
> -	zram_meta_free(zram->meta);
> +	zram_meta_free(zram->meta, zram->disksize);
>  	zram->meta = NULL;
>  	/* Reset stats */
>  	memset(&zram->stats, 0, sizeof(zram->stats));
> @@ -803,7 +802,7 @@ out_destroy_comp:
>  	up_write(&zram->init_lock);
>  	zcomp_destroy(comp);
>  out_free_meta:
> -	zram_meta_free(meta);
> +	zram_meta_free(meta, disksize);
>  	return err;
>  }
>  
> -- 
> 1.7.9.5
> 
