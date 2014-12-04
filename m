Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbaLDRNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:13:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466AbaLDRNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:13:17 -0500
From: Vlastimil Babka <vbabka@suse.cz>
To: linux-mm@kvack.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>
Subject: [RFC PATCH 2/3] mm: more aggressive page stealing for UNMOVABLE allocations
Date: Thu,  4 Dec 2014 18:12:57 +0100
Message-Id: <1417713178-10256-3-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417713178-10256-1-git-send-email-vbabka@suse.cz>
References: <1417713178-10256-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocation falls back to stealing free pages of another migratetype,
it can decide to steal extra pages, or even the whole pageblock in order to
reduce fragmentation, which could happen if further allocation fallbacks
pick a different pageblock. In try_to_steal_freepages(), one of the situations
where extra pages are stolen happens when we are trying to allocate a
MIGRATE_RECLAIMABLE page.

However, MIGRATE_UNMOVABLE allocations are not treated the same way, although
spreading such allocation over multiple fallback pageblocks is arguably even
worse than it is for RECLAIMABLE allocations. To minimize fragmentation, we
should minimize the number of such fallbacks, and thus steal as much as is
possible from each fallback pageblock.

This patch thus adds a check for MIGRATE_UNMOVABLE to the decision to steal
extra free pages. When evaluating with stress-highalloc from mmtests, this has
reduced the number of MIGRATE_UNMOVABLE fallbacks to roughly 1/6. The number
of these fallbacks stealing from MIGRATE_MOVABLE block is reduced to 1/3.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 548b072..a14249c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1098,6 +1098,7 @@ static int try_to_steal_freepages(struct zone *zone, struct page *page,
 
 	if (current_order >= pageblock_order / 2 ||
 	    start_type == MIGRATE_RECLAIMABLE ||
+	    start_type == MIGRATE_UNMOVABLE ||
 	    page_group_by_mobility_disabled) {
 		int pages;
 
-- 
2.1.2

