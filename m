Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3CaXqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 19:46:47 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62003 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab3CaXqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 19:46:46 -0400
X-AuditID: 9c93016f-b7b6aae000000e9c-79-5158cae4ad92
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>
Subject: [PATCH] THP: Use explicit memory barrier
Date: Mon,  1 Apr 2013 08:45:35 +0900
Message-Id: <1364773535-26264-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__do_huge_pmd_anonymous_page depends on page_add_new_anon_rmap's
spinlock for making sure that clear_huge_page write become visible
after set set_pmd_at() write.

But lru_cache_add_lru uses pagevec so it could miss spinlock
easily so above rule was broken so user may see inconsistent data.

This patch fixes it with using explict barrier rather than depending
on lru spinlock.

Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/huge_memory.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bfa142e..fad800e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -725,11 +725,10 @@ static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 		pmd_t entry;
 		entry = mk_huge_pmd(page, vma);
 		/*
-		 * The spinlocking to take the lru_lock inside
-		 * page_add_new_anon_rmap() acts as a full memory
-		 * barrier to be sure clear_huge_page writes become
-		 * visible after the set_pmd_at() write.
+		 * clear_huge_page write become visible after the
+		 * set_pmd_at() write.
 		 */
+		smp_wmb();
 		page_add_new_anon_rmap(page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
 		pgtable_trans_huge_deposit(mm, pgtable);
-- 
1.8.2

