Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaCCFCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 00:02:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaCCFCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 00:02:43 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH] mm: add pte_present() check on existing hugetlb_entry callbacks
Date: Mon,  3 Mar 2014 00:02:26 -0500
Message-Id: <1393822946-26871-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <53126861.7040107@oracle.com>
References: <53126861.7040107@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

> I can confirm that with this patch the lockdep issue is gone. However, the NULL deref in
> walk_pte_range() and the BUG at mm/hugemem.c:3580 still appear.

I spotted the cause of this problem.
Could you try testing if this patch fixes it?

Thanks,
Naoya
---
Page table walker doesn't check non-present hugetlb entry in common path,
so hugetlb_entry() callbacks must check it. The reason for this behavior
is that some callers want to handle it in its own way.

However, some callers don't check it now, which causes unpredictable result,
for example when we have a race between migrating hugepage and reading
/proc/pid/numa_maps. This patch fixes it by adding pte_present checks on
buggy callbacks.

This bug exists for long and got visible by introducing hugepage migration.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: stable@vger.kernel.org # 3.12+
---
 fs/proc/task_mmu.c | 3 +++
 mm/mempolicy.c     | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git next-20140228.orig/fs/proc/task_mmu.c next-20140228/fs/proc/task_mmu.c
index 3746d89c768b..a4cecadce867 100644
--- next-20140228.orig/fs/proc/task_mmu.c
+++ next-20140228/fs/proc/task_mmu.c
@@ -1299,6 +1299,9 @@ static int gather_hugetlb_stats(pte_t *pte, unsigned long addr,
 	if (pte_none(*pte))
 		return 0;
 
+	if (pte_present(*pte))
+		return 0;
+
 	page = pte_page(*pte);
 	if (!page)
 		return 0;
diff --git next-20140228.orig/mm/mempolicy.c next-20140228/mm/mempolicy.c
index c0d1cbd68790..1e171186ee6d 100644
--- next-20140228.orig/mm/mempolicy.c
+++ next-20140228/mm/mempolicy.c
@@ -524,8 +524,12 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long addr,
 	unsigned long flags = qp->flags;
 	int nid;
 	struct page *page;
+	pte_t entry;
 
-	page = pte_page(huge_ptep_get(pte));
+	entry = huge_ptep_get(pte);
+	if (pte_present(entry))
+		return 0;
+	page = pte_page(entry);
 	nid = page_to_nid(page);
 	if (node_isset(nid, *qp->nmask) == !!(flags & MPOL_MF_INVERT))
 		return 0;
-- 
1.8.5.3

