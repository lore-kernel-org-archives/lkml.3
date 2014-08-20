Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaHTMQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:16:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59575 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754746AbaHTMQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:16:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 061/104] hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned entry
Date: Wed, 20 Aug 2014 13:43:24 +0200
Message-Id: <520ef9c30b71e2c689141d8d18367a2fcff6445c.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4a705fef986231a3e7a6b1a6d3c37025f021f49f upstream.

There's a race between fork() and hugepage migration, as a result we try
to "dereference" a swap entry as a normal pte, causing kernel panic.
The cause of the problem is that copy_hugetlb_page_range() can't handle
"swap entry" family (migration entry and hwpoisoned entry) so let's fix
it.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/hugetlb.c | 71 ++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 28 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 92e103b72dcb..11c2b7fed052 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2381,6 +2381,31 @@ static void set_huge_ptep_writable(struct vm_area_struct *vma,
 		update_mmu_cache(vma, address, ptep);
 }
 
+static int is_hugetlb_entry_migration(pte_t pte)
+{
+	swp_entry_t swp;
+
+	if (huge_pte_none(pte) || pte_present(pte))
+		return 0;
+	swp = pte_to_swp_entry(pte);
+	if (non_swap_entry(swp) && is_migration_entry(swp))
+		return 1;
+	else
+		return 0;
+}
+
+static int is_hugetlb_entry_hwpoisoned(pte_t pte)
+{
+	swp_entry_t swp;
+
+	if (huge_pte_none(pte) || pte_present(pte))
+		return 0;
+	swp = pte_to_swp_entry(pte);
+	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
+		return 1;
+	else
+		return 0;
+}
 
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			    struct vm_area_struct *vma)
@@ -2408,10 +2433,26 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 
 		spin_lock(&dst->page_table_lock);
 		spin_lock_nested(&src->page_table_lock, SINGLE_DEPTH_NESTING);
-		if (!huge_pte_none(huge_ptep_get(src_pte))) {
+		entry = huge_ptep_get(src_pte);
+		if (huge_pte_none(entry)) { /* skip none entry */
+			;
+		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
+				    is_hugetlb_entry_hwpoisoned(entry))) {
+			swp_entry_t swp_entry = pte_to_swp_entry(entry);
+
+			if (is_write_migration_entry(swp_entry) && cow) {
+				/*
+				 * COW mappings require pages in both
+				 * parent and child to be set to read.
+				 */
+				make_migration_entry_read(&swp_entry);
+				entry = swp_entry_to_pte(swp_entry);
+				set_huge_pte_at(src, addr, src_pte, entry);
+			}
+			set_huge_pte_at(dst, addr, dst_pte, entry);
+		} else {
 			if (cow)
 				huge_ptep_set_wrprotect(src, addr, src_pte);
-			entry = huge_ptep_get(src_pte);
 			ptepage = pte_page(entry);
 			get_page(ptepage);
 			page_dup_rmap(ptepage);
@@ -2426,32 +2467,6 @@ nomem:
 	return -ENOMEM;
 }
 
-static int is_hugetlb_entry_migration(pte_t pte)
-{
-	swp_entry_t swp;
-
-	if (huge_pte_none(pte) || pte_present(pte))
-		return 0;
-	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_migration_entry(swp))
-		return 1;
-	else
-		return 0;
-}
-
-static int is_hugetlb_entry_hwpoisoned(pte_t pte)
-{
-	swp_entry_t swp;
-
-	if (huge_pte_none(pte) || pte_present(pte))
-		return 0;
-	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
-		return 1;
-	else
-		return 0;
-}
-
 void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			    unsigned long start, unsigned long end,
 			    struct page *ref_page)
-- 
2.0.4

