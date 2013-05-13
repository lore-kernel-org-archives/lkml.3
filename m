Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3EMCK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:10:57 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48764 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3EMCKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:10:55 -0400
X-AuditID: 9c930197-b7b76ae000003523-21-51904bacbdce
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 1/4] mm: Don't hide spin_lock in swap_info_get
Date: Mon, 13 May 2013 11:10:45 +0900
Message-Id: <1368411048-3753-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368411048-3753-1-git-send-email-minchan@kernel.org>
References: <1368411048-3753-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, swap_info_get hides lock holding by doing it internally
but releasing the lock is caller's duty. It's not serious bad
pattern but not good for readability, either.
More concern that if we uses swap_info_get in irq context,
the lock should be held with irq disabled.
So it would be better for caller to hold it because he can
judge the function will be used in irqcontext or not.

This patch will be used next patchset in this series.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/swapfile.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6c340d9..2966978 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -523,7 +523,6 @@ static struct swap_info_struct *swap_info_get(swp_entry_t entry)
 		goto bad_offset;
 	if (!p->swap_map[offset])
 		goto bad_free;
-	spin_lock(&p->lock);
 	return p;
 
 bad_free:
@@ -629,6 +628,7 @@ void swap_free(swp_entry_t entry)
 
 	p = swap_info_get(entry);
 	if (p) {
+		spin_lock(&p->lock);
 		swap_entry_free(p, entry, 1);
 		spin_unlock(&p->lock);
 	}
@@ -644,6 +644,7 @@ void swapcache_free(swp_entry_t entry, struct page *page)
 
 	p = swap_info_get(entry);
 	if (p) {
+		spin_lock(&p->lock);
 		count = swap_entry_free(p, entry, SWAP_HAS_CACHE);
 		if (page)
 			mem_cgroup_uncharge_swapcache(page, entry, count != 0);
@@ -665,6 +666,7 @@ int page_swapcount(struct page *page)
 	entry.val = page_private(page);
 	p = swap_info_get(entry);
 	if (p) {
+		spin_lock(&p->lock);
 		count = swap_count(p->swap_map[swp_offset(entry)]);
 		spin_unlock(&p->lock);
 	}
@@ -747,6 +749,7 @@ int free_swap_and_cache(swp_entry_t entry)
 
 	p = swap_info_get(entry);
 	if (p) {
+		spin_lock(&p->lock);
 		if (swap_entry_free(p, entry, 1) == SWAP_HAS_CACHE) {
 			page = find_get_page(swap_address_space(entry),
 						entry.val);
@@ -2373,6 +2376,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
 		goto outer;
 	}
 
+	spin_lock(&si->lock);
 	offset = swp_offset(entry);
 	count = si->swap_map[offset] & ~SWAP_HAS_CACHE;
 
-- 
1.8.2.1

