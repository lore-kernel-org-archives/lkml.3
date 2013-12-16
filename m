Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab3LPWSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 17:18:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab3LPWSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 17:18:05 -0500
Subject: [PATCH] vfio-pci: Don't use device_lock around AER interrupt setup
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 16 Dec 2013 15:18:03 -0700
Message-ID: <20131216221726.3575.59283.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_lock is much too prone to lockups.  For instance if we have a
pending .remove then device_lock is already held.  If userspace
attempts to modify AER signaling after that point, a deadlock occurs.
eventfd setup/teardown is already protected in vfio with the igate
mutex.  AER is not a high performance interrupt, so we can also use
the same mutex to protect signaling versus setup races.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c       |    4 ++++
 drivers/vfio/pci/vfio_pci_intrs.c |   17 -----------------
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 576e34e..468a9fb 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -872,9 +872,13 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	mutex_lock(&vdev->igate);
+
 	if (vdev->err_trigger)
 		eventfd_signal(vdev->err_trigger, 1);
 
+	mutex_unlock(&vdev->igate);
+
 	vfio_device_put(device);
 
 	return PCI_ERS_RESULT_CAN_RECOVER;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 641bc87..2103576 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -749,54 +749,37 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_device *vdev,
 				    unsigned count, uint32_t flags, void *data)
 {
 	int32_t fd = *(int32_t *)data;
-	struct pci_dev *pdev = vdev->pdev;
 
 	if ((index != VFIO_PCI_ERR_IRQ_INDEX) ||
 	    !(flags & VFIO_IRQ_SET_DATA_TYPE_MASK))
 		return -EINVAL;
 
-	/*
-	 * device_lock synchronizes setting and checking of
-	 * err_trigger. The vfio_pci_aer_err_detected() is also
-	 * called with device_lock held.
-	 */
-
 	/* DATA_NONE/DATA_BOOL enables loopback testing */
-
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		device_lock(&pdev->dev);
 		if (vdev->err_trigger)
 			eventfd_signal(vdev->err_trigger, 1);
-		device_unlock(&pdev->dev);
 		return 0;
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		uint8_t trigger = *(uint8_t *)data;
-		device_lock(&pdev->dev);
 		if (trigger && vdev->err_trigger)
 			eventfd_signal(vdev->err_trigger, 1);
-		device_unlock(&pdev->dev);
 		return 0;
 	}
 
 	/* Handle SET_DATA_EVENTFD */
-
 	if (fd == -1) {
-		device_lock(&pdev->dev);
 		if (vdev->err_trigger)
 			eventfd_ctx_put(vdev->err_trigger);
 		vdev->err_trigger = NULL;
-		device_unlock(&pdev->dev);
 		return 0;
 	} else if (fd >= 0) {
 		struct eventfd_ctx *efdctx;
 		efdctx = eventfd_ctx_fdget(fd);
 		if (IS_ERR(efdctx))
 			return PTR_ERR(efdctx);
-		device_lock(&pdev->dev);
 		if (vdev->err_trigger)
 			eventfd_ctx_put(vdev->err_trigger);
 		vdev->err_trigger = efdctx;
-		device_unlock(&pdev->dev);
 		return 0;
 	} else
 		return -EINVAL;

