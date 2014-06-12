Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaFLFuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 01:50:20 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:50273 "EHLO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154AbaFLFuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 01:50:17 -0400
Message-ID: <53993F61.10209@gaisler.com>
Date: Thu, 12 Jun 2014 07:49:21 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Andersson <jan@gaisler.com>
CC: julia.lawall@lip6.fr
Subject: Re: [PATCH v3] usb: host: uhci-grlib.c : use devm_ functions
References: <20140611183823.GA10519@himangi-Dell>
In-Reply-To: <20140611183823.GA10519@himangi-Dell>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-11 20:38, Himangi Saraogi wrote:
> The various devm_ functions allocate memory that is released when a
> driver detaches. This patch uses devm_ioremap_resource for data
> that is allocated in the probe function of a platform device and
> is only freed in the remove function. The corresponding free functions
> are removed and two labels are done away with. Also, linux/device.h
> is added to make sure the devm_*() routine declarations are
> unambiguously available.
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>

Looks and works fine now!

Acked-by: Andreas Larsson <andreas@gaisler.com>

Best regards,
Andreas Larsson

> ---
> Not compile tested due to incompatible architecture.
> v3: pass correct arguments to devm_ioremap_resource
>
>   drivers/usb/host/uhci-grlib.c | 31 +++++++++----------------------
>   1 file changed, 9 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/usb/host/uhci-grlib.c b/drivers/usb/host/uhci-grlib.c
> index ab25dc3..05f57ff 100644
> --- a/drivers/usb/host/uhci-grlib.c
> +++ b/drivers/usb/host/uhci-grlib.c
> @@ -17,6 +17,7 @@
>    * (C) Copyright 2004-2007 Alan Stern, stern@rowland.harvard.edu
>    */
>
> +#include <linux/device.h>
>   #include <linux/of_irq.h>
>   #include <linux/of_address.h>
>   #include <linux/of_platform.h>
> @@ -113,24 +114,17 @@ static int uhci_hcd_grlib_probe(struct platform_device *op)
>   	hcd->rsrc_start = res.start;
>   	hcd->rsrc_len = resource_size(&res);
>
> -	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
> -		printk(KERN_ERR "%s: request_mem_region failed\n", __FILE__);
> -		rv = -EBUSY;
> -		goto err_rmr;
> -	}
> -
>   	irq = irq_of_parse_and_map(dn, 0);
>   	if (irq == NO_IRQ) {
>   		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
>   		rv = -EBUSY;
> -		goto err_irq;
> +		goto err_usb;
>   	}
>
> -	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
> -	if (!hcd->regs) {
> -		printk(KERN_ERR "%s: ioremap failed\n", __FILE__);
> -		rv = -ENOMEM;
> -		goto err_ioremap;
> +	hcd->regs = devm_ioremap_resource(&op->dev, &res);
> +	if (IS_ERR(hcd->regs)) {
> +		rv = PTR_ERR(hcd->regs);
> +		goto err_irq;
>   	}
>
>   	uhci = hcd_to_uhci(hcd);
> @@ -139,18 +133,14 @@ static int uhci_hcd_grlib_probe(struct platform_device *op)
>
>   	rv = usb_add_hcd(hcd, irq, 0);
>   	if (rv)
> -		goto err_uhci;
> +		goto err_irq;
>
>   	device_wakeup_enable(hcd->self.controller);
>   	return 0;
>
> -err_uhci:
> -	iounmap(hcd->regs);
> -err_ioremap:
> -	irq_dispose_mapping(irq);
>   err_irq:
> -	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
> -err_rmr:
> +	irq_dispose_mapping(irq);
> +err_usb:
>   	usb_put_hcd(hcd);
>
>   	return rv;
> @@ -164,10 +154,7 @@ static int uhci_hcd_grlib_remove(struct platform_device *op)
>
>   	usb_remove_hcd(hcd);
>
> -	iounmap(hcd->regs);
>   	irq_dispose_mapping(hcd->irq);
> -	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
> -
>   	usb_put_hcd(hcd);
>
>   	return 0;
>
