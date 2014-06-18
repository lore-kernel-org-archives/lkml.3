Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbaFRIXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:23:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388AbaFRIXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:23:30 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Jens Axboe <axboe@kernel.dk>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/4] Improve sequential read throughput
Date: Wed, 18 Jun 2014 09:23:23 +0100
Message-Id: <1403079807-24690-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IO performance since 3.0 has been a mixed bag. In many respects we are
better and in some we are worse and one of those places is sequential read
performance, particularly for higher numbers of threads. This is visible
in a number of benchmarks but tiobench has been the one I looked at the
closest despite its age.

                                      3.16.0-rc1            3.16.0-rc1                 3.0.0
                                         vanilla          patch-series               vanilla
Mean   SeqRead-MB/sec-1         121.88 (  0.00%)      133.84 (  9.81%)      134.59 ( 10.42%)
Mean   SeqRead-MB/sec-2         101.99 (  0.00%)      115.01 ( 12.77%)      122.59 ( 20.20%)
Mean   SeqRead-MB/sec-4          97.42 (  0.00%)      108.40 ( 11.27%)      114.78 ( 17.82%)
Mean   SeqRead-MB/sec-8          83.39 (  0.00%)       97.50 ( 16.92%)      100.14 ( 20.09%)
Mean   SeqRead-MB/sec-16         68.90 (  0.00%)       82.14 ( 19.22%)       81.64 ( 18.50%)

The impact on the other operations is negligible. Note that 3.0-vanilla is
still far better but bringing the patch series further in line would involve
increasing the CFQ target latency higher and there should be better options.
This series is a major improvement on 3.16-rc1-vanilla at least so worth
sending out to a larger audience for comment.

 block/cfq-iosched.c            |   2 +-
 include/linux/mmzone.h         |   9 +++
 include/linux/writeback.h      |   1 +
 include/trace/events/pagemap.h |  16 ++--
 mm/internal.h                  |   1 +
 mm/mm_init.c                   |   5 +-
 mm/page-writeback.c            |  15 ++--
 mm/page_alloc.c                | 176 ++++++++++++++++++++++++++---------------
 mm/swap.c                      |   4 +-
 9 files changed, 144 insertions(+), 85 deletions(-)

-- 
1.8.4.5

