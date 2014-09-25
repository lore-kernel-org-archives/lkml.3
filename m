Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaIYNoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:44:12 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:37178 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbaIYNoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:44:07 -0400
Date: Thu, 25 Sep 2014 15:44:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: memcontrol: do not kill uncharge batching in
 free_pages_and_swap_cache
Message-ID: <20140925134403.GA11080@dhcp22.suse.cz>
References: <1411571338-8178-1-git-send-email-hannes@cmpxchg.org>
 <1411571338-8178-2-git-send-email-hannes@cmpxchg.org>
 <20140924124234.3fdb59d6cdf7e9c4d6260adb@linux-foundation.org>
 <20140924210322.GA11017@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924210322.GA11017@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-09-14 17:03:22, Johannes Weiner wrote:
[...]
> In release_pages, break the lock at least every SWAP_CLUSTER_MAX (32)
> pages, then remove the batching from free_pages_and_swap_cache.

Actually I had something like that originally but then decided to
not change the break out logic to prevent from strange and subtle
regressions. I have focused only on the memcg batching POV and led the
rest untouched.

I do agree that lru_lock batching can be improved as well. Your change
looks almost correct but you should count all the pages while the lock
is held otherwise you might happen to hold the lock for too long just
because most pages are off the LRU already for some reason. At least
that is what my original attempt was doing. Something like the following
on top of the current patch:
---
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
[...]
-- 
Michal Hocko
SUSE Labs
