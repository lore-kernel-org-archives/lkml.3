Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab3K1Hqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:46:45 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62354 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3K1Hqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:46:40 -0500
X-AuditID: 9c93016f-b7b6aae000005fae-cb-5296f4df9fbd
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 1/9] mm/rmap: recompute pgoff for huge page
Date: Thu, 28 Nov 2013 16:48:38 +0900
Message-Id: <1385624926-28883-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385624926-28883-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1385624926-28883-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to recompute pgoff if the given page is huge, since result based
on HPAGE_SIZE is not approapriate for scanning the vma interval tree, as
shown by commit 36e4f20af833 ("hugetlb: do not use vma_hugecache_offset()
for vma_prio_tree_foreach") and commit 369a713e ("rmap: recompute pgoff
for unmapping huge page").

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/rmap.c b/mm/rmap.c
index 55c8b8d..1214703 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1714,6 +1714,10 @@ static int rmap_walk_file(struct page *page, int (*rmap_one)(struct page *,
 
 	if (!mapping)
 		return ret;
+
+	if (PageHuge(page))
+		pgoff = page->index << compound_order(page);
+
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
-- 
1.7.9.5

