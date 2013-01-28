Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab3A1Jz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:55:26 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:18345 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab3A1JzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:55:15 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] QEMU-AER: Qemu changes to support AER for VFIO-PCI
 devices
Thread-Topic: [PATCH v2 3/3] QEMU-AER: Qemu changes to support AER for
 VFIO-PCI devices
Thread-Index: AQHN/T2ESeM5ph2BDEKiycwqYtLNug==
Date: Mon, 28 Jan 2013 09:54:52 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C9014A7BDF@G9W0717.americas.hpqcorp.net>
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


	- Create eventfd per vfio device assigned to a guest and register an
          event handler

	- This fd is passed to the vfio_pci driver through the SET_IRQ ioctl

	- When the device encounters an error, the eventfd is signalled
          and the qemu eventfd handler gets invoked.

	- In the handler decide what action to take. Current action taken
          is to terminate the guest.

Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 hw/vfio_pci.c              | 106 +++++++++++++++++++++++++++++++++++++++++++++
 linux-headers/linux/vfio.h |   3 ++
 2 files changed, 109 insertions(+)

diff --git a/hw/vfio_pci.c b/hw/vfio_pci.c
index c51ae67..c4a6aec 100644
--- a/hw/vfio_pci.c
+++ b/hw/vfio_pci.c
@@ -130,6 +130,8 @@ typedef struct VFIODevice {
     QLIST_ENTRY(VFIODevice) next;
     struct VFIOGroup *group;
     bool reset_works;
+    bool pci_aer_notify_cap;
+    EventNotifier err_notifier;
 } VFIODevice;
 
 typedef struct VFIOGroup {
@@ -1837,6 +1839,10 @@ static int vfio_get_device(VFIOGroup *group, const char *name, VFIODevice *vdev)
         error_report("Warning, device %s does not support reset\n", name);
     }
 
+    vdev->pci_aer_notify_cap = !!(dev_info.flags &
+                                    (VFIO_DEVICE_FLAGS_PCI_AER |
+                                    VFIO_DEVICE_FLAGS_PCI_AER_NOTIFY));
+
     if (dev_info.num_regions < VFIO_PCI_CONFIG_REGION_INDEX + 1) {
         error_report("vfio: unexpected number of io regions %u\n",
                      dev_info.num_regions);
@@ -1922,6 +1928,103 @@ static void vfio_put_device(VFIODevice *vdev)
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
+    if (!(vdev->pci_aer_notify_cap)) {
+        DPRINTF("vfio: Error notification not supported for the device\n");
+        return;
+    }
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
+        error_report("vfio: Warning: Failed to setup error fd: %d\n", ret);
+        qemu_set_fd_handler(*pfd, NULL, NULL, vdev);
+        event_notifier_cleanup(&vdev->err_notifier);
+    }
+    g_free(irq_set);
+    return;
+}
+static void vfio_unregister_err_notifier(VFIODevice *vdev)
+{
+    int argsz;
+    struct vfio_irq_set *irq_set;
+    int32_t *pfd;
+    int ret;
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
@@ -2032,6 +2135,8 @@ static int vfio_initfn(PCIDevice *pdev)
         }
     }
 
+    vfio_register_err_notifier(vdev);
+
     return 0;
 
 out_teardown:
@@ -2049,6 +2154,7 @@ static void vfio_exitfn(PCIDevice *pdev)
     VFIODevice *vdev = DO_UPCAST(VFIODevice, pdev, pdev);
     VFIOGroup *group = vdev->group;
 
+    vfio_unregister_err_notifier(vdev);
     pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
     vfio_disable_interrupts(vdev);
     if (vdev->intx.mmap_timer) {
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index f787b72..ed87792 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -147,6 +147,8 @@ struct vfio_device_info {
 	__u32	flags;
 #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
+#define VFIO_DEVICE_FLAGS_PCI_AER (1 << 2)      /* AER capable */
+#define VFIO_DEVICE_FLAGS_PCI_AER_NOTIFY (1 << 3)   /* Supports aer notify */
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

