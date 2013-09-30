Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3I3Oea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:34:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43742 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753681Ab3I3Oe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:34:28 -0400
Date: Mon, 30 Sep 2013 10:34:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Robert Baldyga <r.baldyga@samsung.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>
Subject: Re: [PATCH v2] USB: gadget: epautoconf: fix ep maxpacket check
In-Reply-To: <1380534260-24162-1-git-send-email-r.baldyga@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1309301030110.1352-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Sep 2013, Robert Baldyga wrote:

> Hello,
> This is update for my patch fixing maxpacket check in epautoconfig. Now code
> is better arranged for clearity and take into account super speed devices,
> as Alan Stern suggested.
> 
> This patch fixes validation of maxpacket value given in endpoint descriptor.
> Added check of maxpacket for bulk endpoints.
> 
> Correct maxpacket value is:
> 
>              FULL-SPEED  HIGH-SPEED  SUPER-SPEED
> BULK         64          512         1024
> INTERRUPT    64          1024        1024
> ISOCHRONOUS  1023        1024        1024
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> 
> Changelog:
> 
> v2:
> - arrange code for clearity
> - fix support for super speed devices
> 
> v1: https://lkml.org/lkml/2013/9/27/127
> ---
>  drivers/usb/gadget/epautoconf.c |   54 +++++++++++++++++++++++++++++++--------
>  1 file changed, 43 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
> index a777f7b..2daf3ba 100644
> --- a/drivers/usb/gadget/epautoconf.c
> +++ b/drivers/usb/gadget/epautoconf.c
> @@ -136,25 +136,57 @@ ep_matches (
>  	 * the usb spec fixes high speed bulk maxpacket at 512 bytes.
>  	 */
>  	max = 0x7ff & usb_endpoint_maxp(desc);
> +
> +	if (ep->maxpacket < max)
> +		return 0;
> +
>  	switch (type) {
> -	case USB_ENDPOINT_XFER_INT:
> -		/* INT:  limit 64 bytes full speed, 1024 high/super speed */
> +	case USB_ENDPOINT_XFER_BULK:
> +		/*
> +		 * LIMITS:
> +		 * full speed:    64 bytes
> +		 * high speed:   512 bytes
> +		 * super speed: 1024 bytes
> +		 */
> +		if (max > 1024)
> +			return 0;
> +		if (!gadget_is_superspeed(gadget) && max > 512)
> +			return 0;

You might be able to do better than this.  For high speed, the bulk 
maxpacket size must be exactly 512, and for SuperSpeed it must be 
exactly 1024.

(With full speed, by contrast, it can be 8, 16, 32, or 64.)

>  		if (!gadget_is_dualspeed(gadget) && max > 64)
>  			return 0;
> -		/* FALLTHROUGH */
> +		break;
>  
> -	case USB_ENDPOINT_XFER_ISOC:
> -		/* ISO:  limit 1023 bytes full speed, 1024 high/super speed */
> -		if (ep->maxpacket < max)
> +	case USB_ENDPOINT_XFER_INT:
> +		/*
> +		 * LIMITS:
> +		 * full speed:		64 bytes
> +		 * high/super speed:  1024 bytes
> +		 * multiple transactions per microframe only for super speed

No, high speed allows up to 3 transactions per microframe.

Alan Stern

