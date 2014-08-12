Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaHLJlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:41:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23186 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaHLJla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:41:30 -0400
X-AuditID: cbfee61a-f79e46d00000134f-c9-53e9e1489a21
From: Chao Yu <chao2.yu@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        "'Jerome Marchand'" <jmarchan@redhat.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
References: <000001cfb53f$d63b6ea0$82b24be0$@samsung.com>
 <20140812073740.GA9227@bbox>
In-reply-to: <20140812073740.GA9227@bbox>
Subject: RE: [PATCH] zram: fix incorrectly stat with failed_reads
Date: Tue, 12 Aug 2014 17:40:32 +0800
Message-id: <005201cfb611$97362100$c5a26300$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQF4FQUURvVmlZfToiq37apX9RhKNwG2iExAnG4ot8A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9jAV2Phy+DDb7c4rKYs34Nm8WpP9eZ
	LC7vmsNmsezre3aLDS2z2C3Wfn7M7sDmsXPWXXaPTas62TxOzPjN4vF+31Wg2KfNrB6fN8kF
	sEVx2aSk5mSWpRbp2yVwZTRc+8NY8E+uomfyY5YGxkviXYycHBICJhLvD9xjh7DFJC7cW8/W
	xcjFISSwiFGi4+c+RpCEkMAPRon/29NAbDYBFYnlHf+ZQGwRATWJdQdfsIA0MAscYZRo+XuY
	HaIhQuLykdlARRwcnAKaErO21ICEhQUcJXYeuMEKYrMIqEpsffoMzOYVsJTYN+8+lC0o8WPy
	PRYQm1lAXWLSvEXMELa8xOY1b5khDlWQ2HH2NSPEDVYS/3bcgaoXl9h45BbLBEahWUhGzUIy
	ahaSUbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERwtz6R2MK5ssDjEKMDBqMTD
	O+Pvi2Ah1sSy4srcQ4wSHMxKIryCt18GC/GmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQ
	nliSmp2aWpBaBJNl4uCUamAs2sbEtqqvPLBQSelhwJaLoYnlG89bLSv2azQ1/MT20T+kdKbk
	uhkJHTf+fJH7/LDqWeWP43cmsr0SLlt5MCG5Pu2pwf+r2ZznFjuo5qXlF3NtOe5idP3PAYXc
	qRrZsnfkskzP/9Nj+PQiZ6LCTp/VEe71p1wmWOm9f3OnJObK6Q9/P5SbRacqsRRnJBpqMRcV
	JwIADz2ZP5ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

> -----Original Message-----
> From: Minchan Kim [mailto:minchan@kernel.org]
> Sent: Tuesday, August 12, 2014 3:38 PM
> To: Chao Yu
> Cc: ngupta@vflare.org; linux-kernel@vger.kernel.org; Jerome Marchand; Sergey Senozhatsky;
> Andrew Morton
> Subject: Re: [PATCH] zram: fix incorrectly stat with failed_reads
> 
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

I found this one by code review.

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

I think this implementation of yours is pretty clean and simple because this one
hides every error paths inside zram_bvec_{read,write}, so we do not need to
consider covering the stat code to everywhere of inside.

IMHO, your implementation also fixed the issue in following call chain:
->zram_bvec_rw
  ->zram_bvec_write
    ->zram_decompress_page
      ->atomic64_inc(failed_reads)    ---at perspective of user, this kind of
      failure should be regarded as the write one's, because user pay fewer
      attention to inner error of zram.

Please correct me if I'm wrong, and thanks for your review and suggestion. :)

Regards,
Yu

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

