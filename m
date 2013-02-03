Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3BCOVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:21:08 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55725 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3BCOVB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:21:01 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/3] QEMU-AER: Qemu changes to support AER for VFIO-PCI
 devices
Thread-Topic: [PATCH v3 3/3] QEMU-AER: Qemu changes to support AER for
 VFIO-PCI devices
Thread-Index: AQHOAhg4taf68fRLz0WTtmu8HI0G/g==
Date: Sun, 3 Feb 2013 14:10:29 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C9014AAF07@G9W0717.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.27]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	- Create eventfd per vfio device assigned to a guest and register an
          event handler

	- This fd is passed to the vfio_pci driver through the SET_IRQ ioctl

	- When the device encounters an error, the eventfd is signalled
          and the qemu eventfd handler gets invoked.

	- In the handler decide what action to take. Current action taken
          is to terminate the guest.

Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 hw/vfio_pci.c              | 105 +++++++++++++++++++++++++++++++++++++++++++++
 linux-headers/linux/vfio.h |   1 +
 2 files changed, 106 insertions(+)

diff --git a/hw/vfio_pci.c b/hw/vfio_pci.c
index c51ae67..4e2f768 100644
--- a/hw/vfio_pci.c
+++ b/hw/vfio_pci.c
@@ -130,6 +130,8 @@ typedef struct VFIODevice {
     QLIST_ENTRY(VFIODevice) next;
     struct VFIOGroup *group;
     bool reset_works;
+    EventNotifier err_notifier;
+    bool pci_aer;
 } VFIODevice;
 
 typedef struct VFIOGroup {
@@ -1922,6 +1924,106 @@ static void vfio_put_device(VFIODevice *vdev)
     }
 }
 
+static void vfio_err_notifier_handler(void *opaque)
+{
+    VFIODevice *vdev = opaque;
+
+    if (!event_notifier_test_and_clear(&vdev->err_notifier)) {
+        return;
+    }
+
+    /*
+     * TBD. Retrieve the error details and decide what action
+     * needs to be taken. One of the actions could be to pass
+     * the error to the guest and have the guest driver recover
+     * from the error. This requires that PCIe capabilities be
+     * exposed to the guest. At present, we just terminate the
+     * guest to contain the error.
+     */
+
+    error_report("%s (%04x:%02x:%02x.%x)"
+        "Unrecoverable error detected... Terminating guest\n",
+        __func__, vdev->host.domain, vdev->host.bus,
+        vdev->host.slot, vdev->host.function);
+
+    hw_error("(%04x:%02x:%02x.%x) Unrecoverable device error\n",
+        vdev->host.domain, vdev->host.bus,
+        vdev->host.slot, vdev->host.function);
+
+    return;
+}
+
+static void vfio_register_err_notifier(VFIODevice *vdev)
+{
+    int ret;
+    int argsz;
+    struct vfio_irq_set *irq_set;
+    int32_t *pfd;
+
+    if (event_notifier_init(&vdev->err_notifier, 0)) {
+        error_report("vfio: Warning: Unable to init event notifier for error detection\n");
+        return;
+    }
+
+    argsz = sizeof(*irq_set) + sizeof(*pfd);
+
+    irq_set = g_malloc0(argsz);
+    irq_set->argsz = argsz;
+    irq_set->flags = VFIO_IRQ_SET_DATA_EVENTFD |
+                     VFIO_IRQ_SET_ACTION_TRIGGER;
+    irq_set->index = VFIO_PCI_ERR_IRQ_INDEX;
+    irq_set->start = 0;
+    irq_set->count = 1;
+    pfd = (int32_t *)&irq_set->data;
+
+    *pfd = event_notifier_get_fd(&vdev->err_notifier);
+    qemu_set_fd_handler(*pfd, vfio_err_notifier_handler, NULL, vdev);
+
+    ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, irq_set);
+    if (ret) {
+        DPRINTF("vfio: Error notification not supported for the device\n");
+        qemu_set_fd_handler(*pfd, NULL, NULL, vdev);
+        event_notifier_cleanup(&vdev->err_notifier);
+        g_free(irq_set);
+        return;
+    }
+    g_free(irq_set);
+    vdev->pci_aer = 1;
+    return;
+}
+static void vfio_unregister_err_notifier(VFIODevice *vdev)
+{
+    int argsz;
+    struct vfio_irq_set *irq_set;
+    int32_t *pfd;
+    int ret;
+
+    if (!vdev->pci_aer) {
+        return;
+    }
+
+    argsz = sizeof(*irq_set) + sizeof(*pfd);
+
+    irq_set = g_malloc0(argsz);
+    irq_set->argsz = argsz;
+    irq_set->flags = VFIO_IRQ_SET_DATA_EVENTFD |
+                     VFIO_IRQ_SET_ACTION_TRIGGER;
+    irq_set->index = VFIO_PCI_ERR_IRQ_INDEX;
+    irq_set->start = 0;
+    irq_set->count = 1;
+    pfd = (int32_t *)&irq_set->data;
+    *pfd = -1;
+
+    ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, irq_set);
+    if (ret) {
+        DPRINTF("vfio: Failed to de-assign error fd: %d\n", ret);
+    }
+    g_free(irq_set);
+    qemu_set_fd_handler(event_notifier_get_fd(&vdev->err_notifier),
+                        NULL, NULL, vdev);
+    event_notifier_cleanup(&vdev->err_notifier);
+    return;
+}
 static int vfio_initfn(PCIDevice *pdev)
 {
     VFIODevice *pvdev, *vdev = DO_UPCAST(VFIODevice, pdev, pdev);
@@ -2032,6 +2134,8 @@ static int vfio_initfn(PCIDevice *pdev)
         }
     }
 
+    vfio_register_err_notifier(vdev);
+
     return 0;
 
 out_teardown:
@@ -2049,6 +2153,7 @@ static void vfio_exitfn(PCIDevice *pdev)
     VFIODevice *vdev = DO_UPCAST(VFIODevice, pdev, pdev);
     VFIOGroup *group = vdev->group;
 
+    vfio_unregister_err_notifier(vdev);
     pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
     vfio_disable_interrupts(vdev);
     if (vdev->intx.mmap_timer) {
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index f787b72..6b20849 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -310,6 +310,7 @@ enum {
 	VFIO_PCI_INTX_IRQ_INDEX,
 	VFIO_PCI_MSI_IRQ_INDEX,
 	VFIO_PCI_MSIX_IRQ_INDEX,
+	VFIO_PCI_ERR_IRQ_INDEX,
 	VFIO_PCI_NUM_IRQS
 };
 
-- 
1.7.11.3

