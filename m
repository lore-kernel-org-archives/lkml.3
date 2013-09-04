Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138Ab3IDX0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:26:05 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52688 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3IDX0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:26:02 -0400
Date: Wed, 4 Sep 2013 16:25:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch] mm, compaction: periodically schedule when freeing pages
Message-ID: <alpine.DEB.2.02.1309041625060.29607@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been getting warnings about an excessive amount of time spent
allocating pages for migration during memory compaction without
scheduling.  isolate_freepages_block() already periodically checks for
contended locks or the need to schedule, but isolate_freepages() never
does.

When a zone is massively long and no suitable targets can be found, this
iteration can be quite expensive without ever doing cond_resched().

Check periodically for the need to reschedule while the compaction free
scanner iterates.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/compaction.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -677,6 +677,13 @@ static void isolate_freepages(struct zone *zone,
 					pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
 
+		/*
+		 * This can iterate a massively long zone without finding any
+		 * suitable migration targets, so periodically check if we need
+		 * to schedule.
+		 */
+		cond_resched();
+
 		if (!pfn_valid(pfn))
 			continue;
 
