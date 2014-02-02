Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaBBFqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 00:46:32 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40298 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaBBFq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 00:46:29 -0500
Date: Sat, 1 Feb 2014 21:46:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, compaction: avoid isolating pinned pages
Message-ID: <alpine.DEB.2.02.1402012145510.2593@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

compact_blocks_moved 7609
compact_pages_moved 3431
compact_pagemigrate_failed 133219
compact_stall 13

After the patch, it is much more efficient:

compact_blocks_moved 7998
compact_pages_moved 6403
compact_pagemigrate_failed 3
compact_stall 15

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/compaction.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -578,6 +578,14 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			continue;
 		}
 
+		/*
+		 * Migration will fail if an anonymous page is pinned in memory,
+		 * so avoid taking zone->lru_lock and isolating it unnecessarily
+		 * in an admittedly racy check.
+		 */
+		if (!page_mapping(page) && page_count(page))
+			continue;
+
 		/* Check if it is ok to still hold the lock */
 		locked = compact_checklock_irqsave(&zone->lru_lock, &flags,
 								locked, cc);
