Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455Ab3BNBdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:33:47 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47059 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3BNBdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:33:45 -0500
Date: Wed, 13 Feb 2013 17:33:11 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] aio: correct calculation of available events
Message-ID: <20130214013311.GM12631@moria.home.lan>
References: <20130213174551.GA19958@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213174551.GA19958@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 12:45:52PM -0500, Benjamin LaHaise wrote:
> When the number of available events in the ring buffer is calculated,
> the avail calculation is incorrect when head == tail.  This is harmless
> in aio_read_events_ring(), but in free_ioctx() leads to the subsequent
> WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr).  Correct this.
> 
> Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
> ---
>  fs/aio.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 24ba228..dc52b0c 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -337,7 +337,8 @@ static void free_ioctx(struct kioctx *ctx)
>  	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
>  		wait_event(ctx->wait, head != ctx->shadow_tail);
>  
> -		avail = (head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - head;
> +		avail = (head <= ctx->shadow_tail ?
> +			 ctx->shadow_tail : ctx->nr) - head;
>  
>  		atomic_add(avail, &ctx->reqs_available);
>  		head += avail;
> @@ -884,7 +885,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
>  		goto out;
>  
>  	while (ret < nr) {
> -		long avail = (head < ctx->shadow_tail
> +		long avail = (head <= ctx->shadow_tail
>  			      ? ctx->shadow_tail : ctx->nr) - head;
>  		struct io_event *ev;
>  		struct page *page;
> -- 
> 1.7.4.1
> 
> 
> -- 
> "Thought is the essence of where you are now."

Whoops!

Reviewed-by: Kent Overstreet <koverstreet@google.com>
