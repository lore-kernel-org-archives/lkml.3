Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaAPBdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:33:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:32449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaAPBZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:25:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="467394581"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v5 02/22] Allow page fault handlers to perform the COW
Date: Wed, 15 Jan 2014 20:24:20 -0500
Message-Id: <60513ca8b173f467bde45765633fb8f527687401.1389779961.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <cover.1389779961.git.matthew.r.wilcox@intel.com>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1389779961.git.matthew.r.wilcox@intel.com>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>
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
i_mmap_mutex instead.  We must therefore unlock the i_mmap_mutex in
__do_fault().

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 19 ++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1cedd00..e07c57c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -195,6 +195,7 @@ struct vm_fault {
 	pgoff_t pgoff;			/* Logical page offset based on vma */
 	void __user *virtual_address;	/* Faulting virtual address */
 
+	struct page *cow_page;		/* Handler may choose to COW */
 	struct page *page;		/* ->fault handlers should return a
 					 * page here, unless VM_FAULT_NOPAGE
 					 * is set (which is also implied by
@@ -958,6 +959,7 @@ static inline int page_mapped(struct page *page)
 #define VM_FAULT_HWPOISON 0x0010	/* Hit poisoned small page */
 #define VM_FAULT_HWPOISON_LARGE 0x0020  /* Hit poisoned large page. Index encoded in upper bits */
 
+#define VM_FAULT_COWED	0x0080	/* ->fault COWed the page instead */
 #define VM_FAULT_NOPAGE	0x0100	/* ->fault installed the pte, not return page */
 #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
 #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
diff --git a/mm/memory.c b/mm/memory.c
index 5d9025f..3f1b666 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2673,6 +2673,7 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			vmf.pgoff = old_page->index;
 			vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 			vmf.page = old_page;
+			vmf.cow_page = NULL;
 
 			/*
 			 * Notify the address space that the page is about to
@@ -3335,11 +3336,18 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	vmf.pgoff = pgoff;
 	vmf.flags = flags;
 	vmf.page = NULL;
+	vmf.cow_page = cow_page;
 
 	ret = vma->vm_ops->fault(vma, &vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
 			    VM_FAULT_RETRY)))
 		goto uncharge_out;
+	if (unlikely(ret & VM_FAULT_COWED)) {
+		page = cow_page;
+		anon = 1;
+		__SetPageUptodate(page);
+		goto cowed;
+	}
 
 	if (unlikely(PageHWPoison(vmf.page))) {
 		if (ret & VM_FAULT_LOCKED)
@@ -3399,6 +3407,7 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	}
 
+ cowed:
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 
 	/*
@@ -3465,9 +3474,13 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (vma->vm_file && !page_mkwrite)
 			file_update_time(vma->vm_file);
 	} else {
-		unlock_page(vmf.page);
-		if (anon)
-			page_cache_release(vmf.page);
+		if ((ret & VM_FAULT_COWED)) {
+			mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+		} else {
+			unlock_page(vmf.page);
+			if (anon)
+				page_cache_release(vmf.page);
+		}
 	}
 
 	return ret;
-- 
1.8.5.2

