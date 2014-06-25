Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbaFYObO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:31:14 -0400
Received: from kanga.kvack.org ([205.233.56.17]:44367 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbaFYObM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:31:12 -0400
Date: Wed, 25 Jun 2014 10:31:12 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux-foundation.org, kmo@daterainc.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] percpu-refcount, aio: use percpu_ref_cancel_init() in ioctx_alloc()
Message-ID: <20140625143112.GR23137@kvack.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org> <1403053685-28240-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403053685-28240-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 09:08:00PM -0400, Tejun Heo wrote:
> ioctx_alloc() reaches inside percpu_ref and directly frees
> ->pcpu_count in its failure path, which is quite gross.  percpu_ref
> has been providing a proper interface to do this,
> percpu_ref_cancel_init(), for quite some time now.  Let's use that
> instead.

I applied this to my aio-next tree at git://git.kvack.org/~bcrl/aio-next.git .

		-ben

> This patch doesn't introduce any behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> Cc: Kent Overstreet <kmo@daterainc.com>
> ---
>  fs/aio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 4f078c0..5e0d7f9 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -715,8 +715,8 @@ err_ctx:
>  err:
>  	mutex_unlock(&ctx->ring_lock);
>  	free_percpu(ctx->cpu);
> -	free_percpu(ctx->reqs.pcpu_count);
> -	free_percpu(ctx->users.pcpu_count);
> +	percpu_ref_cancel_init(&ctx->reqs);
> +	percpu_ref_cancel_init(&ctx->users);
>  	kmem_cache_free(kioctx_cachep, ctx);
>  	pr_debug("error allocating ioctx %d\n", err);
>  	return ERR_PTR(err);
> -- 
> 1.9.3

-- 
"Thought is the essence of where you are now."
