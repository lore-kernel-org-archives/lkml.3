Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaIXVJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:09:12 -0400
Received: from mail-by2on0141.outbound.protection.outlook.com ([207.46.100.141]:20448
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751989AbaIXVEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:04:12 -0400
X-WSS-ID: 0NCFB6Y-07-TAP-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 19/23] amdkfd: Add interrupt handling module
Date: Wed, 24 Sep 2014 23:45:33 +0300
Message-ID: <1411591537-31636-20-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(77156001)(92726001)(104166001)(107046002)(64706001)(86362001)(77982003)(20776003)(47776003)(81342003)(92566001)(93916002)(33646002)(46102003)(74502003)(74662003)(99396003)(68736004)(90102001)(229853001)(81542003)(79102003)(80022003)(62966002)(97736003)(85852003)(77096002)(50466002)(88136002)(95666004)(83072002)(89996001)(76176999)(50986999)(85306004)(48376002)(31966008)(101416001)(4396001)(10300001)(102836001)(50226001)(84676001)(83322001)(19580395003)(19580405001)(87286001)(36756003)(87936001)(76482002)(106466001)(120916001)(44976005)(105586002)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lewycky <Andrew.Lewycky@amd.com>

This patch adds the interrupt handling module, in kfd_interrupt.c, and its
related members in different data structures to the amdkfd driver.

The amdkfd interrupt module maintains an internal interrupt ring per amdkfd
device. The internal interrupt ring contains interrupts that needs further
handling. The extra handling is deferred to a later time through a workqueue.

There's no acknowledgment for the interrupts we use. The hardware simply queues
a new interrupt each time without waiting.

The fixed-size internal queue means that it's possible for us to lose
interrupts because we have no back-pressure to the hardware.

v3:

Change device init
Made sure spin lock is taken only if init is complete
Moved bool field to the end of the structure

Signed-off-by: Andrew Lewycky <Andrew.Lewycky@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/Makefile        |   3 +-
 drivers/gpu/drm/radeon/amdkfd/kfd_device.c    |  23 +++-
 drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c | 161 ++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h      |  18 ++-
 4 files changed, 200 insertions(+), 5 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c

diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
index e3099c8..91d5015 100644
--- a/drivers/gpu/drm/radeon/amdkfd/Makefile
+++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
@@ -8,6 +8,7 @@ amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
 		kfd_pasid.o kfd_doorbell.o kfd_aperture.o \
 		kfd_process.o kfd_queue.o kfd_mqd_manager.o \
 		kfd_kernel_queue.o kfd_packet_manager.o \
-		kfd_process_queue_manager.o kfd_device_queue_manager.o
+		kfd_process_queue_manager.o kfd_device_queue_manager.o \
+		kfd_interrupt.o
 
 obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
index 74575de..a364c1c 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
@@ -31,6 +31,7 @@
 
 static const struct kfd_device_info kaveri_device_info = {
 	.max_pasid_bits = 16,
+	.ih_ring_entry_size = 4 * sizeof(uint32_t)
 };
 
 struct kfd_deviceid {
@@ -187,6 +188,13 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 		goto kfd_topology_add_device_error;
 	}
 
+	if (kfd_interrupt_init(kfd)) {
+		dev_err(kfd_device,
+			"Error initializing interrupts for device (%x:%x)\n",
+			kfd->pdev->vendor, kfd->pdev->device);
+		goto kfd_interrupt_error;
+	}
+
 	if (!device_iommu_pasid_init(kfd)) {
 		dev_err(kfd_device,
 			"Error initializing iommuv2 for device (%x:%x)\n",
@@ -223,6 +231,8 @@ dqm_start_error:
 device_queue_manager_error:
 	amd_iommu_free_device(kfd->pdev);
 device_iommu_pasid_error:
+	kfd_interrupt_exit(kfd);
+kfd_interrupt_error:
 	kfd_topology_remove_device(kfd);
 kfd_topology_add_device_error:
 	kfd2kgd->fini_sa_manager(kfd->kgd);
@@ -238,6 +248,7 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd)
 	if (kfd->init_complete) {
 		device_queue_manager_uninit(kfd->dqm);
 		amd_iommu_free_device(kfd->pdev);
+		kfd_interrupt_exit(kfd);
 		kfd_topology_remove_device(kfd);
 	}
 
@@ -274,6 +285,16 @@ int kgd2kfd_resume(struct kfd_dev *kfd)
 	return 0;
 }
 
