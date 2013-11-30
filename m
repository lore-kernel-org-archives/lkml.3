Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab3K3ASw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 19:18:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56752 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751191Ab3K3ASl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 19:18:41 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once
Date: Sat, 30 Nov 2013 01:31:33 +0100
Message-ID: <2994709.aBAqQ6JkJi@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <4276127.HzbOlVUbc2@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <461934992.nFRx8soJrp@vostro.rjw.lan> <4276127.HzbOlVUbc2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 30, 2013 12:45:55 AM Rafael J. Wysocki wrote:
> On Saturday, November 30, 2013 12:38:26 AM Rafael J. Wysocki wrote:
> > On Tuesday, November 26, 2013 06:26:54 PM Yinghai Lu wrote:
> > > On Tue, Nov 26, 2013 at 5:24 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > > >
> > > > So assume pci_destroy_dev() is called twice in parallel for the same dev
> > > > by two different threads.  Thread 1 does the atomic_inc_and_test() and
> > > > finds that it is OK to do the device_del() and put_device() which causes
> > > > the device object to be freed.  Then thread 2 does the atomic_inc_and_test()
> > > > on the already freed device object and crashes the kernel.
> > > >
> > > thread2 should still hold one extra reference.
> > > that is in
> > >   device_schedule_callback
> > >      ==> sysfs_schedule_callback
> > >          ==> kobject_get(kobj)
> > > 
> > > pci_destroy_dev for thread2 is called at this point.
> > > 
> > > and that reference will be released from
> > >         sysfs_schedule_callback
> > >         ==> kobject_put()...
> > 
> > Well, that would be the case if thread 2 was started by device_schedule_callback(),
> > but again, for example, it may be trim_stale_devices() started by acpiphp_check_bridge()
> > that doesn't hold extra references to the pci_dev.  [Well, that piece of code
> > is racy anyway, because it walks bus->devices without locking.  Which is my
> > fault too, because I overlooked that.  Shame, shame.]
> > 
> > Perhaps we can do something like the (untested) patch below (in addition to the
> > $subject patch).  Do you see any immediate problems with it?
> 
> Ah, I see one.  It will break pci_stop_bus_device() and pci_remove_bus_device().
> So much for being clever.
> 
> Moreover, it looks like those two routines above are racy too for the same
> reason?

The (still untested) patch below is what I have come up with for now.  The
is_gone flag is now only operated under pci_remove_rescan_mutex, so it need
not be atomic.  Of course, whoever calls pci_stop_and_remove_bus_device()
(the "locked" one) should hold a ref to the device being removed to avoid
use-after-free (the callers need to be audited for that).

Well, I probably still missed something, because it's the middle of the night
and I should be going to sleep instead of starig at the PCI removal code.  Sigh.

Thanks,
Rafael


