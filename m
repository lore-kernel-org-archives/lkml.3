Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaKCR43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:56:29 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:57922 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbaKCR4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:56:23 -0500
Date: Mon, 3 Nov 2014 17:56:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 11/47] mfd: retu: Register with kernel power-off
 handler
Message-ID: <20141103175616.GR12011@x1>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-12-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414425354-10359-12-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Guenter Roeck wrote:

> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> only sets pm_power_off if it was not already set.
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
> - Use devm_register_power_off_handler
> - Use dev_warn instead of dev_err
> 
>  drivers/mfd/retu-mfd.c | 33 +++++++++++++++++++--------------
>  1 file changed, 19 insertions(+), 14 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/retu-mfd.c b/drivers/mfd/retu-mfd.c
> index 663f8a3..7c657e6 100644
> --- a/drivers/mfd/retu-mfd.c
> +++ b/drivers/mfd/retu-mfd.c
> @@ -22,6 +22,8 @@
>  #include <linux/slab.h>
>  #include <linux/mutex.h>
>  #include <linux/module.h>
> +#include <linux/notifier.h>
> +#include <linux/pm.h>
>  #include <linux/regmap.h>
>  #include <linux/mfd/core.h>
>  #include <linux/mfd/retu.h>
> @@ -43,6 +45,7 @@ struct retu_dev {
>  	struct device			*dev;
>  	struct mutex			mutex;
>  	struct regmap_irq_chip_data	*irq_data;
> +	struct notifier_block		power_off_nb;
>  };
>  
>  static struct resource retu_pwrbutton_res[] = {
> @@ -81,9 +84,6 @@ static struct regmap_irq_chip retu_irq_chip = {
>  	.ack_base	= RETU_REG_IDR,
>  };
>  
> -/* Retu device registered for the power off. */
> -static struct retu_dev *retu_pm_power_off;
> -
>  static struct resource tahvo_usb_res[] = {
>  	{
>  		.name	= "tahvo-usb",
> @@ -165,12 +165,14 @@ int retu_write(struct retu_dev *rdev, u8 reg, u16 data)
>  }
>  EXPORT_SYMBOL_GPL(retu_write);
>  
> -static void retu_power_off(void)
> +static int retu_power_off(struct notifier_block *this, unsigned long unused1,
> +			  void *unused2)
>  {
> -	struct retu_dev *rdev = retu_pm_power_off;
> +	struct retu_dev *rdev = container_of(this, struct retu_dev,
> +					     power_off_nb);
>  	int reg;
>  
> -	mutex_lock(&retu_pm_power_off->mutex);
> +	mutex_lock(&rdev->mutex);
>  
>  	/* Ignore power button state */
>  	regmap_read(rdev->regmap, RETU_REG_CC1, &reg);
> @@ -183,7 +185,9 @@ static void retu_power_off(void)
>  	for (;;)
>  		cpu_relax();
>  
> -	mutex_unlock(&retu_pm_power_off->mutex);
> +	mutex_unlock(&rdev->mutex);
> +
> +	return NOTIFY_DONE;
>  }
>  
>  static int retu_regmap_read(void *context, const void *reg, size_t reg_size,
> @@ -279,9 +283,14 @@ static int retu_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>  		return ret;
>  	}
>  
> -	if (i2c->addr == 1 && !pm_power_off) {
> -		retu_pm_power_off = rdev;
> -		pm_power_off	  = retu_power_off;
> +	if (i2c->addr == 1) {
> +		rdev->power_off_nb.notifier_call = retu_power_off;
> +		rdev->power_off_nb.priority = POWER_OFF_PRIORITY_LOW;
> +		ret = devm_register_power_off_handler(rdev->dev,
> +						      &rdev->power_off_nb);
> +		if (ret)
> +			dev_warn(rdev->dev,
> +				 "Failed to register power-off handler\n");
>  	}
>  
>  	return 0;
> @@ -291,10 +300,6 @@ static int retu_remove(struct i2c_client *i2c)
>  {
>  	struct retu_dev *rdev = i2c_get_clientdata(i2c);
>  
> -	if (retu_pm_power_off == rdev) {
> -		pm_power_off	  = NULL;
> -		retu_pm_power_off = NULL;
> -	}
>  	mfd_remove_devices(rdev->dev);
>  	regmap_del_irq_chip(i2c->irq, rdev->irq_data);
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
