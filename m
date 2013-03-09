Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab3CIHxD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 02:53:03 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:42069 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab3CIHwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 02:52:31 -0500
From: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
To: alex.williamson@redhat.com, gleb@redhat.com, bhelgaas@google.com,
        blauwirbel@gmail.com, lance.oritz@hp.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
Subject: [PATCH v7 2/3] VFIO-AER: Vfio-pci driver changes for supporting AER
Date: Sat,  9 Mar 2013 01:52:16 -0600
Message-Id: <1362815537-27303-3-git-send-email-vijaymohan.pandarathil@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1362815537-27303-1-git-send-email-vijaymohan.pandarathil@hp.com>
References: <1362815537-27303-1-git-send-email-vijaymohan.pandarathil@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	- New VFIO_SET_IRQ ioctl option to pass the eventfd that is signaled when
          an error occurs in the vfio_pci_device

	- Register pci_error_handler for the vfio_pci driver

	- When the device encounters an error, the error handler registered by
          the vfio_pci driver gets invoked by the AER infrastructure

	- In the error handler, signal the eventfd registered for the device.

	- This results in the qemu eventfd handler getting invoked and
          appropriate action taken for the guest.

Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 drivers/vfio/pci/vfio_pci.c         | 44 ++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_intrs.c   | 64 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 include/uapi/linux/vfio.h           |  1 +
 4 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 8189cb6..acfcb1a 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -201,7 +201,9 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 
 			return (flags & PCI_MSIX_FLAGS_QSIZE) + 1;
 		}
-	}
+	} else if (irq_type == VFIO_PCI_ERR_IRQ_INDEX)
+		if (pci_is_pcie(vdev->pdev))
+			return 1;
 
 	return 0;
 }
@@ -317,6 +319,17 @@ static long vfio_pci_ioctl(void *device_data,
 		if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
 			return -EINVAL;
 
+		switch (info.index) {
+		case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
+			break;
+		case VFIO_PCI_ERR_IRQ_INDEX:
+			if (pci_is_pcie(vdev->pdev))
+				break;
+		/* pass thru to return error */
+		default:
+			return -EINVAL;
+		}
+
 		info.flags = VFIO_IRQ_INFO_EVENTFD;
 
 		info.count = vfio_pci_get_irq_count(vdev, info.index);
@@ -551,11 +564,40 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	kfree(vdev);
 }
 
+static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
+						  pci_channel_state_t state)
+{
+	struct vfio_pci_device *vdev;
+	struct vfio_device *device;
+
+	device = vfio_device_get_from_dev(&pdev->dev);
+	if (device == NULL)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	vdev = vfio_device_data(device);
+	if (vdev == NULL) {
+		vfio_device_put(device);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	if (vdev->err_trigger)
+		eventfd_signal(vdev->err_trigger, 1);
+
+	vfio_device_put(device);
+
+	return PCI_ERS_RESULT_CAN_RECOVER;
+}
+
+static struct pci_error_handlers vfio_err_handlers = {
+	.error_detected = vfio_pci_aer_err_detected,
+};
+
 static struct pci_driver vfio_pci_driver = {
 	.name		= "vfio-pci",
 	.id_table	= NULL, /* only dynamic ids */
 	.probe		= vfio_pci_probe,
 	.remove		= vfio_pci_remove,
+	.err_handler	= &vfio_err_handlers,
 };
 
 static void __exit vfio_pci_cleanup(void)
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 3639371..b84bf22 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -745,6 +745,63 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_device *vdev,
 	return 0;
 }
 
+static int vfio_pci_set_err_trigger(struct vfio_pci_device *vdev,
+				    unsigned index, unsigned start,
+				    unsigned count, uint32_t flags, void *data)
+{
+	int32_t fd = *(int32_t *)data;
+	struct pci_dev *pdev = vdev->pdev;
+
+	if ((index != VFIO_PCI_ERR_IRQ_INDEX) ||
+	    !(flags & VFIO_IRQ_SET_DATA_TYPE_MASK))
+		return -EINVAL;
+
+	/*
+	 * device_lock synchronizes setting and checking of
+	 * err_trigger. The vfio_pci_aer_err_detected() is also
+	 * called with device_lock held.
+	 */
+
+	/* DATA_NONE/DATA_BOOL enables loopback testing */
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+		device_lock(&pdev->dev);
+		if (vdev->err_trigger)
+			eventfd_signal(vdev->err_trigger, 1);
+		device_unlock(&pdev->dev);
+		return 0;
+	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+		uint8_t trigger = *(uint8_t *)data;
+		device_lock(&pdev->dev);
+		if (trigger && vdev->err_trigger)
+			eventfd_signal(vdev->err_trigger, 1);
+		device_unlock(&pdev->dev);
+		return 0;
+	}
+
+	/* Handle SET_DATA_EVENTFD */
+
+	if (fd == -1) {
+		device_lock(&pdev->dev);
+		if (vdev->err_trigger)
+			eventfd_ctx_put(vdev->err_trigger);
+		vdev->err_trigger = NULL;
+		device_unlock(&pdev->dev);
+		return 0;
+	} else if (fd >= 0) {
+		struct eventfd_ctx *efdctx;
+		efdctx = eventfd_ctx_fdget(fd);
+		if (IS_ERR(efdctx))
+			return PTR_ERR(efdctx);
+		device_lock(&pdev->dev);
+		if (vdev->err_trigger)
+			eventfd_ctx_put(vdev->err_trigger);
+		vdev->err_trigger = efdctx;
+		device_unlock(&pdev->dev);
+		return 0;
+	} else
+		return -EINVAL;
+}
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data)
@@ -779,6 +836,13 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 			break;
 		}
 		break;
+	case VFIO_PCI_ERR_IRQ_INDEX:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			if (pci_is_pcie(vdev->pdev))
+				func = vfio_pci_set_err_trigger;
+			break;
+		}
 	}
 
 	if (!func)
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index d7e55d0..9c6d5d0 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -56,6 +56,7 @@ struct vfio_pci_device {
 	bool			has_vga;
 	struct pci_saved_state	*pci_saved_state;
 	atomic_t		refcnt;
+	struct eventfd_ctx	*err_trigger;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 4f41f30..284ff24 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -319,6 +319,7 @@ enum {
 	VFIO_PCI_INTX_IRQ_INDEX,
 	VFIO_PCI_MSI_IRQ_INDEX,
 	VFIO_PCI_MSIX_IRQ_INDEX,
+	VFIO_PCI_ERR_IRQ_INDEX,
 	VFIO_PCI_NUM_IRQS
 };
 
-- 
1.7.11.3

