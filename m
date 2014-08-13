Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaHMXCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 19:02:10 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44468 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaHMXCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 19:02:08 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 14 Aug 2014 08:02:16 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Chao Yu <chao2.yu@samsung.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] zram: fix incorrectly stat with failed_reads
Message-ID: <20140813230216.GC9227@bbox>
References: <009001cfb69a$a8470840$f8d518c0$@samsung.com>
 <53EB2271.1080002@redhat.com>
 <20140813113257.GA948@swordfish>
 <20140813144304.GB1091@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140813144304.GB1091@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergey,

On Wed, Aug 13, 2014 at 11:43:04PM +0900, Sergey Senozhatsky wrote:
> Hello,
> 
> On (08/13/14 20:32), Sergey Senozhatsky wrote:
> > On (08/13/14 10:31), Jerome Marchand wrote:
> > > Date: Wed, 13 Aug 2014 10:31:45 +0200
> > > From: Jerome Marchand <jmarchan@redhat.com>
> > > To: Chao Yu <chao2.yu@samsung.com>, minchan@kernel.org
> > > CC: ngupta@vflare.org, linux-kernel@vger.kernel.org, 'Sergey Senozhatsky'
> > >  <sergey.senozhatsky@gmail.com>, 'Andrew Morton'
> > >  <akpm@linux-foundation.org>
> > > Subject: Re: [PATCH v2] zram: fix incorrectly stat with failed_reads
> > > User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
> > >  Thunderbird/24.6.0
> > > 
> > > On 08/13/2014 04:01 AM, Chao Yu wrote:
> > > > Since we allocate a temporary buffer in zram_bvec_read to handle partial page
> > > > operations in this commit 924bd88d703e53d30f393fac6117f8f1bc79aab6 (Staging:
> > > > zram: allow partial page operations), our ->failed_reads value may be incorrect
> > > > as we do not increase its value when failed to allocate the temporary buffer.
> > > > 
> > > > Let's fix this issue and correct the annotation of failed_reads.
> > > > 
> > > >  v2: clean codes of failed_{reads,writes} stat pointed out by Minchan Kim, and
> > > > this cleanup also fix incorrectly stat when fail in zram_decompress_page.
> > > > 
> > > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > 
> > > Acked-by: Jerome Marchand <jmarchan@redhat.com>
> > 
> > Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > 
> > 	-ss
> > 
> > > > ---
> > > >  drivers/block/zram/zram_drv.c | 10 +++++++---
> > > >  drivers/block/zram/zram_drv.h |  2 +-
> > > >  2 files changed, 8 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > > > index dfa4024..d00831c 100644
> > > > --- a/drivers/block/zram/zram_drv.c
> > > > +++ b/drivers/block/zram/zram_drv.c
> > > > @@ -378,7 +378,6 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
> > > >  	/* Should NEVER happen. Return bio error if it does. */
> > > >  	if (unlikely(ret)) {
> > > >  		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
> > > > -		atomic64_inc(&zram->stats.failed_reads);
> > > >  		return ret;
> > > >  	}
> > > >  
> > > > @@ -547,8 +546,6 @@ out:
> > > >  		zcomp_strm_release(zram->comp, zstrm);
> > > >  	if (is_partial_io(bvec))
> > > >  		kfree(uncmem);
> > > > -	if (ret)
> > > > -		atomic64_inc(&zram->stats.failed_writes);
> > > >  	return ret;
> > > >  }
> > > >  
> > > > @@ -566,6 +563,13 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
> > > >  		ret = zram_bvec_write(zram, bvec, index, offset);
> > > >  	}
> > > >  
> > > > +	if (unlikely(ret)) {
> > > > +		if (rw == READ)
> > > > +			atomic64_inc(&zram->stats.failed_reads);
> > > > +		else
> > > > +			atomic64_inc(&zram->stats.failed_writes);
> > > > +	}
> > > > +
> > > >  	return ret;
> > > >  }
> > > >  
> > > > diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> > > > index 5b0afde..e0f725c 100644
> > > > --- a/drivers/block/zram/zram_drv.h
> > > > +++ b/drivers/block/zram/zram_drv.h
> > > > @@ -84,7 +84,7 @@ struct zram_stats {
> > > >  	atomic64_t compr_data_size;	/* compressed size of pages stored */
> > > >  	atomic64_t num_reads;	/* failed + successful */
> > > >  	atomic64_t num_writes;	/* --do-- */
> > > > -	atomic64_t failed_reads;	/* should NEVER! happen */
> > > > +	atomic64_t failed_reads;	/* can happen when memory is too low */
> 
> 
> this grabbed my attention.
> 
> 	"failed_writes; /* can happen when memory is too low */"
> 
> theoretically, we can have a misbehaving compression algorithm. so the
> question is -- should we fail write() if compression has failed for any
> other reason, rather than -ENOMEM? alternatively, we can store uncompressed
> user mem, just the same way we do for `badly' compressed buffers, set a
> FAILED_COMPRESSION flag (so we will not leak kernel memory on read() if we
> failed to compress is_partial_io() bv_page), and on read() copy it out as is,
> just as we do for `badly' compessed pages.
> 
> so, what do you think? /* I can take a look on it */

How often does it happen?
I don't think it's valuable to maintain if it's too rare.
Rather, I'd like to remove the comment on failed_writes. :)

> 
> 	-ss
> 
> > > >  	atomic64_t failed_writes;	/* can happen when memory is too low */
> > > >  	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
> > > >  	atomic64_t notify_free;	/* no. of swap slot free notifications */
> > > > 
> > > 
> > > 
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
