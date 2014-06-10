Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbaFJT5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:57:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35686 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbaFJTyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:54:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Bob Liu <lliubbo@gmail.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michel Lespinasse <walken@google.com>, Dave Jones <davej@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 044/160] thp: close race between split and zap huge pages
Date: Tue, 10 Jun 2014 12:44:44 -0700
Message-Id: <1402429600-20477-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

commit b5a8cad376eebbd8598642697e92a27983aee802 upstream.

Sasha Levin has reported two THP BUGs[1][2].  I believe both of them
have the same root cause.  Let's look to them one by one.

The first bug[1] is "kernel BUG at mm/huge_memory.c:1829!".  It's
BUG_ON(mapcount != page_mapcount(page)) in __split_huge_page().  From my
testing I see that page_mapcount() is higher than mapcount here.

I think it happens due to race between zap_huge_pmd() and
page_check_address_pmd().  page_check_address_pmd() misses PMD which is
under zap:

	CPU0						CPU1
						zap_huge_pmd()
						  pmdp_get_and_clear()
__split_huge_page()
  anon_vma_interval_tree_foreach()
    __split_huge_page_splitting()
      page_check_address_pmd()
        mm_find_pmd()
	  /*
	   * We check if PMD present without taking ptl: no
	   * serialization against zap_huge_pmd(). We miss this PMD,
	   * it's not accounted to 'mapcount' in __split_huge_page().
	   */
	  pmd_present(pmd) == 0

  BUG_ON(mapcount != page_mapcount(page)) // CRASH!!!

						  page_remove_rmap(page)
						    atomic_add_negative(-1, &page->_mapcount)

The second bug[2] is "kernel BUG at mm/huge_memory.c:1371!".
It's VM_BUG_ON_PAGE(!PageHead(page), page) in zap_huge_pmd().

This happens in similar way:

	CPU0						CPU1
						zap_huge_pmd()
						  pmdp_get_and_clear()
						  page_remove_rmap(page)
						    atomic_add_negative(-1, &page->_mapcount)
__split_huge_page()
  anon_vma_interval_tree_foreach()
    __split_huge_page_splitting()
      page_check_address_pmd()
        mm_find_pmd()
	  pmd_present(pmd) == 0	/* The same comment as above */
  /*
   * No crash this time since we already decremented page->_mapcount in
   * zap_huge_pmd().
   */
  BUG_ON(mapcount != page_mapcount(page))

  /*
   * We split the compound page here into small pages without
   * serialization against zap_huge_pmd()
   */
  __split_huge_page_refcount()
						VM_BUG_ON_PAGE(!PageHead(page), page); // CRASH!!!

So my understanding the problem is pmd_present() check in mm_find_pmd()
without taking page table lock.

The bug was introduced by me commit with commit 117b0791ac42. Sorry for
that. :(

Let's open code mm_find_pmd() in page_check_address_pmd() and do the
check under page table lock.

Note that __page_check_address() does the same for PTE entires
if sync != 0.

I've stress tested split and zap code paths for 36+ hours by now and
don't see crashes with the patch applied. Before it took <20 min to
trigger the first bug and few hours for second one (if we ignore
first).

[1] https://lkml.kernel.org/g/<53440991.9090001@oracle.com>
[2] https://lkml.kernel.org/g/<5310C56C.60709@oracle.com>

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 39c8e2e..a2256e0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1610,16 +1610,23 @@ pmd_t *page_check_address_pmd(struct page *page,
 			      enum page_check_address_pmd_flag flag,
 			      spinlock_t **ptl)
 {
+	pgd_t *pgd;
+	pud_t *pud;
 	pmd_t *pmd;
 
 	if (address & ~HPAGE_PMD_MASK)
 		return NULL;
 
-	pmd = mm_find_pmd(mm, address);
-	if (!pmd)
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
 		return NULL;
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		return NULL;
+	pmd = pmd_offset(pud, address);
+
 	*ptl = pmd_lock(mm, pmd);
-	if (pmd_none(*pmd))
+	if (!pmd_present(*pmd))
 		goto unlock;
 	if (pmd_page(*pmd) != page)
 		goto unlock;
-- 
1.9.1

