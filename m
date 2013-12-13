Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3LMQKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:10:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17775 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3LMQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:10:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        gordan@bobich.net
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [RFC PATCH 5/5] xen/pciback: PCI reset slot or bus
Date: Fri, 13 Dec 2013 11:09:38 -0500
Message-Id: <1386950978-8628-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
References: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The life-cycle of a PCI device in Xen pciback is a bit complex.

It starts with the device being binded to us - for which
we do a device function reset.

If the device is unbinded from us - we also do a function
reset.

If the device is un-assigned from a guest - we do a function
reset.

All on the individual PCI function level.

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

As such to do a slot (so all of the functions on a device)
or a bus reset is complex - and is not exported to SysFS
(function reset is is via 'reset' parameter). This is due
to the complexity - we MUST know that the different functions
on a PCIe device are not in use, or if they are in use
(say only one of them) - if it is still OK to reset the slot.

This patch does that by doing an slot or bus reset (if
slot reset not supported) if all of the functions of a PCIe
device belong to Xen PCIback and are not in usage.

The reset is done when all of the functions of a device
are binded to Xen pciback. Or when a device is un-assigned
from a guest. We do this by having a 'completion' workqueue
on which the users of the PCI device wait. This workqueue
is started once the device has been 'binded' or de-assigned
from a guest.

In short - once an PCI device or its functions are under
the ownership of Xen PCIback they are reset. If they
are detached from a guest - they are reset. If they are
unbound from Xen pciback - they are reset.

Reported-by: Gordan Bobic <gordan@bobich.net>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 120 ++++++++++++++++++++++++++++++++-----
 1 file changed, 105 insertions(+), 15 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 4b450c5..bcc8733 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -47,6 +47,9 @@ struct pcistub_device {
 	struct list_head dev_list;
 	spinlock_t lock;
 
+	struct work_struct reset_work;
+	struct completion reset_done;
+
 	struct pci_dev *dev;
 	struct xen_pcibk_device *pdev;/* non-NULL if struct pci_dev is in use */
 };
@@ -63,6 +66,7 @@ static LIST_HEAD(pcistub_devices);
 static int initialize_devices;
 static LIST_HEAD(seized_devices);
 
+static void pcistub_device_reset(struct work_struct *work);
 static struct pcistub_device *pcistub_device_alloc(struct pci_dev *dev)
 {
 	struct pcistub_device *psdev;
@@ -81,6 +85,8 @@ static struct pcistub_device *pcistub_device_alloc(struct pci_dev *dev)
 
 	kref_init(&psdev->kref);
 	spin_lock_init(&psdev->lock);
+	init_completion(&psdev->reset_done);
+	INIT_WORK(&psdev->reset_work, pcistub_device_reset);
 
 	return psdev;
 }
@@ -100,6 +106,9 @@ static void pcistub_device_release(struct kref *kref)
 
 	xen_unregister_device_domain_owner(dev);
 
+	/* If there was an FLR in progress, let it finish and join
+	 * it here. */
+	cancel_work_sync(&psdev->reset_work);
 	/* Call the reset function which does not take lock as this
 	 * is called from "unbind" which takes a device_lock mutex.
 	 */
@@ -219,6 +228,9 @@ struct pci_dev *pcistub_get_pci_dev_by_slot(struct xen_pcibk_device *pdev,
 	}
 
 	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+	if (found_dev)
+		wait_for_completion(&psdev->reset_done);
+
 	return found_dev;
 }
 
@@ -239,25 +251,93 @@ struct pci_dev *pcistub_get_pci_dev(struct xen_pcibk_device *pdev,
 	}
 
 	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+	if (found_dev)
+		wait_for_completion(&psdev->reset_done);
+
 	return found_dev;
 }
 
 void pcistub_reset_pci_dev(struct pci_dev *dev)
 {
+	int slots = 0, inuse = 0;
+	unsigned long flags;
+	struct pci_dev *pci_dev;
+	struct pcistub_device *psdev;
+
 	/* This is OK - we are running from workqueue context
 	 * and want to inhibit the user from fiddling with 'reset'
 	 */
 
-	dev_dbg(&dev->dev, "resetting (FLR, D3, etc) the device\n");
+	dev_dbg(&dev->dev, "resetting (FLR, D3, bus, slot, etc) the device\n");
 
 	pci_reset_function(dev);
+
+	/* Don't do this on a bridge level. */
+	if (pci_is_root_bus(dev->bus))
+		return;
+
+	/* We expect X amount of slots (this would also find out
+	 * if we do not have all of the slots assigned to us).
+	 */
+	list_for_each_entry(pci_dev, &dev->bus->devices, bus_list)
+		slots++;
+
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+	/* Iterate over the existing devices to ascertain whether
+	 * all of them are under the bridge and not in use. */
+	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
+		if (!psdev->dev)
+			continue;
+
+		if (pci_domain_nr(psdev->dev->bus) == pci_domain_nr(dev->bus) &&
+		    psdev->dev->bus->number == dev->bus->number &&
+		    PCI_SLOT(psdev->dev->devfn) == PCI_SLOT(dev->devfn)) {
+			slots--;
+			/* Ignore ourselves in case hadn't cleaned up yet */
+			if (psdev->pdev && psdev->dev != dev)
+				inuse++;
+		}
+	}
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+	/* Slots should be zero (all slots under the bridge are
+	 * accounted for), and inuse should be zero (not assigned
+	 * to anybody). */
+	if (!slots && !inuse) {
+		int rc = 0, bus = 0;
+		list_for_each_entry(pci_dev, &dev->bus->devices, bus_list) {
+			dev_dbg(&pci_dev->dev, "resetting the slot device\n");
+			if (!pci_probe_reset_slot(pci_dev->slot))
+				rc = pci_reset_slot(pci_dev->slot);
+			else
+				bus = 1;
+			if (rc)
+				dev_info(&pci_dev->dev, "resetting slot failed with %d\n", rc);
+		}
+		if (bus && !pci_probe_reset_bus(dev->bus)) {
+			dev_dbg(&dev->bus->dev, "resetting the bus device\n");
+			rc = pci_reset_bus(dev->bus);
+			if (rc)
+				dev_info(&dev->bus->dev, "resetting bus failed with %d\n", rc);
+		}
+	}
+
 	pci_restore_state(dev);
 
 	/* This disables the device. */
 	xen_pcibk_reset_device(dev);
 
