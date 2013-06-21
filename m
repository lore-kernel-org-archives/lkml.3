Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423395Ab3FUQyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:54:33 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:33553 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161494Ab3FUQyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:54:31 -0400
Message-ID: <51C4853D.7040705@gmail.com>
Date: Sat, 22 Jun 2013 00:54:21 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Alexander E. Patrakov" <patrakov@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>, alexdeucher@gmail.com,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX v2 0/4] fix bug 56531, 59501 and 59581
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <1880810.6jIKdDRiJm@vostro.rjw.lan> <CAN_LGv0DUH3o6=iCBcQDEOLQ3n=O=GR5BSQU5dLs306YeLVL7w@mail.gmail.com> <1436701.V8egnZxOqz@vostro.rjw.lan>
In-Reply-To: <1436701.V8egnZxOqz@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 03:06 AM, Rafael J. Wysocki wrote:
> On Wednesday, June 19, 2013 11:18:41 AM Alexander E. Patrakov wrote:
>> 2013/6/19 Rafael J. Wysocki <rjw@sisk.pl>:
>>> OK, let's try to untangle this a bit.
>>>
>>> If you applyt patches [1/4] and [4/4] from the $subject series only, what
>>> does remain unfixed?
>>
>> [not tested, can do so in 12 hours if needed]
>>
>> I think there will be problems on undocking and/or on the second
>> docking, as described in comments #6 - #8 of
>> https://bugzilla.kernel.org/show_bug.cgi?id=59501
> 
> OK, I think I have something that might work.  It may not solve all problems,
> but maybe it helps a bit.  Unfortunately, I can't really test it, so please do
> if you can.
> 
> Please apply [1/4] and [4/4] and the one below and see what happens.
> 
> Thanks,
> Rafael
> 
> 
> ---
> Rationale:
> 	acpiphp_glue.c:disable_device() trims the underlying ACPI device objects
> 	after removing the companion PCI devices, so the dock station code
> 	doesn't need to trim them separately for the dependent devices handled
> 	by acpiphp.
> 
> 	Moreover, acpiphp_glue.c is the only user of
> 	[un]register_hotplug_dock_device(), so *all* devices on the
> 	ds->hotplug_devices list are handled by acpiphp and ops is set for all
> 	of them.
Hi Rafael,
    There's an ongoing patch to fix a disk bay hotplug regression, which
may add a second caller of register_hotplug_device(). Please refer to
bug 59871, and the proposed patch is at:
https://bugzilla.kernel.org/attachment.cgi?id=105581

