Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaKFXKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:10:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58750 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaKFWlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 053/162] sparc64: Kill unnecessary tables and increase MAX_BANKS.
Date: Thu,  6 Nov 2014 14:35:17 -0800
Message-Id: <1415313426-9622-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit d195b71bad4347d2df51072a537f922546a904f1 ]

swapper_low_pmd_dir and swapper_pud_dir are actually completely
useless and unnecessary.

We just need swapper_pg_dir[].  Naturally the other page table chunks
will be allocated on an as-needed basis.  Since the kernel actually
accesses these tables in the PAGE_OFFSET view, there is not even a TLB
locality advantage of placing them in the kernel image.

Use the hard coded vmlinux.ld.S slot for swapper_pg_dir which is
naturally page aligned.

Increase MAX_BANKS to 1024 in order to handle heavily fragmented
virtual guests.

Even with this MAX_BANKS increase, the kernel is 20K+ smaller.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Bob Picco <bob.picco@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/pgtable_64.h |  1 -
 arch/sparc/kernel/vmlinux.lds.S     |  5 +++--
 arch/sparc/mm/init_64.c             | 25 ++-----------------------
 3 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index ad1def4..e8dfabf 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -927,7 +927,6 @@ static inline void __set_pte_at(struct mm_struct *mm, unsigned long addr,
 #endif
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
-extern pmd_t swapper_low_pmd_dir[PTRS_PER_PMD];
 
 extern void paging_init(void);
 extern unsigned long find_ecache_flush_span(unsigned long size);
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index 0bacceb..0924305 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -35,8 +35,9 @@ jiffies = jiffies_64;
 
 SECTIONS
 {
-	/* swapper_low_pmd_dir is sparc64 only */
-	swapper_low_pmd_dir = 0x0000000000402000;
+#ifdef CONFIG_SPARC64
+	swapper_pg_dir = 0x0000000000402000;
+#endif
 	. = INITIAL_ADDRESS;
 	.text TEXTSTART :
 	{
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index ca634b3..39c52fc 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -85,7 +85,7 @@ extern struct tsb swapper_tsb[KERNEL_TSB_NENTRIES];
 
 static unsigned long cpu_pgsz_mask;
 
-#define MAX_BANKS	32
+#define MAX_BANKS	1024
 
 static struct linux_prom64_registers pavail[MAX_BANKS];
 static int pavail_ents;
@@ -1936,12 +1936,6 @@ static void __init sun4v_linear_pte_xor_finalize(void)
 
 static unsigned long last_valid_pfn;
 
-/* These must be page aligned in order to not trigger the
- * alignment tests of pgd_bad() and pud_bad().
- */
-pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__ ((aligned (PAGE_SIZE)));
-static pud_t swapper_pud_dir[PTRS_PER_PUD] __attribute__ ((aligned (PAGE_SIZE)));
-
 static void sun4u_pgprot_init(void);
 static void sun4v_pgprot_init(void);
 
@@ -1949,8 +1943,6 @@ void __init paging_init(void)
 {
 	unsigned long end_pfn, shift, phys_base;
 	unsigned long real_end, i;
-	pud_t *pud;
-	pmd_t *pmd;
 	int node;
 
 	setup_page_offset();
@@ -2045,20 +2037,7 @@ void __init paging_init(void)
 	 */
 	init_mm.pgd += ((shift) / (sizeof(pgd_t)));
 	
-	memset(swapper_low_pmd_dir, 0, sizeof(swapper_low_pmd_dir));
-
-	/* The kernel page tables we publish into what the rest of the
-	 * world sees must be adjusted so that they see the PAGE_OFFSET
-	 * address of these in-kerenel data structures.  However right
-	 * here we must access them from the kernel image side, because
-	 * the trap tables haven't been taken over and therefore we cannot
-	 * take TLB misses in the PAGE_OFFSET linear mappings yet.
-	 */
-	pud = swapper_pud_dir + (shift / sizeof(pud_t));
-	pgd_set(&swapper_pg_dir[0], pud);
-
-	pmd = swapper_low_pmd_dir + (shift / sizeof(pmd_t));
-	pud_set(&swapper_pud_dir[0], pmd);
+	memset(swapper_pg_dir, 0, sizeof(swapper_pg_dir));
 
 	inherit_prom_mappings();
 	
-- 
1.9.1

