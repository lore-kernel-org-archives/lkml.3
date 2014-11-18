Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbaKRXvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:51:33 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59833 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648AbaKRXvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:51:32 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 19 Nov 2014 08:52:01 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Karam Lee <karam.lee@lge.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] zram: rely on the bi_end_io for zram_rw_page fails
Message-ID: <20141118235201.GB7393@bbox>
References: <1415926147-9023-1-git-send-email-minchan@kernel.org>
 <20141118152336.d58b7b61a711b7d9982deb9d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141118152336.d58b7b61a711b7d9982deb9d@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 03:23:36PM -0800, Andrew Morton wrote:
> On Fri, 14 Nov 2014 09:49:07 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > When I tested zram, I found processes got segfaulted.
> > The reason was zram_rw_page doesn't make the page dirty
> > again when swap write failed, and even it doesn't return
> > error by [1].
> > 
> > If error by zram internal happens, zram_rw_page should return
> > non-zero without calling page_endio.
> > It causes resubmit the IO with bio so that it ends up calling
> > bio->bi_end_io.
> > 
> > The reason is zram could be used for a block device for FS and
> > swap, which they uses different bio complete callback, which
> > works differently. So, we should rely on the bio I/O complete
> > handler rather than zram_bvec_rw itself in case of I/O fail.
> > 
> > This patch fixes the segfault issue as well one [1]'s
> > mentioned
> > 
> > ...
> >
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -978,12 +978,10 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
> >  out_unlock:
> >  	up_read(&zram->init_lock);
> >  out:
> > -	page_endio(page, rw, err);
> > +	if (unlikely(err))
> > +		return err;
> >  
> > -	/*
> > -	 * Return 0 prevents I/O fallback trial caused by rw_page fail
> > -	 * and upper layer can handle this IO error via page error.
> > -	 */
> > +	page_endio(page, rw, 0);
> >  	return 0;
> 
> Losing the comment makes me sad.  The code is somewhat odd-looking.  We
> should add some words explaining why we're not reporting errors at this
> point.

Okay. How about this?


diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index decca6f161b8..1d7c90d5e0d0 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -975,6 +975,12 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 	err = zram_bvec_rw(zram, &bv, index, offset, rw);
 out_unlock:
 	up_read(&zram->init_lock);
+	/*
+	 * If I/O fails, just return error without calling page_endio.
+	 * It causes resubmit the I/O with bio request by rw_page fallback
+	 * and bio I/O complete handler does things to handle the error
+	 * (e.g., set_page_dirty of swap_writepage fail).
+	 */
 	if (err == 0)
 		page_endio(page, rw, 0);
 	return err;


> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
