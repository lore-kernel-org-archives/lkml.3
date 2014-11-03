Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaKCRyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:54:50 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:33595 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbaKCRyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:54:47 -0500
Date: Mon, 3 Nov 2014 17:54:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 17/47] mfd: tps65910: Register with kernel power-off
 handler
Message-ID: <20141103175440.GL12011@x1>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-18-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414425354-10359-18-git-send-email-linux@roeck-us.net>
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
>  drivers/mfd/tps65910.c       | 27 ++++++++++++++++++---------
>  include/linux/mfd/tps65910.h |  3 +++
>  2 files changed, 21 insertions(+), 9 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index 7612d89..3c94dbf 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -23,6 +23,8 @@
>  #include <linux/irq.h>
>  #include <linux/irqdomain.h>
>  #include <linux/mfd/core.h>
> +#include <linux/notifier.h>
> +#include <linux/pm.h>
>  #include <linux/regmap.h>
>  #include <linux/mfd/tps65910.h>
>  #include <linux/of.h>
> @@ -437,19 +439,20 @@ struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
>  }
>  #endif
>  
> -static struct i2c_client *tps65910_i2c_client;
> -static void tps65910_power_off(void)
> +static int tps65910_power_off(struct notifier_block *this,
> +			      unsigned long unused1, void *unused2)
>  {
> -	struct tps65910 *tps65910;
> -
> -	tps65910 = dev_get_drvdata(&tps65910_i2c_client->dev);
> +	struct tps65910 *tps65910 = container_of(this, struct tps65910,
> +						 power_off_nb);
>  
>  	if (tps65910_reg_set_bits(tps65910, TPS65910_DEVCTRL,
>  			DEVCTRL_PWR_OFF_MASK) < 0)
> -		return;
> +		return NOTIFY_DONE;
>  
>  	tps65910_reg_clear_bits(tps65910, TPS65910_DEVCTRL,
>  			DEVCTRL_DEV_ON_MASK);
> +
> +	return NOTIFY_DONE;
>  }
>  
>  static int tps65910_i2c_probe(struct i2c_client *i2c,
> @@ -505,9 +508,13 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>  	tps65910_ck32k_init(tps65910, pmic_plat_data);
>  	tps65910_sleepinit(tps65910, pmic_plat_data);
>  
> -	if (pmic_plat_data->pm_off && !pm_power_off) {
> -		tps65910_i2c_client = i2c;
> -		pm_power_off = tps65910_power_off;
> +	if (pmic_plat_data->pm_off) {
> +		tps65910->power_off_nb.notifier_call = tps65910_power_off;
> +		tps65910->power_off_nb.priority = POWER_OFF_PRIORITY_LOW;
> +		ret = register_power_off_handler(&tps65910->power_off_nb);
> +		if (ret)
> +			dev_warn(&i2c->dev,
> +				 "failed to register power-off handler\n");
>  	}
>  
>  	ret = mfd_add_devices(tps65910->dev, -1,
> @@ -527,6 +534,8 @@ static int tps65910_i2c_remove(struct i2c_client *i2c)
>  {
>  	struct tps65910 *tps65910 = i2c_get_clientdata(i2c);
>  
> +	unregister_power_off_handler(&tps65910->power_off_nb);
> +
>  	tps65910_irq_exit(tps65910);
>  	mfd_remove_devices(tps65910->dev);
>  
> diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
> index 6483a6f..94876c4 100644
> --- a/include/linux/mfd/tps65910.h
> +++ b/include/linux/mfd/tps65910.h
> @@ -905,6 +905,9 @@ struct tps65910 {
>  	/* IRQ Handling */
>  	int chip_irq;
>  	struct regmap_irq_chip_data *irq_data;
> +
> +	/* Power-off handling */
> +	struct notifier_block power_off_nb;
>  };
>  
>  struct tps65910_platform_data {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
