Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaF0K3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 06:29:38 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11833 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaF0K3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:29:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 27 Jun 2014 03:19:36 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/2] drm/gk20a: add BAR instance
Date: Fri, 27 Jun 2014 19:28:51 +0900
Message-ID: <1403864931-4663-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403864931-4663-1-git-send-email-acourbot@nvidia.com>
References: <1403864931-4663-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GK20A's BAR is functionally identical to NVC0's, but do not support
being ioremapped write-combined. Create a BAR instance for GK20A that
reflect that state.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/Makefile                  |  1 +
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c |  2 +-
 drivers/gpu/drm/nouveau/core/include/subdev/bar.h |  1 +
 drivers/gpu/drm/nouveau/core/subdev/bar/gk20a.c   | 54 +++++++++++++++++++++++
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c    |  6 +--
 drivers/gpu/drm/nouveau/core/subdev/bar/priv.h    |  6 +++
 6 files changed, 66 insertions(+), 4 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/bar/gk20a.c

diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
index 8b307e143632..11d9561d67c1 100644
--- a/drivers/gpu/drm/nouveau/Makefile
+++ b/drivers/gpu/drm/nouveau/Makefile
@@ -26,6 +26,7 @@ nouveau-y += core/core/subdev.o
 nouveau-y += core/subdev/bar/base.o
 nouveau-y += core/subdev/bar/nv50.o
 nouveau-y += core/subdev/bar/nvc0.o
+nouveau-y += core/subdev/bar/gk20a.o
 nouveau-y += core/subdev/bios/base.o
 nouveau-y += core/subdev/bios/bit.o
 nouveau-y += core/subdev/bios/boost.o
diff --git a/drivers/gpu/drm/nouveau/core/engine/device/nve0.c b/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
index 2d1e97d4264f..a2b9ccc48f66 100644
--- a/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
@@ -165,7 +165,7 @@ nve0_identify(struct nouveau_device *device)
 		device->oclass[NVDEV_SUBDEV_IBUS   ] = &gk20a_ibus_oclass;
 		device->oclass[NVDEV_SUBDEV_INSTMEM] = nv50_instmem_oclass;
 		device->oclass[NVDEV_SUBDEV_VM     ] = &nvc0_vmmgr_oclass;
-		device->oclass[NVDEV_SUBDEV_BAR    ] = &nvc0_bar_oclass;
+		device->oclass[NVDEV_SUBDEV_BAR    ] = &gk20a_bar_oclass;
 		device->oclass[NVDEV_ENGINE_DMAOBJ ] = &nvd0_dmaeng_oclass;
 		device->oclass[NVDEV_ENGINE_FIFO   ] =  gk20a_fifo_oclass;
 		device->oclass[NVDEV_ENGINE_SW     ] =  nvc0_software_oclass;
diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/bar.h b/drivers/gpu/drm/nouveau/core/include/subdev/bar.h
index 9002cbb6432b..be037fac534c 100644
--- a/drivers/gpu/drm/nouveau/core/include/subdev/bar.h
+++ b/drivers/gpu/drm/nouveau/core/include/subdev/bar.h
@@ -33,5 +33,6 @@ nouveau_bar(void *obj)
 
 extern struct nouveau_oclass nv50_bar_oclass;
 extern struct nouveau_oclass nvc0_bar_oclass;
+extern struct nouveau_oclass gk20a_bar_oclass;
 
 #endif
diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/gk20a.c b/drivers/gpu/drm/nouveau/core/subdev/bar/gk20a.c
new file mode 100644
index 000000000000..cc7c3db211d1
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/gk20a.c
@@ -0,0 +1,54 @@
+/*
+ * Copyright (c) 2014, NVIDIA CORPORATION. All rights reserved.
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
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
+#include <subdev/bar.h>
+
+#include "priv.h"
+
+int
+gk20a_bar_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
+	       struct nouveau_oclass *oclass, void *data, u32 size,
+	       struct nouveau_object **pobject)
+{
+	struct nouveau_bar *bar;
+	int ret;
+
+	ret = nvc0_bar_ctor(parent, engine, oclass, data, size, pobject);
+	if (ret)
+		return ret;
+
+	bar = *pobject;
+	bar->iomap_uncached = true;
+
+	return 0;
+}
+
+struct nouveau_oclass
+gk20a_bar_oclass = {
+	.handle = NV_SUBDEV(BAR, 0xea),
+	.ofuncs = &(struct nouveau_ofuncs) {
+		.ctor = gk20a_bar_ctor,
+		.dtor = nvc0_bar_dtor,
+		.init = nvc0_bar_init,
+		.fini = _nouveau_bar_fini,
+	},
+};
diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c b/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
index ca8139b9ab27..0a44459844e3 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
@@ -133,7 +133,7 @@ nvc0_bar_init_vm(struct nvc0_bar_priv *priv, struct nvc0_bar_priv_vm *bar_vm,
 	return 0;
 }
 
-static int
+int
 nvc0_bar_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	      struct nouveau_oclass *oclass, void *data, u32 size,
 	      struct nouveau_object **pobject)
@@ -169,7 +169,7 @@ nvc0_bar_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	return 0;
 }
 
-static void
+void
 nvc0_bar_dtor(struct nouveau_object *object)
 {
 	struct nvc0_bar_priv *priv = (void *)object;
@@ -188,7 +188,7 @@ nvc0_bar_dtor(struct nouveau_object *object)
 	nouveau_bar_destroy(&priv->base);
 }
 
-static int
+int
 nvc0_bar_init(struct nouveau_object *object)
 {
 	struct nvc0_bar_priv *priv = (void *)object;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/priv.h b/drivers/gpu/drm/nouveau/core/subdev/bar/priv.h
index ffad8f337ead..3ee8b1476d00 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bar/priv.h
+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/priv.h
@@ -23,4 +23,10 @@ int  nouveau_bar_alloc(struct nouveau_bar *, struct nouveau_object *,
 
 void nv84_bar_flush(struct nouveau_bar *);
 
+int nvc0_bar_ctor(struct nouveau_object *, struct nouveau_object *,
+		  struct nouveau_oclass *, void *, u32,
+		  struct nouveau_object **);
+void nvc0_bar_dtor(struct nouveau_object *);
+int nvc0_bar_init(struct nouveau_object *);
+
 #endif
-- 
2.0.0

