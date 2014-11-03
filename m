Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaKCRyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:54:37 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:63939 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbaKCRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:54:34 -0500
Date: Mon, 3 Nov 2014 17:54:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 18/47] mfd: twl4030-power: Register with kernel
 power-off handler
Message-ID: <20141103175427.GK12011@x1>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-19-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414425354-10359-19-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Guenter Roeck wrote:

> Register with kernel power-off handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> only sets pm_power_off if it was not already set.
> 
> Make twl4030_power_off static as it is only called from the twl4030-power
> driver. Drop remove function as it is no longer needed.
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
> - Use devm_register_power_off_handler
> - Drop remove function as it is no longer needed.
> 
>  drivers/mfd/twl4030-power.c | 29 +++++++++++++++++++----------
>  include/linux/i2c/twl.h     |  1 -
>  2 files changed, 19 insertions(+), 11 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> index cf92a6d..e36eea9 100644
> --- a/drivers/mfd/twl4030-power.c
> +++ b/drivers/mfd/twl4030-power.c
> @@ -25,9 +25,10 @@
>   */
>  
>  #include <linux/module.h>
> -#include <linux/pm.h>
> +#include <linux/notifier.h>
>  #include <linux/i2c/twl.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
>  
> @@ -611,7 +612,8 @@ twl4030_power_configure_resources(const struct twl4030_power_data *pdata)
>   * After a successful execution, TWL shuts down the power to the SoC
>   * and all peripherals connected to it.
>   */
> -void twl4030_power_off(void)
> +static int twl4030_power_off(struct notifier_block *this, unsigned long unused1,
> +			     void *unused2)
>  {
>  	int err;
>  
> @@ -619,8 +621,15 @@ void twl4030_power_off(void)
>  			       TWL4030_PM_MASTER_P1_SW_EVENTS);
>  	if (err)
>  		pr_err("TWL4030 Unable to power off\n");
> +
> +	return NOTIFY_DONE;
>  }
>  
> +static struct notifier_block twl4030_power_off_nb = {
> +	.notifier_call = twl4030_power_off,
> +	.priority = POWER_OFF_PRIORITY_LOW,
> +};
> +
>  static bool twl4030_power_use_poweroff(const struct twl4030_power_data *pdata,
>  					struct device_node *node)
>  {
> @@ -839,7 +848,9 @@ static int twl4030_power_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Board has to be wired properly to use this feature */
> -	if (twl4030_power_use_poweroff(pdata, node) && !pm_power_off) {
> +	if (twl4030_power_use_poweroff(pdata, node)) {
> +		int ret;
> +
>  		/* Default for SEQ_OFFSYNC is set, lets ensure this */
>  		err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &val,
>  				      TWL4030_PM_MASTER_CFG_P123_TRANSITION);
> @@ -856,7 +867,11 @@ static int twl4030_power_probe(struct platform_device *pdev)
>  			}
>  		}
>  
> -		pm_power_off = twl4030_power_off;
> +		ret = devm_register_power_off_handler(&pdev->dev,
> +						      &twl4030_power_off_nb);
> +		if (ret)
> +			dev_warn(&pdev->dev,
> +				 "Failed to register power-off handler\n");
>  	}
>  
>  relock:
> @@ -870,11 +885,6 @@ relock:
>  	return err;
>  }
>  
> -static int twl4030_power_remove(struct platform_device *pdev)
> -{
> -	return 0;
> -}
> -
>  static struct platform_driver twl4030_power_driver = {
>  	.driver = {
>  		.name	= "twl4030_power",
> @@ -882,7 +892,6 @@ static struct platform_driver twl4030_power_driver = {
>  		.of_match_table = of_match_ptr(twl4030_power_of_match),
>  	},
>  	.probe		= twl4030_power_probe,
> -	.remove		= twl4030_power_remove,
>  };
>  
>  module_platform_driver(twl4030_power_driver);
> diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
> index 8cfb50f..f8544f1 100644
> --- a/include/linux/i2c/twl.h
> +++ b/include/linux/i2c/twl.h
> @@ -680,7 +680,6 @@ struct twl4030_power_data {
>  };
>  
>  extern int twl4030_remove_script(u8 flags);
> -extern void twl4030_power_off(void);
>  
>  struct twl4030_codec_data {
>  	unsigned int digimic_delay; /* in ms */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
