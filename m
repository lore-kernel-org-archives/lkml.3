Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934158Ab3CHNsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:48:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11397 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127Ab3CHNsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:48:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 08 Mar 2013 05:42:13 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv6 8/9] gpu: host1x: drm: Add CMA ops for host1x driver
Date: Fri, 8 Mar 2013 15:47:00 +0200
Message-ID: <1362750421-18080-9-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362750421-18080-1-git-send-email-tbergstrom@nvidia.com>
References: <1362750421-18080-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arto Merilainen <amerilainen@nvidia.com>

This patch adds CMA memory operations for host1x driver. This allows
usage of CMA buffers inside host1x driver.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Makefile  |    1 +
 drivers/gpu/host1x/drm/cma.c |   87 ++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/host1x/drm/cma.h |   26 +++++++++++++
 3 files changed, 114 insertions(+)
 create mode 100644 drivers/gpu/host1x/drm/cma.c
 create mode 100644 drivers/gpu/host1x/drm/cma.h

diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index ad39fef..d1d7e35 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -16,4 +16,5 @@ ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 
 host1x-$(CONFIG_DRM_TEGRA) += drm/drm.o drm/fb.o drm/dc.o
 host1x-$(CONFIG_DRM_TEGRA) += drm/output.o drm/rgb.o drm/hdmi.o
+host1x-$(CONFIG_DRM_TEGRA) += drm/cma.o
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/drm/cma.c b/drivers/gpu/host1x/drm/cma.c
new file mode 100644
index 0000000..1c5d000
--- /dev/null
+++ b/drivers/gpu/host1x/drm/cma.c
@@ -0,0 +1,87 @@
+/*
+ * Tegra host1x CMA support
+ *
+ * Copyright (c) 2012-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_gem_cma_helper.h>
+#include <linux/mutex.h>
+
+#include "memmgr.h"
+
+static void cma_put(void *handle_data)
+{
+	struct drm_gem_cma_object *obj = handle_data;
+	struct drm_device *drm = obj->base.dev;
+
+	mutex_lock(&drm->struct_mutex);
+	drm_gem_object_unreference(&obj->base);
+	mutex_unlock(&drm->struct_mutex);
+}
+
+static dma_addr_t cma_pin(void *handle_data, struct sg_table **sgt)
+{
+	struct drm_gem_cma_object *obj = handle_data;
+	return obj->paddr;
+}
+
+static void cma_unpin(void *handle_data, struct sg_table *sgt)
+{
+}
+
+static void *cma_mmap(void *handle_data)
+{
+	struct drm_gem_cma_object *obj = handle_data;
+	return obj->vaddr;
+}
+
+static void cma_munmap(void *handle_data, void *addr)
+{
+}
+
+static void *cma_kmap(void *handle_data, unsigned int pagenum)
+{
+	struct drm_gem_cma_object *obj = handle_data;
+	return obj->vaddr + pagenum * PAGE_SIZE;
+}
+
+static void cma_kunmap(void *handle_data, unsigned int pagenum, void *addr)
+{
+}
+
+static struct host1x_mem_handle *cma_get(void *handle_data)
+{
+	struct drm_gem_cma_object *obj = handle_data;
+	struct drm_device *drm = obj->base.dev;
+
+	mutex_lock(&drm->struct_mutex);
+	drm_gem_object_reference(&obj->base);
+	mutex_unlock(&drm->struct_mutex);
+
+	return obj->base.driver_private;
+}
+
+const struct host1x_mem_op host1x_cma_ops = {
+	.get = cma_get,
+	.put = cma_put,
+	.pin = cma_pin,
+	.unpin = cma_unpin,
+	.mmap = cma_mmap,
+	.munmap = cma_munmap,
+	.kmap = cma_kmap,
+	.kunmap = cma_kunmap,
+};
diff --git a/drivers/gpu/host1x/drm/cma.h b/drivers/gpu/host1x/drm/cma.h
new file mode 100644
index 0000000..06aa0ba
--- /dev/null
+++ b/drivers/gpu/host1x/drm/cma.h
@@ -0,0 +1,26 @@
+/*
+ * Tegra host1x cma memory manager
+ *
+ * Copyright (c) 2012-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __HOST1X_CMA_H
+#define __HOST1X_CMA_H
+
+#include "memmgr.h"
+
+extern const struct host1x_mem_op host1x_cma_ops;
+
+#endif
-- 
1.7.9.5

