Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaLBIah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:30:37 -0500
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:56635 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaLBIaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:30:30 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
CC: David Rientjes <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v5 7/8] mm/hugetlb: fix suboptimal migration/hwpoisoned
 entry check
Thread-Topic: [PATCH v5 7/8] mm/hugetlb: fix suboptimal migration/hwpoisoned
 entry check
Thread-Index: AQHQDgmy7cRjtcBUck6BF4XxyuFbxA==
Date: Tue, 2 Dec 2014 08:26:40 +0000
Message-ID: <1417508759-10848-8-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1417508759-10848-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1417508759-10848-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.13]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently hugetlb_fault() checks at first whether pte of the faulted address
is a migration or hwpoisoned entry, which means that we call huge_ptep_get()
twice in single hugetlb_fault(). This is not optimized. The reason of this
approach is that without checking at first, huge_pte_alloc() can trigger
BUG_ON() because pmd_huge() returned false for non-present hugetlb entry.

With a previous patch in this series, pmd_huge() becomes to return true
for non-present entry, so we no longer need this dirty workaround.
Let's move the checking code to the proper place.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/hugetlb.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git mmotm-2014-11-26-15-45.orig/mm/hugetlb.c mmotm-2014-11-26-15-45/mm/hugetlb.c
index a2bfd02e289f..6c38f9ad3d56 100644
--- mmotm-2014-11-26-15-45.orig/mm/hugetlb.c
+++ mmotm-2014-11-26-15-45/mm/hugetlb.c
@@ -3136,20 +3136,10 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
 	int need_wait_lock = 0;
+	int need_wait_migration = 0;
 
 	address &= huge_page_mask(h);
 
-	ptep = huge_pte_offset(mm, address);
-	if (ptep) {
-		entry = huge_ptep_get(ptep);
-		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait_huge(vma, mm, ptep);
-			return 0;
-		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
-			return VM_FAULT_HWPOISON_LARGE |
-				VM_FAULT_SET_HINDEX(hstate_index(h));
-	}
-
 	ptep = huge_pte_alloc(mm, address, huge_page_size(h));
 	if (!ptep)
 		return VM_FAULT_OOM;
@@ -3176,12 +3166,16 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	/*
 	 * entry could be a migration/hwpoison entry at this point, so this
 	 * check prevents the kernel from going below assuming that we have
-	 * a active hugepage in pagecache. This goto expects the 2nd page fault,
-	 * and is_hugetlb_entry_(migration|hwpoisoned) check will properly
-	 * handle it.
+	 * a active hugepage in pagecache.
 	 */
-	if (!pte_present(entry))
+	if (!pte_present(entry)) {
+		if (is_hugetlb_entry_migration(entry))
+			need_wait_migration = 1;
+		else if (is_hugetlb_entry_hwpoisoned(entry))
+			ret = VM_FAULT_HWPOISON_LARGE |
+				VM_FAULT_SET_HINDEX(hstate_index(h));
 		goto out_mutex;
+	}
 
 	/*
 	 * If we are going to COW the mapping later, we examine the pending
@@ -3247,6 +3241,8 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 out_mutex:
 	mutex_unlock(&htlb_fault_mutex_table[hash]);
+	if (need_wait_migration)
+		migration_entry_wait_huge(vma, mm, ptep);
 	/*
 	 * Generally it's safe to hold refcount during waiting page lock. But
 	 * here we just wait to defer the next page fault to avoid busy loop and
-- 
2.2.0.rc0.2.gf745acb
