Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaKXOUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:20:16 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59266 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbaKXOUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:20:14 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] mm/thp: Always allocate transparent hugepages on local node
Date: Mon, 24 Nov 2014 19:49:51 +0530
Message-Id: <1416838791-30023-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112414-0025-0000-0000-0000009211AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This make sure that we try to allocate hugepages from local node. If
we can't we fallback to small page allocation based on
mempolicy. This is based on the observation that allocating pages
on local node is more beneficial that allocating hugepages on remote node.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
NOTE:
I am not sure whether we want this to be per system configurable ? If not
we could possibly remove alloc_hugepage_vma.

 mm/huge_memory.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index de984159cf0b..b309705e7e96 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -775,6 +775,12 @@ static inline struct page *alloc_hugepage_vma(int defrag,
 			       HPAGE_PMD_ORDER, vma, haddr, nd);
 }
 
+static inline struct page *alloc_hugepage_exact_node(int node, int defrag)
+{
+	return alloc_pages_exact_node(node, alloc_hugepage_gfpmask(defrag, 0),
+				      HPAGE_PMD_ORDER);
+}
+
 /* Caller must hold page table lock. */
 static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
@@ -830,8 +836,8 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		}
 		return 0;
 	}
-	page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
-			vma, haddr, numa_node_id(), 0);
+	page = alloc_hugepage_exact_node(numa_node_id(),
+					 transparent_hugepage_defrag(vma));
 	if (unlikely(!page)) {
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
@@ -1120,8 +1126,8 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 alloc:
 	if (transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow())
-		new_page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
-					      vma, haddr, numa_node_id(), 0);
+		new_page = alloc_hugepage_exact_node(numa_node_id(),
+					     transparent_hugepage_defrag(vma));
 	else
 		new_page = NULL;
 
-- 
2.1.0

