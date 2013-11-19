Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab3KSUGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:06:48 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:45012 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab3KSUGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:06:38 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: linux-graphics-maintainer@vmware.com,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH RFC 1/3] mm: Add pfn_mkwrite()
Date: Tue, 19 Nov 2013 12:06:14 -0800
Message-Id: <1384891576-7851-2-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1384891576-7851-1-git-send-email-thellstrom@vmware.com>
References: <1384891576-7851-1-git-send-email-thellstrom@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A callback similar to page_mkwrite except it will be called before making
ptes that don't point to normal pages writable.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 include/linux/mm.h |    9 +++++++++
 mm/memory.c        |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8b6e55e..23d1791 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -212,6 +212,15 @@ struct vm_operations_struct {
 	 * writable, if an error is returned it will cause a SIGBUS */
 	int (*page_mkwrite)(struct vm_area_struct *vma, struct vm_fault *vmf);
 
+	/*
+	 * Notification that a previously read-only pfn map is about to become
+	 * writable, Returning VM_FAULT_NOPAGE will cause the fault to be
+	 * retried,
+	 * Returning a VM_FAULT_SIGBUS or VM_FAULT_OOM will propagate the
+	 * error. Returning 0 will make the pfn map writable.
+	 */
+	int (*pfn_mkwrite)(struct vm_area_struct *vma, struct vm_fault *vmf);
+
 	/* called by access_process_vm when get_user_pages() fails, typically
 	 * for use by special VMAs that can switch between memory and hardware
 	 */
diff --git a/mm/memory.c b/mm/memory.c
index d176154..8ae9a6e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2584,6 +2584,45 @@ static inline void cow_user_page(struct page *dst, struct page *src, unsigned lo
 		copy_user_highpage(dst, src, va, vma);
 }
 
+static int prepare_call_pfn_mkwrite(struct vm_area_struct *vma,
+				    unsigned long address,
+				    pte_t *pte, pmd_t *pmd,
+				    spinlock_t *ptl, pte_t orig_pte)
+{
+	int ret = 0;
+	struct vm_fault vmf;
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (!vma->vm_ops || !vma->vm_ops->pfn_mkwrite)
+		return 0;
+
+	/*
+	 * In general, we can't say anything about the mapping offset
+	 * here, so set it to 0.
+	 */
+	vmf.pgoff = 0;
+	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
+	vmf.flags = FAULT_FLAG_WRITE | FAULT_FLAG_MKWRITE;
+	vmf.page = NULL;
+	pte_unmap_unlock(pte, ptl);
+	ret = vma->vm_ops->pfn_mkwrite(vma, &vmf);
+	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
+		return ret;
+
+	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
+
+	/*
+	 * Retry the fault if someone updated the pte while we
+	 * dropped the lock.
+	 */
+	if (!pte_same(*pte, orig_pte)) {
+		pte_unmap_unlock(pte, ptl);
+		return VM_FAULT_NOPAGE;
+	}
+
+	return 0;
+}
+
 /*
  * This routine handles present pages, when users try to write
  * to a shared page. It is done by copying the page to a new address
@@ -2621,12 +2660,19 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		 * VM_MIXEDMAP !pfn_valid() case
 		 *
 		 * We should not cow pages in a shared writeable mapping.
-		 * Just mark the pages writable as we can't do any dirty
-		 * accounting on raw pfn maps.
+		 * Optionally call pfn_mkwrite to notify the address
+		 * space that the pte is about to become writeable.
 		 */
 		if ((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
-				     (VM_WRITE|VM_SHARED))
+		    (VM_WRITE|VM_SHARED)) {
+			ret = prepare_call_pfn_mkwrite(vma, address,
+						       page_table, pmd, ptl,
+						       orig_pte);
+			if (ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))
+				return ret;
+
 			goto reuse;
+		}
 		goto gotten;
 	}
 
-- 
1.7.10.4
