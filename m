Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753Ab3B1Vxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:53:40 -0500
Received: from kanga.kvack.org ([205.233.56.17]:34038 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab3B1Vxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:53:35 -0500
Date: Thu, 28 Feb 2013 16:53:34 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, tytso@mit.edu, axboe@kernel.dk, zab@redhat.com,
        anatol@google.com
Subject: Re: [PATCH 2/4] aio: Allow cancellation without a cancel callback
Message-ID: <20130228215334.GB25505@kvack.org>
References: <1362083741-2429-1-git-send-email-koverstreet@google.com> <1362083741-2429-2-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362083741-2429-2-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 12:35:39PM -0800, Kent Overstreet wrote:
> Prep work for bio cancellation. At least initially, we don't want to
> implement a callback that has to chase down all the state (multiple
> bios/requests) associated with the iocb; a simple flag will suffice.

I don't this you want to force mandatory addition to the cancel list.  This 
essentially regresses part of the optimization work you put into place with 
percpu reference counts and the rest of the cleanups you put into place for 
the aio core and direct i/o.  I think we should find a better way of doing 
this to keep your performance optimizations in as good a state as possible.

This patch also makes cancellation falsely return succees for kiocbs that do 
not have any actual support for cancellation.  I think this is incorrect, 
and have to NAK this part of the patch as a result.

		-ben
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> ---
>  drivers/usb/gadget/inode.c |  7 +----
>  fs/aio.c                   | 76 +++++++++++++++++++++-------------------------
>  include/linux/aio.h        |  5 +++
>  3 files changed, 41 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
> index fd1bf4a..e5e2210 100644
> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c
> @@ -528,19 +528,14 @@ static void ep_aio_cancel(struct kiocb *iocb)
>  {
>  	struct kiocb_priv	*priv = iocb->private;
>  	struct ep_data		*epdata;
> -	int			value;
>  
>  	local_irq_disable();
>  	epdata = priv->epdata;
>  	// spin_lock(&epdata->dev->lock);
>  	if (likely(epdata && epdata->ep && priv->req))
> -		value = usb_ep_dequeue (epdata->ep, priv->req);
> -	else
> -		value = -EINVAL;
> +		usb_ep_dequeue (epdata->ep, priv->req);
>  	// spin_unlock(&epdata->dev->lock);
>  	local_irq_enable();
> -
> -	return value;
>  }
>  
>  static ssize_t ep_copy_to_user(struct kiocb_priv *priv)
> diff --git a/fs/aio.c b/fs/aio.c
> index 4b9bfb5..f5f27bd 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -242,48 +242,34 @@ static int aio_setup_ring(struct kioctx *ctx)
>  
>  void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
>  {
> -	struct kioctx *ctx = req->ki_ctx;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&ctx->ctx_lock, flags);
> +	kiocb_cancel_fn *p, *old = req->ki_cancel;
>  
> -	if (!req->ki_list.next)
> -		list_add(&req->ki_list, &ctx->active_reqs);
> -
> -	req->ki_cancel = cancel;
> +	do {
> +		if (old == KIOCB_CANCELLED) {
> +			cancel(req);
> +			return;
> +		}
>  
> -	spin_unlock_irqrestore(&ctx->ctx_lock, flags);
> +		p = old;
> +		old = cmpxchg(&req->ki_cancel, old, cancel);
> +	} while (old != p);
>  }
>  EXPORT_SYMBOL(kiocb_set_cancel_fn);
>  
> -static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
> +static void kiocb_cancel(struct kioctx *ctx, struct kiocb *req)
>  {
> -	kiocb_cancel_fn *old, *cancel;
> -	int ret = -EINVAL;
> -
> -	/*
> -	 * Don't want to set kiocb->ki_cancel = KIOCB_CANCELLED unless it
> -	 * actually has a cancel function, hence the cmpxchg()
> -	 */
> -
> -	cancel = ACCESS_ONCE(kiocb->ki_cancel);
> -	do {
> -		if (!cancel || cancel == KIOCB_CANCELLED)
> -			return ret;
> -
> -		old = cancel;
> -		cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
> -	} while (cancel != old);
> -
> -	atomic_inc(&kiocb->ki_users);
> -	spin_unlock_irq(&ctx->ctx_lock);
> +	kiocb_cancel_fn *cancel;
>  
> -	ret = cancel(kiocb);
> +	cancel = xchg(&req->ki_cancel, KIOCB_CANCELLED);
> +	if (cancel && cancel != KIOCB_CANCELLED) {
> +		atomic_inc(&req->ki_users);
> +		spin_unlock_irq(&ctx->ctx_lock);
>  
> -	spin_lock_irq(&ctx->ctx_lock);
> -	aio_put_req(kiocb);
> +		cancel(req);
>  
> -	return ret;
> +		spin_lock_irq(&ctx->ctx_lock);
> +		aio_put_req(req);
> +	}
>  }
>  
>  static void free_ioctx_rcu(struct rcu_head *head)
> @@ -1126,6 +1112,10 @@ rw_common:
>  
>  		req->ki_nbytes = ret;
>  
> +		spin_lock_irq(&req->ki_ctx->ctx_lock);
> +		list_add(&req->ki_list, &req->ki_ctx->active_reqs);
> +		spin_unlock_irq(&req->ki_ctx->ctx_lock);
> +
>  		/* XXX: move/kill - rw_verify_area()? */
>  		/* This matches the pread()/pwrite() logic */
>  		if (req->ki_pos < 0) {
> @@ -1141,6 +1131,10 @@ rw_common:
>  		if (!file->f_op->aio_fsync)
>  			return -EINVAL;
>  
> +		spin_lock_irq(&req->ki_ctx->ctx_lock);
> +		list_add(&req->ki_list, &req->ki_ctx->active_reqs);
> +		spin_unlock_irq(&req->ki_ctx->ctx_lock);
> +
>  		ret = file->f_op->aio_fsync(req, 1);
>  		break;
>  
> @@ -1148,6 +1142,10 @@ rw_common:
>  		if (!file->f_op->aio_fsync)
>  			return -EINVAL;
>  
> +		spin_lock_irq(&req->ki_ctx->ctx_lock);
> +		list_add(&req->ki_list, &req->ki_ctx->active_reqs);
> +		spin_unlock_irq(&req->ki_ctx->ctx_lock);
> +
>  		ret = file->f_op->aio_fsync(req, 0);
>  		break;
>  
> @@ -1363,14 +1361,8 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
>  	spin_lock_irq(&ctx->ctx_lock);
>  
>  	kiocb = lookup_kiocb(ctx, iocb, key);
> -	if (kiocb)
> -		ret = kiocb_cancel(ctx, kiocb);
> -	else
> -		ret = -EINVAL;
> -
> -	spin_unlock_irq(&ctx->ctx_lock);
> -
> -	if (!ret) {
> +	if (kiocb) {
> +		kiocb_cancel(ctx, kiocb);
>  		/*
>  		 * The result argument is no longer used - the io_event is
>  		 * always delivered via the ring buffer. -EINPROGRESS indicates
> @@ -1379,6 +1371,8 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
>  		ret = -EINPROGRESS;
>  	}
>  
> +	spin_unlock_irq(&ctx->ctx_lock);
> +
>  	put_ioctx(ctx);
>  
>  	return ret;
> diff --git a/include/linux/aio.h b/include/linux/aio.h
> index 7340f77..d9686f1 100644
> --- a/include/linux/aio.h
> +++ b/include/linux/aio.h
> @@ -65,6 +65,11 @@ struct kiocb {
>  	struct eventfd_ctx	*ki_eventfd;
>  };
>  
> +static inline bool kiocb_cancelled(struct kiocb *kiocb)
> +{
> +	return kiocb->ki_cancel == KIOCB_CANCELLED;
> +}
> +
>  static inline bool is_sync_kiocb(struct kiocb *kiocb)
>  {
>  	return kiocb->ki_ctx == NULL;
> -- 
> 1.7.12

-- 
"Thought is the essence of where you are now."
