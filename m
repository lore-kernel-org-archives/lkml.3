Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbaCEBkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:40:40 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49632 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaCEBkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:40:37 -0500
Date: Wed, 5 Mar 2014 09:40:29 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCHv2 2/9] mfd: twl4030-madc: Add DT support and convert to
 IIO framework
Message-ID: <20140305014029.GH10579@lee--X1>
References: <1393702365-26429-1-git-send-email-sre@debian.org>
 <1393970751-18157-1-git-send-email-sre@debian.org>
 <1393970751-18157-3-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393970751-18157-3-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This converts twl4030-madc module to use the Industrial IO ADC
> framework and adds device tree support.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  drivers/mfd/twl4030-madc.c | 126 +++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 116 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
> index 5458561..0479af0 100644
> --- a/drivers/mfd/twl4030-madc.c
> +++ b/drivers/mfd/twl4030-madc.c

<snip>

 @@ -702,28 +766,50 @@ static int twl4030_madc_probe(struct platform_device *pdev)

> -	madc = devm_kzalloc(&pdev->dev, sizeof(*madc), GFP_KERNEL);
> -	if (!madc)
> +
> +	iio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*madc));
> +	if (!iio_dev) {
> +		dev_err(&pdev->dev, "failed allocating iio device\n");
>  		return -ENOMEM;
> +	}
>  
> +	madc = iio_priv(iio_dev);
>  	madc->dev = &pdev->dev;
> +	madc->use_second_irq = false;

You don't need to do this a) it will be set below and b) it's already
false since you used kzalloc() to zero the region.

<snip>

> -	madc->imr = (pdata->irq_line == 1) ?
> -	    TWL4030_MADC_IMR1 : TWL4030_MADC_IMR2;
> -	madc->isr = (pdata->irq_line == 1) ?
> -	    TWL4030_MADC_ISR1 : TWL4030_MADC_ISR2;
> +	if (pdata && pdata->irq_line != 1)
> +		madc->use_second_irq = true;
> +	else if (!pdata)
> +		madc->use_second_irq = of_property_read_bool(np,
> +				       "ti,system-uses-second-madc-irq");

How about:

	if (pdata)
		madc->use_second_irq = (pdata->irq_line != 1);
	else 
		madc->use_second_irq = of_property_read_bool(np,
					"ti,system-uses-second-madc-irq");

<snip>

> +	ret = iio_device_register(iio_dev);
> +	if (ret) {
> +		dev_dbg(&pdev->dev, "could not register iio device\n");

This should be a dev_err().

<snip>

> +#ifdef CONFIG_OF
> +static const struct of_device_id twl_madc_of_match[] = {
> +	{.compatible = "ti,twl4030-madc", },

nit: "{ .compatible"

>  static struct platform_driver twl4030_madc_driver = {
>  	.probe = twl4030_madc_probe,
>  	.remove = twl4030_madc_remove,
>  	.driver = {
>  		   .name = "twl4030_madc",
>  		   .owner = THIS_MODULE,
> +		   .of_match_table = of_match_ptr(twl_madc_of_match),
>  		   },

Also fix this please.

>  };
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
