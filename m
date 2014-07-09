Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaGIIOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:14:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbaGIINP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:13:15 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 4/6] mm: vmscan: Only update per-cpu thresholds for online CPU
Date: Wed,  9 Jul 2014 09:13:06 +0100
Message-Id: <1404893588-21371-5-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404893588-21371-1-git-send-email-mgorman@suse.de>
References: <1404893588-21371-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kswapd is awake reclaiming, the per-cpu stat thresholds are
lowered to get more accurate counts to avoid breaching watermarks.  This
threshold update iterates over all possible CPUs which is unnecessary.
Only online CPUs need to be updated. If a new CPU is onlined,
refresh_zone_stat_thresholds() will set the thresholds correctly.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index e574e883..e9ab104 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -200,7 +200,7 @@ void set_pgdat_percpu_threshold(pg_data_t *pgdat,
 			continue;
 
 		threshold = (*calculate_pressure)(zone);
-		for_each_possible_cpu(cpu)
+		for_each_online_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
 							= threshold;
 	}
-- 
1.8.4.5

