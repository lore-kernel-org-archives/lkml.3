Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab3LFP04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:26:56 -0500
Received: from kanga.kvack.org ([205.233.56.17]:36753 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab3LFP0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:26:55 -0500
Date: Fri, 6 Dec 2013 10:26:54 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Kent <kmo@daterainc.com>, Kristian Nielsen <knielsen@knielsen-hq.org>
Subject: Re: [PATCH] aio: clean up aio ring in the fail path
Message-ID: <20131206152654.GD13581@kvack.org>
References: <529F019A.2040401@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529F019A.2040401@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 06:19:06PM +0800, Gu Zheng wrote:
> Clean up the aio ring file in the fail path of aio_setup_ring
> and ioctx_alloc. And maybe it can fix the GPF issue reported by
> Dave Jones:
> https://lkml.org/lkml/2013/11/25/898

Good catch.  I've applied this to my aio-next tree.  It does indeed look 
like it could be the cause of Dave's GPF -- I'll try to trigger it with 
some other kernel debug options on and see if the EAGAIN failure case can 
trip it up.

		-ben

> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/aio.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 08159ed..6efb7f6 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -367,8 +367,10 @@ static int aio_setup_ring(struct kioctx *ctx)
>  	if (nr_pages > AIO_RING_PAGES) {
>  		ctx->ring_pages = kcalloc(nr_pages, sizeof(struct page *),
>  					  GFP_KERNEL);
> -		if (!ctx->ring_pages)
> +		if (!ctx->ring_pages) {
> +			put_aio_ring_file(ctx);
>  			return -ENOMEM;
> +		}
>  	}
>  
>  	ctx->mmap_size = nr_pages * PAGE_SIZE;
> @@ -645,7 +647,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
>  	    aio_nr + nr_events < aio_nr) {
>  		spin_unlock(&aio_nr_lock);
>  		err = -EAGAIN;
> -		goto err;
> +		goto err_ctx;
>  	}
>  	aio_nr += ctx->max_reqs;
>  	spin_unlock(&aio_nr_lock);
> @@ -662,6 +664,8 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
>  
>  err_cleanup:
>  	aio_nr_sub(ctx->max_reqs);
> +err_ctx:
> +	aio_free_ring(ctx);
>  err:
>  	free_percpu(ctx->cpu);
>  	free_percpu(ctx->reqs.pcpu_count);
> -- 
> 1.7.7
> 

-- 
"Thought is the essence of where you are now."
