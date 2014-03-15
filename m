Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbaCOPS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 11:18:26 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60235 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaCOPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 11:18:24 -0400
Message-ID: <53246F79.1020000@kernel.org>
Date: Sat, 15 Mar 2014 15:19:21 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Marek Belisko <marek@goldelico.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCHv2 1/9] mfd: twl4030-madc: Use managed resources
References: <1393702365-26429-1-git-send-email-sre@debian.org> <1393970751-18157-1-git-send-email-sre@debian.org> <1393970751-18157-2-git-send-email-sre@debian.org>
In-Reply-To: <1393970751-18157-2-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/14 22:05, Sebastian Reichel wrote:
> Update twl4030-madc driver to use managed resources.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>   drivers/mfd/twl4030-madc.c | 15 ++++++---------
>   1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
> index 4c583e4..5458561 100644
> --- a/drivers/mfd/twl4030-madc.c
> +++ b/drivers/mfd/twl4030-madc.c
> @@ -702,14 +702,14 @@ static int twl4030_madc_probe(struct platform_device *pdev)
>   {
>   	struct twl4030_madc_data *madc;
>   	struct twl4030_madc_platform_data *pdata = dev_get_platdata(&pdev->dev);
> -	int ret;
> +	int irq, ret;
>   	u8 regval;
>
>   	if (!pdata) {
>   		dev_err(&pdev->dev, "platform_data not available\n");
>   		return -EINVAL;
>   	}
> -	madc = kzalloc(sizeof(*madc), GFP_KERNEL);
> +	madc = devm_kzalloc(&pdev->dev, sizeof(*madc), GFP_KERNEL);
>   	if (!madc)
>   		return -ENOMEM;
>
> @@ -726,7 +726,7 @@ static int twl4030_madc_probe(struct platform_device *pdev)
>   	    TWL4030_MADC_ISR1 : TWL4030_MADC_ISR2;
>   	ret = twl4030_madc_set_power(madc, 1);
>   	if (ret < 0)
> -		goto err_power;
> +		return ret;
>   	ret = twl4030_madc_set_current_generator(madc, 0, 1);
>   	if (ret < 0)
>   		goto err_current_generator;
> @@ -770,7 +770,9 @@ static int twl4030_madc_probe(struct platform_device *pdev)
>
>   	platform_set_drvdata(pdev, madc);
>   	mutex_init(&madc->lock);
> -	ret = request_threaded_irq(platform_get_irq(pdev, 0), NULL,
> +
> +	irq = platform_get_irq(pdev, 0);
> +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
>   				   twl4030_madc_threaded_irq_handler,
>   				   IRQF_TRIGGER_RISING, "twl4030_madc", madc);
>   	if (ret) {
> @@ -783,9 +785,6 @@ err_i2c:
>   	twl4030_madc_set_current_generator(madc, 0, 0);
>   err_current_generator:
>   	twl4030_madc_set_power(madc, 0);
> -err_power:
> -	kfree(madc);
> -
>   	return ret;
>   }
>
> @@ -793,10 +792,8 @@ static int twl4030_madc_remove(struct platform_device *pdev)
>   {
>   	struct twl4030_madc_data *madc = platform_get_drvdata(pdev);
>
> -	free_irq(platform_get_irq(pdev, 0), madc);
>   	twl4030_madc_set_current_generator(madc, 0, 0);
>   	twl4030_madc_set_power(madc, 0);
> -	kfree(madc);
>
>   	return 0;
>   }
>

