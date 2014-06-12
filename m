Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaFLXYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:24:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbaFLXSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:18:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 11/18] mm: compaction: reset cached scanner pfns before reading them
Date: Thu, 12 Jun 2014 16:22:15 -0700
Message-Id: <20140612232213.438086731@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232212.960235342@linuxfoundation.org>
References: <20140612232212.960235342@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -947,6 +947,14 @@ static int compact_zone(struct zone *zon
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
@@ -962,14 +970,6 @@ static int compact_zone(struct zone *zon
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


