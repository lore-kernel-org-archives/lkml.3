Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaBMFEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 00:04:42 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55508 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaBMFEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 00:04:41 -0500
X-Original-SENDERIP: 10.177.220.194
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 13 Feb 2014 14:04:39 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 2/4] zram: use zcomp compressing backends
Message-ID: <20140213050439.GA5882@bbox>
References: <1392233976-26473-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1392233976-26473-4-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392233976-26473-4-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:39:34PM +0300, Sergey Senozhatsky wrote:
> Do not perform direct LZO compress/decompress calls,
> initialise and use zcomp LZO backend instead.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/block/zram/Makefile   |  2 +-
>  drivers/block/zram/zram_drv.c | 62 +++++++++++++++++++------------------------
>  drivers/block/zram/zram_drv.h |  8 +++---
>  3 files changed, 33 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/block/zram/Makefile b/drivers/block/zram/Makefile
> index cb0f9ce..757c6a5 100644
> --- a/drivers/block/zram/Makefile
> +++ b/drivers/block/zram/Makefile
> @@ -1,3 +1,3 @@
> -zram-y	:=	zram_drv.o
> +zram-y	:=	zcomp_lzo.o zcomp.o zram_drv.o
>  
>  obj-$(CONFIG_ZRAM)	+=	zram.o
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 9baac5b..d0d7254 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -29,15 +29,14 @@
>  #include <linux/genhd.h>
>  #include <linux/highmem.h>
>  #include <linux/slab.h>
> -#include <linux/lzo.h>
>  #include <linux/string.h>
> -#include <linux/vmalloc.h>
>  
>  #include "zram_drv.h"
>  
>  /* Globals */
>  static int zram_major;
>  static struct zram *zram_devices;
> +static const char *default_compressor = "lzo";
>  
>  /* Module params (documentation at end) */
>  static unsigned int num_devices = 1;
> @@ -160,8 +159,6 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
>  static void zram_meta_free(struct zram_meta *meta)
>  {
>  	zs_destroy_pool(meta->mem_pool);
> -	kfree(meta->compress_workmem);
> -	free_pages((unsigned long)meta->compress_buffer, 1);
>  	vfree(meta->table);
>  	kfree(meta);
>  }
> @@ -173,22 +170,11 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
>  	if (!meta)
>  		goto out;
>  
> -	meta->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
> -	if (!meta->compress_workmem)
> -		goto free_meta;
> -
> -	meta->compress_buffer =
> -		(void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
> -	if (!meta->compress_buffer) {
> -		pr_err("Error allocating compressor buffer space\n");
> -		goto free_workmem;
> -	}
> -
>  	num_pages = disksize >> PAGE_SHIFT;
>  	meta->table = vzalloc(num_pages * sizeof(*meta->table));
>  	if (!meta->table) {
>  		pr_err("Error allocating zram address table\n");
> -		goto free_buffer;
> +		goto free_meta;
>  	}
>  
>  	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
> @@ -198,15 +184,10 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
>  	}
>  
>  	rwlock_init(&meta->tb_lock);
> -	mutex_init(&meta->buffer_lock);
>  	return meta;
>  
>  free_table:
>  	vfree(meta->table);
> -free_buffer:
> -	free_pages((unsigned long)meta->compress_buffer, 1);
> -free_workmem:
> -	kfree(meta->compress_workmem);
>  free_meta:
>  	kfree(meta);
>  	meta = NULL;
> @@ -280,7 +261,7 @@ static void zram_free_page(struct zram *zram, size_t index)
>  
>  static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>  {
> -	int ret = LZO_E_OK;
> +	int ret = 0;
>  	size_t clen = PAGE_SIZE;
>  	unsigned char *cmem;
>  	struct zram_meta *meta = zram->meta;
> @@ -301,12 +282,12 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>  	if (size == PAGE_SIZE)
>  		copy_page(mem, cmem);
>  	else
> -		ret = lzo1x_decompress_safe(cmem, size,	mem, &clen);
> +		ret = zcomp_decompress(zram->comp, cmem, size, mem, &clen);
>  	zs_unmap_object(meta->mem_pool, handle);
>  	read_unlock(&meta->tb_lock);
>  
>  	/* Should NEVER happen. Return bio error if it does. */
> -	if (unlikely(ret != LZO_E_OK)) {

Hmm this code depends on that "LZO_E_OK 0" but it could be changed in future
so it ends up break. Perhaps, we should handle it in backend.

zcomp_lzo.c:

int lzo_decompress()
{
        int ret = lzo1x_decompress_safe(xxx);
        if (ret != LZO_E_OK)
                return ret;
}


> +	if (unlikely(ret)) {
>  		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
>  		atomic64_inc(&zram->stats.failed_reads);
>  		return ret;
> @@ -349,7 +330,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>  
>  	ret = zram_decompress_page(zram, uncmem, index);
>  	/* Should NEVER happen. Return bio error if it does. */
> -	if (unlikely(ret != LZO_E_OK))
> +	if (unlikely(ret))
>  		goto out_cleanup;
>  
>  	if (is_partial_io(bvec))
> @@ -374,11 +355,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  	struct page *page;
>  	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
>  	struct zram_meta *meta = zram->meta;
> +	struct zcomp_strm *zstrm;
>  	bool locked = false;
>  
>  	page = bvec->bv_page;
> -	src = meta->compress_buffer;
> -
>  	if (is_partial_io(bvec)) {
>  		/*
>  		 * This is a partial IO. We need to read the full page
> @@ -394,7 +374,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  			goto out;
>  	}
>  
> -	mutex_lock(&meta->buffer_lock);
> +	zstrm = zcomp_strm_get(zram->comp);
>  	locked = true;
>  	user_mem = kmap_atomic(page);
>  
> @@ -420,19 +400,18 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  		goto out;
>  	}
>  
> -	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
> -			       meta->compress_workmem);
> +	ret = zcomp_compress(zram->comp, zstrm, uncmem, bvec->bv_len, &clen);
>  	if (!is_partial_io(bvec)) {
>  		kunmap_atomic(user_mem);
>  		user_mem = NULL;
>  		uncmem = NULL;
>  	}
>  
> -	if (unlikely(ret != LZO_E_OK)) {
> +	if (unlikely(ret)) {
>  		pr_err("Compression failed! err=%d\n", ret);
>  		goto out;
>  	}
> -
> +	src = zstrm->buffer;
>  	if (unlikely(clen > max_zpage_size)) {
>  		clen = PAGE_SIZE;
>  		src = NULL;
> @@ -457,6 +436,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  		memcpy(cmem, src, clen);
>  	}
>  
> +	zcomp_strm_put(zram->comp, zstrm);
> +	locked = false;
>  	zs_unmap_object(meta->mem_pool, handle);
>  
>  	/*
> @@ -475,10 +456,9 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  	atomic64_inc(&zram->stats.pages_stored);
>  out:
>  	if (locked)
> -		mutex_unlock(&meta->buffer_lock);
> +		zcomp_strm_put(zram->comp, zstrm);
>  	if (is_partial_io(bvec))
>  		kfree(uncmem);
> -
>  	if (ret)
>  		atomic64_inc(&zram->stats.failed_writes);
>  	return ret;
> @@ -522,6 +502,10 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  		zs_free(meta->mem_pool, handle);
>  	}
>  
> +	if (zram->comp)
> +		zcomp_destroy(zram->comp);
> +	zram->comp = NULL;

Why we need to reset NULL?

> +
>  	zram_meta_free(zram->meta);
>  	zram->meta = NULL;
>  	/* Reset stats */
> @@ -550,9 +534,18 @@ static ssize_t disksize_store(struct device *dev,
>  		return -EBUSY;
>  	}
>  
> +	zram->comp = zcomp_create(default_compressor);
> +	if (!zram->comp) {
> +		up_write(&zram->init_lock);
> +		pr_info("Cannot initialise compressing backend\n");
> +		return -EINVAL;
> +	}
> +
>  	disksize = PAGE_ALIGN(disksize);
>  	zram->meta = zram_meta_alloc(disksize);
>  	if (!zram->meta) {
> +		zcomp_destroy(zram->comp);
> +		zram->comp = NULL;
>  		up_write(&zram->init_lock);
>  		return -ENOMEM;
>  	}
> @@ -790,6 +783,7 @@ static int create_device(struct zram *zram, int device_id)
>  	}
>  
>  	zram->meta = NULL;
> +	zram->comp = NULL;
>  	return 0;
>  
>  out_free_disk:
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index 1d5b1f5..45e04f7 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -16,9 +16,10 @@
>  #define _ZRAM_DRV_H_
>  
>  #include <linux/spinlock.h>
> -#include <linux/mutex.h>
>  #include <linux/zsmalloc.h>
>  
> +#include "zcomp.h"
> +
>  /*
>   * Some arbitrary value. This is just to catch
>   * invalid value for num_devices module parameter.
> @@ -81,17 +82,16 @@ struct zram_stats {
>  
>  struct zram_meta {
>  	rwlock_t tb_lock;	/* protect table */
> -	void *compress_workmem;
> -	void *compress_buffer;
>  	struct table *table;
>  	struct zs_pool *mem_pool;
> -	struct mutex buffer_lock; /* protect compress buffers */
>  };
>  
>  struct zram {
>  	struct zram_meta *meta;
>  	struct request_queue *queue;
>  	struct gendisk *disk;
> +	struct zcomp *comp;
> +
>  	/* Prevent concurrent execution of device init, reset and R/W request */
>  	struct rw_semaphore init_lock;
>  	/*
> -- 
> 1.9.0.rc3.256.g4af3ebd
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
