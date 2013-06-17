Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3FQMmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:42:22 -0400
Received: from shutemov.name ([204.155.152.216]:38137 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab3FQMmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:42:20 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jun 2013 08:42:20 EDT
Date: Mon, 17 Jun 2013 16:27:46 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: + mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch
 added to -mm tree
Message-ID: <20130617132746.GA30262@shutemov.name>
References: <20130513231406.D912031C276@corp2gmr1-1.hot.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20130513231406.D912031C276@corp2gmr1-1.hot.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 13, 2013 at 04:14:06PM -0700, akpm@linux-foundation.org wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> Subject: mm/THP: don't use HPAGE_SHIFT in transparent hugepage code
> 
> For architectures like powerpc that support multiple explicit hugepage
> sizes, HPAGE_SHIFT indicate the default explicit hugepage shift.  For THP
> to work the hugepage size should be same as PMD_SIZE.  So use PMD_SHIFT
> directly.  So move the define outside CONFIG_TRANSPARENT_HUGEPAGE #ifdef
> because we want to use these defines in generic code with if
> (pmd_trans_huge()) conditional.

I would propose to partly revert the patch with the patch bellow.

Rationale: PMD_SHIFT is not defined in some configurations like nommu
(allnoconfig on ARM).

It blocks valid usecases in common code, like:

	if (PageTransHuge(page))
		do_something_with(HPAGE_PMD_SIZE);

And requires ugly ifdefs.

I also found BUILD_BUG() useful to trigger bugs earlier for !THP
configurations.

The original patch was proposed as part of THP enabling on PPC. The patch
below requires trivial adjustment for PPC THP patchset. Changes required
for V10 is attached.

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index cc276d2..e2dbefb 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -58,11 +58,12 @@ extern pmd_t *page_check_address_pmd(struct page *page,
 
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define HPAGE_PMD_SHIFT PMD_SHIFT
 #define HPAGE_PMD_SIZE	((1UL) << HPAGE_PMD_SHIFT)
 #define HPAGE_PMD_MASK	(~(HPAGE_PMD_SIZE - 1))
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 
 #define transparent_hugepage_enabled(__vma)				\
@@ -180,6 +181,9 @@ extern int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vm
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
+#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
+#define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
+#define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
 
 #define hpage_nr_pages(x) 1
 
-- 
 Kirill A. Shutemov

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=powerpc

diff --git a/arch/powerpc/mm/hash_native_64.c b/arch/powerpc/mm/hash_native_64.c
index 8eed067..3f0c30a 100644
--- a/arch/powerpc/mm/hash_native_64.c
+++ b/arch/powerpc/mm/hash_native_64.c
@@ -421,7 +421,7 @@ static void native_hugepage_invalidate(struct mm_struct *mm,
 	unsigned long hidx, vpn = 0, vsid, hash, slot;
 
 	shift = mmu_psize_defs[psize].shift;
-	max_hpte_count = HPAGE_PMD_SIZE >> shift;
+	max_hpte_count = 1U << (PMD_SHIFT - shift);
 
 	local_irq_save(flags);
 	for (i = 0; i < max_hpte_count; i++) {
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index f92ff2f..fd0f2f2 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -415,7 +415,7 @@ static void pSeries_lpar_hugepage_invalidate(struct mm_struct *mm,
 	unsigned long shift, hidx, vpn = 0, vsid, hash, slot;
 
 	shift = mmu_psize_defs[psize].shift;
-	max_hpte_count = HPAGE_PMD_SIZE >> shift;
+	max_hpte_count = 1U << (PMD_SHIFT - shift);
 
 	for (i = 0; i < max_hpte_count; i++) {
 		valid = hpte_valid(hpte_slot_array, i);

--BOKacYhQ+x31HxR3--
