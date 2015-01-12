Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbbALQLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:11:44 -0500
Received: from smtp.citrix.com ([66.165.176.89]:36052 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbbALQLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:11:42 -0500
X-IronPort-AV: E=Sophos;i="5.07,744,1413244800"; 
   d="scan'208";a="214825310"
From: David Vrabel <david.vrabel@citrix.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>, <linux-mm@kvack.org>
Subject: [PATCH 1/2] mm: provide a find_page vma operation
Date: Mon, 12 Jan 2015 15:53:12 +0000
Message-ID: <1421077993-7909-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421077993-7909-1-git-send-email-david.vrabel@citrix.com>
References: <1421077993-7909-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The optional find_page VMA operation is used to lookup the pages
backing a VMA.  This is useful in cases where the normal mechanisms
for finding the page don't work.  This is only called if the PTE is
special.

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
 include/linux/mm.h |    3 +++
 mm/memory.c        |    2 ++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 80fc92a..1306643 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -290,6 +290,9 @@ struct vm_operations_struct {
 	/* called by sys_remap_file_pages() to populate non-linear mapping */
 	int (*remap_pages)(struct vm_area_struct *vma, unsigned long addr,
 			   unsigned long size, pgoff_t pgoff);
+
+	struct page * (*find_page)(struct vm_area_struct *vma,
+				   unsigned long addr);
 };
 
 struct mmu_gather;
diff --git a/mm/memory.c b/mm/memory.c
index c6565f0..f23a862 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -754,6 +754,8 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 	if (HAVE_PTE_SPECIAL) {
 		if (likely(!pte_special(pte)))
 			goto check_pfn;
+		if (vma->vm_ops && vma->vm_ops->find_page)
+			return vma->vm_ops->find_page(vma, addr);
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 			return NULL;
 		if (!is_zero_pfn(pfn))
-- 
1.7.10.4

