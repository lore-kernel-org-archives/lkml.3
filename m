Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbaGVTDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:03:03 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45341 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbaGVTBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:01:31 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5/8] xtensa: support aliasing cache in k[un]map_atomic
Date: Tue, 22 Jul 2014 23:01:10 +0400
Message-Id: <1406055673-10100-6-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
References: <1406055673-10100-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Map high memory pages at virtual addresses with color that match color
of their physical address. Existing cache alias management mechanisms
may be used with such pages.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/include/asm/fixmap.h |  3 ++-
 arch/xtensa/include/asm/page.h   |  2 ++
 arch/xtensa/mm/highmem.c         | 17 ++++++++++-------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/xtensa/include/asm/fixmap.h b/arch/xtensa/include/asm/fixmap.h
index a43cd52..62b507d 100644
--- a/arch/xtensa/include/asm/fixmap.h
+++ b/arch/xtensa/include/asm/fixmap.h
@@ -38,7 +38,8 @@ enum fixed_addresses {
 #ifdef CONFIG_HIGHMEM
 	/* reserved pte's for temporary kernel mappings */
 	FIX_KMAP_BEGIN,
-	FIX_KMAP_END = FIX_KMAP_BEGIN + (KM_TYPE_NR * NR_CPUS) - 1,
+	FIX_KMAP_END = FIX_KMAP_BEGIN +
+		(KM_TYPE_NR * NR_CPUS * DCACHE_N_COLORS) - 1,
 #endif
 	__end_of_fixed_addresses
 };
diff --git a/arch/xtensa/include/asm/page.h b/arch/xtensa/include/asm/page.h
index 11721cc..abe24c6 100644
--- a/arch/xtensa/include/asm/page.h
+++ b/arch/xtensa/include/asm/page.h
@@ -78,7 +78,9 @@
 # define DCACHE_ALIAS_EQ(a,b)	((((a) ^ (b)) & DCACHE_ALIAS_MASK) == 0)
 #else
 # define DCACHE_ALIAS_ORDER	0
+# define DCACHE_ALIAS(a)	((void)(a), 0)
 #endif
+#define DCACHE_N_COLORS		(1 << DCACHE_ALIAS_ORDER)
 
 #if ICACHE_WAY_SIZE > PAGE_SIZE
 # define ICACHE_ALIAS_ORDER	(ICACHE_WAY_SHIFT - PAGE_SHIFT)
diff --git a/arch/xtensa/mm/highmem.c b/arch/xtensa/mm/highmem.c
index 2e95a76..466abae 100644
--- a/arch/xtensa/mm/highmem.c
+++ b/arch/xtensa/mm/highmem.c
@@ -14,18 +14,23 @@
 
 static pte_t *kmap_pte;
 
+static inline enum fixed_addresses kmap_idx(int type, unsigned long color)
+{
+	return (type + KM_TYPE_NR * smp_processor_id()) * DCACHE_N_COLORS +
+		color;
+}
+
 void *kmap_atomic(struct page *page)
 {
 	enum fixed_addresses idx;
 	unsigned long vaddr;
-	int type;
 
 	pagefault_disable();
 	if (!PageHighMem(page))
 		return page_address(page);
 
-	type = kmap_atomic_idx_push();
-	idx = type + KM_TYPE_NR * smp_processor_id();
+	idx = kmap_idx(kmap_atomic_idx_push(),
+		       DCACHE_ALIAS(page_to_phys(page)));
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
 	BUG_ON(!pte_none(*(kmap_pte + idx)));
@@ -38,12 +43,10 @@ EXPORT_SYMBOL(kmap_atomic);
 
 void __kunmap_atomic(void *kvaddr)
 {
-	int idx, type;
-
 	if (kvaddr >= (void *)FIXADDR_START &&
 	    kvaddr < (void *)FIXADDR_TOP) {
-		type = kmap_atomic_idx();
-		idx = type + KM_TYPE_NR * smp_processor_id();
+		int idx = kmap_idx(kmap_atomic_idx(),
+				   DCACHE_ALIAS((unsigned long)kvaddr));
 
 		/*
 		 * Force other mappings to Oops if they'll try to access this
-- 
1.8.1.4

