Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab3EMCKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:10:55 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48764 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3EMCKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:10:54 -0400
X-AuditID: 9c930197-b7b76ae000003523-13-51904baafb18
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC 0/4] free reclaimed pages by paging out instantly
Date: Mon, 13 May 2013 11:10:44 +0900
Message-Id: <1368411048-3753-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, I/O completed pages for reclaim would be rotated into 
inactive LRU tail. IMHO, the why we did is we can't remove the page
from page cache and (swap cache, swap slot) by locking problem.

So for reclaiming the I/O completed pages, we need one more iteration
of reclaim and it could make unnecessary CPU overhead(ex,
acitve->inactive deactivation, isolation, shrink_page_list).

Another concern is related to per process reclaim, which smart platform
can reclaim some of the process's pages forcely without OOM kill before
VM reaches a latency trouble. Assuming that people does per process
reclaim on some processes before even kswapd runs(ie, free pages > high
watermark).

And they believe nr_free_pages in vmstat should be increased but it's
not true because reclaimed pages caused by paging out(ex, swap page,
dirty pages) will be not freed until kswapd runs in the future so that
the platform confused and discard more workingset unnecessary or 
reclaims more processes until the nr_free_pages is increased by
our goal.

This patch makes swap cache free logic being aware of irq context
so we can free reclaimed pages asap without rotating them back into
LRU's tail so that it can reduce unnecessary CPU overhead and LRU
churning and makes VM more intuitive.

Big problem of this patch is how to handle for memcg.
I hope please memcg guys look at description [3/4] and get feedback.

Minchan Kim (4):
  [1] mm: Don't hide spin_lock in swap_info_get
  [2] mm: introduce __swapcache_free
  [3] mm: support remove_mapping in irqcontext
  [4] mm: free reclaimed pages instantly without depending next reclaim

 fs/splice.c          |  2 +-
 include/linux/swap.h | 12 ++++++++++-
 mm/filemap.c         |  6 +++---
 mm/swap.c            | 14 ++++++++++++-
 mm/swapfile.c        | 22 +++++++++++++++------
 mm/truncate.c        |  2 +-
 mm/vmscan.c          | 56 +++++++++++++++++++++++++++++++++++++++++++---------
 7 files changed, 92 insertions(+), 22 deletions(-)

-- 
1.8.2.1

