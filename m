Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaCXIrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:47:41 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11539 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaCXIqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:46:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 24 Mar 2014 01:42:24 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 10/12] drm/nouveau/graph: add GK20A support
Date: Mon, 24 Mar 2014 17:42:32 +0900
Message-ID: <1395650554-31925-11-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a GR device for GK20A based on NVE4, with the correct classes
definitions (GK20A's 3D class is 0xa297).

Most of the NVE4 code can be used on GK20A, so make relevant bits of
NVE4 available to other chips as well.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/Makefile                   |  1 +
 .../gpu/drm/nouveau/core/engine/graph/ctxnve4.c    |  4 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |  9 +++
 drivers/gpu/drm/nouveau/core/engine/graph/nve4.c   |  2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvea.c   | 75 ++++++++++++++++++++++
 .../gpu/drm/nouveau/core/include/engine/graph.h    |  1 +
 6 files changed, 89 insertions(+), 3 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nvea.c

diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
index 708d2e33835f..032a4744f843 100644
--- a/drivers/gpu/drm/nouveau/Makefile
+++ b/drivers/gpu/drm/nouveau/Makefile
@@ -270,6 +270,7 @@ nouveau-y += core/engine/graph/nvc8.o
 nouveau-y += core/engine/graph/nvd7.o
 nouveau-y += core/engine/graph/nvd9.o
 nouveau-y += core/engine/graph/nve4.o
+nouveau-y += core/engine/graph/nvea.o
 nouveau-y += core/engine/graph/nvf0.o
 nouveau-y += core/engine/graph/nv108.o
 nouveau-y += core/engine/mpeg/nv31.o
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/ctxnve4.c b/drivers/gpu/drm/nouveau/core/engine/graph/ctxnve4.c
index e2de73ee5eee..3904073f860d 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/ctxnve4.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/ctxnve4.c
@@ -804,7 +804,7 @@ nve4_grctx_init_unk[] = {
 	{}
 };
 
-static void
+void
 nve4_grctx_generate_mods(struct nvc0_graph_priv *priv, struct nvc0_grctx *info)
 {
 	u32 magic[GPC_MAX][2];
@@ -962,7 +962,7 @@ nve4_grctx_generate_main(struct nvc0_graph_priv *priv, struct nvc0_grctx *info)
 	nv_mask(priv, 0x41be10, 0x00800000, 0x00800000);
 }
 
-static struct nvc0_graph_init *
+struct nvc0_graph_init *
 nve4_grctx_init_hub[] = {
 	nvc0_grctx_init_base,
 	nve4_grctx_init_unk40xx,
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h
index b0ab6de270b2..904f09b540c5 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h
@@ -221,6 +221,8 @@ void nvc0_grctx_generate_r418bb8(struct nvc0_graph_priv *);
 void nve4_grctx_generate_r418bb8(struct nvc0_graph_priv *);
 void nvc0_grctx_generate_r406800(struct nvc0_graph_priv *);
 
+void nve4_grctx_generate_mods(struct nvc0_graph_priv *, struct nvc0_grctx *);
+
 extern struct nouveau_oclass *nvc0_grctx_oclass;
 extern struct nvc0_graph_init *nvc0_grctx_init_hub[];
 extern struct nvc0_graph_init nvc0_grctx_init_base[];
@@ -237,12 +239,17 @@ extern struct nvc0_graph_init nvc0_grctx_init_gpc_1[];
 extern struct nvc0_graph_init nvc0_grctx_init_tpc[];
 extern struct nvc0_graph_init nvc0_grctx_init_icmd[];
 extern struct nvc0_graph_init nvd9_grctx_init_icmd[]; //
+extern struct nvc0_graph_init nve4_grctx_init_icmd[];
+
+extern struct nvc0_graph_init *nve4_grctx_init_hub[];
+extern struct nvc0_graph_init *nve4_grctx_init_gpc[];
 
 extern struct nvc0_graph_mthd nvc0_grctx_init_mthd[];
 extern struct nvc0_graph_init nvc0_grctx_init_902d[];
 extern struct nvc0_graph_init nvc0_grctx_init_9039[];
 extern struct nvc0_graph_init nvc0_grctx_init_90c0[];
 extern struct nvc0_graph_init nvc0_grctx_init_mthd_magic[];
+extern struct nvc0_graph_init nve4_grctx_init_a097[];
 
 void nvc1_grctx_generate_mods(struct nvc0_graph_priv *, struct nvc0_grctx *);
 void nvc1_grctx_generate_unkn(struct nvc0_graph_priv *);
@@ -277,6 +284,8 @@ extern struct nvc0_graph_init nvf0_grctx_init_unk60xx[];
 
 extern struct nouveau_oclass *nv108_grctx_oclass;
 
+extern struct nvc0_graph_init *nve4_graph_init_mmio[];
+
 #define mmio_data(s,a,p) do {                                                  \
 	info->buffer[info->buffer_nr] = round_up(info->addr, (a));             \
 	info->addr = info->buffer[info->buffer_nr++] + (s);                    \
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nve4.c b/drivers/gpu/drm/nouveau/core/engine/graph/nve4.c
index 05ec09c88517..442857c5c120 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nve4.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nve4.c
@@ -298,7 +298,7 @@ nve4_graph_init(struct nouveau_object *object)
 	return nvc0_graph_init_ctxctl(priv);
 }
 
-static struct nvc0_graph_init *
+struct nvc0_graph_init *
 nve4_graph_init_mmio[] = {
 	nve4_graph_init_regs,
 	nvc0_graph_init_unk40xx,
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvea.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvea.c
new file mode 100644
index 000000000000..d5e6a1adcacb
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvea.c
@@ -0,0 +1,75 @@
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
+#include "nvc0.h"
+
+static struct nouveau_oclass
+nvea_graph_sclass[] = {
+	{ 0x902d, &nouveau_object_ofuncs },
+	{ 0xa040, &nouveau_object_ofuncs },
+	{ 0xa297, &nouveau_object_ofuncs },
+	{ 0xa0c0, &nouveau_object_ofuncs },
+	{}
+};
+
+static struct nvc0_graph_mthd
+nvea_grctx_init_mthd[] = {
+	{ 0xa297, nve4_grctx_init_a097, },
+	{ 0x902d, nvc0_grctx_init_902d, },
+	{ 0x902d, nvc0_grctx_init_mthd_magic, },
+	{}
+};
+
+struct nouveau_oclass *
+nvea_grctx_oclass = &(struct nvc0_grctx_oclass) {
+	.base.handle = NV_ENGCTX(GR, 0xea),
+	.base.ofuncs = &(struct nouveau_ofuncs) {
+		.ctor = nvc0_graph_context_ctor,
+		.dtor = nvc0_graph_context_dtor,
+		.init = _nouveau_graph_context_init,
+		.fini = _nouveau_graph_context_fini,
+		.rd32 = _nouveau_graph_context_rd32,
+		.wr32 = _nouveau_graph_context_wr32,
+	},
+	.main = nve4_grctx_generate_main,
+	.mods = nve4_grctx_generate_mods,
+	.unkn = nve4_grctx_generate_unkn,
+	.hub  = nve4_grctx_init_hub,
+	.gpc  = nve4_grctx_init_gpc,
+	.icmd = nve4_grctx_init_icmd,
+	.mthd = nvea_grctx_init_mthd,
+}.base;
+
+
+struct nouveau_oclass *
+nvea_graph_oclass = &(struct nvc0_graph_oclass) {
+	.base.handle = NV_ENGINE(GR, 0xea),
+	.base.ofuncs = &(struct nouveau_ofuncs) {
+		.ctor = nvc0_graph_ctor,
+		.dtor = nvc0_graph_dtor,
+		.init = nve4_graph_init,
+		.fini = _nouveau_graph_fini,
+	},
+	.cclass = &nvea_grctx_oclass,
+	.sclass = nvea_graph_sclass,
+	.mmio = nve4_graph_init_mmio,
+}.base;
diff --git a/drivers/gpu/drm/nouveau/core/include/engine/graph.h b/drivers/gpu/drm/nouveau/core/include/engine/graph.h
index 97705618de97..632d7e172172 100644
--- a/drivers/gpu/drm/nouveau/core/include/engine/graph.h
+++ b/drivers/gpu/drm/nouveau/core/include/engine/graph.h
@@ -68,6 +68,7 @@ extern struct nouveau_oclass *nvc8_graph_oclass;
 extern struct nouveau_oclass *nvd7_graph_oclass;
 extern struct nouveau_oclass *nvd9_graph_oclass;
 extern struct nouveau_oclass *nve4_graph_oclass;
+extern struct nouveau_oclass *nvea_graph_oclass;
 extern struct nouveau_oclass *nvf0_graph_oclass;
 extern struct nouveau_oclass *nv108_graph_oclass;
 
-- 
1.9.1

