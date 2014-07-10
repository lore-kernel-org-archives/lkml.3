Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaGJVu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:50:57 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:49882 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaGJVuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:50:55 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 06/83] drm/radeon: Add kfd-->kgd interfaces of memory allocation/mapping
Date: Fri, 11 Jul 2014 00:50:06 +0300
Message-Id: <1405029027-6085-5-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new interfaces to kfd2kgd_calls structure.

The new interfaces allow the kfd driver to :

1. Allocated video memory through the radeon driver
2. Map and unmap video memory with GPUVM through the radeon driver
3. Map and unmap system memory with GPUVM through the radeon driver

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon_kfd.c | 129 ++++++++++++++++++++++++++++++++++++
 include/linux/radeon_kfd.h          |  23 +++++++
 2 files changed, 152 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index 1b859b5..66ee36b 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -25,9 +25,31 @@
 #include <drm/drmP.h>
 #include "radeon.h"
 
+struct kgd_mem {
+	struct radeon_bo *bo;
+	u32 domain;
+};
+
+static int allocate_mem(struct kgd_dev *kgd, size_t size, size_t alignment,
+		enum kgd_memory_pool pool, struct kgd_mem **memory_handle);
+
+static void free_mem(struct kgd_dev *kgd, struct kgd_mem *memory_handle);
+
+static int gpumap_mem(struct kgd_dev *kgd, struct kgd_mem *mem, uint64_t *vmid0_address);
+static void ungpumap_mem(struct kgd_dev *kgd, struct kgd_mem *mem);
+
+static int kmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem, void **ptr);
+static void unkmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem);
+
 static uint64_t get_vmem_size(struct kgd_dev *kgd);
 
 static const struct kfd2kgd_calls kfd2kgd = {
+	.allocate_mem = allocate_mem,
+	.free_mem = free_mem,
+	.gpumap_mem = gpumap_mem,
+	.ungpumap_mem = ungpumap_mem,
+	.kmap_mem = kmap_mem,
+	.unkmap_mem = unkmap_mem,
 	.get_vmem_size = get_vmem_size,
 };
 
@@ -96,6 +118,113 @@ void radeon_kfd_device_fini(struct radeon_device *rdev)
 	}
 }
 
+static u32 pool_to_domain(enum kgd_memory_pool p)
+{
+	switch (p) {
+	case KGD_POOL_FRAMEBUFFER: return RADEON_GEM_DOMAIN_VRAM;
+	default: return RADEON_GEM_DOMAIN_GTT;
+	}
+}
+
+static int allocate_mem(struct kgd_dev *kgd, size_t size, size_t alignment,
+		enum kgd_memory_pool pool, struct kgd_mem **memory_handle)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+	struct kgd_mem *mem;
+	int r;
+
+	mem = kzalloc(sizeof(struct kgd_mem), GFP_KERNEL);
+	if (!mem)
+		return -ENOMEM;
+
+	mem->domain = pool_to_domain(pool);
+
+	r = radeon_bo_create(rdev, size, alignment, true, mem->domain, NULL, &mem->bo);
+	if (r) {
+		kfree(mem);
+		return r;
+	}
+
+	*memory_handle = mem;
+	return 0;
+}
+
+static void free_mem(struct kgd_dev *kgd, struct kgd_mem *mem)
+{
+	/* Assume that KFD will never free gpumapped or kmapped memory. This is not quite settled. */
+	radeon_bo_unref(&mem->bo);
+	kfree(mem);
+}
+
+static int gpumap_mem(struct kgd_dev *kgd, struct kgd_mem *mem, uint64_t *vmid0_address)
+{
+	int r;
+
+	r = radeon_bo_reserve(mem->bo, true);
+
+	/*
+	 * ttm_bo_reserve can only fail if the buffer reservation lock
+	 * is held in circumstances that would deadlock
+	 */
+	BUG_ON(r != 0);
+	r = radeon_bo_pin(mem->bo, mem->domain, vmid0_address);
+	radeon_bo_unreserve(mem->bo);
+
+	return r;
+}
+
+static void ungpumap_mem(struct kgd_dev *kgd, struct kgd_mem *mem)
+{
+	int r;
+
+	r = radeon_bo_reserve(mem->bo, true);
+
+	/*
+	 * ttm_bo_reserve can only fail if the buffer reservation lock
+	 * is held in circumstances that would deadlock
+	 */
+	BUG_ON(r != 0);
+	r = radeon_bo_unpin(mem->bo);
+
+	/*
+	 * This unpin only removed NO_EVICT placement flags
+	 * and should never fail
+	 */
+	BUG_ON(r != 0);
+	radeon_bo_unreserve(mem->bo);
+}
+
+static int kmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem, void **ptr)
+{
+	int r;
+
+	r = radeon_bo_reserve(mem->bo, true);
+
+	/*
+	 * ttm_bo_reserve can only fail if the buffer reservation lock
+	 * is held in circumstances that would deadlock
+	 */
+	BUG_ON(r != 0);
+	r = radeon_bo_kmap(mem->bo, ptr);
+	radeon_bo_unreserve(mem->bo);
+
+	return r;
+}
+
+static void unkmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem)
+{
+	int r;
+
+	r = radeon_bo_reserve(mem->bo, true);
+	/*
+	 * ttm_bo_reserve can only fail if the buffer reservation lock
+	 * is held in circumstances that would deadlock
+	 */
+	BUG_ON(r != 0);
+	radeon_bo_kunmap(mem->bo);
+	radeon_bo_unreserve(mem->bo);
+}
+
 static uint64_t get_vmem_size(struct kgd_dev *kgd)
 {
 	struct radeon_device *rdev = (struct radeon_device *)kgd;
diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
index 28cddf5..c7997d4 100644
--- a/include/linux/radeon_kfd.h
+++ b/include/linux/radeon_kfd.h
@@ -36,6 +36,14 @@ struct pci_dev;
 struct kfd_dev;
 struct kgd_dev;
 
+struct kgd_mem;
+
+enum kgd_memory_pool {
+	KGD_POOL_SYSTEM_CACHEABLE = 1,
+	KGD_POOL_SYSTEM_WRITECOMBINE = 2,
+	KGD_POOL_FRAMEBUFFER = 3,
+};
+
 struct kgd2kfd_shared_resources {
 	void __iomem *mmio_registers; /* Mapped pointer to GFX MMIO registers. */
 
@@ -57,6 +65,21 @@ struct kgd2kfd_calls {
 };
 
 struct kfd2kgd_calls {
+	/* Memory management. */
+	int (*allocate_mem)(struct kgd_dev *kgd,
+				size_t size,
+				size_t alignment,
+				enum kgd_memory_pool pool,
+				struct kgd_mem **memory_handle);
+
+	void (*free_mem)(struct kgd_dev *kgd, struct kgd_mem *memory_handle);
+
+	int (*gpumap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem, uint64_t *vmid0_address);
+	void (*ungpumap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem);
+
+	int (*kmap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem, void **ptr);
+	void (*unkmap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem);
+
 	uint64_t (*get_vmem_size)(struct kgd_dev *kgd);
 };
 
-- 
1.9.1

