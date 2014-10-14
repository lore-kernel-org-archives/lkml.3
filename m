Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbaJNUQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:16:55 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41629 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaJNUQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:16:53 -0400
From: Yu Zhao <yuzhao@google.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Yu Zhao <yuzhao@google.com>
Subject: [PATCH 1/2] mm: free compound page with correct order
Date: Tue, 14 Oct 2014 13:16:39 -0700
Message-Id: <1413317800-25450-1-git-send-email-yuzhao@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compound page should be freed by put_page() or free_pages() with
correct order. Not doing so with causing the tail pages leaked.

The compound order can be obtained by compound_order() or use
HPAGE_PMD_ORDER in our case. Some people would argue the latter
is faster but I prefer the former which is more general.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 mm/huge_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 74c78aa..780d12c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -200,7 +200,7 @@ retry:
 	preempt_disable();
 	if (cmpxchg(&huge_zero_page, NULL, zero_page)) {
 		preempt_enable();
-		__free_page(zero_page);
+		__free_pages(zero_page, compound_order(zero_page));
 		goto retry;
 	}
 
@@ -232,7 +232,7 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
 		struct page *zero_page = xchg(&huge_zero_page, NULL);
 		BUG_ON(zero_page == NULL);
-		__free_page(zero_page);
+		__free_pages(zero_page, compound_order(zero_page));
 		return HPAGE_PMD_NR;
 	}
 
-- 
2.1.0.rc2.206.gedb03e5

