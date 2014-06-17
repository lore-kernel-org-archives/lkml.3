Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967348AbaFQWeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:34:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54091 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966286AbaFQVs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 212/212] mm: add !pte_present() check on existing hugetlb_entry callbacks
Date: Tue, 17 Jun 2014 14:45:06 -0700
Message-Id: <1403041506-13646-213-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Backported to 3.15.  Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org> ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/proc/task_mmu.c | 2 +-
 mm/mempolicy.c     | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index fb52b54..8f78819 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1350,7 +1350,7 @@ static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 	struct numa_maps *md;
 	struct page *page;
 
-	if (pte_none(*pte))
+	if (!pte_present(*pte))
 		return 0;
 
 	page = pte_page(*pte);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cb2f3dd..e980746 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -526,9 +526,13 @@ static void queue_pages_hugetlb_pmd_range(struct vm_area_struct *vma,
 	int nid;
 	struct page *page;
 	spinlock_t *ptl;
+	pte_t entry;
 
 	ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, (pte_t *)pmd);
-	page = pte_page(huge_ptep_get((pte_t *)pmd));
+	entry = huge_ptep_get((pte_t *)pmd);
+	if (!pte_present(entry))
+		goto unlock;
+	page = pte_page(entry);
 	nid = page_to_nid(page);
 	if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
 		goto unlock;
-- 
1.9.1

