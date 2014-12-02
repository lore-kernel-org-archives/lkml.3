Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaLBIag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:30:36 -0500
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:56640 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaLBIac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:30:32 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
CC: David Rientjes <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v5 5/8] mm/hugetlb: add migration/hwpoisoned entry check in
 hugetlb_change_protection
Thread-Topic: [PATCH v5 5/8] mm/hugetlb: add migration/hwpoisoned entry
 check in hugetlb_change_protection
Thread-Index: AQHQDgmya+DSwJUdGEue1h6OYNqkZg==
Date: Tue, 2 Dec 2014 08:26:40 +0000
Message-ID: <1417508759-10848-6-git-send-email-n-horiguchi@ah.jp.nec.com>
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

There is a race condition between hugepage migration and change_protection(),
where hugetlb_change_protection() doesn't care about migration entries and
wrongly overwrites them. That causes unexpected results like kernel crash.
HWPoison entries also can cause the same problem.

This patch adds is_hugetlb_entry_(migration|hwpoisoned) check in this
function to do proper actions.

Fixes: 290408d4a2 ("hugetlb: hugepage migration core")
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org> # [2.6.36+]
---
ChangeLog v4:
- s/set_pte_at/set_huge_pte_at/

ChangeLog v3:
- handle migration entry correctly (instead of just skipping)
---
 mm/hugetlb.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git mmotm-2014-11-26-15-45.orig/mm/hugetlb.c mmotm-2014-11-26-15-45/mm/hugetlb.c
index dfc1527e8f4e..2807be3f260d 100644
--- mmotm-2014-11-26-15-45.orig/mm/hugetlb.c
+++ mmotm-2014-11-26-15-45/mm/hugetlb.c
@@ -3384,7 +3384,26 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
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
+				set_huge_pte_at(mm, address, ptep, newpte);
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
2.2.0.rc0.2.gf745acb
