Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118Ab3BNKmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:42:25 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:9134 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934017Ab3BNKmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:42:22 -0500
From: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
To: alex.williamson@redhat.com, gleb@redhat.com, bhelgaas@google.com,
        blauwirbel@gmail.com, lance.oritz@hp.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
Subject: [PATCH v4 3/3] QEMU-AER: Qemu changes to support AER for VFIO-PCI devices
Date: Thu, 14 Feb 2013 04:41:55 -0600
Message-Id: <1360838515-17558-4-git-send-email-vijaymohan.pandarathil@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360838515-17558-1-git-send-email-vijaymohan.pandarathil@hp.com>
References: <1360838515-17558-1-git-send-email-vijaymohan.pandarathil@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	- Create eventfd per vfio device assigned to a guest and register an
          event handler

	- This fd is passed to the vfio_pci driver through the SET_IRQ ioctl

	- When the device encounters an error, the eventfd is signalled
          and the qemu eventfd handler gets invoked.

	- In the handler decide what action to take. Current action taken
          is to stop the guest.

Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 hw/vfio_pci.c              | 112 +++++++++++++++++++++++++++++++++++++++++++++
 linux-headers/linux/vfio.h |   1 +
 2 files changed, 113 insertions(+)

diff --git a/hw/vfio_pci.c b/hw/vfio_pci.c
index c51ae67..05da53b 100644
--- a/hw/vfio_pci.c
+++ b/hw/vfio_pci.c
@@ -38,6 +38,7 @@
 #include "qemu/error-report.h"
 #include "qemu/queue.h"
 #include "qemu/range.h"
+#include "sysemu/sysemu.h"
 
 /* #define DEBUG_VFIO */
 #ifdef DEBUG_VFIO
@@ -129,7 +130,9 @@ typedef struct VFIODevice {
     PCIHostDeviceAddress host;
     QLIST_ENTRY(VFIODevice) next;
     struct VFIOGroup *group;
+    EventNotifier err_notifier;
     bool reset_works;
+    bool pci_aer;
 } VFIODevice;
 
 typedef struct VFIOGroup {
@@ -1802,6 +1805,7 @@ static int vfio_get_device(VFIOGroup *group, const char *name, VFIODevice *vdev)
 {
     struct vfio_device_info dev_info = { .argsz = sizeof(dev_info) };
     struct vfio_region_info reg_info = { .argsz = sizeof(reg_info) };
+    struct vfio_irq_info irq_info = { .argsz = sizeof(irq_info) };
     int ret, i;
 
     ret = ioctl(group->fd, VFIO_GROUP_GET_DEVICE_FD, name);
@@ -1901,6 +1905,15 @@ static int vfio_get_device(VFIOGroup *group, const char *name, VFIODevice *vdev)
     vdev->config_size = reg_info.size;
     vdev->config_offset = reg_info.offset;
 
+    irq_info.index = VFIO_PCI_ERR_IRQ_INDEX;
+
+    ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
+    if (ret) {
+        error_report("vfio: Error getting IRQ info: %m\n");
+        goto error;
+    }
+    if (irq_info.count == 1)
+        vdev->pci_aer = true;
 error:
     if (ret) {
         QLIST_REMOVE(vdev, next);
@@ -1922,6 +1935,102 @@ static void vfio_put_device(VFIODevice *vdev)
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
+     * exposed to the guest. For now, we just terminate the
+     * guest to contain the error.
+     */
+
+    error_report("%s (%04x:%02x:%02x.%x)"
+        "Unrecoverable error detected...\n"
+        "Please inestigate/collect any data required and then kill the quest",
+        __func__, vdev->host.domain, vdev->host.bus,
+        vdev->host.slot, vdev->host.function);
+
+    vm_stop(RUN_STATE_IO_ERROR);
+}
+
+static void vfio_register_err_notifier(VFIODevice *vdev)
+{
+    int ret;
+    int argsz;
+    struct vfio_irq_set *irq_set;
+    int32_t *pfd;
+
+    if (!vdev->pci_aer) {
+        return;
+    }
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
+        error_report("vfio: Failed to set up error notification\n");
+        qemu_set_fd_handler(*pfd, NULL, NULL, vdev);
+        event_notifier_cleanup(&vdev->err_notifier);
+    }
+    g_free(irq_set);
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
+        error_report("vfio: Failed to de-assign error fd: %d\n", ret);
+    }
+    g_free(irq_set);
+    qemu_set_fd_handler(event_notifier_get_fd(&vdev->err_notifier),
+                        NULL, NULL, vdev);
+    event_notifier_cleanup(&vdev->err_notifier);
+}
 static int vfio_initfn(PCIDevice *pdev)
 {
     VFIODevice *pvdev, *vdev = DO_UPCAST(VFIODevice, pdev, pdev);
@@ -2032,6 +2141,8 @@ static int vfio_initfn(PCIDevice *pdev)
         }
     }
 
+    vfio_register_err_notifier(vdev);
+
     return 0;
 
 out_teardown:
@@ -2049,6 +2160,7 @@ static void vfio_exitfn(PCIDevice *pdev)
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

