Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaGJWMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:12:34 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35624 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaGJVvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:51:22 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 10/83] hsa/radeon: Add initialization and unmapping of doorbell aperture
Date: Fri, 11 Jul 2014 00:50:10 +0300
Message-Id: <1405029027-6085-9-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds initialization of the doorbell aperture when
initializing a kfd device.

It also adds a call to unmap the doorbell when a process unbinds
from the kfd

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/Makefile       |  3 +-
 drivers/gpu/hsa/radeon/kfd_device.c   |  2 +
 drivers/gpu/hsa/radeon/kfd_doorbell.c | 72 +++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/hsa/radeon/kfd_doorbell.c

diff --git a/drivers/gpu/hsa/radeon/Makefile b/drivers/gpu/hsa/radeon/Makefile
index ba16a09..989518a 100644
--- a/drivers/gpu/hsa/radeon/Makefile
+++ b/drivers/gpu/hsa/radeon/Makefile
@@ -3,6 +3,7 @@
 #
 
 radeon_kfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o \
-		kfd_pasid.o kfd_topology.o kfd_process.o
+		kfd_pasid.o kfd_topology.o kfd_process.o \
+		kfd_doorbell.o
 
 obj-$(CONFIG_HSA_RADEON)	+= radeon_kfd.o
diff --git a/drivers/gpu/hsa/radeon/kfd_device.c b/drivers/gpu/hsa/radeon/kfd_device.c
index d122920..4e9fe6c 100644
--- a/drivers/gpu/hsa/radeon/kfd_device.c
+++ b/drivers/gpu/hsa/radeon/kfd_device.c
@@ -123,6 +123,8 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 
 	kfd->regs = gpu_resources->mmio_registers;
 
+	radeon_kfd_doorbell_init(kfd);
+
 	if (!device_iommu_pasid_init(kfd))
 		return false;
 
diff --git a/drivers/gpu/hsa/radeon/kfd_doorbell.c b/drivers/gpu/hsa/radeon/kfd_doorbell.c
new file mode 100644
index 0000000..79a9d4b
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_doorbell.c
@@ -0,0 +1,72 @@
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
+#include "kfd_priv.h"
+#include <linux/mm.h>
+#include <linux/mman.h>
+
+/*
+ * Each device exposes a doorbell aperture, a PCI MMIO aperture that
+ * receives 32-bit writes that are passed to queues as wptr values.
+ * The doorbells are intended to be written by applications as part
+ * of queueing work on user-mode queues.
+ * We assign doorbells to applications in PAGE_SIZE-sized and aligned chunks.
+ * We map the doorbell address space into user-mode when a process creates
+ * its first queue on each device.
+ * Although the mapping is done by KFD, it is equivalent to an mmap of
+ * the /dev/kfd with the particular device encoded in the mmap offset.
+ * There will be other uses for mmap of /dev/kfd, so only a range of
+ * offsets (KFD_MMAP_DOORBELL_START-END) is used for doorbells.
+ */
+
+/* # of doorbell bytes allocated for each process. */
+static inline size_t doorbell_process_allocation(void)
+{
+	return roundup(sizeof(doorbell_t) * MAX_PROCESS_QUEUES, PAGE_SIZE);
+}
+
+/* Doorbell calculations for device init. */
+void radeon_kfd_doorbell_init(struct kfd_dev *kfd)
+{
+	size_t doorbell_start_offset;
+	size_t doorbell_aperture_size;
+	size_t doorbell_process_limit;
+
+	/* We start with calculations in bytes because the input data might only be byte-aligned.
+	** Only after we have done the rounding can we assume any alignment. */
+
+	doorbell_start_offset = roundup(kfd->shared_resources.doorbell_start_offset,
+					doorbell_process_allocation());
+	doorbell_aperture_size = rounddown(kfd->shared_resources.doorbell_aperture_size,
+					doorbell_process_allocation());
+
+	if (doorbell_aperture_size > doorbell_start_offset)
+		doorbell_process_limit =
+			(doorbell_aperture_size - doorbell_start_offset) / doorbell_process_allocation();
+	else
+		doorbell_process_limit = 0;
+
+	kfd->doorbell_base = kfd->shared_resources.doorbell_physical_address + doorbell_start_offset;
+	kfd->doorbell_id_offset = doorbell_start_offset / sizeof(doorbell_t);
+	kfd->doorbell_process_limit = doorbell_process_limit;
+}
+
-- 
1.9.1

