Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaKCRzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:55:03 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:43834 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaKCRy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:54:58 -0500
Date: Mon, 3 Nov 2014 17:54:53 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 16/47] mfd: tps6586x: Register with kernel power-off
 handler
Message-ID: <20141103175453.GM12011@x1>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-17-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414425354-10359-17-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Guenter Roeck wrote:

> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> only sets pm_power_off if it was not already set.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
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
>  drivers/mfd/tps6586x.c | 31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
> index 8e1dbc4..1e97478 100644
> --- a/drivers/mfd/tps6586x.c
> +++ b/drivers/mfd/tps6586x.c
> @@ -21,10 +21,12 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/notifier.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/i2c.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm.h>
>  #include <linux/regmap.h>
>  #include <linux/of.h>
>  
> @@ -133,6 +135,8 @@ struct tps6586x {
>  	u32			irq_en;
>  	u8			mask_reg[5];
>  	struct irq_domain	*irq_domain;
> +
> +	struct notifier_block	power_off_nb;
>  };
>  
>  static inline struct tps6586x *dev_to_tps6586x(struct device *dev)
> @@ -472,13 +476,18 @@ static const struct regmap_config tps6586x_regmap_config = {
>  	.cache_type = REGCACHE_RBTREE,
>  };
>  
> -static struct device *tps6586x_dev;
> -static void tps6586x_power_off(void)
> +static int tps6586x_power_off(struct notifier_block *this,
> +			      unsigned long unused1, void *unused2)
>  {
> -	if (tps6586x_clr_bits(tps6586x_dev, TPS6586X_SUPPLYENE, EXITSLREQ_BIT))
> -		return;
> +	struct tps6586x *tps6586x = container_of(this, struct tps6586x,
> +						 power_off_nb);
> +
> +	if (tps6586x_clr_bits(tps6586x->dev, TPS6586X_SUPPLYENE, EXITSLREQ_BIT))
> +		return NOTIFY_DONE;
>  
> -	tps6586x_set_bits(tps6586x_dev, TPS6586X_SUPPLYENE, SLEEP_MODE_BIT);
> +	tps6586x_set_bits(tps6586x->dev, TPS6586X_SUPPLYENE, SLEEP_MODE_BIT);
> +
> +	return NOTIFY_DONE;
>  }
>  
>  static void tps6586x_print_version(struct i2c_client *client, int version)
> @@ -575,9 +584,13 @@ static int tps6586x_i2c_probe(struct i2c_client *client,
>  		goto err_add_devs;
>  	}
>  
> -	if (pdata->pm_off && !pm_power_off) {
> -		tps6586x_dev = &client->dev;
> -		pm_power_off = tps6586x_power_off;
> +	if (pdata->pm_off) {
> +		tps6586x->power_off_nb.notifier_call = tps6586x_power_off;
> +		tps6586x->power_off_nb.priority = POWER_OFF_PRIORITY_LOW;
> +		ret = register_power_off_handler(&tps6586x->power_off_nb);
> +		if (ret)
> +			dev_warn(&client->dev,
> +				 "failed to register power-off handler\n");
>  	}
>  
>  	return 0;
> @@ -594,6 +607,8 @@ static int tps6586x_i2c_remove(struct i2c_client *client)
>  {
>  	struct tps6586x *tps6586x = i2c_get_clientdata(client);
>  
> +	unregister_power_off_handler(&tps6586x->power_off_nb);
> +
>  	tps6586x_remove_subdevs(tps6586x);
>  	mfd_remove_devices(tps6586x->dev);
>  	if (client->irq)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
