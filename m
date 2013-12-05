Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3LEWlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:41:03 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44802 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3LEWk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:40:59 -0500
MIME-Version: 1.0
In-Reply-To: <33026900.FbCAopDPFz@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
 <3611889.9a0SszCTpv@vostro.rjw.lan> <5750980.G76cQES87j@vostro.rjw.lan> <33026900.FbCAopDPFz@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 5 Dec 2013 15:40:39 -0700
Message-ID: <CAErSpo6edmz5nkSYogbYk1FFYsCCwNV_-rir2jGP2JBnvOx+iw@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Myron Stowe <myron.stowe@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 7:49 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> ...
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: PCI / hotplug / ACPI: Fix concurrency problems related to device removal
>
> The following are concurrency problems related to the PCI device
> removal code in pci-sysfs.c and in ACPIPHP present in the current
> mainline kernel:

You've found a bunch of issues.  I don't think there's anything to
gain by fixing them all in a single patch, and I think it would be
useful to split them out to help us think about them and find other
places that have similar problems.

> Scenario 1: pci_stop_and_remove_bus_device() run concurrently for
>   the same top device from remove_callback() in pci-sysfs.c and
>   from trim_stale_devices() in acpiphp_glue.c.
>
>   In this scenario the second code path is executed without
>   pci_remove_rescan_mutex locked, so the &bus->devices list
>   walks in either trim_stale_devices() itself or in
>   acpiphp_check_bridge() can suffer from list corruption while the
>   first code path is executing pci_destroy_dev() for one of the
>   devices on those lists.

Protecting &bus->devices is a generic problem, isn't it?  There are
about a zillion uses of it.  Many are in the pcibios_fixup_bus() path.
 I think we can get rid of most of those by integrating the work into
the pci_scan_device() path instead of doing it as a post-discovery
fixup, but there will be several other cases left.  If using
pci_remove_rescan_mutex to protect &bus->devices is the right generic
answer, we should document that and audit every place that uses the
list.

>   Moreover, if any of the device objects in question is freed
>   after pci_destroy_dev() executed by the first code path, the
>   second code path may suffer a use-after-free problem while
>   trying to access that device object.
>
>   Conversely, the second code path may execute pci_destroy_dev()
>   for one of the devices in question such that one of the
>   &bus->devices list walks in pci_stop_bus_device()
>   or pci_remove_bus_device() executed by the first code path will
>   suffer from a list corruption.
>
>   Moreover, use-after-free is also possible if one of the device
>   objects in question is freed as a result of calling
>   pci_destroy_dev() by the second code path and then the first
>   code path tries to access it (the first code path only holds
>   an extra reference to the device it has been run for, but not
>   for its child devices).

The use-after-free problems *sound* like a reference counting issue.
Yinghai's patch [1] should fix some of this; how much is left after
that?

[1] http://lkml.kernel.org/r/1385851238-21085-4-git-send-email-yinghai@kernel.org

> Scenario 2: ACPI hotplug event occurs for a device under a bridge
>   being removed by pci_stop_and_remove_bus_device() run from
>   remove_callback() in pci-sysfs.c.
>
>   In that case it doesn't make sense to handle the hotplug event,
>   because the device in question will be removed anyway along with
>   its parent bridge and that will cause the context objects needed
>   for hotplug handling to be freed as well.
>
>   Moreover, if the event is handled regardless, it may cause one
>   or more devices already removed by pci_stop_and_remove_bus_device()
>   to be added again by the code handling the event, which will
>   conflict with the bridge removal.

We definitely need to serialize hotplug events from ACPI and sysfs
(and other sources, like other hotplug drivers).  Would that be
enough?  Adding the is_going_away flag is ACPI-specific and seems like
sort of a point workaround.

> Scenario 3: pci_stop_and_remove_bus_device() is run from
>   trim_stale_devices() (as a result of an ACPI hotplug event) in
>   parallel with dev_bus_rescan_store() or bus_rescan_store(),
>   or dev_rescan_store().
>
>   In that scenario the second code path may attempt to operate
>   on device objects being removed by the first code path which
>   may lead to many interesting types of breakage.
>
> Scenario 4: acpi_pci_root_remove() run (as a result of an ACPI PCI
>   host bridge removal event) in  parallel with bus_rescan_store(),
>   dev_bus_rescan_store(), dev_rescan_store(), or remove_callback()
>   for any devices under the host bridge in question.
>
>   In that case the same symptoms as in Scenarios 1 and 3 may occur
>   depending on which code path wins the races involved.

