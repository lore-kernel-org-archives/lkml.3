Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3AYP3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:29:25 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:23735 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab3AYP3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:29:12 -0500
Message-ID: <1359127153.14145.356.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI / scan: Make it clear that acpi_bus_trim() cannot
 fail
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Date: Fri, 25 Jan 2013 08:19:13 -0700
In-Reply-To: <1511096.zmfmBrfdmu@vostro.rjw.lan>
References: <1511096.zmfmBrfdmu@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 23:56 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Since acpi_bus_trim() cannot fail, change its definition to a void
> function, so that its callers don't check the return value in vain
> and update the callers.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

> ---
> 
> On top of current linux-pm.git/linux-next.
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/acpi/dock.c                |    8 ++------
>  drivers/acpi/scan.c                |   12 +++---------
>  drivers/pci/hotplug/acpiphp_glue.c |   10 +++-------
>  include/acpi/acpi_bus.h            |    2 +-
>  4 files changed, 9 insertions(+), 23 deletions(-)
> 
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -127,13 +127,8 @@ void acpi_bus_hot_remove_device(void *co
>  	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>  		"Hot-removing device %s...\n", dev_name(&device->dev)));
>  
> -	if (acpi_bus_trim(device)) {
> -		printk(KERN_ERR PREFIX
> -				"Removing device failed\n");
> -		goto err_out;
> -	}
> -
> -	/* device has been freed */
> +	acpi_bus_trim(device);
> +	/* Device node has been released. */
>  	device = NULL;
>  
>  	/* power off device */
> @@ -1656,7 +1651,7 @@ static acpi_status acpi_bus_remove(acpi_
>  	return AE_OK;
>  }
>  
> -int acpi_bus_trim(struct acpi_device *start)
> +void acpi_bus_trim(struct acpi_device *start)
>  {
>  	/*
>  	 * Execute acpi_bus_device_detach() as a post-order callback to detach
> @@ -1672,7 +1667,6 @@ int acpi_bus_trim(struct acpi_device *st
>  	acpi_walk_namespace(ACPI_TYPE_ANY, start->handle, ACPI_UINT32_MAX, NULL,
>  			    acpi_bus_remove, NULL, NULL);
>  	acpi_bus_remove(start->handle, 0, NULL, NULL);
> -	return 0;
>  }
>  EXPORT_SYMBOL_GPL(acpi_bus_trim);
>  
> Index: linux-pm/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-pm.orig/include/acpi/acpi_bus.h
> +++ linux-pm/include/acpi/acpi_bus.h
> @@ -386,7 +386,7 @@ int acpi_bus_register_driver(struct acpi
>  void acpi_bus_unregister_driver(struct acpi_driver *driver);
>  int acpi_bus_scan(acpi_handle handle);
>  void acpi_bus_hot_remove_device(void *context);
> -int acpi_bus_trim(struct acpi_device *start);
> +void acpi_bus_trim(struct acpi_device *start);
>  acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
>  int acpi_match_device_ids(struct acpi_device *device,
>  			  const struct acpi_device_id *ids);
> Index: linux-pm/drivers/acpi/dock.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/dock.c
> +++ linux-pm/drivers/acpi/dock.c
> @@ -336,13 +336,9 @@ static struct acpi_device * dock_create_
>  static void dock_remove_acpi_device(acpi_handle handle)
>  {
>  	struct acpi_device *device;
> -	int ret;
>  
> -	if (!acpi_bus_get_device(handle, &device)) {
> -		ret = acpi_bus_trim(device);
> -		if (ret)
> -			pr_debug("error removing bus, %x\n", -ret);
> -	}
> +	if (!acpi_bus_get_device(handle, &device))
> +		acpi_bus_trim(device);
>  }
>  
>  /**
> Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> @@ -742,8 +742,7 @@ static int acpiphp_bus_add(struct acpiph
>  		/* this shouldn't be in here, so remove
>  		 * the bus then re-add it...
>  		 */
> -		ret_val = acpi_bus_trim(device);
> -		dbg("acpi_bus_trim return %x\n", ret_val);
> +		acpi_bus_trim(device);
>  	}
>  
>  	ret_val = acpi_bus_scan(func->handle);
> @@ -772,11 +771,8 @@ static int acpiphp_bus_trim(acpi_handle
>  		return retval;
>  	}
>  
> -	retval = acpi_bus_trim(device);
> -	if (retval)
> -		err("cannot remove from acpi list\n");
> -
> -	return retval;
> +	acpi_bus_trim(device);
> +	return 0;
>  }
>  
>  static void acpiphp_set_acpi_region(struct acpiphp_slot *slot)
> 


