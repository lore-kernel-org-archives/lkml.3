Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653AbaKSVPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:15:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873AbaKSVPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:15:36 -0500
Date: Wed, 19 Nov 2014 13:15:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Karam Lee <karam.lee@lge.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] zram: rely on the bi_end_io for zram_rw_page fails
Message-Id: <20141119131535.7d848c148535c076a17b9d29@linux-foundation.org>
In-Reply-To: <20141118235201.GB7393@bbox>
References: <1415926147-9023-1-git-send-email-minchan@kernel.org>
	<20141118152336.d58b7b61a711b7d9982deb9d@linux-foundation.org>
	<20141118235201.GB7393@bbox>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 08:52:01 +0900 Minchan Kim <minchan@kernel.org> wrote:

> > >  
> > > -	/*
> > > -	 * Return 0 prevents I/O fallback trial caused by rw_page fail
> > > -	 * and upper layer can handle this IO error via page error.
> > > -	 */
> > > +	page_endio(page, rw, 0);
> > >  	return 0;
> > 
> > Losing the comment makes me sad.  The code is somewhat odd-looking.  We
> > should add some words explaining why we're not reporting errors at this
> > point.
> 
> Okay. How about this?
> 
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index decca6f161b8..1d7c90d5e0d0 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -975,6 +975,12 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
>  	err = zram_bvec_rw(zram, &bv, index, offset, rw);
>  out_unlock:
>  	up_read(&zram->init_lock);
> +	/*
> +	 * If I/O fails, just return error without calling page_endio.
> +	 * It causes resubmit the I/O with bio request by rw_page fallback
> +	 * and bio I/O complete handler does things to handle the error
> +	 * (e.g., set_page_dirty of swap_writepage fail).
> +	 */
>  	if (err == 0)
>  		page_endio(page, rw, 0);
>  	return err;

I don't understand the comment :( bdev_read_page() doesn't resubmit the
IO if block_device_operations.rw_page() returns zero and it's unclear
how the bio I/O complete handler (which one?) gets involved.

It would help in the comment was more specific.  Instead of using vague
terms like "rw_page fallback" and "bio I/O complete handler", use
actual function names so the reader understand exactly what code we're
referring to.

