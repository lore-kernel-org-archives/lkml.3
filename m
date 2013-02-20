Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263Ab3BTHhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:37:09 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38125 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933891Ab3BTHhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:37:07 -0500
Date: Tue, 19 Feb 2013 23:37:04 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] mfd: twl6040: use devm_gpio_request_one() and
 devm_request_threaded_irq()
Message-ID: <20130220073704.GE2648@core.coreip.homeip.net>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
 <002a01ce0f31$24e5fef0$6eb1fcd0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002a01ce0f31$24e5fef0$6eb1fcd0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On Wed, Feb 20, 2013 at 03:11:38PM +0900, Jingoo Han wrote:
> Use devm_gpio_request_one() and devm_request_threaded_irq() to make
> cleanup paths and  more simple.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/twl6040.c |   26 +++++++-------------------
>  1 files changed, 7 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
> index f361bf3..2d38512 100644
> --- a/drivers/mfd/twl6040.c
> +++ b/drivers/mfd/twl6040.c
> @@ -586,8 +586,8 @@ static int twl6040_probe(struct i2c_client *client,
>  		twl6040->audpwron = -EINVAL;
>  
>  	if (gpio_is_valid(twl6040->audpwron)) {
> -		ret = gpio_request_one(twl6040->audpwron, GPIOF_OUT_INIT_LOW,
> -				       "audpwron");
> +		ret = devm_gpio_request_one(twl6040->dev, twl6040->audpwron,
> +					GPIOF_OUT_INIT_LOW, "audpwron");
>  		if (ret)
>  			goto gpio_err;
>  	}
> @@ -596,14 +596,14 @@ static int twl6040_probe(struct i2c_client *client,
>  			IRQF_ONESHOT, 0, &twl6040_irq_chip,
>  			&twl6040->irq_data);
>  	if (ret < 0)
> -		goto irq_init_err;
> +		goto gpio_err;
>  
>  	twl6040->irq_ready = regmap_irq_get_virq(twl6040->irq_data,
>  					       TWL6040_IRQ_READY);
>  	twl6040->irq_th = regmap_irq_get_virq(twl6040->irq_data,
>  					       TWL6040_IRQ_TH);
>  
> -	ret = request_threaded_irq(twl6040->irq_ready, NULL,
> +	ret = devm_request_threaded_irq(twl6040->dev, twl6040->irq_ready, NULL,
>  				   twl6040_readyint_handler, IRQF_ONESHOT,
>  				   "twl6040_irq_ready", twl6040);
>  	if (ret) {
> @@ -611,12 +611,12 @@ static int twl6040_probe(struct i2c_client *client,
>  		goto readyirq_err;
>  	}
>  
> -	ret = request_threaded_irq(twl6040->irq_th, NULL,
> +	ret = devm_request_threaded_irq(twl6040->dev, twl6040->irq_th, NULL,
>  				   twl6040_thint_handler, IRQF_ONESHOT,
>  				   "twl6040_irq_th", twl6040);
>  	if (ret) {
>  		dev_err(twl6040->dev, "Thermal IRQ request failed: %d\n", ret);
> -		goto thirq_err;
> +		goto readyirq_err;
>  	}
>  
>  	/* dual-access registers controlled by I2C only */
> @@ -676,19 +676,12 @@ static int twl6040_probe(struct i2c_client *client,
>  	ret = mfd_add_devices(&client->dev, -1, twl6040->cells, children,
>  			      NULL, 0, NULL);
>  	if (ret)
> -		goto mfd_err;
> +		goto readyirq_err;
>  
>  	return 0;
>  
> -mfd_err:
> -	free_irq(twl6040->irq_th, twl6040);
> -thirq_err:
> -	free_irq(twl6040->irq_ready, twl6040);
>  readyirq_err:
>  	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
> -irq_init_err:
> -	if (gpio_is_valid(twl6040->audpwron))
> -		gpio_free(twl6040->audpwron);
>  gpio_err:
>  	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
>  power_err:
> @@ -706,11 +699,6 @@ static int twl6040_remove(struct i2c_client *client)
>  	if (twl6040->power_count)
>  		twl6040_power(twl6040, 0);
>  
> -	if (gpio_is_valid(twl6040->audpwron))
> -		gpio_free(twl6040->audpwron);
> -
> -	free_irq(twl6040->irq_ready, twl6040);
> -	free_irq(twl6040->irq_th, twl6040);
>  	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
>  
>  	mfd_remove_devices(&client->dev);

Are you sure it is OK to have sub-devices removed and regmap destroyed
with IRQs still active?

Thanks.

-- 
Dmitry
