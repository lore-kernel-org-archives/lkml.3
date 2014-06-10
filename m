Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaFJKAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:00:18 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:62879 "EHLO
	vsp-authed-04-02.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750836AbaFJKAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:00:16 -0400
Message-ID: <5396D6C4.3090301@gaisler.com>
Date: Tue, 10 Jun 2014 11:58:28 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
CC: julia.lawall@lip6.fr, "software@gaisler.com" <software@gaisler.com>
Subject: Re: [PATCH] usb: host: uhci-grlib.c : use devm_ functions
References: <20140608081213.GA4387@himangi-Dell>
In-Reply-To: <20140608081213.GA4387@himangi-Dell>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-08 10:12, Himangi Saraogi wrote:
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
> ---
>   drivers/usb/host/uhci-grlib.c | 26 +++++++-------------------
>   1 file changed, 7 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/usb/host/uhci-grlib.c b/drivers/usb/host/uhci-grlib.c
> index ab25dc3..2468fb0 100644
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
> @@ -113,23 +114,17 @@ static int uhci_hcd_grlib_probe(struct platform_device *op)
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
> +		goto err_rmr;

Getting rid of request_mem_region, you should rather rename the err_rmr 
to err_irq, to keep the original label naming pattern. Or maybe better 
yet, change naming pattern, as now two failure points are jumping to the 
same label for the second one.


>   	}
>
> -	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
> -	if (!hcd->regs) {
> -		printk(KERN_ERR "%s: ioremap failed\n", __FILE__);
> -		rv = -ENOMEM;
> +	hcd->regs = devm_ioremap_resource(&op->dev, hcd->rsrc_start,
> +					  hcd->rsrc_len);
> +	if (IS_ERR(hcd->regs)) {
> +		rv = PTR_ERR(hcd->regs);
>   		goto err_ioremap;
>   	}

This does not compile. The call to devm_ioremap_resource should rather be:

	hcd->regs = devm_ioremap_resource(&op->dev, &res);

>
> @@ -139,17 +134,13 @@ static int uhci_hcd_grlib_probe(struct platform_device *op)
>
>   	rv = usb_add_hcd(hcd, irq, 0);
>   	if (rv)
> -		goto err_uhci;
> +		goto err_ioremap;

Here the label name also does not make sense anymore.


Best regards,

Andreas Larsson
Software Engineer
Aeroflex Gaisler AB
Aeroflex Microelectronic Solutions – HiRel

>
>   	device_wakeup_enable(hcd->self.controller);
>   	return 0;
>
> -err_uhci:
> -	iounmap(hcd->regs);
>   err_ioremap:
>   	irq_dispose_mapping(irq);
> -err_irq:
> -	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
>   err_rmr:
>   	usb_put_hcd(hcd);
>
> @@ -164,10 +155,7 @@ static int uhci_hcd_grlib_remove(struct platform_device *op)
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
