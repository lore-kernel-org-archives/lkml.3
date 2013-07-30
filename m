Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3G3Tgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:36:54 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:40041 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3G3Tgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:36:53 -0400
Subject: [RFC PATCH] cfq-iosched: limit slice_idle when many busy queues are
 in idle window
To: linux-kernel@vger.kernel.org
From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Cc: axboe@kernel.dk, tj@kernel.org, seiji.aguchi@hds.com
Date: Tue, 30 Jul 2013 15:30:33 -0400
Message-ID: <20130730193033.27856.58005.stgit@hds.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-07-30_08:2013-07-30,2013-07-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=1
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1307300137
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When some application launches several hundreds of processes that issue
only a few small sync I/O requests, CFQ may cause heavy latencies
(10+ seconds at the worst case), although the request rate is low enough for
the disk to handle it without waiting. This is because CFQ waits for
slice_idle (default:8ms) every time before processing each request, until
their thinktimes are evaluated.

This scenario can be reproduced using fio with parameters below:
  fio -filename=/tmp/test -rw=randread -size=5G -runtime=15 -name=file1 \
      -bs=4k -numjobs=500 -thinktime=1000000
In this case, 500 processes issue a random read request every second.

This problem can be avoided by setting slice_idle to 0, but there is a
risk to hurt throughput performance on S-ATA disks.

This patch tries to reduce the effect of slice_idle automatically when a
lot of busy queues are waiting in the idle window.
It adds a counter (busy_idle_queues) of queues in idle window that have
I/O requests to cfq_data. And if (busy_idle_queues * slice_idle) goes over
the slice allocated to the group, it limits the idle wait time to
(group_slice / busy_idle_queues).

Without this patch, fio benchmark with parameters above to an ext4
partition on a S-ATA HDD results in:
 read : io=20140KB, bw=1258.5KB/s, iops=314 , runt= 16004msec
 clat (usec): min=4 , max=6494.9K, avg=541264.54, stdev=993834.12

With this patch:
  read : io=28040KB, bw=1750.1KB/s, iops=437 , runt= 16014msec
  clat (usec): min=4 , max=2837.2K, avg=110236.79, stdev=303351.72

Average latency is reduced by 80%, and max is also reduced by 56%.

Any comments are appreciated.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
---
 block/cfq-iosched.c |   36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d5cd313..77ac27e80 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -329,6 +329,7 @@ struct cfq_data {
 
 	unsigned int busy_queues;
 	unsigned int busy_sync_queues;
+	unsigned int busy_idle_queues; /* busy but with idle window */
 
 	int rq_in_driver;
 	int rq_in_flight[2];
@@ -446,6 +447,20 @@ CFQ_CFQQ_FNS(deep);
 CFQ_CFQQ_FNS(wait_busy);
 #undef CFQ_CFQQ_FNS
 
+static inline void cfq_set_cfqq_idle_window(struct cfq_data *cfqd,
+					    struct cfq_queue *cfqq, bool idle)
+{
+	if (idle) {
+		cfq_mark_cfqq_idle_window(cfqq);
+		if (cfq_cfqq_on_rr(cfqq))
+			cfqd->busy_idle_queues++;
+	} else {
+		cfq_clear_cfqq_idle_window(cfqq);
+		if (cfq_cfqq_on_rr(cfqq))
+			cfqd->busy_idle_queues--;
+	}
+}
+
 static inline struct cfq_group *pd_to_cfqg(struct blkg_policy_data *pd)
 {
 	return pd ? container_of(pd, struct cfq_group, pd) : NULL;
@@ -2164,6 +2179,8 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfqd->busy_queues++;
 	if (cfq_cfqq_sync(cfqq))
 		cfqd->busy_sync_queues++;
+	if (cfq_cfqq_idle_window(cfqq))
+		cfqd->busy_idle_queues++;
 
 	cfq_resort_rr_list(cfqd, cfqq);
 }
@@ -2192,6 +2209,8 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfqd->busy_queues--;
 	if (cfq_cfqq_sync(cfqq))
 		cfqd->busy_sync_queues--;
+	if (cfq_cfqq_idle_window(cfqq))
+		cfqd->busy_idle_queues--;
 }
 
 /*
@@ -2761,6 +2780,16 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	else
 		sl = cfqd->cfq_slice_idle;
 
+	/*
+	 * If there too many queues with idle window, slice idle can cause
+	 * unacceptable latency. Then we reduce slice idle here.
+	 */
+	if (cfqd->busy_idle_queues) {
+		unsigned group_slice = cfq_group_slice(cfqd, cfqq->cfqg);
+		unsigned long limit = group_slice / cfqd->busy_idle_queues;
+		sl = min(sl, limit);
+	}
+
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
 	cfqg_stats_set_start_idle_time(cfqq->cfqg);
 	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu group_idle: %d", sl,
@@ -3091,7 +3120,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	    (cfq_cfqq_slice_new(cfqq) ||
 	    (cfqq->slice_end - jiffies > jiffies - cfqq->slice_start))) {
 		cfq_clear_cfqq_deep(cfqq);
-		cfq_clear_cfqq_idle_window(cfqq);
+		cfq_set_cfqq_idle_window(cfqd, cfqq, false);
 	}
 
 	if (cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
@@ -3742,10 +3771,7 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 
 	if (old_idle != enable_idle) {
 		cfq_log_cfqq(cfqd, cfqq, "idle=%d", enable_idle);
-		if (enable_idle)
-			cfq_mark_cfqq_idle_window(cfqq);
-		else
-			cfq_clear_cfqq_idle_window(cfqq);
+		cfq_set_cfqq_idle_window(cfqd, cfqq, enable_idle);
 	}
 }
 