Scenarios 3 and 4 sound like more cases of hotplug operations needing
to be serialized, right?  If we serialized them sufficiently, would
there still be a problem?  Using pci_remove_rescan_mutex would
serialize *all* PCI hotplug operations, which is more than strictly
necessary, but maybe there's no reason to do anything finer-grained.

> Scenario 5: pci_stop_and_remove_bus_device() is run concurrently
>   for a device and its parent bridge via remove_callback().
>
>   In that case both code paths attempt to acquire
>   pci_remove_rescan_mutex.  If the child device removal acquires
>   it first, there will be no problems.  However, if the parent
>   bridge removal acquires it first, it will eventually execute
>   pci_destroy_dev() for the child device, but that device will
>   not be freed yet due to the reference held by the concurrent
>   child removal.  Consequently, both pci_stop_bus_device() and
>   pci_remove_bus_device() will be executed for that device
>   unnecessarily and pci_destroy_dev() will see a corrupted list
>   head in that object.  Moreover, an excess put_device() will
>   be executed for that device in that case which may lead to a
>   use-after-free in the final kobject_put() done by
>   sysfs_schedule_callback_work().

The corrupted list head should be fixed by Yinghai's patch [1].

Where is the extra put_device()?  I see the
kobject_get()/kobject_put() pair in sysfs_schedule_callback() and
sysfs_schedule_callback_work().  Oh, I see -- the remove_store() ->
remove_callback() path acquires no references, but it calls
pci_stop_and_remove_bus_device(), which ultimately does the
put_device() in pci_destroy_dev().

So if both the parent and the child removal manage to get to
remove_callback() and the parent acquires pci_remove_rescan_mutex
first, the child removal will do the extra put_device().

There are only six callers of device_schedule_callback(), and I think
five of them are susceptible to this same problem: they are sysfs
store methods, and they use device_schedule_callback() with a callback
that does a put_device() on the device:

  drivers/pci/pci-sysfs.c: remove_store()
  drivers/scsi/scsi_sysfs.c: sdev_store_delete()
  arch/s390/pci/pci_sysfs.c: store_recover()
  drivers/s390/block/dcssblk.c: dcssblk_shared_store()
  drivers/s390/cio/ccwgroup.c: ccwgroup_ungroup_store()

I don't know what the right fix is, but adding "is_gone" to struct
pci_dev only addresses one of the five places, of course.

Bjorn

