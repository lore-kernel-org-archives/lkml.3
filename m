Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaFVIvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:51:51 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47666 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaFVIvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:51:49 -0400
From: Chen Yucong <slaoub@gmail.com>
To: mgorman@suse.de
Cc: hannes@cmpxchg.org, mhocko@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] mm:vmscan:replace zone_watermark_ok with zone_balanced for determining if kswapd will call compaction
Date: Sun, 22 Jun 2014 16:51:00 +0800
Message-Id: <1403427060-16711-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the commit messages of "mm: vmscan: fix endless loop in kswapd balancing"
and "mm: vmscan: decide whether to compact the pgdat based on reclaim progress", minor
change is required to the following snippet.

        /*
         * If any zone is currently balanced then kswapd will
         * not call compaction as it is expected that the
         * necessary pages are already available.
         */
        if (pgdat_needs_compaction &&
                zone_watermark_ok(zone, order,
                                        low_wmark_pages(zone),
                                        *classzone_idx, 0))
                pgdat_needs_compaction = false;

zone_watermark_ok() should be replaced by zone_balanced() in the above snippet. That's
because zone_balanced() is more suitable for the context.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 mm/vmscan.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a8ffe4e..e1004ad 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3157,9 +3157,8 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 			 * necessary pages are already available.
 			 */
 			if (pgdat_needs_compaction &&
-					zone_watermark_ok(zone, order,
-						low_wmark_pages(zone),
-						*classzone_idx, 0))
+					zone_balanced(zone, order, 0,
+						*classzone_idx))
 				pgdat_needs_compaction = false;
 		}
 
-- 
1.7.10.4

