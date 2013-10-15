Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab3JOGN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:13:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758065Ab3JOGN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:13:28 -0400
Message-ID: <525CDCFF.7010507@redhat.com>
Date: Tue, 15 Oct 2013 08:13:19 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH v2] xhci: fix usb3 streams
References: <20131015015424.GA5032@xanatos>
In-Reply-To: <20131015015424.GA5032@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

On 10/15/2013 03:54 AM, Gerd Hoffmann wrote:
> Gerd, Hans, any objections to this updated patch?  The warning is fixed
> with it.

No objections, looks good to me.

>
> The patch probably still needs to address the case where the ring
> expansion fails because we can't insert the new segments into the radix
> tree.  The patch should probably allocate the segments, attempt to add
> them to the radix tree, and fail without modifying the link TRBs of the
> ring.  I'd have to look more deeply into the code to see what exactly
> should be done there.
>
> I would like that issue fixed before I merge these patches, so if you
> want to take a stab at fixing it, please do.
>
> Sarah Sharp


Regards,

Hans


>
> 8<---------------------------------------------------------------->8
>
> xhci maintains a radix tree for each stream endpoint because it must
> be able to map a trb address to the stream ring.  Each ring segment
> must be added to the ring for this to work.  Currently xhci sticks
> only the first segment of each stream ring into the radix tree.
>
> Result is that things work initially, but as soon as the first segment
> is full xhci can't map the trb address from the completion event to the
> stream ring any more -> BOOM.  You'll find this message in the logs:
>
>    ERROR Transfer event for disabled endpoint or incorrect stream ring
>
> This patch adds a helper function to update the radix tree, and a
> function to remove ring segments from the tree.  Both functions loop
> over the segment list and handles all segments instead of just the
> first.
>
> [Note: Sarah changed this patch to add radix_tree_maybe_preload() and
> radix_tree_preload_end() calls around the radix tree insert, since we
> can now insert entries in interrupt context.  There are now two helper
> functions to make the code cleaner, and those functions are moved to
> make them static.]
>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> ---
>   drivers/usb/host/xhci-mem.c | 132 +++++++++++++++++++++++++++++---------------
>   drivers/usb/host/xhci.h     |   1 +
>   2 files changed, 90 insertions(+), 43 deletions(-)
>
> diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
> index 83bcd13..8b1ba5b 100644
> --- a/drivers/usb/host/xhci-mem.c
> +++ b/drivers/usb/host/xhci-mem.c
> @@ -149,14 +149,95 @@ static void xhci_link_rings(struct xhci_hcd *xhci, struct xhci_ring *ring,
>   	}
>   }
>
> +/*
> + * We need a radix tree for mapping physical addresses of TRBs to which stream
> + * ID they belong to.  We need to do this because the host controller won't tell
> + * us which stream ring the TRB came from.  We could store the stream ID in an
> + * event data TRB, but that doesn't help us for the cancellation case, since the
> + * endpoint may stop before it reaches that event data TRB.
> + *
> + * The radix tree maps the upper portion of the TRB DMA address to a ring
> + * segment that has the same upper portion of DMA addresses.  For example, say I
> + * have segments of size 1KB, that are always 64-byte aligned.  A segment may
> + * start at 0x10c91000 and end at 0x10c913f0.  If I use the upper 10 bits, the
> + * key to the stream ID is 0x43244.  I can use the DMA address of the TRB to
> + * pass the radix tree a key to get the right stream ID:
> + *
> + * 	0x10c90fff >> 10 = 0x43243
> + * 	0x10c912c0 >> 10 = 0x43244
> + * 	0x10c91400 >> 10 = 0x43245
> + *
> + * Obviously, only those TRBs with DMA addresses that are within the segment
> + * will make the radix tree return the stream ID for that ring.
> + *
> + * Caveats for the radix tree:
> + *
> + * The radix tree uses an unsigned long as a key pair.  On 32-bit systems, an
> + * unsigned long will be 32-bits; on a 64-bit system an unsigned long will be
> + * 64-bits.  Since we only request 32-bit DMA addresses, we can use that as the
> + * key on 32-bit or 64-bit systems (it would also be fine if we asked for 64-bit
> + * PCI DMA addresses on a 64-bit system).  There might be a problem on 32-bit
> + * extended systems (where the DMA address can be bigger than 32-bits),
> + * if we allow the PCI dma mask to be bigger than 32-bits.  So don't do that.
> + */
> +static int xhci_update_stream_mapping(struct xhci_ring *ring, gfp_t mem_flags)
> +{
> +	struct xhci_segment *seg;
> +	unsigned long key;
> +	int ret;
> +
> +	if (WARN_ON_ONCE(ring->trb_address_map == NULL))
> +		return 0;
> +
> +	seg = ring->first_seg;
> +	do {
> +		key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
> +		/* Skip any segments that were already added. */
> +		if (radix_tree_lookup(ring->trb_address_map, key))
> +			continue;
> +
> +		ret = radix_tree_maybe_preload(mem_flags);
> +		if (ret)
> +			return ret;
> +		ret = radix_tree_insert(ring->trb_address_map,
> +				key, ring);
> +		radix_tree_preload_end();
> +		if (ret)
> +			return ret;
> +		seg = seg->next;
> +	} while (seg != ring->first_seg);
> +
> +	return 0;
> +}
> +
> +static void xhci_remove_stream_mapping(struct xhci_ring *ring)
> +{
> +	struct xhci_segment *seg;
> +	unsigned long key;
> +
> +	if (WARN_ON_ONCE(ring->trb_address_map == NULL))
> +		return;
> +
> +	seg = ring->first_seg;
> +	do {
> +		key = (unsigned long)(seg->dma >> TRB_SEGMENT_SHIFT);
> +		if (radix_tree_lookup(ring->trb_address_map, key))
> +			radix_tree_delete(ring->trb_address_map, key);
> +		seg = seg->next;
> +	} while (seg != ring->first_seg);
> +}
> +
>   /* XXX: Do we need the hcd structure in all these functions? */
>   void xhci_ring_free(struct xhci_hcd *xhci, struct xhci_ring *ring)
>   {
>   	if (!ring)
>   		return;
>
> -	if (ring->first_seg)
> +	if (ring->first_seg) {
> +		if (ring->type == TYPE_STREAM)
> +			xhci_remove_stream_mapping(ring);
>   		xhci_free_segments_for_ring(xhci, ring->first_seg);
> +	}
>
>   	kfree(ring);
>   }
> @@ -353,6 +434,11 @@ int xhci_ring_expansion(struct xhci_hcd *xhci, struct xhci_ring *ring,
>   			"ring expansion succeed, now has %d segments",
>   			ring->num_segs);
>
> +	if (ring->type == TYPE_STREAM) {
> +		ret = xhci_update_stream_mapping(ring, flags);
> +		WARN_ON(ret); /* FIXME */
> +	}
> +
>   	return 0;
>   }
>
> @@ -509,36 +595,6 @@ struct xhci_ring *xhci_stream_id_to_ring(
>    * The number of stream contexts in the stream context array may be bigger than
>    * the number of streams the driver wants to use.  This is because the number of
>    * stream context array entries must be a power of two.
> - *
> - * We need a radix tree for mapping physical addresses of TRBs to which stream
> - * ID they belong to.  We need to do this because the host controller won't tell
> - * us which stream ring the TRB came from.  We could store the stream ID in an
> - * event data TRB, but that doesn't help us for the cancellation case, since the
> - * endpoint may stop before it reaches that event data TRB.
> - *
> - * The radix tree maps the upper portion of the TRB DMA address to a ring
> - * segment that has the same upper portion of DMA addresses.  For example, say I
> - * have segments of size 1KB, that are always 64-byte aligned.  A segment may
> - * start at 0x10c91000 and end at 0x10c913f0.  If I use the upper 10 bits, the
> - * key to the stream ID is 0x43244.  I can use the DMA address of the TRB to
> - * pass the radix tree a key to get the right stream ID:
> - *
> - * 	0x10c90fff >> 10 = 0x43243
> - * 	0x10c912c0 >> 10 = 0x43244
> - * 	0x10c91400 >> 10 = 0x43245
> - *
> - * Obviously, only those TRBs with DMA addresses that are within the segment
> - * will make the radix tree return the stream ID for that ring.
> - *
> - * Caveats for the radix tree:
> - *
> - * The radix tree uses an unsigned long as a key pair.  On 32-bit systems, an
> - * unsigned long will be 32-bits; on a 64-bit system an unsigned long will be
> - * 64-bits.  Since we only request 32-bit DMA addresses, we can use that as the
> - * key on 32-bit or 64-bit systems (it would also be fine if we asked for 64-bit
> - * PCI DMA addresses on a 64-bit system).  There might be a problem on 32-bit
> - * extended systems (where the DMA address can be bigger than 32-bits),
> - * if we allow the PCI dma mask to be bigger than 32-bits.  So don't do that.
>    */
>   struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
>   		unsigned int num_stream_ctxs,
> @@ -547,7 +603,6 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
>   	struct xhci_stream_info *stream_info;
>   	u32 cur_stream;
>   	struct xhci_ring *cur_ring;
> -	unsigned long key;
>   	u64 addr;
>   	int ret;
>
> @@ -602,6 +657,7 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
>   		if (!cur_ring)
>   			goto cleanup_rings;
>   		cur_ring->stream_id = cur_stream;
> +		cur_ring->trb_address_map = &stream_info->trb_address_map;
>   		/* Set deq ptr, cycle bit, and stream context type */
>   		addr = cur_ring->first_seg->dma |
>   			SCT_FOR_CTX(SCT_PRI_TR) |
> @@ -611,10 +667,7 @@ struct xhci_stream_info *xhci_alloc_stream_info(struct xhci_hcd *xhci,
>   		xhci_dbg(xhci, "Setting stream %d ring ptr to 0x%08llx\n",
>   				cur_stream, (unsigned long long) addr);
>
> -		key = (unsigned long)
> -			(cur_ring->first_seg->dma >> TRB_SEGMENT_SHIFT);
> -		ret = radix_tree_insert(&stream_info->trb_address_map,
> -				key, cur_ring);
> +		ret = xhci_update_stream_mapping(cur_ring, mem_flags);
>   		if (ret) {
>   			xhci_ring_free(xhci, cur_ring);
>   			stream_info->stream_rings[cur_stream] = NULL;
> @@ -634,9 +687,6 @@ cleanup_rings:
>   	for (cur_stream = 1; cur_stream < num_streams; cur_stream++) {
>   		cur_ring = stream_info->stream_rings[cur_stream];
>   		if (cur_ring) {
> -			addr = cur_ring->first_seg->dma;
> -			radix_tree_delete(&stream_info->trb_address_map,
> -					addr >> TRB_SEGMENT_SHIFT);
>   			xhci_ring_free(xhci, cur_ring);
>   			stream_info->stream_rings[cur_stream] = NULL;
>   		}
> @@ -697,7 +747,6 @@ void xhci_free_stream_info(struct xhci_hcd *xhci,
>   {
>   	int cur_stream;
>   	struct xhci_ring *cur_ring;
> -	dma_addr_t addr;
>
>   	if (!stream_info)
>   		return;
> @@ -706,9 +755,6 @@ void xhci_free_stream_info(struct xhci_hcd *xhci,
>   			cur_stream++) {
>   		cur_ring = stream_info->stream_rings[cur_stream];
>   		if (cur_ring) {
> -			addr = cur_ring->first_seg->dma;
> -			radix_tree_delete(&stream_info->trb_address_map,
> -					addr >> TRB_SEGMENT_SHIFT);
>   			xhci_ring_free(xhci, cur_ring);
>   			stream_info->stream_rings[cur_stream] = NULL;
>   		}
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 289fbfb..737dcc1 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1334,6 +1334,7 @@ struct xhci_ring {
>   	unsigned int		num_trbs_free_temp;
>   	enum xhci_ring_type	type;
>   	bool			last_td_was_short;
> +	struct radix_tree_root	*trb_address_map;
>   };
>
>   struct xhci_erst_entry {
>
