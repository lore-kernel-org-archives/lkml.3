Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaAPN7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:59:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbaAPN7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:59:13 -0500
Message-ID: <52D7E577.5020506@redhat.com>
Date: Thu, 16 Jan 2014 14:58:15 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 4/8] zram: use atomic64_t for all zram stats
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com> <1389877936-15543-5-git-send-email-sergey.senozhatsky@gmail.com>
In-Reply-To: <1389877936-15543-5-git-send-email-sergey.senozhatsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 02:12 PM, Sergey Senozhatsky wrote:
> This is a preparation patch for stats code duplication removal.
> 
> 1) use atomic64_t for `pages_zero' and `pages_stored' zram stats.
> 2) `compr_size' and `pages_zero' struct zram_stats members did not
> follow the existing device attr naming scheme: zram_stats.ATTR has
> ATTR_show() function. rename them:
> -- compr_size -> compr_data_size
> -- pages_zero -> zero_pages
> 
> Minchan Kim's note:
>  If we really have trouble with atomic stat operation, we could
>  change it with percpu_counter so that it could solve atomic overhead and
>  unnecessary memory space by introducing unsigned long instead of 64bit
>  atomic_t.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>

> ---
>  drivers/block/zram/zram_drv.c | 18 +++++++++---------
>  drivers/block/zram/zram_drv.h |  6 +++---
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index c7c7789..0035d39 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -109,7 +109,7 @@ static ssize_t zero_pages_show(struct device *dev,
>  {
>  	struct zram *zram = dev_to_zram(dev);
>  
> -	return sprintf(buf, "%u\n", atomic_read(&zram->stats.pages_zero));
> +	return sprintf(buf, "%llu\n", (u64)atomic64_read(&zram->stats.zero_pages));
>  }
>  
>  static ssize_t orig_data_size_show(struct device *dev,
> @@ -118,7 +118,7 @@ static ssize_t orig_data_size_show(struct device *dev,
>  	struct zram *zram = dev_to_zram(dev);
>  
>  	return sprintf(buf, "%llu\n",
> -		(u64)(atomic_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
> +		(u64)(atomic64_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
>  }
>  
>  static ssize_t compr_data_size_show(struct device *dev,
> @@ -127,7 +127,7 @@ static ssize_t compr_data_size_show(struct device *dev,
>  	struct zram *zram = dev_to_zram(dev);
>  
>  	return sprintf(buf, "%llu\n",
> -			(u64)atomic64_read(&zram->stats.compr_size));
> +			(u64)atomic64_read(&zram->stats.compr_data_size));
>  }
>  
>  static ssize_t mem_used_total_show(struct device *dev,
> @@ -301,15 +301,15 @@ static void zram_free_page(struct zram *zram, size_t index)
>  		 */
>  		if (zram_test_flag(meta, index, ZRAM_ZERO)) {
>  			zram_clear_flag(meta, index, ZRAM_ZERO);
> -			atomic_dec(&zram->stats.pages_zero);
> +			atomic64_dec(&zram->stats.zero_pages);
>  		}
>  		return;
>  	}
>  
>  	zs_free(meta->mem_pool, handle);
>  
> -	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
> -	atomic_dec(&zram->stats.pages_stored);
> +	atomic64_sub(meta->table[index].size, &zram->stats.compr_data_size);
> +	atomic64_dec(&zram->stats.pages_stored);
>  
>  	meta->table[index].handle = 0;
>  	meta->table[index].size = 0;
> @@ -452,7 +452,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  		zram_set_flag(meta, index, ZRAM_ZERO);
>  		write_unlock(&zram->meta->tb_lock);
>  
> -		atomic_inc(&zram->stats.pages_zero);
> +		atomic64_inc(&zram->stats.zero_pages);
>  		ret = 0;
>  		goto out;
>  	}
> @@ -508,8 +508,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  	write_unlock(&zram->meta->tb_lock);
>  
>  	/* Update stats */
> -	atomic64_add(clen, &zram->stats.compr_size);
> -	atomic_inc(&zram->stats.pages_stored);
> +	atomic64_add(clen, &zram->stats.compr_data_size);
> +	atomic64_inc(&zram->stats.pages_stored);
>  out:
>  	if (locked)
>  		mutex_unlock(&meta->buffer_lock);
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index 2f173cb..58d4ac5 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -69,15 +69,15 @@ struct table {
>  } __aligned(4);
>  
>  struct zram_stats {
> -	atomic64_t compr_size;	/* compressed size of pages stored */
> +	atomic64_t compr_data_size;	/* compressed size of pages stored */
>  	atomic64_t num_reads;	/* failed + successful */
>  	atomic64_t num_writes;	/* --do-- */
>  	atomic64_t failed_reads;	/* should NEVER! happen */
>  	atomic64_t failed_writes;	/* can happen when memory is too low */
>  	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
>  	atomic64_t notify_free;	/* no. of swap slot free notifications */
> -	atomic_t pages_zero;		/* no. of zero filled pages */
> -	atomic_t pages_stored;	/* no. of pages currently stored */
> +	atomic64_t zero_pages;		/* no. of zero filled pages */
> +	atomic64_t pages_stored;	/* no. of pages currently stored */
>  };
>  
>  struct zram_meta {
> 

