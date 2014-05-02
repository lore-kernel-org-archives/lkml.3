Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaEBJdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:33:54 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15469 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaEBJdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:33:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 02 May 2014 02:28:10 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 4/9] drm/nouveau/fb: add GK20A support
Date: Fri, 2 May 2014 18:32:37 +0900
Message-ID: <1399023162-13159-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
References: <1399023162-13159-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple FB device for GK20A, as well as a RAM implementation based
on contiguous DMA memory allocations suitable for chips that use system
memory as video RAM.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/Makefile                  |   2 +
 drivers/gpu/drm/nouveau/core/include/subdev/fb.h  |   1 +
 drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c    |  56 ++++++++
 drivers/gpu/drm/nouveau/core/subdev/fb/priv.h     |   1 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c | 167 ++++++++++++++++++++++
 5 files changed, 227 insertions(+)
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c

diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
index bc5fb24630e6..34fef246e779 100644
--- a/drivers/gpu/drm/nouveau/Makefile
+++ b/drivers/gpu/drm/nouveau/Makefile
@@ -102,6 +102,7 @@ nouveau-y += core/subdev/fb/nvaa.o
 nouveau-y += core/subdev/fb/nvaf.o
 nouveau-y += core/subdev/fb/nvc0.o
 nouveau-y += core/subdev/fb/nve0.o
+nouveau-y += core/subdev/fb/gk20a.o
 nouveau-y += core/subdev/fb/gm107.o
 nouveau-y += core/subdev/fb/ramnv04.o
 nouveau-y += core/subdev/fb/ramnv10.o
@@ -117,6 +118,7 @@ nouveau-y += core/subdev/fb/ramnva3.o
 nouveau-y += core/subdev/fb/ramnvaa.o
 nouveau-y += core/subdev/fb/ramnvc0.o
 nouveau-y += core/subdev/fb/ramnve0.o
+nouveau-y += core/subdev/fb/ramgk20a.o
 nouveau-y += core/subdev/fb/ramgm107.o
 nouveau-y += core/subdev/fb/sddr3.o
 nouveau-y += core/subdev/fb/gddr5.o
diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/fb.h b/drivers/gpu/drm/nouveau/core/include/subdev/fb.h
index 58c7ccdebb01..871e73914b24 100644
--- a/drivers/gpu/drm/nouveau/core/include/subdev/fb.h
+++ b/drivers/gpu/drm/nouveau/core/include/subdev/fb.h
@@ -105,6 +105,7 @@ extern struct nouveau_oclass *nvaa_fb_oclass;
 extern struct nouveau_oclass *nvaf_fb_oclass;
 extern struct nouveau_oclass *nvc0_fb_oclass;
 extern struct nouveau_oclass *nve0_fb_oclass;
+extern struct nouveau_oclass *gk20a_fb_oclass;
 extern struct nouveau_oclass *gm107_fb_oclass;
 
 #include <subdev/bios/ramcfg.h>
diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c b/drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c
new file mode 100644
index 000000000000..a16024a74771
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/gk20a.c
@@ -0,0 +1,56 @@
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
+struct gk20a_fb_priv {
+	struct nouveau_fb base;
+};
+
+static int
+gk20a_fb_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
+	     struct nouveau_oclass *oclass, void *data, u32 size,
+	     struct nouveau_object **pobject)
+{
+	struct gk20a_fb_priv *priv;
+	int ret;
+
+	ret = nouveau_fb_create(parent, engine, oclass, &priv);
+	*pobject = nv_object(priv);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+struct nouveau_oclass *
+gk20a_fb_oclass = &(struct nouveau_fb_impl) {
+	.base.handle = NV_SUBDEV(FB, 0xea),
+	.base.ofuncs = &(struct nouveau_ofuncs) {
+		.ctor = gk20a_fb_ctor,
+		.dtor = _nouveau_fb_dtor,
+		.init = _nouveau_fb_init,
+		.fini = _nouveau_fb_fini,
+	},
+	.memtype = nvc0_fb_memtype_valid,
+	.ram = &gk20a_ram_oclass,
+}.base;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/priv.h b/drivers/gpu/drm/nouveau/core/subdev/fb/priv.h
index da74c889aed4..82273f832e42 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/fb/priv.h
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/priv.h
@@ -32,6 +32,7 @@ extern struct nouveau_oclass nva3_ram_oclass;
 extern struct nouveau_oclass nvaa_ram_oclass;
 extern struct nouveau_oclass nvc0_ram_oclass;
 extern struct nouveau_oclass nve0_ram_oclass;
+extern struct nouveau_oclass gk20a_ram_oclass;
 extern struct nouveau_oclass gm107_ram_oclass;
 
 int nouveau_sddr3_calc(struct nouveau_ram *ram);
diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
new file mode 100644
index 000000000000..403c88f07b99
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
@@ -0,0 +1,167 @@
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
+#include "priv.h"
+
+#include <subdev/fb.h>
+
+#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/dma-contiguous.h>
+
+static void
+gk20a_ram_put(struct nouveau_fb *pfb, struct nouveau_mem **pmem)
+{
+	struct device *dev = nv_device_base(nv_device(pfb));
+	struct nouveau_mem *mem = *pmem;
+	int i;
+
+	*pmem = NULL;
+
+	for (i = 0; i < mem->size; i++) {
+		struct page *page;
+
+		if (mem->pages[i] == 0)
+			break;
+
+		page = pfn_to_page(mem->pages[i] >> PAGE_SHIFT);
+		dma_release_from_contiguous(dev, page, 1);
+	}
+
+	kfree(mem->pages);
+	kfree(mem);
+}
+
+static int
+gk20a_ram_get(struct nouveau_fb *pfb, u64 size, u32 align, u32 ncmin,
+	     u32 memtype, struct nouveau_mem **pmem)
+{
+	struct device *dev = nv_device_base(nv_device(pfb));
+	struct nouveau_mem *mem;
+	int type = memtype & 0xff;
+	dma_addr_t dma_addr;
+	int npages;
+	int order;
+	int i;
+
+	nv_debug(pfb, "%s: size: %llx align: %x, ncmin: %x\n", __func__, size,
+		 align, ncmin);
+
+	npages = size >> PAGE_SHIFT;
+	if (npages == 0)
+		npages = 1;
+
+	if (align == 0)
+		align = PAGE_SIZE;
+	align >>= PAGE_SHIFT;
+
+	/* round alignment to the next power of 2, if needed */
+	order = fls(align);
+	if ((align & (align - 1)) == 0)
+		order--;
+
+	ncmin >>= PAGE_SHIFT;
+	/*
+	 * allocate pages by chunks of "align" size, otherwise we may leave
+	 * holes in the contiguous memory area.
+	 */
+	if (ncmin == 0)
+		ncmin = npages;
+	else if (align > ncmin)
+		ncmin = align;
+
+	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+	if (!mem)
+		return -ENOMEM;
+
+	mem->size = npages;
+	mem->memtype = type;
+
+	mem->pages = kzalloc(sizeof(dma_addr_t) * npages, GFP_KERNEL);
+	if (!mem) {
+		kfree(mem);
+		return -ENOMEM;
+	}
+
+	while (npages) {
+		struct page *pages;
+		int pos = 0;
+
+		/* don't overflow in case size is not a multiple of ncmin */
+		if (ncmin > npages)
+			ncmin = npages;
+
+		pages = dma_alloc_from_contiguous(dev, ncmin, order);
+		if (!pages) {
+			gk20a_ram_put(pfb, &mem);
+			return -ENOMEM;
+		}
+
+		dma_addr = (dma_addr_t)(page_to_pfn(pages) << PAGE_SHIFT);
+
+		nv_debug(pfb, "  alloc count: %x, order: %x, addr: %pad\n", ncmin,
+			 order, &dma_addr);
+
+		for (i = 0; i < ncmin; i++)
+			mem->pages[pos + i] = dma_addr + (PAGE_SIZE * i);
+
+		pos += ncmin;
+		npages -= ncmin;
+	}
+
+	mem->offset = (u64)mem->pages[0];
+
+	*pmem = mem;
+
+	return 0;
+}
+
+static int
+gk20a_ram_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
+	      struct nouveau_oclass *oclass, void *data, u32 datasize,
+	      struct nouveau_object **pobject)
+{
+	struct nouveau_ram *ram;
+	int ret;
+
+	ret = nouveau_ram_create(parent, engine, oclass, &ram);
+	*pobject = nv_object(ram);
+	if (ret)
+		return ret;
+	ram->type = NV_MEM_TYPE_STOLEN;
+	ram->size = get_num_physpages() << PAGE_SHIFT;
+
+	ram->get = gk20a_ram_get;
+	ram->put = gk20a_ram_put;
+
+	return 0;
+}
+
+struct nouveau_oclass
+gk20a_ram_oclass = {
+	.ofuncs = &(struct nouveau_ofuncs) {
+		.ctor = gk20a_ram_ctor,
+		.dtor = _nouveau_ram_dtor,
+		.init = _nouveau_ram_init,
+		.fini = _nouveau_ram_fini,
+	},
+};
-- 
1.9.2

