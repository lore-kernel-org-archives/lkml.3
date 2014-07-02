Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbaGBAMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 20:12:33 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44535 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaGBAMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 20:12:31 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH v3 0/3] free reclaimed pages by paging out instantly
Date: Wed,  2 Jul 2014 09:13:46 +0900
Message-Id: <1404260029-11525-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, I/O completed pages for reclaim would be rotated into
inactive LRU tail without freeing. The why it works is we can't free
page from atomic context(ie, end_page_writeback) due to vaious locks
isn't aware of atomic context.

So for reclaiming the I/O completed pages, we need one more iteration
of reclaim and it could make unnecessary aging as well as CPU overhead.

Long time ago, at the first trial, most concern was memcg locking
but recently, Johnannes tried amazing effort to make memcg lock simple
and got merged into mmotm so I coded up based on mmotm tree.
(Kudos to Johannes)

On 1G, 12 CPU kvm guest, build kernel 5 times and result was

allocstall
vanilla: records: 5 avg: 4733.80 std: 913.55(19.30%) max: 6442.00 min: 3719.00
improve: records: 5 avg: 1514.20 std: 441.69(29.17%) max: 1974.00 min: 863.00

pgrotated
vanilla: records: 5 avg: 873313.80 std: 40999.20(4.69%) max: 954722.00 min: 845903.00
improve: records: 5 avg: 28406.40 std: 3296.02(11.60%) max: 34552.00 min: 25047.00

Most of field in vmstat are not changed too much but things I can notice
is allocstall and pgrotated. We could save allocstall(ie, direct relcaim)
and pgrotated very much.

Welcome testing, review and any feedback!

* from v2 - 2014.06.20
  * Rebased on v3.16-rc2-mmotm-2014-06-25-16-44
  * Remove RFC tag

Minchan Kim (3):
  mm: Don't hide spin_lock in swap_info_get internal
  mm: Introduce atomic_remove_mapping
  mm: Free reclaimed pages indepdent of next reclaim

 include/linux/swap.h |  4 ++++
 mm/filemap.c         | 17 +++++++++-----
 mm/swap.c            | 21 ++++++++++++++++++
 mm/swapfile.c        | 17 ++++++++++++--
 mm/vmscan.c          | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 114 insertions(+), 8 deletions(-)

-- 
2.0.0

