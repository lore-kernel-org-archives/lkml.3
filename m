Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaAWQOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:14:54 -0500
Received: from kanga.kvack.org ([205.233.56.17]:59143 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaAWQOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:14:53 -0500
Date: Thu, 23 Jan 2014 11:14:52 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH] aio: fix request cancelling
Message-ID: <20140123161452.GA688@kvack.org>
References: <1390472703-11228-1-git-send-email-r.baldyga@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390472703-11228-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert,

Adding Kent to the Cc list as well.

On Thu, Jan 23, 2014 at 11:25:03AM +0100, Robert Baldyga wrote:
> This this patch fix kiocb_cancel() function.
> If cancel() function ends successfully:
> - kiocb request is removed from ctx->active_reqs,
> - new event is added to ring buffer (this behavior is described in comment
>   in io_cancel function, but was not implemented)
> - kiocb_free function is called
> - percpu_ref_put is called for ctx->reqs refcount
> 
> To do this, part of io_complete function, responsible for adding new event
> to ring buffer, was moved into new function named add_event().

> This patch solves problem related with lack of possibility to call
> aio_complete() from cancel callback. It was because it needs to lock
> ctx->ctx_lock which is always locked before kiocb_cancel() call. So there
> was no way to complete request properly. Now, after cancel() function call,
> request and related resources are freed, and event is added to ring buffer,
> so there is no need to call aio_complete() in cancel callback function.

Your concern is valid, but your fix has a few problems.  First off, 
you're changing the meaning of a 0 return value from the cancel method.  
A 0 return means that cancel has been initiated and at some bounded point 
in the future, a call to aio_complete() will be made.  Changing that to 
mean that the kiocb has been canceled and will never be touched again is 
a big change.  Cancellation sematics were changed in part by Kent to 
improve performance by eliminating reference counts where they were not 
needed.

Additionally, from a performance point of view, adding another bounce of 
ctx_lock in the aio_complete() code path is a non-starter.  Much simpler 
would be to drop ctx_lock when calling into the cancel method, but changing 
this would need rethinking kiocb lifetime issues now that Kent's changes 
have removed the reference count from the kiocb.

Consider this version of the patch Nacked.  We'll have to come up with a 
better way of dealing with this issue.

		-ben

> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  fs/aio.c |   77 ++++++++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 47 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 062a5f6..ea275fa 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -471,8 +471,12 @@ void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
>  }
>  EXPORT_SYMBOL(kiocb_set_cancel_fn);
>  
> +void add_event(struct kiocb *iocb, long res, long res2);
> +static void kiocb_free(struct kiocb *req);
> +
>  static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
>  {
> +	int ret;
>  	kiocb_cancel_fn *old, *cancel;
>  
>  	/*
> @@ -488,8 +492,15 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
>  		old = cancel;
>  		cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
>  	} while (cancel != old);
> -
> -	return cancel(kiocb);
> +	
> +	ret = cancel(kiocb);
> +	if (!ret) {
> +		list_del_init(&kiocb->ki_list);
> +		add_event(kiocb, -EIDRM, -EIDRM);
> +		kiocb_free(kiocb);
> +		percpu_ref_put(&ctx->reqs);
> +	}
> +	return ret;
>  }
>  
>  static void free_ioctx(struct work_struct *work)
> @@ -906,40 +917,13 @@ out:
>  	return ret;
>  }
>  
> -/* aio_complete
> - *	Called when the io request on the given iocb is complete.
> - */
> -void aio_complete(struct kiocb *iocb, long res, long res2)
> +void add_event(struct kiocb *iocb, long res, long res2)
>  {
>  	struct kioctx	*ctx = iocb->ki_ctx;
>  	struct aio_ring	*ring;
>  	struct io_event	*ev_page, *event;
>  	unsigned long	flags;
>  	unsigned tail, pos;
> -
> -	/*
> -	 * Special case handling for sync iocbs:
> -	 *  - events go directly into the iocb for fast handling
> -	 *  - the sync task with the iocb in its stack holds the single iocb
> -	 *    ref, no other paths have a way to get another ref
> -	 *  - the sync task helpfully left a reference to itself in the iocb
> -	 */
> -	if (is_sync_kiocb(iocb)) {
> -		iocb->ki_user_data = res;
> -		smp_wmb();
> -		iocb->ki_ctx = ERR_PTR(-EXDEV);
> -		wake_up_process(iocb->ki_obj.tsk);
> -		return;
> -	}
> -
> -	if (iocb->ki_list.next) {
> -		unsigned long flags;
> -
> -		spin_lock_irqsave(&ctx->ctx_lock, flags);
> -		list_del(&iocb->ki_list);
> -		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
> -	}
> -
>  	/*
>  	 * Add a completion event to the ring buffer. Must be done holding
>  	 * ctx->completion_lock to prevent other code from messing with the tail
> @@ -983,6 +967,39 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
>  	spin_unlock_irqrestore(&ctx->completion_lock, flags);
>  
>  	pr_debug("added to ring %p at [%u]\n", iocb, tail);
> +}
> +
> +/* aio_complete
> + *	Called when the io request on the given iocb is complete.
> + */
> +void aio_complete(struct kiocb *iocb, long res, long res2)
> +{
> +	struct kioctx	*ctx = iocb->ki_ctx;
> +
> +	/*
> +	 * Special case handling for sync iocbs:
> +	 *  - events go directly into the iocb for fast handling
> +	 *  - the sync task with the iocb in its stack holds the single iocb
> +	 *    ref, no other paths have a way to get another ref
> +	 *  - the sync task helpfully left a reference to itself in the iocb
> +	 */
> +	if (is_sync_kiocb(iocb)) {
> +		iocb->ki_user_data = res;
> +		smp_wmb();
> +		iocb->ki_ctx = ERR_PTR(-EXDEV);
> +		wake_up_process(iocb->ki_obj.tsk);
> +		return;
> +	}
> +
> +	if (iocb->ki_list.next) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&ctx->ctx_lock, flags);
> +		list_del(&iocb->ki_list);
> +		spin_unlock_irqrestore(&ctx->ctx_lock, flags);
> +	}
> +
> +	add_event(iocb, res, res2);
>  
>  	/*
>  	 * Check if the user asked us to deliver the result through an
> -- 
> 1.7.9.5

-- 
"Thought is the essence of where you are now."
