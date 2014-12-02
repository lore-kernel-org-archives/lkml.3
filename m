Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaLBIae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:30:34 -0500
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:46782 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaLBIac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:30:32 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
CC: David Rientjes <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v5 8/8] mm/hugetlb: cleanup and rename
 is_hugetlb_entry_(migration|hwpoisoned)()
Thread-Topic: [PATCH v5 8/8] mm/hugetlb: cleanup and rename
 is_hugetlb_entry_(migration|hwpoisoned)()
Thread-Index: AQHQDgmyxLHHDH28CUazDtrqvVGHzg==
Date: Tue, 2 Dec 2014 08:26:41 +0000
Message-ID: <1417508759-10848-9-git-send-email-n-horiguchi@ah.jp.nec.com>
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

non_swap_entry() returns true if a given swp_entry_t is a migration
entry or hwpoisoned entry. So non_swap_entry() && is_migration_entry() is
identical with just is_migration_entry(). So by removing non_swap_entry(),
we can write is_hugetlb_entry_(migration|hwpoisoned)() more simply.

And the name is_hugetlb_entry_(migration|hwpoisoned) is lengthy and
it's not predictable from naming convention around pte_* family.
Just pte_migration() looks better, but these function contains hugetlb
specific (so architecture dependent) huge_pte_none() check, so let's
rename them as huge_pte_(migration|hwpoisoned).

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/hugetlb.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git mmotm-2014-11-26-15-45.orig/mm/hugetlb.c mmotm-2014-11-26-15-45/mm/hugetlb.c
index 6c38f9ad3d56..bc9cbdb4f58f 100644
--- mmotm-2014-11-26-15-45.orig/mm/hugetlb.c
+++ mmotm-2014-11-26-15-45/mm/hugetlb.c
@@ -2516,30 +2516,18 @@ static void set_huge_ptep_writable(struct vm_area_struct *vma,
 		update_mmu_cache(vma, address, ptep);
 }
 
-static int is_hugetlb_entry_migration(pte_t pte)
+static inline int huge_pte_migration(pte_t pte)
 {
-	swp_entry_t swp;
-
 	if (huge_pte_none(pte) || pte_present(pte))
 		return 0;
-	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_migration_entry(swp))
-		return 1;
-	else
-		return 0;
+	return is_migration_entry(pte_to_swp_entry(pte));
 }
 
-static int is_hugetlb_entry_hwpoisoned(pte_t pte)
+static inline int huge_pte_hwpoisoned(pte_t pte)
 {
-	swp_entry_t swp;
-
 	if (huge_pte_none(pte) || pte_present(pte))
 		return 0;
-	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
-		return 1;
-	else
-		return 0;
+	return is_hwpoison_entry(pte_to_swp_entry(pte));
 }
 
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
@@ -2583,8 +2571,8 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 		entry = huge_ptep_get(src_pte);
 		if (huge_pte_none(entry)) { /* skip none entry */
 			;
-		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
-				    is_hugetlb_entry_hwpoisoned(entry))) {
+		} else if (unlikely(huge_pte_migration(entry) ||
+				    huge_pte_hwpoisoned(entry))) {
 			swp_entry_t swp_entry = pte_to_swp_entry(entry);
 
 			if (is_write_migration_entry(swp_entry) && cow) {
@@ -3169,9 +3157,9 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * a active hugepage in pagecache.
 	 */
 	if (!pte_present(entry)) {
-		if (is_hugetlb_entry_migration(entry))
+		if (huge_pte_migration(entry))
 			need_wait_migration = 1;
-		else if (is_hugetlb_entry_hwpoisoned(entry))
+		else if (huge_pte_hwpoisoned(entry))
 			ret = VM_FAULT_HWPOISON_LARGE |
 				VM_FAULT_SET_HINDEX(hstate_index(h));
 		goto out_mutex;
@@ -3303,8 +3291,8 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		 * (in which case hugetlb_fault waits for the migration,) and
 		 * hwpoisoned hugepages (in which case we need to prevent the
 		 * caller from accessing to them.) In order to do this, we use
-		 * here is_swap_pte instead of is_hugetlb_entry_migration and
-		 * is_hugetlb_entry_hwpoisoned. This is because it simply covers
+		 * here is_swap_pte instead of huge_pte_migration and
+		 * huge_pte_hwpoisoned. This is because it simply covers
 		 * both cases, and because we can't follow correct pages
 		 * directly from any kind of swap entries.
 		 */
@@ -3382,11 +3370,11 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 			continue;
 		}
 		pte = huge_ptep_get(ptep);
-		if (unlikely(is_hugetlb_entry_hwpoisoned(pte))) {
+		if (unlikely(huge_pte_hwpoisoned(pte))) {
 			spin_unlock(ptl);
 			continue;
 		}
-		if (unlikely(is_hugetlb_entry_migration(pte))) {
+		if (unlikely(huge_pte_migration(pte))) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
 			if (is_write_migration_entry(entry)) {
@@ -3730,7 +3718,7 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 		if (flags & FOLL_GET)
 			get_page(page);
 	} else {
-		if (is_hugetlb_entry_migration(huge_ptep_get((pte_t *)pmd))) {
+		if (huge_pte_migration(huge_ptep_get((pte_t *)pmd))) {
 			spin_unlock(ptl);
 			__migration_entry_wait(mm, (pte_t *)pmd, ptl);
 			goto retry;
-- 
2.2.0.rc0.2.gf745acb
