Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3AOGoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:44:07 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:38888 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3AOGoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:44:05 -0500
MIME-Version: 1.0
In-Reply-To: <1493550.As37othyQz@vostro.rjw.lan>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
	<1357944049-29620-9-git-send-email-yinghai@kernel.org>
	<1493550.As37othyQz@vostro.rjw.lan>
Date: Mon, 14 Jan 2013 22:44:02 -0800
X-Google-Sender-Auth: p8aiMqJCmIVMRzbUqxC0cJC6e_k
Message-ID: <CAE9FiQX6q-tbQuq_0mc0kBFC-bb0zKRDyg=aGLkrAeh5Y7FkYg@mail.gmail.com>
Subject: Re: [PATCH v8 08/22] PCI, acpiphp: Separate out hot-add support of
 pci host bridge
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

On Sat, Jan 12, 2013 at 3:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> @@ -673,3 +673,223 @@ int __init acpi_pci_root_init(void)
>>
>>       return 0;
>>  }
>> +
>> +/*
>> + * Separated from drivers/pci/hotplug/acpiphp_glue.c
>> + *   only support root bridge
>> + */
>
> This comment will be useless after applying the patch.
>
>> +
>> +static LIST_HEAD(acpi_root_bridge_list);
>> +struct acpi_root_bridge {
>> +     struct list_head list;
>> +     acpi_handle handle;
>> +     u32 flags;
>> +};
>
> We have struct acpi_pci_root already.  Why do we need this in addition?

will address that in following patch.

>
> Also, we have acpi_pci_roots, so why do we need another list of root bridges?
>
>> +
>> +/* bridge flags */
>> +#define ROOT_BRIDGE_HAS_EJ0  (0x00000002)
>> +#define ROOT_BRIDGE_HAS_PS3  (0x00000080)
>
> What is that needed for?

will address that in following patch.

>
>> +
>> +#define ACPI_STA_FUNCTIONING (0x00000008)
>> +
>> +static struct acpi_root_bridge *acpi_root_handle_to_bridge(acpi_handle handle)
>> +{
>> +     struct acpi_root_bridge *bridge;
>> +
>> +     list_for_each_entry(bridge, &acpi_root_bridge_list, list)
>> +             if (bridge->handle == handle)
>> +                     return bridge;
>> +
>> +     return NULL;
>> +}
>> +
>> +/* allocate and initialize host bridge data structure */
>> +static void add_acpi_root_bridge(acpi_handle handle)
>> +{
>> +     struct acpi_root_bridge *bridge;
>> +     acpi_handle dummy_handle;
>> +     acpi_status status;
>> +
>
> Why do we need to evaluate all of the methods directly here?
>
> Don't we have a struct acpi_device for handle already?
>
>> +     /* if the bridge doesn't have _STA, we assume it is always there */
>> +     status = acpi_get_handle(handle, "_STA", &dummy_handle);
>> +     if (ACPI_SUCCESS(status)) {
>> +             unsigned long long tmp;
>> +
>> +             status = acpi_evaluate_integer(handle, "_STA", NULL, &tmp);
>> +             if (ACPI_FAILURE(status)) {
>> +                     printk(KERN_DEBUG "%s: _STA evaluation failure\n",
>> +                                              __func__);
>> +                     return;
>> +             }
>> +             if ((tmp & ACPI_STA_FUNCTIONING) == 0)
>> +                     /* don't register this object */
>> +                     return;
>> +     }
>> +
>> +     bridge = kzalloc(sizeof(struct acpi_root_bridge), GFP_KERNEL);
>> +     if (!bridge)
>> +             return;
>> +
>> +     bridge->handle = handle;
>> +
>> +     if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0", &dummy_handle)))
>> +             bridge->flags |= ROOT_BRIDGE_HAS_EJ0;
>> +     if (ACPI_SUCCESS(acpi_get_handle(handle, "_PS3", &dummy_handle)))
>> +             bridge->flags |= ROOT_BRIDGE_HAS_PS3;
>
> All of this attempts to duplicate the scanning code from scan.c in a very
> incomplete and questionable way.
>
> For example, what if the root bridge has _PR0?

will address that in following patch

>
>> +
>> +     list_add(&bridge->list, &acpi_root_bridge_list);
>> +}
>> +
>> +struct acpi_root_hp_work {
>> +     struct work_struct work;
>> +     acpi_handle handle;
>> +     u32 type;
>> +     void *context;
>> +};
>> +
>> +static void alloc_acpi_root_hp_work(acpi_handle handle, u32 type,
>> +                                     void *context,
>> +                                     void (*func)(struct work_struct *work))
>> +{
>> +     struct acpi_root_hp_work *hp_work;
>> +     int ret;
>> +
>> +     hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
>> +     if (!hp_work)
>> +             return;
>> +
>> +     hp_work->handle = handle;
>> +     hp_work->type = type;
>> +     hp_work->context = context;
>> +
>> +     INIT_WORK(&hp_work->work, func);
>> +     ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
>> +     if (!ret)
>> +             kfree(hp_work);
>> +}
>
> The function above is called only once and used by __init stuff only.
> Why don't we move it to the caller and mark that caller as __init too?

