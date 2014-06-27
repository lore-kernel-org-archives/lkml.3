Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaF0J5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:57:05 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34625 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaF0J5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:57:01 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] dma-mapping: Provide write-combine allocations
Date: Fri, 27 Jun 2014 11:56:58 +0200
Message-Id: <1403863018-20033-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Provide an implementation for dma_{alloc,free,mmap}_writecombine() when
the architecture supports DMA attributes.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- Add a generic dma_mmap_writecombine() function

 arch/arm/include/asm/dma-mapping.h       | 16 ----------------
 include/asm-generic/dma-mapping-common.h |  8 --------
 include/linux/dma-mapping.h              | 26 ++++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index c45b61a4b4a5..85738b200023 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -265,22 +265,6 @@ extern int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 			void *cpu_addr, dma_addr_t dma_addr, size_t size,
 			struct dma_attrs *attrs);
 
-static inline void *dma_alloc_writecombine(struct device *dev, size_t size,
-				       dma_addr_t *dma_handle, gfp_t flag)
-{
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
-	return dma_alloc_attrs(dev, size, dma_handle, flag, &attrs);
-}
-
-static inline void dma_free_writecombine(struct device *dev, size_t size,
-				     void *cpu_addr, dma_addr_t dma_handle)
-{
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
-	return dma_free_attrs(dev, size, cpu_addr, dma_handle, &attrs);
-}
-
 /*
  * This can be called during early boot to increase the size of the atomic
  * coherent DMA pool above the default value of 256KiB. It must be called
diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index de8bf89940f8..d137431bf26f 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -205,14 +205,6 @@ dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma, void *cpu_addr,
 
 #define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, NULL)
 
-static inline int dma_mmap_writecombine(struct device *dev, struct vm_area_struct *vma,
-		      void *cpu_addr, dma_addr_t dma_addr, size_t size)
-{
-	DEFINE_DMA_ATTRS(attrs);
-	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
-	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size, &attrs);
-}
-
 int
 dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
 		       void *cpu_addr, dma_addr_t dma_addr, size_t size);
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 931b70986272..d5d388160f42 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -263,6 +263,32 @@ struct dma_attrs;
 #define dma_unmap_sg_attrs(dev, sgl, nents, dir, attrs) \
 	dma_unmap_sg(dev, sgl, nents, dir)
 
+#else
+static inline void *dma_alloc_writecombine(struct device *dev, size_t size,
+					   dma_addr_t *dma_addr, gfp_t gfp)
+{
+	DEFINE_DMA_ATTRS(attrs);
+	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+	return dma_alloc_attrs(dev, size, dma_addr, gfp, &attrs);
+}
+
+static inline void dma_free_writecombine(struct device *dev, size_t size,
+					 void *cpu_addr, dma_addr_t dma_addr)
+{
+	DEFINE_DMA_ATTRS(attrs);
+	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+	return dma_free_attrs(dev, size, cpu_addr, dma_addr, &attrs);
+}
+
+static inline int dma_mmap_writecombine(struct device *dev,
+					struct vm_area_struct *vma,
+					void *cpu_addr, dma_addr_t dma_addr,
+					size_t size)
+{
+	DEFINE_DMA_ATTRS(attrs);
+	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
+	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size, &attrs);
+}
 #endif /* CONFIG_HAVE_DMA_ATTRS */
 
 #ifdef CONFIG_NEED_DMA_MAP_STATE
-- 
2.0.0

