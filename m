Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaH1SnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:43:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbaH1ShY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:24 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 95/97] mm: vmscan: only update per-cpu thresholds for online CPU
Date: Thu, 28 Aug 2014 19:35:43 +0100
Message-Id: <1409250945-30874-96-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit bb0b6dffa2ccfbd9747ad0cc87c7459622896e60 upstream.

When kswapd is awake reclaiming, the per-cpu stat thresholds are lowered
to get more accurate counts to avoid breaching watermarks.  This
threshold update iterates over all possible CPUs which is unnecessary.
Only online CPUs need to be updated.  If a new CPU is onlined,
refresh_zone_stat_thresholds() will set the thresholds correctly.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 28245d5..f7ca044 100644
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

