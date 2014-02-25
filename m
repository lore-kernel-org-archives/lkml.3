Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaBYOSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:18:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:39086 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaBYOSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:18:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,540,1389772800"; 
   d="scan'208";a="489486770"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, willy@linux.intel.com
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v6 02/22] Allow page fault handlers to perform the COW
Date: Tue, 25 Feb 2014 09:18:18 -0500
Message-Id: <1393337918-28265-3-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently COW of an XIP file is done by first bringing in a read-only
mapping, then retrying the fault and copying the page.  It is much more
efficient to tell the fault handler that a COW is being attempted (by
passing in the pre-allocated page in the vm_fault structure), and allow
the handler to perform the COW operation itself.

Where the filemap code protects against truncation of the file until
the PTE has been installed with the page lock, the XIP code use the
i_mmap_mutex instead.  We must therefore unlock the i_mmap_mutex after
inserting the PTE.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 44 ++++++++++++++++++++++++++++++++------------
 2 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f28f46e..22260c0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -205,6 +205,7 @@ struct vm_fault {
 	pgoff_t pgoff;			/* Logical page offset based on vma */
 	void __user *virtual_address;	/* Faulting virtual address */
 
+	struct page *cow_page;		/* Handler may choose to COW */
 	struct page *page;		/* ->fault handlers should return a
 					 * page here, unless VM_FAULT_NOPAGE
 					 * is set (which is also implied by
@@ -1000,6 +1001,7 @@ static inline int page_mapped(struct page *page)
 #define VM_FAULT_HWPOISON 0x0010	/* Hit poisoned small page */
 #define VM_FAULT_HWPOISON_LARGE 0x0020  /* Hit poisoned large page. Index encoded in upper bits */
 
+#define VM_FAULT_COWED	0x0080	/* ->fault COWed the page instead */
 #define VM_FAULT_NOPAGE	0x0100	/* ->fault installed the pte, not return page */
 #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
 #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
diff --git a/mm/memory.c b/mm/memory.c
index 7f52c46..c7fc9c5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3288,7 +3288,8 @@ oom:
 }
 
 static int __do_fault(struct vm_area_struct *vma, unsigned long address,
-		pgoff_t pgoff, unsigned int flags, struct page **page)
+			pgoff_t pgoff, unsigned int flags,
+			struct page *cow_page, struct page **page)
 {
 	struct vm_fault vmf;
 	int ret;
@@ -3297,10 +3298,13 @@ static int __do_fault(struct vm_area_struct *vma, unsigned long address,
 	vmf.pgoff = pgoff;
 	vmf.flags = flags;
 	vmf.page = NULL;
+	vmf.cow_page = cow_page;
 
 	ret = vma->vm_ops->fault(vma, &vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
+	if (unlikely(ret & VM_FAULT_COWED))
+		goto out;
 
 	if (unlikely(PageHWPoison(vmf.page))) {
 		if (ret & VM_FAULT_LOCKED)
@@ -3314,6 +3318,7 @@ static int __do_fault(struct vm_area_struct *vma, unsigned long address,
 	else
 		VM_BUG_ON_PAGE(!PageLocked(vmf.page), vmf.page);
 
+ out:
 	*page = vmf.page;
 	return ret;
 }
@@ -3351,7 +3356,7 @@ static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	pte_t *pte;
 	int ret;
 
-	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
+	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
@@ -3368,6 +3373,12 @@ static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	return ret;
 }
 
+/*
+ * If the fault handler performs the COW, it does not return a page,
+ * so cannot use the page's lock to protect against a concurrent truncate
+ * operation.  Instead it returns with the i_mmap_mutex held, which must
+ * be released after the PTE has been inserted.
+ */
 static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmd,
 		pgoff_t pgoff, unsigned int flags, pte_t orig_pte)
@@ -3389,25 +3400,34 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		return VM_FAULT_OOM;
 	}
 
-	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
+	ret = __do_fault(vma, address, pgoff, flags, new_page, &fault_page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
 
-	copy_user_highpage(new_page, fault_page, address, vma);
+	if (!(ret & VM_FAULT_COWED))
+		copy_user_highpage(new_page, fault_page, address, vma);
 	__SetPageUptodate(new_page);
 
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (unlikely(!pte_same(*pte, orig_pte))) {
-		pte_unmap_unlock(pte, ptl);
+	if (unlikely(!pte_same(*pte, orig_pte)))
+		goto unlock_out;
+	do_set_pte(vma, address, new_page, pte, true, true);
+	pte_unmap_unlock(pte, ptl);
+	if (ret & VM_FAULT_COWED) {
+		mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+	} else {
 		unlock_page(fault_page);
 		page_cache_release(fault_page);
-		goto uncharge_out;
 	}
-	do_set_pte(vma, address, new_page, pte, true, true);
-	pte_unmap_unlock(pte, ptl);
-	unlock_page(fault_page);
-	page_cache_release(fault_page);
 	return ret;
+unlock_out:
+	pte_unmap_unlock(pte, ptl);
+	if (ret & VM_FAULT_COWED) {
+		mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+	} else {
+		unlock_page(fault_page);
+		page_cache_release(fault_page);
+	}
 uncharge_out:
 	mem_cgroup_uncharge_page(new_page);
 	page_cache_release(new_page);
@@ -3424,7 +3444,7 @@ static int do_shared_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	int dirtied = 0;
 	int ret, tmp;
 
-	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
+	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
-- 
1.8.5.3

