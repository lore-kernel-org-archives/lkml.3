Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3FNNyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:54:10 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44402 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab3FNNyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:54:08 -0400
Message-ID: <51BB2075.5040600@gmail.com>
Date: Fri, 14 Jun 2013 21:53:57 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org
Subject: Re: [BUGFIX 2/9] ACPIPHP: fix device destroying order issue when
 handling dock notification
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com> <1371141152-9468-3-git-send-email-jiang.liu@huawei.com> <2448481.HbOiE9Npmq@vostro.rjw.lan>
In-Reply-To: <2448481.HbOiE9Npmq@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 03:59 AM, Rafael J. Wysocki wrote:
> On Friday, June 14, 2013 12:32:25 AM Jiang Liu wrote:
>> Current ACPI glue logic expects that physical devices are destroyed
>> before destroying companion ACPI devices, otherwise it will break the
>> ACPI unbind logic and cause following warning messages:
>> [  185.026073] usb usb5: Oops, 'acpi_handle' corrupt
>> [  185.035150] pci 0000:1b:00.0: Oops, 'acpi_handle' corrupt
>> [  185.035515] pci 0000:18:02.0: Oops, 'acpi_handle' corrupt
>> [  180.013656]  port1: Oops, 'acpi_handle' corrupt
>> Please refer to https://bugzilla.kernel.org/attachment.cgi?id=104321
>> for full log message.
> 
> So my question is, did we have this problem before commit 3b63aaa70e1?
> 
> If we did, then when did it start?  Or was it present forever?
I think this issue should exist before commit "PCI: acpiphp: Do not use
ACPI PCI subdriver mechanism". It may trace back to the changes to kill
acpi_pci_bind()/acpi_pci_unbind().

> 
>> Above warning messages are caused by following scenario:
>> 1) acpi_dock_notifier_call() queues a task (T1) onto kacpi_hotplug_wq
>> 2) kacpi_hotplug_wq handles T1, which invokes acpi_dock_deferred_cb()
>>    ->dock_notify()-> handle_eject_request()->hotplug_dock_devices()
>> 3) hotplug_dock_devices() first invokes registered hotplug callbacks to
>>    destroy physical devices, then destroys all affected ACPI devices.
>>    Everything seems perfect until now. But the acpiphp dock notification
>>    handler will queue another task (T2) onto kacpi_hotplug_wq to really
>>    destroy affected physical devices.
> 
> Would not the solution be to modify it so that it didn't spawn the other
> task (T2), but removed the affected physical devices synchronously?
Yes, that's the way I'm going to fix this issue.

> 
>> 4) kacpi_hotplug_wq finishes T1, and all affected ACPI devices have
>>    been destroyed.
>> 5) kacpi_hotplug_wq handles T2, which destroys all affected physical
>>    devices.
>>
>> So it breaks ACPI glue logic's expection because ACPI devices are destroyed
>> in step 3 and physical devices are destroyed in step 5.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>> Cc: linux-pci@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: stable@vger.kernel.org
>> ---
>> Hi Bjorn and Rafael,
>>      The recursive lock changes haven't been tested yet, need help
>> from Alexander for testing.
> 
> Well, let's just say I'm not a fan of recursive locks.  Is that unavoidable
> here?
Yeah, you are right, we encounter other deadlock issue here, as reported
by Alexander. So need to find new solution here.

