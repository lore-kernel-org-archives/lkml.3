Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab3BLTLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 14:11:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31457 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab3BLTLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 14:11:38 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] ACPI, PCI: Get PRT entry during acpi_pci_enable_irq()
Date: Tue, 12 Feb 2013 11:11:23 -0800
Message-Id: <1360696283-20313-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAE9FiQUkmnV_On5+ZpH2pF4Li1HxLpkO8bp4TnYB46=pc9Safg@mail.gmail.com>
References: <CAE9FiQUkmnV_On5+ZpH2pF4Li1HxLpkO8bp4TnYB46=pc9Safg@mail.gmail.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley found "irq 18 nobody cared" with pci-next, and dmesg has

[    8.983246] pci 0000:00:1e.0: can't derive routing for PCI INT A
[    8.983600] snd_ctxfi 0000:09:02.0: PCI INT A: no GSI - using ISA IRQ 5

bisect to
| commit 4f535093cf8f6da8cfda7c36c2c1ecd2e9586ee4
|     PCI: Put pci_dev in device tree as early as possible

It turns out we need to call acpi_pci_irq_add_prt() after the pci bridges
are scanned.

Bjorn said:
 The bus number binding means acpi_pci_irq_add_prt() has to happen
 after enumerating everything below a bridge, and it will prevent us
 from doing any bus number reassignment for hotplug.

 I think we should remove the bus numbers from the cached _PRT (or
 maybe even remove the _PRT caching completely).  When we enable a PCI
 device's IRQ, we should search up the PCI device tree looking for a
 _PRT associated with each node, and applying normal PCI bridge
 swizzling when we don't find a _PRT.  I think this can be done without
 using PCI bus numbers at all.

So here we try to remove _PRT caching completely.

-v2: check !handle early.

Reported-and-tested-by: Peter Hurley <peter@hurleysoftware.com>
Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/acpi/pci_irq.c      |   95 +++++++++++++++++---------------------------
 drivers/acpi/pci_root.c     |   18 --------
 drivers/pci/pci-acpi.c      |   24 -----------
 include/acpi/acpi_drivers.h |    5 --
 4 files changed, 38 insertions(+), 104 deletions(-)

Index: linux-2.6/drivers/acpi/pci_irq.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_irq.c
+++ linux-2.6/drivers/acpi/pci_irq.c
@@ -53,9 +53,6 @@ struct acpi_prt_entry {
 	u32			index;		/* GSI, or link _CRS index */
 };
 
