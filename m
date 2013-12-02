Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab3LBOgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:36:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53659 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751761Ab3LBOgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:36:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Myron Stowe <myron.stowe@gmail.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
Date: Mon, 02 Dec 2013 15:49:40 +0100
Message-ID: <33026900.FbCAopDPFz@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5750980.G76cQES87j@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <3611889.9a0SszCTpv@vostro.rjw.lan> <5750980.G76cQES87j@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 02, 2013 02:29:46 AM Rafael J. Wysocki wrote:
> On Sunday, December 01, 2013 02:24:33 AM Rafael J. Wysocki wrote:
> > On Saturday, November 30, 2013 02:27:15 PM Yinghai Lu wrote:
> > > On Sat, Nov 30, 2013 at 1:37 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > > > On Saturday, November 30, 2013 01:31:33 AM Rafael J. Wysocki wrote:
> > > >> On Saturday, November 30, 2013 12:45:55 AM Rafael J. Wysocki wrote:
> > > >> > On Saturday, November 30, 2013 12:38:26 AM Rafael J. Wysocki wrote:
> > > >> > > On Tuesday, November 26, 2013 06:26:54 PM Yinghai Lu wrote:
> > > >> > > > On Tue, Nov 26, 2013 at 5:24 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > > >> > > > >
> > > >> > > > > So assume pci_destroy_dev() is called twice in parallel for the same dev
> > > >> > > > > by two different threads.  Thread 1 does the atomic_inc_and_test() and
> > > >> > > > > finds that it is OK to do the device_del() and put_device() which causes
> > > >> > > > > the device object to be freed.  Then thread 2 does the atomic_inc_and_test()
> > > >> > > > > on the already freed device object and crashes the kernel.
> > > >> > > > >
> > > >> > > > thread2 should still hold one extra reference.
> > > >> > > > that is in
> > > >> > > >   device_schedule_callback
> > > >> > > >      ==> sysfs_schedule_callback
> > > >> > > >          ==> kobject_get(kobj)
> > > >> > > >
> > > >> > > > pci_destroy_dev for thread2 is called at this point.
> > > >> > > >
> > > >> > > > and that reference will be released from
> > > >> > > >         sysfs_schedule_callback
> > > >> > > >         ==> kobject_put()...
> > > >> > >
> > > >> > > Well, that would be the case if thread 2 was started by device_schedule_callback(),
> > > >> > > but again, for example, it may be trim_stale_devices() started by acpiphp_check_bridge()
> > > >> > > that doesn't hold extra references to the pci_dev.  [Well, that piece of code
> > > >> > > is racy anyway, because it walks bus->devices without locking.  Which is my
> > > >> > > fault too, because I overlooked that.  Shame, shame.]
> > > >> > >
> > > 
> > > can you add extra reference to that path?
> > 
> > hotplug_event_work()
> > 	hotplug_event()
> > 		acpiphp_check_bridge()
> > 			trim_stale_devices()
> > 				pci_stop_and_remove_bus_device()
> > 
> > Yes, it should hold a reference to dev, but adding it there doesn't really help,
> > because there are list walks over &bus->devices in acpiphp_check_bridge() and
> > trim_stale_devices() that are racy with respect to pci_stop_and_remove_bus_device()
> > run from device_schedule_callback().
> > 
> > > >> > > Perhaps we can do something like the (untested) patch below (in addition to the
> > > >> > > $subject patch).  Do you see any immediate problems with it?
> > > >> >
> > > >> > Ah, I see one.  It will break pci_stop_bus_device() and pci_remove_bus_device().
> > > >> > So much for being clever.
> > > >> >
> > > >> > Moreover, it looks like those two routines above are racy too for the same
> > > >> > reason?
> > > >>
> > > >> The (still untested) patch below is what I have come up with for now.  The
> > > >> is_gone flag is now only operated under pci_remove_rescan_mutex, so it need
> > > >> not be atomic.  Of course, whoever calls pci_stop_and_remove_bus_device()
> > > >> (the "locked" one) should hold a ref to the device being removed to avoid
> > > >> use-after-free (the callers need to be audited for that).
> > > 
> > > if you can use device_schedule_...,
> > 
> > No, I can't.  I need to hold acpi_scan_lock taken in hotplug_event_work()
> > throughout all bus trimming/scanning and I need to protect list walks over
> > &bus->devices too.
> > 
> > > should have hold reference may be
> > > atomic would be better than lock/unlock everywhere?
> > 
> > The locking is necessary not only for the device removal itself, but also for
> > the safety of the &bus->devices list walks.
> > 
> > Besides, remove_callback() in remove.c already holds pci_remove_rescan_mutex
> > around pci_stop_and_remove_bus_device() and I don't see how it would be safe
> > to run pci_stop_and_remove_bus_device() without holding that mutex from
> > anywhere else.
> > 
> > For one example, pci_stop_and_remove_bus_device() that is not run under
> > pci_remove_rescan_mutex can race with the stuff called under that mutex
> > in dev_bus_rescan_store() (and elsewhere in pci-sysfs.c).
> > 
> > So either pci_remove_rescan_mutex is useless and should be dropped, or
> > it is there for a purpose, in which case it needs to be used around
> > pci_stop_and_remove_bus_device() everywhere.  There's no other possibility
> > and to my eyes that mutex is necessary.
> 
> So below is a new version of the patch (which has been tested on my Thunderbolt
> rig without visibly breaking anything) with the description of all the problems
> it attempts to address.  If any of the scenarios described in the changelog are
> not possible for some reason, please tell me why that is the case.  I couldn't
> find such reasons myself.

