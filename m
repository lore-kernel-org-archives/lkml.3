Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbaGHR6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:58:02 -0400
Received: from mail.kernel.org ([198.145.19.201]:54867 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbaGHR5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:57:06 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v3 4/7] xen/pciback: Implement PCI reset slot or bus with 'do_flr' SysFS attribute
Date: Tue,  8 Jul 2014 14:58:26 -0400
Message-Id: <1404845909-13563-5-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1404845909-13563-1-git-send-email-konrad@kernel.org>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

The life-cycle of a PCI device in Xen pciback is complex
and is constrained by the PCI generic locking mechanism.

It starts with the device being binded to us - for which
we do a device function reset (and done via SysFS
so the PCI lock is held)

If the device is unbinded from us - we also do a function
reset (also done via SysFS so the PCI lock is held).

If the device is un-assigned from a guest - we do a function
reset (no PCI lock).

All on the individual PCI function level (so bus:device:function).

Unfortunatly a function reset is not adequate for certain
PCIe devices. The reset for an individual PCI function "means
device must support FLR (PCIe or AF), PM reset on D3hot->D0
device specific reset, or be a singleton device on a bus
a secondary bus reset.  FLR does not have widespread support,
reset is not very reliable, and bus topology is dictated by the
and device design.  We need to provide a means for a user to
a bus reset in cases where the existing mechanisms are not
 or not reliable. " (Adam Williamson, 'vfio-pci: PCI hot reset
interface' commit 8b27ee60bfd6bbb84d2df28fa706c5c5081066ca).

As such to do a slot or a bus reset is we need another mechanism.
This is not exposed SysFS as there is no good way of exposing
a bus topology there.

This is due to the complexity - we MUST know that the different
functions off a PCIe device are not in use by other drivers, or
if they are in use (say one of them is assigned to a guest
and the other is idle) - it is still OK to reset the slot
(assuming both of them are owned by Xen pciback).

This patch does that by doing an slot or bus reset (if
slot not supported) if all of the functions of a PCIe
device belong to Xen PCIback. We do not care if the device is
in-use as we depend on the toolstack to be aware of this -
however if it is we will WARN the user.

Due to the complexity with the PCI lock we cannot do
the reset when a device is binded ('echo $BDF > bind')
or when unbinded ('echo $BDF > unbind') as the pci_[slot|bus]_reset
also take the same lock resulting in a dead-lock.

Putting the reset function in a workqueue or thread
won't work either - as we have to do the reset function
outside the 'unbind' context (it holds the PCI lock).
But once you 'unbind' a device the device is no longer
under the ownership of Xen pciback and the pci_set_drvdata
has been reset so we cannot use a thread for this.

Instead of doing all this complex dance, we depend on the toolstack
doing the right thing. As such implement the 'do_flr' SysFS attribute
which 'xl' uses when a device is detached or attached from/to a guest.
It bypasses the need to worry about the PCI lock.

To not inadvertly do a bus reset that would affect devices that
are in use by other drivers (other than Xen pciback) prior
to the reset we check that all of the devices under the bridge
are owned by Xen pciback. If they are not we do not do
the bus (or slot) reset.

We also warn the user if the device is in use - but still
continue with the reset. This should not happen as the toolstack
also does the check.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/ABI/testing/sysfs-driver-pciback |   11 ++
 drivers/xen/xen-pciback/pci_stub.c             |  124 +++++++++++++++++++-----
 2 files changed, 110 insertions(+), 25 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-pciback b/Documentation/ABI/testing/sysfs-driver-pciback
index 4d2860c..812eb1a 100644
--- a/Documentation/ABI/testing/sysfs-driver-pciback
+++ b/Documentation/ABI/testing/sysfs-driver-pciback
@@ -82,3 +82,14 @@ Description:
                 device is shared, enabled, or on a level interrupt line.
                 Writing a string of DDDD:BB:DD.F will toggle the state.
                 This is Domain:Bus:Device.Function where domain is optional.
+
+What:           /sys/bus/pci/drivers/pciback/do_flr
+Date:           July 2014
+KernelVersion:  3.16
+Contact:        xen-devel@lists.xenproject.org
+Description:
+                An option to slot or bus reset an PCI device owned by
+                Xen PCI backend. Writing a string of DDDD:BB:DD.F will cause
+                the driver to perform an slot or bus reset if the device
+                supports. It also checks to make sure that all of the devices
+                under the bridge are owned by Xen PCI backend.
diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 03badac..6bb6be8 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -100,14 +100,9 @@ static void pcistub_device_release(struct kref *kref)
 
 	xen_unregister_device_domain_owner(dev);
 
-	/* Call the reset function which does not take lock as this
-	 * is called from "unbind" which takes a device_lock mutex.
-	 */
-	__pci_reset_function_locked(dev);
+	/* Reset is done by the toolstack by using 'do_flr' on the SysFS. */
 	if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
 		dev_dbg(&dev->dev, "Could not reload PCI state\n");
-	else
-		pci_restore_state(dev);
 
 	if (dev->msix_cap) {
 		struct physdev_pci_device ppdev = {
@@ -123,9 +118,6 @@ static void pcistub_device_release(struct kref *kref)
 				 err);
 	}
 
-	/* Disable the device */
-	xen_pcibk_reset_device(dev);
-
 	kfree(dev_data);
 	pci_set_drvdata(dev, NULL);
 
@@ -242,22 +234,64 @@ struct pci_dev *pcistub_get_pci_dev(struct xen_pcibk_device *pdev,
 	return found_dev;
 }
 
