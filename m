Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaGWBfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 21:35:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54611 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaGWBfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 21:35:16 -0400
From: Laura Abbott <lauraa@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        David Riley <davidriley@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Ritesh Harjain <ritesh.harjani@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCHv4 4/5] arm: use genalloc for the atomic pool
Date: Tue, 22 Jul 2014 18:35:07 -0700
Message-Id: <1406079308-5232-5-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1406079308-5232-1-git-send-email-lauraa@codeaurora.org>
References: <1406079308-5232-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM currently uses a bitmap for tracking atomic allocations.
genalloc already handles this type of memory pool allocation
so switch to using that instead.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 arch/arm/Kconfig          |   1 +
 arch/arm/mm/dma-mapping.c | 153 +++++++++++++++-------------------------------
 2 files changed, 50 insertions(+), 104 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index eed8334..b686e0e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -13,6 +13,7 @@ config ARM
 	select CLONE_BACKWARDS
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select DCACHE_WORD_ACCESS if HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select GENERIC_ALLOCATOR
 	select GENERIC_ATOMIC64 if (CPU_V7M || CPU_V6 || !CPU_32v6K || !AEABI)
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select GENERIC_IDLE_POLL_SETUP
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 8c4c755..ad6ac3a 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -12,6 +12,7 @@
 #include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/genalloc.h>
 #include <linux/gfp.h>
 #include <linux/errno.h>
 #include <linux/list.h>
@@ -314,23 +315,13 @@ static void __dma_free_remap(void *cpu_addr, size_t size)
 }
 
 #define DEFAULT_DMA_COHERENT_POOL_SIZE	SZ_256K
+static struct gen_pool *atomic_pool;
 
-struct dma_pool {
-	size_t size;
-	spinlock_t lock;
-	unsigned long *bitmap;
-	unsigned long nr_pages;
-	void *vaddr;
-	struct page **pages;
-};
-
-static struct dma_pool atomic_pool = {
-	.size = DEFAULT_DMA_COHERENT_POOL_SIZE,
-};
+static size_t atomic_pool_size = DEFAULT_DMA_COHERENT_POOL_SIZE;
 
 static int __init early_coherent_pool(char *p)
 {
-	atomic_pool.size = memparse(p, &p);
+	atomic_pool_size = memparse(p, &p);
 	return 0;
 }
 early_param("coherent_pool", early_coherent_pool);
@@ -340,14 +331,14 @@ void __init init_dma_coherent_pool_size(unsigned long size)
 	/*
 	 * Catch any attempt to set the pool size too late.
 	 */
-	BUG_ON(atomic_pool.vaddr);
+	BUG_ON(atomic_pool);
 
 	/*
 	 * Set architecture specific coherent pool size only if
 	 * it has not been changed by kernel command line parameter.
 	 */
-	if (atomic_pool.size == DEFAULT_DMA_COHERENT_POOL_SIZE)
-		atomic_pool.size = size;
+	if (atomic_pool_size == DEFAULT_DMA_COHERENT_POOL_SIZE)
+		atomic_pool_size = size;
 }
 
 /*
@@ -355,52 +346,44 @@ void __init init_dma_coherent_pool_size(unsigned long size)
  */
 static int __init atomic_pool_init(void)
 {
-	struct dma_pool *pool = &atomic_pool;
 	pgprot_t prot = pgprot_dmacoherent(PAGE_KERNEL);
 	gfp_t gfp = GFP_KERNEL | GFP_DMA;
-	unsigned long nr_pages = pool->size >> PAGE_SHIFT;
-	unsigned long *bitmap;
 	struct page *page;
-	struct page **pages;
 	void *ptr;
-	int bitmap_size = BITS_TO_LONGS(nr_pages) * sizeof(long);
-
-	bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!bitmap)
-		goto no_bitmap;
 
-	pages = kzalloc(nr_pages * sizeof(struct page *), GFP_KERNEL);
-	if (!pages)
-		goto no_pages;
+	atomic_pool = gen_pool_create(PAGE_SHIFT, -1);
+	if (!atomic_pool)
+		goto out;
 
 	if (dev_get_cma_area(NULL))
-		ptr = __alloc_from_contiguous(NULL, pool->size, prot, &page,
-					      atomic_pool_init);
+		ptr = __alloc_from_contiguous(NULL, atomic_pool_size, prot,
+					      &page, atomic_pool_init);
 	else
-		ptr = __alloc_remap_buffer(NULL, pool->size, gfp, prot, &page,
-					   atomic_pool_init);
+		ptr = __alloc_remap_buffer(NULL, atomic_pool_size, gfp, prot,
+					   &page, atomic_pool_init);
 	if (ptr) {
-		int i;
-
-		for (i = 0; i < nr_pages; i++)
-			pages[i] = page + i;
-
-		spin_lock_init(&pool->lock);
-		pool->vaddr = ptr;
-		pool->pages = pages;
-		pool->bitmap = bitmap;
-		pool->nr_pages = nr_pages;
-		pr_info("DMA: preallocated %u KiB pool for atomic coherent allocations\n",
-		       (unsigned)pool->size / 1024);
+		int ret;
+
+		ret = gen_pool_add_virt(atomic_pool, (unsigned long)ptr,
+					page_to_phys(page),
+					atomic_pool_size, -1);
+		if (ret)
+			goto destroy_genpool;
+
+		gen_pool_set_algo(atomic_pool,
+				gen_pool_first_fit_order_align,
+				(void *)PAGE_SHIFT);
+		pr_info("DMA: preallocated %zd KiB pool for atomic coherent allocations\n",
+		       atomic_pool_size / 1024);
 		return 0;
 	}
 
