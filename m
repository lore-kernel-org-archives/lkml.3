Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaJNC0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 22:26:06 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:52731 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaJNC0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 22:26:04 -0400
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
Subject: [PATCH] mm/compaction: avoid premature range skip in isolate_migratepages_range
Date: Tue, 14 Oct 2014 11:26:28 +0900
Message-Id: <1413253588-26457-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit edc2ca612496 ("mm, compaction: move pageblock checks up from
isolate_migratepages_range()") commonizes isolate_migratepages variants
and make them use isolate_migratepages_block().
isolate_migratepages_block() could stop the execution when enough pages
are isolated, but, there is no code in isolate_migratepages_range()
to handle this case. In the result, even if isolate_migratepages_block()
returns prematurely without checking all pages in the range,
isolate_migratepages_block() is called repeately on the following
pageblock and some pages in the previous range are skipped to check.
Then, CMA is failed frequently due to this fact.

To fix this problem, this patch let isolate_migratepages_range() know
the situation that enough pages are isolated and stop the isolation
in that case.

Note that isolate_migratepages() has no such problem, because, it always
stops the isolation after just one call of isolate_migratepages_block().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/compaction.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index edba18a..ec74cf0 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -784,6 +784,9 @@ isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
 			cc->nr_migratepages = 0;
 			break;
 		}
+
+		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
+			break;
 	}
 	acct_isolated(cc->zone, cc);
 
-- 
1.7.9.5

