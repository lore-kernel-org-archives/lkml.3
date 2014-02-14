Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaBNGyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:54:13 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44298 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaBNGyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:54:08 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-00-52fdbd8cb63f
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 2/5] mm/compaction: do not call suitable_migration_target() on every page
Date: Fri, 14 Feb 2014 15:54:00 +0900
Message-Id: <1392360843-22261-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392360843-22261-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1392360843-22261-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

suitable_migration_target() checks that pageblock is suitable for
migration target. In isolate_freepages_block(), it is called on every
page and this is inefficient. So make it called once per pageblock.

suitable_migration_target() also checks if page is highorder or not,
but it's criteria for highorder is pageblock order. So calling it once
within pageblock range has no problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/compaction.c b/mm/compaction.c
index bbe1260..0d821a2 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -245,6 +245,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 	unsigned long nr_strict_required = end_pfn - blockpfn;
 	unsigned long flags;
 	bool locked = false;
+	bool checked_pageblock = false;
 
 	cursor = pfn_to_page(blockpfn);
 
@@ -275,8 +276,16 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 			break;
 
 		/* Recheck this is a suitable migration target under lock */
-		if (!strict && !suitable_migration_target(page))
-			break;
+		if (!strict && !checked_pageblock) {
+			/*
+			 * We need to check suitability of pageblock only once
+			 * and this isolate_freepages_block() is called with
+			 * pageblock range, so just check once is sufficient.
+			 */
+			checked_pageblock = true;
+			if (!suitable_migration_target(page))
+				break;
+		}
 
 		/* Recheck this is a buddy page under lock */
 		if (!PageBuddy(page))
-- 
1.7.9.5

