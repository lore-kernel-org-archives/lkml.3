Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaKRXXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:23:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbaKRXXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:23:37 -0500
Date: Tue, 18 Nov 2014 15:23:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Karam Lee <karam.lee@lge.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] zram: rely on the bi_end_io for zram_rw_page fails
Message-Id: <20141118152336.d58b7b61a711b7d9982deb9d@linux-foundation.org>
In-Reply-To: <1415926147-9023-1-git-send-email-minchan@kernel.org>
References: <1415926147-9023-1-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 09:49:07 +0900 Minchan Kim <minchan@kernel.org> wrote:

> When I tested zram, I found processes got segfaulted.
> The reason was zram_rw_page doesn't make the page dirty
> again when swap write failed, and even it doesn't return
> error by [1].
> 
> If error by zram internal happens, zram_rw_page should return
> non-zero without calling page_endio.
> It causes resubmit the IO with bio so that it ends up calling
> bio->bi_end_io.
> 
> The reason is zram could be used for a block device for FS and
> swap, which they uses different bio complete callback, which
> works differently. So, we should rely on the bio I/O complete
> handler rather than zram_bvec_rw itself in case of I/O fail.
> 
> This patch fixes the segfault issue as well one [1]'s
> mentioned
> 
> ...
>
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -978,12 +978,10 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
>  out_unlock:
>  	up_read(&zram->init_lock);
>  out:
> -	page_endio(page, rw, err);
> +	if (unlikely(err))
> +		return err;
>  
> -	/*
> -	 * Return 0 prevents I/O fallback trial caused by rw_page fail
> -	 * and upper layer can handle this IO error via page error.
> -	 */
> +	page_endio(page, rw, 0);
>  	return 0;

Losing the comment makes me sad.  The code is somewhat odd-looking.  We
should add some words explaining why we're not reporting errors at this
point.

