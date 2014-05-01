Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaEAIu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:50:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaEAIoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:44:55 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/17] mm: page_alloc: Only check the zone id check if pages are buddies
Date: Thu,  1 May 2014 09:44:36 +0100
Message-Id: <1398933888-4940-6-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1398933888-4940-1-git-send-email-mgorman@suse.de>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A node/zone index is used to check if pages are compatible for merging
but this happens unconditionally even if the buddy page is not free. Defer
the calculation as long as possible. Ideally we would check the zone boundary
but nodes can overlap.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3b6ae9d..8971953 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -508,16 +508,26 @@ static inline int page_is_buddy(struct page *page, struct page *buddy,
 	if (!pfn_valid_within(page_to_pfn(buddy)))
 		return 0;
 
-	if (page_zone_id(page) != page_zone_id(buddy))
-		return 0;
-
 	if (page_is_guard(buddy) && page_order(buddy) == order) {
 		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
+
+		if (page_zone_id(page) != page_zone_id(buddy))
+			return 0;
+
 		return 1;
 	}
 
 	if (PageBuddy(buddy) && page_order(buddy) == order) {
 		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
+
+		/*
+		 * zone check is done late to avoid uselessly
+		 * calculating zone/node ids for pages that could
+		 * never merge.
+		 */
+		if (page_zone_id(page) != page_zone_id(buddy))
+			return 0;
+
 		return 1;
 	}
 	return 0;
-- 
1.8.4.5

