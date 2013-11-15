Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3KOWmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:42:11 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50877 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530Ab3KOWmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:42:08 -0500
Message-ID: <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] aio: fix D-cache aliasing issues
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Helge Deller <deller@gmx.de>
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Date: Fri, 15 Nov 2013 14:42:05 -0800
In-Reply-To: <20131115220529.GA3160@ls3530.box>
References: <20131115220529.GA3160@ls3530.box>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-15 at 23:05 +0100, Helge Deller wrote:
> When a user page mapping is released via kunmap*() functions, the D-cache needs
> to be flushed via flush_dcache_page() to avoid D-cache aliasing issues.
> 
> This patch fixes aio on the parisc platform (and probably others).

This should be flush_kernel_dcache_page().  flush_dcache_page() is for
full coherency but for unmap, we know the page was coherent going in and
may have been modified by the kernel, so only the kernel view needs to
be sync'd.  Technically, by the kernel API, the flush should be done
*before* unmapping.  This would have mattered on parisc until we did
flush via tmpalias which means we no-longer care if the mapping for the
flush exists or not because we always recreate it via the tmpalias
pages.

James

> Signed-off-by: Helge Deller <deller@gmx.de>
> To: Benjamin LaHaise <bcrl@kvack.org>
> To: linux-aio@kvack.org
> Cc: stable@vger.kernel.org    # 3.12+
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 823efcb..2181821 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -514,6 +514,7 @@ static void free_ioctx(struct work_struct *work)
>  		atomic_add(avail, &ctx->reqs_available);
>  		ring->head = ring->tail;
>  		kunmap_atomic(ring);
> +		flush_dcache_page(ctx->ring_pages[0]);
>  
>  		if (atomic_read(&ctx->reqs_available) >= ctx->nr_events - 1)
>  			break;
> @@ -568,6 +569,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
>  					ring = kmap_atomic(ctx->ring_pages[0]);
>  					ring->id = ctx->id;
>  					kunmap_atomic(ring);
> +					flush_dcache_page(ctx->ring_pages[0]);
>  					return 0;
>  				}
>  
> @@ -1032,6 +1034,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
>  	head = ring->head;
>  	tail = ring->tail;
>  	kunmap_atomic(ring);
> +	flush_dcache_page(ctx->ring_pages[0]);
>  
>  	pr_debug("h%u t%u m%u\n", head, tail, ctx->nr_events);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



