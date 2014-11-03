Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaKCRzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:55:14 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57057 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaKCRzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:55:11 -0500
Date: Mon, 3 Nov 2014 17:55:05 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 15/47] mfd: dm355evm_msp: Register with kernel
 power-off handler
Message-ID: <20141103175505.GN12011@x1>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-16-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414425354-10359-16-git-send-email-linux@roeck-us.net>
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
>  drivers/mfd/dm355evm_msp.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/dm355evm_msp.c b/drivers/mfd/dm355evm_msp.c
> index 4c826f7..63a1632 100644
> --- a/drivers/mfd/dm355evm_msp.c
> +++ b/drivers/mfd/dm355evm_msp.c
> @@ -14,6 +14,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/clk.h>
>  #include <linux/module.h>
> +#include <linux/notifier.h>
> +#include <linux/pm.h>
>  #include <linux/err.h>
>  #include <linux/gpio.h>
>  #include <linux/leds.h>
> @@ -352,14 +354,22 @@ static void dm355evm_command(unsigned command)
>  				command, status);
>  }
>  
> -static void dm355evm_power_off(void)
> +static int dm355evm_power_off(struct notifier_block *this,
> +			      unsigned long unused1, void *unused2)
>  {
>  	dm355evm_command(MSP_COMMAND_POWEROFF);
> +
> +	return NOTIFY_DONE;
>  }
>  
> +static struct notifier_block dm355evm_msp_power_off_nb = {
> +	.notifier_call = dm355evm_power_off,
> +	.priority = POWER_OFF_PRIORITY_LOW,
> +};
> +
>  static int dm355evm_msp_remove(struct i2c_client *client)
>  {
> -	pm_power_off = NULL;
> +	unregister_power_off_handler(&dm355evm_msp_power_off_nb);
>  	msp430 = NULL;
>  	return 0;
>  }
> @@ -398,7 +408,9 @@ dm355evm_msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		goto fail;
>  
>  	/* PM hookup */
> -	pm_power_off = dm355evm_power_off;
> +	status = register_power_off_handler(&dm355evm_msp_power_off_nb);
> +	if (status)
> +		dev_warn(&client->dev, "Failed to register power-off handler\n");
>  
>  	return 0;
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
