Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3KFAnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 19:43:50 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:34821 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab3KFAns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 19:43:48 -0500
Message-ID: <1383698367.1847.18.camel@misato.fc.hp.com>
Subject: Re: [fixup][PATCH 2/6] ACPI / hotplug: Refuse to hot-remove all
 objects with disabled hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Date: Tue, 05 Nov 2013 17:39:27 -0700
In-Reply-To: <5195965.AgE9G8aXP3@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan>
	 <2970389.SeMGM45Qln@vostro.rjw.lan> <1842331.UHR0XPv1jo@vostro.rjw.lan>
	 <5195965.AgE9G8aXP3@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-06 at 00:27 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> In theory, an ACPI device object may be the parent of another
> device object whose hotplug is disabled by user space through its
> scan handler.  In that case, the eject operation targeting the
> parent should fail as though the parent's own hotplug was disabled,
> but currently this is not the case, because acpi_scan_hot_remove()
> doesn't check the disable/enable hotplug status of the children
> of the top-most object passed to it.
> 
> To fix this, modify acpi_bus_offline_companions() to return an
> error code if hotplug is disabled for the given device object.
> [Also change the name of the function to acpi_bus_offline(),
> because it is not only about companions any more, and change
> the name of acpi_bus_online_companions() accordingly.]  Make
> acpi_scan_hot_remove() propagate that error to its callers.
> 
 :
> +static acpi_status acpi_bus_online(acpi_handle handle, u32 lvl, void *data,
> +				   void **ret_p)
>  {
>  	struct acpi_device *device = NULL;
>  	struct acpi_device_physical_node *pn;
> @@ -214,26 +220,32 @@ static int acpi_scan_hot_remove(struct a
>  	 * If the first pass is successful, the second one isn't needed, though.
>  	 */
>  	errdev = NULL;
> -	acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> -			    NULL, acpi_bus_offline_companions,
> -			    (void *)false, (void **)&errdev);
> -	acpi_bus_offline_companions(handle, 0, (void *)false, (void **)&errdev);
> +	status = acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> +				     NULL, acpi_bus_offline, (void *)false,
> +				     (void **)&errdev);
> +	if (status == AE_SUPPORT) {
> +		dev_warn(errdev, "Offline disabled.\n");
> +		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> +				    acpi_bus_online, NULL, NULL, NULL);
> +		put_device(&device->dev);
> +		return -EPERM;
> +	}
> +	acpi_bus_offline(handle, 0, (void *)false, (void **)&errdev);
>  	if (errdev) {

If the target object failed with AE_SUPPORT, shouldn't we skip the 2nd
pass and return with -EPERM after rollback? 

Thanks,
-Toshi


>  		errdev = NULL;
>  		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> -				    NULL, acpi_bus_offline_companions,
> -				    (void *)true , (void **)&errdev);
> +				    NULL, acpi_bus_offline, (void *)true,
> +				    (void **)&errdev);
>  		if (!errdev || acpi_force_hot_remove)
> -			acpi_bus_offline_companions(handle, 0, (void *)true,
> -						    (void **)&errdev);
> +			acpi_bus_offline(handle, 0, (void *)true,
> +					 (void **)&errdev);
>  
>  		if (errdev && !acpi_force_hot_remove) {
>  			dev_warn(errdev, "Offline failed.\n");
> -			acpi_bus_online_companions(handle, 0, NULL, NULL);
> +			acpi_bus_online(handle, 0, NULL, NULL);
>  			acpi_walk_namespace(ACPI_TYPE_ANY, handle,
> -					    ACPI_UINT32_MAX,
> -					    acpi_bus_online_companions, NULL,
> -					    NULL, NULL);
> +					    ACPI_UINT32_MAX, acpi_bus_online,
> +					    NULL, NULL, NULL);
>  			put_device(&device->dev);
>  			return -EBUSY;
>  		}


