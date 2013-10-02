Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab3JBPs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:48:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53390 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752926Ab3JBPsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:48:53 -0400
Date: Wed, 2 Oct 2013 11:48:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Robert Baldyga <r.baldyga@samsung.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>
Subject: Re: [PATCH v4] USB: gadget: epautoconf: fix ep maxpacket check
In-Reply-To: <1380708563-10622-1-git-send-email-r.baldyga@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1310021128200.1293-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Oct 2013, Robert Baldyga wrote:

> This patch fix validation of maxpacket value given in endpoint descriptor.
> Add check of maxpacket for bulk endpoints. If maxpacket is not set in
> descriptor, it's set to maximum value for given type on endpoint in used
> speed.
> 
> Correct maxpacket value is:
> 
>              FULL-SPEED        HIGH-SPEED   SUPER-SPEED
> BULK         8, 16, 32, 64     512          1024
> INTERRUPT    1..64             1..1024      1..1024
> ISOCHRONOUS  1..1023           1..1024      1..1024
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
> 
> Hello,
> 
> This is fourth version of my patch. From last version I have removed
> code reporting full speed bulk maxpacket because it's not needed since
> maxpacket check for all speeds is performed before.

It seems that this patch does a lot of things wrong.  Comments below.

> @@ -124,37 +124,90 @@ ep_matches (
>  
>  	}
>  
> +	max = 0x7ff & usb_endpoint_maxp(desc);
> +
>  	/*
> -	 * If the protocol driver hasn't yet decided on wMaxPacketSize
> -	 * and wants to know the maximum possible, provide the info.
> +	 * Test if maxpacket given in descriptor isn't greater than maximum
> +	 * packet size for this endpoint
>  	 */
> -	if (desc->wMaxPacketSize == 0)
> -		desc->wMaxPacketSize = cpu_to_le16(ep->maxpacket);
> +	if (ep->maxpacket < max)
> +		return 0;
>  
> -	/* endpoint maxpacket size is an input parameter, except for bulk
> -	 * where it's an output parameter representing the full speed limit.
> -	 * the usb spec fixes high speed bulk maxpacket at 512 bytes.
> +	/*
> +	 * Test if ep supports maxpacket size set in descriptor.
> +	 * If the protocol driver hasn't yet decided on wMaxPacketSize
> +	 * (when wMaxPacketSize == 0) and wants to know the maximum possible,
> +	 * provide the info.

This disagrees with the kerneldoc for usb_ep_autoconfig().  For bulk
endpoints, wMaxPacket is always supposed to be set to the full-speed
value, regardless of what the protocol driver specifies.

>  	 */
> -	max = 0x7ff & usb_endpoint_maxp(desc);
>  	switch (type) {
> +	case USB_ENDPOINT_XFER_BULK:
> +		/*
> +		 * LIMITS:
> +		 * full speed:    64 bytes
> +		 * high speed:   512 bytes
> +		 * super speed: 1024 bytes
> +		 */
> +		if (max == 0) {
> +			if (gadget_is_superspeed(gadget))
> +				desc->wMaxPacketSize = cpu_to_le16(1024);
> +			else if (gadget_is_dualspeed(gadget))
> +				desc->wMaxPacketSize = cpu_to_le16(512);
> +			else
> +				desc->wMaxPacketSize = cpu_to_le16(64);

So these lines are wrong.  Also, how do you know that 64 is correct for 
full speed?  The hardware might only support 32.

> +		} else {
> +			if (max > 1024)
> +				return 0;
> +			if (!gadget_is_superspeed(gadget) && max > 512)
> +				return 0;
> +			if (!gadget_is_dualspeed(gadget) && max > 64)
> +				return 0;
> +		}

For bulk endpoints, you should ignore the original value in the
descriptor.  All that matters is ep->maxpacket; it will override the
value in the descriptor.

> +		break;
> +
>  	case USB_ENDPOINT_XFER_INT:
> -		/* INT:  limit 64 bytes full speed, 1024 high/super speed */
> -		if (!gadget_is_dualspeed(gadget) && max > 64)
> -			return 0;
> -		/* FALLTHROUGH */
> +		/*
> +		 * LIMITS:
> +		 * full speed:		64 bytes
> +		 * high/super speed:  1024 bytes
> +		 * multiple transactions per microframe only for super speed

The last comment is wrong.  High speed also allows multiple interrupt 
transactions in a microframe.

Also, why bother to spell out the limits in the comment?  You're not 
going to use those values; you're going to use the limit in 
ep->maxpacket.

> +		 */
> +		if (max == 0) {
> +			if (gadget_is_dualspeed(gadget))
> +				desc->wMaxPacketSize = cpu_to_le16(1024);
> +			else
> +				desc->wMaxPacketSize = cpu_to_le16(64);

These values should be taken from ep->maxpacket, not from the spec.

> +		} else {
> +			if (max > 1024)
> +				return 0;
> +			if (!gadget_is_superspeed(gadget))
> +				if ((desc->wMaxPacketSize & cpu_to_le16(3<<11)))
> +					return 0;
> +			if (!gadget_is_dualspeed(gadget) && max > 64)
> +				return 0;

The first and third tests are unnecessary, because you have already 
checked that max <= ep->maxpacket.

Similar issues apply to the Isochronous case.

Alan Stern

