Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab3FEG5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 02:57:51 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48947 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3FEG5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 02:57:49 -0400
X-AuditID: 9c93017e-b7bd9ae000006882-f6-51aee16bc79f
Date: Wed, 5 Jun 2013 15:57:47 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/10] zram: optimize memory operations with
 clear_page()/copy_page()
Message-ID: <20130605065747.GG8732@blaptop>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
 <1370361968-8764-7-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370361968-8764-7-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good but although we can know your intention easily with only
subject, it would be better to add body in description.

More questionable thing is I'm not sure Greg accepts this optimization
patch(NOT bug fix) because he claimed he will not accept any patches
from zram/zsmalloc except plain bug fix patch if we don't give any
plan about promotion from staging tree and we didn't yet.(Maybe I need
to talk about zsmalloc promotion with z* family people and mm guys)

If it could be acceptable, we have a few patches to optimize zram, too.

On Wed, Jun 05, 2013 at 12:06:05AM +0800, Jiang Liu wrote:
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  drivers/staging/zram/zram_drv.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 1c3974f..a4595ca 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -128,23 +128,26 @@ static void zram_free_page(struct zram *zram, size_t index)
>  	meta->table[index].size = 0;
>  }
>  
> +static inline int is_partial_io(struct bio_vec *bvec)
> +{
> +	return bvec->bv_len != PAGE_SIZE;
> +}
> +
>  static void handle_zero_page(struct bio_vec *bvec)
>  {
>  	struct page *page = bvec->bv_page;
>  	void *user_mem;
>  
>  	user_mem = kmap_atomic(page);
> -	memset(user_mem + bvec->bv_offset, 0, bvec->bv_len);
> +	if (is_partial_io(bvec))
> +		memset(user_mem + bvec->bv_offset, 0, bvec->bv_len);
> +	else
> +		clear_page(user_mem);
>  	kunmap_atomic(user_mem);
>  
>  	flush_dcache_page(page);
>  }
>  
> -static inline int is_partial_io(struct bio_vec *bvec)
> -{
> -	return bvec->bv_len != PAGE_SIZE;
> -}
> -
>  static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>  {
>  	int ret = LZO_E_OK;
> @@ -154,13 +157,13 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>  	unsigned long handle = meta->table[index].handle;
>  
>  	if (!handle || zram_test_flag(meta, index, ZRAM_ZERO)) {
> -		memset(mem, 0, PAGE_SIZE);
> +		clear_page(mem);
>  		return 0;
>  	}
>  
>  	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_RO);
>  	if (meta->table[index].size == PAGE_SIZE)
> -		memcpy(mem, cmem, PAGE_SIZE);
> +		copy_page(mem, cmem);
>  	else
>  		ret = lzo1x_decompress_safe(cmem, meta->table[index].size,
>  						mem, &clen);
> @@ -309,11 +312,13 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  	}
>  	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_WO);
>  
> -	if ((clen == PAGE_SIZE) && !is_partial_io(bvec))
> +	if ((clen == PAGE_SIZE) && !is_partial_io(bvec)) {
>  		src = kmap_atomic(page);
> -	memcpy(cmem, src, clen);
> -	if ((clen == PAGE_SIZE) && !is_partial_io(bvec))
> +		copy_page(cmem, src);
>  		kunmap_atomic(src);
> +	} else {
> +		memcpy(cmem, src, clen);
> +	}
>  
>  	zs_unmap_object(meta->mem_pool, handle);
>  
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
