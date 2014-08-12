Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaHLLeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 07:34:13 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59456 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaHLLeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 07:34:10 -0400
Date: Tue, 12 Aug 2014 20:33:00 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Chao Yu <chao2.yu@samsung.com>, ngupta@vflare.org,
        linux-kernel@vger.kernel.org, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] zram: fix incorrectly stat with failed_reads
Message-ID: <20140812113300.GA943@swordfish>
References: <000001cfb53f$d63b6ea0$82b24be0$@samsung.com>
 <20140812073740.GA9227@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812073740.GA9227@bbox>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/12/14 16:37), Minchan Kim wrote:
> On Mon, Aug 11, 2014 at 04:39:17PM +0800, Chao Yu wrote:
> > Since we allocate a temporary buffer in zram_bvec_read to handle partial page
> > operations in this commit 924bd88d703e53d30f393fac6117f8f1bc79aab6 (Staging:
> > zram: allow partial page operations), our ->failed_reads value may be incorrect
> > as we do not increase its value when failed to allocate the temporary buffer.
> > 
> > Let's fix this issue and correct the annotation of failed_reads.
> 
> Good catch.
> Just out of curiosity.
> 
> Did you catch it by code review or real workload?
> 
> > 
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  drivers/block/zram/zram_drv.c | 1 +
> >  drivers/block/zram/zram_drv.h | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index dfa4024..bf8ea1b 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -413,6 +413,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> >  
> >  	if (!uncmem) {
> >  		pr_info("Unable to allocate temp memory\n");
> > +		atomic64_inc(&zram->stats.failed_reads);
> >  		ret = -ENOMEM;
> >  		goto out_cleanup;
> >  	}
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
> > -- 
> > 2.0.1.474.g72c7794
> 
> How abouting moving failed_reads/writes in zram_bvec_rw?
> 
> int zram_bvec_rw(..)
> {
>         if (rw == READ) {
>                 atomic64_inc(num_reads);
>                 ret = zram_bvec_read(xxx);
>         } else {
>                 atomic64_inc(&num_writes);
>                 ret = zram_bvec_write(xxx);
>         }
> 
>         if (unlikely(ret)) {
>                 if (rw == READ)
>                         atomic64_inc(failed_reads);
>                 else
>                         atomic64_inc(failed_writes);
>         }
> }
> 

looks good. these stats were supposed to be here.

	-ss

> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Kind regards,
> Minchan Kim
> 
