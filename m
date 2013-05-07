Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3EGEAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:00:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5656 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760399Ab3EGD67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:59 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1PLQy-MI-7QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=srhSLCMOe8MA:10 a=NtpouL_lAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=oGMlB6cnAAAA:8 a=mbrmHoIvAAAA:8 a=Z4Rwk6OoAAAA:8 a=0AWPF2qeU-xyIF9p1esA:9 a=sx0aeZmlSPoA:10 a=CY6gl2JlH4YA:10 a=LI9Vle30uBYA:10 a=1cKoR8bf_0cA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=U1C3fMHSDAkLZqa5:21 a=IYF8zL58oypDcURz:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035849.761545681@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Artem S Tashkinov <t.artem@mailcity.com>
Subject: [053/126] x86-32: Fix possible incomplete TLB invalidate with PAE pagetables
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0053-x86-32-Fix-possible-incomplete-TLB-invalidate-with-P.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave@sr71.net>

[ Upstream commit 1de14c3c5cbc9bb17e9dcc648cda51c0c85d54b9 ]

This patch attempts to fix:

	https://bugzilla.kernel.org/show_bug.cgi?id=56461

The symptom is a crash and messages like this:

	chrome: Corrupted page table at address 34a03000
	*pdpt = 0000000000000000 *pde = 0000000000000000
	Bad pagetable: 000f [#1] PREEMPT SMP

Ingo guesses this got introduced by commit 611ae8e3f520 ("x86/tlb:
enable tlb flush range support for x86") since that code started to free
unused pagetables.

On x86-32 PAE kernels, that new code has the potential to free an entire
PMD page and will clear one of the four page-directory-pointer-table
(aka pgd_t entries).

The hardware aggressively "caches" these top-level entries and invlpg
does not actually affect the CPU's copy.  If we clear one we *HAVE* to
do a full TLB flush, otherwise we might continue using a freed pmd page.
(note, we do this properly on the population side in pud_populate()).

This patch tracks whenever we clear one of these entries in the 'struct
mmu_gather', and ensures that we follow up with a full tlb flush.

BTW, I disassembled and checked that:

	if (tlb->fullmm == 0)
and
	if (!tlb->fullmm && !tlb->need_flush_all)

generate essentially the same code, so there should be zero impact there
to the !PAE case.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Artem S Tashkinov <t.artem@mailcity.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/tlb.h |    2 +-
 arch/x86/mm/pgtable.c      |    7 +++++++
 include/asm-generic/tlb.h  |    7 ++++++-
 mm/memory.c                |    1 +
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 4fef207..c779730 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -7,7 +7,7 @@
 
 #define tlb_flush(tlb)							\
 {									\
-	if (tlb->fullmm == 0)						\
+	if (!tlb->fullmm && !tlb->need_flush_all) 			\
 		flush_tlb_mm_range(tlb->mm, tlb->start, tlb->end, 0UL);	\
 	else								\
 		flush_tlb_mm_range(tlb->mm, 0UL, TLB_FLUSH_ALL, 0UL);	\
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..eedfeed 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -58,6 +58,13 @@ void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
 	paravirt_release_pmd(__pa(pmd) >> PAGE_SHIFT);
+	/*
+	 * NOTE! For PAE, any changes to the top page-directory-pointer-table
+	 * entries need a full cr3 reload to flush.
+	 */
+#ifdef CONFIG_X86_PAE
+	tlb->need_flush_all = 1;
+#endif
 	tlb_remove_page(tlb, virt_to_page(pmd));
 }
 
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index ed6642a..54d2a6a 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -91,7 +91,12 @@ struct mmu_gather {
 	unsigned int		need_flush : 1,	/* Did free PTEs */
 				fast_mode  : 1; /* No batching   */
 
-	unsigned int		fullmm;
+	/* we are in the middle of an operation to clear
+	 * a full mm and can make some optimizations */
+	unsigned int		fullmm : 1,
+	/* we have performed an operation which
+	 * requires a complete flush of the tlb */
+				need_flush_all : 1;
 
 	struct mmu_gather_batch *active;
 	struct mmu_gather_batch	local;
diff --git a/mm/memory.c b/mm/memory.c
index 5736170..3a8b06b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -206,6 +206,7 @@ void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, bool fullmm)
 	tlb->mm = mm;
 
 	tlb->fullmm     = fullmm;
+	tlb->need_flush_all = 0;
 	tlb->start	= -1UL;
 	tlb->end	= 0;
 	tlb->need_flush = 0;
-- 
1.7.10.4


