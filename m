Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750766AbaESEJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:09:20 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53508 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaESEJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:09:19 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: akpm@linux-foundation.org, hannes@cmpxchg.org, shli@kernel.org,
        minchan@kernel.org, riel@redhat.com, nasa4836@gmail.com,
        mgorman@suse.de, cmetcalf@tilera.com, aquini@redhat.com,
        mhocko@suse.cz, vdavydov@parallels.com, glommer@openvz.org,
        dchinner@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm/vmscan.c: use DIV_ROUND_UP for calculation of zone's balance_gap and correct comments.
Date: Mon, 19 May 2014 12:08:30 +0800
Message-Id: <1400472510-24375-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we use (zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
KSWAPD_ZONE_BALANCE_GAP_RATIO to avoid a zero gap value. It's better to
use DIV_ROUND_UP macro for neater code and clear meaning.

Besides, the gap value is calculated against the per-zone "managed pages",
not "present pages". This patch also corrects the comment and do some
rephrasing.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 include/linux/swap.h |  8 ++++----
 mm/vmscan.c          | 10 ++++------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5a14b92..58e1696 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -166,10 +166,10 @@ enum {
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
 /*
- * Ratio between the present memory in the zone and the "gap" that
- * we're allowing kswapd to shrink in addition to the per-zone high
- * wmark, even for zones that already have the high wmark satisfied,
- * in order to provide better per-zone lru behavior. We are ok to
+ * Ratio between zone->managed_pages and the "gap" that above the per-zone
+ * "high_wmark". While balancing nodes, We allow kswapd to shrink zones that
+ * do not meet the (high_wmark + gap) watermark, even which already met the
+ * high_wmark, in order to provide better per-zone lru behavior. We are ok to
  * spend not more than 1% of the memory for this zone balancing "gap".
  */
 #define KSWAPD_ZONE_BALANCE_GAP_RATIO 100
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 32c661d..9ef9f6c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2268,9 +2268,8 @@ static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
 	 * there is a buffer of free pages available to give compaction
 	 * a reasonable chance of completing and allocating the page
 	 */
-	balance_gap = min(low_wmark_pages(zone),
-		(zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
-			KSWAPD_ZONE_BALANCE_GAP_RATIO);
+	balance_gap = min(low_wmark_pages(zone), DIV_ROUND_UP(
+			zone->managed_pages, KSWAPD_ZONE_BALANCE_GAP_RATIO));
 	watermark = high_wmark_pages(zone) + balance_gap + (2UL << sc->order);
 	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, 0, 0);
 
@@ -2891,9 +2890,8 @@ static bool kswapd_shrink_zone(struct zone *zone,
 	 * high wmark plus a "gap" where the gap is either the low
 	 * watermark or 1% of the zone, whichever is smaller.
 	 */
-	balance_gap = min(low_wmark_pages(zone),
-		(zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
-		KSWAPD_ZONE_BALANCE_GAP_RATIO);
+	balance_gap = min(low_wmark_pages(zone), DIV_ROUND_UP(
+			zone->managed_pages, KSWAPD_ZONE_BALANCE_GAP_RATIO));
 
 	/*
 	 * If there is no low memory pressure or the zone is balanced then no
-- 
2.0.0-rc3

