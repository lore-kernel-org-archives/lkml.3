Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3AUCdD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 21:33:03 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:57585 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3AUCdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 21:33:00 -0500
MIME-Version: 1.0
In-Reply-To: <9639993.DWkmFxRIH0@vostro.rjw.lan>
References: <1358495602-22867-1-git-send-email-yinghai@kernel.org>
	<1358495602-22867-8-git-send-email-yinghai@kernel.org>
	<9639993.DWkmFxRIH0@vostro.rjw.lan>
Date: Sun, 20 Jan 2013 18:32:59 -0800
X-Google-Sender-Auth: 2OIl5efMBcGgFbVsea-Pgkzgo1Q
Message-ID: <CAE9FiQUd9XpQLWFDR3TvG6MDBzxC9frQr9UepFG=r1iHCjac1Q@mail.gmail.com>
Subject: Re: [PATCH v9 07/11] PCI, acpiphp: Move and enhance hotplug support
 of pci host bridge
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 2:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, January 17, 2013 11:53:18 PM Yinghai Lu wrote:
>> We have partial hot-add support in acpiphp driver, and it is confusing.
>>
>> Move host bridge hot-add support to pci_root.c, and keep acpiphp simple,
>> also add hot-remove support in pci_root.c.
>>
>> How to test it: if sci_emu patch is applied,
>>
>> Find out root bus number to acpi root name mapping from dmesg or /sys
>>
>>   echo "\_SB.PCIB 3" > /sys/kernel/debug/acpi/sci_notify
>> to remove root bus
>>
>>   echo "\_SB.PCIB 1" > /sys/kernel/debug/acpi/sci_notify
>> to add back root bus
>>
>> -v2: put back pci_root_hp change in one patch
>> -v3: add pcibios_resource_survey_bus() calling
>> -v4: remove not needed code with remove_bridge
>> -v5: put back support for acpiphp support for slots just on root bus.
>> -v6: change some functions to *_p2p_* to make it more clean.
>> -v7: split hot_added change out.
>> -v8: Move to pci_root.c instead of adding another file requested by Bjorn.
>> -v9: Fold three following patches into this one for easy review:
>>       a: Add missing hot_remove support for root device.
>>       b: Tang Chen noticed that hotplug through container will not update
>>          acpi_root_bridge list. After closely checking, we don't need
>>          that for struct for tracking and could use acpi_pci_root directly.
>>       c: Tang Chen found handle_root_bridge_removal is very similiar to
>>          acpi_bus_hot_remove_device().  Change to handle_root_bridge_removal
>>          to use acpi_bus_hot_remove_device.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/acpi/pci_root.c            |  139 ++++++++++++++++++++++++++++++++++++
>>  drivers/pci/hotplug/acpiphp_glue.c |   59 ++++-----------
>>  2 files changed, 154 insertions(+), 44 deletions(-)
>>
>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>> index bf5108a..3ce5d80 100644
>> --- a/drivers/acpi/pci_root.c
>> +++ b/drivers/acpi/pci_root.c
>> @@ -655,3 +655,142 @@ int __init acpi_pci_root_init(void)
>>
>>       return 0;
>>  }
>> +
>> +/* Support root bridge hotplug */
>> +
>> +static void handle_root_bridge_insertion(acpi_handle handle)
>> +{
>> +     struct acpi_device *device, *pdevice;
>> +     acpi_handle phandle;
>> +     int ret_val;
>> +
>> +     acpi_get_parent(handle, &phandle);
>> +     if (acpi_bus_get_device(phandle, &pdevice)) {
>> +             printk(KERN_DEBUG "no parent device, assuming NULL\n");
>> +             pdevice = NULL;
>> +     }
>> +     if (!acpi_bus_get_device(handle, &device)) {
>> +             /* check if  pci root_bus is removed */
>> +             struct acpi_pci_root *root = acpi_driver_data(device);
>> +             if (pci_find_bus(root->segment, root->secondary.start))
>> +                     return;
>> +
>> +             printk(KERN_DEBUG "bus exists... trim\n");
>> +             /* this shouldn't be in here, so remove
>> +              * the bus then re-add it...
>> +              */
>> +             ret_val = acpi_bus_trim(device);
>
> You said that this followed acpiphp, but the purpose of the trimming in there
> seems to be to handle surprise removal and re-insertion, which I'm not sure is
> OK with something like a host bridge.

ok, will just bail out if it is there.

>
> The drawback is that if we have a spurious ACPI_NOTIFY_BUS_CHECK or
> ACPI_NOTIFY_DEVICE_CHECK, we'll be trying to remove the whole bus here in
> response.  That doesn't sound quite right.
>
>> +             printk(KERN_DEBUG "acpi_bus_trim return %x\n", ret_val);
>> +     }
>> +     if (acpi_bus_add(handle))
>> +             printk(KERN_ERR "cannot add bridge to acpi list\n");
>> +}
>> +
>> +static void handle_root_bridge_removal(struct acpi_device *device)
>> +{
>> +     struct acpi_eject_event *ej_event;
>> +
>> +     ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
>> +     if (!ej_event)
>
> Shouldn't we do acpi_evaluate_hotplug_ost() here?

ok. will add

                /* Inform firmware the hot-remove operation has error */
                (void) acpi_evaluate_hotplug_ost(device->handle,
                                        ACPI_NOTIFY_EJECT_REQUEST,
                                        ACPI_OST_SC_NON_SPECIFIC_FAILURE,
                                        NULL);

before return.

>
>> +             return;
>> +
>> +     ej_event->device = device;
>> +     ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
>> +
>> +     acpi_bus_hot_remove_device(ej_event);
>> +}
>> +
>> +static void _handle_hotplug_event_root(struct work_struct *work)
>> +{
>> +     struct acpi_pci_root *root;
>> +     char objname[64];
>> +     struct acpi_buffer buffer = { .length = sizeof(objname),
>> +                                   .pointer = objname };
>> +     struct acpi_hp_work *hp_work;
>> +     acpi_handle handle;
>> +     u32 type;
>> +
>> +     hp_work = container_of(work, struct acpi_hp_work, work);
>> +     handle = hp_work->handle;
>> +     type = hp_work->type;
>> +
>> +     root = acpi_pci_find_root(handle);
>> +
>> +     acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>
> Is the path guaranteed not to be longer than 64 characters?

good. will use

struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER };

