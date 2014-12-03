Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaLCPHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:07:31 -0500
Received: from smtp-out-200.synserver.de ([212.40.185.200]:1073 "EHLO
	smtp-out-200.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaLCPHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:07:30 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31773
From: Lars-Peter Clausen <lars@metafoo.de>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] microblaze: Fix mmap for cache coherent memory
Date: Wed,  3 Dec 2014 16:07:28 +0100
Message-Id: <1417619248-20365-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running in non-cache coherent configuration the memory that was
allocated with dma_alloc_coherent() has a custom mapping and so there is no
1-to-1 relationship between the kernel virtual address and the PFN. This
means that virt_to_pfn() will not work correctly for those addresses and the
default mmap implementation in the form of dma_common_mmap() will map some
random, but not the requested, memory area.

Fix this by providing a custom mmap implementation that looks up the PFN
from the page table rather than using virt_to_pfn.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/microblaze/include/asm/pgtable.h |  1 +
 arch/microblaze/kernel/dma.c          | 26 ++++++++++++++++++++++++++
 arch/microblaze/mm/consistent.c       | 23 ++++++++++++++++++-----
 3 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/arch/microblaze/include/asm/pgtable.h b/arch/microblaze/include/asm/pgtable.h
index 95cef0b..df19d0c 100644
--- a/arch/microblaze/include/asm/pgtable.h
+++ b/arch/microblaze/include/asm/pgtable.h
@@ -565,6 +565,7 @@ void consistent_free(size_t size, void *vaddr);
 void consistent_sync(void *vaddr, size_t size, int direction);
 void consistent_sync_page(struct page *page, unsigned long offset,
 	size_t size, int direction);
+unsigned long consistent_virt_to_pfn(void *vaddr);
 
 void setup_memory(void);
 #endif /* __ASSEMBLY__ */
diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.c
index 4633c36..4822367 100644
--- a/arch/microblaze/kernel/dma.c
+++ b/arch/microblaze/kernel/dma.c
@@ -154,9 +154,35 @@ dma_direct_sync_sg_for_device(struct device *dev,
 			__dma_sync(sg->dma_address, sg->length, direction);
 }
 
+int dma_direct_mmap_coherent(struct device *dev, struct vm_area_struct *vma,
+			     void *cpu_addr, dma_addr_t handle, size_t size,
+			     struct dma_attrs *attrs)
+{
+	unsigned long user_count = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	unsigned long off = vma->vm_pgoff;
+	unsigned long pfn;
+
+	if (!IS_ENABLED(CONFIG_MMU))
+		return -ENXIO;
+
+	if (off >= count || user_count > (count - off))
+		return -ENXIO;
+
+#ifdef NOT_COHERENT_CACHE
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	pfn = consistent_virt_to_pfn(cpu_addr);
+#else
+	pfn = virt_to_pfn(cpu_addr);
+#endif
+	return remap_pfn_range(vma, vma->vm_start, pfn + off,
+			       vma->vm_end - vma->vm_start, vma->vm_page_prot);
+}
+
 struct dma_map_ops dma_direct_ops = {
 	.alloc		= dma_direct_alloc_coherent,
 	.free		= dma_direct_free_coherent,
+	.mmap		= dma_direct_mmap_coherent,
 	.map_sg		= dma_direct_map_sg,
 	.dma_supported	= dma_direct_dma_supported,
 	.map_page	= dma_direct_map_page,
diff --git a/arch/microblaze/mm/consistent.c b/arch/microblaze/mm/consistent.c
index e10ad93..f358cd2 100644
--- a/arch/microblaze/mm/consistent.c
+++ b/arch/microblaze/mm/consistent.c
@@ -156,6 +156,23 @@ void *consistent_alloc(gfp_t gfp, size_t size, dma_addr_t *dma_handle)
 }
 EXPORT_SYMBOL(consistent_alloc);
 
+static pte_t *consistent_virt_to_pte(void *vaddr)
+{
+	unsigned long addr = (unsigned long)vaddr;
+
+	return pte_offset_kernel(pmd_offset(pgd_offset_k(addr), addr), addr);
+}
+
+unsigned long consistent_virt_to_pfn(void *vaddr)
+{
+	pte_t *ptep = consistent_virt_to_pte(vaddr);
+
+	if (pte_none(*ptep) || !pte_present(*ptep))
+		return 0;
+
+	return pte_pfn(*ptep);
+}
+
 /*
  * free page(s) as defined by the above mapping.
  */
@@ -181,13 +198,9 @@ void consistent_free(size_t size, void *vaddr)
 	} while (size -= PAGE_SIZE);
 #else
 	do {
-		pte_t *ptep;
+		pte_t *ptep = consistent_virt_to_pte(vaddr);
 		unsigned long pfn;
 
-		ptep = pte_offset_kernel(pmd_offset(pgd_offset_k(
-						(unsigned int)vaddr),
-					(unsigned int)vaddr),
-				(unsigned int)vaddr);
 		if (!pte_none(*ptep) && pte_present(*ptep)) {
 			pfn = pte_pfn(*ptep);
 			pte_clear(&init_mm, (unsigned int)vaddr, ptep);
-- 
1.8.0