---
 drivers/pci/hotplug/acpiphp_glue.c |   15 ++++++++++++---
 drivers/pci/pci-sysfs.c            |   17 ++++++++++++-----
 drivers/pci/pci.h                  |    3 +++
 drivers/pci/remove.c               |   15 +++++++++++++--
 include/linux/pci.h                |    1 +
 5 files changed, 41 insertions(+), 10 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -553,6 +553,8 @@ static void __ref enable_slot(struct acp
 	int max, pass;
 	LIST_HEAD(add_list);
 
+	lock_pci_remove_rescan();
+
 	acpiphp_rescan_slot(slot);
 	max = acpiphp_max_busnr(bus);
 	for (pass = 0; pass < 2; pass++) {
@@ -586,6 +588,8 @@ static void __ref enable_slot(struct acp
 
 	pci_bus_add_devices(bus);
 
+	unlock_pci_remove_rescan();
+
 	slot->flags |= SLOT_ENABLED;
 	list_for_each_entry(func, &slot->funcs, sibling) {
 		dev = pci_get_slot(bus, PCI_DEVFN(slot->device,
@@ -626,6 +630,7 @@ static void disable_slot(struct acpiphp_
 	struct acpiphp_func *func;
 	struct pci_dev *pdev;
 
+	lock_pci_remove_rescan();
 	/*
 	 * enable_slot() enumerates all functions in this device via
 	 * pci_scan_slot(), whether they have associated ACPI hotplug
@@ -633,9 +638,10 @@ static void disable_slot(struct acpiphp_
 	 * here.
 	 */
 	while ((pdev = dev_in_slot(slot))) {
-		pci_stop_and_remove_bus_device(pdev);
+		__pci_stop_and_remove_bus_device(pdev);
 		pci_dev_put(pdev);
 	}
+	unlock_pci_remove_rescan();
 
 	list_for_each_entry(func, &slot->funcs, sibling)
 		acpiphp_bus_trim(func_to_handle(func));
@@ -710,7 +716,7 @@ static void trim_stale_devices(struct pc
 		alive = pci_bus_read_dev_vendor_id(dev->bus, dev->devfn, &v, 0);
 	}
 	if (!alive) {
-		pci_stop_and_remove_bus_device(dev);
+		__pci_stop_and_remove_bus_device(dev);
 		if (handle)
 			acpiphp_bus_trim(handle);
 	} else if (bus) {
@@ -743,12 +749,15 @@ static void acpiphp_check_bridge(struct
 		mutex_lock(&slot->crit_sect);
 		/* wake up all functions */
 		if (get_slot_status(slot) == ACPI_STA_ALL) {
+			lock_pci_remove_rescan();
+
 			/* remove stale devices if any */
 			list_for_each_entry_safe(dev, tmp, &bus->devices,
 						 bus_list)
 				if (PCI_SLOT(dev->devfn) == slot->device)
 					trim_stale_devices(dev);
 
+			unlock_pci_remove_rescan();
 			/* configure all functions */
 			enable_slot(slot);
 		} else {
@@ -783,7 +792,7 @@ static void acpiphp_sanitize_bus(struct
 					res->end) {
 				/* Could not assign a required resources
 				 * for this device, remove it */
-				pci_stop_and_remove_bus_device(dev);
+				__pci_stop_and_remove_bus_device(dev);
 				break;
 			}
 		}
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
@@ -354,11 +365,7 @@ static struct device_attribute dev_resca
 
 static void remove_callback(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-
-	mutex_lock(&pci_remove_rescan_mutex);
-	pci_stop_and_remove_bus_device(pdev);
-	mutex_unlock(&pci_remove_rescan_mutex);
+	pci_stop_and_remove_bus_device(to_pci_dev(dev));
 }
 
 static ssize_t
Index: linux-pm/drivers/pci/pci.h
===================================================================
--- linux-pm.orig/drivers/pci/pci.h
+++ linux-pm/drivers/pci/pci.h
@@ -11,8 +11,11 @@ extern const unsigned char pcie_link_spe
 
 /* Functions internal to the PCI core code */
 
+void lock_pci_remove_rescan(void);
+void unlock_pci_remove_rescan(void);
 int pci_create_sysfs_dev_files(struct pci_dev *pdev);
 void pci_remove_sysfs_dev_files(struct pci_dev *pdev);
+void __pci_stop_and_remove_bus_device(struct pci_dev *pdev);
 #if !defined(CONFIG_DMI) && !defined(CONFIG_ACPI)
 static inline void pci_create_firmware_label_files(struct pci_dev *pdev)
 { return; }
Index: linux-pm/drivers/pci/remove.c
===================================================================
--- linux-pm.orig/drivers/pci/remove.c
+++ linux-pm/drivers/pci/remove.c
@@ -34,6 +34,10 @@ static void pci_stop_dev(struct pci_dev
 
 static void pci_destroy_dev(struct pci_dev *dev)
 {
+	if (dev->is_gone)
+		return;
+
+	dev->is_gone = 1;
 	device_del(&dev->dev);
 
 	down_write(&pci_bus_sem);
@@ -95,6 +99,12 @@ static void pci_remove_bus_device(struct
 	pci_destroy_dev(dev);
 }
 
+void __pci_stop_and_remove_bus_device(struct pci_dev *dev)
+{
+	pci_stop_bus_device(dev);
+	pci_remove_bus_device(dev);
+}
+
 /**
  * pci_stop_and_remove_bus_device - remove a PCI device and any children
  * @dev: the device to remove
@@ -109,8 +119,9 @@ static void pci_remove_bus_device(struct
  */
 void pci_stop_and_remove_bus_device(struct pci_dev *dev)
 {
-	pci_stop_bus_device(dev);
-	pci_remove_bus_device(dev);
+	lock_pci_remove_rescan();
+	__pci_stop_and_remove_bus_device(dev);
+	unlock_pci_remove_rescan();
 }
 EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
 
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

