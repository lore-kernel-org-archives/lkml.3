Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934496AbaKSWex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:34:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbaKSUx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Gioh Kim <gioh.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 029/141] mm/page_alloc: move freepage counting logic to __free_one_page()
Date: Wed, 19 Nov 2014 12:50:52 -0800
Message-Id: <20141119205151.601067804@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

commit 8f82b55dd558a74fc33d69a1f2c2605d0cd2c908 upstream.

All the caller of __free_one_page() has similar freepage counting logic,
so we can move it to __free_one_page().  This reduce line of code and
help future maintenance.

This is also preparation step for "mm/page_alloc: restrict max order of
merging on isolated pageblock" which fix the freepage counting problem
on freepage with more than pageblock order.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Heesub Shin <heesub.shin@samsung.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Gioh Kim <gioh.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -578,6 +578,8 @@ static inline void __free_one_page(struc
 			return;
 
 	VM_BUG_ON(migratetype == -1);
+	if (!is_migrate_isolate(migratetype))
+		__mod_zone_freepage_state(zone, 1 << order, migratetype);
 
 	page_idx = pfn & ((1 << MAX_ORDER) - 1);
 
@@ -716,14 +718,9 @@ static void free_pcppages_bulk(struct zo
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
 			mt = get_freepage_migratetype(page);
-			if (unlikely(has_isolate_pageblock(zone))) {
+			if (unlikely(has_isolate_pageblock(zone)))
 				mt = get_pageblock_migratetype(page);
-				if (is_migrate_isolate(mt))
-					goto skip_counting;
-			}
-			__mod_zone_freepage_state(zone, 1, mt);
 
-skip_counting:
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
@@ -746,12 +743,7 @@ static void free_one_page(struct zone *z
 	if (unlikely(has_isolate_pageblock(zone) ||
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
-		if (is_migrate_isolate(migratetype))
-			goto skip_counting;
 	}
-	__mod_zone_freepage_state(zone, 1 << order, migratetype);
-
-skip_counting:
 	__free_one_page(page, pfn, zone, order, migratetype);
 	spin_unlock(&zone->lock);
 }


