Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaJBSrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:47:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbaJBSrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:47:49 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] mm: numa: Do not mark PTEs pte_numa when splitting huge pages
Date: Thu,  2 Oct 2014 19:47:42 +0100
Message-Id: <1412275662-16201-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1412275662-16201-1-git-send-email-mgorman@suse.de>
References: <1412275662-16201-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reverts 1ba6e0b50b ("mm: numa: split_huge_page: transfer the
NUMA type from the pmd to the pte"). If a huge page is being split due
a protection change and the tail will be in a PROT_NONE vma then NUMA
hinting PTEs are temporarily created in the protected VMA.

 VM_RW|VM_PROTNONE
|-----------------|
      ^
      split here

In the specific case above, it should get fixed up by change_pte_range()
but there is a window of opportunity for weirdness to happen. Similarly,
if a huge page is shrunk and split during a protection update but before
pmd_numa is cleared then a pte_numa can be left behind.

Instead of adding complexity trying to deal with the case, this patch
will not mark PTEs NUMA when splitting a huge page. NUMA hinting faults
will not be triggered which is marginal in comparison to the complexity
in dealing with the corner cases during THP split.

Cc: stable@vger.kernel.org
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/huge_memory.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d9a21d06..f8ffd94 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1795,14 +1795,17 @@ static int __split_huge_page_map(struct page *page,
 		for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
 			pte_t *pte, entry;
 			BUG_ON(PageCompound(page+i));
+			/*
+			 * Note that pmd_numa is not transferred deliberately
+			 * to avoid any possibility that pte_numa leaks to
+			 * a PROT_NONE VMA by accident.
+			 */
 			entry = mk_pte(page + i, vma->vm_page_prot);
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 			if (!pmd_write(*pmd))
 				entry = pte_wrprotect(entry);
 			if (!pmd_young(*pmd))
 				entry = pte_mkold(entry);
-			if (pmd_numa(*pmd))
-				entry = pte_mknuma(entry);
 			pte = pte_offset_map(&_pmd, haddr);
 			BUG_ON(!pte_none(*pte));
 			set_pte_at(mm, haddr, pte, entry);
-- 
1.8.4.5