And I forgot about the ACPIPHP slot "power" attribute that also may trigger
race conditions with device removal.  Updated patch follows.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: PCI / hotplug / ACPI: Fix concurrency problems related to device removal

The following are concurrency problems related to the PCI device
removal code in pci-sysfs.c and in ACPIPHP present in the current
mainline kernel:

Scenario 1: pci_stop_and_remove_bus_device() run concurrently for
  the same top device from remove_callback() in pci-sysfs.c and
  from trim_stale_devices() in acpiphp_glue.c.

  In this scenario the second code path is executed without
  pci_remove_rescan_mutex locked, so the &bus->devices list
  walks in either trim_stale_devices() itself or in
  acpiphp_check_bridge() can suffer from list corruption while the
  first code path is executing pci_destroy_dev() for one of the
  devices on those lists.

  Moreover, if any of the device objects in question is freed
  after pci_destroy_dev() executed by the first code path, the
  second code path may suffer a use-after-free problem while
  trying to access that device object.

  Conversely, the second code path may execute pci_destroy_dev()
  for one of the devices in question such that one of the
  &bus->devices list walks in pci_stop_bus_device()
  or pci_remove_bus_device() executed by the first code path will
  suffer from a list corruption.

  Moreover, use-after-free is also possible if one of the device
  objects in question is freed as a result of calling
  pci_destroy_dev() by the second code path and then the first
  code path tries to access it (the first code path only holds
  an extra reference to the device it has been run for, but not
  for its child devices).

Scenario 2: ACPI hotplug event occurs for a device under a bridge
  being removed by pci_stop_and_remove_bus_device() run from
  remove_callback() in pci-sysfs.c.

  In that case it doesn't make sense to handle the hotplug event,
  because the device in question will be removed anyway along with
  its parent bridge and that will cause the context objects needed
  for hotplug handling to be freed as well.

  Moreover, if the event is handled regardless, it may cause one
  or more devices already removed by pci_stop_and_remove_bus_device()
  to be added again by the code handling the event, which will
  conflict with the bridge removal.

Scenario 3: pci_stop_and_remove_bus_device() is run from
  trim_stale_devices() (as a result of an ACPI hotplug event) in
  parallel with dev_bus_rescan_store() or bus_rescan_store(),
  or dev_rescan_store().

  In that scenario the second code path may attempt to operate
  on device objects being removed by the first code path which
  may lead to many interesting types of breakage.

