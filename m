Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645Ab3GDXi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 19:38:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58861 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909Ab3GDXiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 19:38:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2.1 6/8] PCI: acpiphp: workaround for Thunderbolt on Acer Aspire S5
Date: Fri, 05 Jul 2013 01:48:01 +0200
Message-ID: <2539126.i7GjLNiDjm@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1372948192-17913-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1656567.0oqS7xVYJ8@vostro.rjw.lan> <1372948192-17913-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 04, 2013 05:29:51 PM Mika Westerberg wrote:
> The acpiphp driver finds out whether the device is removable by checking
> whether it has _RMV method directly behind it (and if it returns 1).
> However, at least on Acer Aspire S5 with Thunderbolt host router has this
> method placed behind a device called EPUP (endpoint upstream port?) and not
> in the usual place expected by the acpiphp driver. The ASL code below shows
> how this is done on that machine:
> 
> Device (RP05)
> {
> 	...
> 	Device (HRUP)
> 	{
> 		Name (_ADR, Zero)
> 		Name (_PRW, Package (0x02)
> 		{
> 			0x09,
> 			0x04
> 		})
> 		Device (HRDN)
> 		{
> 			Name (_ADR, 0x00040000)
> 			Name (_PRW, Package (0x02)
> 			{
> 				0x09,
> 				0x04
> 			})
> 			Device (EPUP)
> 			{
> 				Name (_ADR, Zero)
> 				Method (_RMV, 0, NotSerialized)
> 				{
> 					Return (One)
> 				}
> 			}
> 		}
> 	}
> 	...
> 
> Fix this by adding a DMI quirk for the Acer Aspire S5 machine that gives an
> alternative path to the _RMV method.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

This is fine by me and same for the other patches in the series.

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/pci/hotplug/acpi_pcihp.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
> index 2a47e82..eae1511 100644
> --- a/drivers/pci/hotplug/acpi_pcihp.c
> +++ b/drivers/pci/hotplug/acpi_pcihp.c
> @@ -33,6 +33,7 @@
>  #include <linux/acpi.h>
>  #include <linux/pci-acpi.h>
>  #include <linux/slab.h>
> +#include <linux/dmi.h>
>  
>  #define MY_NAME	"acpi_pcihp"
>  
> @@ -408,11 +409,31 @@ got_one:
>  }
>  EXPORT_SYMBOL(acpi_get_hp_hw_control_from_firmware);
>  
> +static const struct dmi_system_id pcihp_platform_quirks[] = {
> +	{
> +		/*
> +		 * On Acer Aspire S5 the _RMV method for the
> +		 * Thunderbolt host router upstream port is not
> +		 * located directly under the device but it is
> +		 * instead placed a bit deeper in the hierarchy.
> +		 */
> +		.ident = "Acer Aspire S5",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire S5-391"),
> +		},
> +		.driver_data = "HRDN.EPUP._RMV",
> +	},
> +	{ }
> +};
> +
>  static int pcihp_is_ejectable(acpi_handle handle)
>  {
>  	acpi_status status;
>  	acpi_handle tmp;
>  	unsigned long long removable;
> +	const struct dmi_system_id *id;
> +
>  	status = acpi_get_handle(handle, "_ADR", &tmp);
>  	if (ACPI_FAILURE(status))
>  		return 0;
> @@ -422,6 +443,19 @@ static int pcihp_is_ejectable(acpi_handle handle)
>  	status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
>  	if (ACPI_SUCCESS(status) && removable)
>  		return 1;
> +
> +	/*
> +	 * Try to look if there is a platform specific method that we can
> +	 * use to determine if the device is removable or not.
> +	 */
> +	id = dmi_first_match(pcihp_platform_quirks);
> +	if (id && id->driver_data) {
> +		status = acpi_evaluate_integer(handle, id->driver_data, NULL,
> +					       &removable);
> +		if (ACPI_SUCCESS(status) && removable)
> +			return 1;
> +	}
> +
>  	return 0;
>  }
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
