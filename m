Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3FGIJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:09:50 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48616 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3FGIJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:09:47 -0400
X-AuditID: 9c930197-b7b8cae000003b08-0c-51b1954907c8
Date: Fri, 7 Jun 2013 17:09:45 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Jiang Liu <jiang.liu@huawei.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 05/10] zram: avoid access beyond the zram device
Message-ID: <20130607080945.GD22516@blaptop>
References: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com>
 <1370534851-26056-6-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370534851-26056-6-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 12:07:26AM +0800, Jiang Liu wrote:
> Function valid_io_request() should verify the entire request are within
> the zram device address range. Otherwise it may cause invalid memory
> access when accessing/modifying zram->meta->table[index] because the
> 'index' is out of range. Then it may access non-exist memory, randomly
> modify memory belong to other subsystems, which is hard to track down.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/staging/zram/zram_drv.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 27ab824..9289217 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -420,13 +420,20 @@ out:
>   */
>  static inline int valid_io_request(struct zram *zram, struct bio *bio)
>  {
> -	if (unlikely(
> -		(bio->bi_sector >= (zram->disksize >> SECTOR_SHIFT)) ||
> -		(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)) ||
> -		(bio->bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))) {
> +	u64 start, end, bound;
> +	
> +	/* unaligned request */
> +	if (unlikely(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
> +		return 0;
> +	if (unlikely(bio->bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
> +		return 0;
>  
> +	start = bio->bi_sector;
> +	end = start + (bio->bi_size >> SECTOR_SHIFT);
> +	bound = zram->disksize >> SECTOR_SHIFT;
> +	/* out of range range */
> +	if (unlikely(start >= bound || end >= bound || start > end))

        if (end >= bound || start > end) isn't enough?

>  		return 0;
> -	}
>  
>  	/* I/O request is valid */
>  	return 1;
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
