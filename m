Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaF0IOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:14:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbaF0IOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:14:44 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/5] Improve sequential read throughput v3
Date: Fri, 27 Jun 2014 09:14:35 +0100
Message-Id: <1403856880-12597-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since V2
o Simply fair zone policy cost reduction
o Drop CFQ patch

Changelog since v1
o Rebase to v3.16-rc2
o Move CFQ patch to end of series where it can be rejected easier if necessary
o Introduce page-reclaim related patch related to kswapd/fairzone interactions
o Rework fast zone policy patch

IO performance since 3.0 has been a mixed bag. In many respects we are
better and in some we are worse and one of those places is sequential
read throughput. This is visible in a number of benchmarks but I looked
at tiobench the closest. This is using ext3 on a mid-range desktop and
the series applied.

                                      3.16.0-rc2            3.16.0-rc2
                                         vanilla             lessdirty
Min    SeqRead-MB/sec-1         120.92 (  0.00%)      140.73 ( 16.38%)
Min    SeqRead-MB/sec-2         100.25 (  0.00%)      117.43 ( 17.14%)
Min    SeqRead-MB/sec-4          96.27 (  0.00%)      109.01 ( 13.23%)
Min    SeqRead-MB/sec-8          83.55 (  0.00%)       90.86 (  8.75%)
Min    SeqRead-MB/sec-16         66.77 (  0.00%)       74.12 ( 11.01%)

Overall system CPU usage is reduced

          3.16.0-rc2  3.16.0-rc2
             vanilla lessdirty-v3
User          390.13      390.20
System        404.41      379.08
Elapsed      5412.45     5123.74

This series does not fully restore throughput performance to 3.0 levels
but it brings it close for lower thread counts. Higher thread counts are
known to be worse than 3.0 due to CFQ changes but there is no appetite
for changing the defaults there.

 include/linux/mmzone.h         | 210 ++++++++++++++++++++++-------------------
 include/linux/writeback.h      |   1 +
 include/trace/events/pagemap.h |  16 ++--
 mm/internal.h                  |   1 +
 mm/mm_init.c                   |   4 +-
 mm/page-writeback.c            |  23 +++--
 mm/page_alloc.c                | 173 ++++++++++++++++++++-------------
 mm/swap.c                      |   4 +-
 mm/vmscan.c                    |  16 ++--
 mm/vmstat.c                    |   4 +-
 10 files changed, 258 insertions(+), 194 deletions(-)

-- 
1.8.4.5

