Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbaJXVWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 17:22:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:33863 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197AbaJXVVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 17:21:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,782,1406617200"; 
   d="scan'208";a="620068414"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v12 04/20] mm: Allow page fault handlers to perform the COW
Date: Fri, 24 Oct 2014 17:20:36 -0400
Message-Id: <1414185652-28663-5-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently COW of an XIP file is done by first bringing in a read-only
mapping, then retrying the fault and copying the page.  It is much more
efficient to tell the fault handler that a COW is being attempted (by
passing in the pre-allocated page in the vm_fault structure), and allow
the handler to perform the COW operation itself.

The handler cannot insert the page itself if there is already a read-only
mapping at that address, so allow the handler to return VM_FAULT_LOCKED
and set the fault_page to be NULL.  This indicates to the MM code that
the i_mmap_mutex is held instead of the page lock.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h |  1 +
 mm/memory.c        | 33 ++++++++++++++++++++++++---------
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 02d11ee..88d1ef4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -209,6 +209,7 @@ struct vm_fault {
 	pgoff_t pgoff;			/* Logical page offset based on vma */
 	void __user *virtual_address;	/* Faulting virtual address */
 
+	struct page *cow_page;		/* Handler may choose to COW */
 	struct page *page;		/* ->fault handlers should return a
 					 * page here, unless VM_FAULT_NOPAGE
 					 * is set (which is also implied by
diff --git a/mm/memory.c b/mm/memory.c
index 1cc6bfb..6dee424 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2002,6 +2002,7 @@ static int do_page_mkwrite(struct vm_area_struct *vma, struct page *page,
 	vmf.pgoff = page->index;
 	vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 	vmf.page = page;
+	vmf.cow_page = NULL;
 
 	ret = vma->vm_ops->page_mkwrite(vma, &vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
@@ -2701,7 +2702,8 @@ oom:
  * See filemap_fault() and __lock_page_retry().
  */
 static int __do_fault(struct vm_area_struct *vma, unsigned long address,
-		pgoff_t pgoff, unsigned int flags, struct page **page)
+			pgoff_t pgoff, unsigned int flags,
+			struct page *cow_page, struct page **page)
 {
 	struct vm_fault vmf;
 	int ret;
@@ -2710,10 +2712,13 @@ static int __do_fault(struct vm_area_struct *vma, unsigned long address,
 	vmf.pgoff = pgoff;
 	vmf.flags = flags;
 	vmf.page = NULL;
+	vmf.cow_page = cow_page;
 
 	ret = vma->vm_ops->fault(vma, &vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
+	if (!vmf.page)
+		goto out;
 
 	if (unlikely(PageHWPoison(vmf.page))) {
 		if (ret & VM_FAULT_LOCKED)
@@ -2727,6 +2732,7 @@ static int __do_fault(struct vm_area_struct *vma, unsigned long address,
 	else
 		VM_BUG_ON_PAGE(!PageLocked(vmf.page), vmf.page);
 
+ out:
 	*page = vmf.page;
 	return ret;
 }
@@ -2900,7 +2906,7 @@ static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		pte_unmap_unlock(pte, ptl);
 	}
 
-	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
+	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
@@ -2940,26 +2946,35 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		return VM_FAULT_OOM;
 	}
 
-	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
+	ret = __do_fault(vma, address, pgoff, flags, new_page, &fault_page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
 
-	copy_user_highpage(new_page, fault_page, address, vma);
+	if (fault_page)
+		copy_user_highpage(new_page, fault_page, address, vma);
 	__SetPageUptodate(new_page);
 
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (unlikely(!pte_same(*pte, orig_pte))) {
 		pte_unmap_unlock(pte, ptl);
-		unlock_page(fault_page);
-		page_cache_release(fault_page);
+		if (fault_page) {
+			unlock_page(fault_page);
+			page_cache_release(fault_page);
+		} else {
+			mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+		}
 		goto uncharge_out;
 	}
 	do_set_pte(vma, address, new_page, pte, true, true);
 	mem_cgroup_commit_charge(new_page, memcg, false);
 	lru_cache_add_active_or_unevictable(new_page, vma);
 	pte_unmap_unlock(pte, ptl);
-	unlock_page(fault_page);
-	page_cache_release(fault_page);
+	if (fault_page) {
+		unlock_page(fault_page);
+		page_cache_release(fault_page);
+	} else {
+		mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+	}
 	return ret;
 uncharge_out:
 	mem_cgroup_cancel_charge(new_page, memcg);
@@ -2978,7 +2993,7 @@ static int do_shared_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	int dirtied = 0;
 	int ret, tmp;
 
-	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
+	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		return ret;
 
-- 
2.1.1

