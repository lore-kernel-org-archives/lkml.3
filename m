Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3HBCIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:08:25 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62998 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3HBCIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:08:06 -0400
X-AuditID: 9c93016f-b7b05ae000002bbd-54-51fb1481529a
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 4/4] swap: clean-up #ifdef in page_mapping()
Date: Fri,  2 Aug 2013 11:07:59 +0900
Message-Id: <1375409279-16919-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375409279-16919-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375409279-16919-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PageSwapCache() is always false when !CONFIG_SWAP, so compiler
properly discard related code. Therefore, we don't need #ifdef explicitly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/include/linux/swap.h b/include/linux/swap.h
index d95cde5..c638a71 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -414,6 +414,7 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
 
 #else /* CONFIG_SWAP */
 
+#define swap_address_space(entry)		(NULL)
 #define get_nr_swap_pages()			0L
 #define total_swap_pages			0L
 #define total_swapcache_pages()			0UL
diff --git a/mm/util.c b/mm/util.c
index 7441c41..eaf63fc2 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -388,15 +388,12 @@ struct address_space *page_mapping(struct page *page)
 	struct address_space *mapping = page->mapping;
 
 	VM_BUG_ON(PageSlab(page));
-#ifdef CONFIG_SWAP
 	if (unlikely(PageSwapCache(page))) {
 		swp_entry_t entry;
 
 		entry.val = page_private(page);
 		mapping = swap_address_space(entry);
-	} else
-#endif
-	if ((unsigned long)mapping & PAGE_MAPPING_ANON)
+	} else if ((unsigned long)mapping & PAGE_MAPPING_ANON)
 		mapping = NULL;
 	return mapping;
 }
-- 
1.7.9.5

