Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab3HGUkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:40:41 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60699 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab3HGUkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:40:39 -0400
Message-ID: <201308072040.r77KecWw016086@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 7 Aug 2013 11:07:52 -0400
Subject: [PATCH] tile: remove calls to arch_flush_lazy_mmu_mode()
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it's a no-op on tile anyway, there's no reason to be calling
it in tile-specific code.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/fault.c   | 5 ++---
 arch/tile/mm/highmem.c | 2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 7863298..502664a 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -122,10 +122,9 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 	pmd_k = pmd_offset(pud_k, address);
 	if (!pmd_present(*pmd_k))
 		return NULL;
-	if (!pmd_present(*pmd)) {
+	if (!pmd_present(*pmd))
 		set_pmd(pmd, *pmd_k);
-		arch_flush_lazy_mmu_mode();
-	} else
+	else
 		BUG_ON(pmd_ptfn(*pmd) != pmd_ptfn(*pmd_k));
 	return pmd_k;
 }
diff --git a/arch/tile/mm/highmem.c b/arch/tile/mm/highmem.c
index 347d123..0dc2182 100644
--- a/arch/tile/mm/highmem.c
+++ b/arch/tile/mm/highmem.c
@@ -114,7 +114,6 @@ static void kmap_atomic_register(struct page *page, int type,
 
 	list_add(&amp->list, &amp_list);
 	set_pte(ptep, pteval);
-	arch_flush_lazy_mmu_mode();
 
 	spin_unlock(&amp_lock);
 	homecache_kpte_unlock(flags);
@@ -259,7 +258,6 @@ void __kunmap_atomic(void *kvaddr)
 		BUG_ON(vaddr >= (unsigned long)high_memory);
 	}
 
-	arch_flush_lazy_mmu_mode();
 	pagefault_enable();
 }
 EXPORT_SYMBOL(__kunmap_atomic);
-- 
1.8.3.1

