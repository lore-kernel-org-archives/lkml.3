Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaA0RgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:36:12 -0500
Received: from kanga.kvack.org ([205.233.56.17]:52556 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbaA0RgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:36:11 -0500
Date: Mon, 27 Jan 2014 12:36:08 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: viro@zeniv.linux.org.uk, kmo@daterainc.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com
Subject: Re: [PATCH] aio: fix kiocb_cancel() funcition
Message-ID: <20140127173608.GI19273@kvack.org>
References: <1390812301-4102-1-git-send-email-r.baldyga@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390812301-4102-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert,

On Mon, Jan 27, 2014 at 09:45:01AM +0100, Robert Baldyga wrote:
> This patch solves problem related with lack of possibility to call
> aio_complete() from cancel callback. It was because it needs to lock
> ctx->ctx_lock which is always locked before kiocb_cancel() call. So there
> was no way to complete request properly.
> 
> Now spinlock is unlocked before cancel callback function call, so spinlock
> recursion will not occur in case of aio_complete() call. After cancel function
> call spinlock is locked back.

You can't just do that -- it introduces a possible use-after-free issue with 
the kiocb when cancellation occurs.  Like I said in my previous email: you 
have to deal with object lifetime expecatations in order to do that.  If you 
could post the code that you're trying to fix this bug for, there might be 
other solutions to the problem we can suggest.

		-ben

> There is also __must_hold() macro added for kiocb_cancel() function, to allow
> sparse spin lock checking.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Nack.  Do not apply.

> ---
> 
> This patch was created according to suggestions of Benjamin LaHaise
> (https://lkml.org/lkml/2014/1/23/336).
> 
>  fs/aio.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 062a5f6..6d5cd9e 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -472,8 +472,10 @@ void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
>  EXPORT_SYMBOL(kiocb_set_cancel_fn);
>  
>  static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
> +			__must_hold(&ctx->ctx_lock)
>  {
>  	kiocb_cancel_fn *old, *cancel;
> +	int ret;
>  
>  	/*
>  	 * Don't want to set kiocb->ki_cancel = KIOCB_CANCELLED unless it
> @@ -489,7 +491,15 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
>  		cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
>  	} while (cancel != old);
>  
> -	return cancel(kiocb);
> +	/*
> +	 * cancel() function may call aio_complete function, which needs to
> +	 * lock ctx->ctx_lock, so we call cancel() with spinlock unlocked
> +	 */
> +	spin_unlock(&ctx->ctx_lock);
> +	ret = cancel(kiocb);
> +	spin_lock(&ctx->ctx_lock);
> +
> +	return ret;
>  }
>  
>  static void free_ioctx(struct work_struct *work)
> -- 
> 1.7.9.5

-- 
"Thought is the essence of where you are now."
