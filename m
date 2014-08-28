Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbaH1TDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:03:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbaH1SgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:21 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 33/97] mm, compaction: determine isolation mode only once
Date: Thu, 28 Aug 2014 19:34:41 +0100
Message-Id: <1409250945-30874-34-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

commit da1c67a76f7cf2b3404823d24f9f10fa91aa5dc5 upstream.

The conditions that control the isolation mode in
isolate_migratepages_range() do not change during the iteration, so
extract them out and only define the value once.

This actually does have an effect, gcc doesn't optimize it itself because
of cc->sync.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 10f9f8c..4530818 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -461,12 +461,13 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
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
@@ -606,12 +607,6 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
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
-- 
1.8.4.5

