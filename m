Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbaIOWpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:45:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51108 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939AbaIOWSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:18:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 023/187] sparc64: Use 'ILOG2_4MB' instead of constant '22'.
Date: Mon, 15 Sep 2014 15:07:13 -0700
Message-Id: <1410818997-9432-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 0eef331a3d0ee970dcbebd1bd5fcb57ca33ece01 ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/pgtable_64.h |  2 +-
 arch/sparc/kernel/head_64.S         |  4 ++--
 arch/sparc/kernel/ktlb.S            |  2 +-
 arch/sparc/mm/init_64.c             | 12 ++++++------
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index ff97960..0ad0a12 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -918,7 +918,7 @@ static inline bool kern_addr_valid(unsigned long addr)
 
 	if ((paddr >> MAX_PHYS_ADDRESS_BITS) != 0UL)
 		return false;
-	return test_bit(paddr >> 22, sparc64_valid_addr_bitmap);
+	return test_bit(paddr >> ILOG2_4MB, sparc64_valid_addr_bitmap);
 }
 
 extern int page_in_phys_avail(unsigned long paddr);
diff --git a/arch/sparc/kernel/head_64.S b/arch/sparc/kernel/head_64.S
index 26b706a..452f04f 100644
--- a/arch/sparc/kernel/head_64.S
+++ b/arch/sparc/kernel/head_64.S
@@ -282,8 +282,8 @@ sun4v_chip_type:
 	stx	%l2, [%l4 + 0x0]
 	ldx	[%sp + 2047 + 128 + 0x50], %l3	! physaddr low
 	/* 4MB align */
-	srlx	%l3, 22, %l3
-	sllx	%l3, 22, %l3
+	srlx	%l3, ILOG2_4MB, %l3
+	sllx	%l3, ILOG2_4MB, %l3
 	stx	%l3, [%l4 + 0x8]
 
 	/* Leave service as-is, "call-method" */
diff --git a/arch/sparc/kernel/ktlb.S b/arch/sparc/kernel/ktlb.S
index 542e96a..605d492 100644
--- a/arch/sparc/kernel/ktlb.S
+++ b/arch/sparc/kernel/ktlb.S
@@ -277,7 +277,7 @@ kvmap_dtlb_load:
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 kvmap_vmemmap:
 	sub		%g4, %g5, %g5
-	srlx		%g5, 22, %g5
+	srlx		%g5, ILOG2_4MB, %g5
 	sethi		%hi(vmemmap_table), %g1
 	sllx		%g5, 3, %g5
 	or		%g1, %lo(vmemmap_table), %g1
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 5322e53..848bea7 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -588,7 +588,7 @@ static void __init remap_kernel(void)
 	int i, tlb_ent = sparc64_highest_locked_tlbent();
 
 	tte_vaddr = (unsigned long) KERNBASE;
-	phys_page = (prom_boot_mapping_phys_low >> 22UL) << 22UL;
+	phys_page = (prom_boot_mapping_phys_low >> ILOG2_4MB) << ILOG2_4MB;
 	tte_data = kern_large_tte(phys_page);
 
 	kern_locked_tte_data = tte_data;
@@ -1880,7 +1880,7 @@ void __init paging_init(void)
 
 	BUILD_BUG_ON(NR_CPUS > 4096);
 
-	kern_base = (prom_boot_mapping_phys_low >> 22UL) << 22UL;
+	kern_base = (prom_boot_mapping_phys_low >> ILOG2_4MB) << ILOG2_4MB;
 	kern_size = (unsigned long)&_end - (unsigned long)KERNBASE;
 
 	/* Invalidate both kernel TSBs.  */
@@ -1936,7 +1936,7 @@ void __init paging_init(void)
 	shift = kern_base + PAGE_OFFSET - ((unsigned long)KERNBASE);
 
 	real_end = (unsigned long)_end;
-	num_kernel_image_mappings = DIV_ROUND_UP(real_end - KERNBASE, 1 << 22);
+	num_kernel_image_mappings = DIV_ROUND_UP(real_end - KERNBASE, 1 << ILOG2_4MB);
 	printk("Kernel: Using %d locked TLB entries for main kernel image.\n",
 	       num_kernel_image_mappings);
 
@@ -2093,7 +2093,7 @@ static void __init setup_valid_addr_bitmap_from_pavail(unsigned long *bitmap)
 
 				if (new_start <= old_start &&
 				    new_end >= (old_start + PAGE_SIZE)) {
-					set_bit(old_start >> 22, bitmap);
+					set_bit(old_start >> ILOG2_4MB, bitmap);
 					goto do_next_page;
 				}
 			}
@@ -2142,7 +2142,7 @@ void __init mem_init(void)
 	addr = PAGE_OFFSET + kern_base;
 	last = PAGE_ALIGN(kern_size) + addr;
 	while (addr < last) {
-		set_bit(__pa(addr) >> 22, sparc64_valid_addr_bitmap);
+		set_bit(__pa(addr) >> ILOG2_4MB, sparc64_valid_addr_bitmap);
 		addr += PAGE_SIZE;
 	}
 
@@ -2266,7 +2266,7 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 		void *block;
 
 		if (!(*vmem_pp & _PAGE_VALID)) {
-			block = vmemmap_alloc_block(1UL << 22, node);
+			block = vmemmap_alloc_block(1UL << ILOG2_4MB, node);
 			if (!block)
 				return -ENOMEM;
 
-- 
1.9.1

