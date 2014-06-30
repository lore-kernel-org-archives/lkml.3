Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbaF3MRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:17:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51964 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 050/181] mm: add !pte_present() check on existing hugetlb_entry callbacks
Date: Mon, 30 Jun 2014 13:51:11 +0200
Message-Id: <3e500cc45f518651ca7ff2e91fece7ed1c039704.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d4c54919ed86302094c0ca7d48a8cbd4ee753e92 upstream.

The age table walker doesn't check non-present hugetlb entry in common
path, so hugetlb_entry() callbacks must check it.  The reason for this
behavior is that some callers want to handle it in its own way.

[ I think that reason is bogus, btw - it should just do what the regular
  code does, which is to call the "pte_hole()" function for such hugetlb
  entries  - Linus]

However, some callers don't check it now, which causes unpredictable
result, for example when we have a race between migrating hugepage and
reading /proc/pid/numa_maps.  This patch fixes it by adding !pte_present
checks on buggy callbacks.

This bug exists for years and got visible by introducing hugepage
migration.

ChangeLog v2:
- fix if condition (check !pte_present() instead of pte_present())

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org> [3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Backported to 3.15.  Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org> ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/proc/task_mmu.c | 2 +-
 mm/mempolicy.c     | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 390bdab01c3c..ad4df869c907 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1353,7 +1353,7 @@ static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 	struct numa_maps *md;
 	struct page *page;
 
-	if (pte_none(*pte))
+	if (!pte_present(*pte))
 		return 0;
 
 	page = pte_page(*pte);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 927a69cf354a..a005cc9f6f18 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -525,9 +525,13 @@ static void queue_pages_hugetlb_pmd_range(struct vm_area_struct *vma,
 #ifdef CONFIG_HUGETLB_PAGE
 	int nid;
 	struct page *page;
+	pte_t entry;
 
 	spin_lock(&vma->vm_mm->page_table_lock);
-	page = pte_page(huge_ptep_get((pte_t *)pmd));
+	entry = huge_ptep_get((pte_t *)pmd);
+	if (!pte_present(entry))
+		goto unlock;
+	page = pte_page(entry);
 	nid = page_to_nid(page);
 	if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
 		goto unlock;
-- 
2.0.0

