Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaFWIkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:40:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55605 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 010/111] mm: compaction: reset cached scanner pfn's before reading them
Date: Mon, 23 Jun 2014 10:30:45 +0200
Message-Id: <948ec1dbfa6a5846473649655c1fd376be286a43.1403512280.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d3132e4b83e6bd383c74d716f7281d7c3136089c upstream.

Compaction caches pfn's for its migrate and free scanners to avoid
scanning the whole zone each time.  In compact_zone(), the cached values
are read to set up initial values for the scanners.  There are several
situations when these cached pfn's are reset to the first and last pfn
of the zone, respectively.  One of these situations is when a compaction
has been deferred for a zone and is now being restarted during a direct
compaction, which is also done in compact_zone().

However, compact_zone() currently reads the cached pfn's *before*
resetting them.  This means the reset doesn't affect the compaction that
performs it, and with good chance also subsequent compactions, as
update_pageblock_skip() is likely to be called and update the cached
pfn's to those being processed.  Another chance for a successful reset
is when a direct compaction detects that migration and free scanners
meet (which has its own problems addressed by another patch) and sets
update_pageblock_skip flag which kswapd uses to do the reset because it
goes to sleep.

This is clearly a bug that results in non-deterministic behavior, so
this patch moves the cached pfn reset to be performed *before* the
values are read.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/compaction.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index d2c6751879dc..c2082d8674b3 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -954,6 +954,14 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	}
 
 	/*
+	 * Clear pageblock skip if there were failures recently and compaction
+	 * is about to be retried after being deferred. kswapd does not do
+	 * this reset as it'll reset the cached information when going to sleep.
+	 */
+	if (compaction_restarting(zone, cc->order) && !current_is_kswapd())
+		__reset_isolation_suitable(zone);
+
+	/*
 	 * Setup to move all movable pages to the end of the zone. Used cached
 	 * information on where the scanners should start but check that it
 	 * is initialised by ensuring the values are within zone boundaries.
@@ -969,14 +977,6 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 		zone->compact_cached_migrate_pfn = cc->migrate_pfn;
 	}
 
-	/*
-	 * Clear pageblock skip if there were failures recently and compaction
-	 * is about to be retried after being deferred. kswapd does not do
-	 * this reset as it'll reset the cached information when going to sleep.
-	 */
-	if (compaction_restarting(zone, cc->order) && !current_is_kswapd())
-		__reset_isolation_suitable(zone);
-
 	migrate_prep_local();
 
 	while ((ret = compact_finished(zone, cc)) == COMPACT_CONTINUE) {
-- 
2.0.0

