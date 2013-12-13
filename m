Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3LMGvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:51:11 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43203 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab3LMGuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:50:35 -0500
X-AuditID: 9c93017e-b7c17ae000003961-d5-52aaae38d092
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 5/6] mm/compaction: respect ignore_skip_hint in update_pageblock_skip
Date: Fri, 13 Dec 2013 15:53:30 +0900
Message-Id: <1386917611-11319-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386917611-11319-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1386917611-11319-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update_pageblock_skip() only fits to compaction which tries to isolate by
pageblock unit. If isolate_migratepages_range() is called by CMA, it try to
isolate regardless of pageblock unit and it don't reference
get_pageblock_skip() by ignore_skip_hint. We should also respect it on
update_pageblock_skip() to prevent from setting the wrong information.

Cc: <stable@vger.kernel.org> # 3.7+
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/compaction.c b/mm/compaction.c
index 805165b..f58bcd0 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -134,6 +134,10 @@ static void update_pageblock_skip(struct compact_control *cc,
 			bool migrate_scanner)
 {
 	struct zone *zone = cc->zone;
+
+	if (cc->ignore_skip_hint)
+		return;
+
 	if (!page)
 		return;
 
-- 
1.7.9.5

