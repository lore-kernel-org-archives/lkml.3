Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaB1Uuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:50:39 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55433 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaB1Uui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:50:38 -0500
Date: Fri, 28 Feb 2014 12:52:43 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Benjamin <bcrl@kvack.org>, Jens <axboe@kernel.dk>, linux-aio@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] aio: make aio_read_events_ring be aware of
 aio_complete
Message-ID: <20140228205243.GA7325@kmo-pixel>
References: <53106486.1090300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53106486.1090300@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 06:27:18PM +0800, Gu Zheng wrote:
> Commit 5ffac122dbda8(aio: Don't use ctx->tail unnecessarily) uses
> ring->tail rather than the ctx->tail, but with this change, we fetch 'tail'
> only once at the start, so that we can not be aware of adding event by aio_complete
> when reading events. It seems a regression.

"Seems a regression" is not good enough. What breaks?

> So here we fetch the ring->tail in start of the loop each time to make it be
> aware of adding event from aio_complete.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/aio.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 7eaa631..f5b8551 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1029,10 +1029,14 @@ static long aio_read_events_ring(struct kioctx *ctx,
>  		struct io_event *ev;
>  		struct page *page;
>  
> -		avail = (head <= tail ?  tail : ctx->nr_events) - head;
> +		ring = kmap_atomic(ctx->ring_pages[0]);
> +		tail = ring->tail;
> +		kunmap_atomic(ring);
> +
>  		if (head == tail)
>  			break;
>  
> +		avail = (head <= tail ?  tail : ctx->nr_events) - head;
>  		avail = min(avail, nr - ret);
>  		avail = min_t(long, avail, AIO_EVENTS_PER_PAGE -
>  			    ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
> -- 
> 1.7.7
> 
