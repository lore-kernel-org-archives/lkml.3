Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaI3APx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:15:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911AbaI3APw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:15:52 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] vfio-pci: Fix remove path locking
To: alex.williamson@redhat.com, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 29 Sep 2014 18:15:51 -0600
Message-ID: <20140930001533.17278.33091.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Locking both the remove() and release() path results in a deadlock
that should have been obvious.  To fix this we can get and hold the
vfio_device reference as we evaluate whether to do a bus/slot reset.
This will automatically block any remove() calls, allowing us to
remove the explict lock.  Fixes 61d792562b53.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org	[3.17]
---

 drivers/vfio/pci/vfio_pci.c |  136 ++++++++++++++++++-------------------------
 1 file changed, 57 insertions(+), 79 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f782533..9558da3 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -876,15 +876,11 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct vfio_pci_device *vdev;
 
-	mutex_lock(&driver_lock);
-
 	vdev = vfio_del_group_dev(&pdev->dev);
 	if (vdev) {
 		iommu_group_put(pdev->dev.iommu_group);
 		kfree(vdev);
 	}
-
-	mutex_unlock(&driver_lock);
 }
 
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
@@ -927,108 +923,90 @@ static struct pci_driver vfio_pci_driver = {
 	.err_handler	= &vfio_err_handlers,
 };
 
-/*
- * Test whether a reset is necessary and possible.  We mark devices as
- * needs_reset when they are released, but don't have a function-local reset
- * available.  If any of these exist in the affected devices, we want to do
- * a bus/slot reset.  We also need all of the affected devices to be unused,
- * so we abort if any device has a non-zero refcnt.  driver_lock prevents a
- * device from being opened during the scan or unbound from vfio-pci.
- */
-static int vfio_pci_test_bus_reset(struct pci_dev *pdev, void *data)
-{
-	bool *needs_reset = data;
-	struct pci_driver *pci_drv = ACCESS_ONCE(pdev->driver);
-	int ret = -EBUSY;
-
-	if (pci_drv == &vfio_pci_driver) {
-		struct vfio_device *device;
-		struct vfio_pci_device *vdev;
-
-		device = vfio_device_get_from_dev(&pdev->dev);
-		if (!device)
-			return ret;
-
-		vdev = vfio_device_data(device);
-		if (vdev) {
-			if (vdev->needs_reset)
-				*needs_reset = true;
-
-			if (!vdev->refcnt)
-				ret = 0;
-		}
-
-		vfio_device_put(device);
-	}
-
-	/*
-	 * TODO: vfio-core considers groups to be viable even if some devices
-	 * are attached to known drivers, like pci-stub or pcieport.  We can't
-	 * freeze devices from being unbound to those drivers like we can
-	 * here though, so it would be racy to test for them.  We also can't
-	 * use device_lock() to prevent changes as that would interfere with
-	 * PCI-core taking device_lock during bus reset.  For now, we require
-	 * devices to be bound to vfio-pci to get a bus/slot reset on release.
-	 */
-
-	return ret;
-}
+struct vfio_devices {
+	struct vfio_device **devices;
+	int cur_index;
+	int max_index;
+};
 
-/* Clear needs_reset on all affected devices after successful bus/slot reset */
-static int vfio_pci_clear_needs_reset(struct pci_dev *pdev, void *data)
+static int vfio_pci_get_devs(struct pci_dev *pdev, void *data)
 {
+	struct vfio_devices *devs = data;
 	struct pci_driver *pci_drv = ACCESS_ONCE(pdev->driver);
 
-	if (pci_drv == &vfio_pci_driver) {
-		struct vfio_device *device;
-		struct vfio_pci_device *vdev;
+	if (pci_drv != &vfio_pci_driver)
+		return -EBUSY;
 
-		device = vfio_device_get_from_dev(&pdev->dev);
-		if (!device)
-			return 0;
+	if (devs->cur_index == devs->max_index)
+		return -ENOSPC;
 
-		vdev = vfio_device_data(device);
-		if (vdev)
-			vdev->needs_reset = false;
-
-		vfio_device_put(device);
-	}
+	devs->devices[devs->cur_index] = vfio_device_get_from_dev(&pdev->dev);
+	if (!devs->devices[devs->cur_index])
+		return -EINVAL;
 
+	devs->cur_index++;
 	return 0;
 }
 
 /*
  * Attempt to do a bus/slot reset if there are devices affected by a reset for
  * this device that are needs_reset and all of the affected devices are unused
- * (!refcnt).  Callers of this function are required to hold driver_lock such
- * that devices can not be unbound from vfio-pci or opened by a user while we
- * test for and perform a bus/slot reset.
+ * (!refcnt).  Callers are required to hold driver_lock when calling this to
+ * prevent device opens and concurrent bus reset attempts.  We prevent device
+ * unbinds by acquiring and holding a reference to the vfio_device.
+ *
+ * NB: vfio-core considers a group to be viable even if some devices are
+ * bound to drivers like pci-stub or pcieport.  Here we require all devices
+ * to be bound to vfio_pci since that's the only way we can be sure they
+ * stay put.
  */
 static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 {
+	struct vfio_devices devs = { .cur_index = 0 };
+	int i = 0, ret = -EINVAL;
 	bool needs_reset = false, slot = false;
-	int ret;
+	struct vfio_pci_device *tmp;
 
 	if (!pci_probe_reset_slot(vdev->pdev->slot))
 		slot = true;
 	else if (pci_probe_reset_bus(vdev->pdev->bus))
 		return;
 
-	if (vfio_pci_for_each_slot_or_bus(vdev->pdev,
-					  vfio_pci_test_bus_reset,
-					  &needs_reset, slot) || !needs_reset)
+	if (vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
+					  &i, slot) || !i)
 		return;
 
-	if (slot)
-		ret = pci_try_reset_slot(vdev->pdev->slot);
-	else
-		ret = pci_try_reset_bus(vdev->pdev->bus);
-
-	if (ret)
+	devs.max_index = i;
+	devs.devices = kcalloc(i, sizeof(struct vfio_device *), GFP_KERNEL);
+	if (!devs.devices)
 		return;
 
-	vfio_pci_for_each_slot_or_bus(vdev->pdev,
-				      vfio_pci_clear_needs_reset, NULL, slot);
+	if (vfio_pci_for_each_slot_or_bus(vdev->pdev,
+					  vfio_pci_get_devs, &devs, slot))
+		goto put_devs;
+
+	for (i = 0; i < devs.cur_index; i++) {
+		tmp = vfio_device_data(devs.devices[i]);
+		if (tmp->needs_reset)
+			needs_reset = true;
+		if (tmp->refcnt)
+			goto put_devs;
+	}
+
+	if (needs_reset)
+		ret = slot ? pci_try_reset_slot(vdev->pdev->slot) :
+			     pci_try_reset_bus(vdev->pdev->bus);
+
+put_devs:
+	for (i = 0; i < devs.cur_index; i++) {
+		if (!ret) {
+			tmp = vfio_device_data(devs.devices[i]);
+			tmp->needs_reset = false;
+		}
+		vfio_device_put(devs.devices[i]);
+	}
+
+	kfree(devs.devices);
 }
 
 static void __exit vfio_pci_cleanup(void)

