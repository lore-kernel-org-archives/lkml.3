Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3J2SJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:09:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3J2SJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 81/81] mm: fix BUG in __split_huge_page_pmd
Date: Tue, 29 Oct 2013 11:04:42 -0700
Message-Id: <1383069882-11437-82-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 750e8165f5e87b6a142be953640eabb13a9d350a upstream.

Occasionally we hit the BUG_ON(pmd_trans_huge(*pmd)) at the end of
__split_huge_page_pmd(): seen when doing madvise(,,MADV_DONTNEED).

It's invalid: we don't always have down_write of mmap_sem there: a racing
do_huge_pmd_wp_page() might have copied-on-write to another huge page
before our split_huge_page() got the anon_vma lock.

Forget the BUG_ON, just go back and try again if this happens.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e9308d3..a057a7d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2740,6 +2740,7 @@ void __split_huge_page_pmd(struct vm_area_struct *vma, unsigned long address,
 
 	mmun_start = haddr;
 	mmun_end   = haddr + HPAGE_PMD_SIZE;
+again:
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_trans_huge(*pmd))) {
@@ -2762,7 +2763,14 @@ void __split_huge_page_pmd(struct vm_area_struct *vma, unsigned long address,
 	split_huge_page(page);
 
 	put_page(page);
-	BUG_ON(pmd_trans_huge(*pmd));
+
+	/*
+	 * We don't always have down_write of mmap_sem here: a racing
+	 * do_huge_pmd_wp_page() might have copied-on-write to another
+	 * huge page before our split_huge_page() got the anon_vma lock.
+	 */
+	if (unlikely(pmd_trans_huge(*pmd)))
+		goto again;
 }
 
 void split_huge_page_pmd_mm(struct mm_struct *mm, unsigned long address,
-- 
1.8.1.2

