Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbaGVTC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:02:28 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40635 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbaGVTBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:01:36 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 8/8] xtensa: support highmem in aliasing cache flushing code
Date: Tue, 22 Jul 2014 23:01:13 +0400
Message-Id: <1406055673-10100-9-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
References: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __flush_invalidate_dcache_page_alias with alias set to color of the
page physical address instead of __flush_invalidate_dcache_page: this
works for high memory pages and mapping/unmapping to the TLBTEMP area is
virtually free.

Allow building configurations with aliasing cache and highmem enabled.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/mm/cache.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/xtensa/mm/cache.c b/arch/xtensa/mm/cache.c
index 96aea66..d75aa14 100644
--- a/arch/xtensa/mm/cache.c
+++ b/arch/xtensa/mm/cache.c
@@ -59,10 +59,6 @@
  *
  */
 
-#if (DCACHE_WAY_SIZE > PAGE_SIZE) && defined(CONFIG_HIGHMEM)
-#error "HIGHMEM is not supported on cores with aliasing cache."
-#endif
-
 #if (DCACHE_WAY_SIZE > PAGE_SIZE)
 static inline void kmap_invalidate_coherent(struct page *page,
 					    unsigned long vaddr)
@@ -166,7 +162,8 @@ void flush_dcache_page(struct page *page)
 		if (!alias && !mapping)
 			return;
 
-		__flush_invalidate_dcache_page((long)page_address(page));
+		virt = TLBTEMP_BASE_1 + (phys & DCACHE_ALIAS_MASK);
+		__flush_invalidate_dcache_page_alias(virt, phys);
 
 		virt = TLBTEMP_BASE_1 + (temp & DCACHE_ALIAS_MASK);
 
@@ -231,13 +228,12 @@ update_mmu_cache(struct vm_area_struct * vma, unsigned long addr, pte_t *ptep)
 #if (DCACHE_WAY_SIZE > PAGE_SIZE) && XCHAL_DCACHE_IS_WRITEBACK
 
 	if (!PageReserved(page) && test_bit(PG_arch_1, &page->flags)) {
-
-		unsigned long paddr = (unsigned long) page_address(page);
 		unsigned long phys = page_to_phys(page);
-		unsigned long tmp = TLBTEMP_BASE_1 + (addr & DCACHE_ALIAS_MASK);
-
-		__flush_invalidate_dcache_page(paddr);
+		unsigned long tmp;
 
+		tmp = TLBTEMP_BASE_1 + (phys & DCACHE_ALIAS_MASK);
+		__flush_invalidate_dcache_page_alias(tmp, phys);
+		tmp = TLBTEMP_BASE_1 + (addr & DCACHE_ALIAS_MASK);
 		__flush_invalidate_dcache_page_alias(tmp, phys);
 		__invalidate_icache_page_alias(tmp, phys);
 
-- 
1.8.1.4

