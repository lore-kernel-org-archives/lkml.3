Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3A1JzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:55:14 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:18249 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab3A1JzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:55:01 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] VFIO-AER: Vfio-pci driver changes for supporting AER
Thread-Topic: [PATCH v2 2/3] VFIO-AER: Vfio-pci driver changes for
 supporting AER
Thread-Index: AQHN/T1+qYIBUNlwYUCiACwQmlK3Dg==
Date: Mon, 28 Jan 2013 09:54:42 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C9014A7BDA@G9W0717.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
	- New VFIO_SET_IRQ ioctl option to pass the eventfd that is signalled when
          an error occurs in the vfio_pci_device

	- Register pci_error_handler for the vfio_pci driver

	- When the device encounters an error, the error handler registered by
          the vfio_pci driver gets invoked by the AER infrastructure

	- In the error handler, signal the eventfd registered for the device.

	- This results in the qemu eventfd handler getting invoked and
          appropriate action taken for the guest.

Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 drivers/vfio/pci/vfio_pci.c         | 44 ++++++++++++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_intrs.c   | 32 +++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 include/uapi/linux/vfio.h           |  3 +++
 4 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index b28e66c..ff2a078 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -196,7 +196,9 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 
 			return (flags & PCI_MSIX_FLAGS_QSIZE) + 1;
 		}
-	}
+	} else if (irq_type == VFIO_PCI_ERR_IRQ_INDEX)
+		if (pci_is_pcie(vdev->pdev))
+			return 1;
 
 	return 0;
 }
@@ -223,9 +225,18 @@ static long vfio_pci_ioctl(void *device_data,
 		if (vdev->reset_works)
 			info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
+		if (pci_is_pcie(vdev->pdev)) {
+			info.flags |= VFIO_DEVICE_FLAGS_PCI_AER;
+			info.flags |= VFIO_DEVICE_FLAGS_PCI_AER_NOTIFY;
+		}
+
 		info.num_regions = VFIO_PCI_NUM_REGIONS;
 		info.num_irqs = VFIO_PCI_NUM_IRQS;
 
+		/* Expose only implemented IRQs */
+		if (!(info.flags & VFIO_DEVICE_FLAGS_PCI_AER_NOTIFY))
+			info.num_irqs--;
+
 		return copy_to_user((void __user *)arg, &info, minsz);
 
 	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
@@ -302,6 +313,10 @@ static long vfio_pci_ioctl(void *device_data,
 		if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
 			return -EINVAL;
 
+		if ((info.index == VFIO_PCI_ERR_IRQ_INDEX) &&
+		     !pci_is_pcie(vdev->pdev))
+			return -EINVAL;
+
 		info.flags = VFIO_IRQ_INFO_EVENTFD;
 
 		info.count = vfio_pci_get_irq_count(vdev, info.index);
@@ -538,11 +553,38 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	kfree(vdev);
 }
 
+static pci_ers_result_t vfio_err_detected(struct pci_dev *pdev,
+				pci_channel_state_t state)
+{
+	struct vfio_pci_device *vpdev;
+	void *vdev;
+
+	vdev = vfio_device_get_from_dev(&pdev->dev);
+	if (vdev == NULL)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	vpdev = vfio_device_data(vdev);
+	if (vpdev == NULL)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	if (vpdev->err_trigger)
+		eventfd_signal(vpdev->err_trigger, 1);
+
+	vfio_device_put_vdev(vdev);
+
+	return PCI_ERS_RESULT_CAN_RECOVER;
+}
+
+static const struct pci_error_handlers vfio_err_handlers = {
+	.error_detected = vfio_err_detected,
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
index 3639371..f003e08 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -745,6 +745,31 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_device *vdev,
 	return 0;
 }
 
+static int vfio_pci_set_err_eventfd(struct vfio_pci_device *vdev,
+				    unsigned index, unsigned start,
+				    unsigned count, uint32_t flags, void *data)
+{
+	if ((index == VFIO_PCI_ERR_IRQ_INDEX) &&
+	    (flags & VFIO_IRQ_SET_DATA_EVENTFD)   &&
+	    pci_is_pcie(vdev->pdev)) {
+
+		int32_t fd = *(int32_t *)data;
+
+		if (fd == -1) {
+			if (vdev->err_trigger)
+				eventfd_ctx_put(vdev->err_trigger);
+			vdev->err_trigger = NULL;
+			return 0;
+		} else if (fd >= 0) {
+			vdev->err_trigger = eventfd_ctx_fdget(fd);
+			if (IS_ERR(vdev->err_trigger))
+				return PTR_ERR(vdev->err_trigger);
+			return 0;
+		} else
+			return -EINVAL;
+	}
+	return -EINVAL;
+}
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data)
@@ -779,6 +804,13 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 			break;
 		}
 		break;
+	case VFIO_PCI_ERR_IRQ_INDEX:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			if (pci_is_pcie(vdev->pdev))
+				func = vfio_pci_set_err_eventfd;
+			break;
+		}
 	}
 
 	if (!func)
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 611827c..daee62f 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -55,6 +55,7 @@ struct vfio_pci_device {
 	bool			bardirty;
 	struct pci_saved_state	*pci_saved_state;
 	atomic_t		refcnt;
+	struct eventfd_ctx	*err_trigger;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 4758d1b..e81eb4d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -147,6 +147,8 @@ struct vfio_device_info {
 	__u32	flags;
 #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
+#define VFIO_DEVICE_FLAGS_PCI_AER	(1 << 2) /* AER capable */
+#define VFIO_DEVICE_FLAGS_PCI_AER_NOTIFY (1 << 3) /* Supports aer notify */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
@@ -310,6 +312,7 @@ enum {
 	VFIO_PCI_INTX_IRQ_INDEX,
 	VFIO_PCI_MSI_IRQ_INDEX,
 	VFIO_PCI_MSIX_IRQ_INDEX,
+	VFIO_PCI_ERR_IRQ_INDEX,
 	VFIO_PCI_NUM_IRQS
 };
 
-- 
1.7.11.3

