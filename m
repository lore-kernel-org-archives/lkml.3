Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaKCR4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:56:12 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:33703 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbaKCR4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:56:08 -0500
Date: Mon, 3 Nov 2014 17:56:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 13/47] mfd: max8907: Register with kernel power-off
 handler
Message-ID: <20141103175602.GQ12011@x1>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-14-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414425354-10359-14-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Guenter Roeck wrote:

> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> only sets pm_power_off if it was not already set.
> 
> Note that this patch fixes a problem on driver unload as side effect:
> The old code did not restore or clean up pm_power_off on remove,
> meaning the pointer was left in an undefined state.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v3:
> - Replace poweroff in all newly introduced variables and in text
>   with power_off or power-off as appropriate
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> v2:
> - Use define to specify poweroff handler priority
> - Use dev_warn instead of dev_err
> 
>  drivers/mfd/max8907.c       | 24 ++++++++++++++++++------
>  include/linux/mfd/max8907.h |  2 ++
>  2 files changed, 20 insertions(+), 6 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/max8907.c b/drivers/mfd/max8907.c
> index 232749c..a159230 100644
> --- a/drivers/mfd/max8907.c
> +++ b/drivers/mfd/max8907.c
> @@ -19,6 +19,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/pm.h>
>  #include <linux/regmap.h>
>  #include <linux/slab.h>
>  
> @@ -177,11 +178,16 @@ static const struct regmap_irq_chip max8907_rtc_irq_chip = {
>  	.num_irqs = ARRAY_SIZE(max8907_rtc_irqs),
>  };
>  
> -static struct max8907 *max8907_pm_off;
> -static void max8907_power_off(void)
> +static int max8907_power_off(struct notifier_block *this, unsigned long unused1,
> +			     void *unused2)
>  {
> -	regmap_update_bits(max8907_pm_off->regmap_gen, MAX8907_REG_RESET_CNFG,
> +	struct max8907 *max8907 = container_of(this, struct max8907,
> +					       power_off_nb);
> +
> +	regmap_update_bits(max8907->regmap_gen, MAX8907_REG_RESET_CNFG,
>  			MAX8907_MASK_POWER_OFF, MAX8907_MASK_POWER_OFF);
> +
> +	return NOTIFY_DONE;
>  }
>  
>  static int max8907_i2c_probe(struct i2c_client *i2c,
> @@ -267,9 +273,13 @@ static int max8907_i2c_probe(struct i2c_client *i2c,
>  		goto err_add_devices;
>  	}
>  
> -	if (pm_off && !pm_power_off) {
> -		max8907_pm_off = max8907;
> -		pm_power_off = max8907_power_off;
> +	if (pm_off) {
> +		max8907->power_off_nb.notifier_call = max8907_power_off;
> +		max8907->power_off_nb.priority = POWER_OFF_PRIORITY_LOW;
> +		ret = register_power_off_handler(&max8907->power_off_nb);
> +		if (ret)
> +			dev_warn(&i2c->dev,
> +				 "Failed to register power-off handler");
>  	}
>  
>  	return 0;
> @@ -293,6 +303,8 @@ static int max8907_i2c_remove(struct i2c_client *i2c)
>  {
>  	struct max8907 *max8907 = i2c_get_clientdata(i2c);
>  
> +	unregister_power_off_handler(&max8907->power_off_nb);
> +
>  	mfd_remove_devices(max8907->dev);
>  
>  	regmap_del_irq_chip(max8907->i2c_gen->irq, max8907->irqc_rtc);
> diff --git a/include/linux/mfd/max8907.h b/include/linux/mfd/max8907.h
> index b06f7a6..d8a341d 100644
> --- a/include/linux/mfd/max8907.h
> +++ b/include/linux/mfd/max8907.h
> @@ -13,6 +13,7 @@
>  #define __LINUX_MFD_MAX8907_H
>  
>  #include <linux/mutex.h>
> +#include <linux/notifier.h>
>  #include <linux/pm.h>
>  
>  #define MAX8907_GEN_I2C_ADDR		(0x78 >> 1)
> @@ -247,6 +248,7 @@ struct max8907 {
>  	struct regmap_irq_chip_data	*irqc_chg;
>  	struct regmap_irq_chip_data	*irqc_on_off;
>  	struct regmap_irq_chip_data	*irqc_rtc;
> +	struct notifier_block		power_off_nb;
>  };
>  
>  #endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
