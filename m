Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3KLTnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:43:46 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:34696 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab3KLTml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:42:41 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 10/17] tile: Remove tile-specific _sinitdata and _einitdata
Date: Tue, 12 Nov 2013 20:42:20 +0100
Message-Id: <1384285347-13506-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard __init_begin and __init_end instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/sections.h |    3 ---
 arch/tile/kernel/vmlinux.lds.S   |    2 --
 arch/tile/mm/init.c              |   18 +++++++++---------
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/tile/include/asm/sections.h b/arch/tile/include/asm/sections.h
index 5d5d3b739a6b..86a746243dc8 100644
--- a/arch/tile/include/asm/sections.h
+++ b/arch/tile/include/asm/sections.h
@@ -19,9 +19,6 @@
 
 #include <asm-generic/sections.h>
 
-/* Text and data are at different areas in the kernel VA space. */
-extern char _sinitdata[], _einitdata[];
-
 /* Write-once data is writable only till the end of initialization. */
 extern char __w1data_begin[], __w1data_end[];
 
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index f1819423ffc9..0e059a0101ea 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -66,11 +66,9 @@ SECTIONS
 
   . = ALIGN(PAGE_SIZE);
   __init_begin = .;
-  VMLINUX_SYMBOL(_sinitdata) = .;
   INIT_DATA_SECTION(16) :data =0
   PERCPU_SECTION(L2_CACHE_BYTES)
   . = ALIGN(PAGE_SIZE);
-  VMLINUX_SYMBOL(_einitdata) = .;
   __init_end = .;
 
   _sdata = .;                   /* Start of data section */
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 0fa1acfac79a..c4e0b6ddb48c 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -254,7 +254,7 @@ static pgprot_t __init init_pgprot(ulong address)
 	 * Everything else that isn't data or bss is heap, so mark it
 	 * with the initial heap home (hash-for-home, or this cpu).  This
 	 * includes any addresses after the loaded image and any address before
-	 * _einitdata, since we already captured the case of text before
+	 * __init_end, since we already captured the case of text before
 	 * _sinittext, and __pa(einittext) is approximately __pa(sinitdata).
 	 *
 	 * All the LOWMEM pages that we mark this way will get their
@@ -263,7 +263,7 @@ static pgprot_t __init init_pgprot(ulong address)
 	 * homes, but with a zero free_time we don't have to actually
 	 * do a flush action the first time we use them, either.
 	 */
-	if (address >= (ulong) _end || address < (ulong) _einitdata)
+	if (address >= (ulong) _end || address < (ulong) __init_end)
 		return construct_pgprot(PAGE_KERNEL, initial_heap_home());
 
 	/* Use hash-for-home if requested for data/bss. */
@@ -534,7 +534,7 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 
 		BUG_ON(address != (unsigned long)_text);
 		pte = NULL;
-		for (; address < (unsigned long)_einittext;
+		for (; address < (unsigned long)__init_end;
 		     pfn++, address += PAGE_SIZE) {
 			pte_ofs = pte_index(address);
 			if (pte_ofs == 0) {
@@ -572,7 +572,7 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 		else
 			pteval = hv_pte_set_mode(pteval,
 						 HV_PTE_MODE_CACHE_NO_L3);
-		for (; address < (unsigned long)_einittext;
+		for (; address < (unsigned long)__init_end;
 		     pfn += PFN_DOWN(HPAGE_SIZE), address += HPAGE_SIZE)
 			*(pte_t *)(pmd++) = pfn_pte(pfn, pteval);
 	}
@@ -632,9 +632,9 @@ int devmem_is_allowed(unsigned long pagenr)
 {
 	return pagenr < kaddr_to_pfn(_end) &&
 		!(pagenr >= kaddr_to_pfn(&init_thread_union) ||
-		  pagenr < kaddr_to_pfn(_einitdata)) &&
+		  pagenr < kaddr_to_pfn(__init_end)) &&
 		!(pagenr >= kaddr_to_pfn(_sinittext) ||
-		  pagenr <= kaddr_to_pfn(_einittext-1));
+		  pagenr <= kaddr_to_pfn(__init_end-1));
 }
 
 #ifdef CONFIG_HIGHMEM
@@ -975,8 +975,8 @@ void free_initmem(void)
 
 	/* Free the data pages that we won't use again after init. */
 	free_init_pages("unused kernel data",
-			(unsigned long)_sinitdata,
-			(unsigned long)_einitdata);
+			(unsigned long)__init_begin,
+			(unsigned long)__init_end);
 
 	/*
 	 * Free the pages mapped from 0xc0000000 that correspond to code
@@ -984,7 +984,7 @@ void free_initmem(void)
 	 */
 	free_init_pages("unused kernel text",
 			(unsigned long)_sinittext - text_delta,
-			(unsigned long)_einittext - text_delta);
+			(unsigned long)__init_end - text_delta);
 	/* Do a global TLB flush so everyone sees the changes. */
 	flush_tlb_all();
 }
-- 
1.7.9.5

