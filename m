Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaFYH67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:58:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbaFYH65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:58:57 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 6/6] cfq: Increase default value of target_latency
Date: Wed, 25 Jun 2014 08:58:49 +0100
Message-Id: <1403683129-10814-7-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1403683129-10814-1-git-send-email-mgorman@suse.de>
References: <1403683129-10814-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing CFQ default target_latency results in very poor performance
for larger numbers of threads doing sequential reads. While this can be
easily described as a tuning problem for users, it is one that is tricky
to detect. This patch updates the default to benefit smaller machines.
Dave Chinner points out that it is dangerous to assume that people know
how to tune their IO scheduler. Jeff Moyer asked what workloads even
care about threaded readers but it's reasonable to assume file,
media, database and multi-user servers all experience large sequential
readers from multiple sources at the same time.

It's a bit depressing to note how much slower this relatively simple case
is in comparison to 3.0.  The following is from tiobench on a mid-range
desktop using ext3 as the test filesystem although it's known other
filesystems experience similar trouble.

                                      3.16.0-rc2            3.16.0-rc2                 3.0.0
                                 lessdirty                cfq600                     vanilla
Min    SeqRead-MB/sec-1         140.79 (  0.00%)      140.43 ( -0.26%)      134.04 ( -4.79%)
Min    SeqRead-MB/sec-2         118.08 (  0.00%)      118.18 (  0.08%)      120.76 (  2.27%)
Min    SeqRead-MB/sec-4         108.47 (  0.00%)      110.84 (  2.18%)      114.49 (  5.55%)
Min    SeqRead-MB/sec-8          87.20 (  0.00%)       92.40 (  5.96%)       98.04 ( 12.43%)
Min    SeqRead-MB/sec-16         68.98 (  0.00%)       76.68 ( 11.16%)       79.49 ( 15.24%)

The full series including this patch brings performance within an acceptable
distance of 3.0.0-vanilla considering that read latencies and fairness are
generally better now at the cost of overall throughput.

Here is the very high-level view of the iostats

                  3.16.0-rc2  3.16.0-rc2       3.0.0
                   lessdirty      cfq600     vanilla
Mean sda-avgqusz      935.48      957.28     1000.70
Mean sda-avgrqsz      575.27      579.85      600.71
Mean sda-await       4405.00     4471.12     4887.67
Mean sda-r_await       82.43       87.95      108.53
Mean sda-w_await    13272.23    10783.67    11599.83
Mean sda-rrqm          14.12       10.14       19.68
Mean sda-wrqm        1631.24     1744.00    11999.46
Max  sda-avgqusz     2179.79     2238.95     2626.78
Max  sda-avgrqsz     1021.03     1021.97     1024.00
Max  sda-await      15007.79    13600.51    24971.00
Max  sda-r_await      897.78      893.09     5308.00
Max  sda-w_await   207814.40   179483.79   177698.47
Max  sda-rrqm          68.40       45.60       73.30
Max  sda-wrqm       19544.00    19619.20    58058.40

await figures are generally ok.  Average wait times are still acceptable
and the worst-case read wait times are ok. Queue sizes and request sizes
generally look ok. It's worth noting that the iostats are generally *far*
better than 3.0.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 block/cfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index cadc378..876ae44 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -32,7 +32,7 @@ static int cfq_slice_async = HZ / 25;
 static const int cfq_slice_async_rq = 2;
 static int cfq_slice_idle = HZ / 125;
 static int cfq_group_idle = HZ / 125;
-static const int cfq_target_latency = HZ * 3/10; /* 300 ms */
+static const int cfq_target_latency = HZ * 6/10; /* 600 ms */
 static const int cfq_hist_divisor = 4;
 
 /*
-- 
1.8.4.5

