Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaLCVm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:42:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33561 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaLCVlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:41:09 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v5 9/9] xen/pciback: Implement PCI reset slot or bus with 'do_flr' SysFS attribute
Date: Wed,  3 Dec 2014 16:40:34 -0500
Message-Id: <1417642834-20350-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com>
References: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 Documentation/ABI/testing/sysfs-driver-pciback |  12 +++
 drivers/xen/xen-pciback/pci_stub.c             | 124 ++++++++++++++++++++++---
 2 files changed, 125 insertions(+), 11 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-pciback b/Documentation/ABI/testing/sysfs-driver-pciback
index 6a733bf..2d4e32f 100644
--- a/Documentation/ABI/testing/sysfs-driver-pciback
+++ b/Documentation/ABI/testing/sysfs-driver-pciback
@@ -11,3 +11,15 @@ Description:
                 #echo 00:19.0-E0:2:FF > /sys/bus/pci/drivers/pciback/quirks
                 will allow the guest to read and write to the configuration
                 register 0x0E.
+
+
+What:           /sys/bus/pci/drivers/pciback/do_flr
+Date:           December 2014
+KernelVersion:  3.19
+Contact:        xen-devel@lists.xenproject.org
+Description:
+                An option to slot or bus reset an PCI device owned by
+                Xen PCI backend. Writing a string of DDDD:BB:DD.F will cause
+                the driver to perform an slot or bus reset if the device
+                supports. It also checks to make sure that all of the devices
+                under the bridge are owned by Xen PCI backend.
diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index cc3cbb4..f830bf4 100644
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
 		dev_info(&dev->dev, "Could not reload PCI state\n");
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
 
@@ -242,6 +234,87 @@ struct pci_dev *pcistub_get_pci_dev(struct xen_pcibk_device *pdev,
 	return found_dev;
 }
 
+struct wrapper_args {
+	struct pci_dev *dev;
+	int in_use;
+};
+
+static int pcistub_pci_walk_wrapper(struct pci_dev *dev, void *data)
+{
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
+	struct xen_pcibk_dev_data *dev_data;
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
+
+	/*
+	 * Takes the PCI lock. OK to do it as we are never called
+	 * from 'unbind' state and don't deadlock.
+	 */
+	dev_data = pci_get_drvdata(dev);
+	if (!pci_load_saved_state(dev, dev_data->pci_saved_state))
+		pci_restore_state(dev);
+
+	pci_reset_function(dev);
+
+	/* This disables the device. */
+	xen_pcibk_reset_device(dev);
+
+	/* And cleanup up our emulated fields. */
+	xen_pcibk_config_reset_dev(dev);
+
+	if (!bus && !slot)
+		return 0;
+
+	/* All slots or devices under the bus should be part of pcistub! */
+	if (arg.dev) {
+		dev_err(&dev->dev, "depends on: %s!\n", pci_name(arg.dev));
+		return -EBUSY;
+	}
+	return slot ? pci_try_reset_slot(dev->slot) :
+		      pci_try_reset_bus(dev->bus);
+}
+
 /*
  * Called when:
  *  - XenBus state has been reconfigure (pci unplug). See xen_pcibk_remove_device
@@ -277,8 +350,9 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	* pcistub and xen_pcibk when AER is in processing
 	*/
 	down_write(&pcistub_sem);
-	/* Cleanup our device
-	 * (so it's ready for the next domain)
+	/* Cleanup our device (so it's ready for the next domain)
+	 * That is the job of the toolstack which has to call 'do_flr' before
+	 * providing the PCI device to a guest (see pcistub_do_flr).
 	 */
 	device_lock_assert(&dev->dev);
 	__pci_reset_function_locked(dev);
@@ -1389,6 +1463,29 @@ static ssize_t permissive_show(struct device_driver *drv, char *buf)
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
@@ -1402,6 +1499,8 @@ static void pcistub_exit(void)
 			   &driver_attr_irq_handlers);
 	driver_remove_file(&xen_pcibk_pci_driver.driver,
 			   &driver_attr_irq_handler_state);
+	driver_remove_file(&xen_pcibk_pci_driver.driver,
+			   &driver_attr_do_flr);
 	pci_unregister_driver(&xen_pcibk_pci_driver);
 }
 
@@ -1495,6 +1594,9 @@ static int __init pcistub_init(void)
 	if (!err)
 		err = driver_create_file(&xen_pcibk_pci_driver.driver,
 					&driver_attr_irq_handler_state);
+	if (!err)
+		err = driver_create_file(&xen_pcibk_pci_driver.driver,
+					&driver_attr_do_flr);
 	if (err)
 		pcistub_exit();
 
-- 
1.9.3

