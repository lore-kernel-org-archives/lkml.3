Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934826AbaH0PDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:03:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53168 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934523AbaH0PDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:03:04 -0400
Date: Wed, 27 Aug 2014 11:03:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Sojka <sojka@merica.cz>
cc: linux-usb@vger.kernel.org, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.vokac@comap.cz>
Subject: Re: [PATCH v3 1/2] usb: gadget: Refactor request completion
In-Reply-To: <1409144625-25274-2-git-send-email-sojka@merica.cz>
Message-ID: <Pine.LNX.4.44L0.1408271058010.1460-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Michal Sojka wrote:

> All USB peripheral controller drivers called completion routines
> directly. This patch moves the completion call from drivers to
> usb_gadget_giveback_request(), in order to have a place where common
> functionality can be added.
> 
> All places in drivers/usb/ matching "[-.]complete(" were replaced with a
> call to usb_gadget_giveback_request(). This was compile-tested with all
> ARM drivers enabled and runtime-tested for musb.


> --- a/drivers/usb/gadget/udc/udc-core.c
> +++ b/drivers/usb/gadget/udc/udc-core.c
> @@ -102,6 +102,15 @@ void usb_gadget_unmap_request(struct usb_gadget *gadget,
>  }
>  EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
>  
> +void usb_gadget_giveback_request(struct usb_ep *ep,
> +		struct usb_request *req)
> +{
> +	/* complete() is from gadget layer,
> +	 * eg fsg->bulk_in_complete() */

Wrong format for a multi-line comment.  It should look like this:

	/*
	 * Blah, blah, blah
	 * blah, blah, blah
	 */

Also, the reference to fsg is obsolete; the File-backed Storage Gadget 
is no longer in the kernel.  You might as well leave the comment out 
entirely.

> +	if (req->complete)

This test shouldn't be here.  The UDC drivers don't do it, but they
probably do check the req->complete isn't NULL when the request is
submitted.  In any case, if req->complete is NULL then we want to know
about it because it is a bug.  It should not be covered up silently.

> +		req->complete(ep, req);
> +}
> +EXPORT_SYMBOL_GPL(usb_gadget_giveback_request);
>  #endif	/* CONFIG_HAS_DMA */

Alan Stern

