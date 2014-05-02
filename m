Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaEBJfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:35:33 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4224 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaEBJdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:33:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 02 May 2014 02:24:13 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 5/9] drm/nouveau/fifo: add GK20A support
Date: Fri, 2 May 2014 18:32:38 +0900
Message-ID: <1399023162-13159-6-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
References: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GK20A's FIFO is compatible with NVE0, but only features 128 channels and
1 runlist.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/nouveau/Makefile                   |  1 +
 drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c   | 35 ++++++++++++++++++++++
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h    |  1 +
 drivers/gpu/drm/nouveau/core/include/engine/fifo.h |  1 +
 4 files changed, 38 insertions(+)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c

diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
index 34fef246e779..e6fe53bab593 100644
--- a/drivers/gpu/drm/nouveau/Makefile
+++ b/drivers/gpu/drm/nouveau/Makefile
@@ -248,6 +248,7 @@ nouveau-y += core/engine/fifo/nv50.o
 nouveau-y += core/engine/fifo/nv84.o
 nouveau-y += core/engine/fifo/nvc0.o
 nouveau-y += core/engine/fifo/nve0.o
+nouveau-y += core/engine/fifo/gk20a.o
 nouveau-y += core/engine/fifo/nv108.o
 nouveau-y += core/engine/graph/ctxnv40.o
 nouveau-y += core/engine/graph/ctxnv50.o
diff --git a/drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c b/drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c
new file mode 100644
index 000000000000..327456eae963
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/core/engine/fifo/gk20a.c
@@ -0,0 +1,35 @@
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
+#include "nve0.h"
+
+struct nouveau_oclass *
+gk20a_fifo_oclass = &(struct nve0_fifo_impl) {
+	.base.handle = NV_ENGINE(FIFO, 0xea),
+	.base.ofuncs = &(struct nouveau_ofuncs) {
+		.ctor = nve0_fifo_ctor,
+		.dtor = nve0_fifo_dtor,
+		.init = nve0_fifo_init,
+		.fini = nve0_fifo_fini,
+	},
+	.channels = 128,
+}.base;
diff --git a/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h b/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h
index 014344ebee66..e96b32bb1bbc 100644
--- a/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h
+++ b/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h
@@ -8,6 +8,7 @@ int  nve0_fifo_ctor(struct nouveau_object *, struct nouveau_object *,
 		    struct nouveau_object **);
 void nve0_fifo_dtor(struct nouveau_object *);
 int  nve0_fifo_init(struct nouveau_object *);
+int  nve0_fifo_fini(struct nouveau_object *, bool);
 
 struct nve0_fifo_impl {
 	struct nouveau_oclass base;
diff --git a/drivers/gpu/drm/nouveau/core/include/engine/fifo.h b/drivers/gpu/drm/nouveau/core/include/engine/fifo.h
index 26b6b2bb1112..b639eb2c74ff 100644
--- a/drivers/gpu/drm/nouveau/core/include/engine/fifo.h
+++ b/drivers/gpu/drm/nouveau/core/include/engine/fifo.h
@@ -109,6 +109,7 @@ extern struct nouveau_oclass *nv50_fifo_oclass;
 extern struct nouveau_oclass *nv84_fifo_oclass;
 extern struct nouveau_oclass *nvc0_fifo_oclass;
 extern struct nouveau_oclass *nve0_fifo_oclass;
+extern struct nouveau_oclass *gk20a_fifo_oclass;
 extern struct nouveau_oclass *nv108_fifo_oclass;
 
 void nv04_fifo_intr(struct nouveau_subdev *);
-- 
1.9.2

