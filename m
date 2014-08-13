Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaHMLeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:34:12 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39865 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaHMLeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:34:11 -0400
Date: Wed, 13 Aug 2014 20:32:57 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Chao Yu <chao2.yu@samsung.com>, minchan@kernel.org, ngupta@vflare.org,
        linux-kernel@vger.kernel.org,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] zram: fix incorrectly stat with failed_reads
Message-ID: <20140813113257.GA948@swordfish>
References: <009001cfb69a$a8470840$f8d518c0$@samsung.com>
 <53EB2271.1080002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EB2271.1080002@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/13/14 10:31), Jerome Marchand wrote:
> Date: Wed, 13 Aug 2014 10:31:45 +0200
> From: Jerome Marchand <jmarchan@redhat.com>
> To: Chao Yu <chao2.yu@samsung.com>, minchan@kernel.org
> CC: ngupta@vflare.org, linux-kernel@vger.kernel.org, 'Sergey Senozhatsky'
>  <sergey.senozhatsky@gmail.com>, 'Andrew Morton'
>  <akpm@linux-foundation.org>
> Subject: Re: [PATCH v2] zram: fix incorrectly stat with failed_reads
> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
>  Thunderbird/24.6.0
> 
> On 08/13/2014 04:01 AM, Chao Yu wrote:
> > Since we allocate a temporary buffer in zram_bvec_read to handle partial page
> > operations in this commit 924bd88d703e53d30f393fac6117f8f1bc79aab6 (Staging:
> > zram: allow partial page operations), our ->failed_reads value may be incorrect
> > as we do not increase its value when failed to allocate the temporary buffer.
> > 
> > Let's fix this issue and correct the annotation of failed_reads.
> > 
> >  v2: clean codes of failed_{reads,writes} stat pointed out by Minchan Kim, and
> > this cleanup also fix incorrectly stat when fail in zram_decompress_page.
> > 
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> 
> Acked-by: Jerome Marchand <jmarchan@redhat.com>

Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss

> > ---
> >  drivers/block/zram/zram_drv.c | 10 +++++++---
> >  drivers/block/zram/zram_drv.h |  2 +-
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index dfa4024..d00831c 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -378,7 +378,6 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
> >  	/* Should NEVER happen. Return bio error if it does. */
> >  	if (unlikely(ret)) {
> >  		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
> > -		atomic64_inc(&zram->stats.failed_reads);
> >  		return ret;
> >  	}
> >  
> > @@ -547,8 +546,6 @@ out:
> >  		zcomp_strm_release(zram->comp, zstrm);
> >  	if (is_partial_io(bvec))
> >  		kfree(uncmem);
> > -	if (ret)
> > -		atomic64_inc(&zram->stats.failed_writes);
> >  	return ret;
> >  }
> >  
> > @@ -566,6 +563,13 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  		ret = zram_bvec_write(zram, bvec, index, offset);
> >  	}
> >  
> > +	if (unlikely(ret)) {
> > +		if (rw == READ)
> > +			atomic64_inc(&zram->stats.failed_reads);
> > +		else
> > +			atomic64_inc(&zram->stats.failed_writes);
> > +	}
> > +
> >  	return ret;
> >  }
> >  
> > diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> > index 5b0afde..e0f725c 100644
> > --- a/drivers/block/zram/zram_drv.h
> > +++ b/drivers/block/zram/zram_drv.h
> > @@ -84,7 +84,7 @@ struct zram_stats {
> >  	atomic64_t compr_data_size;	/* compressed size of pages stored */
> >  	atomic64_t num_reads;	/* failed + successful */
> >  	atomic64_t num_writes;	/* --do-- */
> > -	atomic64_t failed_reads;	/* should NEVER! happen */
> > +	atomic64_t failed_reads;	/* can happen when memory is too low */
> >  	atomic64_t failed_writes;	/* can happen when memory is too low */
> >  	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
> >  	atomic64_t notify_free;	/* no. of swap slot free notifications */
> > 
> 
> 


