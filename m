Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaLOQPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:15:00 -0500
Received: from netrider.rowland.org ([192.131.102.5]:34902 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750777AbaLOQO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:14:57 -0500
Date: Mon, 15 Dec 2014 11:14:55 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Robert Baldyga <r.baldyga@samsung.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <peter.chen@freescale.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <m.szyprowski@samsung.com>, <k.opasiak@samsung.com>
Subject: Re: [PATCH] usb: gadget: udc-core: call udc_stop() before gadget
 unbind
In-Reply-To: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1412151112150.27915-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2014, Robert Baldyga wrote:

> As usb function drivers assumes that all usb request will be completed
> before function unbind call, we should supply such behavior. In some
> cases ep_disable() won't kill all request effectively, because some
> IN requests can be in running state. In such situation it's possible
> to have unbind function called before last request completion, which
> can cause problems.
> 
> For example unbinding f_ecm function while request on 'notify' endpoint
> is not completed, ends up NULL pointer dereference in unbind() function.
> 
> usb_gadget_udc_stop() call causes completion of all requests so if it's
> called before gadget unbind there is no risk that some of requests will
> stay uncompleted.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/usb/gadget/udc/udc-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
> index e31d574..6f0d233 100644
> --- a/drivers/usb/gadget/udc/udc-core.c
> +++ b/drivers/usb/gadget/udc/udc-core.c
> @@ -331,8 +331,8 @@ static void usb_gadget_remove_driver(struct usb_udc *udc)
>  
>  	usb_gadget_disconnect(udc->gadget);
>  	udc->driver->disconnect(udc->gadget);
> -	udc->driver->unbind(udc->gadget);
>  	usb_gadget_udc_stop(udc);
> +	udc->driver->unbind(udc->gadget);
>  
>  	udc->driver = NULL;
>  	udc->dev.driver = NULL;

There has been a lot of churn and a lot of bug fixes involving those
lines of code.  Have you checked the git log for this function?  It's
quite possible that interchanging those two statements will recreate a
bug that has already been fixed.

Alan Stern

