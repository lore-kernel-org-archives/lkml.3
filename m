Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaEBJfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:35:00 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19299 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaEBJd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:33:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 02 May 2014 02:28:19 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 8/9] drm/nouveau/graph: add GK20A support
Date: Fri, 2 May 2014 18:32:41 +0900
Message-ID: <1399023162-13159-9-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
References: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
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
 drivers/gpu/drm/nouveau/Makefile                   |  2 +
 .../gpu/drm/nouveau/core/engine/graph/ctxgk20a.c   | 53 ++++++++++++++++++++++
 .../gpu/drm/nouveau/core/engine/graph/ctxnvc0.h    |  9 ++++
 .../gpu/drm/nouveau/core/engine/graph/ctxnve4.c    | 14 +++---
 drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c  | 47 +++++++++++++++++++
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |  2 +
 drivers/gpu/drm/nouveau/core/engine/graph/nve4.c   |  4 +-
 .../gpu/drm/nouveau/core/include/engine/graph.h    |  1 +
 8 files changed, 123 insertions(+), 9 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/ctxgk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c

diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
index e6fe53bab593..1aaa2ef577d9 100644
--- a/drivers/gpu/drm/nouveau/Makefile
+++ b/drivers/gpu/drm/nouveau/Makefile
@@ -259,6 +259,7 @@ nouveau-y += core/engine/graph/ctxnvc8.o
 nouveau-y += core/engine/graph/ctxnvd7.o
 nouveau-y += core/engine/graph/ctxnvd9.o
 nouveau-y += core/engine/graph/ctxnve4.o
+nouveau-y += core/engine/graph/ctxgk20a.o
 nouveau-y += core/engine/graph/ctxnvf0.o
 nouveau-y += core/engine/graph/ctxnv108.o
 nouveau-y += core/engine/graph/ctxgm107.o
@@ -279,6 +280,7 @@ nouveau-y += core/engine/graph/nvc8.o
 nouveau-y += core/engine/graph/nvd7.o
 nouveau-y += core/engine/graph/nvd9.o
 nouveau-y += core/engine/graph/nve4.o
+nouveau-y += core/engine/graph/gk20a.o
 nouveau-y += core/engine/graph/nvf0.o
 nouveau-y += core/engine/graph/nv108.o
 nouveau-y += core/engine/graph/gm107.o
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/ctxgk20a.c b/drivers/gpu/drm/nouveau/core/engine/graph/ctxgk20a.c
new file mode 100644
index 000000000000..224ee0287ab7
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/ctxgk20a.c
@@ -0,0 +1,53 @@
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
+#include "ctxnvc0.h"
+
+static const struct nvc0_graph_pack
+gk20a_grctx_pack_mthd[] = {
+	{ nve4_grctx_init_a097_0, 0xa297 },
+	{ nvc0_grctx_init_902d_0, 0x902d },
+	{}
+};
+
+struct nouveau_oclass *
+gk20a_grctx_oclass = &(struct nvc0_grctx_oclass) {
+	.base.handle = NV_ENGCTX(GR, 0xea),
+	.base.ofuncs = &(struct nouveau_ofuncs) {
+		.ctor = nvc0_graph_context_ctor,
+		.dtor = nvc0_graph_context_dtor,
+		.init = _nouveau_graph_context_init,
+		.fini = _nouveau_graph_context_fini,
+		.rd32 = _nouveau_graph_context_rd32,
+		.wr32 = _nouveau_graph_context_wr32,
+	},
+	.main  = nve4_grctx_generate_main,
+	.mods  = nve4_grctx_generate_mods,
+	.unkn  = nve4_grctx_generate_unkn,
+	.hub   = nve4_grctx_pack_hub,
+	.gpc   = nve4_grctx_pack_gpc,
+	.zcull = nvc0_grctx_pack_zcull,
+	.tpc   = nve4_grctx_pack_tpc,
+	.ppc   = nve4_grctx_pack_ppc,
+	.icmd  = nve4_grctx_pack_icmd,
+	.mthd  = gk20a_grctx_pack_mthd,
+}.base;
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc0.h b/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc0.h
index 9c815d1f99ef..8da8b627b9d0 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc0.h
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc0.h
@@ -69,7 +69,9 @@ extern struct nouveau_oclass *nvd7_grctx_oclass;
 extern struct nouveau_oclass *nvd9_grctx_oclass;
 
 extern struct nouveau_oclass *nve4_grctx_oclass;
