Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaE0NAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:00:17 -0400
Received: from smtp7.sms.unimo.it ([155.185.44.150]:55624 "EHLO
	smtp7.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaE0NAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:00:11 -0400
From: paolo <paolo.valente@unimore.it>
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Cc: Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Paolo Valente <paolo.valente@unimore.it>
Subject: [PATCH RFC RESEND 10/14] block, bfq: preserve a low latency also with NCQ-capable drives
Date: Tue, 27 May 2014 14:42:34 +0200
Message-Id: <1401194558-5283-11-git-send-email-paolo.valente@unimore.it>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
UNIMORE-X-SA-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Valente <paolo.valente@unimore.it>

I/O schedulers typically allow NCQ-capable drives to prefetch I/O
requests, as NCQ boosts the throughput exactly by prefetching and
internally reordering requests.

Unfortunately, as discussed in detail and shown experimentally in [1],
this may cause fairness and latency guarantees to be violated. The
main problem is that the internal scheduler of an NCQ-capable drive
may postpone the service of some unlucky (prefetched) requests as long
as it deems serving other requests more appropriate to boost the
throughput.

This patch addresses this issue by not disabling device idling for
weight-raised queues, even if the device supports NCQ. This allows BFQ
to start serving a new queue, and therefore allows the drive to
prefetch new requests, only after the idling timeout expires. At that
time, all the outstanding requests of the expired queue have been most
certainly served.

[1] P. Valente and M. Andreolini, "Improving Application
    Responsiveness with the BFQ Disk I/O Scheduler", Proceedings of
    the 5th Annual International Systems and Storage Conference
    (SYSTOR '12), June 2012.
    Slightly extended version:
http://www.algogroup.unimo.it/people/paolo/disk_sched/bf1-v1-suite-results.pdf

Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 block/bfq-iosched.c | 5 +++--
 block/bfq.h         | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 661f948..0b24130 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2051,7 +2051,8 @@ static void bfq_update_idle_window(struct bfq_data *bfqd,
 
 	if (atomic_read(&bic->icq.ioc->active_ref) == 0 ||
 	    bfqd->bfq_slice_idle == 0 ||
-		(bfqd->hw_tag && BFQQ_SEEKY(bfqq)))
+		(bfqd->hw_tag && BFQQ_SEEKY(bfqq) &&
+			bfqq->wr_coeff == 1))
 		enable_idle = 0;
 	else if (bfq_sample_valid(bic->ttime.ttime_samples)) {
 		if (bic->ttime.ttime_mean > bfqd->bfq_slice_idle &&
@@ -2874,7 +2875,7 @@ static int __init bfq_init(void)
 	device_speed_thresh[1] = (R_fast[1] + R_slow[1]) / 2;
 
 	elv_register(&iosched_bfq);
-	pr_info("BFQ I/O-scheduler version: v1");
+	pr_info("BFQ I/O-scheduler version: v2");
 
 	return 0;
 }
diff --git a/block/bfq.h b/block/bfq.h
index 5fa8b34..3b5763a7 100644
--- a/block/bfq.h
+++ b/block/bfq.h
@@ -1,5 +1,5 @@
 /*
- * BFQ-v1 for 3.15.0: data structures and common functions prototypes.
+ * BFQ-v2 for 3.15.0: data structures and common functions prototypes.
  *
  * Based on ideas and code from CFQ:
  * Copyright (C) 2003 Jens Axboe <axboe@kernel.dk>
-- 
1.9.2

