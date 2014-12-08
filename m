Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaLHHMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:12:36 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34151 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbaLHHMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:12:35 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/4] mm/compaction: fix wrong order check in compact_finished()
Date: Mon,  8 Dec 2014 16:16:17 +0900
Message-Id: <1418022980-4584-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418022980-4584-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1418022980-4584-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What we want to check here is whether there is highorder freepage
in buddy list of other migratetype in order to steal it without
fragmentation. But, current code just checks cc->order which means
allocation request order. So, this is wrong.

Without this fix, non-movable synchronous compaction below pageblock order
would not stopped until compaction is complete, because migratetype of most
pageblocks are movable and high order freepage made by compaction is usually
on movable type buddy list.

There is some report related to this bug. See below link.

http://www.spinics.net/lists/linux-mm/msg81666.html

Although the issued system still has load spike comes from compaction,
this makes that system completely stable and responsive according to
his report.

stress-highalloc test in mmtests with non movable order 7 allocation doesn't
show any notable difference in allocation success rate, but, it shows more
compaction success rate and reduced elapsed time.

Compaction success rate (Compaction success * 100 / Compaction stalls, %)
18.47 : 28.94

Elapsed time (sec)
1429 : 1411

Cc: <stable@vger.kernel.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index c9ee464..1a5f465 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1105,7 +1105,7 @@ static int __compact_finished(struct zone *zone, struct compact_control *cc,
 			return COMPACT_PARTIAL;
 
 		/* Job done if allocation would set block type */
-		if (cc->order >= pageblock_order && area->nr_free)
+		if (order >= pageblock_order && area->nr_free)
 			return COMPACT_PARTIAL;
 	}
 
-- 
1.7.9.5

