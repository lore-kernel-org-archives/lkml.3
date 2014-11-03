Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaKCRxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:53:55 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:65054 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaKCRxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:53:53 -0500
Date: Mon, 3 Nov 2014 17:53:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Chris Zhong <zyw@rock-chips.com>,
        Zhang Qing <zhangqing@rock-chips.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 19/47] mfd: rk808: Register power-off handler with
 kernel power-off handler
Message-ID: <20141103175346.GI12011@x1>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-20-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414425354-10359-20-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Guenter Roeck wrote:

> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> only sets pm_power_off if it was not already set.
> 
> Cc: Chris Zhong <zyw@rock-chips.com>
> Cc: Zhang Qing <zhangqing@rock-chips.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v3:
> - Replace poweroff in all newly introduced variables and in text
>   with power_off or power-off as appropriate
> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> v2:
> - New patch
> 
>  drivers/mfd/rk808.c       | 30 ++++++++++++++++--------------
>  include/linux/mfd/rk808.h |  2 ++
>  2 files changed, 18 insertions(+), 14 deletions(-)

Code looks okay:

Acked-by: Lee Jones <lee.jones@linaro.org>

... but how are you thinking about handling this set?

> diff --git a/drivers/mfd/rk808.c b/drivers/mfd/rk808.c
> index bd02150..5d5257d 100644
> --- a/drivers/mfd/rk808.c
> +++ b/drivers/mfd/rk808.c
> @@ -21,6 +21,8 @@
>  #include <linux/mfd/rk808.h>
>  #include <linux/mfd/core.h>
>  #include <linux/module.h>
> +#include <linux/notifier.h>
> +#include <linux/pm.h>
>  #include <linux/regmap.h>
>  
>  struct rk808_reg_data {
> @@ -147,23 +149,19 @@ static struct regmap_irq_chip rk808_irq_chip = {
>  	.init_ack_masked = true,
>  };
>  
> -static struct i2c_client *rk808_i2c_client;
> -static void rk808_device_shutdown(void)
> +static int rk808_device_shutdown(struct notifier_block *this,
> +				 unsigned long unused1, void *unused2)
>  {
> +	struct rk808 *rk808 = container_of(this, struct rk808, power_off_nb);
>  	int ret;
> -	struct rk808 *rk808 = i2c_get_clientdata(rk808_i2c_client);
> -
> -	if (!rk808) {
> -		dev_warn(&rk808_i2c_client->dev,
> -			 "have no rk808, so do nothing here\n");
> -		return;
> -	}
>  
>  	ret = regmap_update_bits(rk808->regmap,
>  				 RK808_DEVCTRL_REG,
>  				 DEV_OFF_RST, DEV_OFF_RST);
>  	if (ret)
> -		dev_err(&rk808_i2c_client->dev, "power off error!\n");
> +		dev_err(&rk808->i2c->dev, "power off error!\n");
> +
> +	return NOTIFY_DONE;
>  }
>  
>  static int rk808_probe(struct i2c_client *client,
> @@ -222,9 +220,14 @@ static int rk808_probe(struct i2c_client *client,
>  
>  	pm_off = of_property_read_bool(np,
>  				"rockchip,system-power-controller");
> -	if (pm_off && !pm_power_off) {
> -		rk808_i2c_client = client;
> -		pm_power_off = rk808_device_shutdown;
> +	if (pm_off) {
> +		rk808->power_off_nb.notifier_call = rk808_device_shutdown;
> +		rk808->power_off_nb.priority = POWER_OFF_PRIORITY_LOW;
> +		ret = devm_register_power_off_handler(&client->dev,
> +						      &rk808->power_off_nb);
> +		if (ret)
> +			dev_warn(&client->dev,
> +				 "Failed to register power-off handler\n");
>  	}
>  
>  	return 0;
> @@ -240,7 +243,6 @@ static int rk808_remove(struct i2c_client *client)
>  
>  	regmap_del_irq_chip(client->irq, rk808->irq_data);
>  	mfd_remove_devices(&client->dev);
> -	pm_power_off = NULL;
>  
>  	return 0;
>  }
> diff --git a/include/linux/mfd/rk808.h b/include/linux/mfd/rk808.h
> index fb09312..6308fd4 100644
> --- a/include/linux/mfd/rk808.h
> +++ b/include/linux/mfd/rk808.h
> @@ -19,6 +19,7 @@
>  #ifndef __LINUX_REGULATOR_rk808_H
>  #define __LINUX_REGULATOR_rk808_H
>  
> +#include <linux/notifier.h>
>  #include <linux/regulator/machine.h>
>  #include <linux/regmap.h>
>  
> @@ -192,5 +193,6 @@ struct rk808 {
>  	struct i2c_client *i2c;
>  	struct regmap_irq_chip_data *irq_data;
>  	struct regmap *regmap;
> +	struct notifier_block power_off_nb;
>  };
>  #endif /* __LINUX_REGULATOR_rk808_H */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
