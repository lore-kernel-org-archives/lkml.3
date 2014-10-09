Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720AbaJIVM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:12:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59735 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaJIVMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:12:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 155/163] mm: numa: Do not mark PTEs pte_numa when splitting huge pages
Date: Thu,  9 Oct 2014 14:03:00 -0700
Message-Id: <1412888588-26755-156-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit abc40bd2eeb77eb7c2effcaf63154aad929a1d5f upstream.

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

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a2256e0..64a7f9c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1823,6 +1823,11 @@ static int __split_huge_page_map(struct page *page,
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
@@ -1831,8 +1836,6 @@ static int __split_huge_page_map(struct page *page,
 				BUG_ON(page_mapcount(page) != 1);
 			if (!pmd_young(*pmd))
 				entry = pte_mkold(entry);
-			if (pmd_numa(*pmd))
-				entry = pte_mknuma(entry);
 			pte = pte_offset_map(&_pmd, haddr);
 			BUG_ON(!pte_none(*pte));
 			set_pte_at(mm, haddr, pte, entry);
-- 
1.9.1

