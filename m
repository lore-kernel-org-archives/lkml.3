Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbaFCXBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:01:10 -0400
Received: from [162.210.130.12] ([162.210.130.12]:56330 "EHLO
	prod-mx.aristanetworks.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751955AbaFCXBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:01:07 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2014 19:01:07 EDT
Date: Tue, 03 Jun 2014 15:55:02 -0700
To: linux-kernel@vger.kernel.org, hare@suse.de, gregkh@linuxfoundation.org,
        linux@roeck-us.net
Subject: Re: pci: kernel crash in bus_find_device
Cc: fruggeri@arista.com
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20140603225502.F1C5122C07D5@bs320.sjc.aristanetworks.com>
From: fruggeri@aristanetworks.com (Francesco Ruggeri)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In-Reply-To: <20140523023141.GC13900@kroah.com>


Hi Guenter,
I got back to looking into this crash.
Just as an example, the attached diffs also fix my bus_find_device problem for
traversals that start from the head of the list and traverse it completely.
They are very specific to the case of bus_find_device, and a complete solution
would affect a lot of code.
The main issue seems to be that when a device is found in a klist by say
bus_find_device the klist_node reference should be returned to the caller,
who should then decide whether to use it for the next klist search, drop it or
maybe exchange it for a struct device reference. When resuming a search one
should already hold a klist_node reference from the previous search.
This model is broken by several functions using struct devices such as
bus_find_device, which resume klist searches on the implicit assumption that
holding a reference to the struct device is enough to acquire one on the
klist_node. 
The only reason that this has not been a big issue so far is probably that
on most systems struct devices are not destroyed and created very often.
Thanks,
Francesco


Index: linux-3.4/lib/klist.c
===================================================================
--- linux-3.4.orig/lib/klist.c
+++ linux-3.4/lib/klist.c
@@ -318,6 +318,51 @@ void klist_iter_exit(struct klist_iter *
 }
 EXPORT_SYMBOL_GPL(klist_iter_exit);
 
+/**
+ * klist_iter_init_node_noref - Initialize a klist_iter structure without
+ *				taking a kref.
+ * @k: klist we're iterating.
+ * @i: klist_iter we're filling.
+ * @n: node to start with.
+ *
+ * Similar to klist_iter_init_noref(), but starts the action off with @n,
+ * instead of with the list head.
+ */
+void klist_iter_init_node_noref(struct klist *k, struct klist_iter *i,
+			  struct klist_node *n)
+{
+	i->i_klist = k;
+	i->i_cur = n;
+}
+EXPORT_SYMBOL_GPL(klist_iter_init_node_noref);
+
+/**
+ * klist_iter_init_noref - Initalize a klist_iter structure without taking
+ *			   a kref.
+ * @k: klist we're iterating.
+ * @i: klist_iter structure we're filling.
+ *
+ * Similar to klist_iter_init_node_noref(), but start with the list head.
+ */
+void klist_iter_init_noref(struct klist *k, struct klist_iter *i)
+{
+	klist_iter_init_node_noref(k, i, NULL);
+}
+EXPORT_SYMBOL_GPL(klist_iter_init_noref);
+
+/**
+ * klist_iter_exit_noref - Finish a list iteration without dropping a kref.
+ * @i: Iterator structure.
+ *
+ * Not really needed, but always good form.
+ */
+void klist_iter_exit_noref(struct klist_iter *i)
+{
+	if (i->i_cur)
+		i->i_cur = NULL;
+}
+EXPORT_SYMBOL_GPL(klist_iter_exit_noref);
+
 static struct klist_node *to_klist_node(struct list_head *n)
 {
 	return container_of(n, struct klist_node, n_node);
Index: linux-3.4/drivers/base/bus.c
===================================================================
--- linux-3.4.orig/drivers/base/bus.c
+++ linux-3.4/drivers/base/bus.c
@@ -341,6 +341,37 @@ struct device *bus_find_device(struct bu
 }
 EXPORT_SYMBOL_GPL(bus_find_device);
 
+/**
+ * bus_find_device_noref - device iterator for locating a particular device.
+ * @bus: bus type
+ * @start: Device to begin with
+ * @data: Data to pass to match function
+ * @match: Callback function to check device
+ *
+ * Same as bus_find_device, but it assumes caller already has klist_node ref,
+ * and it returns to caller a struct device with the new kref.
+ */
+
+struct device *bus_find_device_noref(struct bus_type *bus,
+				     struct device *start, void *data,
+				     int (*match)(struct device *dev, void *data))
+{
+	struct klist_iter i;
+	struct device *dev;
+
+	if (!bus || !bus->p)
+		return NULL;
+
+	klist_iter_init_node_noref(&bus->p->klist_devices, &i,
+				   (start ? &start->p->knode_bus : NULL));
+	while ((dev = next_device(&i)))
+		if (match(dev, data) && get_device(dev))
+			break;
+	klist_iter_exit_noref(&i);
+	return dev;
+}
+EXPORT_SYMBOL_GPL(bus_find_device_noref);
+
 static int match_name(struct device *dev, void *data)
 {
 	const char *name = data;
Index: linux-3.4/drivers/pci/search.c
===================================================================
--- linux-3.4.orig/drivers/pci/search.c
+++ linux-3.4/drivers/pci/search.c
@@ -289,6 +289,94 @@ pci_get_device(unsigned int vendor, unsi
 	return pci_get_subsys(vendor, device, PCI_ANY_ID, PCI_ANY_ID, from);
 }
 
+/*
+ * pci_get_dev_by_id_noref - begin or continue searching for a PCI device by id
+ * @id: pointer to struct pci_device_id to match for the device
+ * @from: Previous PCI device found in search, or %NULL for new search.
+ *
+ * Same as pci_get_dev_by_id, but it expects caller to hold a kref on knode_bus
+ * in "from" from previous search, and it holds a kref on knode_bus in returned
+ * pdev.
+ * This is an internal function for use by the other search functions in
+ * this file.
+ */
+static struct pci_dev *pci_get_dev_by_id_noref(const struct pci_device_id *id,
+					       struct pci_dev *from)
+{
+	struct device *dev;
+	struct device *dev_start = NULL;
+	struct pci_dev *pdev = NULL;
+
+	WARN_ON(in_interrupt());
+	if (from)
+		dev_start = &from->dev;
+	dev = bus_find_device_noref(&pci_bus_type, dev_start, (void *)id,
+				    match_pci_dev_by_id);
+	if (dev)
+		pdev = to_pci_dev(dev);
+	if (from)
+		pci_dev_put(from);
+	return pdev;
+}
+
+/**
+ * pci_get_subsys_noref - begin or continue searching for a PCI device by vendor/subvendor/device/subdevice id
+ * @vendor: PCI vendor id to match, or %PCI_ANY_ID to match all vendor ids
+ * @device: PCI device id to match, or %PCI_ANY_ID to match all device ids
+ * @ss_vendor: PCI subsystem vendor id to match, or %PCI_ANY_ID to match all vendor ids
+ * @ss_device: PCI subsystem device id to match, or %PCI_ANY_ID to match all device ids
+ * @from: Previous PCI device found in search, or %NULL for new search.
+ *
+ * Same as pci_get_subsys, but it expects caller to hold a kref on knode_bus
+ * in "from" from previous search, and it holds a kref on knode_bus in returned
+ * pdev.
+ */
+struct pci_dev *pci_get_subsys_noref(unsigned int vendor, unsigned int device,
+				     unsigned int ss_vendor, unsigned int ss_device,
+				     struct pci_dev *from)
+{
+	struct pci_dev *pdev;
+	struct pci_device_id *id;
+
+	/*
+	 * pci_find_subsys() can be called on the ide_setup() path,
+	 * super-early in boot.  But the down_read() will enable local
+	 * interrupts, which can cause some machines to crash.  So here we
+	 * detect and flag that situation and bail out early.
+	 */
+	if (unlikely(no_pci_devices()))
+		return NULL;
+
+	id = kzalloc(sizeof(*id), GFP_KERNEL);
+	if (!id)
+		return NULL;
+	id->vendor = vendor;
+	id->device = device;
+	id->subvendor = ss_vendor;
+	id->subdevice = ss_device;
+
+	pdev = pci_get_dev_by_id_noref(id, from);
+	kfree(id);
+
+	return pdev;
+}
+
+/**
+ * pci_get_device_noref - begin or continue searching for a PCI device by vendor/device id
+ * @vendor: PCI vendor id to match, or %PCI_ANY_ID to match all vendor ids
+ * @device: PCI device id to match, or %PCI_ANY_ID to match all device ids
+ * @from: Previous PCI device found in search, or %NULL for new search.
+ *
+ * Same as pci_get_subsys, but it expects caller to hold a kref on knode_bus
+ * in "from" from previous search, and it holds a kref on knode_bus in returned
+ * pdev.
+ */
+struct pci_dev *
+pci_get_device_noref(unsigned int vendor, unsigned int device, struct pci_dev *from)
+{
+	return pci_get_subsys_noref(vendor, device, PCI_ANY_ID, PCI_ANY_ID, from);
+}
+
 /**
  * pci_get_class - begin or continue searching for a PCI device by class
  * @class: search for a PCI device with this class designation
@@ -355,5 +443,7 @@ EXPORT_SYMBOL(pci_find_next_bus);
 /* For everyone */
 EXPORT_SYMBOL(pci_get_device);
 EXPORT_SYMBOL(pci_get_subsys);
+EXPORT_SYMBOL(pci_get_device_noref);
+EXPORT_SYMBOL(pci_get_subsys_noref);
 EXPORT_SYMBOL(pci_get_slot);
 EXPORT_SYMBOL(pci_get_class);
Index: linux-3.4/include/linux/pci.h
===================================================================
--- linux-3.4.orig/include/linux/pci.h
+++ linux-3.4/include/linux/pci.h
@@ -719,6 +719,11 @@ struct pci_dev *pci_get_device(unsigned 
 struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 				unsigned int ss_vendor, unsigned int ss_device,
 				struct pci_dev *from);
+struct pci_dev *pci_get_device_noref(unsigned int vendor, unsigned int device,
+				     struct pci_dev *from);
+struct pci_dev *pci_get_subsys_noref(unsigned int vendor, unsigned int device,
+				     unsigned int ss_vendor, unsigned int ss_device,
+				     struct pci_dev *from);
 struct pci_dev *pci_get_slot(struct pci_bus *bus, unsigned int devfn);
 struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
 					    unsigned int devfn);
Index: linux-3.4/include/linux/device.h
===================================================================
--- linux-3.4.orig/include/linux/device.h
+++ linux-3.4/include/linux/device.h
@@ -140,6 +140,9 @@ int bus_for_each_dev(struct bus_type *bu
 struct device *bus_find_device(struct bus_type *bus, struct device *start,
 			       void *data,
 			       int (*match)(struct device *dev, void *data));
+struct device *bus_find_device_noref(struct bus_type *bus, struct device *start,
+				     void *data,
+				     int (*match)(struct device *dev, void *data));
 struct device *bus_find_device_by_name(struct bus_type *bus,
 				       struct device *start,
 				       const char *name);
Index: linux-3.4/include/linux/klist.h
===================================================================
--- linux-3.4.orig/include/linux/klist.h
+++ linux-3.4/include/linux/klist.h
@@ -63,6 +63,10 @@ extern void klist_iter_init(struct klist
 extern void klist_iter_init_node(struct klist *k, struct klist_iter *i,
 				 struct klist_node *n);
 extern void klist_iter_exit(struct klist_iter *i);
+extern void klist_iter_init_noref(struct klist *k, struct klist_iter *i);
+extern void klist_iter_init_node_noref(struct klist *k, struct klist_iter *i,
+				       struct klist_node *n);
+extern void klist_iter_exit_noref(struct klist_iter *i);
 extern struct klist_node *klist_next(struct klist_iter *i);
 
 #endif
