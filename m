Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaAOCKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:10:09 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50818 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaAOCKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:10:05 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-08-52d5edfb9ec8
Date: Wed, 15 Jan 2014 11:10:51 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] zram: do not pass rw argument to
 __zram_make_request()
Message-ID: <20140115021051.GH1992@bbox>
References: <1389692260-4421-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389692260-4421-3-git-send-email-sergey.senozhatsky@gmail.com>
 <52D5195A.3040001@redhat.com>
 <20140114112723.GA2226@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114112723.GA2226@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergey,

On Tue, Jan 14, 2014 at 02:27:23PM +0300, Sergey Senozhatsky wrote:
> Do not pass rw argument down the __zram_make_request() -> zram_bvec_rw()
> chain, decode it in zram_bvec_rw() instead. Besides, this is the place
> where we distinguish READ (+READ AHEAD) and WRITE bio data directions, so
> account zram RW stats here, instead of __zram_make_request(). This also
> allows to account a real number of zram READ/WRITE operations, not just
> requests (single RW request may cause a number of zram RW ops with separate
> locking, compression/decompression, etc).
> 
> v2: use bio_rw() instead of bio_data_dir(). noted by Jerome Marchand.

We don't have any special logic for READA so please use bio_data_dir
instead of bio_rw.

And please Ccing Andrew Morton when you send a updated patch.
Thanks.

> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/block/zram/zram_drv.c | 33 +++++++++++++++------------------
>  1 file changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index c323e05..2a7682c 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -533,14 +533,21 @@ out:
>  }
>  
>  static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
> -			int offset, struct bio *bio, int rw)
> +			int offset, struct bio *bio)
>  {
>  	int ret;
> +	int rw = bio_rw(bio);
>  
> -	if (rw == READ)
> +	if (rw == READA)
> +		rw = READ;
> +
> +	if (rw == READ) {
> +		atomic64_inc(&zram->stats.num_reads);
>  		ret = zram_bvec_read(zram, bvec, index, offset, bio);
> -	else
> +	} else {
> +		atomic64_inc(&zram->stats.num_writes);
>  		ret = zram_bvec_write(zram, bvec, index, offset);
> +	}
>  
>  	return ret;
>  }
> @@ -670,22 +677,13 @@ out:
>  	return ret;
>  }
>  
> -static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
> +static void __zram_make_request(struct zram *zram, struct bio *bio)
>  {
>  	int offset;
>  	u32 index;
>  	struct bio_vec bvec;
>  	struct bvec_iter iter;
>  
> -	switch (rw) {
> -	case READ:
> -		atomic64_inc(&zram->stats.num_reads);
> -		break;
> -	case WRITE:
> -		atomic64_inc(&zram->stats.num_writes);
> -		break;
> -	}
> -
>  	index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
>  	offset = (bio->bi_iter.bi_sector &
>  		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
> @@ -704,16 +702,15 @@ static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
>  			bv.bv_len = max_transfer_size;
>  			bv.bv_offset = bvec.bv_offset;
>  
> -			if (zram_bvec_rw(zram, &bv, index, offset, bio, rw) < 0)
> +			if (zram_bvec_rw(zram, &bv, index, offset, bio) < 0)
>  				goto out;
>  
>  			bv.bv_len = bvec.bv_len - max_transfer_size;
>  			bv.bv_offset += max_transfer_size;
> -			if (zram_bvec_rw(zram, &bv, index+1, 0, bio, rw) < 0)
> +			if (zram_bvec_rw(zram, &bv, index + 1, 0, bio) < 0)
>  				goto out;
>  		} else
> -			if (zram_bvec_rw(zram, &bvec, index, offset, bio, rw)
> -			    < 0)
> +			if (zram_bvec_rw(zram, &bvec, index, offset, bio) < 0)
>  				goto out;
>  
>  		update_position(&index, &offset, &bvec);
> @@ -743,7 +740,7 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
>  		goto error;
>  	}
>  
> -	__zram_make_request(zram, bio, bio_data_dir(bio));
> +	__zram_make_request(zram, bio);
>  	up_read(&zram->init_lock);
>  
>  	return;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