> 
> 	This means that (1) the ds->hotplug_devices list is not necessary (we
> 	can always walk ds->dependent_devices instead and look for those that
> 	have dd->ops set) and (2) we don't need to call
> 	dock_remove_acpi_device(dd->handle) on eject for any of those devices,
> 	because dd->ops->handler() is going to take care of the ACPI device
> 	objects trimming for them anyway.
> 
> 	Taking the above into account make the following changes:
> 	(1) Drop hotplug_devices from struct dock_station.
> 	(2) Drop dock_{add|del}_hotplug_device()
> 	(3) Make [un]register_hotplug_dock_device() [un]set 'ops' and
> 	    'context' for the given device under ds->hp_lock.
> 	(4) Add hot_remove_dock_devices() that walks ds->dependent_devices and
> 	    either calls dd->ops->handler(), if present, or trims the underlying
> 	    ACPI device object, otherwise.
> 	(5) Replace hotplug_dock_devices(ds, ACPI_NOTIFY_EJECT_REQUEST) calls
> 	    with hot_remove_dock_devices(ds).
> 	(6) Rename hotplug_dock_devices() to hot_add_dock_devices() and make
> 	    it only handle bus check and device check requests.  Make it walk
> 	    ds->dependent_devices instead of ds->hotplug devices.
> 	(7) Make dock_event() walk ds->dependent_devices (instead of
> 	    ds->hotplug devices) under ds->hp_lock.
> ---
>  drivers/acpi/dock.c |  111 ++++++++++++++++++++++++----------------------------
>  1 file changed, 53 insertions(+), 58 deletions(-)
> 
> Index: linux-pm/drivers/acpi/dock.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/dock.c
> +++ linux-pm/drivers/acpi/dock.c
> @@ -66,7 +66,6 @@ struct dock_station {
>  	spinlock_t dd_lock;
>  	struct mutex hp_lock;
>  	struct list_head dependent_devices;
> -	struct list_head hotplug_devices;
>  
>  	struct list_head sibling;
>  	struct platform_device *dock_device;
> @@ -121,38 +120,6 @@ add_dock_dependent_device(struct dock_st
>  }
>  
>  /**
> - * dock_add_hotplug_device - associate a hotplug handler with the dock station
> - * @ds: The dock station
> - * @dd: The dependent device struct
> - *
> - * Add the dependent device to the dock's hotplug device list
> - */
> -static void
> -dock_add_hotplug_device(struct dock_station *ds,
> -			struct dock_dependent_device *dd)
> -{
> -	mutex_lock(&ds->hp_lock);
> -	list_add_tail(&dd->hotplug_list, &ds->hotplug_devices);
> -	mutex_unlock(&ds->hp_lock);
> -}
> -
> -/**
> - * dock_del_hotplug_device - remove a hotplug handler from the dock station
> - * @ds: The dock station
> - * @dd: the dependent device struct
> - *
> - * Delete the dependent device from the dock's hotplug device list
> - */
> -static void
> -dock_del_hotplug_device(struct dock_station *ds,
> -			struct dock_dependent_device *dd)
> -{
> -	mutex_lock(&ds->hp_lock);
> -	list_del(&dd->hotplug_list);
> -	mutex_unlock(&ds->hp_lock);
> -}
> -
> -/**
>   * find_dock_dependent_device - get a device dependent on this dock
>   * @ds: the dock station
>   * @handle: the acpi_handle of the device we want
> @@ -342,40 +309,60 @@ static void dock_remove_acpi_device(acpi
>  }
>  
>  /**
> - * hotplug_dock_devices - insert or remove devices on the dock station
> - * @ds: the dock station
> - * @event: either bus check or eject request
> + * hot_remove_dock_devices - Remove devices on a dock station.
> + * @ds: Dock station to remove devices for.
> + *
> + * For each device depending on @ds, if a dock event handler is registered,
> + * call it for the device, or trim the underlying ACPI device object otherwise.
> + *
> + * Dock event handlers are responsible for trimming the underlying ACPI device
> + * objects if present.
> + */
> +static void hot_remove_dock_devices(struct dock_station *ds)
> +{
> +	struct dock_dependent_device *dd;
> +
> +	mutex_lock(&ds->hp_lock);
> +
> +	list_for_each_entry(dd, &ds->dependent_devices, list) {
> +		if (dd->ops && dd->ops->handler)
> +			dd->ops->handler(dd->handle, ACPI_NOTIFY_EJECT_REQUEST,
> +					 dd->context);
> +		else
> +			dock_remove_acpi_device(dd->handle);
> +	}
The proposed patch for bug 59871 may not be safe with above changes
because the ACPI ATA hotplug handler may not remove ACPI devices as
acpiphp driver does.

On the other hand, the above change does get rid of the warning message
"Oops, 'acpi_handle' corrupt", but it may hide the real issue. With
current implementation, devices on the dock station are stopped and
removed after invoking ACPI _DCK method, which seems a little dangerous.
I think ACPI _DCK method should be called to power off the dock station
after stopping all affected devices.

Regards!
Gerry

> +
> +	mutex_unlock(&ds->hp_lock);
> +}
> +
> +/**
> + * hot_add_dock_devices - Insert devices on a dock station.
> + * @ds: Dock station to insert devices for.
>   *
>   * Some devices on the dock station need to have drivers called
>   * to perform hotplug operations after a dock event has occurred.
>   * Traverse the list of dock devices that have registered a
>   * hotplug handler, and call the handler.
>   */
> -static void hotplug_dock_devices(struct dock_station *ds, u32 event)
> +static void hot_add_dock_devices(struct dock_station *ds, u32 event)
>  {
>  	struct dock_dependent_device *dd;
>  
>  	mutex_lock(&ds->hp_lock);
>  
> -	/*
> -	 * First call driver specific hotplug functions
> -	 */
> -	list_for_each_entry(dd, &ds->hotplug_devices, hotplug_list)
> +	/* First call driver specific hotplug event handlers. */
> +	list_for_each_entry(dd, &ds->dependent_devices, list)
>  		if (dd->ops && dd->ops->handler)
>  			dd->ops->handler(dd->handle, event, dd->context);
>  
>  	/*
> -	 * Now make sure that an acpi_device is created for each
> -	 * dependent device, or removed if this is an eject request.
> -	 * This will cause acpi_drivers to be stopped/started if they
> -	 * exist
> +	 * Now make sure that an acpi_device is created for each dependent
> +	 * device.  That will cause scan handlers to attach to devices objects
> +	 * or  acpi_drivers to be started if they exist.
>  	 */
> -	list_for_each_entry(dd, &ds->dependent_devices, list) {
> -		if (event == ACPI_NOTIFY_EJECT_REQUEST)
> -			dock_remove_acpi_device(dd->handle);
> -		else
> -			dock_create_acpi_device(dd->handle);
> -	}
> +	list_for_each_entry(dd, &ds->dependent_devices, list)
> +		dock_create_acpi_device(dd->handle);
> +
>  	mutex_unlock(&ds->hp_lock);
>  }
>  
> @@ -398,10 +385,14 @@ static void dock_event(struct dock_stati
>  	if (num == DOCK_EVENT)
>  		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
>  
> -	list_for_each_entry(dd, &ds->hotplug_devices, hotplug_list)
> +	mutex_lock(&ds->hp_lock);
> +
> +	list_for_each_entry(dd, &ds->dependent_devices, list)
>  		if (dd->ops && dd->ops->uevent)
>  			dd->ops->uevent(dd->handle, event, dd->context);
>  
> +	mutex_unlock(&ds->hp_lock);
> +
>  	if (num != DOCK_EVENT)
>  		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
>  }
> @@ -598,9 +589,10 @@ register_hotplug_dock_device(acpi_handle
>  		 */
>  		dd = find_dock_dependent_device(dock_station, handle);
>  		if (dd) {
> +			mutex_lock(&dock_station->hp_lock);
>  			dd->ops = ops;
>  			dd->context = context;
> -			dock_add_hotplug_device(dock_station, dd);
> +			mutex_unlock(&dock_station->hp_lock);
>  			ret = 0;
>  		}
>  	}
> @@ -623,8 +615,12 @@ void unregister_hotplug_dock_device(acpi
>  
>  	list_for_each_entry(dock_station, &dock_stations, sibling) {
>  		dd = find_dock_dependent_device(dock_station, handle);
> -		if (dd)
> -			dock_del_hotplug_device(dock_station, dd);
> +		if (dd) {
> +			mutex_lock(&dock_station->hp_lock);
> +			dd->ops = NULL;
> +			dd->context = NULL;
> +			mutex_unlock(&dock_station->hp_lock);
> +		}
>  	}
>  }
>  EXPORT_SYMBOL_GPL(unregister_hotplug_dock_device);
> @@ -649,7 +645,7 @@ static int handle_eject_request(struct d
>  	 */
>  	dock_event(ds, event, UNDOCK_EVENT);
>  
> -	hotplug_dock_devices(ds, ACPI_NOTIFY_EJECT_REQUEST);
> +	hot_remove_dock_devices(ds);
>  	undock(ds);
>  	dock_lock(ds, 0);
>  	eject_dock(ds);
> @@ -708,7 +704,7 @@ static void dock_notify(acpi_handle hand
>  			}
>  			atomic_notifier_call_chain(&dock_notifier_list,
>  						   event, NULL);
> -			hotplug_dock_devices(ds, event);
> +			hot_add_dock_devices(ds, event);
>  			complete_dock(ds);
>  			dock_event(ds, event, DOCK_EVENT);
>  			dock_lock(ds, 1);
> @@ -953,7 +949,6 @@ static int __init dock_add(acpi_handle h
>  	mutex_init(&dock_station->hp_lock);
>  	spin_lock_init(&dock_station->dd_lock);
>  	INIT_LIST_HEAD(&dock_station->sibling);
> -	INIT_LIST_HEAD(&dock_station->hotplug_devices);
>  	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
>  	INIT_LIST_HEAD(&dock_station->dependent_devices);
>  
> 
> 
> 

