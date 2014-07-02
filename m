Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964909AbaGBANA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 20:13:00 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44542 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbaGBAMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 20:12:32 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH v3 1/3] mm: Don't hide spin_lock in swap_info_get internal
Date: Wed,  2 Jul 2014 09:13:47 +0900
Message-Id: <1404260029-11525-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404260029-11525-1-git-send-email-minchan@kernel.org>
References: <1404260029-11525-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, swap_info_get hides lock holding by doing it internally
but releasing the lock so caller should release the lock.
Normally, it's not a good pattern and I need to handle lock
from caller in next patchset.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/swapfile.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8798b2e0ac59..ec2ce926ea5f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -740,7 +740,6 @@ static struct swap_info_struct *swap_info_get(swp_entry_t entry)
 		goto bad_offset;
 	if (!p->swap_map[offset])
 		goto bad_free;
-	spin_lock(&p->lock);
 	return p;
 
 bad_free:
@@ -835,6 +834,7 @@ void swap_free(swp_entry_t entry)
 
 	p = swap_info_get(entry);
 	if (p) {
+		spin_lock(&p->lock);
 		swap_entry_free(p, entry, 1);
 		spin_unlock(&p->lock);
 	}
@@ -849,6 +849,7 @@ void swapcache_free(swp_entry_t entry)
 
 	p = swap_info_get(entry);
 	if (p) {
+		spin_lock(&p->lock);
 		swap_entry_free(p, entry, SWAP_HAS_CACHE);
 		spin_unlock(&p->lock);
 	}
@@ -868,6 +869,7 @@ int page_swapcount(struct page *page)
 	entry.val = page_private(page);
 	p = swap_info_get(entry);
 	if (p) {
+		spin_lock(&p->lock);
 		count = swap_count(p->swap_map[swp_offset(entry)]);
 		spin_unlock(&p->lock);
 	}
@@ -950,6 +952,7 @@ int free_swap_and_cache(swp_entry_t entry)
 
 	p = swap_info_get(entry);
 	if (p) {
+		spin_lock(&p->lock);
 		if (swap_entry_free(p, entry, 1) == SWAP_HAS_CACHE) {
 			page = find_get_page(swap_address_space(entry),
 						entry.val);
@@ -2763,6 +2766,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
 		goto outer;
 	}
 
+	spin_lock(&si->lock);
 	offset = swp_offset(entry);
 	count = si->swap_map[offset] & ~SWAP_HAS_CACHE;
 
-- 
2.0.0

