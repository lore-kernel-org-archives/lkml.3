Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966957AbaFQWix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:38:53 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:54098 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966205AbaFQWiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:38:21 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 1/2] mm, thp: move invariant bug check out of loop in __split_huge_page_map
Date: Tue, 17 Jun 2014 18:37:58 -0400
Message-Id: <1403044679-9993-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1403044679-9993-1-git-send-email-Waiman.Long@hp.com>
References: <1403044679-9993-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the __split_huge_page_map() function, the check for
page_mapcount(page) is invariant within the for loop. Because of the
fact that the macro is implemented using atomic_read(), the redundant
check cannot be optimized away by the compiler leading to unnecessary
read to the page structure.

This patch moves the invariant bug check out of the loop so that it
will be done only once. On a 3.16-rc1 based kernel, the execution
time of a microbenchmark that broke up 1000 transparent huge pages
using munmap() had an execution time of 38,245us and 38,548us with
and without the patch respectively. The performance gain is about 1%.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 mm/huge_memory.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e60837d..be84c71 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1744,6 +1744,8 @@ static int __split_huge_page_map(struct page *page,
 	if (pmd) {
 		pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 		pmd_populate(mm, &_pmd, pgtable);
+		if (pmd_write(*pmd))
+			BUG_ON(page_mapcount(page) != 1);
 
 		haddr = address;
 		for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
@@ -1753,8 +1755,6 @@ static int __split_huge_page_map(struct page *page,
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 			if (!pmd_write(*pmd))
 				entry = pte_wrprotect(entry);
-			else
-				BUG_ON(page_mapcount(page) != 1);
 			if (!pmd_young(*pmd))
 				entry = pte_mkold(entry);
 			if (pmd_numa(*pmd))
-- 
1.7.1

