Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab3HNEqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 00:46:14 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:28521 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3HNEqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 00:46:11 -0400
Message-ID: <520B0B75.4030708@huawei.com>
Date: Wed, 14 Aug 2013 12:45:41 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        <aquini@redhat.com>
CC: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] mm: skip the page buddy block instead of one page
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A large free page buddy block will continue many times, so if the page 
is free, skip the whole page buddy block instead of one page.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/compaction.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 05ccb4c..874bae1 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -520,9 +520,10 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			goto next_pageblock;
 
 		/* Skip if free */
-		if (PageBuddy(page))
+		if (PageBuddy(page)) {
+			low_pfn += (1 << page_order(page)) - 1;
 			continue;
-
+		}
 		/*
 		 * For async migration, also only scan in MOVABLE blocks. Async
 		 * migration is optimistic to see if the minimum amount of work
-- 
1.7.1

