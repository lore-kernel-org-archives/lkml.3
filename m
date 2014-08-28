Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaH1Sxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:53:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbaH1Sgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:45 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 57/97] mm, compaction: terminate async compaction when rescheduling
Date: Thu, 28 Aug 2014 19:35:05 +0100
Message-Id: <1409250945-30874-58-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

commit aeef4b83806f49a0c454b7d4578671b71045bee2 upstream.

Async compaction terminates prematurely when need_resched(), see
compact_checklock_irqsave().  This can never trigger, however, if the
cond_resched() in isolate_migratepages_range() always takes care of the
scheduling.

If the cond_resched() actually triggers, then terminate this pageblock
scan for async compaction as well.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index cebdeca..4933fde 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -495,8 +495,13 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			return 0;
 	}
 
+	if (cond_resched()) {
+		/* Async terminates prematurely on need_resched() */
+		if (cc->mode == MIGRATE_ASYNC)
+			return 0;
+	}
+
 	/* Time to isolate some pages for migration */
-	cond_resched();
 	for (; low_pfn < end_pfn; low_pfn++) {
 		/* give a chance to irqs before checking need_resched() */
 		if (locked && !(low_pfn % SWAP_CLUSTER_MAX)) {
-- 
1.8.4.5

