Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaB1OP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:15:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbaB1OPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:15:34 -0500
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 5/6] mm: compaction: do not set pageblock skip bit when already set
Date: Fri, 28 Feb 2014 15:15:03 +0100
Message-Id: <1393596904-16537-6-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1393596904-16537-1-git-send-email-vbabka@suse.cz>
References: <1393596904-16537-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compaction migratepages scanner calls update_pageblock_skip() for blocks where
isolation failed. It currently does that also for blocks where no isolation
was attempted because the skip bit was already set. This is wasteful, so this
patch reuses the existing skipped_async_unsuitable flag to avoid setting the
skip bit again.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/compaction.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f0db73b..20a75ee 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -529,8 +529,10 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			int mt;
 
 			last_pageblock_nr = pageblock_nr;
-			if (!isolation_suitable(cc, page))
+			if (!isolation_suitable(cc, page)) {
+				skipped_async_unsuitable = true;
 				goto next_pageblock;
+			}
 
 			/*
 			 * For async migration, also only scan in MOVABLE
-- 
1.8.4.5