-static LIST_HEAD(acpi_prt_list);
-static DEFINE_SPINLOCK(acpi_prt_lock);
-
 static inline char pin_name(int pin)
 {
 	return 'A' + pin - 1;
@@ -65,28 +62,6 @@ static inline char pin_name(int pin)
                          PCI IRQ Routing Table (PRT) Support
    -------------------------------------------------------------------------- */
 
-static struct acpi_prt_entry *acpi_pci_irq_find_prt_entry(struct pci_dev *dev,
-							  int pin)
-{
-	struct acpi_prt_entry *entry;
-	int segment = pci_domain_nr(dev->bus);
-	int bus = dev->bus->number;
-	int device = PCI_SLOT(dev->devfn);
-
-	spin_lock(&acpi_prt_lock);
-	list_for_each_entry(entry, &acpi_prt_list, list) {
-		if ((segment == entry->id.segment)
-		    && (bus == entry->id.bus)
-		    && (device == entry->id.device)
-		    && (pin == entry->pin)) {
-			spin_unlock(&acpi_prt_lock);
-			return entry;
-		}
-	}
-	spin_unlock(&acpi_prt_lock);
-	return NULL;
-}
-
 /* http://bugzilla.kernel.org/show_bug.cgi?id=4773 */
 static const struct dmi_system_id medion_md9580[] = {
 	{
@@ -184,11 +159,19 @@ static void do_prt_fixups(struct acpi_pr
 	}
 }
 
-static int acpi_pci_irq_add_entry(acpi_handle handle, int segment, int bus,
-				  struct acpi_pci_routing_table *prt)
+static int acpi_pci_irq_check_entry(acpi_handle handle, struct pci_dev *dev,
+				  int pin, struct acpi_pci_routing_table *prt,
+				  struct acpi_prt_entry **entry_ptr)
 {
+	int segment = pci_domain_nr(dev->bus);
+	int bus = dev->bus->number;
+	int device = PCI_SLOT(dev->devfn);
 	struct acpi_prt_entry *entry;
 
+	if (((prt->address >> 16) & 0xffff) != device ||
+	    prt->pin + 1 != pin)
+		return -ENODEV;
+
 	entry = kzalloc(sizeof(struct acpi_prt_entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
@@ -237,26 +220,33 @@ static int acpi_pci_irq_add_entry(acpi_h
 			      entry->id.device, pin_name(entry->pin),
 			      prt->source, entry->index));
 
-	spin_lock(&acpi_prt_lock);
-	list_add_tail(&entry->list, &acpi_prt_list);
-	spin_unlock(&acpi_prt_lock);
+	*entry_ptr = entry;
 
 	return 0;
 }
 
-int acpi_pci_irq_add_prt(acpi_handle handle, int segment, int bus)
+static int acpi_pci_irq_find_prt_entry(struct pci_dev *dev,
+			  int pin, struct acpi_prt_entry **entry_ptr)
 {
 	acpi_status status;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	struct acpi_pci_routing_table *entry;
+	acpi_handle handle = NULL;
+
+	if (dev->bus->bridge)
+		handle = ACPI_HANDLE(dev->bus->bridge);
+
+	if (!handle)
+		return -ENODEV;
 
 	/* 'handle' is the _PRT's parent (root bridge or PCI-PCI bridge) */
 	status = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 
-	printk(KERN_DEBUG "ACPI: PCI Interrupt Routing Table [%s._PRT]\n",
-	       (char *) buffer.pointer);
+	dev_printk(KERN_DEBUG, &dev->dev,
+			"ACPI: PCI Interrupt Routing Table [%s._PRT]\n",
+		       (char *) buffer.pointer);
 
 	kfree(buffer.pointer);
 
@@ -273,7 +263,9 @@ int acpi_pci_irq_add_prt(acpi_handle han
 
 	entry = buffer.pointer;
 	while (entry && (entry->length > 0)) {
-		acpi_pci_irq_add_entry(handle, segment, bus, entry);
+		if (!acpi_pci_irq_check_entry(handle, dev, pin,
+						 entry, entry_ptr))
+			break;
 		entry = (struct acpi_pci_routing_table *)
 		    ((unsigned long)entry + entry->length);
 	}
@@ -282,23 +274,6 @@ int acpi_pci_irq_add_prt(acpi_handle han
 	return 0;
 }
 
-void acpi_pci_irq_del_prt(int segment, int bus)
-{
-	struct acpi_prt_entry *entry, *tmp;
-
-	printk(KERN_DEBUG
-	       "ACPI: Delete PCI Interrupt Routing Table for %04x:%02x\n",
-	       segment, bus);
-	spin_lock(&acpi_prt_lock);
-	list_for_each_entry_safe(entry, tmp, &acpi_prt_list, list) {
-		if (segment == entry->id.segment && bus == entry->id.bus) {
-			list_del(&entry->list);
-			kfree(entry);
-		}
-	}
-	spin_unlock(&acpi_prt_lock);
-}
-
 /* --------------------------------------------------------------------------
                           PCI Interrupt Routing Support
    -------------------------------------------------------------------------- */
@@ -359,12 +334,13 @@ static int acpi_reroute_boot_interrupt(s
 
 static struct acpi_prt_entry *acpi_pci_irq_lookup(struct pci_dev *dev, int pin)
 {
-	struct acpi_prt_entry *entry;
+	struct acpi_prt_entry *entry = NULL;
 	struct pci_dev *bridge;
 	u8 bridge_pin, orig_pin = pin;
+	int ret;
 
-	entry = acpi_pci_irq_find_prt_entry(dev, pin);
-	if (entry) {
+	ret = acpi_pci_irq_find_prt_entry(dev, pin, &entry);
+	if (!ret && entry) {
 #ifdef CONFIG_X86_IO_APIC
 		acpi_reroute_boot_interrupt(dev, entry);
 #endif /* CONFIG_X86_IO_APIC */
@@ -373,7 +349,7 @@ static struct acpi_prt_entry *acpi_pci_i
 		return entry;
 	}
 
-	/* 
+	/*
 	 * Attempt to derive an IRQ for this device from a parent bridge's
 	 * PCI interrupt routing entry (eg. yenta bridge and add-in card bridge).
 	 */
@@ -393,8 +369,8 @@ static struct acpi_prt_entry *acpi_pci_i
 			pin = bridge_pin;
 		}
 
-		entry = acpi_pci_irq_find_prt_entry(bridge, pin);
-		if (entry) {
+		ret = acpi_pci_irq_find_prt_entry(bridge, pin, &entry);
+		if (!ret && entry) {
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 					 "Derived GSI for %s INT %c from %s\n",
 					 pci_name(dev), pin_name(orig_pin),
@@ -470,6 +446,7 @@ int acpi_pci_irq_enable(struct pci_dev *
 			dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
 				 pin_name(pin));
 		}
+
 		return 0;
 	}
 
@@ -477,6 +454,7 @@ int acpi_pci_irq_enable(struct pci_dev *
 	if (rc < 0) {
 		dev_warn(&dev->dev, "PCI INT %c: failed to register GSI\n",
 			 pin_name(pin));
+		kfree(entry);
 		return rc;
 	}
 	dev->irq = rc;
@@ -491,6 +469,7 @@ int acpi_pci_irq_enable(struct pci_dev *
 		(triggering == ACPI_LEVEL_SENSITIVE) ? "level" : "edge",
 		(polarity == ACPI_ACTIVE_LOW) ? "low" : "high", dev->irq);
 
+	kfree(entry);
 	return 0;
 }
 
@@ -513,6 +492,8 @@ void acpi_pci_irq_disable(struct pci_dev
 	else
 		gsi = entry->index;
 
+	kfree(entry);
+
 	/*
 	 * TBD: It might be worth clearing dev->irq by magic constant
 	 * (e.g. PCI_UNDEFINED_IRQ).
Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -413,7 +413,6 @@ static int acpi_pci_root_add(struct acpi
 	acpi_status status;
 	int result;
 	struct acpi_pci_root *root;
-	acpi_handle handle;
 	struct acpi_pci_driver *driver;
 	u32 flags, base_flags;
 	bool is_osc_granted = false;
@@ -468,16 +467,6 @@ static int acpi_pci_root_add(struct acpi
 	       acpi_device_name(device), acpi_device_bid(device),
 	       root->segment, &root->secondary);
 
-	/*
-	 * PCI Routing Table
-	 * -----------------
-	 * Evaluate and parse _PRT, if exists.
-	 */
-	status = acpi_get_handle(device->handle, METHOD_NAME__PRT, &handle);
-	if (ACPI_SUCCESS(status))
-		result = acpi_pci_irq_add_prt(device->handle, root->segment,
-					      root->secondary.start);
-
 	root->mcfg_addr = acpi_pci_root_get_mcfg_addr(device->handle);
 
 	/*
@@ -602,7 +591,6 @@ out_del_root:
 	list_del(&root->node);
 	mutex_unlock(&acpi_pci_root_lock);
 
-	acpi_pci_irq_del_prt(root->segment, root->secondary.start);
 end:
 	kfree(root);
 	return result;
@@ -610,8 +598,6 @@ end:
 
 static void acpi_pci_root_remove(struct acpi_device *device)
 {
-	acpi_status status;
-	acpi_handle handle;
 	struct acpi_pci_root *root = acpi_driver_data(device);
 	struct acpi_pci_driver *driver;
 
@@ -626,10 +612,6 @@ static void acpi_pci_root_remove(struct
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_bus_pm_notifier(device);
 
-	status = acpi_get_handle(device->handle, METHOD_NAME__PRT, &handle);
-	if (ACPI_SUCCESS(status))
-		acpi_pci_irq_del_prt(root->segment, root->secondary.start);
-
 	pci_remove_root_bus(root->bus);
 
 	mutex_lock(&acpi_pci_root_lock);
Index: linux-2.6/drivers/pci/pci-acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-acpi.c
+++ linux-2.6/drivers/pci/pci-acpi.c
@@ -307,25 +307,6 @@ static void pci_acpi_setup(struct device
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	acpi_handle handle = ACPI_HANDLE(dev);
 	struct acpi_device *adev;
-	acpi_status status;
-	acpi_handle dummy;
-
-	/*
-	 * Evaluate and parse _PRT, if exists.  This code allows parsing of
-	 * _PRT objects within the scope of non-bridge devices.  Note that
-	 * _PRTs within the scope of a PCI bridge assume the bridge's
-	 * subordinate bus number.
-	 *
-	 * TBD: Can _PRTs exist within the scope of non-bridge PCI devices?
-	 */
-	status = acpi_get_handle(handle, METHOD_NAME__PRT, &dummy);
-	if (ACPI_SUCCESS(status)) {
-		unsigned char bus;
-
-		bus = pci_dev->subordinate ?
-			pci_dev->subordinate->number : pci_dev->bus->number;
-		acpi_pci_irq_add_prt(handle, pci_domain_nr(pci_dev->bus), bus);
-	}
 
 	if (acpi_bus_get_device(handle, &adev) || !adev->wakeup.flags.valid)
 		return;
@@ -340,7 +321,6 @@ static void pci_acpi_setup(struct device
 
 static void pci_acpi_cleanup(struct device *dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(dev);
 	acpi_handle handle = ACPI_HANDLE(dev);
 	struct acpi_device *adev;
 
@@ -349,10 +329,6 @@ static void pci_acpi_cleanup(struct devi
 		device_set_run_wake(dev, false);
 		pci_acpi_remove_pm_notifier(adev);
 	}
-
-	if (pci_dev->subordinate)
-		acpi_pci_irq_del_prt(pci_domain_nr(pci_dev->bus),
-				     pci_dev->subordinate->number);
 }
 
 static struct acpi_bus_type acpi_pci_bus = {
Index: linux-2.6/include/acpi/acpi_drivers.h
===================================================================
--- linux-2.6.orig/include/acpi/acpi_drivers.h
+++ linux-2.6/include/acpi/acpi_drivers.h
@@ -90,11 +90,6 @@ int acpi_pci_link_allocate_irq(acpi_hand
 			       int *polarity, char **name);
 int acpi_pci_link_free_irq(acpi_handle handle);
 
-/* ACPI PCI Interrupt Routing (pci_irq.c) */
-
-int acpi_pci_irq_add_prt(acpi_handle handle, int segment, int bus);
-void acpi_pci_irq_del_prt(int segment, int bus);
-
 /* ACPI PCI Device Binding (pci_bind.c) */
 
 struct pci_bus;
