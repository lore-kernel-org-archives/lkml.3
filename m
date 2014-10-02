Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaJBPuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:50:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbaJBPtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:49:41 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 4/4] mm, memory_hotplug/failure: drain single zone pcplists
Date: Thu,  2 Oct 2014 17:49:00 +0200
Message-Id: <1412264940-15738-5-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1412264940-15738-1-git-send-email-vbabka@suse.cz>
References: <1412264940-15738-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory hotplug and failure mechanisms have several places where pcplists are
drained so that pages are returned to the buddy allocator and can be e.g.
prepared for offlining. This is always done in the context of a single zone,
we can reduce the pcplists drain to the single zone, which is now possible.

The change should make memory offlining due to hotremove or failure faster and
not disturbing unrelated pcplists anymore.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/memory-failure.c | 4 ++--
 mm/memory_hotplug.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 851b4d7..84e7ded 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -233,7 +233,7 @@ void shake_page(struct page *p, int access)
 		lru_add_drain_all();
 		if (PageLRU(p))
 			return;
-		drain_all_pages(NULL);
+		drain_all_pages(page_zone(p));
 		if (PageLRU(p) || is_free_buddy_page(p))
 			return;
 	}
@@ -1661,7 +1661,7 @@ static int __soft_offline_page(struct page *page, int flags)
 			if (!is_free_buddy_page(page))
 				lru_add_drain_all();
 			if (!is_free_buddy_page(page))
-				drain_all_pages(NULL);
+				drain_all_pages(page_zone(page));
 			SetPageHWPoison(page);
 			if (!is_free_buddy_page(page))
 				pr_info("soft offline: %#lx: page leaked\n",
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 55a5441..7b67053 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1699,7 +1699,7 @@ repeat:
 	if (drain) {
 		lru_add_drain_all();
 		cond_resched();
-		drain_all_pages(NULL);
+		drain_all_pages(zone);
 	}
 
 	pfn = scan_movable_pages(start_pfn, end_pfn);
@@ -1721,7 +1721,7 @@ repeat:
 	lru_add_drain_all();
 	yield();
 	/* drain pcp pages, this is synchronous. */
-	drain_all_pages(NULL);
+	drain_all_pages(zone);
 	/*
 	 * dissolve free hugepages in the memory block before doing offlining
 	 * actually in order to make hugetlbfs's object counting consistent.
-- 
1.8.4.5

