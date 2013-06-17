Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab3FQWDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:03:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:5814 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab3FQWDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:03:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="256348287"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] thp: define HPAGE_PMD_* constans as BUILD_BUG() if !THP
Date: Tue, 18 Jun 2013 01:05:40 +0300
Message-Id: <1371506740-14606-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Currently, HPAGE_PMD_* constans rely on PMD_SHIFT regardless of
CONFIG_TRANSPARENT_HUGEPAGE. PMD_SHIFT is not defined everywhere (e.g.
arm nommu case).

It means we can't use anything like this in generic code:

        if (PageTransHuge(page))
                zero_huge_user(page, 0, HPAGE_PMD_SIZE);
        else
                clear_highpage(page);

For !THP case, PageTransHuge() is 0 and compiler can eliminate
zero_huge_user() call. But it still need to be valid C expression, means
HPAGE_PMD_SIZE has to expand to something compiler can understand.

Previously, HPAGE_PMD_* were defined to BUILD_BUG() for !THP. Let's come
back to it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/huge_mm.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

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
1.8.3.1