> Scenario 6: ACPIPHP slot enabling/disabling triggered by the
>   slot's "power" attribute in parallel with device removal run
>   from remove_callback().
>
>   This scenario may lead to race conditions analogous to the
>   ones described in Scenario 1.  It also may lead to situations
>   in which an already removed device under a bridge scheduled
>   for removal will be added which is analogous to Scenario 2.
>
> All of these scenarios are addressed by the patch below as follows.
>
> (1) To prevent the races in Scenarios 1 and 3 from happening hold
>     pci_remove_rescan_mutex around hotplug_event() in
>     hotplug_event_work(() (acpiphp_glue.c).
>
> (2) To prevent the races in Scenario 2 from happening, add an ACPIPHP
>     bridge flag is_going_away indicating that hotplug events should
>     be ignored for children below that bridge.  That flag is set
>     by cleanup_bridge() that for non-root bridges should be run
>     under pci_remove_rescan_mutex (for root bridges it is only
>     run under acpi_scan_lock anyway).
>
> (3) To prevent the races in Scenario 4 from happening, hold
>     pci_remove_rescan_mutex around pci_stop_root_bus() and
>     pci_remove_root_bus() in acpi_pci_root_remove().
>
> (4) To prevent the races in Scenario 5 from happening, add an new
>     is_gone flag to struct pci_dev that will be set by pci_destroy_dev()
>     and checked by pci_stop_and_remove_bus_device().  That only
>     covers cases in which pci_stop_and_remove_bus_device() is
>     run under pci_remove_rescan_mutex, but the other existing
>     cases need to be fixed to use that mutex anyway for other
>     reasons (analogous to Scenarios 1 and 3 above, for example).
>
> (5) To prevent the races in Scenario 6 from happening, add
>     the PCI remove/rescan locking to acpiphp_enable_slot() and
>     acpiphp_disable_and_eject_slot() and make these functions
>     check the slot's parent bridge status.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/pci_root.c            |    4 ++
>  drivers/pci/hotplug/acpiphp.h      |    1
>  drivers/pci/hotplug/acpiphp_glue.c |   74 ++++++++++++++++++++++++++++++-------
>  drivers/pci/pci-sysfs.c            |   11 +++++
>  drivers/pci/remove.c               |    7 ++-
>  include/linux/pci.h                |    3 +
>  6 files changed, 84 insertions(+), 16 deletions(-)
>
> Index: linux-pm/include/linux/pci.h
> ===================================================================
> --- linux-pm.orig/include/linux/pci.h
> +++ linux-pm/include/linux/pci.h
> @@ -321,6 +321,7 @@ struct pci_dev {
>         unsigned int    multifunction:1;/* Part of multi-function device */
>         /* keep track of device state */
>         unsigned int    is_added:1;
> +       unsigned int    is_gone:1;
>         unsigned int    is_busmaster:1; /* device is busmaster */
>         unsigned int    no_msi:1;       /* device may not use msi */
>         unsigned int    block_cfg_access:1;     /* config space access is blocked */
> @@ -1022,6 +1023,8 @@ void set_pcie_hotplug_bridge(struct pci_
>  int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap);
>  unsigned int pci_rescan_bus_bridge_resize(struct pci_dev *bridge);
>  unsigned int pci_rescan_bus(struct pci_bus *bus);
> +void lock_pci_remove_rescan(void);
> +void unlock_pci_remove_rescan(void);
>
>  /* Vital product data routines */
>  ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
> Index: linux-pm/drivers/pci/pci-sysfs.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pci-sysfs.c
> +++ linux-pm/drivers/pci/pci-sysfs.c
> @@ -298,6 +298,17 @@ msi_bus_store(struct device *dev, struct
>  static DEVICE_ATTR_RW(msi_bus);
>
>  static DEFINE_MUTEX(pci_remove_rescan_mutex);
> +
> +void lock_pci_remove_rescan(void)
> +{
> +       mutex_lock(&pci_remove_rescan_mutex);
> +}
> +
> +void unlock_pci_remove_rescan(void)
> +{
> +       mutex_unlock(&pci_remove_rescan_mutex);
> +}
> +
>  static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
>                                 size_t count)
>  {
> Index: linux-pm/drivers/pci/remove.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/remove.c
> +++ linux-pm/drivers/pci/remove.c
> @@ -34,6 +34,7 @@ static void pci_stop_dev(struct pci_dev
>
>  static void pci_destroy_dev(struct pci_dev *dev)
>  {
> +       dev->is_gone = 1;
>         device_del(&dev->dev);
>
>         down_write(&pci_bus_sem);
> @@ -109,8 +110,10 @@ static void pci_remove_bus_device(struct
>   */
>  void pci_stop_and_remove_bus_device(struct pci_dev *dev)
>  {
> -       pci_stop_bus_device(dev);
> -       pci_remove_bus_device(dev);
> +       if (!dev->is_gone) {
> +               pci_stop_bus_device(dev);
> +               pci_remove_bus_device(dev);
> +       }
>  }
>  EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
>
> Index: linux-pm/drivers/pci/hotplug/acpiphp.h
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
> +++ linux-pm/drivers/pci/hotplug/acpiphp.h
> @@ -71,6 +71,7 @@ struct acpiphp_bridge {
>         struct acpiphp_context *context;
>
>         int nr_slots;
> +       bool is_going_away;
>
>         /* This bus (host bridge) or Secondary bus (PCI-to-PCI bridge) */
>         struct pci_bus *pci_bus;
> Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> @@ -439,6 +439,13 @@ static void cleanup_bridge(struct acpiph
>         mutex_lock(&bridge_mutex);
>         list_del(&bridge->list);
>         mutex_unlock(&bridge_mutex);
> +
> +       /*
> +        * For non-root bridges this flag is protected by the PCI remove/rescan
> +        * locking.  For root bridges it is only operated under acpi_scan_lock
> +        * anyway.
> +        */
> +       bridge->is_going_away = true;
>  }
>
>  /**
> @@ -733,11 +740,17 @@ static void trim_stale_devices(struct pc
>   *
>   * Iterate over all slots under this bridge and make sure that if a
>   * card is present they are enabled, and if not they are disabled.
> + *
> + * For non-root bridges call under the PCI remove/rescan mutex.
>   */
>  static void acpiphp_check_bridge(struct acpiphp_bridge *bridge)
>  {
>         struct acpiphp_slot *slot;
>
> +       /* Bail out if the bridge is going away. */
> +       if (bridge->is_going_away)
> +               return;
> +
>         list_for_each_entry(slot, &bridge->slots, node) {
>                 struct pci_bus *bus = slot->bus;
>                 struct pci_dev *dev, *tmp;
> @@ -807,6 +820,8 @@ void acpiphp_check_host_bridge(acpi_hand
>         }
>  }
>
> +static int disable_and_eject_slot(struct acpiphp_slot *slot);
> +
>  static void hotplug_event(acpi_handle handle, u32 type, void *data)
>  {
>         struct acpiphp_context *context = data;
> @@ -866,7 +881,7 @@ static void hotplug_event(acpi_handle ha
>         case ACPI_NOTIFY_EJECT_REQUEST:
>                 /* request device eject */
>                 pr_debug("%s: Device eject notify on %s\n", __func__, objname);
> -               acpiphp_disable_and_eject_slot(func->slot);
> +               disable_and_eject_slot(func->slot);
>                 break;
>         }
>
> @@ -878,14 +893,19 @@ static void hotplug_event_work(void *dat
>  {
>         struct acpiphp_context *context = data;
>         acpi_handle handle = context->handle;
> +       struct acpiphp_bridge *bridge = context->func.parent;
>
>         acpi_scan_lock_acquire();
> +       lock_pci_remove_rescan();
>
> -       hotplug_event(handle, type, context);
> +       /* Bail out if the parent bridge is going away. */
> +       if (!bridge->is_going_away)
> +               hotplug_event(handle, type, context);
>
> +       unlock_pci_remove_rescan();
>         acpi_scan_lock_release();
>         acpi_evaluate_hotplug_ost(handle, type, ACPI_OST_SC_SUCCESS, NULL);
> -       put_bridge(context->func.parent);
> +       put_bridge(bridge);
>  }
>
>  /**
> @@ -1050,20 +1070,27 @@ void acpiphp_remove_slots(struct pci_bus
>   */
>  int acpiphp_enable_slot(struct acpiphp_slot *slot)
>  {
> -       mutex_lock(&slot->crit_sect);
> -       /* configure all functions */
> -       if (!(slot->flags & SLOT_ENABLED))
> -               enable_slot(slot);
> +       struct acpiphp_func *func;
> +       int ret = -ENODEV;
>
> -       mutex_unlock(&slot->crit_sect);
> -       return 0;
> +       lock_pci_remove_rescan();
> +
> +       func = list_first_entry(&slot->funcs, struct acpiphp_func, sibling);
> +       if (!func->parent->is_going_away) {
> +               mutex_lock(&slot->crit_sect);
> +               /* configure all functions */
> +               if (!(slot->flags & SLOT_ENABLED))
> +                       enable_slot(slot);
> +
> +               mutex_unlock(&slot->crit_sect);
> +               ret = 0;
> +       }
> +
> +       unlock_pci_remove_rescan();
> +       return ret;
>  }
>
> -/**
> - * acpiphp_disable_and_eject_slot - power off and eject slot
> - * @slot: ACPI PHP slot
> - */
> -int acpiphp_disable_and_eject_slot(struct acpiphp_slot *slot)
> +static int disable_and_eject_slot(struct acpiphp_slot *slot)
>  {
>         struct acpiphp_func *func;
>         int retval = 0;
> @@ -1087,6 +1114,25 @@ int acpiphp_disable_and_eject_slot(struc
>         return retval;
>  }
>
> +/**
> + * acpiphp_disable_and_eject_slot - power off and eject slot.
> + * @slot: ACPIPHP slot.
> + */
> +int acpiphp_disable_and_eject_slot(struct acpiphp_slot *slot)
> +{
> +       struct acpiphp_func *func;
> +       int ret = -ENODEV;
> +
> +       lock_pci_remove_rescan();
> +
> +       func = list_first_entry(&slot->funcs, struct acpiphp_func, sibling);
> +       if (!func->parent->is_going_away)
> +               ret = disable_and_eject_slot(slot);
> +
> +       unlock_pci_remove_rescan();
> +       return ret;
> +}
> +
>
>  /*
>   * slot enabled:  1
> Index: linux-pm/drivers/acpi/pci_root.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/pci_root.c
> +++ linux-pm/drivers/acpi/pci_root.c
> @@ -616,6 +616,8 @@ static void acpi_pci_root_remove(struct
>  {
>         struct acpi_pci_root *root = acpi_driver_data(device);
>
> +       lock_pci_remove_rescan();
> +
>         pci_stop_root_bus(root->bus);
>
>         device_set_run_wake(root->bus->bridge, false);
> @@ -623,6 +625,8 @@ static void acpi_pci_root_remove(struct
>
>         pci_remove_root_bus(root->bus);
>
> +       unlock_pci_remove_rescan();
> +
>         kfree(root);
>  }
>
>