> 
> Rafael
> 
> 
>> ---
>>  drivers/acpi/dock.c                | 33 +++++++++++++++++++++++++++------
>>  drivers/pci/hotplug/acpiphp_glue.c | 32 ++++++++++++++++++--------------
>>  2 files changed, 45 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
>> index 02b0563..79c8d9e 100644
>> --- a/drivers/acpi/dock.c
>> +++ b/drivers/acpi/dock.c
>> @@ -65,6 +65,7 @@ struct dock_station {
>>  	u32 flags;
>>  	spinlock_t dd_lock;
>>  	struct mutex hp_lock;
>> +	struct task_struct *owner;
>>  	struct list_head dependent_devices;
>>  	struct list_head hotplug_devices;
>>  
>> @@ -131,9 +132,13 @@ static void
>>  dock_add_hotplug_device(struct dock_station *ds,
>>  			struct dock_dependent_device *dd)
>>  {
>> -	mutex_lock(&ds->hp_lock);
>> -	list_add_tail(&dd->hotplug_list, &ds->hotplug_devices);
>> -	mutex_unlock(&ds->hp_lock);
>> +	if (mutex_is_locked(&ds->hp_lock) && ds->owner == current) {
>> +		list_add_tail(&dd->hotplug_list, &ds->hotplug_devices);
>> +	} else {
>> +		mutex_lock(&ds->hp_lock);
>> +		list_add_tail(&dd->hotplug_list, &ds->hotplug_devices);
>> +		mutex_unlock(&ds->hp_lock);
>> +	}
>>  }
>>  
>>  /**
>> @@ -147,9 +152,13 @@ static void
>>  dock_del_hotplug_device(struct dock_station *ds,
>>  			struct dock_dependent_device *dd)
>>  {
>> -	mutex_lock(&ds->hp_lock);
>> -	list_del(&dd->hotplug_list);
>> -	mutex_unlock(&ds->hp_lock);
>> +	if (mutex_is_locked(&ds->hp_lock) && ds->owner == current) {
>> +		list_del_init(&dd->hotplug_list);
>> +	} else {
>> +		mutex_lock(&ds->hp_lock);
>> +		list_del_init(&dd->hotplug_list);
>> +		mutex_unlock(&ds->hp_lock);
>> +	}
>>  }
>>  
>>  /**
>> @@ -355,7 +364,17 @@ static void hotplug_dock_devices(struct dock_station *ds, u32 event)
>>  {
>>  	struct dock_dependent_device *dd;
>>  
>> +	/*
>> +	 * There is a deadlock scenario as below:
>> +	 *	hotplug_dock_devices()
>> +	 *	    mutex_lock(&ds->hp_lock)
>> +	 *		dd->ops->handler()
>> +	 *		    register_hotplug_dock_device()
>> +	 *			mutex_lock(&ds->hp_lock)
>> +	 * So we need recursive lock scematics here, do it by ourselves.
>> +	 */
>>  	mutex_lock(&ds->hp_lock);
>> +	ds->owner = current;
>>  
>>  	/*
>>  	 * First call driver specific hotplug functions
>> @@ -376,6 +395,8 @@ static void hotplug_dock_devices(struct dock_station *ds, u32 event)
>>  		else
>>  			dock_create_acpi_device(dd->handle);
>>  	}
>> +
>> +	ds->owner = NULL;
>>  	mutex_unlock(&ds->hp_lock);
>>  }
>>  
>> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
>> index 716aa93..699b8ca 100644
>> --- a/drivers/pci/hotplug/acpiphp_glue.c
>> +++ b/drivers/pci/hotplug/acpiphp_glue.c
>> @@ -61,6 +61,8 @@ static DEFINE_MUTEX(bridge_mutex);
>>  static void handle_hotplug_event_bridge (acpi_handle, u32, void *);
>>  static void acpiphp_sanitize_bus(struct pci_bus *bus);
>>  static void acpiphp_set_hpp_values(struct pci_bus *bus);
>> +static void _handle_hotplug_event_func(acpi_handle handle, u32 type,
>> +				       void *context);
>>  static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
>>  static void free_bridge(struct kref *kref);
>>  
>> @@ -147,7 +149,7 @@ static int post_dock_fixups(struct notifier_block *nb, unsigned long val,
>>  
>>  
>>  static const struct acpi_dock_ops acpiphp_dock_ops = {
>> -	.handler = handle_hotplug_event_func,
>> +	.handler = _handle_hotplug_event_func,
>>  };
>>  
>>  /* Check whether the PCI device is managed by native PCIe hotplug driver */
>> @@ -1065,22 +1067,13 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
>>  	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_bridge);
>>  }
>>  
>> -static void _handle_hotplug_event_func(struct work_struct *work)
>> +static void _handle_hotplug_event_func(acpi_handle handle, u32 type,
>> +				       void *context)
>>  {
>> -	struct acpiphp_func *func;
>> +	struct acpiphp_func *func = context;
>>  	char objname[64];
>>  	struct acpi_buffer buffer = { .length = sizeof(objname),
>>  				      .pointer = objname };
>> -	struct acpi_hp_work *hp_work;
>> -	acpi_handle handle;
>> -	u32 type;
>> -
>> -	hp_work = container_of(work, struct acpi_hp_work, work);
>> -	handle = hp_work->handle;
>> -	type = hp_work->type;
>> -	func = (struct acpiphp_func *)hp_work->context;
>> -
>> -	acpi_scan_lock_acquire();
>>  
>>  	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>>  
>> @@ -1113,7 +1106,18 @@ static void _handle_hotplug_event_func(struct work_struct *work)
>>  		warn("notify_handler: unknown event type 0x%x for %s\n", type, objname);
>>  		break;
>>  	}
>> +}
>> +
>> +static void _handle_hotplug_event_cb(struct work_struct *work)
>> +{
>> +	struct acpiphp_func *func;
>> +	struct acpi_hp_work *hp_work;
>>  
>> +	hp_work = container_of(work, struct acpi_hp_work, work);
>> +	func = (struct acpiphp_func *)hp_work->context;
>> +	acpi_scan_lock_acquire();
>> +	_handle_hotplug_event_func(hp_work->handle, hp_work->type,
>> +				    hp_work->context);
>>  	acpi_scan_lock_release();
>>  	kfree(hp_work); /* allocated in handle_hotplug_event_func */
>>  	put_bridge(func->slot->bridge);
>> @@ -1141,7 +1145,7 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
>>  	 * don't deadlock on hotplug actions.
>>  	 */
>>  	get_bridge(func->slot->bridge);
>> -	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_func);
>> +	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_cb);
>>  }
>>  
>>  /*
>>

