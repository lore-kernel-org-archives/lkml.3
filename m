Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbaE2LHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:07:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183AbaE2LHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:07:05 -0400
Date: Thu, 29 May 2014 13:07:23 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/4] virtio_net: pass well-formed sg to
 virtqueue_add_inbuf()
Message-ID: <20140529100723.GA30210@redhat.com>
References: <87oayh6s3s.fsf@rustcorp.com.au>
 <1401348405-18614-1-git-send-email-rusty@rustcorp.com.au>
 <1401348405-18614-3-git-send-email-rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401348405-18614-3-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 04:56:43PM +0930, Rusty Russell wrote:
> This is the only place which doesn't hand virtqueue_add_inbuf or
> virtqueue_add_outbuf a well-formed, well-terminated sg.  Fix it,
> so we can make virtio_add_* simpler.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/net/virtio_net.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8a852b5f215f..63299b04cdf2 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -590,6 +590,8 @@ static int add_recvbuf_big(struct receive_queue *rq, gfp_t gfp)
>  	offset = sizeof(struct padded_vnet_hdr);
>  	sg_set_buf(&rq->sg[1], p + offset, PAGE_SIZE - offset);
>  
> +	sg_mark_end(&rq->sg[MAX_SKB_FRAGS + 2 - 1]);
> +
>  	/* chain first in list head */
>  	first->private = (unsigned long)list;
>  	err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,

Not that performance of add_recvbuf_big actually mattered anymore, but
in fact this can be done in virtnet_probe if we like.


Anyway

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> -- 
> 1.9.1
