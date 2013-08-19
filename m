Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230Ab3HSSPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:15:36 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53024 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3HSSPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:15:33 -0400
Message-ID: <52126ED5.3040702@kernel.org>
Date: Mon, 19 Aug 2013 20:15:33 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
CC: jic23@cam.ac.uk, gg@slimlogic.co.uk, balajitk@ti.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: adc: twl6030-gpadc: Use devm_* API family
References: <1376910580-7545-1-git-send-email-oleksandr.kozaruk@ti.com>
In-Reply-To: <1376910580-7545-1-git-send-email-oleksandr.kozaruk@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/13 12:09, Oleksandr Kozaruk wrote:
> Using devm_iio_device_alloc and devm_request_threaded_irq makes
> code simpler.
> 
> Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
Applied to the togreg branch of iio.git

Thanks,

Jonathan
> ---
>  drivers/iio/adc/twl6030-gpadc.c | 36 ++++++++++--------------------------
>  1 file changed, 10 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
> index a80a049..a558516 100644
> --- a/drivers/iio/adc/twl6030-gpadc.c
> +++ b/drivers/iio/adc/twl6030-gpadc.c
> @@ -893,11 +893,9 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
>  
>  	pdata = match->data;
>  
> -	indio_dev = iio_device_alloc(sizeof(*gpadc));
> -	if (!indio_dev) {
> -		dev_err(dev, "failed allocating iio device\n");
> -		ret = -ENOMEM;
> -	}
> +	indio_dev = devm_iio_device_alloc(dev, sizeof(*gpadc));
> +	if (!indio_dev)
> +		return -ENOMEM;
>  
>  	gpadc = iio_priv(indio_dev);
>  
> @@ -905,7 +903,7 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
>  					sizeof(*gpadc->twl6030_cal_tbl) *
>  					pdata->nchannels, GFP_KERNEL);
>  	if (!gpadc->twl6030_cal_tbl)
> -		goto err_free_device;
> +		return -ENOMEM;
>  
>  	gpadc->dev = dev;
>  	gpadc->pdata = pdata;
> @@ -917,33 +915,30 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
>  	ret = pdata->calibrate(gpadc);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to read calibration registers\n");
> -		goto err_free_device;
> +		return ret;
>  	}
>  
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0) {
>  		dev_err(&pdev->dev, "failed to get irq\n");
> -		goto err_free_device;
> +		return irq;
>  	}
>  
> -	ret = request_threaded_irq(irq, NULL, twl6030_gpadc_irq_handler,
> +	ret = devm_request_threaded_irq(dev, irq, NULL,
> +				twl6030_gpadc_irq_handler,
>  				IRQF_ONESHOT, "twl6030_gpadc", indio_dev);
> -	if (ret) {
> -		dev_dbg(&pdev->dev, "could not request irq\n");
> -		goto err_free_device;
> -	}
>  
>  	ret = twl6030_gpadc_enable_irq(TWL6030_GPADC_RT_SW1_EOC_MASK);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to enable GPADC interrupt\n");
> -		goto err_free_irq;
> +		return ret;
>  	}
>  
>  	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, TWL6030_GPADCS,
>  					TWL6030_REG_TOGGLE1);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to enable GPADC module\n");
> -		goto err_free_irq;
> +		return ret;
>  	}
>  
>  	indio_dev->name = DRIVER_NAME;
> @@ -954,15 +949,6 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
>  	indio_dev->num_channels = pdata->nchannels;
>  
>  	ret = iio_device_register(indio_dev);
> -	if (ret)
> -		goto err_free_irq;
> -
> -	return ret;
> -
> -err_free_irq:
> -	free_irq(irq, indio_dev);
> -err_free_device:
> -	iio_device_free(indio_dev);
>  
>  	return ret;
>  }
> @@ -972,9 +958,7 @@ static int twl6030_gpadc_remove(struct platform_device *pdev)
>  	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
>  
>  	twl6030_gpadc_disable_irq(TWL6030_GPADC_RT_SW1_EOC_MASK);
> -	free_irq(platform_get_irq(pdev, 0), indio_dev);
>  	iio_device_unregister(indio_dev);
> -	iio_device_free(indio_dev);
>  
>  	return 0;
>  }
> 
