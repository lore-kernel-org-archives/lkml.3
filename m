Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbaBAD3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:29:10 -0500
Received: from gnurou.org ([207.192.72.5]:51800 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588AbaBAD20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 22:28:26 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc: Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Eric Brower <ebrower@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 07/16] drm/nouveau/bar/nvc0: support chips without BAR3
Date: Sat,  1 Feb 2014 12:16:49 +0900
Message-Id: <1391224618-3794-8-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt the NVC0 BAR driver to make it able to support chips that do not
expose a BAR3. When this happens, BAR1 is then used for USERD mapping
and the BAR alloc() functions is disabled, making GPU objects unable
to rely on BAR for data access and falling back to PRAMIN.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c | 115 +++++++++++++------------
 1 file changed, 61 insertions(+), 54 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c b/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
index 3f30db6..c2bb0e5 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
@@ -79,87 +79,88 @@ nvc0_bar_unmap(struct nouveau_bar *bar, struct nouveau_vma *vma)
 }
 
 static int
-nvc0_bar_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
-	      struct nouveau_oclass *oclass, void *data, u32 size,
-	      struct nouveau_object **pobject)
+nvc0_bar_init_vm(struct nvc0_bar_priv *priv, int nr, int bar)
 {
-	struct nouveau_device *device = nv_device(parent);
-	struct nvc0_bar_priv *priv;
+	struct nouveau_device *device = nv_device(&priv->base);
 	struct nouveau_gpuobj *mem;
 	struct nouveau_vm *vm;
+	resource_size_t bar_len;
 	int ret;
 
-	ret = nouveau_bar_create(parent, engine, oclass, &priv);
-	*pobject = nv_object(priv);
-	if (ret)
-		return ret;
-
-	/* BAR3 */
 	ret = nouveau_gpuobj_new(nv_object(priv), NULL, 0x1000, 0, 0,
-				&priv->bar[0].mem);
-	mem = priv->bar[0].mem;
+				&priv->bar[nr].mem);
+	mem = priv->bar[nr].mem;
 	if (ret)
 		return ret;
 
 	ret = nouveau_gpuobj_new(nv_object(priv), NULL, 0x8000, 0, 0,
-				&priv->bar[0].pgd);
+				&priv->bar[nr].pgd);
 	if (ret)
 		return ret;
 
-	ret = nouveau_vm_new(device, 0, nv_device_resource_len(device, 3), 0, &vm);
+	bar_len = nv_device_resource_len(device, bar);
+
+	ret = nouveau_vm_new(device, 0, bar_len, 0, &vm);
 	if (ret)
 		return ret;
 
 	atomic_inc(&vm->engref[NVDEV_SUBDEV_BAR]);
 
-	ret = nouveau_gpuobj_new(nv_object(priv), NULL,
-				 (nv_device_resource_len(device, 3) >> 12) * 8,
-				 0x1000, NVOBJ_FLAG_ZERO_ALLOC,
-				 &vm->pgt[0].obj[0]);
-	vm->pgt[0].refcount[0] = 1;
-	if (ret)
-		return ret;
+	/*
+	 * Bootstrap page table lookup.
+	 */
+	if (bar == 3) {
+		ret = nouveau_gpuobj_new(nv_object(priv), NULL,
+					 (bar_len >> 12) * 8, 0x1000,
+					 NVOBJ_FLAG_ZERO_ALLOC,
+					&vm->pgt[0].obj[0]);
+		vm->pgt[0].refcount[0] = 1;
+		if (ret)
+			return ret;
+	}
 
-	ret = nouveau_vm_ref(vm, &priv->bar[0].vm, priv->bar[0].pgd);
+	ret = nouveau_vm_ref(vm, &priv->bar[nr].vm, priv->bar[nr].pgd);
 	nouveau_vm_ref(NULL, &vm, NULL);
 	if (ret)
 		return ret;
 
-	nv_wo32(mem, 0x0200, lower_32_bits(priv->bar[0].pgd->addr));
-	nv_wo32(mem, 0x0204, upper_32_bits(priv->bar[0].pgd->addr));
-	nv_wo32(mem, 0x0208, lower_32_bits(nv_device_resource_len(device, 3) - 1));
-	nv_wo32(mem, 0x020c, upper_32_bits(nv_device_resource_len(device, 3) - 1));
+	nv_wo32(mem, 0x0200, lower_32_bits(priv->bar[nr].pgd->addr));
+	nv_wo32(mem, 0x0204, upper_32_bits(priv->bar[nr].pgd->addr));
+	nv_wo32(mem, 0x0208, lower_32_bits(bar_len - 1));
+	nv_wo32(mem, 0x020c, upper_32_bits(bar_len - 1));
 
