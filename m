Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934793AbaH0OWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:22:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43845 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934514AbaH0OWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:22:37 -0400
Message-ID: <53FDE9A2.501@canonical.com>
Date: Wed, 27 Aug 2014 10:22:26 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mathias Nyman <mathias.nyman@linux.intel.com>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org,
        Dustin Kirkland <dustin.kirkland@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] xhci: rework cycle bit checking for new dequeue pointers
References: <1408450678-5653-1-git-send-email-mathias.nyman@linux.intel.com> <1408450678-5653-4-git-send-email-mathias.nyman@linux.intel.com> <53F51BD5.50302@canonical.com> <53FDBC03.7040402@linux.intel.com>
In-Reply-To: <53FDBC03.7040402@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 07:07 AM, Mathias Nyman wrote:
> On 08/21/2014 01:06 AM, Joseph Salisbury wrote:
>> On 08/19/2014 08:17 AM, Mathias Nyman wrote:
>>> When we manually need to move the TR dequeue pointer we need to set the
>>> correct cycle bit as well. Previously we used the trb pointer from the
>>> last event received as a base, but this was changed in
>>> commit 1f81b6d22a59 ("usb: xhci: Prefer endpoint context dequeue pointer")
>>> to use the dequeue pointer from the endpoint context instead
>>>
>>> It turns out some Asmedia controllers advance the dequeue pointer
>>> stored in the endpoint context past the event triggering TRB, and
>>> this messed up the way the cycle bit was calculated.
>>>
>>> Instead of adding a quirk or complicating the already hard to follow cycle bit
>>> code, the whole cycle bit calculation is now simplified and adapted to handle
>>> event and endpoint context dequeue pointer differences.
>>>
>>> Fixes: 1f81b6d22a59 ("usb: xhci: Prefer endpoint context dequeue pointer")
>>> Reported-by: Maciej Puzio <mx34567@gmail.com>
>>> Reported-by: Evan Langlois <uudruid74@gmail.com>
>>> Reviewed-by: Julius Werner <jwerner@chromium.org>
>>> Tested-by: Maciej Puzio <mx34567@gmail.com>
>>> Tested-by: Evan Langlois <uudruid74@gmail.com>
>>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>  drivers/usb/host/xhci-ring.c | 101 +++++++++++++++++--------------------------
>>>  drivers/usb/host/xhci.c      |   3 ++
>>>  2 files changed, 42 insertions(+), 62 deletions(-)
>>>
>>> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
>>> index ac8cf23..abed30b 100644
>>> --- a/drivers/usb/host/xhci-ring.c
>>> +++ b/drivers/usb/host/xhci-ring.c
>>> @@ -364,32 +364,6 @@ static void ring_doorbell_for_active_rings(struct xhci_hcd *xhci,
>>>  	}
>>>  }
>>>  
>>> -/*
>>> - * Find the segment that trb is in.  Start searching in start_seg.
>>> - * If we must move past a segment that has a link TRB with a toggle cycle state
>>> - * bit set, then we will toggle the value pointed at by cycle_state.
>>> - */
>>> -static struct xhci_segment *find_trb_seg(
>>> -		struct xhci_segment *start_seg,
>>> -		union xhci_trb	*trb, int *cycle_state)
>>> -{
>>> -	struct xhci_segment *cur_seg = start_seg;
>>> -	struct xhci_generic_trb *generic_trb;
>>> -
>>> -	while (cur_seg->trbs > trb ||
>>> -			&cur_seg->trbs[TRBS_PER_SEGMENT - 1] < trb) {
>>> -		generic_trb = &cur_seg->trbs[TRBS_PER_SEGMENT - 1].generic;
>>> -		if (generic_trb->field[3] & cpu_to_le32(LINK_TOGGLE))
>>> -			*cycle_state ^= 0x1;
>>> -		cur_seg = cur_seg->next;
>>> -		if (cur_seg == start_seg)
>>> -			/* Looped over the entire list.  Oops! */
>>> -			return NULL;
>>> -	}
>>> -	return cur_seg;
>>> -}
>>> -
>>> -
>>>  static struct xhci_ring *xhci_triad_to_transfer_ring(struct xhci_hcd *xhci,
>>>  		unsigned int slot_id, unsigned int ep_index,
>>>  		unsigned int stream_id)
>>> @@ -459,9 +433,12 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
>>>  	struct xhci_virt_device *dev = xhci->devs[slot_id];
>>>  	struct xhci_virt_ep *ep = &dev->eps[ep_index];
>>>  	struct xhci_ring *ep_ring;
>>> -	struct xhci_generic_trb *trb;
>>> +	struct xhci_segment *new_seg;
>>> +	union xhci_trb *new_deq;
>>>  	dma_addr_t addr;
>>>  	u64 hw_dequeue;
>>> +	bool cycle_found = false;
>>> +	bool td_last_trb_found = false;
>>>  
>>>  	ep_ring = xhci_triad_to_transfer_ring(xhci, slot_id,
>>>  			ep_index, stream_id);
>>> @@ -486,45 +463,45 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
>>>  		hw_dequeue = le64_to_cpu(ep_ctx->deq);
>>>  	}
>>>  
>>> -	/* Find virtual address and segment of hardware dequeue pointer */
>>> -	state->new_deq_seg = ep_ring->deq_seg;
>>> -	state->new_deq_ptr = ep_ring->dequeue;
>>> -	while (xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr)
>>> -			!= (dma_addr_t)(hw_dequeue & ~0xf)) {
>>> -		next_trb(xhci, ep_ring, &state->new_deq_seg,
>>> -					&state->new_deq_ptr);
>>> -		if (state->new_deq_ptr == ep_ring->dequeue) {
>>> -			WARN_ON(1);
>>> -			return;
>>> -		}
>>> -	}
>>> +	new_seg = ep_ring->deq_seg;
>>> +	new_deq = ep_ring->dequeue;
>>> +	state->new_cycle_state = hw_dequeue & 0x1;
>>> +
>>>  	/*
>>> -	 * Find cycle state for last_trb, starting at old cycle state of
>>> -	 * hw_dequeue. If there is only one segment ring, find_trb_seg() will
>>> -	 * return immediately and cannot toggle the cycle state if this search
>>> -	 * wraps around, so add one more toggle manually in that case.
>>> +	 * We want to find the pointer, segment and cycle state of the new trb
>>> +	 * (the one after current TD's last_trb). We know the cycle state at
>>> +	 * hw_dequeue, so walk the ring until both hw_dequeue and last_trb are
>>> +	 * found.
>>>  	 */
>>> -	state->new_cycle_state = hw_dequeue & 0x1;
>>> -	if (ep_ring->first_seg == ep_ring->first_seg->next &&
>>> -			cur_td->last_trb < state->new_deq_ptr)
>>> -		state->new_cycle_state ^= 0x1;
>>> +	do {
>>> +		if (!cycle_found && xhci_trb_virt_to_dma(new_seg, new_deq)
>>> +		    == (dma_addr_t)(hw_dequeue & ~0xf)) {
>>> +			cycle_found = true;
>>> +			if (td_last_trb_found)
>>> +				break;
>>> +		}
>>> +		if (new_deq == cur_td->last_trb)
>>> +			td_last_trb_found = true;
>>>  
>>> -	state->new_deq_ptr = cur_td->last_trb;
>>> -	xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
>>> -			"Finding segment containing last TRB in TD.");
>>> -	state->new_deq_seg = find_trb_seg(state->new_deq_seg,
>>> -			state->new_deq_ptr, &state->new_cycle_state);
>>> -	if (!state->new_deq_seg) {
>>> -		WARN_ON(1);
>>> -		return;
>>> -	}
>>> +		if (cycle_found &&
>>> +		    TRB_TYPE_LINK_LE32(new_deq->generic.field[3]) &&
>>> +		    new_deq->generic.field[3] & cpu_to_le32(LINK_TOGGLE))
>>> +			state->new_cycle_state ^= 0x1;
>>> +
>>> +		next_trb(xhci, ep_ring, &new_seg, &new_deq);
>>> +
>>> +		/* Search wrapped around, bail out */
>>> +		if (new_deq == ep->ring->dequeue) {
>>> +			xhci_err(xhci, "Error: Failed finding new dequeue state\n");
>>> +			state->new_deq_seg = NULL;
>>> +			state->new_deq_ptr = NULL;
>>> +			return;
>>> +		}
>>> +
>>> +	} while (!cycle_found || !td_last_trb_found);
>>>  
>>> -	/* Increment to find next TRB after last_trb. Cycle if appropriate. */
>>> -	trb = &state->new_deq_ptr->generic;
>>> -	if (TRB_TYPE_LINK_LE32(trb->field[3]) &&
>>> -	    (trb->field[3] & cpu_to_le32(LINK_TOGGLE)))
>>> -		state->new_cycle_state ^= 0x1;
>>> -	next_trb(xhci, ep_ring, &state->new_deq_seg, &state->new_deq_ptr);
>>> +	state->new_deq_seg = new_seg;
>>> +	state->new_deq_ptr = new_deq;
>>>  
>>>  	/* Don't update the ring cycle state for the producer (us). */
>>>  	xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
>>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>>> index b6f2117..c020b09 100644
>>> --- a/drivers/usb/host/xhci.c
>>> +++ b/drivers/usb/host/xhci.c
>>> @@ -2880,6 +2880,9 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci,
>>>  			ep_index, ep->stopped_stream, ep->stopped_td,
>>>  			&deq_state);
>>>  
>>> +	if (!deq_state.new_deq_ptr || !deq_state.new_deq_seg)
>>> +		return;
>>> +
>>>  	/* HW with the reset endpoint quirk will use the saved dequeue state to
>>>  	 * issue a configure endpoint command later.
>>>  	 */
>>   
>> Hi Mathias,
>>
>> Some of the stable kernel versions fail to build with this patch, 3.2.y
>> and 3.13.y for example.  This is because the function 'find_trb_seg' is
>> still called by xhci_cmd_to_noop, which is removed from mainline but
>> still exists in the stable kernels.  The patch removes the definition of
>> find_trb_seg, which is what causes the build to fail. 
>>
>> Should we leave the definition of find_trb_seg in your patch for the
>> stable kernels, or do you have other ideas?
>>
> You can leave the find_trb_seg() function there for xhci_cmd_to_noop() to use in older kernels
>
> Should I backport it against 3.13.y for you?
No need for you to backport.  I just wanted to confirm that leaving
find_trb_seg() was an ok approach.

>
> -Mathias
>