+extern struct nouveau_oclass *gk20a_grctx_oclass;
 void nve4_grctx_generate_main(struct nvc0_graph_priv *, struct nvc0_grctx *);
+void nve4_grctx_generate_mods(struct nvc0_graph_priv *, struct nvc0_grctx *);
 void nve4_grctx_generate_unkn(struct nvc0_graph_priv *);
 void nve4_grctx_generate_r418bb8(struct nvc0_graph_priv *);
 
@@ -151,6 +153,13 @@ extern const struct nvc0_graph_init nve4_grctx_init_gpm_0[];
 
 extern const struct nvc0_graph_init nve4_grctx_init_pes_0[];
 
+extern const struct nvc0_graph_pack nve4_grctx_pack_hub[];
+extern const struct nvc0_graph_pack nve4_grctx_pack_gpc[];
+extern const struct nvc0_graph_pack nve4_grctx_pack_tpc[];
+extern const struct nvc0_graph_pack nve4_grctx_pack_ppc[];
+extern const struct nvc0_graph_pack nve4_grctx_pack_icmd[];
+extern const struct nvc0_graph_init nve4_grctx_init_a097_0[];
+
 extern const struct nvc0_graph_pack nvf0_grctx_pack_mthd[];
 
 extern const struct nvc0_graph_init nvf0_grctx_init_pri_0[];
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/ctxnve4.c b/drivers/gpu/drm/nouveau/core/engine/graph/ctxnve4.c
index 49a14b116a5f..c5b249238587 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/ctxnve4.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/ctxnve4.c
@@ -272,13 +272,13 @@ nve4_grctx_init_icmd_0[] = {
 	{}
 };
 
-static const struct nvc0_graph_pack
+const struct nvc0_graph_pack
 nve4_grctx_pack_icmd[] = {
 	{ nve4_grctx_init_icmd_0 },
 	{}
 };
 
