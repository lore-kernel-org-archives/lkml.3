Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab3CMMf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 08:35:58 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4280 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007Ab3CMMfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 08:35:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 13 Mar 2013 05:29:13 -0700
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv7 09/10] gpu: host1x: drm: Add CMA ops for host1x driver
Date: Wed, 13 Mar 2013 14:36:25 +0200
Message-ID: <1363178186-2017-10-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com>
References: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arto Merilainen <amerilainen@nvidia.com>

This patch implements a CMA memory handler for the host1x driver.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Makefile  |    1 +
 drivers/gpu/host1x/drm/cma.c |   93 ++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/host1x/drm/cma.h |   35 ++++++++++++++++
 3 files changed, 129 insertions(+)
 create mode 100644 drivers/gpu/host1x/drm/cma.c
 create mode 100644 drivers/gpu/host1x/drm/cma.h

diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index 9a6fc76..e85db5a 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -15,4 +15,5 @@ ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 
 host1x-$(CONFIG_DRM_TEGRA) += drm/drm.o drm/fb.o drm/dc.o
 host1x-$(CONFIG_DRM_TEGRA) += drm/output.o drm/rgb.o drm/hdmi.o
+host1x-$(CONFIG_DRM_TEGRA) += drm/cma.o
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/drm/cma.c b/drivers/gpu/host1x/drm/cma.c
new file mode 100644
index 0000000..cf86fce
--- /dev/null
+++ b/drivers/gpu/host1x/drm/cma.c
@@ -0,0 +1,93 @@
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
+#include "cma.h"
+#include "host1x_bo.h"
+
+static void cma_put(struct host1x_bo *bo)
+{
+	struct tegra_drm_bo *cma_bo =
+		container_of(bo, struct tegra_drm_bo, base);
+	struct drm_device *drm = cma_bo->cma_obj.base.dev;
+
+	mutex_lock(&drm->struct_mutex);
+	drm_gem_object_unreference(&cma_bo->cma_obj.base);
+	mutex_unlock(&drm->struct_mutex);
+}
+
+static dma_addr_t cma_pin(struct host1x_bo *bo, struct sg_table **sgt)
+{
+	struct tegra_drm_bo *cma_bo =
+		container_of(bo, struct tegra_drm_bo, base);
+	return cma_bo->cma_obj.paddr;
+}
+
+static void cma_unpin(struct host1x_bo *bo, struct sg_table *sgt)
+{
+}
+
+static void *cma_mmap(struct host1x_bo *bo)
+{
+	struct tegra_drm_bo *cma_bo =
+		container_of(bo, struct tegra_drm_bo, base);
+	return cma_bo->cma_obj.vaddr;
+}
+
+static void cma_munmap(struct host1x_bo *bo, void *addr)
+{
+}
+
+static void *cma_kmap(struct host1x_bo *bo, unsigned int pagenum)
+{
+	struct tegra_drm_bo *cma_bo =
+		container_of(bo, struct tegra_drm_bo, base);
+	return cma_bo->cma_obj.vaddr + pagenum * PAGE_SIZE;
+}
+
+static void cma_kunmap(struct host1x_bo *bo, unsigned int pagenum, void *addr)
+{
+}
+
+static struct host1x_bo *cma_get(struct host1x_bo *bo)
+{
+	struct tegra_drm_bo *cma_bo =
+		container_of(bo, struct tegra_drm_bo, base);
+	struct drm_device *drm = cma_bo->cma_obj.base.dev;
+
+	mutex_lock(&drm->struct_mutex);
+	drm_gem_object_reference(&cma_bo->cma_obj.base);
+	mutex_unlock(&drm->struct_mutex);
+
+	return bo;
+}
+
+const struct host1x_bo_ops tegra_drm_bo_ops = {
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
index 0000000..f35cebd
--- /dev/null
+++ b/drivers/gpu/host1x/drm/cma.h
@@ -0,0 +1,35 @@
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
+#include <drm/drm.h>
+#include <drm/drmP.h>
+#include <drm/drm_gem_cma_helper.h>
+
+#include "host1x_bo.h"
+
+struct tegra_drm_bo {
+	struct host1x_bo base;
+	struct drm_gem_cma_object cma_obj;
+};
+
+extern const struct host1x_bo_ops tegra_drm_bo_ops;
+
+#endif
-- 
1.7.9.5

