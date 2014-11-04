Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaKDCfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:35:55 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:47586 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaKDCft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:35:49 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 for v3.18] mm/compaction: skip the range until proper target pageblock is met
Date: Tue,  4 Nov 2014 11:37:29 +0900
Message-Id: <1415068649-18040-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7d49d8868336 ("mm, compaction: reduce zone checking frequency in
the migration scanner") makes side-effect that change iteration
range calculation. Before change, block_end_pfn is calculated using
start_pfn, but, now, blindly add pageblock_nr_pages to previous value.

This cause the problem that isolation_start_pfn is larger than
block_end_pfn when we isolate the page with more than pageblock order.
In this case, isolation would be failed due to invalid range parameter.

To prevent this, this patch recalculate the range to find valid target
pageblock. Without this patch, CMA with more than pageblock order always
fail, but, with this patch, it will succeed.

Changes from v1:
recalculate the range rather than just skipping to find valid one.
add code comment.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/compaction.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index ec74cf0..4f0151c 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -479,6 +479,16 @@ isolate_freepages_range(struct compact_control *cc,
 
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
+		/*
+		 * pfn could pass the block_end_pfn if isolated freepage
+		 * is more than pageblock order. In this case, we adjust
+		 * scanning range to right one.
+		 */
+		if (pfn >= block_end_pfn) {
+			block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+			block_end_pfn = min(block_end_pfn, end_pfn);
+		}
+
 		if (!pageblock_pfn_to_page(pfn, block_end_pfn, cc->zone))
 			break;
 
-- 
1.7.9.5

