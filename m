Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966012AbaLMIWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 03:22:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63349 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965934AbaLMIWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 03:22:32 -0500
X-AuditID: cbfee61a-f79c06d000004e71-f5-548bf746f533
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: mgorman@suse.de, "'Johannes Weiner'" <hannes@cmpxchg.org>,
        "'Rik van Riel'" <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH ] mm: page_alloc: place zone_id check before
 VM_BUG_ON_PAGE check
Date: Sat, 13 Dec 2014 16:21:36 +0800
Message-id: <000101d016ad$f0278720$d0769560$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAWrc+VqYsCCQ1eTrKsNc09fdmXLw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jAV23790hBoc7bCzmrF/DZrF6k6/F
	5V1z2CzurfnPajH53TNGi79X1rM4sHkcfvOe2WPTp0nsHidm/GbxeL/vKpvH5tPVHp83yQWw
	RXHZpKTmZJalFunbJXBlLOwKLHjPX/H48h/GBsZbPF2MnBwSAiYS13ffYYewxSQu3FvP1sXI
	xSEksIhR4s72zcwgCSGBP4wSp98KgthsAtoSd/s3snYxcnCICOhLtLVogNQzC0xmlNjfcxCs
	XlggSmLrskVsIDaLgKrEnP5DYAt4Bewk5uz5DGULSvyYfI8FxGYWUJeYNG8RM4QtL7F5zVtm
	kPkSQPFHf3VBwiICehINLZ1sECXiEhuP3GKZwCgwC8mkWUgmzUIyaRaSlgWMLKsYRVMLkguK
	k9JzDfWKE3OLS/PS9ZLzczcxgoP+mdQOxpUNFocYBTgYlXh4LXq7Q4RYE8uKK3MPMUpwMCuJ
	8D7sBwrxpiRWVqUW5ccXleakFh9ilOZgURLnVbJvCxESSE8sSc1OTS1ILYLJMnFwSjUwxlv8
	1Ax4cu28MMOji7e6VNd7rX3zKMzCLyp6zS/FeW+nBrXmxykL984J67O1t7iVcmWpQKj9xuqr
	yZru3PFR1SsVbE9xt0+z/16y9WFQDIcD72rV+0aJMp6SXPfeB2/ZU2Baa737ZYnPo/kFPN8e
	LS1Z6nHn9+xq/1szOWe01XadvRnG9/yyEktxRqKhFnNRcSIA+atRXHYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the freeing page and its buddy page are not at the same zone, the current
holding zone->lock for the freeing page cann't prevent buddy page getting
allocated, this could trigger VM_BUG_ON_PAGE in page_is_buddy() at a
very tiny chance, such as:

cpu 0:						cpu 1:
hold zone_1 lock
check page and it buddy
PageBuddy(buddy) is true			hold zone_2 lock
page_order(buddy) == order is true		alloc buddy
trigger VM_BUG_ON_PAGE(page_count(buddy) != 0)

zone_1->lock prevents the freeing page getting allocated
zone_2->lock prevents the buddy page getting allocated
they are not the same zone->lock.

If we cann't remove the zone_id check statement, it's better handle
this rare race. This patch fixes this by placing the zone_id check
before the VM_BUG_ON_PAGE check.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 616a2c9..491d055 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -488,17 +488,15 @@ static inline int page_is_buddy(struct page *page, struct page *buddy,
 		return 0;
 
 	if (page_is_guard(buddy) && page_order(buddy) == order) {
-		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
-
 		if (page_zone_id(page) != page_zone_id(buddy))
 			return 0;
 
+		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
+
 		return 1;
 	}
 
 	if (PageBuddy(buddy) && page_order(buddy) == order) {
-		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
-
 		/*
 		 * zone check is done late to avoid uselessly
 		 * calculating zone/node ids for pages that could
@@ -507,6 +505,8 @@ static inline int page_is_buddy(struct page *page, struct page *buddy,
 		if (page_zone_id(page) != page_zone_id(buddy))
 			return 0;
 
+		VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
+
 		return 1;
 	}
 	return 0;
-- 
1.7.10.4


