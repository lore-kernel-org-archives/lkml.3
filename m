Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3EIHVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 03:21:35 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58264 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3EIHVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 03:21:33 -0400
X-AuditID: 9c93016f-b7ba0ae000004cc2-68-518b4e7b975f
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Minkyung Kim <minkyung88@lge.com>,
        Minchan Kim <minchan@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH v5 1/7] mm: prevent to write out dirty page in CMA by may_writepage
Date: Thu,  9 May 2013 16:21:23 +0900
Message-Id: <1368084089-24576-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368084089-24576-1-git-send-email-minchan@kernel.org>
References: <1368084089-24576-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, local variable references in shrink_page_list is
PAGEREF_RECLAIM_CLEAN as default. It is for preventing to reclaim
dirty pages when CMA try to migrate pages.
Strictly speaking, we don't need it because CMA already didn't allow
to write out by .may_writepage = 0 in reclaim_clean_pages_from_list.

Morever, it has a problem to prevent anonymous pages's swap out when
we use force_reclaim = true in shrink_page_list(ex, per process reclaim
can do it)

So this patch makes references's default value to PAGEREF_RECLAIM
and declare .may_writepage = 0 of scan_control in CMA part to make
code more clear.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Reported-by: Minkyung Kim <minkyung88@lge.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fa6a853..c22f9c1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -695,7 +695,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		struct address_space *mapping;
 		struct page *page;
 		int may_enter_fs;
-		enum page_references references = PAGEREF_RECLAIM_CLEAN;
+		enum page_references references = PAGEREF_RECLAIM;
 
 		cond_resched();
 
@@ -972,6 +972,8 @@ unsigned long reclaim_clean_pages_from_list(struct zone *zone,
 		.gfp_mask = GFP_KERNEL,
 		.priority = DEF_PRIORITY,
 		.may_unmap = 1,
+		/* Doesn't allow to write out dirty page */
+		.may_writepage = 0,
 	};
 	unsigned long ret, dummy1, dummy2;
 	struct page *page, *next;
-- 
1.8.2.1

