Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbbAQPVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 10:21:31 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:57669 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbbAQPVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 10:21:30 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] mm: memcontrol: default hierarchy interface for memory fix - high reclaim
Date: Sat, 17 Jan 2015 10:21:19 -0500
Message-Id: <1421508079-29293-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

High limit reclaim can currently overscan in proportion to how many
charges are happening concurrently.  Tone it down such that charges
don't target the entire high-boundary excess, but instead only the
pages they charged themselves when excess is detected.

Reported-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 323a01fa1833..7adccee9fecb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2348,19 +2348,13 @@ done_restock:
 		refill_stock(memcg, batch - nr_pages);
 	/*
 	 * If the hierarchy is above the normal consumption range,
-	 * make the charging task trim the excess.
+	 * make the charging task trim their excess contribution.
 	 */
 	do {
-		unsigned long nr_pages = page_counter_read(&memcg->memory);
-		unsigned long high = ACCESS_ONCE(memcg->high);
-
-		if (nr_pages > high) {
-			mem_cgroup_events(memcg, MEMCG_HIGH, 1);
-
-			try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-						     gfp_mask, true);
-		}
-
+		if (page_counter_read(&memcg->memory) <= memcg->high)
+			continue;
+		mem_cgroup_events(memcg, MEMCG_HIGH, 1);
+		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
 	} while ((memcg = parent_mem_cgroup(memcg)));
 done:
 	return ret;
-- 
2.2.0

