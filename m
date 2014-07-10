Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaGJWIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:08:17 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64203 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaGJVzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:18 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 38/83] hsa/radeon: Workaround for a bug in amd_iommu
Date: Fri, 11 Jul 2014 00:53:54 +0300
Message-Id: <1405029279-6894-10-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a workaround for a bug in amd_iommu driver, where the driver
doesn't save all necessary information when going to suspend.
The workaround removes a device from the IOMMU device list on suspend and register a resumed device in the IOMMU device list.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/Makefile     |  2 +-
 drivers/gpu/hsa/radeon/kfd_device.c | 30 ++++++++++++++++++++++++++
 drivers/gpu/hsa/radeon/kfd_pasid.c  |  5 +++++
 drivers/gpu/hsa/radeon/kfd_pm.c     | 43 -------------------------------------
 drivers/gpu/hsa/radeon/kfd_priv.h   |  1 +
 5 files changed, 37 insertions(+), 44 deletions(-)
 delete mode 100644 drivers/gpu/hsa/radeon/kfd_pm.c

diff --git a/drivers/gpu/hsa/radeon/Makefile b/drivers/gpu/hsa/radeon/Makefile
index 935f9b7..5422e6a 100644
--- a/drivers/gpu/hsa/radeon/Makefile
+++ b/drivers/gpu/hsa/radeon/Makefile
@@ -5,6 +5,6 @@
 radeon_kfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o \
 		kfd_pasid.o kfd_topology.o kfd_process.o \
 		kfd_doorbell.o kfd_sched_cik_static.o kfd_registers.o \
-		kfd_vidmem.o kfd_interrupt.o kfd_pm.o
+		kfd_vidmem.o kfd_interrupt.o
 
 obj-$(CONFIG_HSA_RADEON)	+= radeon_kfd.o
diff --git a/drivers/gpu/hsa/radeon/kfd_device.c b/drivers/gpu/hsa/radeon/kfd_device.c
index a21c095..2e7d50d 100644
--- a/drivers/gpu/hsa/radeon/kfd_device.c
+++ b/drivers/gpu/hsa/radeon/kfd_device.c
@@ -188,3 +188,33 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd)
 
 	kfree(kfd);
 }
+
+void kgd2kfd_suspend(struct kfd_dev *kfd)
+{
+	BUG_ON(kfd == NULL);
+
+	if (kfd->init_complete) {
+		kfd->device_info->scheduler_class->stop(kfd->scheduler);
+		amd_iommu_free_device(kfd->pdev);
+	}
+}
+
+int kgd2kfd_resume(struct kfd_dev *kfd)
+{
+	pasid_t pasid_limit;
+	int err;
+
+	BUG_ON(kfd == NULL);
+
+	pasid_limit = radeon_kfd_get_pasid_limit();
+
+	if (kfd->init_complete) {
+		err = amd_iommu_init_device(kfd->pdev, pasid_limit);
+		if (err < 0)
+			return -ENXIO;
+		amd_iommu_set_invalidate_ctx_cb(kfd->pdev, iommu_pasid_shutdown_callback);
+		kfd->device_info->scheduler_class->start(kfd->scheduler);
+	}
+
+	return 0;
+}
diff --git a/drivers/gpu/hsa/radeon/kfd_pasid.c b/drivers/gpu/hsa/radeon/kfd_pasid.c
index d78bd00..8bd1562 100644
--- a/drivers/gpu/hsa/radeon/kfd_pasid.c
+++ b/drivers/gpu/hsa/radeon/kfd_pasid.c
@@ -68,6 +68,11 @@ bool radeon_kfd_set_pasid_limit(pasid_t new_limit)
 	return true;
 }
 
+inline pasid_t radeon_kfd_get_pasid_limit(void)
+{
+	return pasid_limit;
+}
+
 pasid_t radeon_kfd_pasid_alloc(void)
 {
 	pasid_t found;
diff --git a/drivers/gpu/hsa/radeon/kfd_pm.c b/drivers/gpu/hsa/radeon/kfd_pm.c
deleted file mode 100644
index 783311f..0000000
--- a/drivers/gpu/hsa/radeon/kfd_pm.c
+++ /dev/null
@@ -1,43 +0,0 @@
-/*
- * Copyright 2014 Advanced Micro Devices, Inc.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
- * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
- * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
- * OTHER DEALINGS IN THE SOFTWARE.
- *
- * Author: Oded Gabbay
- */
-
-#include <linux/device.h>
-#include "kfd_priv.h"
-#include "kfd_scheduler.h"
-
-void kgd2kfd_suspend(struct kfd_dev *kfd)
-{
-	BUG_ON(kfd == NULL);
-
-	kfd->device_info->scheduler_class->stop(kfd->scheduler);
-}
-
-int kgd2kfd_resume(struct kfd_dev *kfd)
-{
-	BUG_ON(kfd == NULL);
-
-	kfd->device_info->scheduler_class->start(kfd->scheduler);
-
-	return 0;
-}
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index bca9cce..8b877ca 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -213,6 +213,7 @@ struct kfd_queue *radeon_kfd_get_queue(struct kfd_process *p, unsigned int queue
 int radeon_kfd_pasid_init(void);
 void radeon_kfd_pasid_exit(void);
 bool radeon_kfd_set_pasid_limit(pasid_t new_limit);
+pasid_t radeon_kfd_get_pasid_limit(void);
 pasid_t radeon_kfd_pasid_alloc(void);
 void radeon_kfd_pasid_free(pasid_t pasid);
 
-- 
1.9.1

