Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaH2Bjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 21:39:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbaH2BjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 21:39:22 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v3 5/6] mm/hugetlb: add migration entry check in __unmap_hugepage_range
Date: Thu, 28 Aug 2014 21:38:59 -0400
Message-Id: <1409276340-7054-6-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1409276340-7054-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1409276340-7054-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If __unmap_hugepage_range() tries to unmap the address range over which
hugepage migration is on the way, we get the wrong page because pte_page()
doesn't work for migration entries. This patch calls pte_to_swp_entry() and
migration_entry_to_page() to get the right page for migration entries.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>  # [2.6.36+]
---
 mm/hugetlb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git mmotm-2014-08-25-16-52.orig/mm/hugetlb.c mmotm-2014-08-25-16-52/mm/hugetlb.c
index 1ed9df6def54..0a4511115ee0 100644
--- mmotm-2014-08-25-16-52.orig/mm/hugetlb.c
+++ mmotm-2014-08-25-16-52/mm/hugetlb.c
@@ -2652,6 +2652,13 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (huge_pte_none(pte))
 			goto unlock;
 
+		if (unlikely(is_hugetlb_entry_migration(pte))) {
+			swp_entry_t entry = pte_to_swp_entry(pte);
+
+			page = migration_entry_to_page(entry);
+			goto clear;
+		}
+
 		/*
 		 * HWPoisoned hugepage is already unmapped and dropped reference
 		 */
@@ -2677,7 +2684,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			 */
 			set_vma_resv_flags(vma, HPAGE_RESV_UNMAPPED);
 		}
-
+clear:
 		pte = huge_ptep_get_and_clear(mm, address, ptep);
 		tlb_remove_tlb_entry(tlb, ptep, address);
 		if (huge_pte_dirty(pte))
-- 
1.9.3

