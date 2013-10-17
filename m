Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab3JQVMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:12:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab3JQVMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:12:31 -0400
Message-ID: <526052B3.9030000@redhat.com>
Date: Thu, 17 Oct 2013 23:12:19 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Gerd Hoffmann <kraxel@redhat.com>
CC: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] xhci: Remove segments from radix tree on failed insert.
References: <20131017194458.GA12351@xanatos>
In-Reply-To: <20131017194458.GA12351@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/17/2013 09:44 PM, Sarah Sharp wrote:
> If we're expanding a stream ring, we want to make sure we can add those
> ring segments to the radix tree that maps segments to ring pointers.
> Try the radix tree insert after the new ring segments have been allocated
> (the last segment in the new ring chunk will point to the first newly
> allocated segment), but before the new ring segments are linked into the
> old ring.
>
> If insert fails on any one segment, remove each segment from the radix
> tree, deallocate the new segments, and return.  Otherwise, link the new
> segments into the tree.
>
> Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> ---
>
> Something like this.

Thanks for working on this.

 > It's ugly, but it compiles.  I haven't tested it.
> Hans, can you review and test this?

Reviewed, I've one small nitpick, see inline comments, other then that it looks
good, and I don't find it all that ugly :)

I've also run various tests and it seems to work as advertised (I've not
managed to trigger the error path though AFAIK).

Acked-by: Hans de Goede <hdegoede@redhat.com>

>
> Sarah Sharp
>
>   drivers/usb/host/xhci-mem.c | 106 +++++++++++++++++++++++++++++++++-----------
>   1 file changed, 80 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
> index a455c56..6ce8d31 100644
> --- a/drivers/usb/host/xhci-mem.c
> +++ b/drivers/usb/host/xhci-mem.c
> @@ -180,53 +180,98 @@ static void xhci_link_rings(struct xhci_hcd *xhci, struct xhci_ring *ring,
>    * extended systems (where the DMA address can be bigger than 32-bits),
>    * if we allow the PCI dma mask to be bigger than 32-bits.  So don't do that.
>    */
> -static int xhci_update_stream_mapping(struct xhci_ring *ring, gfp_t mem_flags)
> +static int xhci_insert_segment_mapping(struct radix_tree_root *trb_address_map,
> +		struct xhci_ring *ring,
> +		struct xhci_segment *seg,
> +		gfp_t mem_flags)
>   {
> -	struct xhci_segment *seg;
>   	unsigned long key;
>   	int ret;
>
> -	if (WARN_ON_ONCE(ring->trb_address_map == NULL))
> +	key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
> +	/* Skip any segments that were already added. */
> +	if (radix_tree_lookup(trb_address_map, key))
>   		return 0;
>
> -	seg = ring->first_seg;
> -	do {
> -		key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
> -		/* Skip any segments that were already added. */
> -		if (radix_tree_lookup(ring->trb_address_map, key))
> -			continue;
> +	ret = radix_tree_maybe_preload(mem_flags);
> +	if (ret)
> +		return ret;
> +	ret = radix_tree_insert(trb_address_map,
> +			key, ring);
> +	radix_tree_preload_end();
> +	return ret;
> +}
>
> -		ret = radix_tree_maybe_preload(mem_flags);
> -		if (ret)
> -			return ret;
> -		ret = radix_tree_insert(ring->trb_address_map,
> -				key, ring);
> -		radix_tree_preload_end();
> +static void xhci_remove_segment_mapping(struct radix_tree_root *trb_address_map,
> +		struct xhci_segment *seg)
> +{
> +	unsigned long key;
> +
> +	key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
> +	if (radix_tree_lookup(trb_address_map, key))
> +		radix_tree_delete(trb_address_map, key);
> +}
> +
> +static int xhci_update_stream_segment_mapping(
> +		struct radix_tree_root *trb_address_map,
> +		struct xhci_ring *ring,
> +		struct xhci_segment *first_seg,
> +		struct xhci_segment *last_seg,
> +		gfp_t mem_flags)
> +{
> +	struct xhci_segment *seg;
> +	struct xhci_segment *failed_seg;
> +	int ret;
> +
> +	if (WARN_ON_ONCE(trb_address_map == NULL))
> +		return 0;
> +
> +	seg = first_seg;
> +	do {
> +		ret = xhci_insert_segment_mapping(trb_address_map,
> +				ring, seg, mem_flags);
>   		if (ret)
> -			return ret;
> +			goto remove_streams;
> +		if (seg == last_seg)
> +			return 0;
>   		seg = seg->next;
> -	} while (seg != ring->first_seg);
> +	} while (seg != first_seg);

The while here tests for looping round, but that should never
happen, IMHO using do {} while (true); here would be more clear,
and also consistent with how the tear-down is done in the
error case in xhci_ring_expansion.

>
>   	return 0;
> +
> +remove_streams:
> +	failed_seg = seg;
> +	seg = first_seg;
> +	do {
> +		xhci_remove_segment_mapping(trb_address_map, seg);
> +		if (seg == failed_seg)
> +			return ret;
> +		seg = seg->next;
> +	} while (seg != first_seg);

And I would also prefer "} while (true};" here for the same reasons.

> +
> +	return ret;
>   }
>
>   static void xhci_remove_stream_mapping(struct xhci_ring *ring)
>   {
>   	struct xhci_segment *seg;
> -	unsigned long key;
>
>   	if (WARN_ON_ONCE(ring->trb_address_map == NULL))
>   		return;
>
>   	seg = ring->first_seg;
>   	do {
> -		key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
> -		if (radix_tree_lookup(ring->trb_address_map, key))
> -			radix_tree_delete(ring->trb_address_map, key);
> +		xhci_remove_segment_mapping(ring->trb_address_map, seg);
>   		seg = seg->next;
>   	} while (seg != ring->first_seg);
>   }
>
> +static int xhci_update_stream_mapping(struct xhci_ring *ring, gfp_t mem_flags)
> +{
> +	return xhci_update_stream_segment_mapping(ring->trb_address_map, ring,
> +			ring->first_seg, ring->last_seg, mem_flags);
> +}
> +
>   /* XXX: Do we need the hcd structure in all these functions? */
>   void xhci_ring_free(struct xhci_hcd *xhci, struct xhci_ring *ring)
>   {
> @@ -429,16 +474,25 @@ int xhci_ring_expansion(struct xhci_hcd *xhci, struct xhci_ring *ring,
>   	if (ret)
>   		return -ENOMEM;
>
> +	ret = xhci_update_stream_segment_mapping(ring->trb_address_map, ring,
> +			first, last, flags);
> +	if (ret) {
> +		struct xhci_segment *next;
> +		do {
> +			next = first->next;
> +			xhci_segment_free(xhci, first);
> +			if (first == last)
> +				break;
> +			first = next;
> +		} while (true);
> +		return ret;
> +	}
> +
>   	xhci_link_rings(xhci, ring, first, last, num_segs);
>   	xhci_dbg_trace(xhci, trace_xhci_dbg_ring_expansion,
>   			"ring expansion succeed, now has %d segments",
>   			ring->num_segs);
>
> -	if (ring->type == TYPE_STREAM) {
> -		ret = xhci_update_stream_mapping(ring, flags);
> -		WARN_ON(ret); /* FIXME */
> -	}
> -
>   	return 0;
>   }
>
>

Regards,

Hans
