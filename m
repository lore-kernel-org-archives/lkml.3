Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab3A2C34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:29:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57428 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3A2C3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:29:52 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51073402.5040104@jp.fujitsu.com>
Date: Tue, 29 Jan 2013 11:29:22 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ACPI / scan: Introduce struct acpi_scan_handler
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <4311642.nDd2RCVeDc@vostro.rjw.lan> <1408351.aVGQgvLeMo@vostro.rjw.lan> <51072E2A.8040203@jp.fujitsu.com>
In-Reply-To: <51072E2A.8040203@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/01/29 11:04, Yasuaki Ishimatsu wrote:
> Hi Rafael,
>
> 2013/01/28 21:59, Rafael J. Wysocki wrote:
>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> Introduce struct acpi_scan_handler for representing objects that
>> will do configuration tasks depending on ACPI device nodes'
>> hardware IDs (HIDs).
>>
>> Currently, those tasks are done either directly by the ACPI namespace
>> scanning code or by ACPI device drivers designed specifically for
>> this purpose.  None of the above is desirable, however, because
>> doing that directly in the namespace scanning code makes that code
>> overly complicated and difficult to follow and doing that in
>> "special" device drivers leads to a great deal of confusion about
>> their role and to confusing interactions with the driver core (for
>> example, sysfs directories are created for those drivers, but they
>> are completely unnecessary and only increase the kernel's memory
>> footprint in vain).
>>
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> ---
> Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>
> I have a comment. Please see below.
>
>>   Documentation/acpi/scan_handlers.txt |   77 +++++++++++++++++++++++++++++++++++
>>   drivers/acpi/scan.c                  |   60 ++++++++++++++++++++++++---
>>   include/acpi/acpi_bus.h              |   14 ++++++
>>   3 files changed, 144 insertions(+), 7 deletions(-)
>>
>> Index: test/include/acpi/acpi_bus.h
>> ===================================================================
>> --- test.orig/include/acpi/acpi_bus.h
>> +++ test/include/acpi/acpi_bus.h
>> @@ -84,6 +84,18 @@ struct acpi_driver;
>>   struct acpi_device;
>>
>>   /*
>> + * ACPI Scan Handler
>> + * -----------------
>> + */
>> +
>> +struct acpi_scan_handler {
>> +    const struct acpi_device_id *ids;
>> +    struct list_head list_node;
>> +    int (*attach)(struct acpi_device *dev, const struct acpi_device_id *id);
>> +    void (*detach)(struct acpi_device *dev);
>> +};
>> +
>> +/*
>>    * ACPI Driver
>>    * -----------
>>    */
>> @@ -269,6 +281,7 @@ struct acpi_device {
>>       struct acpi_device_wakeup wakeup;
>>       struct acpi_device_perf performance;
>>       struct acpi_device_dir dir;
>> +    struct acpi_scan_handler *handler;
>>       struct acpi_driver *driver;
>>       void *driver_data;
>>       struct device dev;
>> @@ -382,6 +395,7 @@ int acpi_bus_receive_event(struct acpi_b
>>   static inline int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data)
>>       { return 0; }
>>   #endif
>> +int acpi_scan_add_handler(struct acpi_scan_handler *handler);
>>   int acpi_bus_register_driver(struct acpi_driver *driver);
>>   void acpi_bus_unregister_driver(struct acpi_driver *driver);
>>   int acpi_bus_scan(acpi_handle handle);
>> Index: test/drivers/acpi/scan.c
>> ===================================================================
>> --- test.orig/drivers/acpi/scan.c
>> +++ test/drivers/acpi/scan.c
>> @@ -53,6 +53,7 @@ static const struct acpi_device_id acpi_
>>   static LIST_HEAD(acpi_device_list);
>>   static LIST_HEAD(acpi_bus_id_list);
>>   static DEFINE_MUTEX(acpi_scan_lock);
>> +static LIST_HEAD(acpi_scan_handlers_list);
>>   DEFINE_MUTEX(acpi_device_lock);
>>   LIST_HEAD(acpi_wakeup_device_list);
>>
>> @@ -62,6 +63,15 @@ struct acpi_device_bus_id{
>>       struct list_head node;
>>   };
>>
>> +int acpi_scan_add_handler(struct acpi_scan_handler *handler)
>> +{
>> +    if (!handler || !handler->attach)
>> +        return -EINVAL;
>> +
>> +    list_add_tail(&handler->list_node, &acpi_scan_handlers_list);
>> +    return 0;
>> +}
>> +
>>   /*
>>    * Creates hid/cid(s) string needed for modalias and uevent
>>    * e.g. on a device with hid:IBM0001 and cid:ACPI0001 you get:
>> @@ -1570,20 +1580,42 @@ static acpi_status acpi_bus_check_add(ac
>>       return AE_OK;
>>   }
>>
>> +static int acpi_scan_attach_handler(struct acpi_device *device)
>> +{
>> +    struct acpi_scan_handler *handler;
>> +    int ret = 0;
>> +
>> +    list_for_each_entry(handler, &acpi_scan_handlers_list, list_node) {
>> +        const struct acpi_device_id *id;
>> +
>> +        id = __acpi_match_device(device, handler->ids);
>> +        if (!id)
>> +            continue;
>> +
>> +        ret = handler->attach(device, id);
>> +        if (ret > 0) {
>> +            device->handler = handler;
>> +            break;
>> +        } else if (ret < 0) {
>> +            break;
>> +        }
>> +    }
>> +    return ret;
>> +}
>> +
>>   static acpi_status acpi_bus_device_attach(acpi_handle handle, u32 lvl_not_used,
>>                         void *not_used, void **ret_not_used)
>>   {
>>       const struct acpi_device_id *id;
>> -    acpi_status status = AE_OK;
>>       struct acpi_device *device;
>>       unsigned long long sta_not_used;
>> -    int type_not_used;
>> +    int ret;
>>
>>       /*
>>        * Ignore errors ignored by acpi_bus_check_add() to avoid terminating
>>        * namespace walks prematurely.
>>        */
>> -    if (acpi_bus_type_and_status(handle, &type_not_used, &sta_not_used))
>> +    if (acpi_bus_type_and_status(handle, &ret, &sta_not_used))
>>           return AE_OK;
>>
>>       if (acpi_bus_get_device(handle, &device))
>> @@ -1593,10 +1625,15 @@ static acpi_status acpi_bus_device_attac
>>       if (id) {
>>           /* This is a known good platform device. */
>>           acpi_create_platform_device(device, id->driver_data);
>> -    } else if (device_attach(&device->dev) < 0) {
>> -        status = AE_CTRL_DEPTH;
>> +        return AE_OK;
>>       }
>> -    return status;
>> +
>
>> +    ret = acpi_scan_attach_handler(device);
>> +    if (ret)
>> +        return ret > 0 ? AE_OK : AE_CTRL_DEPTH;
>
> acpi_scan_attach_hanlder() returns only 0 or -EINVAL.
> How about just return AE_CTRL_DEPTH?

I am wrong. Please forget it.

Thanks,
Yasuaki Ishimatsu

>
> Thanks,
> Yasuaki Ishimatsu
>
>> +
>> +    ret = device_attach(&device->dev);
>> +    return ret >= 0 ? AE_OK : AE_CTRL_DEPTH;
>>   }
>>
>>   /**
>> @@ -1639,8 +1676,17 @@ static acpi_status acpi_bus_device_detac
>>       struct acpi_device *device = NULL;
>>
>>       if (!acpi_bus_get_device(handle, &device)) {
>> +        struct acpi_scan_handler *dev_handler = device->handler;
>> +
>>           device->removal_type = ACPI_BUS_REMOVAL_EJECT;
>> -        device_release_driver(&device->dev);
>> +        if (dev_handler) {
>> +            if (dev_handler->detach)
>> +                dev_handler->detach(device);
>> +
>> +            device->handler = NULL;
>> +        } else {
>> +            device_release_driver(&device->dev);
>> +        }
>>       }
>>       return AE_OK;
>>   }
>> Index: test/Documentation/acpi/scan_handlers.txt
>> ===================================================================
>> --- /dev/null
>> +++ test/Documentation/acpi/scan_handlers.txt
>> @@ -0,0 +1,77 @@
>> +ACPI Scan Handlers
>> +
>> +Copyright (C) 2012, Intel Corporation
>> +Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> +
>> +During system initialization and ACPI-based device hot-add, the ACPI namespace
>> +is scanned in search of device objects that generally represent various pieces
>> +of hardware.  This causes a struct acpi_device object to be created and
>> +registered with the driver core for every device object in the ACPI namespace
>> +and the hierarchy of those struct acpi_device objects reflects the namespace
>> +layout (i.e. parent device objects in the namespace are represented by parent
>> +struct acpi_device objects and analogously for their children).  Those struct
>> +acpi_device objects are referred to as "device nodes" in what follows, but they
>> +should not be confused with struct device_node objects used by the Device Trees
>> +parsing code (although their role is analogous to the role of those objects).
>> +
>> +During ACPI-based device hot-remove device nodes representing pieces of hardware
>> +being removed are unregistered and deleted.
>> +
>> +The core ACPI namespace scanning code in drivers/acpi/scan.c carries out basic
>> +initialization of device nodes, such as retrieving common configuration
>> +information from the device objects represented by them and populating them with
>> +appropriate data, but some of them require additional handling after they have
>> +been registered.  For example, if the given device node represents a PCI host
>> +bridge, its registration should cause the PCI bus under that bridge to be
>> +enumerated and PCI devices on that bus to be registered with the driver core.
>> +Similarly, if the device node represents a PCI interrupt link, it is necessary
>> +to configure that link so that the kernel can use it.
>> +
>> +Those additional configuration tasks usually depend on the type of the hardware
>> +component represented by the given device node which can be determined on the
>> +basis of the device node's hardware ID (HID).  They are performed by objects
>> +called ACPI scan handlers represented by the following structure:
>> +
>> +struct acpi_scan_handler {
>> +    const struct acpi_device_id *ids;
>> +    struct list_head list_node;
>> +    int (*attach)(struct acpi_device *dev, const struct acpi_device_id *id);
>> +    void (*detach)(struct acpi_device *dev);
>> +};
>> +
>> +where ids is the list of IDs of device nodes the given handler is supposed to
>> +take care of, list_node is the hook to the global list of ACPI scan handlers
>> +maintained by the ACPI core and the .attach() and .detach() callbacks are
>> +executed, respectively, after registration of new device nodes and before
>> +unregistration of device nodes the handler attached to previously.
>> +
>> +The namespace scanning function, acpi_bus_scan(), first registers all of the
>> +device nodes in the given namespace scope with the driver core.  Then, it tries
>> +to match a scan handler against each of them using the ids arrays of the
>> +available scan handlers.  If a matching scan handler is found, its .attach()
>> +callback is executed for the given device node.  If that callback returns 1,
>> +that means that the handler has claimed the device node and is now responsible
>> +for carrying out any additional configuration tasks related to it.  It also will
>> +be responsible for preparing the device node for unregistration in that case.
>> +The device node's handler field is then populated with the address of the scan
>> +handler that has claimed it.
>> +
>> +If the .attach() callback returns 0, it means that the device node is not
>> +interesting to the given scan handler and may be matched against the next scan
>> +handler in the list.  If it returns a (negative) error code, that means that
>> +the namespace scan should be terminated due to a serious error.  The error code
>> +returned should then reflect the type of the error.
>> +
>> +The namespace trimming function, acpi_bus_trim(), first executes .detach()
>> +callbacks from the scan handlers of all device nodes in the given namespace
>> +scope (if they have scan handlers).  Next, it unregisters all of the device
>> +nodes in that scope.
>> +
>> +ACPI scan handlers can be added to the list maintained by the ACPI core with the
>> +help of the acpi_scan_add_handler() function taking a pointer to the new scan
>> +handler as an argument.  The order in which scan handlers are added to the list
>> +is the order in which they are matched against device nodes during namespace
>> +scans.
>> +
>> +All scan handles must be added to the list before acpi_bus_scan() is run for the
>> +first time and they cannot be removed from it.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


