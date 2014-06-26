Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaFZUuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:50:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63838 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaFZUuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:50:15 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>
Cc: Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 09/10] drm/tegra: Add IOMMU support
Date: Thu, 26 Jun 2014 22:49:49 +0200
Message-Id: <1403815790-8548-10-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

When an IOMMU device is available on the platform bus, allocate an IOMMU
domain and attach the display controllers to it. The display controllers
can then scan out non-contiguous buffers by mapping them through the
IOMMU.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c  |  21 ++++
 drivers/gpu/drm/tegra/drm.c |  17 ++++
 drivers/gpu/drm/tegra/drm.h |   3 +
 drivers/gpu/drm/tegra/fb.c  |  16 ++-
 drivers/gpu/drm/tegra/gem.c | 236 +++++++++++++++++++++++++++++++++++++++-----
 drivers/gpu/drm/tegra/gem.h |   4 +
 6 files changed, 273 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index afcca04f5367..0f7452d04811 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -9,6 +9,7 @@
 
 #include <linux/clk.h>
 #include <linux/debugfs.h>
+#include <linux/iommu.h>
 #include <linux/reset.h>
 
 #include "dc.h"
@@ -1283,8 +1284,18 @@ static int tegra_dc_init(struct host1x_client *client)
 {
 	struct drm_device *drm = dev_get_drvdata(client->parent);
 	struct tegra_dc *dc = host1x_client_to_dc(client);
+	struct tegra_drm *tegra = drm->dev_private;
 	int err;
 
+	if (tegra->domain) {
+		err = iommu_attach_device(tegra->domain, dc->dev);
+		if (err < 0) {
+			dev_err(dc->dev, "failed to attach to IOMMU: %d\n",
+				err);
+			return err;
+		}
+	}
+
 	drm_crtc_init(drm, &dc->base, &tegra_crtc_funcs);
 	drm_mode_crtc_set_gamma_size(&dc->base, 256);
 	drm_crtc_helper_add(&dc->base, &tegra_crtc_helper_funcs);
@@ -1318,7 +1329,9 @@ static int tegra_dc_init(struct host1x_client *client)
 
 static int tegra_dc_exit(struct host1x_client *client)
 {
+	struct drm_device *drm = dev_get_drvdata(client->parent);
 	struct tegra_dc *dc = host1x_client_to_dc(client);
+	struct tegra_drm *tegra = drm->dev_private;
 	int err;
 
 	devm_free_irq(dc->dev, dc->irq, dc);
@@ -1335,6 +1348,8 @@ static int tegra_dc_exit(struct host1x_client *client)
 		return err;
 	}
 
+	iommu_detach_device(tegra->domain, dc->dev);
+
 	return 0;
 }
 
@@ -1462,6 +1477,12 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
+	err = iommu_attach(&pdev->dev);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to attach to IOMMU: %d\n", err);
+		return err;
+	}
+
 	INIT_LIST_HEAD(&dc->client.list);
 	dc->client.ops = &dc_client_ops;
 	dc->client.dev = &pdev->dev;
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 59736bb810cd..1d2bbafad982 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/host1x.h>
+#include <linux/iommu.h>
 
 #include "drm.h"
 #include "gem.h"
@@ -33,6 +34,16 @@ static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 	if (!tegra)
 		return -ENOMEM;
 
+	if (iommu_present(&platform_bus_type)) {
+		tegra->domain = iommu_domain_alloc(&platform_bus_type);
+		if (IS_ERR(tegra->domain)) {
+			kfree(tegra);
+			return PTR_ERR(tegra->domain);
+		}
+
+		drm_mm_init(&tegra->mm, 0, SZ_2G);
+	}
+
 	mutex_init(&tegra->clients_lock);
 	INIT_LIST_HEAD(&tegra->clients);
 	drm->dev_private = tegra;