-	kfree(pages);
-no_pages:
-	kfree(bitmap);
-no_bitmap:
-	pr_err("DMA: failed to allocate %u KiB pool for atomic coherent allocation\n",
-	       (unsigned)pool->size / 1024);
+destroy_genpool:
+	gen_pool_destroy(atomic_pool);
+	atomic_pool = NULL;
+out:
+	pr_err("DMA: failed to allocate %zx KiB pool for atomic coherent allocation\n",
+	       atomic_pool_size / 1024);
 	return -ENOMEM;
 }
 /*
@@ -495,76 +478,36 @@ static void *__alloc_remap_buffer(struct device *dev, size_t size, gfp_t gfp,
 
 static void *__alloc_from_pool(size_t size, struct page **ret_page)
 {
-	struct dma_pool *pool = &atomic_pool;
-	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	unsigned int pageno;
-	unsigned long flags;
+	unsigned long val;
 	void *ptr = NULL;
-	unsigned long align_mask;
 
-	if (!pool->vaddr) {
+	if (!atomic_pool) {
 		WARN(1, "coherent pool not initialised!\n");
 		return NULL;
 	}
 
-	/*
-	 * Align the region allocation - allocations from pool are rather
-	 * small, so align them to their order in pages, minimum is a page
-	 * size. This helps reduce fragmentation of the DMA space.
-	 */
-	align_mask = (1 << get_order(size)) - 1;
-
-	spin_lock_irqsave(&pool->lock, flags);
-	pageno = bitmap_find_next_zero_area(pool->bitmap, pool->nr_pages,
-					    0, count, align_mask);
-	if (pageno < pool->nr_pages) {
-		bitmap_set(pool->bitmap, pageno, count);
-		ptr = pool->vaddr + PAGE_SIZE * pageno;
-		*ret_page = pool->pages[pageno];
-	} else {
-		pr_err_once("ERROR: %u KiB atomic DMA coherent pool is too small!\n"
-			    "Please increase it with coherent_pool= kernel parameter!\n",
-			    (unsigned)pool->size / 1024);
+	val = gen_pool_alloc(atomic_pool, size);
+	if (val) {
+		phys_addr_t phys = gen_pool_virt_to_phys(atomic_pool, val);
+
+		*ret_page = phys_to_page(phys);
+		ptr = (void *)val;
 	}
-	spin_unlock_irqrestore(&pool->lock, flags);
 
 	return ptr;
 }
 
 static bool __in_atomic_pool(void *start, size_t size)
 {
-	struct dma_pool *pool = &atomic_pool;
-	void *end = start + size;
-	void *pool_start = pool->vaddr;
-	void *pool_end = pool->vaddr + pool->size;
-
-	if (start < pool_start || start >= pool_end)
-		return false;
-
-	if (end <= pool_end)
-		return true;
-
-	WARN(1, "Wrong coherent size(%p-%p) from atomic pool(%p-%p)\n",
-	     start, end - 1, pool_start, pool_end - 1);
-
-	return false;
+	return addr_in_gen_pool(atomic_pool, (unsigned long)start, size);
 }
 
 static int __free_from_pool(void *start, size_t size)
 {
-	struct dma_pool *pool = &atomic_pool;
-	unsigned long pageno, count;
-	unsigned long flags;
-
 	if (!__in_atomic_pool(start, size))
 		return 0;
 
-	pageno = (start - pool->vaddr) >> PAGE_SHIFT;
-	count = size >> PAGE_SHIFT;
-
-	spin_lock_irqsave(&pool->lock, flags);
-	bitmap_clear(pool->bitmap, pageno, count);
-	spin_unlock_irqrestore(&pool->lock, flags);
+	gen_pool_free(atomic_pool, (unsigned long)start, size);
 
 	return 1;
 }
@@ -1307,11 +1250,13 @@ static int __iommu_remove_mapping(struct device *dev, dma_addr_t iova, size_t si
 
 static struct page **__atomic_get_pages(void *addr)
 {
-	struct dma_pool *pool = &atomic_pool;
-	struct page **pages = pool->pages;
-	int offs = (addr - pool->vaddr) >> PAGE_SHIFT;
+	struct page *page;
+	phys_addr_t phys;
+
+	phys = gen_pool_virt_to_phys(atomic_pool, (unsigned long)addr);
+	page = phys_to_page(phys);
 
-	return pages + offs;
+	return (struct page **)page;
 }
 
 static struct page **__iommu_get_pages(void *cpu_addr, struct dma_attrs *attrs)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

