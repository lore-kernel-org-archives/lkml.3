Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaIYTwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:52:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaIYTwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:52:19 -0400
Date: Thu, 25 Sep 2014 15:52:10 -0400
From: Rafael Aquini <aquini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, jstancek@redhat.com, jburke@redhat.com,
        jsnitsel@redhat.com, jbenc@redhat.com, davem@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] dma: iovlock: avoid dma_pin_iovec_pages() causing page
 allocator warns on order >= MAX_ORDER
Message-ID: <20140925195209.GA12006@t510.redhat.com>
References: <d5a910e218633b0ea66ae9caa696bf6cf2d08d78.1410286742.git.aquini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5a910e218633b0ea66ae9caa696bf6cf2d08d78.1410286742.git.aquini@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 02:22:38PM -0400, Rafael Aquini wrote:
> dma_pin_iovec_pages() eventually causes the page allocator to stumble across
> it warning case when a request for contigous mem block gets order >= MAX_ORDER.
> 
>    trinity(11230): Randomness reseeded to 0xaf76756f
>    trinity: trinity(11230) Randomness reseeded to 0xaf76756f
>    [ 7442.617160] ------------[ cut here ]------------
>    [ 7442.621890] WARNING: at mm/page_alloc.c:2410 __alloc_pages_nodemask+0x346/0xa00()
>    ...
>    [ 7442.797088] Call Trace:
>    [ 7442.799614]  [<ffffffff81600bf7>] dump_stack+0x19/0x1b
>    [ 7442.804860]  [<ffffffff8105f621>] warn_slowpath_common+0x61/0x80
>    [ 7442.810944]  [<ffffffff8105f6fa>] warn_slowpath_null+0x1a/0x20
>    [ 7442.816858]  [<ffffffff8113d016>] __alloc_pages_nodemask+0x346/0xa00
>    [ 7442.823294]  [<ffffffff81175f59>] alloc_pages_current+0xa9/0x170
>    [ 7442.829364]  [<ffffffff811384be>] __get_free_pages+0xe/0x50
>    [ 7442.835009]  [<ffffffff8118064e>] kmalloc_order_trace+0x2e/0xa0
>    [ 7442.841005]  [<ffffffff81182899>] __kmalloc+0x219/0x230
>    [ 7442.846284]  [<ffffffff81387c8b>] dma_pin_iovec_pages+0x9b/0x240
>    [ 7442.852323]  [<ffffffff8153ffb8>] tcp_recvmsg+0x888/0xd10
>    ...
> 
> dma_pin_iovec_pages() is actually being used for an unique callsite within
> tcp_recvmsg() which falls back to skb_copy_datagram_iovec() if the first
> routine fails to pin a DMA buffer for the iovec. The splatted calltrace is
> more scary than other thing, so lets just prevent it from getting out to
> the wild world. This patch also does a minor code style surgery on the
> surrounding hunk.
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>
> ---
>  drivers/dma/iovlock.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/iovlock.c b/drivers/dma/iovlock.c
> index bb48a57..4cb8379 100644
> --- a/drivers/dma/iovlock.c
> +++ b/drivers/dma/iovlock.c
> @@ -69,9 +69,10 @@ struct dma_pinned_list *dma_pin_iovec_pages(struct iovec *iov, size_t len)
>  	} while (iovec_len_used < len);
>  
>  	/* single kmalloc for pinned list, page_list[], and the page arrays */
> -	local_list = kmalloc(sizeof(*local_list)
> -		+ (nr_iovecs * sizeof (struct dma_page_list))
> -		+ (iovec_pages_used * sizeof (struct page*)), GFP_KERNEL);
> +	local_list = kmalloc(sizeof(*local_list) +
> +			     (nr_iovecs * sizeof(struct dma_page_list)) +
> +			     (iovec_pages_used * sizeof(struct page *)),
> +			     GFP_KERNEL | __GFP_NOWARN);
>  	if (!local_list)
>  		goto out;
>  
> -- 
> 1.9.3
>

Guys, what's the word here?

Cheers,
-- Rafael
 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