Scenario 4: acpi_pci_root_remove() run (as a result of an ACPI PCI
  host bridge removal event) in  parallel with bus_rescan_store(),
  dev_bus_rescan_store(), dev_rescan_store(), or remove_callback()
  for any devices under the host bridge in question.

  In that case the same symptoms as in Scenarios 1 and 3 may occur
  depending on which code path wins the races involved.

Scenario 5: pci_stop_and_remove_bus_device() is run concurrently
  for a device and its parent bridge via remove_callback().

  In that case both code paths attempt to acquire
  pci_remove_rescan_mutex.  If the child device removal acquires
  it first, there will be no problems.  However, if the parent
  bridge removal acquires it first, it will eventually execute
  pci_destroy_dev() for the child device, but that device will
  not be freed yet due to the reference held by the concurrent
  child removal.  Consequently, both pci_stop_bus_device() and
  pci_remove_bus_device() will be executed for that device
  unnecessarily and pci_destroy_dev() will see a corrupted list
  head in that object.  Moreover, an excess put_device() will
  be executed for that device in that case which may lead to a
  use-after-free in the final kobject_put() done by
  sysfs_schedule_callback_work().

Scenario 6: ACPIPHP slot enabling/disabling triggered by the
  slot's "power" attribute in parallel with device removal run
  from remove_callback().

  This scenario may lead to race conditions analogous to the
  ones described in Scenario 1.  It also may lead to situations
  in which an already removed device under a bridge scheduled
  for removal will be added which is analogous to Scenario 2.

All of these scenarios are addressed by the patch below as follows.

