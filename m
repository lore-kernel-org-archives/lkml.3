Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3I0Pct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:32:49 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55260 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753497Ab3I0Pcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:32:46 -0400
Date: Fri, 27 Sep 2013 11:32:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Robert Baldyga <r.baldyga@samsung.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>
Subject: Re: [PATCH] USB: gadget: epautoconf: fix ep maxpacket check
In-Reply-To: <1380277808-17736-1-git-send-email-r.baldyga@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1309271126490.10254-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep 2013, Robert Baldyga wrote:

> This patch fixes validation of maxpacket value given in endpoint descriptor.
> Added check of maxpacket for bulk endpoints.
> Correct maxpacket value is:
> 
>              FULL-SPEED  HIGH-SPEED
> BULK         64          512

Don't forget SuperSpeed.  It requires Bulk endpoints to have maxpacket 
= 1024.

> INTERRUPT    64          1024
> ISOCHRONOUS  1023        1024
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/usb/gadget/epautoconf.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
> index a777f7b..35bde34 100644
> --- a/drivers/usb/gadget/epautoconf.c
> +++ b/drivers/usb/gadget/epautoconf.c
> @@ -136,16 +136,26 @@ ep_matches (
>  	 * the usb spec fixes high speed bulk maxpacket at 512 bytes.
>  	 */
>  	max = 0x7ff & usb_endpoint_maxp(desc);
> +	
> +	if (ep->maxpacket < max)
> +		return 0;
> +	
>  	switch (type) {
> +	case USB_ENDPOINT_XFER_BULK:
> +		/* BULK:  limit 512 high/super speed */

512 high, 1024 super.

> +		if (max > 512)
> +			return 0;
> +		/* FALLTHROUGH */
> +		
>  	case USB_ENDPOINT_XFER_INT:
> -		/* INT:  limit 64 bytes full speed, 1024 high/super speed */
> +		/* BULK/INT:  limit 64 bytes full speed */
>  		if (!gadget_is_dualspeed(gadget) && max > 64)
>  			return 0;
>  		/* FALLTHROUGH */
>  
>  	case USB_ENDPOINT_XFER_ISOC:
> -		/* ISO:  limit 1023 bytes full speed, 1024 high/super speed */
> -		if (ep->maxpacket < max)
> +		/* INT/ISO:  limit 1023 bytes full speed, 1024 high/super speed */

The comment mentions INT/ISO.  But this code can also run in the BULK
case.

> +		if (max > 1024)
>  			return 0;
>  		if (!gadget_is_dualspeed(gadget) && max > 1023)
>  			return 0;

I suspect this code would become a lot clearer if all the FALLTHROUGH 
logic were eliminated and each case was handled on its own.

Alan Stern

