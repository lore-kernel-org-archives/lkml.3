Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690AbaKSXce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:32:34 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48765 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbaKSXcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:32:32 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 20 Nov 2014 08:32:32 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Karam Lee <karam.lee@lge.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] zram: rely on the bi_end_io for zram_rw_page fails
Message-ID: <20141119233232.GA2627@bbox>
References: <1415926147-9023-1-git-send-email-minchan@kernel.org>
 <20141118152336.d58b7b61a711b7d9982deb9d@linux-foundation.org>
 <20141118235201.GB7393@bbox>
 <20141119131535.7d848c148535c076a17b9d29@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141119131535.7d848c148535c076a17b9d29@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 19, 2014 at 01:15:35PM -0800, Andrew Morton wrote:
> On Wed, 19 Nov 2014 08:52:01 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > > >  
> > > > -	/*
> > > > -	 * Return 0 prevents I/O fallback trial caused by rw_page fail
> > > > -	 * and upper layer can handle this IO error via page error.
> > > > -	 */
> > > > +	page_endio(page, rw, 0);
> > > >  	return 0;
> > > 
> > > Losing the comment makes me sad.  The code is somewhat odd-looking.  We
> > > should add some words explaining why we're not reporting errors at this
> > > point.
> > 
> > Okay. How about this?
> > 
> > 
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index decca6f161b8..1d7c90d5e0d0 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -975,6 +975,12 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
> >  	err = zram_bvec_rw(zram, &bv, index, offset, rw);
> >  out_unlock:
> >  	up_read(&zram->init_lock);
> > +	/*
> > +	 * If I/O fails, just return error without calling page_endio.
> > +	 * It causes resubmit the I/O with bio request by rw_page fallback
> > +	 * and bio I/O complete handler does things to handle the error
> > +	 * (e.g., set_page_dirty of swap_writepage fail).
> > +	 */
> >  	if (err == 0)
> >  		page_endio(page, rw, 0);
> >  	return err;
> 
> I don't understand the comment :( bdev_read_page() doesn't resubmit the
> IO if block_device_operations.rw_page() returns zero and it's unclear

It's not bdev_read_page but upper functions.
(ie, do_mpage_readpage, swap_readpage, __mpage_writepage, __swap_writepage)

> how the bio I/O complete handler (which one?) gets involved.

bio->bi_end_io.

> 
> It would help in the comment was more specific.  Instead of using vague
> terms like "rw_page fallback" and "bio I/O complete handler", use
> actual function names so the reader understand exactly what code we're
> referring to.

Indeed. I was terrible.

Hope this is better.

>From 635f22cac08f76b909ccc13b2de0b5d437eef5aa Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Wed, 19 Nov 2014 08:57:49 +0900
Subject: [PATCH] zram: add comment

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index decca6f161b8..6f1ceb14e64b 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -975,6 +975,14 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	err = zram_bvec_rw(zram, &bv, index, offset, rw);
 out_unlock:
 	up_read(&zram->init_lock);
+	/*
+	 * If I/O fails, just return error(ie, non-zero) without
+	 * calling page_endio.
+	 * It causes resubmit the I/O with bio request by upper functions
+	 * of rw_page(e.g., swap_readpage, __swap_writepage) and
+	 * bio->bi_end_io does things to handle the error
+	 * (e.g., SetPageError, set_page_dirty and extra works).
+	 */
 	if (err == 0)
 		page_endio(page, rw, 0);
 	return err;
-- 
2.0.0

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
