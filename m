Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaFFRhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:37:05 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:39202 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaFFRhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:37:02 -0400
Date: Fri, 6 Jun 2014 13:36:54 -0400
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: pte_present check on hugetlb_entry fix for 3.15?
Message-ID: <20140606173546.GA1869@zod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naoya,

I noticed that your
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch in
Andrew's -mm tree has been queued for a while and has a CC to stable on
it.  Is that something that should get into 3.15?  I know it doesn't
cleanly apply to Linus' current tree because of the patch before it, but
it seems to be a fairly independent fix.

This originally came up in this thread: https://lkml.org/lkml/2014/3/18/784
as a fix for some issues Sasha was hitting with the generic page walker
changes, but you found it was an existing issue.  We now have a CVE
assigned for this:

http://seclists.org/oss-sec/2014/q2/399

So I'm wondering if you think this should fix the issue and if it should
go into 3.15.  A backported version is below.  I poked Linus about this
early today privately (my fault, apologies) and he had some
questions/comments on the code.

josh

>From ecc894926ef62080c2a4c4286eccce9d2f30f05a Mon Sep 17 00:00:00 2001
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date: Fri, 6 Jun 2014 10:00:01 -0400
Subject: [PATCH] mm: add !pte_present() check on existing hugetlb_entry
 callbacks

Page table walker doesn't check non-present hugetlb entry in common path,
so hugetlb_entry() callbacks must check it. The reason for this behavior
is that some callers want to handle it in its own way.

However, some callers don't check it now, which causes unpredictable
result, for example when we have a race between migrating hugepage and
reading /proc/pid/numa_maps. This patch fixes it by adding !pte_present
checks on buggy callbacks.

This bug exists for years and got visible by introducing hugepage migration.

ChangeLog v2:
- fix if condition (check !pte_present() instead of pte_present())

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org> [3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ Backported to 3.15.  Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org> ]
---
 fs/proc/task_mmu.c | 3 +++
 mm/mempolicy.c     | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 442177b1119a..89620cdb57c9 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1354,6 +1354,9 @@ static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 	if (pte_none(*pte))
 		return 0;
 
+	if (!pte_present(*pte))
+		return 0;
+
 	page = pte_page(*pte);
 	if (!page)
 		return 0;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 78e1472933ea..30cc47f8ffa0 100644
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
1.9.3

