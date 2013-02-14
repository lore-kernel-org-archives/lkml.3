Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471Ab3BNBlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:41:19 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:53829 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab3BNBlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:41:18 -0500
Date: Wed, 13 Feb 2013 17:40:39 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aio: only suppress events from cancelled kiocbs if
 free_ioctx() is in progress
Message-ID: <20130214014039.GO12631@moria.home.lan>
References: <20130213215214.GA24582@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213215214.GA24582@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 04:52:14PM -0500, Benjamin LaHaise wrote:
> The io_cancel() syscall allows for cancellation of iocbs in flight to
> generate a completion event.  The current behaviour of batch_complete_aio()
> is to suppress all completion events.  Some types of asynchronous operations
> cannot be cancelled synchronously, and must generate a completion event at
> some point after the io_cancel() syscall.  Instead, only suppress
> completion events during kioctx teardown by free_ioctx().
> 
> Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
> ---
>  fs/aio.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 46f9dd0..1bcb818 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -81,6 +81,7 @@ struct kioctx {
>  
>  	/* sys_io_setup currently limits this to an unsigned int */
>  	unsigned		max_reqs;
> +	unsigned		dead;

Can use percpu_ref_dead() for this - it returns true after
percpu_ref_kill() has been called (it's what I converted the old
ctx->dead uses to).

>  
>  	unsigned long		mmap_base;
>  	unsigned long		mmap_size;
> @@ -311,6 +312,7 @@ static void free_ioctx(struct kioctx *ctx)
>  	struct kiocb *req;
>  	unsigned cpu, head, avail;
>  
> +	ctx->dead = 1;
>  	spin_lock_irq(&ctx->ctx_lock);
>  
>  	while (!list_empty(&ctx->active_reqs)) {
> @@ -749,7 +751,9 @@ void batch_complete_aio(struct batch_complete *batch)
>  			n = rb_parent(n);
>  		}
>  
> -		if (unlikely(xchg(&req->ki_cancel,
> +		/* Suppress cancelled events if free_ioctx() is in progress. */
> +		if (unlikely(req->ki_ctx->dead &&
> +			     xchg(&req->ki_cancel,
>  				  KIOCB_CANCELLED) == KIOCB_CANCELLED)) {

I'm not seeing why we need to supress events during teardown - if we
just let it be delivered to the ringbuffer like normal, the free_ioctx()
code will find it there.

I think the event supressing code can be deleted entirely.
