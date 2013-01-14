Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab3ANXXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:23:33 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:26202 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab3ANXXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:23:32 -0500
Message-ID: <1358205223.14145.108.camel@misato.fc.hp.com>
Subject: Re: [PATCH 5/5] ACPI / scan: Add second pass to acpi_bus_trim()
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Date: Mon, 14 Jan 2013 16:13:43 -0700
In-Reply-To: <9393976.KUs5xrSxYx@vostro.rjw.lan>
References: <3885603.ydrrB7OEKf@vostro.rjw.lan>
	 <9393976.KUs5xrSxYx@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-14 at 22:39 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Make acpi_bus_trim() work in analogy with acpi_bus_scan() and carry
> out two passes such that ACPI drivers will be detached from device
> nodes being removed in the first pass and the device nodes themselves
> will be removed in the second pass.
> 
> For this purpose split the driver unregistration out of
> acpi_bus_remove() into a new routine, acpi_bus_device_detach(), that
> will be executed by acpi_bus_trim() in the additional first pass as
> a post-order callback.
> 
> This is necessary, because some ACPI drivers' .remove() routines
> unregister struct device objects associated with the ACPI device
> nodes being removed and that needs to happen while the ACPI
> device nodes are still around (for example, in case they need to be
> used for power management or similar things at that time).
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

I'd suggest to add some comment stating that acpi_bus_device_detach()
acpi_bus_remove() are post-order callbacks.  I do not think many people
recognize it by just looking the calls to acpi_walk_namespace().

Otherwise, the patchset looks good.  For the patch series:
Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

> ---
>  drivers/acpi/scan.c |   44 ++++++++++++++++++++++++++++----------------
>  1 file changed, 28 insertions(+), 16 deletions(-)
> 
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -1425,22 +1425,6 @@ static void acpi_device_set_id(struct ac
>  	}
>  }
>  
> -static acpi_status acpi_bus_remove(acpi_handle handle, u32 lvl_not_used,
> -				   void *not_used, void **ret_not_used)
> -{
> -	struct acpi_device *dev = NULL;
> -
> -	if (acpi_bus_get_device(handle, &dev))
> -		return AE_OK;
> -
> -	dev->removal_type = ACPI_BUS_REMOVAL_EJECT;
> -	device_release_driver(&dev->dev);
> -
> -	acpi_device_unregister(dev);
> -
> -	return AE_OK;
> -}
> -
>  void acpi_init_device_object(struct acpi_device *device, acpi_handle handle,
>  			     int type, unsigned long long sta)
>  {
> @@ -1647,8 +1631,36 @@ int acpi_bus_add(acpi_handle handle)
>  }
>  EXPORT_SYMBOL(acpi_bus_add);
>  
> +static acpi_status acpi_bus_device_detach(acpi_handle handle, u32 lvl_not_used,
> +					  void *not_used, void **ret_not_used)
> +{
> +	struct acpi_device *device = NULL;
> +
> +	if (!acpi_bus_get_device(handle, &device)) {
> +		device->removal_type = ACPI_BUS_REMOVAL_EJECT;
> +		device_release_driver(&device->dev);
> +	}
> +	return AE_OK;
> +}
> +
> +static acpi_status acpi_bus_remove(acpi_handle handle, u32 lvl_not_used,
> +				   void *not_used, void **ret_not_used)
> +{
> +	struct acpi_device *device = NULL;
> +
> +	if (!acpi_bus_get_device(handle, &device))
> +		acpi_device_unregister(device);
> +
> +	return AE_OK;
> +}
> +
>  int acpi_bus_trim(struct acpi_device *start)
>  {
> +	/* Detach all ACPI drivers from the device nodes being removed. */
> +	acpi_walk_namespace(ACPI_TYPE_ANY, start->handle, ACPI_UINT32_MAX, NULL,
> +			    acpi_bus_device_detach, NULL, NULL);
> +	acpi_bus_device_detach(start->handle, 0, NULL, NULL);
> +	/* Remove the device nodes. */
>  	acpi_walk_namespace(ACPI_TYPE_ANY, start->handle, ACPI_UINT32_MAX, NULL,
>  			    acpi_bus_remove, NULL, NULL);
>  	acpi_bus_remove(start->handle, 0, NULL, NULL);
> 


