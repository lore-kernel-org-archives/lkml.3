Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaDTC2W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 22:28:22 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:57934 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbaDTC04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 22:26:56 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: zeus@gnu.org, aswin@hp.com, davidlohr@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 6/6] drm/exynos: call find_vma with the mmap_sem held
Date: Sat, 19 Apr 2014 19:26:31 -0700
Message-Id: <1397960791-16320-7-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
References: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Gonzalez V <zeus@gnu.org>

Performing vma lookups without taking the mm->mmap_sem is asking
for trouble. While doing the search, the vma in question can be
modified or even removed before returning to the caller. Take the
lock (exclusively) in order to avoid races while iterating through
the vmacache and/or rbtree.

This patch is completely *untested*.

Signed-off-by: Jonathan Gonzalez V <zeus@gnu.org>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-samsung-soc@vger.kernel.org
---
 drivers/gpu/drm/exynos/exynos_drm_g2d.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index 6c1885e..8001587 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -467,14 +467,17 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct drm_device *drm_dev,
 		goto err_free;
 	}
 
+	down_read(&current->mm->mmap_sem);
 	vma = find_vma(current->mm, userptr);
 	if (!vma) {
+		up_read(&current->mm->mmap_sem);
 		DRM_ERROR("failed to get vm region.\n");
 		ret = -EFAULT;
 		goto err_free_pages;
 	}
 
 	if (vma->vm_end < userptr + size) {
+		up_read(&current->mm->mmap_sem);
 		DRM_ERROR("vma is too small.\n");
 		ret = -EFAULT;
 		goto err_free_pages;
@@ -482,6 +485,7 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct drm_device *drm_dev,
 
 	g2d_userptr->vma = exynos_gem_get_vma(vma);
 	if (!g2d_userptr->vma) {
+		up_read(&current->mm->mmap_sem);
 		DRM_ERROR("failed to copy vma.\n");
 		ret = -ENOMEM;
 		goto err_free_pages;
@@ -492,10 +496,12 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struct drm_device *drm_dev,
 	ret = exynos_gem_get_pages_from_userptr(start & PAGE_MASK,
 						npages, pages, vma);
 	if (ret < 0) {
+		up_read(&current->mm->mmap_sem);
 		DRM_ERROR("failed to get user pages from userptr.\n");
 		goto err_put_vma;
 	}
 
+	up_read(&current->mm->mmap_sem);
 	g2d_userptr->pages = pages;
 
 	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
-- 
1.8.1.4

