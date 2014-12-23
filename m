Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaLWKke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:40:34 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18053 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbaLWKk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:40:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Dec 2014 02:38:45 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: thierry.reding@gmail.com, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com
CC: nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH nouveau 08/11] instmem: add dummy support for GK20A
Date: Tue, 23 Dec 2014 18:40:01 +0800
Message-ID: <1419331204-26679-9-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a workaround to avoid the instmem backup/restore during the suspend
and resume process in nv50 instemem driver.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
 drm/Kbuild                    |  1 +
 nvkm/engine/device/nve0.c     |  2 +-
 nvkm/include/subdev/instmem.h |  1 +
 nvkm/subdev/instmem/gk20a.c   | 70 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 73 insertions(+), 1 deletion(-)
 create mode 100644 nvkm/subdev/instmem/gk20a.c

diff --git a/drm/Kbuild b/drm/Kbuild
index 6461e3565afe..ea40cd653c7c 100644
--- a/drm/Kbuild
+++ b/drm/Kbuild
@@ -176,6 +176,7 @@ nouveau-y += core/subdev/instmem/base.o
 nouveau-y += core/subdev/instmem/nv04.o
 nouveau-y += core/subdev/instmem/nv40.o
 nouveau-y += core/subdev/instmem/nv50.o
+nouveau-y += core/subdev/instmem/gk20a.o
 nouveau-y += core/subdev/ltc/base.o
 nouveau-y += core/subdev/ltc/gf100.o
 nouveau-y += core/subdev/ltc/gk104.o
diff --git a/nvkm/engine/device/nve0.c b/nvkm/engine/device/nve0.c
index 732922690653..fcbdc5259c7c 100644
--- a/nvkm/engine/device/nve0.c
+++ b/nvkm/engine/device/nve0.c
@@ -170,7 +170,7 @@ nve0_identify(struct nouveau_device *device)
 		device->oclass[NVDEV_SUBDEV_FB     ] =  gk20a_fb_oclass;
 		device->oclass[NVDEV_SUBDEV_LTC    ] =  gk104_ltc_oclass;
 		device->oclass[NVDEV_SUBDEV_IBUS   ] = &gk20a_ibus_oclass;
-		device->oclass[NVDEV_SUBDEV_INSTMEM] = nv50_instmem_oclass;
+		device->oclass[NVDEV_SUBDEV_INSTMEM] = gk20a_instmem_oclass;
 		device->oclass[NVDEV_SUBDEV_VM     ] = &nvc0_vmmgr_oclass;
 		device->oclass[NVDEV_SUBDEV_BAR    ] = &gk20a_bar_oclass;
 		device->oclass[NVDEV_ENGINE_DMAOBJ ] =  nvd0_dmaeng_oclass;
diff --git a/nvkm/include/subdev/instmem.h b/nvkm/include/subdev/instmem.h
index c1df26f3230c..6264660bedce 100644
--- a/nvkm/include/subdev/instmem.h
+++ b/nvkm/include/subdev/instmem.h
@@ -48,5 +48,6 @@ nouveau_instmem(void *obj)
 extern struct nouveau_oclass *nv04_instmem_oclass;
 extern struct nouveau_oclass *nv40_instmem_oclass;
 extern struct nouveau_oclass *nv50_instmem_oclass;
+extern struct nouveau_oclass *gk20a_instmem_oclass;
 
 #endif
diff --git a/nvkm/subdev/instmem/gk20a.c b/nvkm/subdev/instmem/gk20a.c
new file mode 100644
index 000000000000..5e072d6e743f
--- /dev/null
+++ b/nvkm/subdev/instmem/gk20a.c
@@ -0,0 +1,70 @@
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
+ *
+ */
+
+#include "nv50.h"
+#include "priv.h"
+
+static int
+gk20a_instmem_fini(struct nouveau_object *object, bool suspend)
+{
+	struct nouveau_instmem *imem = (void *)object;
+
+	return nouveau_subdev_fini(&imem->base, suspend);
+}
+
+static int
+gk20a_instmem_init(struct nouveau_object *object)
+{
+	struct nouveau_instmem *imem = (void *)object;
+
+	return nouveau_subdev_init(&imem->base);
+}
+
+static int
+gk20a_instmem_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
+		  struct nouveau_oclass *oclass, void *data, u32 size,
+		  struct nouveau_object **pobject)
+{
+	struct nv50_instmem_priv *priv;
+	int ret;
+
+	ret = nouveau_instmem_create(parent, engine, oclass, &priv);
+	*pobject = nv_object(priv);
+	if (ret)
+		return ret;
+
+	spin_lock_init(&priv->lock);
+	return 0;
+}
+
+struct nouveau_oclass *
+gk20a_instmem_oclass = &(struct nouveau_instmem_impl) {
+	.base.handle = NV_SUBDEV(INSTMEM, 0x50),
+	.base.ofuncs = &(struct nouveau_ofuncs) {
+		.ctor = gk20a_instmem_ctor,
+		.dtor = _nouveau_instmem_dtor,
+		.init = gk20a_instmem_init,
+		.fini = gk20a_instmem_fini,
+	},
+	.instobj = &nv50_instobj_oclass.base,
+}.base;
-- 
1.9.1

