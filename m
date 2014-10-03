Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaJCQHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:07:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbaJCQHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:07:03 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>, Dave Hansen <dave@sr71.net>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH]  mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache-fix.patch
Date: Fri,  3 Oct 2014 18:06:50 +0200
Message-Id: <1412352410-23500-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <20141002155750.GB2035@cmpxchg.org>
References: <20141002155750.GB2035@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

count all pages because many pages might be off LRU already.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/swap.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 39affa1932ce..8a12b33936b4 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -911,13 +911,22 @@ void release_pages(struct page **pages, int nr, bool cold)
 		if (unlikely(PageCompound(page))) {
 			if (zone) {
 				spin_unlock_irqrestore(&zone->lru_lock, flags);
-				lock_batch = 0;
 				zone = NULL;
 			}
 			put_compound_page(page);
 			continue;
 		}
 
+		/*
+		 * Make sure the IRQ-safe lock-holding time does not get
+		 * excessive with a continuous string of pages from the
+		 * same zone. The lock is held only if zone != NULL.
+		 */
+		if (zone && ++lock_batch == SWAP_CLUSTER_MAX) {
+			spin_unlock_irqrestore(&zone->lru_lock, flags);
+			zone = NULL;
+		}
+
 		if (!put_page_testzero(page))
 			continue;
 
@@ -937,16 +946,6 @@ void release_pages(struct page **pages, int nr, bool cold)
 			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
-
-			/*
-			 * Make sure the IRQ-safe lock-holding time
-			 * does not get excessive with a continuous
-			 * string of pages from the same zone.
-			 */
-			if (++lock_batch == SWAP_CLUSTER_MAX) {
-				spin_unlock_irqrestore(&zone->lru_lock, flags);
-				zone = NULL;
-			}
 		}
 
 		/* Clear Active bit in case of parallel mark_page_accessed */
-- 
2.1.1

