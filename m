Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaBKMXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:23:25 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:42613 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaBKMXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:23:20 -0500
Date: Tue, 11 Feb 2014 12:23:14 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 5/7] mfd: max8925: Fix possible NULL pointer dereference
 on i2c_new_dummy error
Message-ID: <20140211122314.GT32042@lee--X1>
References: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
 <1392113015-11180-5-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392113015-11180-5-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Krzysztof Kozlowski wrote:

> During probe the driver allocates dummy I2C devices for RTC and ADC
> with i2c_new_dummy() but it does not check the return value of this
> calls.
> 
> In case of error (i2c_new_device(): memory allocation failure or I2C
> address cannot be used) this function returns NULL which is later used
> by i2c_unregister_device().
> 
> If i2c_new_dummy() fails for RTC or ADC devices, fail also the probe
> for main MFD driver.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mfd/max8925-i2c.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
> index 176aa26fc787..a83eed5c15ca 100644
> --- a/drivers/mfd/max8925-i2c.c
> +++ b/drivers/mfd/max8925-i2c.c
> @@ -181,9 +181,18 @@ static int max8925_probe(struct i2c_client *client,
>  	mutex_init(&chip->io_lock);
>  
>  	chip->rtc = i2c_new_dummy(chip->i2c->adapter, RTC_I2C_ADDR);
> +	if (!chip->rtc) {
> +		dev_err(chip->dev, "Failed to allocate I2C device for RTC\n");
> +		return -ENODEV;
> +	}
>  	i2c_set_clientdata(chip->rtc, chip);
>  
>  	chip->adc = i2c_new_dummy(chip->i2c->adapter, ADC_I2C_ADDR);
> +	if (!chip->adc) {
> +		dev_err(chip->dev, "Failed to allocate I2C device for ADC\n");
> +		i2c_unregister_device(chip->rtc);
> +		return -ENODEV;
> +	}
>  	i2c_set_clientdata(chip->adc, chip);
>  
>  	device_init_wakeup(&client->dev, 1);

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