-void kgd2kfd_interrupt(struct kfd_dev *dev, const void *ih_ring_entry)
+/* This is called directly from KGD at ISR. */
+void kgd2kfd_interrupt(struct kfd_dev *kfd, const void *ih_ring_entry)
 {
+	if (kfd->init_complete) {
+		spin_lock(&kfd->interrupt_lock);
+
+		if (kfd->interrupts_active
+		    && enqueue_ih_ring_entry(kfd, ih_ring_entry))
+			schedule_work(&kfd->interrupt_work);
+
+		spin_unlock(&kfd->interrupt_lock);
+	}
 }
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c b/drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c
new file mode 100644
index 0000000..eed43a7
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c
@@ -0,0 +1,161 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+/*
+ * KFD Interrupts.
+ *
+ * AMD GPUs deliver interrupts by pushing an interrupt description onto the
+ * interrupt ring and then sending an interrupt. KGD receives the interrupt
+ * in ISR and sends us a pointer to each new entry on the interrupt ring.
+ *
+ * We generally can't process interrupt-signaled events from ISR, so we call
+ * out to each interrupt client module (currently only the scheduler) to ask if
+ * each interrupt is interesting. If they return true, then it requires further
+ * processing so we copy it to an internal interrupt ring and call each
+ * interrupt client again from a work-queue.
+ *
+ * There's no acknowledgment for the interrupts we use. The hardware simply
+ * queues a new interrupt each time without waiting.
+ *
+ * The fixed-size internal queue means that it's possible for us to lose
+ * interrupts because we have no back-pressure to the hardware.
+ */
+
+#include <linux/slab.h>
+#include <linux/device.h>
+#include "kfd_priv.h"
+
+#define KFD_INTERRUPT_RING_SIZE 256
+
+static void interrupt_wq(struct work_struct *);
+
+int kfd_interrupt_init(struct kfd_dev *kfd)
+{
+	void *interrupt_ring = kmalloc_array(KFD_INTERRUPT_RING_SIZE,
+					kfd->device_info->ih_ring_entry_size,
+					GFP_KERNEL);
+	if (!interrupt_ring)
+		return -ENOMEM;
+
+	kfd->interrupt_ring = interrupt_ring;
+	kfd->interrupt_ring_size =
+		KFD_INTERRUPT_RING_SIZE * kfd->device_info->ih_ring_entry_size;
+	atomic_set(&kfd->interrupt_ring_wptr, 0);
+	atomic_set(&kfd->interrupt_ring_rptr, 0);
+
+	spin_lock_init(&kfd->interrupt_lock);
+
+	INIT_WORK(&kfd->interrupt_work, interrupt_wq);
+
+	kfd->interrupts_active = true;
+
+	/*
+	 * After this function returns, the interrupt will be enabled. This
+	 * barrier ensures that the interrupt running on a different processor
+	 * sees all the above writes.
+	 */
+	smp_wmb();
+
+	return 0;
+}
+
+void kfd_interrupt_exit(struct kfd_dev *kfd)
+{
+	/*
+	 * Stop the interrupt handler from writing to the ring and scheduling
+	 * workqueue items. The spinlock ensures that any interrupt running
+	 * after we have unlocked sees interrupts_active = false.
+	 */
+	unsigned long flags;
+
+	spin_lock_irqsave(&kfd->interrupt_lock, flags);
+	kfd->interrupts_active = false;
+	spin_unlock_irqrestore(&kfd->interrupt_lock, flags);
+
+	/*
+	 * Flush_scheduled_work ensures that there are no outstanding work-queue
+	 * items that will access interrupt_ring. New work items can't be
+	 * created because we stopped interrupt handling above.
+	 */
+	flush_scheduled_work();
+
+	kfree(kfd->interrupt_ring);
+}
+
+/*
+ * This assumes that it can't be called concurrently with itself
+ * but only with dequeue_ih_ring_entry.
+ */
+bool enqueue_ih_ring_entry(struct kfd_dev *kfd,	const void *ih_ring_entry)
+{
+	unsigned int rptr = atomic_read(&kfd->interrupt_ring_rptr);
+	unsigned int wptr = atomic_read(&kfd->interrupt_ring_wptr);
+
+	if ((rptr - wptr) % kfd->interrupt_ring_size == kfd->device_info->ih_ring_entry_size) {
+		/* This is very bad, the system is likely to hang. */
+		dev_err_ratelimited(kfd_chardev(),
+			"Interrupt ring overflow, dropping interrupt.\n");
+		return false;
+	}
+
+	memcpy(kfd->interrupt_ring + wptr, ih_ring_entry, kfd->device_info->ih_ring_entry_size);
+	wptr = (wptr + kfd->device_info->ih_ring_entry_size) % kfd->interrupt_ring_size;
+	smp_wmb(); /* Ensure memcpy'd data is visible before wptr update. */
+	atomic_set(&kfd->interrupt_ring_wptr, wptr);
+
+	return true;
+}
+
+/*
+ * This assumes that it can't be called concurrently with itself
+ * but only with enqueue_ih_ring_entry.
+ */
+static bool dequeue_ih_ring_entry(struct kfd_dev *kfd, void *ih_ring_entry)
+{
+	/*
+	 * Assume that wait queues have an implicit barrier, i.e. anything that
+	 * happened in the ISR before it queued work is visible.
+	 */
+
+	unsigned int wptr = atomic_read(&kfd->interrupt_ring_wptr);
+	unsigned int rptr = atomic_read(&kfd->interrupt_ring_rptr);
+
+	if (rptr == wptr)
+		return false;
+
+	memcpy(ih_ring_entry, kfd->interrupt_ring + rptr, kfd->device_info->ih_ring_entry_size);
+	rptr = (rptr + kfd->device_info->ih_ring_entry_size) % kfd->interrupt_ring_size;
+	smp_mb(); /* Ensure the rptr write update is not visible until memcpy has finished reading. */
+	atomic_set(&kfd->interrupt_ring_rptr, rptr);
+
+	return true;
+}
+
+static void interrupt_wq(struct work_struct *work)
+{
+	struct kfd_dev *dev = container_of(work, struct kfd_dev, interrupt_work);
+
+	uint32_t ih_ring_entry[DIV_ROUND_UP(dev->device_info->ih_ring_entry_size, sizeof(uint32_t))];
+
+	while (dequeue_ih_ring_entry(dev, ih_ring_entry))
+		;
+}
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 75214a1..6c656d8 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -126,10 +126,19 @@ struct kfd_dev {
 
 	struct kgd2kfd_shared_resources shared_resources;
 
+	void *interrupt_ring;
+	size_t interrupt_ring_size;
+	atomic_t interrupt_ring_rptr;
+	atomic_t interrupt_ring_wptr;
+	struct work_struct interrupt_work;
+	spinlock_t interrupt_lock;
+
 	/* QCM Device instance */
 	struct device_queue_manager *dqm;
 
 	bool init_complete;
+	/* Interrupts of interest to KFD are copied from the HW ring into a SW ring. */
+	bool interrupts_active;
 };
 
 /* KGD2KFD callbacks */
@@ -468,11 +477,14 @@ struct kfd_dev *kfd_device_by_pci_dev(const struct pci_dev *pdev);
 struct kfd_dev *kfd_topology_enum_kfd_devices(uint8_t idx);
 
 /* Interrupts */
-void kgd2kfd_interrupt(struct kfd_dev *dev, const void *ih_ring_entry);
+int kfd_interrupt_init(struct kfd_dev *dev);
+void kfd_interrupt_exit(struct kfd_dev *dev);
+void kgd2kfd_interrupt(struct kfd_dev *kfd, const void *ih_ring_entry);
+bool enqueue_ih_ring_entry(struct kfd_dev *kfd,	const void *ih_ring_entry);
 
 /* Power Management */
-void kgd2kfd_suspend(struct kfd_dev *dev);
-int kgd2kfd_resume(struct kfd_dev *dev);
+void kgd2kfd_suspend(struct kfd_dev *kfd);
+int kgd2kfd_resume(struct kfd_dev *kfd);
 
 /* amdkfd Apertures */
 int kfd_init_apertures(struct kfd_process *process);
-- 
1.9.1