-static const struct nvc0_graph_init
+const struct nvc0_graph_init
 nve4_grctx_init_a097_0[] = {
 	{ 0x000800,   8, 0x40, 0x00000000 },
 	{ 0x000804,   8, 0x40, 0x00000000 },
@@ -697,7 +697,7 @@ nve4_grctx_init_be_0[] = {
 	{}
 };
 
-static const struct nvc0_graph_pack
+const struct nvc0_graph_pack
 nve4_grctx_pack_hub[] = {
 	{ nvc0_grctx_init_main_0 },
 	{ nve4_grctx_init_fe_0 },
@@ -737,7 +737,7 @@ nve4_grctx_init_gpm_0[] = {
 	{}
 };
 
-static const struct nvc0_graph_pack
+const struct nvc0_graph_pack
 nve4_grctx_pack_gpc[] = {
 	{ nvc0_grctx_init_gpc_unk_0 },
 	{ nvd9_grctx_init_prop_0 },
@@ -802,7 +802,7 @@ nve4_grctx_init_sm_0[] = {
 	{}
 };
 
-static const struct nvc0_graph_pack
+const struct nvc0_graph_pack
 nve4_grctx_pack_tpc[] = {
 	{ nvd7_grctx_init_pe_0 },
 	{ nve4_grctx_init_tex_0 },
@@ -826,7 +826,7 @@ nve4_grctx_init_cbm_0[] = {
 	{}
 };
 
-static const struct nvc0_graph_pack
+const struct nvc0_graph_pack
 nve4_grctx_pack_ppc[] = {
 	{ nve4_grctx_init_pes_0 },
 	{ nve4_grctx_init_cbm_0 },
@@ -838,7 +838,7 @@ nve4_grctx_pack_ppc[] = {
  * PGRAPH context implementation
  ******************************************************************************/
 
-static void
+void
 nve4_grctx_generate_mods(struct nvc0_graph_priv *priv, struct nvc0_grctx *info)
 {
 	u32 magic[GPC_MAX][2];
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c b/drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c
new file mode 100644
index 000000000000..83048a56430d
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/gk20a.c
@@ -0,0 +1,47 @@
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
+#include "ctxnvc0.h"
+
+static struct nouveau_oclass
+gk20a_graph_sclass[] = {
+	{ 0x902d, &nouveau_object_ofuncs },
+	{ 0xa040, &nouveau_object_ofuncs },
+	{ 0xa297, &nouveau_object_ofuncs },
+	{ 0xa0c0, &nouveau_object_ofuncs },
+	{}
+};
+
+struct nouveau_oclass *
+gk20a_graph_oclass = &(struct nvc0_graph_oclass) {
+	.base.handle = NV_ENGINE(GR, 0xea),
+	.base.ofuncs = &(struct nouveau_ofuncs) {
+		.ctor = nvc0_graph_ctor,
+		.dtor = nvc0_graph_dtor,
+		.init = nve4_graph_init,
+		.fini = nve4_graph_fini,
+	},
+	.cclass = &gk20a_grctx_oclass,
+	.sclass = gk20a_graph_sclass,
+	.mmio = nve4_graph_pack_mmio,
+}.base;
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h
index 90d44616c876..75203a99d902 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h
@@ -116,6 +116,7 @@ int  nvc0_graph_ctor(struct nouveau_object *, struct nouveau_object *,
 		     struct nouveau_object **);
 void nvc0_graph_dtor(struct nouveau_object *);
 int  nvc0_graph_init(struct nouveau_object *);
+int  nve4_graph_fini(struct nouveau_object *, bool);
 int  nve4_graph_init(struct nouveau_object *);
 
 extern struct nouveau_oclass nvc0_graph_sclass[];
@@ -217,6 +218,7 @@ extern const struct nvc0_graph_init nve4_graph_init_main_0[];
 extern const struct nvc0_graph_init nve4_graph_init_tpccs_0[];
 extern const struct nvc0_graph_init nve4_graph_init_pe_0[];
 extern const struct nvc0_graph_init nve4_graph_init_be_0[];
+extern const struct nvc0_graph_pack nve4_graph_pack_mmio[];
 
 extern const struct nvc0_graph_init nvf0_graph_init_fe_0[];
 extern const struct nvc0_graph_init nvf0_graph_init_sked_0[];
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nve4.c b/drivers/gpu/drm/nouveau/core/engine/graph/nve4.c
index f7c011217175..51e0c075ad34 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nve4.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nve4.c
@@ -151,7 +151,7 @@ nve4_graph_init_be_0[] = {
 	{}
 };
 
-static const struct nvc0_graph_pack
+const struct nvc0_graph_pack
 nve4_graph_pack_mmio[] = {
 	{ nve4_graph_init_main_0 },
 	{ nvc0_graph_init_fe_0 },
@@ -189,7 +189,7 @@ nve4_graph_pack_mmio[] = {
  * PGRAPH engine/subdev functions
  ******************************************************************************/
 
-static int
+int
 nve4_graph_fini(struct nouveau_object *object, bool suspend)
 {
 	struct nvc0_graph_priv *priv = (void *)object;
diff --git a/drivers/gpu/drm/nouveau/core/include/engine/graph.h b/drivers/gpu/drm/nouveau/core/include/engine/graph.h
index 871edfdf3d5b..8c1d4772da0c 100644
--- a/drivers/gpu/drm/nouveau/core/include/engine/graph.h
+++ b/drivers/gpu/drm/nouveau/core/include/engine/graph.h
@@ -68,6 +68,7 @@ extern struct nouveau_oclass *nvc8_graph_oclass;
 extern struct nouveau_oclass *nvd7_graph_oclass;
 extern struct nouveau_oclass *nvd9_graph_oclass;
 extern struct nouveau_oclass *nve4_graph_oclass;
+extern struct nouveau_oclass *gk20a_graph_oclass;
 extern struct nouveau_oclass *nvf0_graph_oclass;
 extern struct nouveau_oclass *nv108_graph_oclass;
 extern struct nouveau_oclass *gm107_graph_oclass;
-- 
1.9.2

