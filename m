Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab3HFIhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:37:42 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47889 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab3HFIhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:37:37 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-9b-5200b5cf0f91
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 mmotm 1/3] mm, page_alloc: add unlikely macro to help compiler optimization
Date: Tue,  6 Aug 2013 17:37:33 +0900
Message-Id: <1375778255-31398-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We rarely allocate a page with ALLOC_NO_WATERMARKS and it is used
in slow path. For helping compiler optimization, add unlikely macro to
ALLOC_NO_WATERMARKS checking.

This patch doesn't have any effect now, because gcc already optimize
this properly. But we cannot assume that gcc always does right and nobody
re-evaluate if gcc do proper optimization with their change, for example,
it is not optimized properly on v3.10. So adding compiler hint here
is reasonable.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f5c549c..04bec49 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1901,7 +1901,7 @@ zonelist_scan:
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
 		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
-		if (alloc_flags & ALLOC_NO_WATERMARKS)
+		if (unlikely(alloc_flags & ALLOC_NO_WATERMARKS))
 			goto try_this_zone;
 		/*
 		 * Distribute pages in proportion to the individual
-- 
1.7.9.5

