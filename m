Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaGIINQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:13:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbaGIINM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:13:12 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/5] Reduce sequential read overhead
Date: Wed,  9 Jul 2014 09:13:02 +0100
Message-Id: <1404893588-21371-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was formerly the series "Improve sequential read throughput" which
noted some major differences in performance of tiobench since 3.0. While
there are a number of factors, two that dominated were the introduction
of the fair zone allocation policy and changes to CFQ.

The behaviour of fair zone allocation policy makes more sense than tiobench
as a benchmark and CFQ defaults were not changed due to insufficient
benchmarking.

This series is what's left. It's one functional fix to the fair zone
allocation policy when used on NUMA machines and a reduction of overhead
in general. tiobench was used for the comparison despite its flaws as an
IO benchmark as in this case we are primarily interested in the overhead
of page allocator and page reclaim activity.

On UMA, it makes little difference to overhead

          3.16.0-rc3   3.16.0-rc3
             vanilla lowercost-v5
User          383.61      386.77
System        403.83      401.74
Elapsed      5411.50     5413.11

On a 4-socket NUMA machine it's a bit more noticable

          3.16.0-rc3   3.16.0-rc3
             vanilla lowercost-v5
User          746.94      802.00
System      65336.22    40852.33
Elapsed     27553.52    27368.46

 include/linux/mmzone.h         | 217 ++++++++++++++++++++++-------------------
 include/trace/events/pagemap.h |  16 ++-
 mm/page_alloc.c                | 122 ++++++++++++-----------
 mm/swap.c                      |   4 +-
 mm/vmscan.c                    |   7 +-
 mm/vmstat.c                    |   9 +-
 6 files changed, 198 insertions(+), 177 deletions(-)

-- 
1.8.4.5

