Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaE1HBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:01:36 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:37607 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaE1HBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:01:32 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] CMA: remove redundant retrying code in __alloc_contig_migrate_range
Date: Wed, 28 May 2014 16:04:30 +0900
Message-Id: <1401260672-28339-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401260672-28339-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1401260672-28339-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have retry logic in migrate_pages(). It does retry 10 times.
So if we keep this retrying code in __alloc_contig_migrate_range(), we
would try to migrate some unmigratable page in 50 times. There is just one
small difference in -ENOMEM case. migrate_pages() don't do retry
in this case, however, current __alloc_contig_migrate_range() does. But,
I think that this isn't problem, because in this case, we may fail again
with same reason.

Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5dba293..674ade7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6185,7 +6185,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 	/* This function is based on compact_zone() from compaction.c. */
 	unsigned long nr_reclaimed;
 	unsigned long pfn = start;
-	unsigned int tries = 0;
 	int ret = 0;
 
 	migrate_prep();
@@ -6204,10 +6203,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 				ret = -EINTR;
 				break;
 			}
-			tries = 0;
-		} else if (++tries == 5) {
-			ret = ret < 0 ? ret : -EBUSY;
-			break;
 		}
 
 		nr_reclaimed = reclaim_clean_pages_from_list(cc->zone,
@@ -6216,6 +6211,10 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 
 		ret = migrate_pages(&cc->migratepages, alloc_migrate_target,
 				    0, MIGRATE_SYNC, MR_CMA);
+		if (ret) {
+			ret = ret < 0 ? ret : -EBUSY;
+			break;
+		}
 	}
 	if (ret < 0) {
 		putback_movable_pages(&cc->migratepages);
-- 
1.7.9.5

