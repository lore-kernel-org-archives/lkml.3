Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab3JKM2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:28:51 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14297 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab3JKM2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:28:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 11 Oct 2013 05:28:47 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>
Subject: [PATCH] drm/tegra: Use dma_mapping API in mmap
Date: Fri, 11 Oct 2013 15:24:37 +0300
Message-ID: <1381494277-25542-1-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This far we have used the remap_pfn_range() function directly to
map buffers to user space. Calling this function has worked as all
memory allocations have been contiguous. However, the function must
support also non-contiguous memory allocations as we later want to
turn on IOMMU.

This patch modifies the code to use dma_mapping API for mapping
buffers to user space.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---

I tested this patch on cardhu using Hiroshi Doyu's series "Unified SMMU
driver among Tegra SoCs" and using just pure Linux 3.12rc4. I have not
tested this on T20 so I would appreaciate help in here (although I do not
think this should affect the behavior on T20 at all).

I also would like to hear suggestions on better approaches for using
dma_mmap_writecombine(). If IOMMU is not used, this function call ends up
calling arm_iommu_mmap() which assumes that vm_pgoff value is valid. I see
that other drm drivers simply implement fault callbacks and avoid this problem
completely.

 drivers/gpu/host1x/drm/gem.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/drm/gem.c b/drivers/gpu/host1x/drm/gem.c
index 59623de..82ae3d5 100644
--- a/drivers/gpu/host1x/drm/gem.c
+++ b/drivers/gpu/host1x/drm/gem.c
@@ -240,6 +240,7 @@ int tegra_drm_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct drm_gem_object *gem;
 	struct tegra_bo *bo;
+	unsigned long vm_pgoff;
 	int ret;
 
 	ret = drm_gem_mmap(file, vma);
@@ -249,8 +250,19 @@ int tegra_drm_mmap(struct file *file, struct vm_area_struct *vma)
 	gem = vma->vm_private_data;
 	bo = to_tegra_bo(gem);
 
-	ret = remap_pfn_range(vma, vma->vm_start, bo->paddr >> PAGE_SHIFT,
-			      vma->vm_end - vma->vm_start, vma->vm_page_prot);
+	/* the pages are real */
+	vma->vm_flags &= ~VM_PFNMAP;
+
+	/* drm holds a fake offset in vm_pgoff... dma_mapping assumes that
+	 * vm_pgoff contains data related to the buffer => clear the cookie
+	 * temporarily. */
+
+	vm_pgoff = vma->vm_pgoff;
+	vma->vm_pgoff = 0;
+	ret = dma_mmap_writecombine(bo->gem.dev->dev, vma, bo->vaddr,
+				    bo->paddr, bo->gem.size);
+	vma->vm_pgoff = vm_pgoff;
+
 	if (ret)
 		drm_gem_vm_close(vma);
 
-- 
1.8.1.5

