Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271AbaLIHli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:41:38 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28599 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaLIHlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:41:37 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-04-5486a7ae0c41
From: Weijie Yang <weijie.yang@samsung.com>
To: mgorman@suse.de
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Johannes Weiner'" <hannes@cmpxchg.org>,
        "'Rik van Riel'" <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: [PATCH] mm: page_alloc: place zone id check before VM_BUG_ON_PAGE check
Date: Tue, 09 Dec 2014 15:40:35 +0800
Message-id: <000001d01383$8e0f1120$aa2d3360$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdATg2sCgnMnKwFZR4uFzxGcBhBclw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t9jQd11y9tCDC4eELCYs34Nm8XqTb4W
	l3fNYbO4t+Y/q8Xkd88YLf5eWc9i8eTEfxYHdo/Db94ze+ycdZfdY9OnSeweJ2b8ZvF4v+8q
	m8fm09UenzfJBbBHcdmkpOZklqUW6dslcGUcXdzJWHCOp6Lh3nmWBsY/nF2MnBwSAiYSV5sn
	s0HYYhIX7q0Hsrk4hASmM0rc+bmEEcL5wyhx7NkcZpAqNgFtibv9G1lBbBEBYYnXN7eCxZkF
	bjMCtQeB2MICARJrt85mB7FZBFQlzq/eywJi8wrYScye+JcNwhaU+DH5HlCcA6hXXWLKlFyI
	MfISm9e8ZQYJSwCFH/3VhdikJ3Hu3komiBJxiY1HbrFMYBSYhWTQLIRBs5AMmoWkYwEjyypG
	0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Eh4Jr2DcVWDxSFGAQ5GJR5eDcu2ECHWxLLiytxD
	jBIczEoivEpLgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5leyBUgLpiSWp2ampBalFMFkmDk6p
	BkYhheTH5mz/Lj9y2sxasGvjUaGwTtPI4xHeYR9XsUbcMXbblzI34vjfnYbvjCS+VP+Rs9nP
	ztTGE/nIjf3BuvBaoyeznvEtkPl2+Hl+8jKh5SlZM1uk3n71sU+Ianm/pMkjaUoOz5HJ/5er
	czNMX/Hbo8vN/3WlxS6Gs761+Yd+n5v3OFU8oFqJpTgj0VCLuag4EQDIsVhLgAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the free page and its buddy has different zone id, the current
zone->lock cann't prevent buddy page getting allocated, this could
trigger VM_BUG_ON_PAGE in a very tiny chance:

cpu 0:						cpu 1:
hold zone_1 lock
check page and it buddy
PageBuddy(buddy) is true			hold zone_2 lock
page_order(buddy) == order is true		alloc buddy
trigger VM_BUG_ON_PAGE(page_count(buddy) != 0)

This patch fixes this issue by placing the zone id check before
the VM_BUG_ON_PAGE check.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
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


