Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaFHJRA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 05:17:00 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:57242 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaFHJQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 05:16:57 -0400
Date: Sun, 8 Jun 2014 11:16:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Himangi Saraogi <himangi774@gmail.com>, Jan Andersson <jan@gaisler.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] usb: host: uhci-grlib.c : use devm_ functions
Message-ID: <20140608091630.GA19043@ravnborg.org>
References: <20140608081213.GA4387@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140608081213.GA4387@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2014 at 01:42:13PM +0530, Himangi Saraogi wrote:
> The various devm_ functions allocate memory that is released when a
> driver detaches. This patch uses devm_ioremap_resource for data
> that is allocated in the probe function of a platform device and
> is only freed in the remove function. The corresponding free functions
> are removed and two labels are done away with. Also, linux/device.h
> is added to make sure the devm_*() routine declarations are
> unambiguously available.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Included Jan Andersson (the original author) in the loop.

	Sam

> ---
>  drivers/usb/host/uhci-grlib.c | 26 +++++++-------------------
>  1 file changed, 7 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/usb/host/uhci-grlib.c b/drivers/usb/host/uhci-grlib.c
> index ab25dc3..2468fb0 100644
> --- a/drivers/usb/host/uhci-grlib.c
> +++ b/drivers/usb/host/uhci-grlib.c
> @@ -17,6 +17,7 @@
>   * (C) Copyright 2004-2007 Alan Stern, stern@rowland.harvard.edu
>   */
>  
> +#include <linux/device.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_address.h>
>  #include <linux/of_platform.h>
> @@ -113,23 +114,17 @@ static int uhci_hcd_grlib_probe(struct platform_device *op)
>  	hcd->rsrc_start = res.start;
>  	hcd->rsrc_len = resource_size(&res);
>  
> -	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
> -		printk(KERN_ERR "%s: request_mem_region failed\n", __FILE__);
> -		rv = -EBUSY;
> -		goto err_rmr;
> -	}
> -
>  	irq = irq_of_parse_and_map(dn, 0);
>  	if (irq == NO_IRQ) {
>  		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
>  		rv = -EBUSY;
> -		goto err_irq;
> +		goto err_rmr;
>  	}
>  
> -	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
> -	if (!hcd->regs) {
> -		printk(KERN_ERR "%s: ioremap failed\n", __FILE__);
> -		rv = -ENOMEM;
> +	hcd->regs = devm_ioremap_resource(&op->dev, hcd->rsrc_start,
> +					  hcd->rsrc_len);
> +	if (IS_ERR(hcd->regs)) {
> +		rv = PTR_ERR(hcd->regs);
>  		goto err_ioremap;
>  	}
>  
> @@ -139,17 +134,13 @@ static int uhci_hcd_grlib_probe(struct platform_device *op)
>  
>  	rv = usb_add_hcd(hcd, irq, 0);
>  	if (rv)
> -		goto err_uhci;
> +		goto err_ioremap;
>  
>  	device_wakeup_enable(hcd->self.controller);
>  	return 0;
>  
> -err_uhci:
> -	iounmap(hcd->regs);
>  err_ioremap:
>  	irq_dispose_mapping(irq);
> -err_irq:
> -	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
>  err_rmr:
>  	usb_put_hcd(hcd);
>  
> @@ -164,10 +155,7 @@ static int uhci_hcd_grlib_remove(struct platform_device *op)
>  
>  	usb_remove_hcd(hcd);
>  
> -	iounmap(hcd->regs);
>  	irq_dispose_mapping(hcd->irq);
> -	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
> -
>  	usb_put_hcd(hcd);
>  
>  	return 0;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
