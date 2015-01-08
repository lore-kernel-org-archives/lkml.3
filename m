Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbbAHP27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:28:59 -0500
Received: from smtp.citrix.com ([66.165.176.89]:21312 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbbAHP25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:28:57 -0500
X-IronPort-AV: E=Sophos;i="5.07,723,1413244800"; 
   d="scan'208";a="212710931"
From: David Vrabel <david.vrabel@citrix.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>, <linux-mm@kvack.org>,
        <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 1/2] mm: allow for an alternate set of pages for userspace mappings
Date: Thu, 8 Jan 2015 15:28:43 +0000
Message-ID: <1420730924-22811-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420730924-22811-1-git-send-email-david.vrabel@citrix.com>
References: <1420730924-22811-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an optional array of pages to struct vm_area_struct that can be
used find the page backing a VMA.  This is useful in cases where the
normal mechanisms for finding the page don't work.  This array is only
inspected if the PTE is special.

Splitting a VMA with such an array of pages is trivially done by
adjusting vma->pages.  The original creator of the VMA must only free
the page array once all sub-VMAs are closed (e.g., by ref-counting in
vm_ops->open and vm_ops->close).

One use case is a Xen PV guest mapping foreign pages into userspace.

In a Xen PV guest, the PTEs contain MFNs so get_user_pages() (for
example) must do an MFN to PFN (M2P) lookup before it can get the
page.  For foreign pages (those owned by another guest) the M2P lookup
returns the PFN as seen by the foreign guest (which would be
completely the wrong page for the local guest).

This cannot be fixed up improving the M2P lookup since one MFN may be
mapped onto two or more pages so getting the right page is impossible
given just the MFN.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 include/linux/mm_types.h |    8 ++++++++
 mm/memory.c              |    2 ++
 mm/mmap.c                |   12 +++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6d34aa2..4f34609 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -309,6 +309,14 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA
 	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
 #endif
+	/*
+	 * Array of pages to override the default vm_normal_page()
+	 * result iff the PTE is special.
+	 *
+	 * The memory for this should be refcounted in vm_ops->open
+	 * and vm_ops->close.
+	 */
+	struct page **pages;
 };
 
 struct core_thread {
diff --git a/mm/memory.c b/mm/memory.c
index ca920d1..98520f6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -754,6 +754,8 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 	if (HAVE_PTE_SPECIAL) {
 		if (likely(!pte_special(pte)))
 			goto check_pfn;
+		if (vma->pages)
+			return vma->pages[(addr - vma->vm_start) >> PAGE_SHIFT];
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 			return NULL;
 		if (!is_zero_pfn(pfn))
diff --git a/mm/mmap.c b/mm/mmap.c
index 7b36aa7..504dc5c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2448,6 +2448,7 @@ static int __split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
 	      unsigned long addr, int new_below)
 {
 	struct vm_area_struct *new;
+	unsigned long delta;
 	int err = -ENOMEM;
 
 	if (is_vm_hugetlb_page(vma) && (addr &
@@ -2463,11 +2464,20 @@ static int __split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	INIT_LIST_HEAD(&new->anon_vma_chain);
 
+	delta = (addr - vma->vm_start) >> PAGE_SHIFT;
+
 	if (new_below)
 		new->vm_end = addr;
 	else {
 		new->vm_start = addr;
-		new->vm_pgoff += ((addr - vma->vm_start) >> PAGE_SHIFT);
+		new->vm_pgoff += delta;
+	}
+
+	if (vma->pages) {
+		if (new_below)
+			vma->pages += delta;
+		else
+			new->pages += delta;
 	}
 
 	err = vma_dup_policy(vma, new);
-- 
1.7.10.4

