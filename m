Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab3FWPyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 11:54:36 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52149 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3FWPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 11:54:34 -0400
Message-ID: <51C71A27.1040600@gmail.com>
Date: Sun, 23 Jun 2013 23:54:15 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ACPI / dock / PCI: Synchronous handling of dock events
 for PCI devices
References: <2737587.I0nULev1kj@vostro.rjw.lan> <15269989.ojxutYs2L1@vostro.rjw.lan>
In-Reply-To: <15269989.ojxutYs2L1@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 05:25 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The interactions between the ACPI dock driver and the ACPI-based PCI
> hotplug (acpiphp) are currently problematic because of ordering
> issues during hot-remove operations.
> 
> First of all, the current ACPI glue code expects that physical
> devices will always be deleted before deleting the companion ACPI
> device objects.  Otherwise, acpi_unbind_one() will fail with a
> warning message printed to the kernel log, for example:
> 
> [  185.026073] usb usb5: Oops, 'acpi_handle' corrupt
> [  185.035150] pci 0000:1b:00.0: Oops, 'acpi_handle' corrupt
> [  185.035515] pci 0000:18:02.0: Oops, 'acpi_handle' corrupt
> [  180.013656]  port1: Oops, 'acpi_handle' corrupt
> 
[...]
> @@ -597,15 +654,11 @@ register_hotplug_dock_device(acpi_handle
>  		 * ops
>  		 */
>  		dd = find_dock_dependent_device(dock_station, handle);
> -		if (dd) {
> -			dd->ops = ops;
> -			dd->context = context;
> -			dock_add_hotplug_device(dock_station, dd);
> -			ret = 0;
> -		}
> +		if (dd)
> +			return dock_init_hotplug(dd, ops, context,
> +						 init, release);
Hi Rafael,
	Seems not an equivalent change.	According to the comment just above the
code, we shouldn't return but continue here.
/*
 * An ATA bay can be in a dock and itself can be ejected
 * separately, so there are two 'dock stations' which need the
 * ops
 */

Regards!
Gerry

>  
> -
> -	return ret;
> +	return -EINVAL;
>  }
>  EXPORT_SYMBOL_GPL(register_hotplug_dock_device);
>  
> @@ -623,8 +676,10 @@ void unregister_hotplug_dock_device(acpi
>  
>  	list_for_each_entry(dock_station, &dock_stations, sibling) {
>  		dd = find_dock_dependent_device(dock_station, handle);
> -		if (dd)
> -			dock_del_hotplug_device(dock_station, dd);
> +		if (dd) {
> +			dock_release_hotplug(dd);
> +			return;
> +		}
>  	}
>  }
>  EXPORT_SYMBOL_GPL(unregister_hotplug_dock_device);
> @@ -953,7 +1008,6 @@ static int __init dock_add(acpi_handle h
>  	mutex_init(&dock_station->hp_lock);
>  	spin_lock_init(&dock_station->dd_lock);
>  	INIT_LIST_HEAD(&dock_station->sibling);
> -	INIT_LIST_HEAD(&dock_station->hotplug_devices);
>  	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
>  	INIT_LIST_HEAD(&dock_station->dependent_devices);
>  
> Index: linux-pm/include/acpi/acpi_drivers.h
> ===================================================================
> --- linux-pm.orig/include/acpi/acpi_drivers.h
> +++ linux-pm/include/acpi/acpi_drivers.h
> @@ -123,7 +123,9 @@ extern int register_dock_notifier(struct
>  extern void unregister_dock_notifier(struct notifier_block *nb);
>  extern int register_hotplug_dock_device(acpi_handle handle,
>  					const struct acpi_dock_ops *ops,
> -					void *context);
> +					void *context,
> +					void (*init)(void *),
> +					void (*release)(void *));
>  extern void unregister_hotplug_dock_device(acpi_handle handle);
>  #else
>  static inline int is_dock_device(acpi_handle handle)
> Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> @@ -61,6 +61,7 @@ static DEFINE_MUTEX(bridge_mutex);
>  static void handle_hotplug_event_bridge (acpi_handle, u32, void *);
>  static void acpiphp_sanitize_bus(struct pci_bus *bus);
>  static void acpiphp_set_hpp_values(struct pci_bus *bus);
> +static void hotplug_event_func(acpi_handle handle, u32 type, void *context);
>  static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
>  static void free_bridge(struct kref *kref);
>  
> @@ -147,7 +148,7 @@ static int post_dock_fixups(struct notif
>  
>  
>  static const struct acpi_dock_ops acpiphp_dock_ops = {
> -	.handler = handle_hotplug_event_func,
> +	.handler = hotplug_event_func,
>  };
>  
>  /* Check whether the PCI device is managed by native PCIe hotplug driver */
> @@ -179,6 +180,20 @@ static bool device_is_managed_by_native_
>  	return true;
>  }
>  
> +static void acpiphp_dock_init(void *data)
> +{
> +	struct acpiphp_func *func = data;
> +
> +	get_bridge(func->slot->bridge);
> +}
> +
> +static void acpiphp_dock_release(void *data)
> +{
> +	struct acpiphp_func *func = data;
> +
> +	put_bridge(func->slot->bridge);
> +}
> +
>  /* callback routine to register each ACPI PCI slot object */
>  static acpi_status
>  register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
> @@ -298,7 +313,8 @@ register_slot(acpi_handle handle, u32 lv
>  		 */
>  		newfunc->flags &= ~FUNC_HAS_EJ0;
>  		if (register_hotplug_dock_device(handle,
> -			&acpiphp_dock_ops, newfunc))
> +			&acpiphp_dock_ops, newfunc,
> +			acpiphp_dock_init, acpiphp_dock_release))
>  			dbg("failed to register dock device\n");
>  
>  		/* we need to be notified when dock events happen
> @@ -1068,22 +1084,12 @@ static void handle_hotplug_event_bridge(
>  	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_bridge);
>  }
>  
> -static void _handle_hotplug_event_func(struct work_struct *work)
> +static void hotplug_event_func(acpi_handle handle, u32 type, void *context)
>  {
> -	struct acpiphp_func *func;
> +	struct acpiphp_func *func = context;
>  	char objname[64];
>  	struct acpi_buffer buffer = { .length = sizeof(objname),
>  				      .pointer = objname };
> -	struct acpi_hp_work *hp_work;
> -	acpi_handle handle;
> -	u32 type;
> -
> -	hp_work = container_of(work, struct acpi_hp_work, work);
> -	handle = hp_work->handle;
> -	type = hp_work->type;
> -	func = (struct acpiphp_func *)hp_work->context;
> -
> -	acpi_scan_lock_acquire();
>  
>  	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>  
> @@ -1116,6 +1122,18 @@ static void _handle_hotplug_event_func(s
>  		warn("notify_handler: unknown event type 0x%x for %s\n", type, objname);
>  		break;
>  	}
> +}
> +
> +static void _handle_hotplug_event_func(struct work_struct *work)
> +{
> +	struct acpi_hp_work *hp_work;
> +	struct acpiphp_func *func;
> +
> +	hp_work = container_of(work, struct acpi_hp_work, work);
> +	func = hp_work->context;
> +	acpi_scan_lock_acquire();
> +
> +	hotplug_event_func(hp_work->handle, hp_work->type, func);
>  
>  	acpi_scan_lock_release();
>  	kfree(hp_work); /* allocated in handle_hotplug_event_func */
> 

