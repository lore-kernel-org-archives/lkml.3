Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaGRGpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 02:45:44 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:35934 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaGRGpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 02:45:43 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53C8C290.90503@lge.com>
Date: Fri, 18 Jul 2014 15:45:36 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        =?EUC-KR?B?J7Howdi89ic=?= <iamjoonsoo.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>
CC: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        =?EUC-KR?B?wMywx8ij?= <gunho.lee@lge.com>,
        "'Chanho Min'" <chanho.min@lge.com>
Subject: [PATCH] CMA/HOTPLUG: clear buffer-head lru before page migration
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

For page migration of CMA, buffer-heads of lru should be dropped.
Please refer to https://lkml.org/lkml/2014/7/4/101 for the history.

I have two solution to drop bhs.
One is invalidating entire lru.
Another is searching the lru and dropping only one bh that Laura proposed
at https://lkml.org/lkml/2012/8/31/313.

I'm not sure which has better performance.
So I did performance test on my cortex-a7 platform with Lmbench
that has "File & VM system latencies" test.
I am attaching the results.
The first line is of invalidating entire lru and the second is dropping selected bh.

File & VM system latencies in microseconds - smaller is better
-------------------------------------------------------------------------------
Host                 OS   0K File      10K File     Mmap    Prot   Page   100fd
                        Create Delete Create Delete Latency Fault  Fault  selct
--------- ------------- ------ ------ ------ ------ ------- ----- ------- -----
10.178.33 Linux 3.10.19   25.1   19.6   32.6   19.7  5098.0 0.666 3.45880 6.506
10.178.33 Linux 3.10.19   24.9   19.5   32.3   19.4  5059.0 0.563 3.46380 6.521


I tried several times but the result tells that they are the same under 1% gap
except Protection Fault.
But the latency of Protection Fault is very small and I think it has little effect.

Therefore we can choose anything but I choose invalidating entire lru.
The try_to_free_buffers() which is calling drop_buffers() is called by many filesystem code.
So I think inserting codes in drop_buffers() can affect the system.
And also we cannot distinguish migration type in drop_buffers().

In alloc_contig_range() we can distinguish migration type and invalidate lru if it needs.
I think alloc_contig_range() is proper to deal with bh like following patch.

Laura, can I have you name on Acked-by line?
Please let me represent my thanks.

Thanks for any feedback.

------------------------------- 8< ----------------------------------

>From 33c894b1bab9bc26486716f0c62c452d3a04d35d Mon Sep 17 00:00:00 2001
From: Gioh Kim <gioh.kim@lge.com>
Date: Fri, 18 Jul 2014 13:40:01 +0900
Subject: [PATCH] CMA/HOTPLUG: clear buffer-head lru before page migration

The bh must be free to migrate a page at which bh is mapped.
The reference count of bh is increased when it is installed
into lru so that the bh of lru must be freed before migrating the page.

This frees every bh of lru. We could free only bh of migrating page.
But searching lru costs more than invalidating entire lru.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Acked-by: Laura Abbott <lauraa@codeaurora.org>
---
 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b99643d4..3b474e0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6369,6 +6369,9 @@ int alloc_contig_range(unsigned long start, unsigned long end,
        if (ret)
                return ret;

+       if (migratetype == MIGRATE_CMA || migratetype == MIGRATE_MOVABLE)
+               invalidate_bh_lrus();
+
        ret = __alloc_contig_migrate_range(&cc, start, end);
        if (ret)
                goto done;
--
1.7.9.5
