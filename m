Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaJGHww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 03:52:52 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:53113 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaJGHwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 03:52:47 -0400
Date: Tue, 7 Oct 2014 08:52:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, adi-buildroot-devel@lists.sourceforge.net,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-am33-list@redhat.com,
        linux-cris-kernel@axis.com, linux-efi@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-m32r-ja@ml.linux-m32r.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        openipmi-developer@lists.sourceforge.net,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org,
        linux-ia64@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-sh@vger.kernel.org, xen-devel@lists.xenproject.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 18/44] mfd: twl4030-power: Register with kernel poweroff
 handler
Message-ID: <20141007075238.GA25331@lee--X1>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
 <1412659726-29957-19-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412659726-29957-19-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Oct 2014, Guenter Roeck wrote:

> Register with kernel poweroff handler instead of setting pm_power_off
> directly. Register with a low priority value of 64 to reflect that
> the original code only sets pm_power_off if it was not already set.
> 
> Make twl4030_power_off static as it is only called from the twl4030-power
> driver.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/mfd/twl4030-power.c | 25 +++++++++++++++++++++----
>  include/linux/i2c/twl.h     |  1 -
>  2 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> index 4d3ff37..bd6b830 100644
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
> +static struct notifier_block twl4030_poweroff_nb = {
> +	.notifier_call = twl4030_power_off,
> +	.priority = 64,

64 out of what?  How is this calculated?  Wouldn't it be better to
define these?

> +};
> +
>  static bool twl4030_power_use_poweroff(const struct twl4030_power_data *pdata,
>  					struct device_node *node)
>  {
> @@ -836,7 +845,7 @@ static int twl4030_power_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Board has to be wired properly to use this feature */
> -	if (twl4030_power_use_poweroff(pdata, node) && !pm_power_off) {
> +	if (twl4030_power_use_poweroff(pdata, node)) {
>  		/* Default for SEQ_OFFSYNC is set, lets ensure this */
>  		err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &val,
>  				      TWL4030_PM_MASTER_CFG_P123_TRANSITION);
> @@ -853,7 +862,13 @@ static int twl4030_power_probe(struct platform_device *pdev)
>  			}
>  		}
>  
> -		pm_power_off = twl4030_power_off;
> +		err = register_poweroff_handler(&twl4030_poweroff_nb);
> +		if (err) {
> +			dev_err(&pdev->dev,
> +				"Failed to register poweroff handler\n");

If this is not fatal, you should issue a dev_warn() instead.

> +			/* Not a fatal error */
> +			err = 0;

How about using your own variable for this?  Then you don't have to
worry about resetting it.

> +		}
>  	}
>  
>  relock:
> @@ -869,6 +884,8 @@ relock:
>  
>  static int twl4030_power_remove(struct platform_device *pdev)
>  {
> +	unregister_poweroff_handler(&twl4030_poweroff_nb);

Perhaps a naive question, but is there any way you can do this using
devres (devm_* managed resources)?

>  	return 0;
>  }
>  
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
