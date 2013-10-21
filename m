Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab3JUDUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 23:20:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:51655 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab3JUDUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 23:20:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,536,1378882800"; 
   d="scan'208";a="419931099"
Message-ID: <52649D84.9010306@intel.com>
Date: Mon, 21 Oct 2013 11:20:36 +0800
From: Aaron Lu <aaron.lu@intel.com>
Organization: Intel, Shanghai, PRC
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko.nikula@linux.intel.com,
        mika.westerberg@linux.intel.com
Subject: Re: [PATCH 1/3] ACPI: add module autoloading support for ACPI enumerated
 devices
References: <1381741834-7334-1-git-send-email-rui.zhang@intel.com>
In-Reply-To: <1381741834-7334-1-git-send-email-rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 05:10 PM, Zhang Rui wrote:
> An ACPI enumerated device may have its compatible id strings.
> 
> To support the compatible ACPI ids (acpi_device->pnp.ids),
> we introduced acpi_driver_match_device() to match
> the driver->acpi_match_table and acpi_device->pnp.ids.
> 
> For those drivers, MODULE_DEVICE_TABLE(acpi, xxx) is used to
> exports the driver module alias in the format of
> "acpi:device_compatible_ids".
> But in the mean time, the current code does not export the
> ACPI compatible strings as part of the module_alias for the
> ACPI enumerated devices, which will break the module autoloading.
> 
> Take the following piece of code for example,
> static const struct acpi_device_id xxx_acpi_match[] = {
>         { "INTABCD", 0 },
>         { }
> };
> MODULE_DEVICE_TABLE(acpi, xxx_acpi_match);
> 
> If this piece of code is used in a platform driver for
> an ACPI enumerated platform device, the platform driver module_alias
> is "acpi:INTABCD", but the uevent attribute of its platform device node
> is "platform:INTABCD:00" (PREFIX:pdev->name).
> If this piece of code is used in an i2c driver for an ACPI enumerated
> i2c device, the i2c driver module_alias is "acpi:INTABCD", but
> the uevent of its i2c device node is "i2c:INTABCD:00" (PREFIX:client->name).
> 
> The reason why the module autoloading is not broken for now is that
> the uevent file of the ACPI device node is "acpi:INTABCD".
> Thus it is the ACPI device node creation that loads the platform/i2c driver.
> 
> So this is a problem that will affect us the day when the ACPI bus
> is removed from device model.
> 
> This patch introduces a new function to exporting ACPI ids as the
> module_alias, for the ACPI enumerate devices.
> 
> For any drivers using MODULE_DEVICE_TALBE(acpi, blabla), the uevent file
> of its associated device must be fixed by invoking this function.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/scan.c  |   24 ++++++++++++++++++++++++
>  include/linux/acpi.h |    8 ++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 407ad13..db6f879 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -111,6 +111,30 @@ static int create_modalias(struct acpi_device *acpi_dev, char *modalias,
>  	return len;
>  }
>  
> +int acpi_device_uevent_modalias(struct device *dev, struct kobj_uevent_env *env)
> +{
> +	struct acpi_device *acpi_dev;
> +	int result;
> +	int len;
> +
> +	result = acpi_bus_get_device(ACPI_HANDLE(dev), &acpi_dev);
> +	if (result)
> +		return result;
> +
> +	if (list_empty(&acpi_dev->pnp.ids))
> +		return 0;
> +
> +	if (add_uevent_var(env, "MODALIAS="))
> +		return -ENOMEM;
> +	len = create_modalias(acpi_dev, &env->buf[env->buflen - 1],
> +				sizeof(env->buf) - env->buflen);
> +	if (len >= (sizeof(env->buf) - env->buflen))
> +		return -ENOMEM;
> +	env->buflen += len;
> +	return 0;
> +}
> +EXPORT_SYMBOL(acpi_device_uevent_modalias);

Looks like this function shares a lot with the existing
acpi_device_uevent, so perhaps worth making some resue of the exising
code? e.g. seperate the common code into a function and then have the
two functions call it.

-Aaron

> +
>  static ssize_t
>  acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, char *buf) {
>  	struct acpi_device *acpi_dev = to_acpi_device(dev);
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index a5db4ae..117fa26 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -401,6 +401,8 @@ static inline bool acpi_driver_match_device(struct device *dev,
>  	return !!acpi_match_device(drv->acpi_match_table, dev);
>  }
>  
> +int acpi_device_uevent_modalias(struct device *, struct kobj_uevent_env *);
> +
>  #define ACPI_PTR(_ptr)	(_ptr)
>  
>  #else	/* !CONFIG_ACPI */
> @@ -471,6 +473,12 @@ static inline bool acpi_driver_match_device(struct device *dev,
>  	return false;
>  }
>  
> +static inline int acpi_device_uevent_modalias(struct device *dev,
> +				struct kobj_uevent_env *env)
> +{
> +	return -ENODEV;
> +}
> +
>  #define ACPI_PTR(_ptr)	(NULL)
>  
>  #endif	/* !CONFIG_ACPI */
> 

