Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaBKMXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:23:41 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44368 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaBKMXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:23:37 -0500
Date: Tue, 11 Feb 2014 12:23:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 6/7] mfd: max8997: Fix possible NULL pointer dereference
 on i2c_new_dummy error
Message-ID: <20140211122331.GU32042@lee--X1>
References: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
 <1392113015-11180-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392113015-11180-6-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Krzysztof Kozlowski wrote:

> During probe the driver allocates dummy I2C devices for RTC, haptic and
> MUIC with i2c_new_dummy() but it does not check the return value of this
> calls.
> 
> In case of error (i2c_new_device(): memory allocation failure or I2C
> address cannot be used) this function returns NULL which is later used
> by i2c_unregister_device().
> 
> If i2c_new_dummy() fails for RTC, haptic or MUIC devices, fail also the
> probe for main MFD driver.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mfd/max8997.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index be88a3bf7b85..3ffc11dfc3b6 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> @@ -208,10 +208,26 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>  	mutex_init(&max8997->iolock);
>  
>  	max8997->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
> +	if (!max8997->rtc) {
> +		dev_err(max8997->dev, "Failed to allocate I2C device for RTC\n");
> +		return -ENODEV;
> +	}
>  	i2c_set_clientdata(max8997->rtc, max8997);
> +
>  	max8997->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
> +	if (!max8997->haptic) {
> +		dev_err(max8997->dev, "Failed to allocate I2C device for Haptic\n");
> +		ret = -ENODEV;
> +		goto err_i2c_haptic;
> +	}
>  	i2c_set_clientdata(max8997->haptic, max8997);
> +
>  	max8997->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
> +	if (!max8997->muic) {
> +		dev_err(max8997->dev, "Failed to allocate I2C device for MUIC\n");
> +		ret = -ENODEV;
> +		goto err_i2c_muic;
> +	}
>  	i2c_set_clientdata(max8997->muic, max8997);
>  
>  	pm_runtime_set_active(max8997->dev);
> @@ -239,7 +255,9 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>  err_mfd:
>  	mfd_remove_devices(max8997->dev);
>  	i2c_unregister_device(max8997->muic);
> +err_i2c_muic:
>  	i2c_unregister_device(max8997->haptic);
> +err_i2c_haptic:
>  	i2c_unregister_device(max8997->rtc);
>  	return ret;
>  }

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
