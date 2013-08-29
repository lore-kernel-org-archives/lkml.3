Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3H2DKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 23:10:22 -0400
Received: from sam.nabble.com ([216.139.236.26]:59949 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab3H2DKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 23:10:21 -0400
Date: Wed, 28 Aug 2013 20:10:20 -0700 (PDT)
From: joeytao <husttsq@gmail.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1377745820121-710883.post@n7.nabble.com>
In-Reply-To: <CAFVn34Rq6=VjOvB8KHT-AMNo3WpyNFAKgXxWufQjDRDC0UCEDg@mail.gmail.com>
References: <CAFVn34Rq6=VjOvB8KHT-AMNo3WpyNFAKgXxWufQjDRDC0UCEDg@mail.gmail.com>
Subject: Re: performance drop after using blkcg
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

I also do these tests and find the same results. IMO, on faster storage with
deep queue depth, if device is asking for more requests,but our workload
can't send enough requests, we have to idle to provide service
differentiation. We'll see performance drop if  applications can't drive
enough  IO  to keep disk busy.Especially for writes, with the effect of disk
cache and deep queue depth, we'll often see performance drop .

So I come up with an approach called Self-adaption blkcg that if the 
average total service time for a request is much less,we don' choose to
idle. Otherwise, we choose to idle to wait for the request. The patch is
below. After large tests,the new scheduler can provide service 
differentiation in most cases. When the application can't drive enough
requests and the mean total service time is very small, we don't choose to
idle. In most cases, the performance doesn't drop after using blkcg and the
service  differentiation is good.

>From 50705c8d4e456d3286e76bed7281796b1e915e0e Mon Sep 17 00:00:00 2001
From: Joeytao <husttsq@gmail.com>
Date: Mon, 26 Aug 2013 15:40:39 +0800
Subject: [PATCH] Self-adaption blkcg

---
 block/cfq-iosched.c       |   41 ++++++++++++++++++++++++++++++++++++++---
 include/linux/iocontext.h |    5 +++++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 23500ac..79296de 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -288,6 +288,8 @@ struct cfq_data {
 	unsigned int cfq_group_idle;
 	unsigned int cfq_latency;
 
+    unsigned int cfq_target_latency; 
+    unsigned int cfq_write_isolation; 
 	unsigned int cic_index;
 	struct list_head cic_list;
 
@@ -589,7 +591,7 @@ cfq_group_slice(struct cfq_data *cfqd, struct cfq_group
*cfqg)
 {
 	struct cfq_rb_root *st = &cfqd->grp_service_tree;
 
-	return cfq_target_latency * cfqg->weight / st->total_weight;
+	return cfqd->cfq_target_latency * cfqg->weight / st->total_weight;
 }
 
 static inline unsigned
@@ -2028,6 +2031,14 @@ static void cfq_arm_slice_timer(struct cfq_data
*cfqd)
 			     cic->ttime_mean);
 		return;
 	}
+	
+	/* 
+	 * added by joeytao,   
+	 * If our average await_time is 0, then don't idle. This is for requests
of 
+	 * write,because if the cache of disk is on, it's no need to wait.
+	 */
+	if(!cfqd->cfq_write_isolation && sample_valid(cic->awtime_samples) &&
(cic->awtime_mean==0))
+		return;
 
 	/* There are other queues in the group, don't do group idle */
 	if (group_idle && cfqq->cfqg->nr_cfqq > 1)
@@ -2243,7 +2254,7 @@ new_workload:
 		 * to have higher weight. A more accurate thing would be to
 		 * calculate system wide asnc/sync ratio.
 		 */
-		tmp = cfq_target_latency * cfqg_busy_async_queues(cfqd, cfqg);
+		tmp = cfqd->cfq_target_latency * cfqg_busy_async_queues(cfqd, cfqg);
 		tmp = tmp/cfqd->busy_queues;
 		slice = min_t(unsigned, slice, tmp);
 
@@ -3228,10 +3239,21 @@ err:
 }
 
 static void