@@ -71,6 +82,7 @@ static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
 static int tegra_drm_unload(struct drm_device *drm)
 {
 	struct host1x_device *device = to_host1x_device(drm->dev);
+	struct tegra_drm *tegra = drm->dev_private;
 	int err;
 
 	drm_kms_helper_poll_fini(drm);
@@ -82,6 +94,11 @@ static int tegra_drm_unload(struct drm_device *drm)
 	if (err < 0)
 		return err;
 
+	if (tegra->domain) {
+		iommu_domain_free(tegra->domain);
+		drm_mm_takedown(&tegra->mm);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 96d754e7b3eb..a07c796b7edc 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -39,6 +39,9 @@ struct tegra_fbdev {
 struct tegra_drm {
 	struct drm_device *drm;
 
+	struct iommu_domain *domain;
+	struct drm_mm mm;
+
 	struct mutex clients_lock;
 	struct list_head clients;
 
diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
index 7790d43ad082..21c65dd817c3 100644
--- a/drivers/gpu/drm/tegra/fb.c
+++ b/drivers/gpu/drm/tegra/fb.c
@@ -65,8 +65,12 @@ static void tegra_fb_destroy(struct drm_framebuffer *framebuffer)
 	for (i = 0; i < fb->num_planes; i++) {
 		struct tegra_bo *bo = fb->planes[i];
 
-		if (bo)
+		if (bo) {
+			if (bo->pages && bo->virt)
+				vunmap(bo->virt);
+
 			drm_gem_object_unreference_unlocked(&bo->gem);
+		}
 	}
 
 	drm_framebuffer_cleanup(framebuffer);
@@ -252,6 +256,16 @@ static int tegra_fbdev_probe(struct drm_fb_helper *helper,
 	offset = info->var.xoffset * bytes_per_pixel +
 		 info->var.yoffset * fb->pitches[0];
 
+	if (bo->pages) {
+		bo->vaddr = vmap(bo->pages, bo->num_pages, VM_MAP,
+				 pgprot_writecombine(PAGE_KERNEL));
+		if (!bo->vaddr) {
+			dev_err(drm->dev, "failed to vmap() framebuffer\n");
+			err = -ENOMEM;
+			goto destroy;
+		}
+	}
+
 	drm->mode_config.fb_base = (resource_size_t)bo->paddr;
 	info->screen_base = (void __iomem *)bo->vaddr + offset;
 	info->screen_size = size;
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index c1e4e8b6e5ca..2912e61a2599 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -14,8 +14,10 @@
  */
 
 #include <linux/dma-buf.h>
+#include <linux/iommu.h>
 #include <drm/tegra_drm.h>
 
+#include "drm.h"
 #include "gem.h"
 
 static inline struct tegra_bo *host1x_to_tegra_bo(struct host1x_bo *bo)
@@ -90,14 +92,144 @@ static const struct host1x_bo_ops tegra_bo_ops = {
 	.kunmap = tegra_bo_kunmap,
 };
 
+static int iommu_map_sg(struct iommu_domain *domain, struct sg_table *sgt,
+			dma_addr_t iova, int prot)
+{
+	unsigned long offset = 0;
+	struct scatterlist *sg;
+	unsigned int i, j;
+	int err;
+
+	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
+		dma_addr_t phys = sg_phys(sg);
+		size_t length = sg->offset;
+
+		phys = sg_phys(sg) - sg->offset;
+		length = sg->length + sg->offset;
+
+		err = iommu_map(domain, iova + offset, phys, length, prot);
+		if (err < 0)
+			goto unmap;
+
+		offset += length;
+	}
+
+	return 0;
+
+unmap:
+	offset = 0;
+
+	for_each_sg(sgt->sgl, sg, i, j) {
+		size_t length = sg->length + sg->offset;
+		iommu_unmap(domain, iova + offset, length);
+		offset += length;
+	}
+
+	return err;
+}
+
+static int iommu_unmap_sg(struct iommu_domain *domain, struct sg_table *sgt,
+			  dma_addr_t iova)
+{
+	unsigned long offset = 0;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
+		dma_addr_t phys = sg_phys(sg);
+		size_t length = sg->offset;
+
+		phys = sg_phys(sg) - sg->offset;
+		length = sg->length + sg->offset;
+
+		iommu_unmap(domain, iova + offset, length);
+		offset += length;
+	}
+
+	return 0;
+}
+
+static int tegra_bo_iommu_map(struct tegra_drm *tegra, struct tegra_bo *bo)
+{
+	int prot = IOMMU_READ | IOMMU_WRITE;
+	int err;
+
+	if (bo->mm)
+		return -EBUSY;
+
+	bo->mm = kzalloc(sizeof(*bo->mm), GFP_KERNEL);
+	if (!bo->mm)
+		return -ENOMEM;
+
+	err = drm_mm_insert_node_generic(&tegra->mm, bo->mm, bo->gem.size,
+					 PAGE_SIZE, 0, 0, 0);
+	if (err < 0) {
+		dev_err(tegra->drm->dev, "out of virtual memory: %d\n", err);
+		return err;
+	}
+
+	bo->paddr = bo->mm->start;
+
+	err = iommu_map_sg(tegra->domain, bo->sgt, bo->paddr, prot);
+	if (err < 0) {
+		dev_err(tegra->drm->dev, "failed to map buffer: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static int tegra_bo_iommu_unmap(struct tegra_drm *tegra, struct tegra_bo *bo)
+{
+	if (!bo->mm)
+		return 0;
+
+	iommu_unmap_sg(tegra->domain, bo->sgt, bo->paddr);
+	drm_mm_remove_node(bo->mm);
+
+	kfree(bo->mm);
+	return 0;
+}
+
 static void tegra_bo_destroy(struct drm_device *drm, struct tegra_bo *bo)
 {
-	dma_free_writecombine(drm->dev, bo->gem.size, bo->vaddr, bo->paddr);
+	if (!bo->pages)
+		dma_free_writecombine(drm->dev, bo->gem.size, bo->vaddr,
+				      bo->paddr);
+	else
+		drm_gem_put_pages(&bo->gem, bo->pages, true, true);
+}
+
+static int tegra_bo_get_pages(struct drm_device *drm, struct tegra_bo *bo,
+			      size_t size)
+{
+	bo->pages = drm_gem_get_pages(&bo->gem, GFP_KERNEL);
+	if (!bo->pages)
+		return -ENOMEM;
+
+	bo->num_pages = size >> PAGE_SHIFT;
+
+	return 0;
+}
+
+static int tegra_bo_alloc(struct drm_device *drm, struct tegra_bo *bo,
+			  size_t size)
+{
+	bo->vaddr = dma_alloc_writecombine(drm->dev, size, &bo->paddr,
+					   GFP_KERNEL | __GFP_NOWARN);
+	if (!bo->vaddr) {
+		dev_err(drm->dev, "failed to allocate buffer of size %zu\n",
+			size);
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 struct tegra_bo *tegra_bo_create(struct drm_device *drm, unsigned int size,
 				 unsigned long flags)
 {
+	struct tegra_drm *tegra = drm->dev_private;
 	struct tegra_bo *bo;
 	int err;
 
@@ -108,22 +240,33 @@ struct tegra_bo *tegra_bo_create(struct drm_device *drm, unsigned int size,
 	host1x_bo_init(&bo->base, &tegra_bo_ops);
 	size = round_up(size, PAGE_SIZE);
 
-	bo->vaddr = dma_alloc_writecombine(drm->dev, size, &bo->paddr,
-					   GFP_KERNEL | __GFP_NOWARN);
-	if (!bo->vaddr) {
-		dev_err(drm->dev, "failed to allocate buffer with size %u\n",
-			size);
-		err = -ENOMEM;
-		goto err_dma;
-	}
-
 	err = drm_gem_object_init(drm, &bo->gem, size);
 	if (err)
-		goto err_init;
+		goto free;
 
 	err = drm_gem_create_mmap_offset(&bo->gem);
 	if (err)
-		goto err_mmap;
+		goto release;
+
+	if (tegra->domain) {
+		err = tegra_bo_get_pages(drm, bo, size);
+		if (err < 0)
+			goto release;
+
+		bo->sgt = drm_prime_pages_to_sg(bo->pages, bo->num_pages);
+		if (IS_ERR(bo->sgt)) {
+			err = PTR_ERR(bo->sgt);
+			goto release;
+		}
+
+		err = tegra_bo_iommu_map(tegra, bo);
+		if (err < 0)
+			goto release;
+	} else {
+		err = tegra_bo_alloc(drm, bo, size);
+		if (err < 0)
+			goto release;
+	}
 
 	if (flags & DRM_TEGRA_GEM_CREATE_TILED)
 		bo->tiling.mode = TEGRA_BO_TILING_MODE_TILED;
@@ -133,11 +276,10 @@ struct tegra_bo *tegra_bo_create(struct drm_device *drm, unsigned int size,
 
 	return bo;
 
-err_mmap:
+release:
 	drm_gem_object_release(&bo->gem);
-err_init:
 	tegra_bo_destroy(drm, bo);
-err_dma:
+free:
 	kfree(bo);
 
 	return ERR_PTR(err);
@@ -172,6 +314,7 @@ err:
 static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
 					struct dma_buf *buf)
 {
+	struct tegra_drm *tegra = drm->dev_private;
 	struct dma_buf_attachment *attach;
 	struct tegra_bo *bo;
 	ssize_t size;
@@ -211,12 +354,19 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
 		goto detach;
 	}
 
-	if (bo->sgt->nents > 1) {
-		err = -EINVAL;
-		goto detach;
+	if (tegra->domain) {
+		err = tegra_bo_iommu_map(tegra, bo);
+		if (err < 0)
+			goto detach;
+	} else {
+		if (bo->sgt->nents > 1) {
+			err = -EINVAL;
+			goto detach;
+		}
+
+		bo->paddr = sg_dma_address(bo->sgt->sgl);
 	}
 
-	bo->paddr = sg_dma_address(bo->sgt->sgl);
 	bo->gem.import_attach = attach;
 
 	return bo;
@@ -239,8 +389,12 @@ free:
 
 void tegra_bo_free_object(struct drm_gem_object *gem)
 {
+	struct tegra_drm *tegra = gem->dev->dev_private;
 	struct tegra_bo *bo = to_tegra_bo(gem);
 
+	if (tegra->domain)
+		tegra_bo_iommu_unmap(tegra, bo);
+
 	if (gem->import_attach) {
 		dma_buf_unmap_attachment(gem->import_attach, bo->sgt,
 					 DMA_TO_DEVICE);
@@ -301,7 +455,38 @@ int tegra_bo_dumb_map_offset(struct drm_file *file, struct drm_device *drm,
 	return 0;
 }
 
+static int tegra_bo_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct drm_gem_object *gem = vma->vm_private_data;
+	struct tegra_bo *bo = to_tegra_bo(gem);
+	struct page *page;
+	pgoff_t offset;
+	int err;
+
+	if (!bo->pages)
+		return VM_FAULT_SIGBUS;
+
+	offset = ((unsigned long)vmf->virtual_address - vma->vm_start) >> PAGE_SHIFT;
+	page = bo->pages[offset];
+
+	err = vm_insert_page(vma, (unsigned long)vmf->virtual_address, page);
+	switch (err) {
+	case -EAGAIN:
+	case 0:
+	case -ERESTARTSYS:
+	case -EINTR:
+	case -EBUSY:
+		return VM_FAULT_NOPAGE;
+
+	case -ENOMEM:
+		return VM_FAULT_OOM;
+	}
+
+	return VM_FAULT_SIGBUS;
+}
+
 const struct vm_operations_struct tegra_bo_vm_ops = {
+	.fault = tegra_bo_fault,
 	.open = drm_gem_vm_open,
 	.close = drm_gem_vm_close,
 };
@@ -316,13 +501,18 @@ int tegra_drm_mmap(struct file *file, struct vm_area_struct *vma)
 	if (ret)
 		return ret;
 
+	vma->vm_flags |= VM_MIXEDMAP;
+	vma->vm_flags &= ~VM_PFNMAP;
+
 	gem = vma->vm_private_data;
 	bo = to_tegra_bo(gem);
 
-	ret = remap_pfn_range(vma, vma->vm_start, bo->paddr >> PAGE_SHIFT,
-			      vma->vm_end - vma->vm_start, vma->vm_page_prot);
-	if (ret)
-		drm_gem_vm_close(vma);
+	if (!bo->pages) {
+		ret = remap_pfn_range(vma, vma->vm_start, bo->paddr >> PAGE_SHIFT,
+				      vma->vm_end - vma->vm_start, vma->vm_page_prot);
+		if (ret)
+			drm_gem_vm_close(vma);
+	}
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/tegra/gem.h b/drivers/gpu/drm/tegra/gem.h
index 43a25c853357..c2e3f43e4b3f 100644
--- a/drivers/gpu/drm/tegra/gem.h
+++ b/drivers/gpu/drm/tegra/gem.h
@@ -37,6 +37,10 @@ struct tegra_bo {
 	dma_addr_t paddr;
 	void *vaddr;
 
+	struct drm_mm_node *mm;
+	unsigned long num_pages;
+	struct page **pages;
+
 	struct tegra_bo_tiling tiling;
 };
 
-- 
2.0.0

