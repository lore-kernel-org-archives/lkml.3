Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3EOD5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 23:57:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:53283 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764Ab3EOD5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 23:57:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,675,1363158000"; 
   d="scan'208";a="337428525"
Date: Tue, 14 May 2013 20:57:14 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] usb: xhci: Consolidate XHCI TD Size calculation
Message-ID: <20130515035714.GB17398@xanatos>
References: <1368160971-2176-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368160971-2176-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 09:42:51PM -0700, Julius Werner wrote:
> The TD Size field in an XHCI TRB is calculated in two different ways,
> depending on the XHCI version. The current code does this version check
> in every caller, which makes it easy to forget (such as in the function
> for control transfers, which still erroneously uses the old calculation
> for its data stage TRB). The 1.0 calculation has also been corrected and
> amended several times, growing slightly more complicated than necessary.

Does this patch fix the control transfer data stage issue?  Please break
this into a bug fix for that, with your refactoring on top of that.  We
need to backport the bug fix to the stable kernels, and queue the
refactoring for 3.11.

Sarah Sharp

> 
> This patch moves the XHCI version check into a single, unified (and
> slightly simplified) xhci_td_remainder() function, which deduplicates
> code and looks cleaner in the callers.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/host/xhci-ring.c | 111 +++++++++++--------------------------------
>  1 file changed, 29 insertions(+), 82 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 1969c00..32629b2 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -3074,54 +3074,33 @@ int xhci_queue_intr_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  }
>  
>  /*
> - * The TD size is the number of bytes remaining in the TD (including this TRB),
> - * right shifted by 10.
> - * It must fit in bits 21:17, so it can't be bigger than 31.
> - */
> -static u32 xhci_td_remainder(unsigned int remainder)
> -{
> -	u32 max = (1 << (21 - 17 + 1)) - 1;
> -
> -	if ((remainder >> 10) >= max)
> -		return max << 17;
> -	else
> -		return (remainder >> 10) << 17;
> -}
> -
> -/*
> - * For xHCI 1.0 host controllers, TD size is the number of max packet sized
> - * packets remaining in the TD (*not* including this TRB).
> - *
> - * Total TD packet count = total_packet_count =
> - *     DIV_ROUND_UP(TD size in bytes / wMaxPacketSize)
> + * Calculate the TD Size field of a TRB, shifted to its correct position
> + * in bits 21:17. In pre-1.0 XHCI versions, this field contains the
> + * number of bytes left in the TD, including the current TRB, in kB.
>   *
> - * Packets transferred up to and including this TRB = packets_transferred =
> - *     rounddown(total bytes transferred including this TRB / wMaxPacketSize)
> + * In XHCI 1.0, it contains the amount of packets left in the TD,
> + * excluding the current TRB. Even though the spec explains this in a
> + * roundabout way, the end result is just the amount of bytes left after
> + * this TRB divided by the maximum packet size, rounded up. For the last
> + * TRB this is naturally zero since there cannot be any more bytes left.
>   *
> - * TD size = total_packet_count - packets_transferred
> - *
> - * It must fit in bits 21:17, so it can't be bigger than 31.
> - * The last TRB in a TD must have the TD size set to zero.
> + * @running_total:	amount of bytes in the TD before this TRB
> + * @trb_len:		amount of bytes in the current TRB
> + * @total_len:		total amount of bytes in the TD
>   */
> -static u32 xhci_v1_0_td_remainder(int running_total, int trb_buff_len,
> -		unsigned int total_packet_count, struct urb *urb,
> -		unsigned int num_trbs_left)
> +static u32 xhci_td_remainder(int running_total, int trb_len, int total_len,
> +		struct urb *urb)
>  {
> -	int packets_transferred;
> +	u32 result;
>  
> -	/* One TRB with a zero-length data packet. */
> -	if (num_trbs_left == 0 || (running_total == 0 && trb_buff_len == 0))
> -		return 0;
> -
> -	/* All the TRB queueing functions don't count the current TRB in
> -	 * running_total.
> -	 */
> -	packets_transferred = (running_total + trb_buff_len) /
> -		GET_MAX_PACKET(usb_endpoint_maxp(&urb->ep->desc));
> +	if (hcd_to_xhci(bus_to_hcd(urb->dev->bus))->hci_version < 0x100)
> +		result = (total_len - running_total) >> 10;
> +	else
> +		result = DIV_ROUND_UP(total_len - running_total - trb_len,
> +			GET_MAX_PACKET(usb_endpoint_maxp(&urb->ep->desc)));
>  
> -	if ((total_packet_count - packets_transferred) > 31)
> -		return 31 << 17;
> -	return (total_packet_count - packets_transferred) << 17;
> +	/* TD size field is only 5 bit wide, so cap this at 31 */
> +	return min(result, 31u) << 17;
>  }
>  
>  static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
> @@ -3134,7 +3113,6 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  	struct scatterlist *sg;
>  	int num_sgs;
>  	int trb_buff_len, this_sg_len, running_total;
> -	unsigned int total_packet_count;
>  	bool first_trb;
>  	u64 addr;
>  	bool more_trbs_coming;
> @@ -3148,8 +3126,6 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  
>  	num_trbs = count_sg_trbs_needed(xhci, urb);
>  	num_sgs = urb->num_mapped_sgs;
> -	total_packet_count = DIV_ROUND_UP(urb->transfer_buffer_length,
> -			usb_endpoint_maxp(&urb->ep->desc));
>  
>  	trb_buff_len = prepare_transfer(xhci, xhci->devs[slot_id],
>  			ep_index, urb->stream_id,
> @@ -3191,7 +3167,6 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  	do {
>  		u32 field = 0;
>  		u32 length_field = 0;
> -		u32 remainder = 0;
>  
>  		/* Don't change the cycle bit of the first TRB until later */
>  		if (first_trb) {
> @@ -3225,17 +3200,9 @@ static int queue_bulk_sg_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  		}
>  
>  		/* Set the TRB length, TD size, and interrupter fields. */
> -		if (xhci->hci_version < 0x100) {
> -			remainder = xhci_td_remainder(
> -					urb->transfer_buffer_length -
> -					running_total);
> -		} else {
> -			remainder = xhci_v1_0_td_remainder(running_total,
> -					trb_buff_len, total_packet_count, urb,
> -					num_trbs - 1);
> -		}
>  		length_field = TRB_LEN(trb_buff_len) |
> -			remainder |
> +			xhci_td_remainder(running_total, trb_buff_len,
> +			urb->transfer_buffer_length, urb) |
>  			TRB_INTR_TARGET(0);
>  
>  		if (num_trbs > 1)
> @@ -3294,7 +3261,6 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  	u32 field, length_field;
>  
>  	int running_total, trb_buff_len, ret;
> -	unsigned int total_packet_count;
>  	u64 addr;
>  
>  	if (urb->num_sgs)
> @@ -3340,8 +3306,6 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  	start_cycle = ep_ring->cycle_state;
>  
>  	running_total = 0;
> -	total_packet_count = DIV_ROUND_UP(urb->transfer_buffer_length,
> -			usb_endpoint_maxp(&urb->ep->desc));
>  	/* How much data is in the first TRB? */
>  	addr = (u64) urb->transfer_dma;
>  	trb_buff_len = TRB_MAX_BUFF_SIZE -
> @@ -3353,7 +3317,6 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  
>  	/* Queue the first TRB, even if it's zero-length */
>  	do {
> -		u32 remainder = 0;
>  		field = 0;
>  
>  		/* Don't change the cycle bit of the first TRB until later */
> @@ -3380,17 +3343,9 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  			field |= TRB_ISP;
>  
>  		/* Set the TRB length, TD size, and interrupter fields. */
> -		if (xhci->hci_version < 0x100) {
> -			remainder = xhci_td_remainder(
> -					urb->transfer_buffer_length -
> -					running_total);
> -		} else {
> -			remainder = xhci_v1_0_td_remainder(running_total,
> -					trb_buff_len, total_packet_count, urb,
> -					num_trbs - 1);
> -		}
>  		length_field = TRB_LEN(trb_buff_len) |
> -			remainder |
> +			xhci_td_remainder(running_total, trb_buff_len,
> +				urb->transfer_buffer_length, urb) |
>  			TRB_INTR_TARGET(0);
>  
>  		if (num_trbs > 1)
> @@ -3502,7 +3457,8 @@ int xhci_queue_ctrl_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  		field = TRB_TYPE(TRB_DATA);
>  
>  	length_field = TRB_LEN(urb->transfer_buffer_length) |
> -		xhci_td_remainder(urb->transfer_buffer_length) |
> +		xhci_td_remainder(0, urb->transfer_buffer_length,
> +			urb->transfer_buffer_length, urb) |
>  		TRB_INTR_TARGET(0);
>  	if (urb->transfer_buffer_length > 0) {
>  		if (setup->bRequestType & USB_DIR_IN)
> @@ -3673,7 +3629,6 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  
>  		td = urb_priv->td[i];
>  		for (j = 0; j < trbs_per_td; j++) {
> -			u32 remainder = 0;
>  			field = 0;
>  
>  			if (first_trb) {
> @@ -3726,17 +3681,9 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
>  				trb_buff_len = td_remain_len;
>  
>  			/* Set the TRB length, TD size, & interrupter fields. */
> -			if (xhci->hci_version < 0x100) {
> -				remainder = xhci_td_remainder(
> -						td_len - running_total);
> -			} else {
> -				remainder = xhci_v1_0_td_remainder(
> -						running_total, trb_buff_len,
> -						total_packet_count, urb,
> -						(trbs_per_td - j - 1));
> -			}
>  			length_field = TRB_LEN(trb_buff_len) |
> -				remainder |
> +				xhci_td_remainder(running_total, trb_buff_len,
> +					td_len, urb) |
>  				TRB_INTR_TARGET(0);
>  
>  			queue_trb(xhci, ep_ring, more_trbs_coming,
> -- 
> 1.7.12.4
> 
