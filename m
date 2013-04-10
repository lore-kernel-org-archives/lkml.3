Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964991Ab3DJQOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:14:16 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:37277 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933445Ab3DJQON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:14:13 -0400
Message-ID: <51658FCB.3030906@gmail.com>
Date: Thu, 11 Apr 2013 00:14:03 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "Rafael J . Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v8 10/13] PCI/acpiphp: do not use ACPI PCI subdriver mechanism
References: <1361892353-14786-1-git-send-email-jiang.liu@huawei.com> <1361892353-14786-11-git-send-email-jiang.liu@huawei.com> <CAErSpo4uyqPRDWKvH_3rtnGzbro1+_SnGH9GBU_-tz1p2a+AMQ@mail.gmail.com>
In-Reply-To: <CAErSpo4uyqPRDWKvH_3rtnGzbro1+_SnGH9GBU_-tz1p2a+AMQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 07:38 AM, Bjorn Helgaas wrote:
> On Tue, Feb 26, 2013 at 8:25 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> Previously the acpiphp driver registers itself as an ACPI PCI subdriver,
>> so it's callbacks will be invoked when creating/destroying PCI root
>> buses to manage ACPI based PCI hotplug slots. But it doesn't handle
>> P2P bridge hotplug events, so it will cause strange behavours if there
>> are hotplug slots associated with a hot-removed P2P bridge.
>>
>> So this patch tries to fix this issue by:
>> 1) Make acpiphp built-in only, not a module.
>> 2) Directly hook into PCI core to update hotplug slot devices when
>>    creating/destroying PCI buses through:
>>         pci_{add|remove}_bus() -> acpi_pci_{add|remove}_bus()
>> 3) Get rid of ACPI PCI subdriver related code, it's not used any more.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>> Cc: Toshi Kani <toshi.kani@hp.com>
>> Cc: linux-pci@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  drivers/pci/hotplug/Kconfig        |    7 +-
>>  drivers/pci/hotplug/acpiphp.h      |    3 -
>>  drivers/pci/hotplug/acpiphp_core.c |   23 +--
>>  drivers/pci/hotplug/acpiphp_glue.c |  282 +++++++-----------------------------
>>  drivers/pci/pci-acpi.c             |    3 +
>>  include/linux/pci-acpi.h           |   14 +-
>>  6 files changed, 67 insertions(+), 265 deletions(-)
>>
>> diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
>> index 13e9e63..9fcb87f 100644
>> --- a/drivers/pci/hotplug/Kconfig
>> +++ b/drivers/pci/hotplug/Kconfig
>> @@ -52,15 +52,12 @@ config HOTPLUG_PCI_IBM
>>           When in doubt, say N.
>>
>>  config HOTPLUG_PCI_ACPI
>> -       tristate "ACPI PCI Hotplug driver"
>> -       depends on (!ACPI_DOCK && ACPI) || (ACPI_DOCK)
>> +       bool "ACPI PCI Hotplug driver"
> 
Hi Bjorn,
	Thanks for review.

> My goal is that a user should never have to specify a kernel boot
> parameter or edit a modules.conf file, but the user did previously
> have some way to influence whether we use pciehp or acpiphp.  I know
> we still have some issues, particularly with acpiphp, so I'm a little
> concerned that by removing the CONFIG_HOTPLUG_PCI_ACPI=m, we might be
> removing a way to work around those issues.
> 
> A distro that previously used CONFIG_HOTPLUG_PCI_ACPI=m will now have
> to use =y, so modules.conf is no longer applicable.  Can you convince
> me that the user still has a way to work around issues?  I spent quite
> a while trying to understand the pciehp/acpiphp dependencies, but it's
> pretty tangled web.
I will try my best to explain the relationships between pciehp and acpiphp
as of v3.9-rc6.

The pciehp driver always have priority over the acpiphp driver.
That is, the acpiphp driver rejects binding to an ACPI PCI hotplug slot if
a) The slot's parent is a PCIe port with native hotplug capability
b) OSPM has taken over PCIe native hotplug control from BIOS. 
	!(root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL)