(1) To prevent the races in Scenarios 1 and 3 from happening hold
    pci_remove_rescan_mutex around hotplug_event() in
    hotplug_event_work(() (acpiphp_glue.c).

(2) To prevent the races in Scenario 2 from happening, add an ACPIPHP
    bridge flag is_going_away indicating that hotplug events should
    be ignored for children below that bridge.  That flag is set
    by cleanup_bridge() that for non-root bridges should be run
    under pci_remove_rescan_mutex (for root bridges it is only
    run under acpi_scan_lock anyway).

(3) To prevent the races in Scenario 4 from happening, hold
    pci_remove_rescan_mutex around pci_stop_root_bus() and
    pci_remove_root_bus() in acpi_pci_root_remove().

(4) To prevent the races in Scenario 5 from happening, add an new
    is_gone flag to struct pci_dev that will be set by pci_destroy_dev()
    and checked by pci_stop_and_remove_bus_device().  That only
    covers cases in which pci_stop_and_remove_bus_device() is
    run under pci_remove_rescan_mutex, but the other existing
    cases need to be fixed to use that mutex anyway for other
    reasons (analogous to Scenarios 1 and 3 above, for example).

(5) To prevent the races in Scenario 6 from happening, add
    the PCI remove/rescan locking to acpiphp_enable_slot() and
    acpiphp_disable_and_eject_slot() and make these functions
    check the slot's parent bridge status.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/pci_root.c            |    4 ++
 drivers/pci/hotplug/acpiphp.h      |    1 
 drivers/pci/hotplug/acpiphp_glue.c |   74 ++++++++++++++++++++++++++++++-------
 drivers/pci/pci-sysfs.c            |   11 +++++
 drivers/pci/remove.c               |    7 ++-
 include/linux/pci.h                |    3 +
 6 files changed, 84 insertions(+), 16 deletions(-)

Index: linux-pm/include/linux/pci.h
===================================================================
--- linux-pm.orig/include/linux/pci.h
+++ linux-pm/include/linux/pci.h
@@ -321,6 +321,7 @@ struct pci_dev {
 	unsigned int	multifunction:1;/* Part of multi-function device */
 	/* keep track of device state */
 	unsigned int	is_added:1;
+	unsigned int	is_gone:1;
 	unsigned int	is_busmaster:1; /* device is busmaster */
 	unsigned int	no_msi:1;	/* device may not use msi */
 	unsigned int	block_cfg_access:1;	/* config space access is blocked */
@@ -1022,6 +1023,8 @@ void set_pcie_hotplug_bridge(struct pci_
 int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap);
 unsigned int pci_rescan_bus_bridge_resize(struct pci_dev *bridge);
 unsigned int pci_rescan_bus(struct pci_bus *bus);
+void lock_pci_remove_rescan(void);
+void unlock_pci_remove_rescan(void);
 
 /* Vital product data routines */
 ssize_t pci_read_vpd(struct pci_dev *dev, loff_t pos, size_t count, void *buf);
Index: linux-pm/drivers/pci/pci-sysfs.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-sysfs.c
+++ linux-pm/drivers/pci/pci-sysfs.c
@@ -298,6 +298,17 @@ msi_bus_store(struct device *dev, struct
 static DEVICE_ATTR_RW(msi_bus);
 
 static DEFINE_MUTEX(pci_remove_rescan_mutex);
+
+void lock_pci_remove_rescan(void)
+{
+	mutex_lock(&pci_remove_rescan_mutex);
+}
+
+void unlock_pci_remove_rescan(void)
+{
+	mutex_unlock(&pci_remove_rescan_mutex);
+}
+
 static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 				size_t count)
 {
Index: linux-pm/drivers/pci/remove.c
===================================================================
--- linux-pm.orig/drivers/pci/remove.c
+++ linux-pm/drivers/pci/remove.c
@@ -34,6 +34,7 @@ static void pci_stop_dev(struct pci_dev
 
 static void pci_destroy_dev(struct pci_dev *dev)
 {
+	dev->is_gone = 1;
 	device_del(&dev->dev);
 
 	down_write(&pci_bus_sem);
@@ -109,8 +110,10 @@ static void pci_remove_bus_device(struct
  */
 void pci_stop_and_remove_bus_device(struct pci_dev *dev)
 {
-	pci_stop_bus_device(dev);
-	pci_remove_bus_device(dev);
+	if (!dev->is_gone) {
+		pci_stop_bus_device(dev);
+		pci_remove_bus_device(dev);
+	}
 }
 EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
 
Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -71,6 +71,7 @@ struct acpiphp_bridge {
 	struct acpiphp_context *context;
 
 	int nr_slots;
+	bool is_going_away;
 
 	/* This bus (host bridge) or Secondary bus (PCI-to-PCI bridge) */
 	struct pci_bus *pci_bus;
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -439,6 +439,13 @@ static void cleanup_bridge(struct acpiph
 	mutex_lock(&bridge_mutex);
 	list_del(&bridge->list);
 	mutex_unlock(&bridge_mutex);
+
+	/*
+	 * For non-root bridges this flag is protected by the PCI remove/rescan
+	 * locking.  For root bridges it is only operated under acpi_scan_lock
+	 * anyway.
+	 */
+	bridge->is_going_away = true;
 }
 
 /**
@@ -733,11 +740,17 @@ static void trim_stale_devices(struct pc
  *
  * Iterate over all slots under this bridge and make sure that if a
  * card is present they are enabled, and if not they are disabled.
+ *
+ * For non-root bridges call under the PCI remove/rescan mutex.
  */
 static void acpiphp_check_bridge(struct acpiphp_bridge *bridge)
 {
 	struct acpiphp_slot *slot;
 
+	/* Bail out if the bridge is going away. */
+	if (bridge->is_going_away)
+		return;
+
 	list_for_each_entry(slot, &bridge->slots, node) {
 		struct pci_bus *bus = slot->bus;
 		struct pci_dev *dev, *tmp;
@@ -807,6 +820,8 @@ void acpiphp_check_host_bridge(acpi_hand
 	}
 }
 
+static int disable_and_eject_slot(struct acpiphp_slot *slot);
+
 static void hotplug_event(acpi_handle handle, u32 type, void *data)
 {
 	struct acpiphp_context *context = data;
@@ -866,7 +881,7 @@ static void hotplug_event(acpi_handle ha
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
 		pr_debug("%s: Device eject notify on %s\n", __func__, objname);
-		acpiphp_disable_and_eject_slot(func->slot);
+		disable_and_eject_slot(func->slot);
 		break;
 	}
 
@@ -878,14 +893,19 @@ static void hotplug_event_work(void *dat
 {
 	struct acpiphp_context *context = data;
 	acpi_handle handle = context->handle;
+	struct acpiphp_bridge *bridge = context->func.parent;
 
 	acpi_scan_lock_acquire();
+	lock_pci_remove_rescan();
 
-	hotplug_event(handle, type, context);
+	/* Bail out if the parent bridge is going away. */
+	if (!bridge->is_going_away)
+		hotplug_event(handle, type, context);
 
+	unlock_pci_remove_rescan();
 	acpi_scan_lock_release();
 	acpi_evaluate_hotplug_ost(handle, type, ACPI_OST_SC_SUCCESS, NULL);
-	put_bridge(context->func.parent);
+	put_bridge(bridge);
 }
 
 /**
@@ -1050,20 +1070,27 @@ void acpiphp_remove_slots(struct pci_bus
  */
 int acpiphp_enable_slot(struct acpiphp_slot *slot)
 {
-	mutex_lock(&slot->crit_sect);
-	/* configure all functions */
-	if (!(slot->flags & SLOT_ENABLED))
-		enable_slot(slot);
+	struct acpiphp_func *func;
+	int ret = -ENODEV;
 
-	mutex_unlock(&slot->crit_sect);
-	return 0;
+	lock_pci_remove_rescan();
+
+	func = list_first_entry(&slot->funcs, struct acpiphp_func, sibling);
+	if (!func->parent->is_going_away) {
+		mutex_lock(&slot->crit_sect);
+		/* configure all functions */
+		if (!(slot->flags & SLOT_ENABLED))
+			enable_slot(slot);
+
+		mutex_unlock(&slot->crit_sect);
+		ret = 0;
+	}
+
+	unlock_pci_remove_rescan();
+	return ret;
 }
 
-/**
- * acpiphp_disable_and_eject_slot - power off and eject slot
- * @slot: ACPI PHP slot
- */
-int acpiphp_disable_and_eject_slot(struct acpiphp_slot *slot)
+static int disable_and_eject_slot(struct acpiphp_slot *slot)
 {
 	struct acpiphp_func *func;
 	int retval = 0;
@@ -1087,6 +1114,25 @@ int acpiphp_disable_and_eject_slot(struc
 	return retval;
 }
 
+/**
+ * acpiphp_disable_and_eject_slot - power off and eject slot.
+ * @slot: ACPIPHP slot.
+ */
+int acpiphp_disable_and_eject_slot(struct acpiphp_slot *slot)
+{
+	struct acpiphp_func *func;
+	int ret = -ENODEV;
+
+	lock_pci_remove_rescan();
+
+	func = list_first_entry(&slot->funcs, struct acpiphp_func, sibling);
+	if (!func->parent->is_going_away)
+		ret = disable_and_eject_slot(slot);
+
+	unlock_pci_remove_rescan();
+	return ret;
+}
+
 
 /*
  * slot enabled:  1
Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -616,6 +616,8 @@ static void acpi_pci_root_remove(struct
 {
 	struct acpi_pci_root *root = acpi_driver_data(device);
 
+	lock_pci_remove_rescan();
+
 	pci_stop_root_bus(root->bus);
 
 	device_set_run_wake(root->bus->bridge, false);
@@ -623,6 +625,8 @@ static void acpi_pci_root_remove(struct
 
 	pci_remove_root_bus(root->bus);
 
+	unlock_pci_remove_rescan();
+
 	kfree(root);
 }
 

