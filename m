Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbaH1TGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:06:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaH1SgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:17 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 27/97] mm, compaction: avoid isolating pinned pages
Date: Thu, 28 Aug 2014 19:34:35 +0100
Message-Id: <1409250945-30874-28-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

commit 119d6d59dcc0980dcd581fdadb6b2033b512a473 upstream.

Page migration will fail for memory that is pinned in memory with, for
example, get_user_pages().  In this case, it is unnecessary to take
zone->lru_lock or isolating the page and passing it to page migration
which will ultimately fail.

This is a racy check, the page can still change from under us, but in
that case we'll just fail later when attempting to move the page.

This avoids very expensive memory compaction when faulting transparent
hugepages after pinning a lot of memory with a Mellanox driver.

On a 128GB machine and pinning ~120GB of memory, before this patch we
see the enormous disparity in the number of page migration failures
because of the pinning (from /proc/vmstat):

	compact_pages_moved 8450
	compact_pagemigrate_failed 15614415

0.05% of pages isolated are successfully migrated and explicitly
triggering memory compaction takes 102 seconds.  After the patch:

	compact_pages_moved 9197
	compact_pagemigrate_failed 7

99.9% of pages isolated are now successfully migrated in this
configuration and memory compaction takes less than one second.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index ae428e6..4885387 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -582,6 +582,15 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			continue;
 		}
 
+		/*
+		 * Migration will fail if an anonymous page is pinned in memory,
+		 * so avoid taking lru_lock and isolating it unnecessarily in an
+		 * admittedly racy check.
+		 */
+		if (!page_mapping(page) &&
+		    page_count(page) > page_mapcount(page))
+			continue;
+
 		/* Check if it is ok to still hold the lock */
 		locked = compact_checklock_irqsave(&zone->lru_lock, &flags,
 								locked, cc);
-- 
1.8.4.5