The above check has no dependency on the loading order of pciehp and acpiphp
drivers. So converting acpiphp driver to builit-in should be ok.

On the other hand, I remember Yinghai has mentioned that some PCIe ports
with native hotplug capability doesn't work as expected with the pciehp driver
and should be managed by the acpiphp driver. Currently we could achieve that
by using boot param "pcie_ports=compat", but this will disable PCIe port
drivers altogether. And I also remember that Rafael has mentioned that
some BIOSes exhibit strange dependency among PCIe OSC controls, so it's
not feasible to only disable PCIe native hotplug. 

For "pciehp_force", it does only affect the way pciehp to detect a hotplug
slot, it doesn't affect acpiphp at all.

To sum up, converting acpiphp as built-in should not affect the relationship
between pciehp and acpiphp driver. So how about splitting this patch into
two and adding more comments for the Kconfig change?

Regards!
Gerry

> 
> I would definitely like to see the changelog mention this issue and
> any changes a user might have to make, e.g., to replace a modules.conf
> edit.  It might be that this involves the "pciehp_force" option, and
> if it does, we should probably add a mention of this in
> Documentation/kernel-parameters.txt.
> 
> Can the Kconfig change be split into its own small patch without all
> the other stuff, or are they inseparable?
> 
> Bjorn
> 
>> +       depends on HOTPLUG_PCI=y && ((!ACPI_DOCK && ACPI) || (ACPI_DOCK))
>>         help
>>           Say Y here if you have a system that supports PCI Hotplug using
>>           ACPI.
>>
>> -         To compile this driver as a module, choose M here: the
>> -         module will be called acpiphp.
>> -
>>           When in doubt, say N.
>>
>>  config HOTPLUG_PCI_ACPI_IBM
>> diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
>> index 1b311f9..69b4aac 100644
>> --- a/drivers/pci/hotplug/acpiphp.h
>> +++ b/drivers/pci/hotplug/acpiphp.h
>> @@ -119,7 +119,6 @@ struct acpiphp_slot {
>>   */
>>  struct acpiphp_func {
>>         struct acpiphp_slot *slot;      /* parent */
>> -       struct acpiphp_bridge *bridge;  /* Ejectable PCI-to-PCI bridge */
>>
>>         struct list_head sibling;
>>         struct notifier_block nb;
>> @@ -176,8 +175,6 @@ extern int acpiphp_register_hotplug_slot(struct acpiphp_slot *slot);
>>  extern void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *slot);
>>
>>  /* acpiphp_glue.c */
>> -extern int acpiphp_glue_init (void);
>> -extern void acpiphp_glue_exit (void);
>>  typedef int (*acpiphp_callback)(struct acpiphp_slot *slot, void *data);
>>
>>  extern int acpiphp_enable_slot (struct acpiphp_slot *slot);
>> diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
>> index c2fd309..80d777c 100644
>> --- a/drivers/pci/hotplug/acpiphp_core.c
>> +++ b/drivers/pci/hotplug/acpiphp_core.c
>> @@ -37,6 +37,7 @@
>>
>>  #include <linux/kernel.h>
>>  #include <linux/pci.h>
>> +#include <linux/pci-acpi.h>
>>  #include <linux/pci_hotplug.h>
>>  #include <linux/slab.h>
>>  #include <linux/smp.h>
>> @@ -351,27 +352,7 @@ void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
>>  }
>>
>>
>> -static int __init acpiphp_init(void)
>> +void __init acpiphp_init(void)
>>  {
>>         info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
>> -
>> -       if (acpi_pci_disabled)
>> -               return 0;
>> -
>> -       /* read all the ACPI info from the system */
>> -       /* initialize internal data structure etc. */
>> -       return acpiphp_glue_init();
>> -}
>> -
>> -
>> -static void __exit acpiphp_exit(void)
>> -{
>> -       if (acpi_pci_disabled)
>> -               return;
>> -
>> -       /* deallocate internal data structures etc. */
>> -       acpiphp_glue_exit();
>>  }
>> -
>> -module_init(acpiphp_init);
>> -module_exit(acpiphp_exit);
>> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
>> index 89e0c36..3db84b6 100644
>> --- a/drivers/pci/hotplug/acpiphp_glue.c
>> +++ b/drivers/pci/hotplug/acpiphp_glue.c
>> @@ -157,6 +157,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
>>         int device, function, retval;
>>         struct pci_bus *pbus = bridge->pci_bus;
>>         struct pci_dev *pdev;
>> +       u32 val;
>>
>>         if (!acpi_pci_check_ejectable(pbus, handle) && !is_dock_device(handle))
>>                 return AE_OK;
>> @@ -249,11 +250,9 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
>>         newfunc->slot = slot;
>>         list_add_tail(&newfunc->sibling, &slot->funcs);
>>
>> -       pdev = pci_get_slot(pbus, PCI_DEVFN(device, function));
>> -       if (pdev) {
>> +       if (pci_bus_read_dev_vendor_id(pbus, PCI_DEVFN(device, function),
>> +                                      &val, 60*1000))
>>                 slot->flags |= (SLOT_ENABLED | SLOT_POWEREDON);
>> -               pci_dev_put(pdev);
>> -       }
>>
>>         if (is_dock_device(handle)) {
>>                 /* we don't want to call this device's _EJ0
>> @@ -366,148 +365,6 @@ static struct acpiphp_func *acpiphp_bridge_handle_to_function(acpi_handle handle
>>  }
>>
>>
>> -static inline void config_p2p_bridge_flags(struct acpiphp_bridge *bridge)
>> -{
>> -       acpi_handle dummy_handle;
>> -       struct acpiphp_func *func;
>> -
>> -       if (ACPI_SUCCESS(acpi_get_handle(bridge->handle,
>> -                                       "_EJ0", &dummy_handle))) {
>> -               bridge->flags |= BRIDGE_HAS_EJ0;
>> -
>> -               dbg("found ejectable p2p bridge\n");
>> -
>> -               /* make link between PCI bridge and PCI function */
>> -               func = acpiphp_bridge_handle_to_function(bridge->handle);
>> -               if (!func)
>> -                       return;
>> -               bridge->func = func;
>> -               func->bridge = bridge;
>> -       }
>> -}
>> -
>> -
>> -/* allocate and initialize host bridge data structure */
>> -static void add_host_bridge(struct acpi_pci_root *root)
>> -{
>> -       struct acpiphp_bridge *bridge;
>> -       acpi_handle handle = root->device->handle;
>> -
>> -       bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
>> -       if (bridge == NULL)
>> -               return;
>> -
>> -       bridge->handle = handle;
>> -
>> -       bridge->pci_bus = root->bus;
>> -
>> -       init_bridge_misc(bridge);
>> -}
>> -
>> -
>> -/* allocate and initialize PCI-to-PCI bridge data structure */
>> -static void add_p2p_bridge(acpi_handle *handle)
>> -{
>> -       struct acpiphp_bridge *bridge;
>> -
>> -       bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
>> -       if (bridge == NULL) {
>> -               err("out of memory\n");
>> -               return;
>> -       }
>> -
>> -       bridge->handle = handle;
>> -       config_p2p_bridge_flags(bridge);
>> -
>> -       bridge->pci_dev = acpi_get_pci_dev(handle);
>> -       bridge->pci_bus = bridge->pci_dev->subordinate;
>> -       if (!bridge->pci_bus) {
>> -               err("This is not a PCI-to-PCI bridge!\n");
>> -               goto err;
>> -       }
>> -
>> -       /*
>> -        * Grab a ref to the subordinate PCI bus in case the bus is
>> -        * removed via PCI core logical hotplug. The ref pins the bus
>> -        * (which we access during module unload).
>> -        */
>> -       get_device(&bridge->pci_bus->dev);
>> -
>> -       init_bridge_misc(bridge);
>> -       return;
>> - err:
>> -       pci_dev_put(bridge->pci_dev);
>> -       kfree(bridge);
>> -       return;
>> -}
>> -
>> -
>> -/* callback routine to find P2P bridges */
>> -static acpi_status
>> -find_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
>> -{
>> -       acpi_status status;
>> -       struct pci_dev *dev;
>> -
>> -       dev = acpi_get_pci_dev(handle);
>> -       if (!dev || !dev->subordinate)
>> -               goto out;
>> -
>> -       /* check if this bridge has ejectable slots */
>> -       if ((detect_ejectable_slots(handle) > 0)) {
>> -               dbg("found PCI-to-PCI bridge at PCI %s\n", pci_name(dev));
>> -               add_p2p_bridge(handle);
>> -       }
>> -
>> -       /* search P2P bridges under this p2p bridge */
>> -       status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
>> -                                    find_p2p_bridge, NULL, NULL, NULL);
>> -       if (ACPI_FAILURE(status))
>> -               warn("find_p2p_bridge failed (error code = 0x%x)\n", status);
>> -
>> - out:
>> -       pci_dev_put(dev);
>> -       return AE_OK;
>> -}
>> -
>> -
>> -/* find hot-pluggable slots, and then find P2P bridge */
>> -static int add_bridge(struct acpi_pci_root *root)
>> -{
>> -       acpi_status status;
>> -       unsigned long long tmp;
>> -       acpi_handle dummy_handle;
>> -       acpi_handle handle = root->device->handle;
>> -
>> -       /* if the bridge doesn't have _STA, we assume it is always there */
>> -       status = acpi_get_handle(handle, "_STA", &dummy_handle);
>> -       if (ACPI_SUCCESS(status)) {
>> -               status = acpi_evaluate_integer(handle, "_STA", NULL, &tmp);
>> -               if (ACPI_FAILURE(status)) {
>> -                       dbg("%s: _STA evaluation failure\n", __func__);
>> -                       return 0;
>> -               }
>> -               if ((tmp & ACPI_STA_DEVICE_FUNCTIONING) == 0)
>> -                       /* don't register this object */
>> -                       return 0;
>> -       }
>> -
>> -       /* check if this bridge has ejectable slots */
>> -       if (detect_ejectable_slots(handle) > 0) {
>> -               dbg("found PCI host-bus bridge with hot-pluggable slots\n");
>> -               add_host_bridge(root);
>> -       }
>> -
>> -       /* search P2P bridges under this host bridge */
>> -       status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
>> -                                    find_p2p_bridge, NULL, NULL, NULL);
>> -
>> -       if (ACPI_FAILURE(status))
>> -               warn("find_p2p_bridge failed (error code = 0x%x)\n", status);
>> -
>> -       return 0;
>> -}
>> -
>>  static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)
>>  {
>>         struct acpiphp_bridge *bridge;
>> @@ -567,56 +424,12 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
>>                 slot = next;
>>         }
>>
>> -       /*
>> -        * Only P2P bridges have a pci_dev
>> -        */
>> -       if (bridge->pci_dev)
>> -               put_device(&bridge->pci_bus->dev);
>> -
>> +       put_device(&bridge->pci_bus->dev);
>>         pci_dev_put(bridge->pci_dev);
>>         list_del(&bridge->list);
>>         kfree(bridge);
>>  }
>>
>> -static acpi_status
>> -cleanup_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
>> -{
>> -       struct acpiphp_bridge *bridge;
>> -
>> -       /* cleanup p2p bridges under this P2P bridge
>> -          in a depth-first manner */
>> -       acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
>> -                               cleanup_p2p_bridge, NULL, NULL, NULL);
>> -
>> -       bridge = acpiphp_handle_to_bridge(handle);
>> -       if (bridge)
>> -               cleanup_bridge(bridge);
>> -
>> -       return AE_OK;
>> -}
>> -
>> -static void remove_bridge(struct acpi_pci_root *root)
>> -{
>> -       struct acpiphp_bridge *bridge;
>> -       acpi_handle handle = root->device->handle;
>> -
>> -       /* cleanup p2p bridges under this host bridge
>> -          in a depth-first manner */
>> -       acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
>> -                               (u32)1, cleanup_p2p_bridge, NULL, NULL, NULL);
>> -
>> -       /*
>> -        * On root bridges with hotplug slots directly underneath (ie,
>> -        * no p2p bridge between), we call cleanup_bridge().
>> -        *
>> -        * The else clause cleans up root bridges that either had no
>> -        * hotplug slots at all, or had a p2p bridge underneath.
>> -        */
>> -       bridge = acpiphp_handle_to_bridge(handle);
>> -       if (bridge)
>> -               cleanup_bridge(bridge);
>> -}
>> -
>>  static int power_on_slot(struct acpiphp_slot *slot)
>>  {
>>         acpi_status status;
>> @@ -802,6 +615,7 @@ static void check_hotplug_bridge(struct acpiphp_slot *slot, struct pci_dev *dev)
>>                 }
>>         }
>>  }
>> +
>>  /**
>>   * enable_device - enable, configure a slot
>>   * @slot: slot to be enabled
>> @@ -816,7 +630,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>>         struct acpiphp_func *func;
>>         int retval = 0;
>>         int num, max, pass;
>> -       acpi_status status;
>>
>>         if (slot->flags & SLOT_ENABLED)
>>                 goto err_exit;
>> @@ -871,18 +684,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>>                         slot->flags &= (~SLOT_ENABLED);
>>                         continue;
>>                 }
>> -
>> -               if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE &&
>> -                   dev->hdr_type != PCI_HEADER_TYPE_CARDBUS) {
>> -                       pci_dev_put(dev);
>> -                       continue;
>> -               }
>> -
>> -               status = find_p2p_bridge(func->handle, (u32)1, bus, NULL);
>> -               if (ACPI_FAILURE(status))
>> -                       warn("find_p2p_bridge failed (error code = 0x%x)\n",
>> -                               status);
>> -               pci_dev_put(dev);
>>         }
>>
>>
>> @@ -916,16 +717,6 @@ static int disable_device(struct acpiphp_slot *slot)
>>  {
>>         struct acpiphp_func *func;
>>         struct pci_dev *pdev;
>> -       struct pci_bus *bus = slot->bridge->pci_bus;
>> -
>> -       list_for_each_entry(func, &slot->funcs, sibling) {
>> -               if (func->bridge) {
>> -                       /* cleanup p2p bridges under this P2P bridge */
>> -                       cleanup_p2p_bridge(func->bridge->handle,
>> -                                               (u32)1, NULL, NULL);
>> -                       func->bridge = NULL;
>> -               }
>> -       }
>>
>>         /*
>>          * enable_device() enumerates all functions in this device via
>> @@ -944,7 +735,6 @@ static int disable_device(struct acpiphp_slot *slot)
>>
>>         slot->flags &= (~SLOT_ENABLED);
>>
>> -err_exit:
>>         return 0;
>>  }
>>
>> @@ -1285,30 +1075,56 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
>>         alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_func);
>>  }
>>
>> -static struct acpi_pci_driver acpi_pci_hp_driver = {
>> -       .add =          add_bridge,
>> -       .remove =       remove_bridge,
>> -};
>> -
>> -/**
>> - * acpiphp_glue_init - initializes all PCI hotplug - ACPI glue data structures
>> +/*
>> + * Create hotplug slots for the PCI bus.
>> + * It should always return 0 to avoid skipping following notifiers.
>>   */
>> -int __init acpiphp_glue_init(void)
>> +void acpiphp_enumerate_slots(struct pci_bus *bus, acpi_handle handle)
>>  {
>> -       acpi_pci_register_driver(&acpi_pci_hp_driver);
>> +       acpi_handle dummy_handle;
>> +       struct acpiphp_bridge *bridge;
>>
>> -       return 0;
>> -}
>> +       if (detect_ejectable_slots(handle) <= 0)
>> +               return;
>>
>> +       bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
>> +       if (bridge == NULL) {
>> +               err("out of memory\n");
>> +               return;
>> +       }
>>
>> -/**
>> - * acpiphp_glue_exit - terminates all PCI hotplug - ACPI glue data structures
>> - *
>> - * This function frees all data allocated in acpiphp_glue_init().
>> - */
>> -void  acpiphp_glue_exit(void)
>> +       bridge->handle = handle;
>> +       bridge->pci_dev = pci_dev_get(bus->self);
>> +       bridge->pci_bus = bus;
>> +
>> +       /*
>> +        * Grab a ref to the subordinate PCI bus in case the bus is
>> +        * removed via PCI core logical hotplug. The ref pins the bus
>> +        * (which we access during module unload).
>> +        */
>> +       get_device(&bus->dev);
>> +
>> +       if (!pci_is_root_bus(bridge->pci_bus) &&
>> +           ACPI_SUCCESS(acpi_get_handle(bridge->handle,
>> +                                       "_EJ0", &dummy_handle))) {
>> +               dbg("found ejectable p2p bridge\n");
>> +               bridge->flags |= BRIDGE_HAS_EJ0;
>> +               bridge->func = acpiphp_bridge_handle_to_function(handle);
>> +       }
>> +
>> +       init_bridge_misc(bridge);
>> +}
>> +
>> +/* Destroy hotplug slots associated with the PCI bus */
>> +void acpiphp_remove_slots(struct pci_bus *bus)
>>  {
>> -       acpi_pci_unregister_driver(&acpi_pci_hp_driver);
>> +       struct acpiphp_bridge *bridge, *tmp;
>> +
>> +       list_for_each_entry_safe(bridge, tmp, &bridge_list, list)
>> +               if (bridge->pci_bus == bus) {
>> +                       cleanup_bridge(bridge);
>> +                       break;
>> +               }
>>  }
>>
>>  /**
>> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
>> index 2dbca38..6fe7bf8 100644
>> --- a/drivers/pci/pci-acpi.c
>> +++ b/drivers/pci/pci-acpi.c
>> @@ -297,6 +297,7 @@ void acpi_pci_add_bus(struct pci_bus *bus)
>>                 return;
>>
>>         acpi_pci_slot_enumerate(bus, handle);
>> +       acpiphp_enumerate_slots(bus, handle);
>>  }
>>
>>  void acpi_pci_remove_bus(struct pci_bus *bus)
>> @@ -308,6 +309,7 @@ void acpi_pci_remove_bus(struct pci_bus *bus)
>>         if (acpi_pci_disabled)
>>                 return;
>>
>> +       acpiphp_remove_slots(bus);
>>         acpi_pci_slot_remove(bus);
>>  }
>>
>> @@ -384,6 +386,7 @@ static int __init acpi_pci_init(void)
>>
>>         pci_set_platform_pm(&acpi_pci_platform_pm);
>>         acpi_pci_slot_init();
>> +       acpiphp_init();
>>
>>         return 0;
>>  }
>> diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
>> index 1ef126f..f1b2380 100644
>> --- a/include/linux/pci-acpi.h
>> +++ b/include/linux/pci-acpi.h
>> @@ -56,9 +56,17 @@ static inline void acpi_pci_slot_enumerate(struct pci_bus *bus,
>>  static inline void acpi_pci_slot_remove(struct pci_bus *bus) { }
>>  #endif
>>
>> -#else  /* CONFIG_ACPI */
>> -static inline void acpi_pci_add_bus(struct pci_bus *bus) { }
>> -static inline void acpi_pci_remove_bus(struct pci_bus *bus) { }
>> +#ifdef CONFIG_HOTPLUG_PCI_ACPI
>> +void acpiphp_init(void);
>> +void acpiphp_enumerate_slots(struct pci_bus *bus, acpi_handle handle);
>> +void acpiphp_remove_slots(struct pci_bus *bus);
>> +#else
>> +static inline void acpiphp_init(void) { }
>> +static inline void acpiphp_enumerate_slots(struct pci_bus *bus,
>> +                                          acpi_handle handle) { }
>> +static inline void acpiphp_remove_slots(struct pci_bus *bus) { }
>> +#endif
>> +
>>  #endif /* CONFIG_ACPI */
>>
>>  #ifdef CONFIG_ACPI_APEI
>> --
>> 1.7.9.5
>>

