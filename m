Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653Ab3B1Vk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:40:59 -0500
Received: from kanga.kvack.org ([205.233.56.17]:33980 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418Ab3B1Vk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:40:57 -0500
Date: Thu, 28 Feb 2013 16:40:56 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, tytso@mit.edu, axboe@kernel.dk, zab@redhat.com,
        anatol@google.com
Subject: Re: [PATCH 1/4] aio: io_cancel() no longer returns the io_event
Message-ID: <20130228214056.GA25505@kvack.org>
References: <1362083741-2429-1-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362083741-2429-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 12:35:38PM -0800, Kent Overstreet wrote:
> Originally, io_event() was documented to return the io_event if
> cancellation succeeded - the io_event wouldn't be delivered via the ring
> buffer like it normally would.
> 
> But this isn't what the implementation was actually doing; the only
> driver implementing cancellation, the usb gadget code, never returned an
> io_event in its cancel function. And aio_complete() was recently changed
> to no longer suppress event delivery if the kiocb had been cancelled.
> 
> This gets rid of the unused io_event argument to kiocb_cancel() and
> kiocb->ki_cancel(), and changes io_cancel() to return -EINPROGRESS if
> kiocb->ki_cancel() returned success.

...

> diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
> index b540a1d..fd1bf4a 100644
> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c
> @@ -524,7 +524,7 @@ struct kiocb_priv {
>  	unsigned		actual;
>  };
>  
> -static int ep_aio_cancel(struct kiocb *iocb, struct io_event *e)
> +static void ep_aio_cancel(struct kiocb *iocb)
>  {
>  	struct kiocb_priv	*priv = iocb->private;
>  	struct ep_data		*epdata;
> @@ -540,7 +540,6 @@ static int ep_aio_cancel(struct kiocb *iocb, struct io_event *e)
>  	// spin_unlock(&epdata->dev->lock);
>  	local_irq_enable();
>  
> -	aio_put_req(iocb);
>  	return value;
>  }
>  

You seem to have removed the return value from ki_cancel in the gadget code, 
so this won't compile.  I think this is wrong and an unnecessary restriction 
As such, I'm NAKing this patch.  Please leave the return value from the 
ki_cancel function present so we can know if the cancel actually succeeded.

		-ben


> diff --git a/fs/aio.c b/fs/aio.c
> index a86ffd0..4b9bfb5 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -256,8 +256,7 @@ void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
>  }
>  EXPORT_SYMBOL(kiocb_set_cancel_fn);
>  
> -static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
> -			struct io_event *res)
> +static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
>  {
>  	kiocb_cancel_fn *old, *cancel;
>  	int ret = -EINVAL;
> @@ -279,12 +278,10 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
>  	atomic_inc(&kiocb->ki_users);
>  	spin_unlock_irq(&ctx->ctx_lock);
>  
> -	memset(res, 0, sizeof(*res));
> -	res->obj = (u64)(unsigned long)kiocb->ki_obj.user;
> -	res->data = kiocb->ki_user_data;
> -	ret = cancel(kiocb, res);
> +	ret = cancel(kiocb);
>  
>  	spin_lock_irq(&ctx->ctx_lock);
> +	aio_put_req(kiocb);
>  
>  	return ret;
>  }
> @@ -305,7 +302,6 @@ static void free_ioctx_rcu(struct rcu_head *head)
>  static void free_ioctx(struct kioctx *ctx)
>  {
>  	struct aio_ring *ring;
> -	struct io_event res;
>  	struct kiocb *req;
>  	unsigned cpu, head, avail;
>  
> @@ -316,7 +312,7 @@ static void free_ioctx(struct kioctx *ctx)
>  				       struct kiocb, ki_list);
>  
>  		list_del_init(&req->ki_list);
> -		kiocb_cancel(ctx, req, &res);
> +		kiocb_cancel(ctx, req);
>  	}
>  
>  	spin_unlock_irq(&ctx->ctx_lock);
> @@ -1351,7 +1347,6 @@ static struct kiocb *lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb,
>  SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
>  		struct io_event __user *, result)
>  {
> -	struct io_event res;
>  	struct kioctx *ctx;
>  	struct kiocb *kiocb;
>  	u32 key;
> @@ -1369,18 +1364,19 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
>  
>  	kiocb = lookup_kiocb(ctx, iocb, key);
>  	if (kiocb)
> -		ret = kiocb_cancel(ctx, kiocb, &res);
> +		ret = kiocb_cancel(ctx, kiocb);
>  	else
>  		ret = -EINVAL;
>  
>  	spin_unlock_irq(&ctx->ctx_lock);
>  
>  	if (!ret) {
> -		/* Cancellation succeeded -- copy the result
> -		 * into the user's buffer.
> +		/*
> +		 * The result argument is no longer used - the io_event is
> +		 * always delivered via the ring buffer. -EINPROGRESS indicates
> +		 * cancellation is progress:
>  		 */
> -		if (copy_to_user(result, &res, sizeof(res)))
> -			ret = -EFAULT;
> +		ret = -EINPROGRESS;
>  	}
>  
>  	put_ioctx(ctx);
> diff --git a/include/linux/aio.h b/include/linux/aio.h
> index 93892bf..7340f77 100644
> --- a/include/linux/aio.h
> +++ b/include/linux/aio.h
> @@ -28,7 +28,7 @@ struct batch_complete;
>   */
>  #define KIOCB_CANCELLED		((void *) (~0ULL))
>  
> -typedef int (kiocb_cancel_fn)(struct kiocb *, struct io_event *);
> +typedef int (kiocb_cancel_fn)(struct kiocb *);
>  
>  struct kiocb {
>  	struct rb_node		ki_node;
> -- 
> 1.7.12

-- 
"Thought is the essence of where you are now."
