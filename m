Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3HFGm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 02:42:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34453 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3HFGm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 02:42:57 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-86-52009aee6cb5
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCH 0/4] mm: reclaim zbud pages on migration and compaction
Date: Tue, 06 Aug 2013 08:42:37 +0200
Message-id: <1375771361-8388-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t/xa7rvZjEEGez8Y2YxZ/0aNouNM9az
	Wrx+YWhxtukNu8XlXXPYLO6t+c9qsfbIXXaLye+eMVoc2reK3YHTY9OnSeweJ2b8ZvF4cGgz
	i0ffllWMHptPV3t83iQXwBbFZZOSmpNZllqkb5fAldHwdAZ7wXreivaf7cwNjF1cXYycHBIC
	JhLfZs9jhrDFJC7cW8/WxcjFISSwlFHi86FmZginj0ni2vGpYFVsAsYSm5cvYQOxRQT6GCUm
	XbYAsZkFnjJK7PruBGILC3hL7J+5hgnEZhFQldi+Yyc7iM0r4Cbx+/kPoDkcQNsUJOZMspnA
	yL2AkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkj4fNnBuPiY1SFGAQ5GJR7ehKv/A4VY
	E8uKK3MPMUpwMCuJ8DJWMQQJ8aYkVlalFuXHF5XmpBYfYmTi4JRqYJzdx+qbUxPcpTB57a2X
	PxknfNDwThZfHv3LqEjkNf/u/FcnDDOudXuK5Rn8LFPcZab6d83VC1cbI1b4MD9v6VW6saKy
	6nKMe/y2W78ZZsjacm5X28w17YPkHFN5vYWTggX2ZNhri4tYled7zrBm3Hinz8blfefy9Y1T
	gytPHJtevqtbccuqj0osxRmJhlrMRcWJADNeX9b9AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently zbud pages are not movable and they cannot be allocated from CMA
region. These patches try to address the problem by:
1. Adding a new form of reclaim of zbud pages.
2. Reclaiming zbud pages during migration and compaction.
3. Allocating zbud pages with __GFP_RECLAIMABLE flag.

This reclaim process is different than zbud_reclaim_page(). It acts more
like swapoff() by trying to unuse pages stored in zbud page and bring
them back to memory. The standard zbud_reclaim_page() on the other hand
tries to write them back.

One of patches introduces a new flag: PageZbud. This flag is used in
isolate_migratepages_range() to grab zbud pages and pass them later
for reclaim. Probably this could be replaced with something
smarter than a flag used only in one case.
Any ideas for a better solution are welcome.

This patch set is based on Linux 3.11-rc4.

TODOs:
1. Replace PageZbud flag with other solution.

Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (4):
  zbud: use page ref counter for zbud pages
  mm: split code for unusing swap entries from try_to_unuse
  mm: add zbud flag to page flags
  mm: reclaim zbud pages on migration and compaction

 include/linux/page-flags.h |   12 ++
 include/linux/swapfile.h   |    2 +
 include/linux/zbud.h       |   11 +-
 mm/compaction.c            |   20 ++-
 mm/internal.h              |    1 +
 mm/page_alloc.c            |    9 ++
 mm/swapfile.c              |  354 +++++++++++++++++++++++---------------------
 mm/zbud.c                  |  301 +++++++++++++++++++++++++------------
 mm/zswap.c                 |   57 ++++++-
 9 files changed, 499 insertions(+), 268 deletions(-)

-- 
1.7.9.5

