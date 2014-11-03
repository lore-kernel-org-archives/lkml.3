Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaKCRyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:54:24 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61899 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaKCRyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:54:21 -0500
Date: Mon, 3 Nov 2014 17:54:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 20/47] mfd: rn5t618: Register power-off handler with
 kernel power-off handler
Message-ID: <20141103175413.GJ12011@x1>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-21-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414425354-10359-21-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Guenter Roeck wrote:

> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> only sets pm_power_off if it was not already set.
> 
> Cc: Beniamino Galvani <b.galvani@gmail.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v3:
> - Replace poweroff in all newly introduced variables and in text
>   with power_off or power-off as appropriate
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> v2:
> - New patch
> 
>  drivers/mfd/rn5t618.c       | 32 ++++++++++++++++----------------
>  include/linux/mfd/rn5t618.h |  2 ++
>  2 files changed, 18 insertions(+), 16 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/rn5t618.c b/drivers/mfd/rn5t618.c
> index 6668571..ed564d1 100644
> --- a/drivers/mfd/rn5t618.c
> +++ b/drivers/mfd/rn5t618.c
> @@ -15,6 +15,8 @@
>  #include <linux/mfd/core.h>
>  #include <linux/mfd/rn5t618.h>
>  #include <linux/module.h>
> +#include <linux/notifier.h>
> +#include <linux/pm.h>
>  #include <linux/regmap.h>
>  
>  static const struct mfd_cell rn5t618_cells[] = {
> @@ -47,16 +49,20 @@ static const struct regmap_config rn5t618_regmap_config = {
>  	.cache_type	= REGCACHE_RBTREE,
>  };
>  
> -static struct rn5t618 *rn5t618_pm_power_off;
> -
> -static void rn5t618_power_off(void)
> +static int rn5t618_power_off(struct notifier_block *this,
> +			     unsigned long unused1, void *unused2)
>  {
> +	struct rn5t618 *rn5t618 = container_of(this, struct rn5t618,
> +					       power_off_nb);
> +
>  	/* disable automatic repower-on */
> -	regmap_update_bits(rn5t618_pm_power_off->regmap, RN5T618_REPCNT,
> +	regmap_update_bits(rn5t618->regmap, RN5T618_REPCNT,
>  			   RN5T618_REPCNT_REPWRON, 0);
>  	/* start power-off sequence */
> -	regmap_update_bits(rn5t618_pm_power_off->regmap, RN5T618_SLPCNT,
> +	regmap_update_bits(rn5t618->regmap, RN5T618_SLPCNT,
>  			   RN5T618_SLPCNT_SWPWROFF, RN5T618_SLPCNT_SWPWROFF);
> +
> +	return NOTIFY_DONE;
>  }
>  
>  static int rn5t618_i2c_probe(struct i2c_client *i2c,
> @@ -85,23 +91,17 @@ static int rn5t618_i2c_probe(struct i2c_client *i2c,
>  		return ret;
>  	}
>  
> -	if (!pm_power_off) {
> -		rn5t618_pm_power_off = priv;
> -		pm_power_off = rn5t618_power_off;
> -	}
> +	priv->power_off_nb.notifier_call = rn5t618_power_off;
> +	priv->power_off_nb.priority = POWER_OFF_PRIORITY_LOW;
> +	ret = devm_register_power_off_handler(&i2c->dev, &priv->power_off_nb);
> +	if (ret)
> +		dev_warn(&i2c->dev, "Failed to register power-off handler\n");
>  
>  	return 0;
>  }
>  
>  static int rn5t618_i2c_remove(struct i2c_client *i2c)
>  {
> -	struct rn5t618 *priv = i2c_get_clientdata(i2c);
> -
> -	if (priv == rn5t618_pm_power_off) {
> -		rn5t618_pm_power_off = NULL;
> -		pm_power_off = NULL;
> -	}
> -
>  	mfd_remove_devices(&i2c->dev);
>  	return 0;
>  }
> diff --git a/include/linux/mfd/rn5t618.h b/include/linux/mfd/rn5t618.h
> index c72d534..21c9c39 100644
> --- a/include/linux/mfd/rn5t618.h
> +++ b/include/linux/mfd/rn5t618.h> @@ -14,6 +14,7 @@
>  #ifndef __LINUX_MFD_RN5T618_H
>  #define __LINUX_MFD_RN5T618_H
>  
> +#include <linux/notifier.h>
>  #include <linux/regmap.h>
>  
>  #define RN5T618_LSIVER			0x00
> @@ -223,6 +224,7 @@ enum {
>  
>  struct rn5t618 {
>  	struct regmap *regmap;
> +	struct notifier_block power_off_nb;
>  };
>  
>  #endif /* __LINUX_MFD_RN5T618_H */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
