Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaEAIpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:45:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbaEAIpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:45:06 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/17] mm: Do not use unnecessary atomic operations when adding pages to the LRU
Date: Thu,  1 May 2014 09:44:46 +0100
Message-Id: <1398933888-4940-16-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1398933888-4940-1-git-send-email-mgorman@suse.de>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adding pages to the LRU we clear the active bit unconditionally. As the
page could be reachable from other paths we cannot use unlocked operations
without risk of corruption such as a parallel mark_page_accessed. This
patch test if is necessary to clear the atomic flag before using an atomic
operation. In the unlikely even this races with mark_page_accesssed the
consequences are simply that the page may be promoted to the active list
that might have been left on the inactive list before the patch. This is
a marginal consequence.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/swap.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index da8a250..395dcab 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -329,13 +329,15 @@ extern void add_page_to_unevictable_list(struct page *page);
  */
 static inline void lru_cache_add_anon(struct page *page)
 {
-	ClearPageActive(page);
+	if (PageActive(page))
+		ClearPageActive(page);
 	__lru_cache_add(page);
 }
 
 static inline void lru_cache_add_file(struct page *page)
 {
-	ClearPageActive(page);
+	if (PageActive(page))
+		ClearPageActive(page);
 	__lru_cache_add(page);
 }
 
-- 
1.8.4.5

