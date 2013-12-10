Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab3LJPx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:53:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab3LJPvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:51:47 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 14/18] mm: numa: Limit scope of lock for NUMA migrate rate limiting
Date: Tue, 10 Dec 2013 15:51:32 +0000
Message-Id: <1386690695-27380-15-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386690695-27380-1-git-send-email-mgorman@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMA migrate rate limiting protects a migration counter and window using
a lock but in some cases this can be a contended lock. It is not
critical that the number of pages be perfect, lost updates are
acceptable. Reduce the importance of this lock.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 include/linux/mmzone.h |  5 +----
 mm/migrate.c           | 21 ++++++++++++---------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index bd791e4..b835d3f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -758,10 +758,7 @@ typedef struct pglist_data {
 	int kswapd_max_order;
 	enum zone_type classzone_idx;
 #ifdef CONFIG_NUMA_BALANCING
-	/*
-	 * Lock serializing the per destination node AutoNUMA memory
-	 * migration rate limiting data.
-	 */
+	/* Lock serializing the migrate rate limiting window */
 	spinlock_t numabalancing_migrate_lock;
 
 	/* Rate limiting time interval */
diff --git a/mm/migrate.c b/mm/migrate.c
index b6eef65..564d5c9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1596,26 +1596,29 @@ bool migrate_ratelimited(int node)
 static bool numamigrate_update_ratelimit(pg_data_t *pgdat,
 					unsigned long nr_pages)
 {
-	bool rate_limited = false;
-
 	/*
 	 * Rate-limit the amount of data that is being migrated to a node.
 	 * Optimal placement is no good if the memory bus is saturated and
 	 * all the time is being spent migrating!
 	 */
-	spin_lock(&pgdat->numabalancing_migrate_lock);
 	if (time_after(jiffies, pgdat->numabalancing_migrate_next_window)) {
+		spin_lock(&pgdat->numabalancing_migrate_lock);
 		pgdat->numabalancing_migrate_nr_pages = 0;
 		pgdat->numabalancing_migrate_next_window = jiffies +
 			msecs_to_jiffies(migrate_interval_millisecs);
+		spin_unlock(&pgdat->numabalancing_migrate_lock);
 	}
 	if (pgdat->numabalancing_migrate_nr_pages > ratelimit_pages)
-		rate_limited = true;
-	else
-		pgdat->numabalancing_migrate_nr_pages += nr_pages;
-	spin_unlock(&pgdat->numabalancing_migrate_lock);
-	
-	return rate_limited;
+		return true;
+
+	/*
+	 * This is an unlocked non-atomic update so errors are possible.
+	 * The consequences are failing to migrate when we potentiall should
+	 * have which is not severe enough to warrant locking. If it is ever
+	 * a problem, it can be converted to a per-cpu counter.
+	 */
+	pgdat->numabalancing_migrate_nr_pages += nr_pages;
+	return false;
 }
 
 static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
-- 
1.8.4

