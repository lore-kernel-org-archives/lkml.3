Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3EKKQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 06:16:09 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53639 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab3EKKQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 06:16:06 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Libo Chen <chenlibo.3@gmail.com>
Cc: ben-linux@fluff.org, kgene.kim@samsung.com, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com, libo.chen@huawei.com,
        stern@rowland.harvard.edu, akpm@linux-foundation.org
Subject: Re: [PATCH] usb: gadget: s3c2410: fix clk resource leak and update
Date: Sat, 11 May 2013 12:15:56 +0200
Message-ID: <1684189.YrZqmJjoym@flatron>
User-Agent: KMail/4.10.3 (Linux/3.9.1-gentoo-r1; KDE/4.10.3; x86_64; ; )
In-Reply-To: <518DE4FF.1000702@gmail.com>
References: <518DE4FF.1000702@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Libo,

On Saturday 11 of May 2013 14:28:15 Libo Chen wrote:
> From: Libo Chen <libo.chen@huawei.com>

The patch subject is slightly misleading. It suggests that the patch only 
changes clock handling, but in fact the biggest part of the patch is 
conversion to devm_ helpers.

I think following subject would suit this patch better:

[PATCH] usb: gadget: s3c2410: Convert to managed resource allocation

What do you think?

Also please see my comments inline.

> currently, when clk_get(NULL,"usb-device") fail, it does not
> disable && put usb_bus_clock. It is incorrect.
> 
> this patch use new interface devm_xxx instead of xxx then
> we no need to care about cleanup resource in err case that is boring
> and reduce code size.
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/usb/gadget/s3c2410_udc.c | 85
> ++++++++++++----------------------------
>  1 file changed, 25 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/usb/gadget/s3c2410_udc.c
> b/drivers/usb/gadget/s3c2410_udc.c
> old mode 100644
> new mode 100755
> index d0e75e1..0c573a8
> --- a/drivers/usb/gadget/s3c2410_udc.c
> +++ b/drivers/usb/gadget/s3c2410_udc.c
> @@ -1780,7 +1780,7 @@ static int s3c2410_udc_probe(struct
> platform_device *pdev)
> 
>  	dev_dbg(dev, "%s()\n", __func__);
> 
> -	usb_bus_clock = clk_get(NULL, "usb-bus-gadget");
> +	usb_bus_clock = devm_clk_get(NULL, "usb-bus-gadget");

Passing NULL as the dev parameter of devm_ functions is a BUG. You need to 
pass a valid pointer to struct device to them, otherwise it doesn't make 
sense - the list of allocated resources is a part of struct device.

>  	if (IS_ERR(usb_bus_clock)) {
>  		dev_err(dev, "failed to get usb bus clock source\n");
>  		return PTR_ERR(usb_bus_clock);
> @@ -1788,8 +1788,9 @@ static int s3c2410_udc_probe(struct
> platform_device *pdev)
> 
>  	clk_enable(usb_bus_clock);

If you enable this clock after allocation of all resources instead, you 
won't have to disable it manually like in following chunk:
> 
> -	udc_clock = clk_get(NULL, "usb-device");
> +	udc_clock = devm_clk_get(NULL, "usb-device");
>  	if (IS_ERR(udc_clock)) {
> +		clk_disable(usb_bus_clock);
>  		dev_err(dev, "failed to get udc clock source\n");
>  		return PTR_ERR(udc_clock);
>  	}
> @@ -1814,13 +1815,15 @@ static int s3c2410_udc_probe(struct
> platform_device *pdev)
>  	rsrc_start = S3C2410_PA_USBDEV;
>  	rsrc_len   = S3C24XX_SZ_USBDEV;
> 
> -	if (!request_mem_region(rsrc_start, rsrc_len, gadget_name))
> -		return -EBUSY;
> +	if (!devm_request_mem_region(rsrc_start, rsrc_len, gadget_name)) {
> +		retval = -EBUSY;
> +		goto out;
> +	}
> 
> -	base_addr = ioremap(rsrc_start, rsrc_len);
> +	base_addr = devm_ioremap(rsrc_start, rsrc_len);

This won't even compile... Was this patch tested at all?

See the definition of devm_ioremap:
http://lxr.free-electrons.com/source/lib/devres.c#L25

In addition, a better function is available, devm_request_and_ioremap.
(http://lxr.free-electrons.com/source/lib/devres.c#L143)

You can use it instead of calling request_mem_region and ioremap 
separately.

>  	if (!base_addr) {
>  		retval = -ENOMEM;
> -		goto err_mem;
> +		goto out;
>  	}
> 
>  	the_controller = udc;
> @@ -1830,31 +1833,31 @@ static int s3c2410_udc_probe(struct
> platform_device *pdev)
>  	s3c2410_udc_reinit(udc);
> 
>  	/* irq setup after old hardware state is cleaned up */
> -	retval = request_irq(IRQ_USBD, s3c2410_udc_irq,
> +	retval = devm_request_irq(IRQ_USBD, s3c2410_udc_irq,
>  			     0, gadget_name, udc);

This won't compile too.

>  	if (retval != 0) {
>  		dev_err(dev, "cannot get irq %i, err %d\n", IRQ_USBD, 
retval);
>  		retval = -EBUSY;
> -		goto err_map;
> +		goto out;
>  	}
> 
>  	dev_dbg(dev, "got irq %i\n", IRQ_USBD);
> 
>  	if (udc_info && udc_info->vbus_pin > 0) {
> -		retval = gpio_request(udc_info->vbus_pin, "udc vbus");
> +		retval = devm_gpio_request(udc_info->vbus_pin, "udc 
vbus");

Neither this will.

>  		if (retval < 0) {
>  			dev_err(dev, "cannot claim vbus pin\n");
> -			goto err_int;
> +			goto out;
>  		}
> 
>  		irq = gpio_to_irq(udc_info->vbus_pin);
>  		if (irq < 0) {
>  			dev_err(dev, "no irq for gpio vbus pin\n");
> -			goto err_gpio_claim;
> +			goto out;
>  		}
> 
> -		retval = request_irq(irq, s3c2410_udc_vbus_irq,
> +		retval = devm_request_irq(irq, s3c2410_udc_vbus_irq,
>  				     IRQF_TRIGGER_RISING

Neither this will.

> 
>  				     | IRQF_TRIGGER_FALLING | IRQF_SHARED,
> 
>  				     gadget_name, udc);
> @@ -1863,7 +1866,7 @@ static int s3c2410_udc_probe(struct
> platform_device *pdev)
>  			dev_err(dev, "can't get vbus irq %d, err %d\n",
>  				irq, retval);
>  			retval = -EBUSY;
> -			goto err_gpio_claim;
> +			goto out;
>  		}
> 
>  		dev_dbg(dev, "got irq %i\n", irq);
> @@ -1874,17 +1877,17 @@ static int s3c2410_udc_probe(struct
> platform_device *pdev)
>  	if (udc_info && !udc_info->udc_command &&
>  		gpio_is_valid(udc_info->pullup_pin)) {
> 
> -		retval = gpio_request_one(udc_info->pullup_pin,
> +		retval = devm_gpio_request_one(udc_info->pullup_pin,

Neither this will.

Well, this patch is a good idea, but a very poor implementation.

Please _test_ (compile and boot) your patch next time.

Best regards,
Tomasz

