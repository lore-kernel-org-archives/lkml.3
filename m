Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab3KEOu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:50:26 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43069 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754766Ab3KEOuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:50:24 -0500
Date: Tue, 5 Nov 2013 09:50:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Cohen <david.a.cohen@linux.intel.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/4] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
In-Reply-To: <1383603177-4624-3-git-send-email-david.a.cohen@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1311050948360.1360-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Nov 2013, David Cohen wrote:

> Due to USB controllers may have different restrictions, usb gadget layer
> needs to provide a generic way to inform gadget functions to complain
> with non-standard requirements.
> 
> This patch adds 'quirk_ep_out_aligned_size' field to struct usb_gadget
> to inform when controller's epout requires buffer size to be aligned to
> MaxPacketSize. A helper is also provided to align buffer size when
> necessary.
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  include/linux/usb/gadget.h | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 23b3bfd0a842..260d972489bd 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -442,6 +442,22 @@ static inline void usb_ep_fifo_flush(struct usb_ep *ep)
>  }
>  
>  
> +static inline size_t usb_ep_align_maxpacketsize(struct usb_ep *ep, size_t len)
> +{
> +	int aligned;
> +
> +	if (ep->desc->bmAttributes & USB_ENDPOINT_XFER_INT)
> +		/*
> +		 * Interrupt eps don't need max packet size to be power of 2,
> +		 * so can't use cheap IS_ALIGNED() macro.
> +		 */
> +		aligned = !(len % ep->desc->wMaxPacketSize);
> +	else
> +		aligned = IS_ALIGNED(len, ep->desc->wMaxPacketSize);

This isn't on a hot path, and I suspect that the extra "if" will 
require nearly as much time as you save by not doing the division.  You 
might as well always use the % operation.

Alan Stern