-static void pcistub_reset_pci_dev(struct pci_dev *dev)
+struct wrapper_args {
+	struct pci_dev *dev;
+	int in_use;
+};
+
+static int pcistub_pci_walk_wrapper(struct pci_dev *dev, void *data)
 {
-	/* This is OK - we are running from workqueue context
-	 * and want to inhibit the user from fiddling with 'reset'
-	 */
+	struct pcistub_device *psdev, *found_psdev = NULL;
+	struct wrapper_args *arg = data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
+		if (psdev->dev == dev) {
+			found_psdev = psdev;
+			if (psdev->pdev)
+				arg->in_use++;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+	dev_dbg(&dev->dev, "%s\n", found_psdev ? "OK" : "not owned by us!");
+
+	if (!found_psdev)
+		arg->dev = dev;
+	return found_psdev ? 0 : 1;
+}
+
+static int pcistub_reset_pci_dev(struct pci_dev *dev)
+{
+	struct wrapper_args arg = { .dev = NULL, .in_use = 0 };
+	bool slot = false, bus = false;
+	int rc;
+
+	if (!dev)
+		return -EINVAL;
+
+	if (!pci_probe_reset_slot(dev->slot))
+		slot = true;
+	else if (!pci_probe_reset_bus(dev->bus)) {
+		/* We won't attempt to reset a root bridge. */
+		if (!pci_is_root_bus(dev->bus))
+			bus = true;
+	}
+	dev_dbg(&dev->dev, "resetting (FLR, D3, %s %s) the device\n",
+		slot ? "slot" : "", bus ? "bus" : "");
+
+	pci_walk_bus(dev->bus, pcistub_pci_walk_wrapper, &arg);
+
+	if (arg.in_use)
+		dev_err(&dev->dev, "is in use!\n");
 
-	dev_dbg(&dev->dev, "resetting (FLR, D3, etc) the device\n");
-	/* We might be holding the PCI lock (see comment at the top of the
-	 * function) - as such try lock and if we can't then don't worry -
-	 * as either:
-	 *  - we are 'unbind' in which case 'pcistub_device_release' gets
-	 *    called which does the locked version of this.
-	 *  - the toolstack has the smarts to do it and has done the
-	 *    reset on SysFS before assigning this device to another guest.
+	/*
+	 * Takes the PCI lock. OK to do it as we are never called
+	 * from 'unbind' state and don't deadlock.
 	 */
-	pci_try_reset_function(dev);
+	pci_reset_function(dev);
+
 	pci_restore_state(dev);
 
 	/* This disables the device. */
@@ -265,6 +299,18 @@ static void pcistub_reset_pci_dev(struct pci_dev *dev)
 
 	/* And cleanup up our emulated fields. */
 	xen_pcibk_config_reset_dev(dev);
+
+	if (!bus && !slot)
+		return 0;
+
+	/* All slots or devices under the bus should be part of pcistub! */
+	if (arg.dev) {
+		dev_err(&dev->dev, "depends on: %s!\n", pci_name(arg.dev));
+		return -EBUSY;
+	}
+	rc = slot ? pci_try_reset_slot(dev->slot): pci_try_reset_bus(dev->bus);
+
+	return rc;
 }
 
 /*
@@ -298,10 +344,10 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	* pcistub and xen_pcibk when AER is in processing
 	*/
 	down_write(&pcistub_sem);
-	/* Cleanup our device
-	 * (so it's ready for the next domain)
+	/* Cleanup our device (so it's ready for the next domain)
+	 * That is the job of the toolstack which has to call 'do_flr' before
+	 * providing the PCI device to a guest (see pcistub_do_flr).
 	 */
-	pcistub_reset_pci_dev(dev);
 
 	xen_pcibk_config_free_dyn_fields(dev);
 
@@ -1388,6 +1434,29 @@ static ssize_t permissive_show(struct device_driver *drv, char *buf)
 static DRIVER_ATTR(permissive, S_IRUSR | S_IWUSR, permissive_show,
 		   permissive_add);
 
+static ssize_t pcistub_do_flr(struct device_driver *drv, const char *buf,
+				size_t count)
+{
+	int domain, bus, slot, func;
+	int err;
+	struct pcistub_device *psdev;
+
+	err = str_to_slot(buf, &domain, &bus, &slot, &func);
+	if (err)
+		goto out;
+
+	psdev = pcistub_device_find(domain, bus, slot, func);
+	if (psdev) {
+		err = pcistub_reset_pci_dev(psdev->dev);
+		pcistub_device_put(psdev);
+	} else
+		err = -ENODEV;
+out:
+	if (!err)
+		err = count;
+	return err;
+}
+static DRIVER_ATTR(do_flr, S_IWUSR, NULL, pcistub_do_flr);
 static void pcistub_exit(void)
 {
 	driver_remove_file(&xen_pcibk_pci_driver.driver, &driver_attr_new_slot);
@@ -1401,6 +1470,8 @@ static void pcistub_exit(void)
 			   &driver_attr_irq_handlers);
 	driver_remove_file(&xen_pcibk_pci_driver.driver,
 			   &driver_attr_irq_handler_state);
+	driver_remove_file(&xen_pcibk_pci_driver.driver,
+			   &driver_attr_do_flr);
 	pci_unregister_driver(&xen_pcibk_pci_driver);
 }
 
@@ -1494,6 +1565,9 @@ static int __init pcistub_init(void)
 	if (!err)
 		err = driver_create_file(&xen_pcibk_pci_driver.driver,
 					&driver_attr_irq_handler_state);
+	if (!err)
+		err = driver_create_file(&xen_pcibk_pci_driver.driver,
+					&driver_attr_do_flr);
 	if (err)
 		pcistub_exit();
 
-- 
1.7.7.6

