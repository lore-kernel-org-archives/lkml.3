Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaFWNFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:05:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37254 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbaFWNF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 85/93] mm: compaction: reset cached scanner pfn's before reading them
Date: Mon, 23 Jun 2014 14:03:04 +0100
Message-Id: <1403528592-2163-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

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
[ luis: backported to 3.11: used vbabka's backport for 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/compaction.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 46e2f96454bc..87a815630379 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -949,6 +949,14 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
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
@@ -964,14 +972,6 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
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
1.9.1