+cfq_update_io_awaittime(struct cfq_data *cfqd, struct cfq_io_context *cic)
+{
+	unsigned long elapsed = jiffies - cic->last_end_request;
+	unsigned long awtime = min(elapsed, 2UL * 16);
+
+	cic->awtime_samples = (7*cic->awtime_samples + 256) / 8;
+	cic->awtime_total = (7*cic->awtime_total + 256*awtime) / 8;
+	cic->awtime_mean = (cic->awtime_total + 128) / cic->awtime_samples;
+}   
+
+static void
 cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_io_context *cic)
 {
 	unsigned long elapsed = jiffies - cic->last_end_request;
-	unsigned long ttime = min(elapsed, 2UL * cfqd->cfq_slice_idle);
+	unsigned long ttime = min(elapsed, 2UL * 8);
 
 	cic->ttime_samples = (7*cic->ttime_samples + 256) / 8;
 	cic->ttime_total = (7*cic->ttime_total + 256*ttime) / 8;
@@ -3573,6 +3595,7 @@ static void cfq_completed_request(struct request_queue
*q, struct request *rq)
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
 	if (sync) {
+		cfq_update_io_awaittime(cfqd,RQ_CIC(rq)); /* added by joeytao,
2013.8.27*/
 		RQ_CIC(rq)->last_end_request = now;
 		if (!time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
 			cfqd->last_delayed_sync = now;
@@ -4075,6 +4098,12 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_back_penalty = cfq_back_penalty;
 	cfqd->cfq_slice[0] = cfq_slice_async;
 	cfqd->cfq_slice[1] = cfq_slice_sync;
+	cfqd->cfq_target_latency = cfq_target_latency; /* added by joeytao,
2013.8.5 */
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	cfqd->cfq_write_isolation = 0; /* added by joeytao, 2013.8.16 */
+#else
+	cfqd->cfq_write_isolation = 1; /* added by joeytao, 2013.8.21 */
+#endif
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 	cfqd->cfq_group_idle = cfq_group_idle;
@@ -4154,6 +4183,8 @@ SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1],
1);
 SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
 SHOW_FUNCTION(cfq_low_latency_show, cfqd->cfq_latency, 0);
+SHOW_FUNCTION(cfq_target_latency_show, cfqd->cfq_target_latency, 1);
+SHOW_FUNCTION(cfq_write_isolation_show, cfqd->cfq_write_isolation, 0); 
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -4187,6 +4218,8 @@ STORE_FUNCTION(cfq_slice_async_store,
&cfqd->cfq_slice[0], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
 		UINT_MAX, 0);
 STORE_FUNCTION(cfq_low_latency_store, &cfqd->cfq_latency, 0, 1, 0);
+STORE_FUNCTION(cfq_target_latency_store, &cfqd->cfq_target_latency, 1,
UINT_MAX, 1);
+STORE_FUNCTION(cfq_write_isolation_store, &cfqd->cfq_write_isolation, 0,
UINT_MAX, 0); 
 #undef STORE_FUNCTION
 
 #define CFQ_ATTR(name) \
@@ -4204,6 +4237,8 @@ static struct elv_fs_entry cfq_attrs[] = {
 	CFQ_ATTR(slice_idle),
 	CFQ_ATTR(group_idle),
 	CFQ_ATTR(low_latency),
+	CFQ_ATTR(target_latency),
+	CFQ_ATTR(write_isolation),
 	__ATTR_NULL
 };
 
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index b2eee89..0c45b09 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -18,6 +18,11 @@ struct cfq_io_context {
 	unsigned long ttime_samples;
 	unsigned long ttime_mean;
 
+	/* added by joeytao */
+	unsigned long awtime_total;
+	unsigned long awtime_samples;
+	unsigned long awtime_mean;
+
 	struct list_head queue_list;
 	struct hlist_node cic_list;
 
-- 
1.7.1





--
View this message in context: http://linux-kernel.2935.n7.nabble.com/performance-drop-after-using-blkcg-tp567957p710883.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
