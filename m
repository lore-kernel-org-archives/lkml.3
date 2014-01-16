Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaAPNpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:45:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbaAPNpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:45:04 -0500
Message-ID: <52D7E225.7000105@redhat.com>
Date: Thu, 16 Jan 2014 14:44:05 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/8] zram: remove good and bad compress stats
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com> <1389877936-15543-4-git-send-email-sergey.senozhatsky@gmail.com>
In-Reply-To: <1389877936-15543-4-git-send-email-sergey.senozhatsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 02:12 PM, Sergey Senozhatsky wrote:
> Remove `good' and `bad' compressed sub-requests stats. RW request may
> cause a number of RW sub-requests. zram used to account `good' compressed
> sub-queries (with compressed size less than 50% of original size), `bad'
> compressed sub-queries (with compressed size greater that 75% of original
> size), leaving sub-requests with compression size between 50% and 75% of
> original size not accounted and not reported. zram already accounts each
> sub-request's compression size so we can calculate real device compression
> ratio.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>

> ---
>  drivers/block/zram/zram_drv.c | 11 -----------
>  drivers/block/zram/zram_drv.h |  2 --
>  2 files changed, 13 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index b0bcb7e..c7c7789 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -293,7 +293,6 @@ static void zram_free_page(struct zram *zram, size_t index)
>  {
>  	struct zram_meta *meta = zram->meta;
>  	unsigned long handle = meta->table[index].handle;
> -	u16 size = meta->table[index].size;
>  
>  	if (unlikely(!handle)) {
>  		/*
> @@ -307,14 +306,8 @@ static void zram_free_page(struct zram *zram, size_t index)
>  		return;
>  	}
>  
> -	if (unlikely(size > max_zpage_size))
> -		atomic_dec(&zram->stats.bad_compress);
> -
>  	zs_free(meta->mem_pool, handle);
>  
> -	if (size <= PAGE_SIZE / 2)
> -		atomic_dec(&zram->stats.good_compress);
> -
>  	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
>  	atomic_dec(&zram->stats.pages_stored);
>  
> @@ -478,7 +471,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  	}
>  
>  	if (unlikely(clen > max_zpage_size)) {
> -		atomic_inc(&zram->stats.bad_compress);
>  		clen = PAGE_SIZE;
>  		src = NULL;
>  		if (is_partial_io(bvec))
> @@ -518,9 +510,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  	/* Update stats */
>  	atomic64_add(clen, &zram->stats.compr_size);
>  	atomic_inc(&zram->stats.pages_stored);
> -	if (clen <= PAGE_SIZE / 2)
> -		atomic_inc(&zram->stats.good_compress);
> -
>  out:
>  	if (locked)
>  		mutex_unlock(&meta->buffer_lock);
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index e81e9cd..2f173cb 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -78,8 +78,6 @@ struct zram_stats {
>  	atomic64_t notify_free;	/* no. of swap slot free notifications */
>  	atomic_t pages_zero;		/* no. of zero filled pages */
>  	atomic_t pages_stored;	/* no. of pages currently stored */
> -	atomic_t good_compress;	/* % of pages with compression ratio<=50% */
> -	atomic_t bad_compress;	/* % of pages with compression ratio>=75% */
>  };
>  
>  struct zram_meta {
> 

