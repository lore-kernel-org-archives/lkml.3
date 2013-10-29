Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3J2Ilk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:41:40 -0400
Received: from canardo.mork.no ([148.122.252.1]:43832 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab3J2Ilh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:41:37 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Du\, ChangbinX" <changbinx.du@intel.com>
Cc: "oliver\@neukum.org" <oliver@neukum.org>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/cdc_ncm: fix null pointer panic at usbnet_link_change
Organization: m
References: <0C18FE92A7765D4EB9EE5D38D86A563A019F450F@SHSMSX103.ccr.corp.intel.com>
Date: Tue, 29 Oct 2013 09:41:26 +0100
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A019F450F@SHSMSX103.ccr.corp.intel.com>
	(ChangbinX Du's message of "Tue, 29 Oct 2013 03:30:42 +0000")
Message-ID: <87wqkwii4p.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Du, ChangbinX" <changbinx.du@intel.com> writes:

> From: "Du, Changbin" <changbinx.du@intel.com>
>
> In cdc_ncm_bind() function, it call cdc_ncm_bind_common() to setup usb.
> But cdc_ncm_bind_common() may meet error and cause usbnet_disconnect()
> be called which calls free_netdev(net).

I am sure you are right, but I really don't see how that can happen.

AFAICS, we ensure that the intfdata is set to NULL before calling 
usb_driver_release_interface() in the error cleanup in 
cdc_ncm_bind_common():


error2:
	usb_set_intfdata(ctx->control, NULL);
	usb_set_intfdata(ctx->data, NULL);
	if (ctx->data != ctx->control)
		usb_driver_release_interface(driver, ctx->data);
error:
	cdc_ncm_free((struct cdc_ncm_ctx *)dev->data[0]);
	dev->data[0] = 0;
	dev_info(&dev->udev->dev, "bind() failure\n");
	return -ENODEV;


Thus we hit the test in disconnect, and usbnet_disconnect() is never
called:

static void cdc_ncm_disconnect(struct usb_interface *intf)
{
	struct usbnet *dev = usb_get_intfdata(intf);

	if (dev == NULL)
		return;		/* already disconnected */

	usbnet_disconnect(intf);
}



So we should really be OK, but we are not????  I would appreciate it if
anyone took the time to feed me why, with a very small spoon...



> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 43afde8..af37ecf 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -603,14 +603,15 @@ static int cdc_ncm_bind(struct usbnet *dev, struct usb_interface *intf)
>  
>  	/* NCM data altsetting is always 1 */
>  	ret = cdc_ncm_bind_common(dev, intf, 1);
> -
> -	/*
> -	 * We should get an event when network connection is "connected" or
> -	 * "disconnected". Set network connection in "disconnected" state
> -	 * (carrier is OFF) during attach, so the IP network stack does not
> -	 * start IPv6 negotiation and more.
> -	 */
> -	usbnet_link_change(dev, 0, 0);
> +	if (!ret) {
> +		/*
> +		 * We should get an event when network connection is "connected"
> +		 * or "disconnected". Set network connection in "disconnected"
> +		 * state (carrier is OFF) during attach, so the IP network stack
> +		 * does not start IPv6 negotiation and more.
> +		 */
> +		usbnet_link_change(dev, 0, 0);
> +	}
>  	return ret;
>  }

This change does of course make sense in any case, so no objections
there.  But maybe you could modify cdc_ncm to set the new FLAG_LINK_INTR
instead, and completely drop the usbnet_link_change() from this driver?
This will make usbnet_probe() handle the call, and it will avoid it if
cdc_ncm_bind() failed.



Bjørn
