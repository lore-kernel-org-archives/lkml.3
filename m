Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaHFN4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:56:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbaHFN4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:56:15 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 1/4] mm: page_alloc: determine migratetype only once
Date: Wed,  6 Aug 2014 15:55:53 +0200
Message-Id: <1407333356-30928-2-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1407333356-30928-1-git-send-email-vbabka@suse.cz>
References: <1407333356-30928-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check for ALLOC_CMA in __alloc_pages_nodemask() derives migratetype
from gfp_mask in each retry pass, although the migratetype variable already
has the value determined and it does not change. Use the variable and perform
the check only once. Also convert #ifdef CONFIC_CMA to IS_ENABLED.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/page_alloc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d0e3d2f..b2cd463 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2775,6 +2775,9 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	if (unlikely(!zonelist->_zonerefs->zone))
 		return NULL;
 
+	if (IS_ENABLED(CONFIG_CMA) && migratetype == MIGRATE_MOVABLE)
+		alloc_flags |= ALLOC_CMA;
+
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
@@ -2786,10 +2789,6 @@ retry_cpuset:
 		goto out;
 	classzone_idx = zonelist_zone_idx(preferred_zoneref);
 
-#ifdef CONFIG_CMA
-	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
-		alloc_flags |= ALLOC_CMA;
-#endif
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, alloc_flags,
-- 
1.8.4.5

