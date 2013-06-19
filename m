Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab3FSHvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:51:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49265 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab3FSHvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:51:51 -0400
Message-ID: <51C162F9.9020705@ti.com>
Date: Wed, 19 Jun 2013 10:51:21 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Chao Xie <chao.xie@marvell.com>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <xiechao.mail@gmail.com>
Subject: Re: [PATCH V2] USB: initialize or shutdown PHY when add or remove
 host controller
References: <1371609080-30595-1-git-send-email-chao.xie@marvell.com>
In-Reply-To: <1371609080-30595-1-git-send-email-chao.xie@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On 06/19/2013 05:31 AM, Chao Xie wrote:
> Some controller need software to initialize PHY before add
> host controller, and shut down PHY after remove host controller.
> Add the generic code for these controllers so they do not need
> do it in its own host controller driver.
> 
> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> ---
>  drivers/usb/core/hcd.c |   24 +++++++++++++++++++++++-
>  1 files changed, 23 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index d53547d..301c639 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -40,9 +40,11 @@
>  #include <linux/platform_device.h>
>  #include <linux/workqueue.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/err.h>
>  
>  #include <linux/usb.h>
>  #include <linux/usb/hcd.h>
> +#include <linux/usb/phy.h>
>  
>  #include "usb.h"
>  
> @@ -2531,12 +2533,26 @@ int usb_add_hcd(struct usb_hcd *hcd,
>  	 */
>  	set_bit(HCD_FLAG_RH_RUNNING, &hcd->flags);
>  
> +	/* In case hcd->phy contains the error code. */
> +	if (IS_ERR(hcd->phy))
> +		hcd->phy = NULL;
> +
> +	/* Initialize the PHY before other hardware operation. */
> +	if (hcd->phy) {
> +		retval = usb_phy_init(hcd->phy);
> +		if (retval) {
> +			dev_err(hcd->self.controller,
> +				"can't initialize phy\n");
> +			goto err_hcd_driver_setup;
> +		}
> +	}
> +
>  	/* "reset" is misnamed; its role is now one-time init. the controller
>  	 * should already have been reset (and boot firmware kicked off etc).
>  	 */
>  	if (hcd->driver->reset && (retval = hcd->driver->reset(hcd)) < 0) {
>  		dev_err(hcd->self.controller, "can't setup\n");
> -		goto err_hcd_driver_setup;
> +		goto err_hcd_driver_init_phy;
>  	}
>  	hcd->rh_pollable = 1;
>  
> @@ -2608,6 +2624,9 @@ err_hcd_driver_start:
>  	if (usb_hcd_is_primary_hcd(hcd) && hcd->irq > 0)
>  		free_irq(irqnum, hcd);
>  err_request_irq:
> +err_hcd_driver_init_phy:
> +	if (hcd->phy)
> +		usb_phy_shutdown(hcd->phy);
>  err_hcd_driver_setup:
>  err_set_rh_speed:
>  	usb_put_dev(hcd->self.root_hub);
> @@ -2674,6 +2693,9 @@ void usb_remove_hcd(struct usb_hcd *hcd)
>  			free_irq(hcd->irq, hcd);
>  	}
>  
> +	if (hcd->phy)
> +		usb_phy_shutdown(hcd->phy);
> +
>  	usb_put_dev(hcd->self.root_hub);
>  	usb_deregister_bus(&hcd->self);
>  	hcd_buffer_destroy(hcd);
> 

I still think that we shouldn't do this because it adds more confusion and is not
still a generic enough solution.

1) It is better for the piece of code that does usb_phy_get() to do usb_phy_init/shutdown,
else there will be lot of confusion. (Felipe pointed this out earlier).

2) There is no standard way of getting phy for different controllers. It is mostly platform
dependent and it is best to leave this to the controller drivers. (Pointed out by Alan).

3) Controllers can have multiple PHYs. e.g. ehci-omap has one PHY per port and it supports
3 ports. This is also platform specific and difficult to handle generically.

4) Controllers can have specific timing requirements as to when the PHY is initialized relative
to the controller being initialized. I've pointed OMAP specific stuff in the earlier patch.

Considering all these points, I think we should leave things as they are. It isn't that hard
for controllers to manage phy_init() and phy_shutdown(), and there is not much code space saved
when compared to the complexity it creates if we move them to HCD layer.

cheers,
-roger
