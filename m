Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaH2Bje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 21:39:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbaH2BjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 21:39:20 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v3 4/6] mm/hugetlb: add migration entry check in hugetlb_change_protection
Date: Thu, 28 Aug 2014 21:38:58 -0400
Message-Id: <1409276340-7054-5-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1409276340-7054-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1409276340-7054-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition between hugepage migration and change_protection(),
where hugetlb_change_protection() doesn't care about migration entries and
wrongly overwrites them. That causes unexpected results like kernel crash.

This patch adds is_hugetlb_entry_(migration|hwpoisoned) check in this
function to do proper actions.

ChangeLog v3:
- handle migration entry correctly (instead of just skipping)

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org> # [2.6.36+]
---
 mm/hugetlb.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git mmotm-2014-08-25-16-52.orig/mm/hugetlb.c mmotm-2014-08-25-16-52/mm/hugetlb.c
index 2aafe073cb06..1ed9df6def54 100644
--- mmotm-2014-08-25-16-52.orig/mm/hugetlb.c
+++ mmotm-2014-08-25-16-52/mm/hugetlb.c
@@ -3362,7 +3362,26 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 			spin_unlock(ptl);
 			continue;
 		}
-		if (!huge_pte_none(huge_ptep_get(ptep))) {
+		pte = huge_ptep_get(ptep);
+		if (unlikely(is_hugetlb_entry_hwpoisoned(pte))) {
+			spin_unlock(ptl);
+			continue;
+		}
+		if (unlikely(is_hugetlb_entry_migration(pte))) {
+			swp_entry_t entry = pte_to_swp_entry(pte);
+
+			if (is_write_migration_entry(entry)) {
+				pte_t newpte;
+
+				make_migration_entry_read(&entry);
+				newpte = swp_entry_to_pte(entry);
+				set_pte_at(mm, address, ptep, newpte);
+				pages++;
+			}
+			spin_unlock(ptl);
+			continue;
+		}
+		if (!huge_pte_none(pte)) {
 			pte = huge_ptep_get_and_clear(mm, address, ptep);
 			pte = pte_mkhuge(huge_pte_modify(pte, newprot));
 			pte = arch_make_huge_pte(pte, vma, NULL, 0);
-- 
1.9.3

