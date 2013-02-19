Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab3BSGnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 01:43:41 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57257 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3BSGnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 01:43:37 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51231EFC.5080006@jp.fujitsu.com>
Date: Tue, 19 Feb 2013 15:43:08 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 2/7] ACPI / scan: Introduce common code for ACPI-based
 device hotplug
References: <3260206.bhaAobGhpZ@vostro.rjw.lan> <2540040.4NPGdn6Df0@vostro.rjw.lan>
In-Reply-To: <2540040.4NPGdn6Df0@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

I have comments. Please see below.

2013/02/18 0:21, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Multiple drivers handling hotplug-capable ACPI device nodes install
> notify handlers covering the same types of events in a very similar
> way.  Moreover, those handlers are installed in separate namespace
> walks, although that really should be done during namespace scans
> carried out by acpi_bus_scan().  This leads to substantial code
> duplication, unnecessary overhead and behavior that is hard to
> follow.
>
> For this reason, introduce common code in drivers/acpi/scan.c for
> handling hotplug-related notification and carrying out device
> insertion and eject operations in a generic fashion, such that it
> may be used by all of the relevant drivers in the future.  To cover
> the existing differences between those drivers introduce struct
> acpi_hotplug_profile for representing collections of hotplug
> settings associated with different ACPI scan handlers that can be
> used by the drivers to make the common code reflect their current
> behavior.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>   drivers/acpi/scan.c     |  271 +++++++++++++++++++++++++++++++++++++-----------
>   include/acpi/acpi_bus.h |    7 +
>   2 files changed, 220 insertions(+), 58 deletions(-)
>
> Index: test/include/acpi/acpi_bus.h
> ===================================================================
> --- test.orig/include/acpi/acpi_bus.h
> +++ test/include/acpi/acpi_bus.h
> @@ -88,11 +88,18 @@ struct acpi_device;
>    * -----------------
>    */
>
> +struct acpi_hotplug_profile {
> +	bool enabled:1;
> +	bool uevents:1;
> +	bool autoeject:1;
> +};
> +
>   struct acpi_scan_handler {
>   	const struct acpi_device_id *ids;
>   	struct list_head list_node;
>   	int (*attach)(struct acpi_device *dev, const struct acpi_device_id *id);
>   	void (*detach)(struct acpi_device *dev);
> +	struct acpi_hotplug_profile hotplug;
>   };
>
>   /*
> Index: test/drivers/acpi/scan.c
> ===================================================================
> --- test.orig/drivers/acpi/scan.c
> +++ test/drivers/acpi/scan.c
> @@ -107,32 +107,19 @@ acpi_device_modalias_show(struct device
>   }
>   static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
>
> -/**
> - * acpi_bus_hot_remove_device: hot-remove a device and its children
> - * @context: struct acpi_eject_event pointer (freed in this func)
> - *
> - * Hot-remove a device and its children. This function frees up the
> - * memory space passed by arg context, so that the caller may call
> - * this function asynchronously through acpi_os_hotplug_execute().
> - */
> -void acpi_bus_hot_remove_device(void *context)
> +static int acpi_scan_hot_remove(struct acpi_device *device)
>   {
> -	struct acpi_eject_event *ej_event = context;
> -	struct acpi_device *device = ej_event->device;
>   	acpi_handle handle = device->handle;
> -	acpi_handle temp;
> +	acpi_handle not_used;
>   	struct acpi_object_list arg_list;
>   	union acpi_object arg;
> -	acpi_status status = AE_OK;
> -	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
> -
> -	mutex_lock(&acpi_scan_lock);
> +	acpi_status status;
>
>   	/* If there is no handle, the device node has been unregistered. */
> -	if (!device->handle) {
> +	if (!handle) {
>   		dev_dbg(&device->dev, "ACPI handle missing\n");
>   		put_device(&device->dev);
> -		goto out;
> +		return -EINVAL;
>   	}
>
>   	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> @@ -143,7 +130,7 @@ void acpi_bus_hot_remove_device(void *co
>   	put_device(&device->dev);
>   	device = NULL;
>
> -	if (ACPI_SUCCESS(acpi_get_handle(handle, "_LCK", &temp))) {
> +	if (ACPI_SUCCESS(acpi_get_handle(handle, "_LCK", &not_used))) {
>   		arg_list.count = 1;
>   		arg_list.pointer = &arg;
>   		arg.type = ACPI_TYPE_INTEGER;
> @@ -161,18 +148,162 @@ void acpi_bus_hot_remove_device(void *co
>   	 */
>   	status = acpi_evaluate_object(handle, "_EJ0", &arg_list, NULL);
>   	if (ACPI_FAILURE(status)) {
> -		if (status != AE_NOT_FOUND)
> +		if (status == AE_NOT_FOUND) {
> +			return -ENODEV;
> +		} else {
>   			acpi_handle_warn(handle, "Eject failed\n");
> +			return -EIO;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void acpi_bus_device_eject(void *context)
> +{
> +	acpi_handle handle = context;
> +	struct acpi_device *device = NULL;
> +	struct acpi_scan_handler *handler;
> +	u32 ost_source = ACPI_NOTIFY_EJECT_REQUEST;
> +	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
> +
> +	mutex_lock(&acpi_scan_lock);
>
> -		/* Tell the firmware the hot-remove operation has failed. */
> -		acpi_evaluate_hotplug_ost(handle, ej_event->event,
> -					  ost_code, NULL);
> +	acpi_bus_get_device(handle, &device);
> +	if (!device)
> +		goto out;
> +
> +	handler = device->handler;
> +	if (!handler || !handler->hotplug.enabled) {
> +		ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
> +		goto out;
>   	}
> +	acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
> +				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);

> +	if (handler->hotplug.uevents)
> +		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
> +
> +	if (handler->hotplug.autoeject) {
> +		int error;
> +
> +		ost_source = ACPI_OST_EC_OSPM_EJECT;
> +		get_device(&device->dev);
> +		error = acpi_scan_hot_remove(device);
> +		if (!error)
> +			ost_code = ACPI_OST_SC_SUCCESS;
> +	} else {
> +		device->flags.eject_pending = true;
> +		goto out_unlock;
> +	}

I want you to change the order of uevents and autoeject.
When user caught OFFLINE event, user thinks devices were removed.
But it is not guaranteed in this code since acpi_scan_hot_remove() may
be running.

> +
> + out:
> +	acpi_evaluate_hotplug_ost(handle, ost_source, ost_code, NULL);
> +
> + out_unlock:
> +	mutex_unlock(&acpi_scan_lock);
> +}
> +
> +static void acpi_scan_bus_device_check(acpi_handle handle, u32 ost_source)
> +{
> +	struct acpi_device *device = NULL;
> +	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
> +	int error;
> +
> +	mutex_lock(&acpi_scan_lock);
> +
> +	acpi_bus_get_device(handle, &device);
> +	if (device) {
> +		dev_warn(&device->dev, "Attempt to re-insert\n");
> +		goto out;
> +	}
> +	acpi_evaluate_hotplug_ost(handle, ost_source,
> +				  ACPI_OST_SC_INSERT_IN_PROGRESS, NULL);
> +	ost_source = ACPI_OST_EC_OSPM_INSERTION;
> +	error = acpi_bus_scan(handle);
> +	if (error) {
> +		acpi_handle_warn(handle, "Namespace scan failure\n");
> +		goto out;
> +	}
> +	error = acpi_bus_get_device(handle, &device);
> +	if (error) {
> +		acpi_handle_warn(handle, "Missing device node object\n");
> +		goto out;
> +	}
> +	ost_code = ACPI_OST_SC_SUCCESS;
> +	if (device->handler && device->handler->hotplug.uevents)
> +		kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
>
>    out:
> +	acpi_evaluate_hotplug_ost(handle, ost_source, ost_code, NULL);
> +	mutex_unlock(&acpi_scan_lock);
> +}
> +
> +static void acpi_scan_bus_check(void *context)
> +{
> +	acpi_scan_bus_device_check((acpi_handle)context,
> +				   ACPI_NOTIFY_BUS_CHECK);
> +}
> +
> +static void acpi_scan_device_check(void *context)
> +{
> +	acpi_scan_bus_device_check((acpi_handle)context,
> +				   ACPI_NOTIFY_DEVICE_CHECK);
> +}
> +
> +static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *not_used)
> +{
> +	acpi_osd_exec_callback callback;
> +	acpi_status status;
> +
> +	switch (type) {
> +	case ACPI_NOTIFY_BUS_CHECK:
> +		acpi_handle_debug(handle, "ACPI_NOTIFY_BUS_CHECK event\n");
> +		callback = acpi_scan_bus_check;
> +		break;
> +	case ACPI_NOTIFY_DEVICE_CHECK:
> +		acpi_handle_debug(handle, "ACPI_NOTIFY_DEVICE_CHECK event\n");
> +		callback = acpi_scan_device_check;
> +		break;
> +	case ACPI_NOTIFY_EJECT_REQUEST:
> +		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
> +		callback = acpi_bus_device_eject;
> +		break;
> +	default:
> +		/* non-hotplug event; possibly handled by other handler */
> +		return;
> +	}
> +	status = acpi_os_hotplug_execute(callback, handle);
> +	if (ACPI_FAILURE(status))
> +		acpi_evaluate_hotplug_ost(handle, type,
> +					  ACPI_OST_SC_NON_SPECIFIC_FAILURE,
> +					  NULL);
> +}
> +
> +/**
> + * acpi_bus_hot_remove_device: hot-remove a device and its children
> + * @context: struct acpi_eject_event pointer (freed in this func)
> + *
> + * Hot-remove a device and its children. This function frees up the
> + * memory space passed by arg context, so that the caller may call
> + * this function asynchronously through acpi_os_hotplug_execute().
> + */
> +void acpi_bus_hot_remove_device(void *context)
> +{
> +	struct acpi_eject_event *ej_event = context;
> +	struct acpi_device *device = ej_event->device;
> +	acpi_handle handle = device->handle;
> +	u32 ost_code = ACPI_OST_SC_SUCCESS;
> +	int error;
> +
> +	mutex_lock(&acpi_scan_lock);
> +
> +	error = acpi_scan_hot_remove(device);
> +	if (error)
> +		ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
> +
> +	acpi_evaluate_hotplug_ost(handle, ej_event->event, ost_code, NULL);
> +
>   	mutex_unlock(&acpi_scan_lock);
>   	kfree(context);
> -	return;
>   }
>   EXPORT_SYMBOL(acpi_bus_hot_remove_device);
>
> @@ -206,50 +337,48 @@ static ssize_t
>   acpi_eject_store(struct device *d, struct device_attribute *attr,
>   		const char *buf, size_t count)
>   {
> -	int ret = count;
> -	acpi_status status;
> -	acpi_object_type type = 0;
>   	struct acpi_device *acpi_device = to_acpi_device(d);
> -	struct acpi_eject_event *ej_event;
> +	acpi_object_type not_used;
> +	acpi_status status;
> +	u32 ost_source;
> +	u32 ost_code;
> +	int ret;
>
> -	if ((!count) || (buf[0] != '1')) {
> +	if (!count || buf[0] != '1')
>   		return -EINVAL;
> -	}
> -	if (!acpi_device->driver && !acpi_device->handler) {
> -		ret = -ENODEV;
> -		goto err;
> -	}
> -	status = acpi_get_type(acpi_device->handle, &type);
> -	if (ACPI_FAILURE(status) || (!acpi_device->flags.ejectable)) {
> -		ret = -ENODEV;
> -		goto err;
> -	}
>
> -	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
> -	if (!ej_event) {
> -		ret = -ENOMEM;
> -		goto err;
> -	}
> +	if ((!acpi_device->handler || !acpi_device->handler->hotplug.enabled)
> +	    && !acpi_device->driver)
> +		return -ENODEV;
> +
> +	status = acpi_get_type(acpi_device->handle, &not_used);
> +	if (ACPI_FAILURE(status) || !acpi_device->flags.ejectable)
> +		return -ENODEV;
> +
> +	mutex_lock(&acpi_scan_lock);
>
> -	get_device(&acpi_device->dev);
> -	ej_event->device = acpi_device;
>   	if (acpi_device->flags.eject_pending) {
> -		/* event originated from ACPI eject notification */
> -		ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
> +		/* ACPI eject notification event. */
> +		ost_source = ACPI_NOTIFY_EJECT_REQUEST;
>   		acpi_device->flags.eject_pending = 0;
>   	} else {
> -		/* event originated from user */
> -		ej_event->event = ACPI_OST_EC_OSPM_EJECT;
> -		(void) acpi_evaluate_hotplug_ost(acpi_device->handle,
> -			ej_event->event, ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
> +		/* Eject initiated by user space. */
> +		ost_source = ACPI_OST_EC_OSPM_EJECT;
>   	}
> -

> -	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, ej_event);
> -	if (ACPI_FAILURE(status)) {
> -		put_device(&acpi_device->dev);
> -		kfree(ej_event);
> +	acpi_evaluate_hotplug_ost(acpi_device->handle, ost_source,
> +				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
> +	get_device(&acpi_device->dev);
> +	ret = acpi_scan_hot_remove(acpi_device);

Why don't you use acpi_os_hotplug_execute()? Do you have some reason?

Thanks,
Yasuaki Ishimatsu

> +	if (ret) {
> +		ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
> +	} else {
> +		ost_code = ACPI_OST_SC_SUCCESS;
> +		ret = count;
>   	}
> -err:
> +	acpi_evaluate_hotplug_ost(acpi_device->handle, ACPI_OST_EC_OSPM_EJECT,
> +				  ost_code, NULL);
> +
> +	mutex_unlock(&acpi_scan_lock);
>   	return ret;
>   }
>
> @@ -1548,6 +1677,30 @@ static struct acpi_scan_handler *acpi_sc
>   	return NULL;
>   }
>
> +static void acpi_scan_init_hotplug(acpi_handle handle)
> +{
> +	struct acpi_device_info *info;
> +	struct acpi_scan_handler *handler;
> +
> +	if (ACPI_FAILURE(acpi_get_object_info(handle, &info)))
> +		return;
> +
> +	if (!(info->valid & ACPI_VALID_HID)) {
> +		kfree(info);
> +		return;
> +	}
> +
> +	/*
> +	 * This relies on the fact that acpi_install_notify_handler() will not
> +	 * install the same notify handler routine twice for the same handle.
> +	 */
> +	handler = acpi_scan_match_handler(info->hardware_id.string, NULL);
> +	kfree(info);
> +	if (handler && handler->hotplug.enabled)
> +		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> +					    acpi_hotplug_notify_cb, NULL);
> +}
> +
>   static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
>   				      void *not_used, void **return_value)
>   {
> @@ -1570,6 +1723,8 @@ static acpi_status acpi_bus_check_add(ac
>   		return AE_OK;
>   	}
>
> +	acpi_scan_init_hotplug(handle);
> +
>   	if (!(sta & ACPI_STA_DEVICE_PRESENT) &&
>   	    !(sta & ACPI_STA_DEVICE_FUNCTIONING)) {
>   		struct acpi_device_wakeup wakeup;
>


