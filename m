Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398Ab3GCVRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:17:42 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50630 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756381Ab3GCVRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:17:40 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Frederick van der Wyck <fvanderwyck@gmail.com>
Cc: mjg59@srcf.ucam.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform samsung-q10: use ACPI instead of direct EC calls
Date: Wed, 03 Jul 2013 23:27:18 +0200
Message-ID: <1714028.c73rMBdPR6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130703210919.GB5579@lat.lan>
References: <20130703210919.GB5579@lat.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 03, 2013 10:09:19 PM Frederick van der Wyck wrote:
> This patch changes the Samsung Q10 backlight driver to use ACPI methods (the same ones as triggered by the brightness up/down function keys) instead of direct EC calls. The advantage is that the brightness setting is not lost on shutdown.
> 
> Signed-off-by: Frederick van der Wyck <fvanderwyck@gmail.com>

Any patches with "ACPI" in the subject (or in the changelog for that matter)
should be CCed to linux-acpi@vger.kernel.org.

Thanks,
Rafael


> ---
>  drivers/platform/x86/Kconfig       |    2 +-
>  drivers/platform/x86/samsung-q10.c |   77 ++++++++++++++++--------------------
>  2 files changed, 35 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 8577261..52aed6d 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -762,7 +762,7 @@ config INTEL_OAKTRAIL
>  
>  config SAMSUNG_Q10
>  	tristate "Samsung Q10 Extras"
> -	depends on SERIO_I8042
> +	depends on ACPI
>  	select BACKLIGHT_CLASS_DEVICE
>  	---help---
>  	  This driver provides support for backlight control on Samsung Q10
> diff --git a/drivers/platform/x86/samsung-q10.c b/drivers/platform/x86/samsung-q10.c
> index 1a90b62..e7caaa3 100644
> --- a/drivers/platform/x86/samsung-q10.c
> +++ b/drivers/platform/x86/samsung-q10.c
> @@ -14,16 +14,14 @@
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  #include <linux/backlight.h>
> -#include <linux/i8042.h>
>  #include <linux/dmi.h>
> +#include <acpi/acpi_drivers.h>
>  
> -#define SAMSUNGQ10_BL_MAX_INTENSITY      255
> -#define SAMSUNGQ10_BL_DEFAULT_INTENSITY  185
> +#define SAMSUNGQ10_BL_MAX_INTENSITY 7
>  
> -#define SAMSUNGQ10_BL_8042_CMD           0xbe
> -#define SAMSUNGQ10_BL_8042_DATA          { 0x89, 0x91 }
> +#define EC_HID "PNP0C09"
>  
> -static int samsungq10_bl_brightness;
> +static acpi_handle ec_handle;
>  
>  static bool force;
>  module_param(force, bool, 0);
> @@ -33,21 +31,26 @@ MODULE_PARM_DESC(force,
>  static int samsungq10_bl_set_intensity(struct backlight_device *bd)
>  {
>  
> -	int brightness = bd->props.brightness;
> -	unsigned char c[3] = SAMSUNGQ10_BL_8042_DATA;
> +	acpi_status status;
> +	int i;
>  
> -	c[2] = (unsigned char)brightness;
> -	i8042_lock_chip();
> -	i8042_command(c, (0x30 << 8) | SAMSUNGQ10_BL_8042_CMD);
> -	i8042_unlock_chip();
> -	samsungq10_bl_brightness = brightness;
> +	for (i = 0; i < SAMSUNGQ10_BL_MAX_INTENSITY; i++) {
> +		status = acpi_evaluate_object(ec_handle, "_Q63", NULL, NULL);
> +		if (ACPI_FAILURE(status))
> +			return -EIO;
> +	}
> +	for (i = 0; i < bd->props.brightness; i++) {
> +		status = acpi_evaluate_object(ec_handle, "_Q64", NULL, NULL);
> +		if (ACPI_FAILURE(status))
> +			return -EIO;
> +	}
>  
>  	return 0;
>  }
>  
>  static int samsungq10_bl_get_intensity(struct backlight_device *bd)
>  {
> -	return samsungq10_bl_brightness;
> +	return bd->props.brightness;
>  }
>  
>  static const struct backlight_ops samsungq10_bl_ops = {
> @@ -55,28 +58,6 @@ static const struct backlight_ops samsungq10_bl_ops = {
>  	.update_status	= samsungq10_bl_set_intensity,
>  };
>  
> -#ifdef CONFIG_PM_SLEEP
> -static int samsungq10_suspend(struct device *dev)
> -{
> -	return 0;
> -}
> -
> -static int samsungq10_resume(struct device *dev)
> -{
> -
> -	struct backlight_device *bd = dev_get_drvdata(dev);
> -
> -	samsungq10_bl_set_intensity(bd);
> -	return 0;
> -}
> -#else
> -#define samsungq10_suspend NULL
> -#define samsungq10_resume  NULL
> -#endif
> -
> -static SIMPLE_DEV_PM_OPS(samsungq10_pm_ops,
> -			  samsungq10_suspend, samsungq10_resume);
> -
>  static int samsungq10_probe(struct platform_device *pdev)
>  {
>  
> @@ -93,9 +74,6 @@ static int samsungq10_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, bd);
>  
> -	bd->props.brightness = SAMSUNGQ10_BL_DEFAULT_INTENSITY;
> -	samsungq10_bl_set_intensity(bd);
> -
>  	return 0;
>  }
>  
> @@ -104,9 +82,6 @@ static int samsungq10_remove(struct platform_device *pdev)
>  
>  	struct backlight_device *bd = platform_get_drvdata(pdev);
>  
> -	bd->props.brightness = SAMSUNGQ10_BL_DEFAULT_INTENSITY;
> -	samsungq10_bl_set_intensity(bd);
> -
>  	backlight_device_unregister(bd);
>  
>  	return 0;
> @@ -116,7 +91,6 @@ static struct platform_driver samsungq10_driver = {
>  	.driver		= {
>  		.name	= KBUILD_MODNAME,
>  		.owner	= THIS_MODULE,
> -		.pm	= &samsungq10_pm_ops,
>  	},
>  	.probe		= samsungq10_probe,
>  	.remove		= samsungq10_remove,
> @@ -167,11 +141,28 @@ static struct dmi_system_id __initdata samsungq10_dmi_table[] = {
>  };
>  MODULE_DEVICE_TABLE(dmi, samsungq10_dmi_table);
>  
> +static acpi_status __init acpi_handle_locate_callback(acpi_handle handle,
> +			u32 level, void *context, void **return_value)
> +{
> +	*(acpi_handle *)return_value = handle;
> +
> +	return AE_CTRL_TERMINATE;
> +}
> +
>  static int __init samsungq10_init(void)
>  {
> +
> +	acpi_status status;
> +
>  	if (!force && !dmi_check_system(samsungq10_dmi_table))
>  		return -ENODEV;
>  
> +	status = acpi_get_devices(EC_HID, acpi_handle_locate_callback,
> +				  NULL, &ec_handle);
> +
> +	if (ACPI_FAILURE(status))
> +		return -ENODEV;
> +
>  	samsungq10_device = platform_create_bundle(&samsungq10_driver,
>  						   samsungq10_probe,
>  						   NULL, 0, NULL, 0);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