-	/* BAR1 */
-	ret = nouveau_gpuobj_new(nv_object(priv), NULL, 0x1000, 0, 0,
-				&priv->bar[1].mem);
-	mem = priv->bar[1].mem;
-	if (ret)
-		return ret;
+	return 0;
+}
 
-	ret = nouveau_gpuobj_new(nv_object(priv), NULL, 0x8000, 0, 0,
-				&priv->bar[1].pgd);
-	if (ret)
-		return ret;
+static int
+nvc0_bar_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
+	      struct nouveau_oclass *oclass, void *data, u32 size,
+	      struct nouveau_object **pobject)
+{
+	struct nouveau_device *device = nv_device(parent);
+	struct nvc0_bar_priv *priv;
+	bool has_bar3 = nv_device_resource_len(device, 3) != 0;
+	int ret;
 
-	ret = nouveau_vm_new(device, 0, nv_device_resource_len(device, 1), 0, &vm);
+	ret = nouveau_bar_create(parent, engine, oclass, &priv);
+	*pobject = nv_object(priv);
 	if (ret)
 		return ret;
 
-	atomic_inc(&vm->engref[NVDEV_SUBDEV_BAR]);
+	/* BAR3 */
+	if (has_bar3) {
+		ret = nvc0_bar_init_vm(priv, 0, 3);
+		if (ret)
+			return ret;
+		priv->base.alloc = nouveau_bar_alloc;
+		priv->base.kmap = nvc0_bar_kmap;
+	}
 
-	ret = nouveau_vm_ref(vm, &priv->bar[1].vm, priv->bar[1].pgd);
-	nouveau_vm_ref(NULL, &vm, NULL);
+	/* BAR1 */
+	ret = nvc0_bar_init_vm(priv, 1, 1);
 	if (ret)
 		return ret;
 
-	nv_wo32(mem, 0x0200, lower_32_bits(priv->bar[1].pgd->addr));
-	nv_wo32(mem, 0x0204, upper_32_bits(priv->bar[1].pgd->addr));
-	nv_wo32(mem, 0x0208, lower_32_bits(nv_device_resource_len(device, 1) - 1));
-	nv_wo32(mem, 0x020c, upper_32_bits(nv_device_resource_len(device, 1) - 1));
-
-	priv->base.alloc = nouveau_bar_alloc;
-	priv->base.kmap = nvc0_bar_kmap;
 	priv->base.umap = nvc0_bar_umap;
 	priv->base.unmap = nvc0_bar_unmap;
 	priv->base.flush = nv84_bar_flush;
@@ -176,12 +177,16 @@ nvc0_bar_dtor(struct nouveau_object *object)
 	nouveau_gpuobj_ref(NULL, &priv->bar[1].pgd);
 	nouveau_gpuobj_ref(NULL, &priv->bar[1].mem);
 
-	if (priv->bar[0].vm) {
-		nouveau_gpuobj_ref(NULL, &priv->bar[0].vm->pgt[0].obj[0]);
-		nouveau_vm_ref(NULL, &priv->bar[0].vm, priv->bar[0].pgd);
+	if (priv->bar[0].mem) {
+		if (priv->bar[0].vm) {
+			nouveau_gpuobj_ref(NULL,
+					   &priv->bar[0].vm->pgt[0].obj[0]);
+			nouveau_vm_ref(NULL, &priv->bar[0].vm,
+				       priv->bar[0].pgd);
+		}
+		nouveau_gpuobj_ref(NULL, &priv->bar[0].pgd);
+		nouveau_gpuobj_ref(NULL, &priv->bar[0].mem);
 	}
-	nouveau_gpuobj_ref(NULL, &priv->bar[0].pgd);
-	nouveau_gpuobj_ref(NULL, &priv->bar[0].mem);
 
 	nouveau_bar_destroy(&priv->base);
 }
@@ -201,7 +206,9 @@ nvc0_bar_init(struct nouveau_object *object)
 	nv_mask(priv, 0x100c80, 0x00000001, 0x00000000);
 
 	nv_wr32(priv, 0x001704, 0x80000000 | priv->bar[1].mem->addr >> 12);
-	nv_wr32(priv, 0x001714, 0xc0000000 | priv->bar[0].mem->addr >> 12);
+	if (priv->bar[0].mem)
+		nv_wr32(priv, 0x001714,
+			0xc0000000 | priv->bar[0].mem->addr >> 12);
 	return 0;
 }
 
-- 
1.8.5.3

