Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbaFIWq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:46:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960AbaFIWpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 68/78] mm: add !pte_present() check on existing hugetlb_entry callbacks
Date: Mon,  9 Jun 2014 15:48:48 -0700
Message-Id: <20140609224815.516161345@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/task_mmu.c |    2 +-
 mm/mempolicy.c     |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1350,7 +1350,7 @@ static int gather_hugetbl_stats(pte_t *p
 	struct numa_maps *md;
 	struct page *page;
 
-	if (pte_none(*pte))
+	if (!pte_present(*pte))
 		return 0;
 
 	page = pte_page(*pte);
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -526,9 +526,13 @@ static void queue_pages_hugetlb_pmd_rang
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


