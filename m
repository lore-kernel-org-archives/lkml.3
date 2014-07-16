Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaGPTBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:01:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760510AbaGPTB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:01:27 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/3] vfio-pci: Use mutex around open, release, and remove
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Date: Wed, 16 Jul 2014 13:01:25 -0600
Message-ID: <20140716190124.4153.97712.stgit@gimli.home>
In-Reply-To: <20140716184645.4153.86129.stgit@gimli.home>
References: <20140716184645.4153.86129.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serializing open/release allows us to fix a refcnt error if we fail
to enable the device and lets us prevent devices from being unbound
or opened, giving us an opportunity to do bus resets on release.  No
restriction added to serialize binding devices to vfio-pci while the
mutex is held though.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/pci/vfio_pci.c         |   35 +++++++++++++++++++++++++----------
 drivers/vfio/pci/vfio_pci_private.h |    2 +-
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 36d8332..c4949a7 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -37,6 +37,8 @@ module_param_named(nointxmask, nointxmask, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(nointxmask,
 		  "Disable support for PCI 2.3 style INTx masking.  If this resolves problems for specific devices, report lspci -vvvxxx to linux-pci@vger.kernel.org so the device can be fixed automatically via the broken_intx_masking flag.");
 
+static DEFINE_MUTEX(driver_lock);
+
 static int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -163,28 +165,39 @@ static void vfio_pci_release(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
 
-	if (atomic_dec_and_test(&vdev->refcnt))
+	mutex_lock(&driver_lock);
+
+	if (!(--vdev->refcnt))
 		vfio_pci_disable(vdev);
 
+	mutex_unlock(&driver_lock);
+
 	module_put(THIS_MODULE);
 }
 
 static int vfio_pci_open(void *device_data)
 {
 	struct vfio_pci_device *vdev = device_data;
+	int ret = 0;
 
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
-	if (atomic_inc_return(&vdev->refcnt) == 1) {
-		int ret = vfio_pci_enable(vdev);
+	mutex_lock(&driver_lock);
+
+	if (!vdev->refcnt) {
+		ret = vfio_pci_enable(vdev);
 		if (ret) {
 			module_put(THIS_MODULE);
-			return ret;
+			goto unlock;
 		}
 	}
+	vdev->refcnt++;
 
-	return 0;
+unlock:
+	mutex_unlock(&driver_lock);
+
+	return ret;
 }
 
 static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
@@ -839,7 +852,6 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
 	spin_lock_init(&vdev->irqlock);
-	atomic_set(&vdev->refcnt, 0);
 
 	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
 	if (ret) {
@@ -854,12 +866,15 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct vfio_pci_device *vdev;
 
+	mutex_lock(&driver_lock);
+
 	vdev = vfio_del_group_dev(&pdev->dev);
-	if (!vdev)
-		return;
+	if (vdev) {
+		iommu_group_put(pdev->dev.iommu_group);
+		kfree(vdev);
+	}
 
-	iommu_group_put(pdev->dev.iommu_group);
-	kfree(vdev);
+	mutex_unlock(&driver_lock);
 }
 
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 9c6d5d0..31e7a30 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -55,7 +55,7 @@ struct vfio_pci_device {
 	bool			bardirty;
 	bool			has_vga;
 	struct pci_saved_state	*pci_saved_state;
-	atomic_t		refcnt;
+	int			refcnt;
 	struct eventfd_ctx	*err_trigger;
 };
 

