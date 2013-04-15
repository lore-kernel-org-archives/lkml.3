Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375Ab3DOCoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:44:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934326Ab3DOCoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:44:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Artem S Tashkinov <t.artem@mailcity.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 20/27] x86-32: Fix possible incomplete TLB invalidate with PAE pagetables
Date: Sun, 14 Apr 2013 19:43:19 -0700
Message-Id: <20130415024232.853890094@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave@sr71.net>

commit 1de14c3c5cbc9bb17e9dcc648cda51c0c85d54b9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/tlb.h |    2 +-
 arch/x86/mm/pgtable.c      |    7 +++++++
 include/asm-generic/tlb.h  |    7 ++++++-
 mm/memory.c                |    1 +
 4 files changed, 15 insertions(+), 2 deletions(-)

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
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -58,6 +58,13 @@ void ___pte_free_tlb(struct mmu_gather *
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
 
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -99,7 +99,12 @@ struct mmu_gather {
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
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -212,6 +212,7 @@ void tlb_gather_mmu(struct mmu_gather *t
 	tlb->mm = mm;
 
 	tlb->fullmm     = fullmm;
+	tlb->need_flush_all = 0;
 	tlb->start	= -1UL;
 	tlb->end	= 0;
 	tlb->need_flush = 0;


