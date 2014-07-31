Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaGaCWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 22:22:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56337 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaGaCWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 22:22:37 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53D9A86B.20208@lge.com>
Date: Thu, 31 Jul 2014 11:22:35 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        =?EUC-KR?B?J7Howdi89ic=?= <iamjoonsoo.kim@lge.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>
CC: Laura Abbott <lauraa@codeaurora.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ????????? <gunho.lee@lge.com>,
        "'Chanho Min'" <chanho.min@lge.com>
Subject: [PATCHv2] CMA/HOTPLUG: clear buffer-head lru before page migration
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous PATCH inserts invalidate_bh_lrus() only into CMA code.
HOTPLUG needs also dropping bh of lru.
So v2 inserts invalidate_bh_lrus() into both of CMA and HOTPLUG.


---------------------------- 8< ----------------------------
The bh must be free to migrate a page at which bh is mapped.
The reference count of bh is increased when it is installed
into lru so that the bh of lru must be freed before migrating the page.

This frees every bh of lru. We could free only bh of migrating page.
But searching lru sometimes costs more than invalidating entire lru.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
---
 mm/memory_hotplug.c |    1 +
 mm/page_alloc.c     |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a3797d3..1c5454f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1672,6 +1672,7 @@ repeat:
                lru_add_drain_all();
                cond_resched();
                drain_all_pages();
+               invalidate_bh_lrus();
        }

        pfn = scan_movable_pages(start_pfn, end_pfn);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b99643d4..c00dedf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6369,6 +6369,8 @@ int alloc_contig_range(unsigned long start, unsigned long end,
        if (ret)
                return ret;

+       invalidate_bh_lrus();
+
        ret = __alloc_contig_migrate_range(&cc, start, end);
        if (ret)
                goto done;
--
1.7.9.5
