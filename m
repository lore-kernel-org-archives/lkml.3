Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbaHARif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:38:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbaHARiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:38:09 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v2 3/3] mm/hugetlb: add migration entry check in hugetlb_change_protection
Date: Fri,  1 Aug 2014 13:37:43 -0400
Message-Id: <1406914663-8631-3-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1406914663-8631-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1406914663-8631-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition between hugepage migration and change_protection(),
where hugetlb_change_protection() doesn't care about migration entries and
wrongly overwrites them. That causes unexpected results like kernel crash.

This patch adds is_hugetlb_entry_(migration|hwpoisoned) check in this
function and skip all such entries.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>  # [3.12+]
---
 mm/hugetlb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git mmotm-2014-07-22-15-58.orig/mm/hugetlb.c mmotm-2014-07-22-15-58/mm/hugetlb.c
index 863f45f63cd5..1da7ca2e2a02 100644
--- mmotm-2014-07-22-15-58.orig/mm/hugetlb.c
+++ mmotm-2014-07-22-15-58/mm/hugetlb.c
@@ -3355,7 +3355,13 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 			spin_unlock(ptl);
 			continue;
 		}
-		if (!huge_pte_none(huge_ptep_get(ptep))) {
+		pte = huge_ptep_get(ptep);
+		if (unlikely(is_hugetlb_entry_migration(pte) ||
+			     is_hugetlb_entry_hwpoisoned(pte))) {
+			spin_unlock(ptl);
+			continue;
+		}
+		if (!huge_pte_none(pte)) {
 			pte = huge_ptep_get_and_clear(mm, address, ptep);
 			pte = pte_mkhuge(huge_pte_modify(pte, newprot));
 			pte = arch_make_huge_pte(pte, vma, NULL, 0);
-- 
1.9.3

