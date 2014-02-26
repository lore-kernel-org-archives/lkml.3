Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaBZJ1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:27:14 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:54447 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaBZJ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:27:09 -0500
Date: Wed, 26 Feb 2014 09:26:59 +0000
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
Subject: Re: [RFCv3 2/7] mfd: twl4030-madc: Add DT support and convert to IIO
 framework
Message-ID: <20140226092659.GI9195@lee--X1>
References: <1393193271-16717-1-git-send-email-sre@debian.org>
 <1393374270-20079-1-git-send-email-sre@debian.org>
 <1393374270-20079-3-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393374270-20079-3-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This converts twl4030-madc module to use the Industrial IO ADC
> framework and adds device tree support.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  drivers/mfd/twl4030-madc.c | 122 ++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 115 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
> index 5458561..81484ee 100644
> --- a/drivers/mfd/twl4030-madc.c
> +++ b/drivers/mfd/twl4030-madc.c
> @@ -47,6 +47,8 @@
>  #include <linux/gfp.h>
>  #include <linux/err.h>
>  
> +#include <linux/iio/iio.h>
> +
>  /*
>   * struct twl4030_madc_data - a container for madc info
>   * @dev - pointer to device structure for madc
> @@ -59,10 +61,74 @@ struct twl4030_madc_data {
>  	struct device *dev;
>  	struct mutex lock;	/* mutex protecting this data structure */
>  	struct twl4030_madc_request requests[TWL4030_MADC_NUM_METHODS];
> +	bool use_second_irq;

This should go into the same patch that adds the header doc, or visa
versa.

>  	int imr;
>  	int isr;
>  };
>  
> +static int twl4030_madc_read(struct iio_dev *iio_dev,
> +			     const struct iio_chan_spec *chan,
> +			     int *val, int *val2, long mask)
> +{
> +	struct twl4030_madc_data *madc = iio_priv(iio_dev);
> +	struct twl4030_madc_request req;
> +	int channel = chan->channel;

Does this really add anything you save 6 chars.

<snip>

>  	/*
>  	 * Phoenix provides 2 interrupt lines. The first one is connected to
>  	 * the OMAP. The other one can be connected to the other processor such
>  	 * as modem. Hence two separate ISR and IMR registers.
>  	 */
> -	madc->imr = (pdata->irq_line == 1) ?
> +	if (pdata)
> +		madc->use_second_irq = pdata->irq_line != 1;

Unconventional an unclear.

Stick the comparison in the if statement.

> +	else
> +		madc->use_second_irq = of_property_read_bool(np,
> +				       "ti,system-uses-second-madc-irq");
> +
> +	madc->imr = (madc->use_second_irq == 1) ?

madc->imr = madc->use_second_irq ? <blah> : <blah>;

>  	    TWL4030_MADC_IMR1 : TWL4030_MADC_IMR2;
> -	madc->isr = (pdata->irq_line == 1) ?
> +	madc->isr = (madc->use_second_irq == 1) ?

Same here.

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
