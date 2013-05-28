Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187Ab3E1XK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:10:26 -0400
Received: from kanga.kvack.org ([205.233.56.17]:55900 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201Ab3E1XKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:10:25 -0400
Date: Tue, 28 May 2013 19:10:24 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] aio: Use call_rcu() instead of synchronize_rcu() in kill_ioctx()
Message-ID: <20130528231024.GA24189@kvack.org>
References: <1369776378-27921-1-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369776378-27921-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 02:26:18PM -0700, Kent Overstreet wrote:
> Just making ioctx shutdown asynchronous so as not to block io_destroy()
> - and percpu refcounts for the ioctx are going to need a RCU barrier in
> the same place anyways.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Tested-by: Benjamin LaHaise <bcrl@kvack.org>

I have reviewed and tested this, and it fixes the io_setup() returning 
EAGAIN error from the first version of this patch.  Thanks Kent!

		-ben

> Cc: Zach Brown <zab@redhat.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Asai Thambi S P <asamymuthupa@micron.com>
> Cc: Selvan Mani <smani@micron.com>
> Cc: Sam Bradshaw <sbradshaw@micron.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> ---
>  fs/aio.c | 36 ++++++++++++++++--------------------
>  1 file changed, 16 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 7fe5bde..2bbcacf 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -141,9 +141,6 @@ static void aio_free_ring(struct kioctx *ctx)
>  	for (i = 0; i < ctx->nr_pages; i++)
>  		put_page(ctx->ring_pages[i]);
>  
> -	if (ctx->mmap_size)
> -		vm_munmap(ctx->mmap_base, ctx->mmap_size);
> -
>  	if (ctx->ring_pages && ctx->ring_pages != ctx->internal_pages)
>  		kfree(ctx->ring_pages);
>  }
> @@ -322,11 +319,6 @@ static void free_ioctx(struct kioctx *ctx)
>  
>  	aio_free_ring(ctx);
>  
> -	spin_lock(&aio_nr_lock);
> -	BUG_ON(aio_nr - ctx->max_reqs > aio_nr);
> -	aio_nr -= ctx->max_reqs;
> -	spin_unlock(&aio_nr_lock);
> -
>  	pr_debug("freeing %p\n", ctx);
>  
>  	/*
> @@ -435,17 +427,24 @@ static void kill_ioctx(struct kioctx *ctx)
>  {
>  	if (!atomic_xchg(&ctx->dead, 1)) {
>  		hlist_del_rcu(&ctx->list);
> -		/* Between hlist_del_rcu() and dropping the initial ref */
> -		synchronize_rcu();
>  
>  		/*
> -		 * We can't punt to workqueue here because put_ioctx() ->
> -		 * free_ioctx() will unmap the ringbuffer, and that has to be
> -		 * done in the original process's context. kill_ioctx_rcu/work()
> -		 * exist for exit_aio(), as in that path free_ioctx() won't do
> -		 * the unmap.
> +		 * It'd be more correct to do this in free_ioctx(), after all
> +		 * the outstanding kiocbs have finished - but by then io_destroy
> +		 * has already returned, so io_setup() could potentially return
> +		 * -EAGAIN with no ioctxs actually in use (as far as userspace
> +		 *  could tell).
>  		 */
> -		kill_ioctx_work(&ctx->rcu_work);
> +		spin_lock(&aio_nr_lock);
> +		BUG_ON(aio_nr - ctx->max_reqs > aio_nr);
> +		aio_nr -= ctx->max_reqs;
> +		spin_unlock(&aio_nr_lock);
> +
> +		if (ctx->mmap_size)
> +			vm_munmap(ctx->mmap_base, ctx->mmap_size);
> +
> +		/* Between hlist_del_rcu() and dropping the initial ref */
> +		call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
>  	}
>  }
>  
> @@ -495,10 +494,7 @@ void exit_aio(struct mm_struct *mm)
>  		 */
>  		ctx->mmap_size = 0;
>  
> -		if (!atomic_xchg(&ctx->dead, 1)) {
> -			hlist_del_rcu(&ctx->list);
> -			call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
> -		}
> +		kill_ioctx(ctx);
>  	}
>  }
>  
> -- 
> 1.8.2.1

-- 
"Thought is the essence of where you are now."
