Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbbAUJfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:35:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36662 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbbAUJe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:34:57 -0500
From: Vinayak Menon <vinmenon@codeaurora.org>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mgorman@suse.de, minchan@kernel.org,
        vbabka@suse.cz, rientjes@google.com, iamjoonsoo.kim@lge.com,
        Vinayak Menon <vinmenon@codeaurora.org>
Subject: [PATCH] mm: compaction: fix the page state calculation in too_many_isolated
Date: Wed, 21 Jan 2015 15:04:24 +0530
Message-Id: <1421832864-30643-1-git-send-email-vinmenon@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "3611badc1baa" (mm: vmscan: fix the page state calculation in
too_many_isolated) fixed an issue where a number of tasks were
blocked in reclaim path for seconds, because of vmstat_diff not being
synced in time. A similar problem can happen in isolate_migratepages_block,
similar calculation is performed. This patch fixes that.

Signed-off-by: Vinayak Menon <vinmenon@codeaurora.org>
---
 mm/compaction.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 546e571..2d9730d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -537,21 +537,43 @@ static void acct_isolated(struct zone *zone, struct compact_control *cc)
 	mod_zone_page_state(zone, NR_ISOLATED_FILE, count[1]);
 }
 
-/* Similar to reclaim, but different enough that they don't share logic */
-static bool too_many_isolated(struct zone *zone)
+static bool __too_many_isolated(struct zone *zone, int safe)
 {
 	unsigned long active, inactive, isolated;
 
-	inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
+	if (safe) {
+		inactive = zone_page_state_snapshot(zone, NR_INACTIVE_FILE) +
+			zone_page_state_snapshot(zone, NR_INACTIVE_ANON);
+		active = zone_page_state_snapshot(zone, NR_ACTIVE_FILE) +
+			zone_page_state_snapshot(zone, NR_ACTIVE_ANON);
+		isolated = zone_page_state_snapshot(zone, NR_ISOLATED_FILE) +
+			zone_page_state_snapshot(zone, NR_ISOLATED_ANON);
+	} else {
+		inactive = zone_page_state(zone, NR_INACTIVE_FILE) +
 					zone_page_state(zone, NR_INACTIVE_ANON);
-	active = zone_page_state(zone, NR_ACTIVE_FILE) +
+		active = zone_page_state(zone, NR_ACTIVE_FILE) +
 					zone_page_state(zone, NR_ACTIVE_ANON);
-	isolated = zone_page_state(zone, NR_ISOLATED_FILE) +
+		isolated = zone_page_state(zone, NR_ISOLATED_FILE) +
 					zone_page_state(zone, NR_ISOLATED_ANON);
+	}
 
 	return isolated > (inactive + active) / 2;
 }
 
+/* Similar to reclaim, but different enough that they don't share logic */
+static bool too_many_isolated(struct zone *zone)
+{
+	/*
+	 * __too_many_isolated(safe=0) is fast but inaccurate, because it
+	 * doesn't account for the vm_stat_diff[] counters.  So if it looks
+	 * like too_many_isolated() is about to return true, fall back to the
+	 * slower, more accurate zone_page_state_snapshot().
+	 */
+	if (unlikely(__too_many_isolated(zone, 0)))
+		return __too_many_isolated(zone, 1);
+	return 0;
+}
+
 /**
  * isolate_migratepages_block() - isolate all migrate-able pages within
  *				  a single pageblock
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation

