Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaGJWNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:13:43 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42157 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaGJVuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:50:51 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 04/83] drm/radeon: Add radeon <--> kfd interface
Date: Fri, 11 Jul 2014 00:50:04 +0300
Message-Id: <1405029027-6085-3-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the interface between the radeon driver and the kfd
driver. The interface implementation is contained in
radeon_kfd.c and radeon_kfd.h.

The interface itself is represented by a pointer to struct
kfd_dev. The pointer is located inside radeon_device structure.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/Makefile     |  1 +
 drivers/gpu/drm/radeon/radeon.h     |  3 ++
 drivers/gpu/drm/radeon/radeon_kfd.c | 94 +++++++++++++++++++++++++++++++++++++
 include/linux/radeon_kfd.h          | 67 ++++++++++++++++++++++++++
 4 files changed, 165 insertions(+)
 create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.c
 create mode 100644 include/linux/radeon_kfd.h

diff --git a/drivers/gpu/drm/radeon/Makefile b/drivers/gpu/drm/radeon/Makefile
index 1b04002..a1c913d 100644
--- a/drivers/gpu/drm/radeon/Makefile
+++ b/drivers/gpu/drm/radeon/Makefile
@@ -104,6 +104,7 @@ radeon-y += \
 	radeon_vce.o \
 	vce_v1_0.o \
 	vce_v2_0.o \
+	radeon_kfd.o
 
 radeon-$(CONFIG_COMPAT) += radeon_ioc32.o
 radeon-$(CONFIG_VGA_SWITCHEROO) += radeon_atpx_handler.o
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 4e7e41f..90f66bb 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -2340,6 +2340,9 @@ struct radeon_device {
 
 	struct dev_pm_domain vga_pm_domain;
 	bool have_disp_power_ref;
+
+	/* HSA KFD interface */
+	struct kfd_dev		*kfd;
 };
 
 bool radeon_is_px(struct drm_device *dev);
diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
new file mode 100644
index 0000000..7c7f808
--- /dev/null
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -0,0 +1,94 @@
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
+#include <linux/module.h>
+#include <linux/radeon_kfd.h>
+#include <drm/drmP.h>
+#include "radeon.h"
+
+static const struct kfd2kgd_calls kfd2kgd = {
+};
+
+static const struct kgd2kfd_calls *kgd2kfd;
+
+bool radeon_kfd_init(void)
+{
+	bool (*kgd2kfd_init_p)(unsigned, const struct kfd2kgd_calls*,
+				const struct kgd2kfd_calls**);
+
+	kgd2kfd_init_p = symbol_request(kgd2kfd_init);
+
+	if (kgd2kfd_init_p == NULL)
+		return false;
+
+	if (!kgd2kfd_init_p(KFD_INTERFACE_VERSION, &kfd2kgd, &kgd2kfd)) {
+		symbol_put(kgd2kfd_init);
+		kgd2kfd = NULL;
+
+		return false;
+	}
+
+	return true;
+}
+
+void radeon_kfd_fini(void)
+{
+	if (kgd2kfd) {
+		kgd2kfd->exit();
+		symbol_put(kgd2kfd_init);
+	}
+}
+
+void radeon_kfd_device_probe(struct radeon_device *rdev)
+{
+	if (kgd2kfd)
+		rdev->kfd = kgd2kfd->probe((struct kgd_dev *)rdev, rdev->pdev);
+}
+
+void radeon_kfd_device_init(struct radeon_device *rdev)
+{
+	if (rdev->kfd) {
+		struct kgd2kfd_shared_resources gpu_resources = {
+			.mmio_registers = rdev->rmmio,
+
+			.compute_vmid_bitmap = 0xFF00,
+
+			.first_compute_pipe = 1,
+			.compute_pipe_count = 8 - 1,
+		};
+
+		radeon_doorbell_get_kfd_info(rdev,
+				&gpu_resources.doorbell_physical_address,
+				&gpu_resources.doorbell_aperture_size,
+				&gpu_resources.doorbell_start_offset);
+
+		kgd2kfd->device_init(rdev->kfd, &gpu_resources);
+	}
+}
+
+void radeon_kfd_device_fini(struct radeon_device *rdev)
+{
+	if (rdev->kfd) {
+		kgd2kfd->device_exit(rdev->kfd);
+		rdev->kfd = NULL;
+	}
+}
diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
new file mode 100644
index 0000000..59785e9
--- /dev/null
+++ b/include/linux/radeon_kfd.h
@@ -0,0 +1,67 @@
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
+ * radeon_kfd.h defines the private interface between the
+ * AMD kernel graphics drivers and the AMD radeon KFD.
+ */
+
+#ifndef RADEON_KFD_H_INCLUDED
+#define RADEON_KFD_H_INCLUDED
+
+#include <linux/types.h>
+struct pci_dev;
+
+#define KFD_INTERFACE_VERSION 1
+
+struct kfd_dev;
+struct kgd_dev;
+
+struct kgd2kfd_shared_resources {
+	void __iomem *mmio_registers; /* Mapped pointer to GFX MMIO registers. */
+
+	unsigned int compute_vmid_bitmap; /* Bit n == 1 means VMID n is available for KFD. */
+
+	unsigned int first_compute_pipe; /* Compute pipes are counted starting from MEC0/pipe0 as 0. */
+	unsigned int compute_pipe_count; /* Number of MEC pipes available for KFD. */
+
+	phys_addr_t doorbell_physical_address; /* Base address of doorbell aperture. */
+	size_t doorbell_aperture_size; /* Size in bytes of doorbell aperture. */
+	size_t doorbell_start_offset; /* Number of bytes at start of aperture reserved for KGD. */
+};
+
+struct kgd2kfd_calls {
+	void (*exit)(void);
+	struct kfd_dev* (*probe)(struct kgd_dev *kgd, struct pci_dev *pdev);
+	bool (*device_init)(struct kfd_dev *kfd, const struct kgd2kfd_shared_resources *gpu_resources);
+	void (*device_exit)(struct kfd_dev *kfd);
+};
+
+struct kfd2kgd_calls {
+};
+
+bool kgd2kfd_init(unsigned interface_version,
+		  const struct kfd2kgd_calls *f2g,
+		  const struct kgd2kfd_calls **g2f);
+
+#endif
+
-- 
1.9.1

