Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882AbaGPTBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:01:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbaGPTBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:01:32 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 3/3] vfio-pci: Attempt bus/slot reset on release
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Date: Wed, 16 Jul 2014 13:01:31 -0600
Message-ID: <20140716190131.4153.10787.stgit@gimli.home>
In-Reply-To: <20140716184645.4153.86129.stgit@gimli.home>
References: <20140716184645.4153.86129.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each time a device is released, mark whether a local reset was
successful or whether a bus/slot reset is needed.  If a reset is
needed and all of the affected devices are bound to vfio-pci and
unused, allow the reset.  This is most useful when the userspace
driver is killed and releases all the devices in an unclean state,
such as when a QEMU VM quits.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/pci/vfio_pci.c         |  112 +++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |    1 
 2 files changed, 113 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index c4949a7..f95b90f 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -39,6 +39,8 @@ MODULE_PARM_DESC(nointxmask,
 
 static DEFINE_MUTEX(driver_lock);
 
+static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev);
+
 static int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -123,6 +125,8 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 		vdev->barmap[bar] = NULL;
 	}
 
+	vdev->needs_reset = true;
+
 	/*
 	 * If we have saved state, restore it.  If we can reset the device,
 	 * even better.  Resetting with current state seems better than
@@ -154,11 +158,15 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 		if (ret)
 			pr_warn("%s: Failed to reset device %s (%d)\n",
 				__func__, dev_name(&pdev->dev), ret);
+		else
+			vdev->needs_reset = false;
 	}
 
 	pci_restore_state(pdev);
 out:
 	pci_disable_device(pdev);
+
+	vfio_pci_try_bus_reset(vdev);
 }
 
 static void vfio_pci_release(void *device_data)
@@ -917,6 +925,110 @@ static struct pci_driver vfio_pci_driver = {
 	.err_handler	= &vfio_err_handlers,
 };
 
+/*
+ * Test whether a reset is necessary and possible.  We mark devices as
+ * needs_reset when they are released, but don't have a function-local reset
+ * available.  If any of these exist in the affected devices, we want to do
+ * a bus/slot reset.  We also need all of the affected devices to be unused,
+ * so we abort if any device has a non-zero refcnt.  driver_lock prevents a
+ * device from being opened during the scan or unbound from vfio-pci.
+ */
+static int vfio_pci_test_bus_reset(struct pci_dev *pdev, void *data)
+{
+	bool *needs_reset = data;
+	struct pci_driver *pci_drv = ACCESS_ONCE(pdev->driver);
+	int ret = -EBUSY;
+
+	if (pci_drv == &vfio_pci_driver) {
+		struct vfio_device *device;
+		struct vfio_pci_device *vdev;
+
+		device = vfio_device_get_from_dev(&pdev->dev);
+		if (!device)
+			return ret;
+
+		vdev = vfio_device_data(device);
+		if (vdev) {
+			if (vdev->needs_reset)
+				*needs_reset = true;
+
+			if (!vdev->refcnt)
+				ret = 0;
+		}
+
+		vfio_device_put(device);
+	}
+
+	/*
+	 * TODO: vfio-core considers groups to be viable even if some devices
+	 * are attached to known drivers, like pci-stub or pcieport.  We can't
+	 * freeze devices from being unbound to those drivers like we can
+	 * here though, so it would be racy to test for them.  We also can't
+	 * use device_lock() to prevent changes as that would interfere with
+	 * PCI-core taking device_lock during bus reset.  For now, we require
+	 * devices to be bound to vfio-pci to get a bus/slot reset on release.
+	 */
+
+	return ret;
+}
+
+/* Clear needs_reset on all affected devices after successful bus/slot reset */
+static int vfio_pci_clear_needs_reset(struct pci_dev *pdev, void *data)
+{
+	struct pci_driver *pci_drv = ACCESS_ONCE(pdev->driver);
+
+	if (pci_drv == &vfio_pci_driver) {
+		struct vfio_device *device;
+		struct vfio_pci_device *vdev;
+
+		device = vfio_device_get_from_dev(&pdev->dev);
+		if (!device)
+			return 0;
+
+		vdev = vfio_device_data(device);
+		if (vdev)
+			vdev->needs_reset = false;
+
+		vfio_device_put(device);
+	}
+
+	return 0;
+}
+
+/*
+ * Attempt to do a bus/slot reset if there are devices affected by a reset for
+ * this device that are needs_reset and all of the affected devices are unused
+ * (!refcnt).  Callers of this function are required to hold driver_lock such
+ * that devices can not be unbound from vfio-pci or opened by a user while we
+ * test for and perform a bus/slot reset.
+ */
+static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
+{
+	bool needs_reset = false, slot = false;
+	int ret;
+
+	if (!pci_probe_reset_slot(vdev->pdev->slot))
+		slot = true;
+	else if (pci_probe_reset_bus(vdev->pdev->bus))
+		return;
+
+	if (vfio_pci_for_each_slot_or_bus(vdev->pdev,
+					  vfio_pci_test_bus_reset,
+					  &needs_reset, slot) || !needs_reset)
+		return;
+
+	if (slot)
+		ret = pci_try_reset_slot(vdev->pdev->slot);
+	else
+		ret = pci_try_reset_bus(vdev->pdev->bus);
+
+	if (ret)
+		return;
+
+	vfio_pci_for_each_slot_or_bus(vdev->pdev,
+				      vfio_pci_clear_needs_reset, NULL, slot);
+}
+
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 31e7a30..671c17a 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -54,6 +54,7 @@ struct vfio_pci_device {
 	bool			extended_caps;
 	bool			bardirty;
 	bool			has_vga;
+	bool			needs_reset;
 	struct pci_saved_state	*pci_saved_state;
 	int			refcnt;
 	struct eventfd_ctx	*err_trigger;

