Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaGJVwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:52:20 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44382 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaGJVwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:52:13 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 21/83] hsa/radeon: Add kgd-->kfd interfaces for suspend and resume
Date: Fri, 11 Jul 2014 00:50:21 +0300
Message-Id: <1405029027-6085-20-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two new interfaces to the kgd2kfd structure. Those
interfaces are for doing suspend and resume of a kfd device, when its
matching radeon device does suspend and resume.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/Makefile     |  2 +-
 drivers/gpu/hsa/radeon/kfd_module.c |  2 ++
 drivers/gpu/hsa/radeon/kfd_pm.c     | 43 +++++++++++++++++++++++++++++++++++++
 drivers/gpu/hsa/radeon/kfd_priv.h   |  4 ++++
 include/linux/radeon_kfd.h          |  2 ++
 5 files changed, 52 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/hsa/radeon/kfd_pm.c

diff --git a/drivers/gpu/hsa/radeon/Makefile b/drivers/gpu/hsa/radeon/Makefile
index 5422e6a..935f9b7 100644
--- a/drivers/gpu/hsa/radeon/Makefile
+++ b/drivers/gpu/hsa/radeon/Makefile
@@ -5,6 +5,6 @@
 radeon_kfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o \
 		kfd_pasid.o kfd_topology.o kfd_process.o \
 		kfd_doorbell.o kfd_sched_cik_static.o kfd_registers.o \
-		kfd_vidmem.o kfd_interrupt.o
+		kfd_vidmem.o kfd_interrupt.o kfd_pm.o
 
 obj-$(CONFIG_HSA_RADEON)	+= radeon_kfd.o
diff --git a/drivers/gpu/hsa/radeon/kfd_module.c b/drivers/gpu/hsa/radeon/kfd_module.c
index ad21c6d..a03743a 100644
--- a/drivers/gpu/hsa/radeon/kfd_module.c
+++ b/drivers/gpu/hsa/radeon/kfd_module.c
@@ -39,6 +39,8 @@ static const struct kgd2kfd_calls kgd2kfd = {
 	.device_init	= kgd2kfd_device_init,
 	.device_exit	= kgd2kfd_device_exit,
 	.interrupt	= kgd2kfd_interrupt,
+	.suspend	= kgd2kfd_suspend,
+	.resume		= kgd2kfd_resume,
 };
 
 bool kgd2kfd_init(unsigned interface_version,
diff --git a/drivers/gpu/hsa/radeon/kfd_pm.c b/drivers/gpu/hsa/radeon/kfd_pm.c
new file mode 100644
index 0000000..783311f
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_pm.c
@@ -0,0 +1,43 @@
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
+ *
+ * Author: Oded Gabbay
+ */
+
+#include <linux/device.h>
+#include "kfd_priv.h"
+#include "kfd_scheduler.h"
+
+void kgd2kfd_suspend(struct kfd_dev *kfd)
+{
+	BUG_ON(kfd == NULL);
+
+	kfd->device_info->scheduler_class->stop(kfd->scheduler);
+}
+
+int kgd2kfd_resume(struct kfd_dev *kfd)
+{
+	BUG_ON(kfd == NULL);
+
+	kfd->device_info->scheduler_class->start(kfd->scheduler);
+
+	return 0;
+}
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index 5b6611f..630d690 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -247,4 +247,8 @@ int radeon_kfd_interrupt_init(struct kfd_dev *dev);
 void radeon_kfd_interrupt_exit(struct kfd_dev *dev);
 void kgd2kfd_interrupt(struct kfd_dev *dev, const void *ih_ring_entry);
 
+/* Power Management */
+void kgd2kfd_suspend(struct kfd_dev *dev);
+int kgd2kfd_resume(struct kfd_dev *dev);
+
 #endif
diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
index 2f4f7c0..63b7bac 100644
--- a/include/linux/radeon_kfd.h
+++ b/include/linux/radeon_kfd.h
@@ -63,6 +63,8 @@ struct kgd2kfd_calls {
 	bool (*device_init)(struct kfd_dev *kfd, const struct kgd2kfd_shared_resources *gpu_resources);
 	void (*device_exit)(struct kfd_dev *kfd);
 	void (*interrupt)(struct kfd_dev *kfd, const void *ih_ring_entry);
+	void (*suspend)(struct kfd_dev *kfd);
+	int (*resume)(struct kfd_dev *kfd);
 };
 
 struct kfd2kgd_calls {
-- 
1.9.1

