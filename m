Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaGUCdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 22:33:46 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55733 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaGUCdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 22:33:44 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53CC7C05.3060703@lge.com>
Date: Mon, 21 Jul 2014 11:33:41 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        =?EUC-KR?B?J7Howdi89ic=?= <iamjoonsoo.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>,
        "'Chanho Min'" <chanho.min@lge.com>
Subject: [PATCHv2] CMA/HOTPLUG: clear buffer-head lru before page migration
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I removed checking migratetype of v1: https://lkml.org/lkml/2014/7/18/82.
Thanks a lot.


---------------------------- 8< ------------------------------
>From 95addf7f1644cde3a0944629ff5c6a8d6f43e5d6 Mon Sep 17 00:00:00 2001
From: Gioh Kim <gioh.kim@lge.com>
Date: Fri, 18 Jul 2014 13:40:01 +0900
Subject: [PATCH] CMA/HOTPLUG: clear buffer-head lru before page migration

The bh must be free to migrate a page at which bh is mapped.
The reference count of bh is increased when it is installed
into lru so that the bh of lru must be freed before migrating the page.

This frees every bh of lru. We could free only bh of migrating page.
But searching lru costs more than invalidating entire lru.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
---
 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

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