will merge the function and shared with acpiphp

>
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
>
> Why?  Shouldn't we just bail out here?

should be the same from acpiphp.

>
>> +             /* remove pci devices at first */
>> +             ret_val = acpi_bus_trim(device, 0);
>> +             printk(KERN_DEBUG "acpi_bus_trim stop return %x\n", ret_val);
>> +             /* remove acpi devices */
>> +             ret_val = acpi_bus_trim(device, 1);
>
> Oh, I see why you need the second argument of acpi_bus_trim() now.
>
> Do I think correctly that you want acpi_pci_root_remove() to be executed before
> all of the struct acpi_device objects are removed?  In which case why don't we
> call acpi_pci_root_remove() directly before doing the acpi_bus_trim(device, 1)
> instead of making the code next to impossible to understand?

yes.

>
>> +             printk(KERN_DEBUG "acpi_bus_trim remove return %x\n", ret_val);
>> +     }
>> +     if (acpi_bus_add(handle))
>> +             printk(KERN_ERR "cannot add bridge to acpi list\n");
>> +}
>> +
>> +static void _handle_hotplug_event_root(struct work_struct *work)
>> +{
>> +     struct acpi_root_bridge *bridge;
>> +     char objname[64];
>> +     struct acpi_buffer buffer = { .length = sizeof(objname),
>> +                                   .pointer = objname };
>> +     struct acpi_root_hp_work *hp_work;
>> +     acpi_handle handle;
>> +     u32 type;
>> +
>> +     hp_work = container_of(work, struct acpi_root_hp_work, work);
>> +     handle = hp_work->handle;
>> +     type = hp_work->type;
>> +
>> +     bridge = acpi_root_handle_to_bridge(handle);
>> +
>> +     acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>> +
>> +     switch (type) {
>> +     case ACPI_NOTIFY_BUS_CHECK:
>> +             /* bus enumerate */
>> +             printk(KERN_DEBUG "%s: Bus check notify on %s\n", __func__,
>> +                              objname);
>> +             if (!bridge) {
>> +                     handle_root_bridge_insertion(handle);
>
> I don't think we should call add_acpi_root_bridge() for handle if the above
> fails.  So probably handle_root_bridge_insertion() should return error codes?

yes

>
>> +                     add_acpi_root_bridge(handle);

will remove root bridge in following patch.

>> +             }
>> +
>> +             break;
>> +
>> +     case ACPI_NOTIFY_DEVICE_CHECK:
>> +             /* device check */
>> +             printk(KERN_DEBUG "%s: Device check notify on %s\n", __func__,
>> +                              objname);
>> +             if (!bridge) {
>> +                     handle_root_bridge_insertion(handle);
>> +                     add_acpi_root_bridge(handle);
>> +             }
>> +             break;
>> +
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
>> +     alloc_acpi_root_hp_work(handle, type, context,
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
>> +     add_acpi_root_bridge(handle);
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
>
> Why do we need to do that from an initcall?  Couldn't we simply hook up
> that code to acpi_pci_root_add() somewhere?

no, not inserted host bridge will not have acpi_pci_root_add called.

>
> And even if not, why don't we call acpi_pci_root_hp_init() from
> acpi_pci_root_init()?

will check if can move that to acpi_pci_root_init and address that in
another patch.

>
> All of the changes in acpiphp_glue.c look reasonable to me.

Good.
