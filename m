Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaKFTlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:41:22 -0500
Received: from kanga.kvack.org ([205.233.56.17]:34491 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbaKFTlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:41:19 -0500
Date: Thu, 6 Nov 2014 14:41:19 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, lersek@redhat.com
Subject: Re: [PATCH] aio: Skip timer for io_getevents if timeout=0
Message-ID: <20141106194119.GD25610@kvack.org>
References: <1415277876-7060-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415277876-7060-1-git-send-email-famz@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fam,

On Thu, Nov 06, 2014 at 08:44:36PM +0800, Fam Zheng wrote:
> In this case, it is basically a polling. Let's not involve timer at all
> because that would hurt performance for application event loops.
> 
> In an arbitrary test I've done, io_getevents syscall elapsed time
> reduces from 50000+ nanoseconds to a few hundereds.

This looks quite reasonable.  I've applied this to my aio-next tree.

		-ben

> Signed-off-by: Fam Zheng <famz@redhat.com>
> ---
>  fs/aio.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 84a7510..7c0b561 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1221,8 +1221,12 @@ static long read_events(struct kioctx *ctx, long min_nr, long nr,
>  	 * the ringbuffer empty. So in practice we should be ok, but it's
>  	 * something to be aware of when touching this code.
>  	 */
> -	wait_event_interruptible_hrtimeout(ctx->wait,
> -			aio_read_events(ctx, min_nr, nr, event, &ret), until);
> +	if (until.tv64 == 0)
> +		aio_read_events(ctx, min_nr, nr, event, &ret);
> +	else
> +		wait_event_interruptible_hrtimeout(ctx->wait,
> +				aio_read_events(ctx, min_nr, nr, event, &ret),
> +				until);
>  
>  	if (!ret && signal_pending(current))
>  		ret = -EINTR;
> -- 
> 1.9.3

-- 
"Thought is the essence of where you are now."
