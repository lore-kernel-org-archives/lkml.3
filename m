Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3EGOYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:24:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42063 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab3EGNki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 008/118] hugetlbfs: add swap entry check in follow_hugetlb_page()
Date: Tue,  7 May 2013 14:37:34 +0100
Message-Id: <1367933964-1564-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit 9cc3a5bd40067b9a0fbd49199d0780463fc2140f upstream.

With applying the previous patch "hugetlbfs: stop setting VM_DONTDUMP in
initializing vma(VM_HUGETLB)" to reenable hugepage coredump, if a memory
error happens on a hugepage and the affected processes try to access the
error hugepage, we hit VM_BUG_ON(atomic_read(&page->_count) <= 0) in
get_page().

The reason for this bug is that coredump-related code doesn't recognise
"hugepage hwpoison entry" with which a pmd entry is replaced when a memory
error occurs on a hugepage.

In other words, physical address information is stored in different bit
layout between hugepage hwpoison entry and pmd entry, so
follow_hugetlb_page() which is called in get_dump_page() returns a wrong
page from a given address.

The expected behavior is like this:

  absent   is_swap_pte   FOLL_DUMP   Expected behavior
  -------------------------------------------------------------------
   true     false         false       hugetlb_fault
   false    true          false       hugetlb_fault
   false    false         false       return page
   true     false         true        skip page (to avoid allocation)
   false    true          true        hugetlb_fault
   false    false         true        return page

With this patch, we can call hugetlb_fault() and take proper actions (we
wait for migration entries, fail with VM_FAULT_HWPOISON_LARGE for
hwpoisoned entries,) and as the result we can dump all hugepages except
for hwpoisoned ones.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/hugetlb.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f30e463..74b8327 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2907,7 +2907,17 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			break;
 		}
 
-		if (absent ||
+		/*
+		 * We need call hugetlb_fault for both hugepages under migration
+		 * (in which case hugetlb_fault waits for the migration,) and
+		 * hwpoisoned hugepages (in which case we need to prevent the
+		 * caller from accessing to them.) In order to do this, we use
+		 * here is_swap_pte instead of is_hugetlb_entry_migration and
+		 * is_hugetlb_entry_hwpoisoned. This is because it simply covers
+		 * both cases, and because we can't follow correct pages
+		 * directly from any kind of swap entries.
+		 */
+		if (absent || is_swap_pte(huge_ptep_get(pte)) ||
 		    ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
 			int ret;
 
-- 
1.8.1.2

