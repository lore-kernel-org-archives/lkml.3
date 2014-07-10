Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaGJVz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:55:58 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:42735 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbaGJVzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:53 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 47/83] hsa/radeon: Add support allocating kernel doorbells
Date: Fri, 11 Jul 2014 00:54:03 +0300
Message-Id: <1405029279-6894-19-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

This patch adds infrastructure to allocate doorbells which are not exposed to
user space.

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_doorbell.c | 76 ++++++++++++++++++++++++++++++++++-
 drivers/gpu/hsa/radeon/kfd_priv.h     |  5 +++
 2 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_doorbell.c b/drivers/gpu/hsa/radeon/kfd_doorbell.c
index 3de8a02..abf4cb0 100644
--- a/drivers/gpu/hsa/radeon/kfd_doorbell.c
+++ b/drivers/gpu/hsa/radeon/kfd_doorbell.c
@@ -23,6 +23,16 @@
 #include "kfd_priv.h"
 #include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/slab.h>
+
+/*
+ * This extension supports a kernel level doorbells management for the kernel queues
+ * basically the last doorbells page is devoted to kernel queues and that's assures
+ * that any user process won't get access to the kernel doorbells page
+ */
+static DEFINE_MUTEX(doorbell_mutex);
+static unsigned long doorbell_available_index[DIV_ROUND_UP(MAX_PROCESS_QUEUES, BITS_PER_LONG)] = { 0 };
+#define KERNEL_DOORBELL_PASID 1
 
 /*
  * Each device exposes a doorbell aperture, a PCI MMIO aperture that
@@ -67,7 +77,22 @@ void radeon_kfd_doorbell_init(struct kfd_dev *kfd)
 
 	kfd->doorbell_base = kfd->shared_resources.doorbell_physical_address + doorbell_start_offset;
 	kfd->doorbell_id_offset = doorbell_start_offset / sizeof(doorbell_t);
-	kfd->doorbell_process_limit = doorbell_process_limit;
+	kfd->doorbell_process_limit = doorbell_process_limit - 1;
+
+	kfd->doorbell_kernel_ptr = ioremap(kfd->doorbell_base, doorbell_process_allocation());
+	BUG_ON(!kfd->doorbell_kernel_ptr);
+
+	pr_debug("kfd: doorbell initialization\n"
+				 "     doorbell base           == 0x%08lX\n"
+				 "     doorbell_id_offset      == 0x%08lu\n"
+				 "     doorbell_process_limit  == 0x%08lu\n"
+				 "     doorbell_kernel_offset  == 0x%08lX\n"
+				 "     doorbell aperture size  == 0x%08lX\n"
+				 "     doorbell kernel address == 0x%08lX\n",
+				 (uintptr_t)kfd->doorbell_base, kfd->doorbell_id_offset, doorbell_process_limit,
+				 (uintptr_t)kfd->doorbell_base, kfd->shared_resources.doorbell_aperture_size,
+				 (uintptr_t)kfd->doorbell_kernel_ptr);
+
 }
 
 /* This is the /dev/kfd mmap (for doorbell) implementation. We intend that this is only called through map_doorbells,
@@ -136,6 +161,53 @@ map_doorbells(struct file *devkfd, struct kfd_process *process, struct kfd_dev *
 	return 0;
 }
 
+/* get kernel iomem pointer for a doorbell */
+u32 __iomem *radeon_kfd_get_kernel_doorbell(struct kfd_dev *kfd, unsigned int *doorbell_off)
+{
+	u32 inx;
+
+	BUG_ON(!kfd || !doorbell_off);
+
+	mutex_lock(&doorbell_mutex);
+	inx = find_first_zero_bit(doorbell_available_index, MAX_PROCESS_QUEUES);
+	__set_bit(inx, doorbell_available_index);
+	mutex_unlock(&doorbell_mutex);
+
+	if (inx >= MAX_PROCESS_QUEUES)
+		return NULL;
+
+	/* caluculating the kernel doorbell offset using "faked" kernel pasid that allocated for kernel queues only */
+	*doorbell_off = KERNEL_DOORBELL_PASID * (doorbell_process_allocation()/sizeof(doorbell_t)) + inx;
+
+	pr_debug("kfd: get kernel queue doorbell\n"
+			 "     doorbell offset   == 0x%08d\n"
+			 "     kernel address    == 0x%08lX\n",
+			 *doorbell_off, (uintptr_t)(kfd->doorbell_kernel_ptr + inx));
+
+	return kfd->doorbell_kernel_ptr + inx;
+}
+
+void radeon_kfd_release_kernel_doorbell(struct kfd_dev *kfd, u32 __iomem *db_addr)
+{
+	unsigned int inx;
+
+	BUG_ON(!kfd || !db_addr);
+
+	inx = (unsigned int)(db_addr - kfd->doorbell_kernel_ptr);
+
+	mutex_lock(&doorbell_mutex);
+	__clear_bit(inx, doorbell_available_index);
+	mutex_unlock(&doorbell_mutex);
+}
+
+inline void write_kernel_doorbell(u32 __iomem *db, u32 value)
+{
+	if (db) {
+		writel(value, db);
+		pr_debug("writing %d to doorbell address 0x%p\n", value, db);
+	}
+}
+
 /* Get the user-mode address of a doorbell. Assumes that the process mutex is being held. */
 doorbell_t __user *radeon_kfd_get_doorbell(struct file *devkfd, struct kfd_process *process, struct kfd_dev *dev,
 					   unsigned int doorbell_index)
@@ -152,6 +224,8 @@ doorbell_t __user *radeon_kfd_get_doorbell(struct file *devkfd, struct kfd_proce
 	pdd = radeon_kfd_get_process_device_data(dev, process);
 	BUG_ON(pdd == NULL); /* map_doorbells would have failed otherwise */
 
+	pr_debug("doorbell value on creation 0x%x\n", pdd->doorbell_mapping[doorbell_index]);
+
 	return &pdd->doorbell_mapping[doorbell_index];
 }
 
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index 14a3f9b..df17387 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -95,6 +95,7 @@ struct kfd_dev {
 					 * at the start)
 					 */
 	size_t doorbell_process_limit;	/* Number of processes we have doorbell space for. */
+	u32 __iomem *doorbell_kernel_ptr; /* this is a pointer for a doorbells page used by kernel queue */
 
 	struct kgd2kfd_shared_resources shared_resources;
 
@@ -288,6 +289,10 @@ void radeon_kfd_doorbell_init(struct kfd_dev *kfd);
 int radeon_kfd_doorbell_mmap(struct kfd_process *process, struct vm_area_struct *vma);
 doorbell_t __user *radeon_kfd_get_doorbell(struct file *devkfd, struct kfd_process *process, struct kfd_dev *dev,
 					   unsigned int doorbell_index);
+u32 __iomem *radeon_kfd_get_kernel_doorbell(struct kfd_dev *kfd, unsigned int *doorbell_off);
+void radeon_kfd_release_kernel_doorbell(struct kfd_dev *kfd, u32 __iomem *db_addr);
+u32 read_kernel_doorbell(u32 __iomem *db);
+void write_kernel_doorbell(u32 __iomem *db, u32 value);
 unsigned int radeon_kfd_queue_id_to_doorbell(struct kfd_dev *kfd, struct kfd_process *process, unsigned int queue_id);
 
 extern struct device *kfd_device;
-- 
1.9.1

