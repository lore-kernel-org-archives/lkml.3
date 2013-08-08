Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113Ab3HHIyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:54:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:1381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933987Ab3HHIyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:54:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,838,1367996400"; 
   d="scan'208";a="383148229"
Date: Thu, 8 Aug 2013 16:54:18 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miao Xie <miaox@cn.fujitsu.com>, Tao Ma <tm@tao.ma>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: readahead: make context readahead more conservative
Message-ID: <20130808085418.GA23970@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps performance on moderately dense random reads on SSD.

Transaction-Per-Second numbers provided by Taobao:

		QPS	case
		-------------------------------------------------------
		7536	disable context readahead totally
w/ patch:	7129	slower size rampup and start RA on the 3rd read
		6717	slower size rampup
w/o patch:	5581	unmodified context readahead

Before, readahead will be started whenever reading page N+1 when it
happen to read N recently. After patch, we'll only start readahead
when *three* random reads happen to access pages N, N+1, N+2. The
probability of this happening is extremely low for pure random reads,
unless they are very dense, which actually deserves some readahead.

Also start with a smaller readahead window. The impact to interleaved
sequential reads should be small, because for a long run stream, the
the small readahead window rampup phase is negletable.

The context readahead actually benefits clustered random reads on HDD
whose seek cost is pretty high. However as SSD is increasingly used
for random read workloads it's better for the context readahead to
concentrate on interleaved sequential reads.

Another SSD rand read test from Miao

        # file size:        2GB
        # read IO amount: 625MB
        sysbench --test=fileio          \
                --max-requests=10000    \
                --num-threads=1         \
                --file-num=1            \
                --file-block-size=64K   \
                --file-test-mode=rndrd  \
                --file-fsync-freq=0     \
                --file-fsync-end=off    run

shows the performance of btrfs grows up from 69MB/s to 121MB/s,
ext4 from 104MB/s to 121MB/s.

Tested-by: Tao Ma <tm@tao.ma>
Tested-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/readahead.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next.orig/mm/readahead.c	2013-08-08 16:21:29.675286154 +0800
+++ linux-next/mm/readahead.c	2013-08-08 16:21:33.851286019 +0800
@@ -371,10 +371,10 @@ static int try_context_readahead(struct
 	size = count_history_pages(mapping, ra, offset, max);
 
 	/*
-	 * no history pages:
+	 * not enough history pages:
 	 * it could be a random read
 	 */
-	if (!size)
+	if (size <= req_size)
 		return 0;
 
 	/*
@@ -385,8 +385,8 @@ static int try_context_readahead(struct
 		size *= 2;
 
 	ra->start = offset;
-	ra->size = get_init_ra_size(size + req_size, max);
-	ra->async_size = ra->size;
+	ra->size = min(size + req_size, max);
+	ra->async_size = 1;
 
 	return 1;
 }
