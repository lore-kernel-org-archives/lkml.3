Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3JUVrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:47:20 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:45438 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab3JUVrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:47:17 -0400
Date: Mon, 21 Oct 2013 14:47:12 -0700
From: Ning Qu <quning@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ning Qu <quning@google.com>, Ning Qu <quning@gmail.com>
Subject: [PATCHv2 06/13] mm, thp, tmpfs: request huge page in shm_fault when
 needed
Message-ID: <20131021214712.GG29870@hippobay.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the function to request huge page in shm_fault when needed.
And it will fall back to regular page if huge page can't be
satisfied or allocated.

If small page requested but huge page is found, the huge page will
be splitted.

Signed-off-by: Ning Qu <quning@gmail.com>
---
 mm/shmem.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b80ace7..0dd6689 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1469,19 +1469,43 @@ unlock:
 static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vma->vm_file);
+	struct page *page = NULL;
 	int error;
 	int ret = VM_FAULT_LOCKED;
 	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
+	bool must_use_thp = vmf->flags & FAULT_FLAG_TRANSHUGE;
+	int flags = AOP_FLAG_TRANSHUGE;
 
-	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, gfp,
-				0, &ret);
+retry_find:
+	error = shmem_getpage(inode, vmf->pgoff, &page, SGP_CACHE, gfp,
+				flags, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
 
+	/* Split huge page if we don't want huge page to be here */
+	if (!must_use_thp && PageTransCompound(page)) {
+		unlock_page(page);
+		page_cache_release(page);
+		split_huge_page(compound_trans_head(page));
+		page = NULL;
+		goto retry_find;
+	}
+
+	if (must_use_thp && !PageTransHuge(page)) {
+		/*
+		 * Caller asked for huge page, but we have small page
+		 * by this offset. Fallback to small pages.
+		 */
+		unlock_page(page);
+		page_cache_release(page);
+		return VM_FAULT_FALLBACK;
+	}
+
 	if (ret & VM_FAULT_MAJOR) {
 		count_vm_event(PGMAJFAULT);
 		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 	}
+	vmf->page = page;
 	return ret;
 }
 
-- 
1.8.4

