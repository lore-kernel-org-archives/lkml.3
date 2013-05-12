Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3ELBWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 21:22:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:23353 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab3ELBVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 21:21:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,654,1363158000"; 
   d="scan'208";a="332629730"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv4 39/39] thp: map file-backed huge pages on fault
Date: Sun, 12 May 2013 04:23:36 +0300
Message-Id: <1368321816-17719-40-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Look like all pieces are in place, we can map file-backed huge-pages
now.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/huge_mm.h |    4 +++-
 mm/memory.c             |    5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f4d6626..903f097 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -78,7 +78,9 @@ extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 	   (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG) &&			\
 	   ((__vma)->vm_flags & VM_HUGEPAGE))) &&			\
 	 !((__vma)->vm_flags & VM_NOHUGEPAGE) &&			\
-	 !is_vma_temporary_stack(__vma))
+	 !is_vma_temporary_stack(__vma) &&				\
+	 (!(__vma)->vm_ops ||						\
+		  mapping_can_have_hugepages((__vma)->vm_file->f_mapping)))
 #define transparent_hugepage_defrag(__vma)				\
 	((transparent_hugepage_flags &					\
 	  (1<<TRANSPARENT_HUGEPAGE_DEFRAG_FLAG)) ||			\
diff --git a/mm/memory.c b/mm/memory.c
index ebff552..7fe9752 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3939,10 +3939,13 @@ retry:
 	if (!pmd)
 		return VM_FAULT_OOM;
 	if (pmd_none(*pmd) && transparent_hugepage_enabled(vma)) {
-		int ret = 0;
+		int ret;
 		if (!vma->vm_ops)
 			ret = do_huge_pmd_anonymous_page(mm, vma, address,
 					pmd, flags);
+		else
+			ret = do_huge_linear_fault(mm, vma, address,
+					pmd, flags);
 		if ((ret & VM_FAULT_FALLBACK) == 0)
 			return ret;
 	} else {
-- 
1.7.10.4

