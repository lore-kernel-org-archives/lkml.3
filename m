Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbbARJRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 04:17:38 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60675 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbbARJRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 04:17:33 -0500
From: Hui Zhu <teawater@gmail.com>
To: akpm@linux-foundation.org, mgorman@suse.de, vbabka@suse.cz,
        hannes@cmpxchg.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: teawater@gmail.com, Hui Zhu <zhuhui@xiaomi.com>
Subject: [PATCH] mm/page_alloc: Fix race conditions on getting migratetype in buffered_rmqueue
Date: Sun, 18 Jan 2015 17:17:14 +0800
Message-Id: <1421572634-3399-1-git-send-email-teawater@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hui Zhu <zhuhui@xiaomi.com>

To test the patch [1], I use KGTP and a script [2] to show NR_FREE_CMA_PAGES
and gross of cma_nr_free.  The values are always not same.
I check the code of pages alloc and free and found that race conditions
on getting migratetype in buffered_rmqueue.
Then I add move the code of getting migratetype inside the zone->lock
protection part.

Because this issue will affect system even if the Linux kernel does't
have [1].  So I post this patch separately.

This patchset is based on fc7f0dd381720ea5ee5818645f7d0e9dece41cb0.

[1] https://lkml.org/lkml/2015/1/18/28
[2] https://github.com/teawater/kgtp/blob/dev/add-ons/cma_free.py

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
---
 mm/page_alloc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7633c50..f3d6922 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1694,11 +1694,12 @@ again:
 		}
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
+		if (page)
+			migratetype = get_pageblock_migratetype(page);
+		else
+			goto failed_unlock;
 		spin_unlock(&zone->lock);
-		if (!page)
-			goto failed;
-		__mod_zone_freepage_state(zone, -(1 << order),
-					  get_freepage_migratetype(page));
+		__mod_zone_freepage_state(zone, -(1 << order), migratetype);
 	}
 
 	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
@@ -1715,6 +1716,8 @@ again:
 		goto again;
 	return page;
 
+failed_unlock:
+	spin_unlock(&zone->lock);
 failed:
 	local_irq_restore(flags);
 	return NULL;
-- 
1.9.3

