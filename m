Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaKFWk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:40:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58639 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaKFWkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:40:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yu Zhao <yuzhao@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, David Rientjes <rientjes@google.com>,
        Bob Liu <lliubbo@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 149/162] mm: free compound page with correct order
Date: Thu,  6 Nov 2014 14:36:53 -0800
Message-Id: <1415313426-9622-150-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhao <yuzhao@google.com>

commit 5ddacbe92b806cd5b4f8f154e8e46ac267fff55c upstream.

Compound page should be freed by put_page() or free_pages() with correct
order.  Not doing so will cause tail pages leaked.

The compound order can be obtained by compound_order() or use
HPAGE_PMD_ORDER in our case.  Some people would argue the latter is
faster but I prefer the former which is more general.

This bug was observed not just on our servers (the worst case we saw is
11G leaked on a 48G machine) but also on our workstations running Ubuntu
based distro.

  $ cat /proc/vmstat  | grep thp_zero_page_alloc
  thp_zero_page_alloc 55
  thp_zero_page_alloc_failed 0

This means there is (thp_zero_page_alloc - 1) * (2M - 4K) memory leaked.

Fixes: 97ae17497e99 ("thp: implement refcounting for huge zero page")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 64a7f9c..310f27e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -193,7 +193,7 @@ retry:
 	preempt_disable();
 	if (cmpxchg(&huge_zero_page, NULL, zero_page)) {
 		preempt_enable();
-		__free_page(zero_page);
+		__free_pages(zero_page, compound_order(zero_page));
 		goto retry;
 	}
 
@@ -225,7 +225,7 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct page *zero_page = xchg(&huge_zero_page, NULL);
 		BUG_ON(zero_page == NULL);
-		__free_page(zero_page);
+		__free_pages(zero_page, compound_order(zero_page));
 		return HPAGE_PMD_NR;
 	}
 
-- 
1.9.1

