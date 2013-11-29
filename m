Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3K2XZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 18:25:39 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52612 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753101Ab3K2XZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 18:25:34 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
Date: Sat, 30 Nov 2013 00:38:26 +0100
Message-ID: <461934992.nFRx8soJrp@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAE9FiQXevSPmPEvxzXjC-CFhpYHic0v+vN5+JV3j5kmX-wv_GQ@mail.gmail.com>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <1559825.A4S6KeB0yX@vostro.rjw.lan> <CAE9FiQXevSPmPEvxzXjC-CFhpYHic0v+vN5+JV3j5kmX-wv_GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 26, 2013 06:26:54 PM Yinghai Lu wrote:
> On Tue, Nov 26, 2013 at 5:24 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >
> > So assume pci_destroy_dev() is called twice in parallel for the same dev
> > by two different threads.  Thread 1 does the atomic_inc_and_test() and
> > finds that it is OK to do the device_del() and put_device() which causes
> > the device object to be freed.  Then thread 2 does the atomic_inc_and_test()
> > on the already freed device object and crashes the kernel.
> >
> thread2 should still hold one extra reference.
> that is in
>   device_schedule_callback
>      ==> sysfs_schedule_callback
>          ==> kobject_get(kobj)
> 
> pci_destroy_dev for thread2 is called at this point.
> 
> and that reference will be released from
>         sysfs_schedule_callback
>         ==> kobject_put()...

Well, that would be the case if thread 2 was started by device_schedule_callback(),
but again, for example, it may be trim_stale_devices() started by acpiphp_check_bridge()
that doesn't hold extra references to the pci_dev.  [Well, that piece of code
is racy anyway, because it walks bus->devices without locking.  Which is my
fault too, because I overlooked that.  Shame, shame.]

Perhaps we can do something like the (untested) patch below (in addition to the
$subject patch).  Do you see any immediate problems with it?

Also I wonder if it is safe to do pci_stop_and_remove_device() in acpiphp_glue.c
without putting it under pci_remove_rescan_mutex?

Rafael


---
 drivers/pci/hotplug/acpiphp_glue.c |   47 +++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 14 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -687,10 +687,11 @@ static unsigned int get_slot_status(stru
 }
 
 /**
- * trim_stale_devices - remove PCI devices that are not responding.
+ * find_stale_devices - Select PCI devices that are not responding for removal.
  * @dev: PCI device to start walking the hierarchy from.
+ * @trim_list: List of devices to remove.
  */
-static void trim_stale_devices(struct pci_dev *dev)
+static void find_stale_devices(struct pci_dev *dev, struct list_head *trim_list)
 {
 	acpi_handle handle = ACPI_HANDLE(&dev->dev);
 	struct pci_bus *bus = dev->subordinate;
@@ -710,21 +711,46 @@ static void trim_stale_devices(struct pc
 		alive = pci_bus_read_dev_vendor_id(dev->bus, dev->devfn, &v, 0);
 	}
 	if (!alive) {
-		pci_stop_and_remove_bus_device(dev);
-		if (handle)
-			acpiphp_bus_trim(handle);
+		pci_dev_get(dev);
+		list_move(&dev->bus_list, trim_list);
 	} else if (bus) {
 		struct pci_dev *child, *tmp;
 
 		/* The device is a bridge. so check the bus below it. */
 		pm_runtime_get_sync(&dev->dev);
 		list_for_each_entry_safe(child, tmp, &bus->devices, bus_list)
-			trim_stale_devices(child);
+			find_stale_devices(child, trim_list);
 
 		pm_runtime_put(&dev->dev);
 	}
 }
 
+void acpiphp_trim_stale_devices(struct acpiphp_slot *slot)
+{
+	struct pci_bus *bus = slot->bus;
+	struct pci_dev *dev, *tmp;
+	LIST_HEAD(trim_list);
+
+	down_write(&pci_bus_sem);
+
+	list_for_each_entry_safe(dev, tmp, &bus->devices, bus_list)
+		if (PCI_SLOT(dev->devfn) == slot->device)
+			find_stale_devices(dev, &trim_list);
+
+	up_write(&pci_bus_sem);
+
+	while (!list_empty(&trim_list)) {
+		acpi_handle handle;
+
+		dev = list_first_entry(&trim_list, struct pci_dev, bus_list);
+		handle = ACPI_HANDLE(&dev->dev);
+		pci_stop_and_remove_bus_device(dev);
+		pci_dev_put(dev);
+		if (handle)
+			acpiphp_bus_trim(handle);
+	}
+}
+
 /**
  * acpiphp_check_bridge - re-enumerate devices
  * @bridge: where to begin re-enumeration
@@ -737,18 +763,11 @@ static void acpiphp_check_bridge(struct
 	struct acpiphp_slot *slot;
 
 	list_for_each_entry(slot, &bridge->slots, node) {
-		struct pci_bus *bus = slot->bus;
-		struct pci_dev *dev, *tmp;
-
 		mutex_lock(&slot->crit_sect);
 		/* wake up all functions */
 		if (get_slot_status(slot) == ACPI_STA_ALL) {
 			/* remove stale devices if any */
-			list_for_each_entry_safe(dev, tmp, &bus->devices,
-						 bus_list)
-				if (PCI_SLOT(dev->devfn) == slot->device)
-					trim_stale_devices(dev);
-
+			acpiphp_trim_stale_devices(slot);
 			/* configure all functions */
 			enable_slot(slot);
 		} else {