instead.

>
>> +
>> +     switch (type) {
>> +     case ACPI_NOTIFY_BUS_CHECK:
>> +             /* bus enumerate */
>> +             printk(KERN_DEBUG "%s: Bus check notify on %s\n", __func__,
>> +                              objname);
>
> pr_debug() would be nicer (and analogously below).

maybe we can change that later after it gets stable a bit.

>
>> +             if (!root)
>> +                     handle_root_bridge_insertion(handle);
>> +
>> +             break;
>> +
>> +     case ACPI_NOTIFY_DEVICE_CHECK:
>> +             /* device check */
>> +             printk(KERN_DEBUG "%s: Device check notify on %s\n", __func__,
>> +                              objname);
>> +             if (!root)
>> +                     handle_root_bridge_insertion(handle);
>> +             break;
>> +
>> +     case ACPI_NOTIFY_EJECT_REQUEST:
>> +             /* request device eject */
>> +             printk(KERN_DEBUG "%s: Device eject notify on %s\n", __func__,
>> +                              objname);
>> +             if (root)
>> +                     handle_root_bridge_removal(root->device);
>> +             break;
>> +     default:
>> +             printk(KERN_WARNING "notify_handler: unknown event type 0x%x for %s\n",
>> +                              type, objname);
>> +             break;
>> +     }
>> +
>> +     kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
>> +}
>> +
>> +static void handle_hotplug_event_root(acpi_handle handle, u32 type,
>> +                                     void *context)
>> +{
>> +     alloc_acpi_hp_work(handle, type, context,
>> +                             _handle_hotplug_event_root);
>> +}
>> +
>> +static acpi_status __init
>> +find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
>> +{
>> +     char objname[64];
>> +     struct acpi_buffer buffer = { .length = sizeof(objname),
>> +                                   .pointer = objname };
>> +     int *count = (int *)context;
>> +
>> +     if (!acpi_is_root_bridge(handle))
>> +             return AE_OK;
>> +
>> +     (*count)++;
>> +
>> +     acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>> +
>> +     acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
>> +                             handle_hotplug_event_root, NULL);
>> +     printk(KERN_DEBUG "acpi root: %s notify handler installed\n", objname);
>> +
>> +     return AE_OK;
>> +}
>> +
>> +static int __init acpi_pci_root_hp_init(void)
>> +{
>> +     int num = 0;
>> +
>> +     acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
>> +             ACPI_UINT32_MAX, find_root_bridges, NULL, &num, NULL);
>> +
>> +     printk(KERN_DEBUG "Found %d acpi root devices\n", num);
>> +
>> +     return 0;
>> +}
>> +
>> +subsys_initcall(acpi_pci_root_hp_init);
>
> Why do we need a separate initcall here?  Is it not enough to call
> acpi_pci_root_hp_init() from acpi_init() or acpi_scan_init(), or
> acpi_pci_root_init() even?

ok, will give it a try.

Thanks

Yinghai
