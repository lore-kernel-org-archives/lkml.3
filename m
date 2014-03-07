Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaCGKuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:50:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59893 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbaCGKus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:50:48 -0500
X-IronPort-AV: E=Sophos;i="4.97,607,1389715200"; 
   d="scan'208";a="9660330"
Message-ID: <5319A279.7010901@cn.fujitsu.com>
Date: Fri, 07 Mar 2014 18:42:01 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin <bcrl@kvack.org>
CC: Kent <kmo@daterainc.com>, Jens <axboe@kernel.dk>, linux-aio@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] aio: make aio_read_events_ring be aware of aio_complete
References: <53106486.1090300@cn.fujitsu.com>
In-Reply-To: <53106486.1090300@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:48:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:48:07,
	Serialize complete at 2014/03/07 18:48:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping...

On 02/28/2014 06:27 PM, Gu Zheng wrote:

> Commit 5ffac122dbda8(aio: Don't use ctx->tail unnecessarily) uses
> ring->tail rather than the ctx->tail, but with this change, we fetch 'tail'
> only once at the start, so that we can not be aware of adding event by aio_complete
> when reading events. It seems a regression.
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


