Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaFDQMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:12:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaFDQM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:12:27 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: [RFC PATCH 2/6] mm, compaction: skip rechecks when lock was already held
Date: Wed,  4 Jun 2014 18:11:46 +0200
Message-Id: <1401898310-14525-2-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1401898310-14525-1-git-send-email-vbabka@suse.cz>
References: <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com>
 <1401898310-14525-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compaction scanners try to lock zone locks as late as possible by checking
many page or pageblock properties opportunistically without lock and skipping
them if not unsuitable. For pages that pass the initial checks, some properties
have to be checked again safely under lock. However, if the lock was already
held from a previous iteration in the initial checks, the rechecks are
unnecessary.

This patch therefore skips the rechecks when the lock was already held. This is
now possible to do, since we don't (potentially) drop and reacquire the lock
between the initial checks and the safe rechecks anymore.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
---
 mm/compaction.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f0fd4b5..27c73d7 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -332,6 +332,16 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 			goto isolate_fail;
 
 		/*
+		 * If we already hold the lock, we can skip some rechecking.
+		 * Note that if we hold the lock now, checked_pageblock was
+		 * already set in some previous iteration (or strict is true),
+		 * so it is correct to skip the suitable migration target
+		 * recheck as well.
+		 */
+		if (locked)
+			goto skip_recheck;
+
+		/*
 		 * The zone lock must be held to isolate freepages.
 		 * Unfortunately this is a very coarse lock and can be
 		 * heavily contended if there are parallel allocations
@@ -339,9 +349,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		 * spin on the lock and we acquire the lock as late as
 		 * possible.
 		 */
-		if (!locked)
-			locked = compact_trylock_irqsave(&cc->zone->lock,
-								&flags, cc);
+		locked = compact_trylock_irqsave(&cc->zone->lock, &flags, cc);
 		if (!locked)
 			break;
 
@@ -361,6 +369,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		if (!PageBuddy(page))
 			goto isolate_fail;
 
+skip_recheck:
 		/* Found a free page, break it into order-0 pages */
 		isolated = split_free_page(page);
 		total_isolated += isolated;
@@ -671,10 +680,11 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		    page_count(page) > page_mapcount(page))
 			continue;
 
-		/* If the lock is not held, try to take it */
-		if (!locked)
-			locked = compact_trylock_irqsave(&zone->lru_lock,
-								&flags, cc);
+		/* If we already hold the lock, we can skip some rechecking */
+		if (locked)
+			goto skip_recheck;
+
+		locked = compact_trylock_irqsave(&zone->lru_lock, &flags, cc);
 		if (!locked)
 			break;
 
@@ -686,6 +696,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			continue;
 		}
 
+skip_recheck:
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 
 		/* Try isolate the page */
-- 
1.8.4.5