-	/* And cleanup up our emulated fields. */
-	xen_pcibk_config_reset_dev(dev);
+	xen_pcibk_config_free_dyn_fields(dev);
+}
+
+static void pcistub_device_reset(struct work_struct *work)
+{
+	struct pcistub_device *psdev = container_of(work, typeof(*psdev), reset_work);
+
+	pcistub_reset_pci_dev(psdev->dev);
+
+	/* Wakes up, if paying attention: pcistub_get_pci_dev_by_slot,
+	 * pcistub_get_pci_dev, and pcistub_put_pci_dev */
+	complete(&psdev->reset_done);
 }
 
 void pcistub_put_pci_dev(struct pci_dev *dev)
@@ -285,9 +365,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	/* Cleanup our device
 	 * (so it's ready for the next domain)
 	 */
-	pcistub_reset_pci_dev(dev);
-
-	xen_pcibk_config_free_dyn_fields(dev);
+	/* And cleanup up our emulated fields. */
+	xen_pcibk_config_reset_dev(dev);
 
 	xen_unregister_device_domain_owner(dev);
 
@@ -295,6 +374,11 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	found_psdev->pdev = NULL;
 	spin_unlock_irqrestore(&found_psdev->lock, flags);
 
+	schedule_work(&found_psdev->reset_work);
+
+	/* Wait .. wait */
+	wait_for_completion(&found_psdev->reset_done);
+
 	pcistub_device_put(found_psdev);
 	up_write(&pcistub_sem);
 }
@@ -402,16 +486,13 @@ static int pcistub_init_device(struct pci_dev *dev)
 	if (!dev_data->pci_saved_state)
 		dev_err(&dev->dev, "Could not store PCI conf saved state!\n");
 	else {
-		dev_dbg(&dev->dev, "resetting (FLR, D3, etc) the device\n");
+		dev_dbg(&dev->dev, "resetting (FLR, D4, etc) the device\n");
 		__pci_reset_function_locked(dev);
+
+		/* WE should figure out whether we can reset the bus. But
+		 * it is locked! (dev_bus)*/
 		pci_restore_state(dev);
 	}
-	/* Now disable the device (this also ensures some private device
-	 * data is setup before we export)
-	 */
-	dev_dbg(&dev->dev, "reset device\n");
-	xen_pcibk_reset_device(dev);
-
 	dev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
 	return 0;
 
@@ -455,8 +536,13 @@ static int __init pcistub_init_devices_late(void)
 
 		spin_lock_irqsave(&pcistub_devices_lock, flags);
 
-		if (psdev)
+		if (psdev) {
 			list_add_tail(&psdev->dev_list, &pcistub_devices);
+			spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+
+			schedule_work(&psdev->reset_work);
+			spin_lock_irqsave(&pcistub_devices_lock, flags);
+		}
 	}
 
 	initialize_devices = 1;
@@ -497,10 +583,13 @@ static int pcistub_seize(struct pci_dev *dev)
 
 	if (err)
 		pcistub_device_put(psdev);
+	else
+		schedule_work(&psdev->reset_work);
 
 	return err;
 }
 
+/* Called when 'bind' */
 static int pcistub_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	int err = 0;
@@ -528,6 +617,7 @@ out:
 	return err;
 }
 
+/* Called when 'unbind' */
 static void pcistub_remove(struct pci_dev *dev)
 {
 	struct pcistub_device *psdev, *found_psdev = NULL;
@@ -1183,7 +1273,7 @@ static ssize_t pcistub_irq_handler_show(struct device_driver *drv, char *buf)
 			continue;
 		count +=
 		    scnprintf(buf + count, PAGE_SIZE - count,
-			      "%s:%s:%sing:%ld\n",
+			      "%s:%s:%sing:%ld:%s\n",
 			      pci_name(psdev->dev),
 			      dev_data->isr_on ? "on" : "off",
 			      dev_data->ack_intr ? "ack" : "not ack",
-- 
1.8.3.1

