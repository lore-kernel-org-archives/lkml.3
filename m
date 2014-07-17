Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaGQNfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:35:54 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:2999
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932880AbaGQNdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:33:52 -0400
X-WSS-ID: 0N8UYZY-08-70J-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "Oded Gabbay" <oded.gabbay@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Subject: [PATCH v2 20/25] amdkfd: Add interrupt handling module
Date: Thu, 17 Jul 2014 16:29:27 +0300
Message-ID: <1405603773-32688-21-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(95666004)(88136002)(77982001)(48376002)(62966002)(83322001)(97736001)(80022001)(76482001)(89996001)(87286001)(85306003)(85852003)(74502001)(36756003)(74662001)(77096002)(50226001)(4396001)(101416001)(93916002)(21056001)(20776003)(19580395003)(92566001)(92726001)(31966008)(46102001)(107046002)(79102001)(44976005)(229853001)(106466001)(68736004)(50466002)(81542001)(102836001)(84676001)(81342001)(19580405001)(99396002)(50986999)(105586002)(47776003)(76176999)(64706001)(104166001)(83072002)(33646002)(77156001)(86362001)(87936001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB035;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lewycky <Andrew.Lewycky@amd.com>

This patch adds the interrupt handling module, in kfd_interrupt.c, and its related members in different data structures to the amdkfd driver.

The amdkfd interrupt module maintains an internal interrupt ring per amdkfd device. The internal interrupt ring contains interrupts that needs further handling. The extra handling is deferred to a later time through a workqueue.

There's no acknowledgment for the interrupts we use. The hardware simply queues a new interrupt each time without waiting.

The fixed-size internal queue means that it's possible for us to lose interrupts because we have no back-pressure to the hardware.

Signed-off-by: Andrew Lewycky <Andrew.Lewycky@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/Makefile        |   3 +-
 drivers/gpu/drm/radeon/amdkfd/kfd_device.c    |  16 ++-
 drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c | 161 ++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h      |  18 ++-
 4 files changed, 193 insertions(+), 5 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_interrupt.c

diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
index 44639f2..e634681 100644
--- a/drivers/gpu/drm/radeon/amdkfd/Makefile
+++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
@@ -8,6 +8,7 @@ amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
 		kfd_pasid.o kfd_doorbell.o kfd_vidmem.o kfd_aperture.o \
 		kfd_process.o kfd_queue.o kfd_mqd_manager.o \
 		kfd_kernel_queue.o kfd_packet_manager.o \
-		kfd_process_queue_manager.o kfd_device_queue_manager.o
+		kfd_process_queue_manager.o kfd_device_queue_manager.o \
+		kfd_interrupt.o
 
 obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
index f5e9f39..6a7a8b2 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
@@ -29,6 +29,7 @@
 
 static const struct kfd_device_info kaveri_device_info = {
 	.max_pasid_bits = 16,
+	.ih_ring_entry_size = 4 * sizeof(uint32_t)
 };
 
 struct kfd_deviceid {
@@ -156,6 +157,9 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 
 	kfd_doorbell_init(kfd);
 
+	if (kfd_interrupt_init(kfd))
+		return false;
+
 	if (!device_iommu_pasid_init(kfd))
 		return false;
 
@@ -195,6 +199,8 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd)
 
 	BUG_ON(err != 0);
 
+	kfd_interrupt_exit(kfd);
+
 	if (kfd->init_complete) {
 		device_queue_manager_uninit(kfd->dqm);
 		amd_iommu_free_device(kfd->pdev);
@@ -233,6 +239,14 @@ int kgd2kfd_resume(struct kfd_dev *kfd)
 	return 0;
 }
 
-void kgd2kfd_interrupt(struct kfd_dev *dev, const void *ih_ring_entry)
+/* This is called directly from KGD at ISR. */
+void kgd2kfd_interrupt(struct kfd_dev *kfd, const void *ih_ring_entry)
 {
+	spin_lock(&kfd->interrupt_lock);
+
+	if (kfd->interrupts_active
+	    && enqueue_ih_ring_entry(kfd, ih_ring_entry))
+		schedule_work(&kfd->interrupt_work);
+
+	spin_unlock(&kfd->interrupt_lock);
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
index 9815ead..8a1de68 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -120,6 +120,15 @@ struct kfd_dev {
 
 	struct kgd2kfd_shared_resources shared_resources;
 
+	/* Interrupts of interest to KFD are copied from the HW ring into a SW ring. */
+	bool interrupts_active;
+	void *interrupt_ring;
+	size_t interrupt_ring_size;
+	atomic_t interrupt_ring_rptr;
+	atomic_t interrupt_ring_wptr;
+	struct work_struct interrupt_work;
+	spinlock_t interrupt_lock;
+
 	/* QCM Device instance */
 	struct device_queue_manager *dqm;
 };
@@ -373,11 +382,14 @@ struct kfd_dev *kfd_device_by_pci_dev(const struct pci_dev *pdev);
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

