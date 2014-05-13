Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbaEMJqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:46:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932769AbaEMJqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:46:03 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 07/19] mm: page_alloc: Only check the alloc flags and gfp_mask for dirty once
Date: Tue, 13 May 2014 10:45:38 +0100
Message-Id: <1399974350-11089-8-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1399974350-11089-1-git-send-email-mgorman@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it's calculated once per zone in the zonelist.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/page_alloc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8971953..2e576fd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1925,6 +1925,8 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 	nodemask_t *allowednodes = NULL;/* zonelist_cache approximation */
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
+	bool consider_zone_dirty = (alloc_flags & ALLOC_WMARK_LOW) &&
+				(gfp_mask & __GFP_WRITE);
 
 zonelist_scan:
 	/*
@@ -1983,8 +1985,7 @@ zonelist_scan:
 		 * will require awareness of zones in the
 		 * dirty-throttling and the flusher threads.
 		 */
-		if ((alloc_flags & ALLOC_WMARK_LOW) &&
-		    (gfp_mask & __GFP_WRITE) && !zone_dirty_ok(zone))
+		if (consider_zone_dirty && !zone_dirty_ok(zone))
 			continue;
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
-- 
1.8.4.5

