Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab3AUMxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:53:08 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48195 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab3AUMxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:53:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>
Subject: Re: [Update][PATCH] ACPI / PM: Export power states of ACPI devices via sysfs
Date: Mon, 21 Jan 2013 13:59:05 +0100
Message-ID: <2154175.hki2a10WqW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1982172.z1FZmGBJNL@vostro.rjw.lan>
References: <2311196.icSMDvAsYg@vostro.rjw.lan> <6722291.GNv0dQuq4j@vostro.rjw.lan> <1982172.z1FZmGBJNL@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 19, 2013 09:53:32 PM Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / PM: Export power states of ACPI devices via sysfs
> 
> Make it possible to retrieve the current power state of a device with
> ACPI power management from user space via sysfs by adding a new
> attribute power_state to the sysfs directory associated with the
> struct acpi_device object representing the device's ACPI node.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> I've changed my mind here.  It looks like it's more convenient to put the
> power_state attribute directly into the ACPI device node's directory in sysfs
> rather than into its power subdirectory.

Well, please scratch this, I'm dropping it for now.

I'll send a new version shortly along with the patches that export power
resources information.

Thanks,
Rafael


> ---
>  Documentation/ABI/testing/sysfs-devices-power |   13 +++++++++++++
>  drivers/acpi/scan.c                           |   25 ++++++++++++++++++++++++-
>  2 files changed, 37 insertions(+), 1 deletion(-)
> 
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -184,6 +184,19 @@ err_out:
>  }
>  EXPORT_SYMBOL(acpi_bus_hot_remove_device);
>  
> +static ssize_t power_state_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct acpi_device *adev = to_acpi_device(dev);
> +	int state;
> +	int ret;
> +
> +	ret = acpi_device_get_power(adev, &state);
> +	return ret ? ret : sprintf(buf, "%s\n", acpi_power_state_string(state));
> +}
> +
> +static DEVICE_ATTR(power_state, 0444, power_state_show, NULL);
> +
>  static ssize_t
>  acpi_eject_store(struct device *d, struct device_attribute *attr,
>  		const char *buf, size_t count)
> @@ -375,8 +388,15 @@ static int acpi_device_setup_files(struc
>           * hot-removal function from userland.
>           */
>  	status = acpi_get_handle(dev->handle, "_EJ0", &temp);
> -	if (ACPI_SUCCESS(status))
> +	if (ACPI_SUCCESS(status)) {
>  		result = device_create_file(&dev->dev, &dev_attr_eject);
> +		if (result)
> +			goto end;
> +	}
> +
> +	if (dev->flags.power_manageable)
> +		result = device_create_file(&dev->dev, &dev_attr_power_state);
> +
>  end:
>  	return result;
>  }
> @@ -386,6 +406,9 @@ static void acpi_device_remove_files(str
>  	acpi_status status;
>  	acpi_handle temp;
>  
> +	if (dev->flags.power_manageable)
> +		device_remove_file(&dev->dev, &dev_attr_power_state);
> +
>  	/*
>  	 * If device has _STR, remove 'description' file
>  	 */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
