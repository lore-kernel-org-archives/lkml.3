Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaCGMBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:01:37 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:48228 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaCGMBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:01:35 -0500
Date: Fri, 7 Mar 2014 04:01:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, compaction: determine isolation mode only once
Message-ID: <alpine.DEB.2.02.1403070358120.13046@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conditions that control the isolation mode in 
isolate_migratepages_range() do not change during the iteration, so 
extract them out and only define the value once.

This actually does have an effect, gcc doesn't optimize it itself because 
of cc->sync.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/compaction.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -454,12 +454,13 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
-	isolate_mode_t mode = 0;
 	struct lruvec *lruvec;
 	unsigned long flags;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
 	bool skipped_async_unsuitable = false;
+	const isolate_mode_t mode = (!cc->sync ? ISOLATE_ASYNC_MIGRATE : 0) |
+				    (unevictable ? ISOLATE_UNEVICTABLE : 0);
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -592,12 +593,6 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			continue;
 		}
 
-		if (!cc->sync)
-			mode |= ISOLATE_ASYNC_MIGRATE;
-
-		if (unevictable)
-			mode |= ISOLATE_UNEVICTABLE;
-
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 
 		/* Try isolate the page */
