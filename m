Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934650Ab3CNRuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:50:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:52060 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934615Ab3CNRt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:49:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,845,1355126400"; 
   d="scan'208";a="279559823"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2, RFC 28/30] thp: handle write-protect exception to file-backed huge pages
Date: Thu, 14 Mar 2013 19:50:33 +0200
Message-Id: <1363283435-7666-29-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/huge_memory.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d1adaea..a416a77 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1339,7 +1339,6 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 
-	VM_BUG_ON(!vma->anon_vma);
 	haddr = address & HPAGE_PMD_MASK;
 	if (is_huge_zero_pmd(orig_pmd))
 		goto alloc;
@@ -1349,7 +1348,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	page = pmd_page(orig_pmd);
 	VM_BUG_ON(!PageCompound(page) || !PageHead(page));
-	if (page_mapcount(page) == 1) {
+	if (PageAnon(page) && page_mapcount(page) == 1) {
 		pmd_t entry;
 		entry = pmd_mkyoung(orig_pmd);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
@@ -1357,10 +1356,72 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			update_mmu_cache_pmd(vma, address, pmd);
 		ret |= VM_FAULT_WRITE;
 		goto out_unlock;
+	} else if ((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
+			(VM_WRITE|VM_SHARED)) {
+		struct vm_fault vmf;
+		pmd_t entry;
+		struct address_space *mapping;
+
+		/* not yet impemented */
+		VM_BUG_ON(!vma->vm_ops || !vma->vm_ops->page_mkwrite);
+
+		vmf.virtual_address = (void __user *)haddr;
+		vmf.pgoff = page->index;
+		vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
+		vmf.page = page;
+
+		page_cache_get(page);
+		spin_unlock(&mm->page_table_lock);
+
+		ret = vma->vm_ops->page_mkwrite(vma, &vmf);
+		if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
+			page_cache_release(page);
+			goto out;
+		}
+		if (unlikely(!(ret & VM_FAULT_LOCKED))) {
+			lock_page(page);
+			if (!page->mapping) {
+				ret = 0; /* retry */
+				unlock_page(page);
+				page_cache_release(page);
+				goto out;
+			}
+		} else
+			VM_BUG_ON(!PageLocked(page));
+		spin_lock(&mm->page_table_lock);
+		if (unlikely(!pmd_same(*pmd, orig_pmd))) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto out_unlock;
+		}
+
+		flush_cache_page(vma, address, pmd_pfn(orig_pmd));
+		entry = pmd_mkyoung(orig_pmd);
+		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+		if (pmdp_set_access_flags(vma, haddr, pmd, entry,  1))
+			update_mmu_cache_pmd(vma, address, pmd);
+		ret = VM_FAULT_WRITE;
+		spin_unlock(&mm->page_table_lock);
+
+		mapping = page->mapping;
+		set_page_dirty(page);
+		unlock_page(page);
+		page_cache_release(page);
+		if (mapping)	{
+			/*
+			 * Some device drivers do not set page.mapping
+			 * but still dirty their pages
+			 */
+			balance_dirty_pages_ratelimited(mapping);
+		}
+		return ret;
 	}
 	get_page(page);
 	spin_unlock(&mm->page_table_lock);
 alloc:
+	if (unlikely(anon_vma_prepare(vma)))
+		return VM_FAULT_OOM;
+
 	if (transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow())
 		new_page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
@@ -1424,6 +1485,10 @@ alloc:
 			add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
 			put_huge_zero_page();
 		} else {
+			if (!PageAnon(page)) {
+				add_mm_counter(mm, MM_FILEPAGES, -HPAGE_PMD_NR);
+				add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
+			}
 			VM_BUG_ON(!PageHead(page));
 			page_remove_rmap(page);
 			put_page(page);
-- 
1.7.10.4

