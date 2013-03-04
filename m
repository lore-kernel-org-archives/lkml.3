Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab3CDJNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:13:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:18261 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab3CDJJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:09:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="294402024"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 05/10] dmatest: split test parameters to separate structure
Date: Mon,  4 Mar 2013 11:09:29 +0200
Message-Id: <1362388174-3435-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better to keep test parameters separate from internal variables.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dmatest.c | 109 ++++++++++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 47 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 475a21a..c6e5d83 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -97,7 +97,7 @@ struct dmatest_chan {
 };
 
 /**
- * struct dmatest_info - test information.
+ * struct dmatest_params - test parameters.
  * @buf_size:		size of the memcpy test buffer
  * @channel:		bus ID of the channel to test
  * @device:		bus ID of the DMA Engine to test
@@ -108,8 +108,7 @@ struct dmatest_chan {
  * @pq_sources:		number of p+q source buffers
  * @timeout:		transfer timeout in msec, -1 for infinite timeout
  */
-struct dmatest_info {
-	/* Test parameters */
+struct dmatest_params {
 	unsigned int	buf_size;
 	char		channel[20];
 	char		device[20];
@@ -119,6 +118,15 @@ struct dmatest_info {
 	unsigned int	xor_sources;
 	unsigned int	pq_sources;
 	int		timeout;
+};
+
+/**
+ * struct dmatest_info - test information.
+ * @params:		test parameters
+ */
+struct dmatest_info {
+	/* Test parameters */
+	struct dmatest_params	params;
 
 	/* Internal state */
 	struct list_head	channels;
@@ -127,20 +135,20 @@ struct dmatest_info {
 
 static struct dmatest_info test_info;
 
-static bool dmatest_match_channel(struct dmatest_info *info,
+static bool dmatest_match_channel(struct dmatest_params *params,
 		struct dma_chan *chan)
 {
-	if (info->channel[0] == '\0')
+	if (params->channel[0] == '\0')
 		return true;
-	return strcmp(dma_chan_name(chan), info->channel) == 0;
+	return strcmp(dma_chan_name(chan), params->channel) == 0;
 }
 
-static bool dmatest_match_device(struct dmatest_info *info,
+static bool dmatest_match_device(struct dmatest_params *params,
 		struct dma_device *device)
 {
-	if (info->device[0] == '\0')
+	if (params->device[0] == '\0')
 		return true;
-	return strcmp(dev_name(device->dev), info->device) == 0;
+	return strcmp(dev_name(device->dev), params->device) == 0;
 }
 
 static unsigned long dmatest_random(void)
@@ -300,6 +308,7 @@ static int dmatest_func(void *data)
 	struct dmatest_thread	*thread = data;
 	struct dmatest_done	done = { .wait = &done_wait };
 	struct dmatest_info	*info;
+	struct dmatest_params	*params;
 	struct dma_chan		*chan;
 	struct dma_device	*dev;
 	const char		*thread_name;
@@ -323,20 +332,21 @@ static int dmatest_func(void *data)
 
 	smp_rmb();
 	info = thread->info;
+	params = &info->params;
 	chan = thread->chan;
 	dev = chan->device;
 	if (thread->type == DMA_MEMCPY)
 		src_cnt = dst_cnt = 1;
 	else if (thread->type == DMA_XOR) {
 		/* force odd to ensure dst = src */
-		src_cnt = min_odd(info->xor_sources | 1, dev->max_xor);
+		src_cnt = min_odd(params->xor_sources | 1, dev->max_xor);
 		dst_cnt = 1;
 	} else if (thread->type == DMA_PQ) {
 		/* force odd to ensure dst = src */
-		src_cnt = min_odd(info->pq_sources | 1, dma_maxpq(dev, 0));
+		src_cnt = min_odd(params->pq_sources | 1, dma_maxpq(dev, 0));
 		dst_cnt = 2;
 
-		pq_coefs = kmalloc(info->pq_sources+1, GFP_KERNEL);
+		pq_coefs = kmalloc(params->pq_sources+1, GFP_KERNEL);
 		if (!pq_coefs)
 			goto err_thread_type;
 
@@ -349,7 +359,7 @@ static int dmatest_func(void *data)
 	if (!thread->srcs)
 		goto err_srcs;
 	for (i = 0; i < src_cnt; i++) {
-		thread->srcs[i] = kmalloc(info->buf_size, GFP_KERNEL);
+		thread->srcs[i] = kmalloc(params->buf_size, GFP_KERNEL);
 		if (!thread->srcs[i])
 			goto err_srcbuf;
 	}
@@ -359,7 +369,7 @@ static int dmatest_func(void *data)
 	if (!thread->dsts)
 		goto err_dsts;
 	for (i = 0; i < dst_cnt; i++) {
-		thread->dsts[i] = kmalloc(info->buf_size, GFP_KERNEL);
+		thread->dsts[i] = kmalloc(params->buf_size, GFP_KERNEL);
 		if (!thread->dsts[i])
 			goto err_dstbuf;
 	}
@@ -375,7 +385,7 @@ static int dmatest_func(void *data)
 	      | DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SRC_UNMAP_SINGLE;
 
 	while (!kthread_should_stop()
-	       && !(info->iterations && total_tests >= info->iterations)) {
+	       && !(params->iterations && total_tests >= params->iterations)) {
 		struct dma_async_tx_descriptor *tx = NULL;
 		dma_addr_t dma_srcs[src_cnt];
 		dma_addr_t dma_dsts[dst_cnt];
@@ -391,24 +401,24 @@ static int dmatest_func(void *data)
 		else if (thread->type == DMA_PQ)
 			align = dev->pq_align;
 
-		if (1 << align > info->buf_size) {
+		if (1 << align > params->buf_size) {
 			pr_err("%u-byte buffer too small for %d-byte alignment\n",
-			       info->buf_size, 1 << align);
+			       params->buf_size, 1 << align);
 			break;
 		}
 
-		len = dmatest_random() % info->buf_size + 1;
+		len = dmatest_random() % params->buf_size + 1;
 		len = (len >> align) << align;
 		if (!len)
 			len = 1 << align;
-		src_off = dmatest_random() % (info->buf_size - len + 1);
-		dst_off = dmatest_random() % (info->buf_size - len + 1);
+		src_off = dmatest_random() % (params->buf_size - len + 1);
+		dst_off = dmatest_random() % (params->buf_size - len + 1);
 
 		src_off = (src_off >> align) << align;
 		dst_off = (dst_off >> align) << align;
 
-		dmatest_init_srcs(thread->srcs, src_off, len, info->buf_size);
-		dmatest_init_dsts(thread->dsts, dst_off, len, info->buf_size);
+		dmatest_init_srcs(thread->srcs, src_off, len, params->buf_size);
+		dmatest_init_dsts(thread->dsts, dst_off, len, params->buf_size);
 
 		for (i = 0; i < src_cnt; i++) {
 			u8 *buf = thread->srcs[i] + src_off;
@@ -429,16 +439,17 @@ static int dmatest_func(void *data)
 		/* map with DMA_BIDIRECTIONAL to force writeback/invalidate */
 		for (i = 0; i < dst_cnt; i++) {
 			dma_dsts[i] = dma_map_single(dev->dev, thread->dsts[i],
-						     info->buf_size,
+						     params->buf_size,
 						     DMA_BIDIRECTIONAL);
 			ret = dma_mapping_error(dev->dev, dma_dsts[i]);
 			if (ret) {
 				unmap_src(dev->dev, dma_srcs, len, src_cnt);
-				unmap_dst(dev->dev, dma_dsts, info->buf_size, i);
+				unmap_dst(dev->dev, dma_dsts, params->buf_size,
+					  i);
 				pr_warn("%s: #%u: mapping error %d with "
 					"dst_off=0x%x len=0x%x\n",
 					thread_name, total_tests - 1, ret,
-					dst_off, info->buf_size);
+					dst_off, params->buf_size);
 				failed_tests++;
 				continue;
 			}
@@ -466,7 +477,8 @@ static int dmatest_func(void *data)
 
 		if (!tx) {
 			unmap_src(dev->dev, dma_srcs, len, src_cnt);
-			unmap_dst(dev->dev, dma_dsts, info->buf_size, dst_cnt);
+			unmap_dst(dev->dev, dma_dsts, params->buf_size,
+				  dst_cnt);
 			pr_warning("%s: #%u: prep error with src_off=0x%x "
 					"dst_off=0x%x len=0x%x\n",
 					thread_name, total_tests - 1,
@@ -494,7 +506,7 @@ static int dmatest_func(void *data)
 
 		wait_event_freezable_timeout(done_wait,
 					     done.done || kthread_should_stop(),
-					     msecs_to_jiffies(info->timeout));
+					     msecs_to_jiffies(params->timeout));
 
 		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
 
@@ -521,7 +533,7 @@ static int dmatest_func(void *data)
 		}
 
 		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
-		unmap_dst(dev->dev, dma_dsts, info->buf_size, dst_cnt);
+		unmap_dst(dev->dev, dma_dsts, params->buf_size, dst_cnt);
 
 		error_count = 0;
 
@@ -532,7 +544,7 @@ static int dmatest_func(void *data)
 				src_off + len, src_off,
 				PATTERN_SRC | PATTERN_COPY, true);
 		error_count += dmatest_verify(thread->srcs, src_off + len,
-				info->buf_size, src_off + len,
+				params->buf_size, src_off + len,
 				PATTERN_SRC, true);
 
 		pr_debug("%s: verifying dest buffer...\n",
@@ -543,7 +555,7 @@ static int dmatest_func(void *data)
 				dst_off + len, src_off,
 				PATTERN_SRC | PATTERN_COPY, false);
 		error_count += dmatest_verify(thread->dsts, dst_off + len,
-				info->buf_size, dst_off + len,
+				params->buf_size, dst_off + len,
 				PATTERN_DST, false);
 
 		if (error_count) {
@@ -580,7 +592,7 @@ err_thread_type:
 	if (ret)
 		dmaengine_terminate_all(chan);
 
-	if (info->iterations > 0)
+	if (params->iterations > 0)
 		while (!kthread_should_stop()) {
 			DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_dmatest_exit);
 			interruptible_sleep_on(&wait_dmatest_exit);
@@ -612,6 +624,7 @@ static void dmatest_cleanup_channel(struct dmatest_chan *dtc)
 static int dmatest_add_threads(struct dmatest_info *info,
 		struct dmatest_chan *dtc, enum dma_transaction_type type)
 {
+	struct dmatest_params *params = &info->params;
 	struct dmatest_thread *thread;
 	struct dma_chan *chan = dtc->chan;
 	char *op;
@@ -626,7 +639,7 @@ static int dmatest_add_threads(struct dmatest_info *info,
 	else
 		return -EINVAL;
 
-	for (i = 0; i < info->threads_per_chan; i++) {
+	for (i = 0; i < params->threads_per_chan; i++) {
 		thread = kzalloc(sizeof(struct dmatest_thread), GFP_KERNEL);
 		if (!thread) {
 			pr_warning("dmatest: No memory for %s-%s%u\n",
@@ -696,10 +709,10 @@ static int dmatest_add_channel(struct dmatest_info *info,
 
 static bool filter(struct dma_chan *chan, void *param)
 {
-	struct dmatest_info *info = param;
+	struct dmatest_params *params = param;
 
-	if (!dmatest_match_channel(info, chan) ||
-	    !dmatest_match_device(info, chan->device))
+	if (!dmatest_match_channel(params, chan) ||
+	    !dmatest_match_device(params, chan->device))
 		return false;
 	else
 		return true;
@@ -709,12 +722,13 @@ static int run_threaded_test(struct dmatest_info *info)
 {
 	dma_cap_mask_t mask;
 	struct dma_chan *chan;
+	struct dmatest_params *params = &info->params;
 	int err = 0;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_MEMCPY, mask);
 	for (;;) {
-		chan = dma_request_channel(mask, filter, info);
+		chan = dma_request_channel(mask, filter, params);
 		if (chan) {
 			err = dmatest_add_channel(info, chan);
 			if (err) {
@@ -723,8 +737,8 @@ static int run_threaded_test(struct dmatest_info *info)
 			}
 		} else
 			break; /* no more channels available */
-		if (info->max_channels &&
-		    info->nr_channels >= info->max_channels)
+		if (params->max_channels &&
+		    info->nr_channels >= params->max_channels)
 			break; /* we have all we need */
 	}
 	return err;
@@ -749,21 +763,22 @@ static void stop_threaded_test(struct dmatest_info *info)
 static int __init dmatest_init(void)
 {
 	struct dmatest_info *info = &test_info;
+	struct dmatest_params *params = &info->params;
 
 	memset(info, 0, sizeof(*info));
 
 	INIT_LIST_HEAD(&info->channels);
 
 	/* Set default parameters */
-	info->buf_size = test_buf_size;
-	strlcpy(info->channel, test_channel, sizeof(info->channel));
-	strlcpy(info->device, test_device, sizeof(info->device));
-	info->threads_per_chan = threads_per_chan;
-	info->max_channels = max_channels;
-	info->iterations = iterations;
-	info->xor_sources = xor_sources;
-	info->pq_sources = pq_sources;
-	info->timeout = timeout;
+	params->buf_size = test_buf_size;
+	strlcpy(params->channel, test_channel, sizeof(params->channel));
+	strlcpy(params->device, test_device, sizeof(params->device));
+	params->threads_per_chan = threads_per_chan;
+	params->max_channels = max_channels;
+	params->iterations = iterations;
+	params->xor_sources = xor_sources;
+	params->pq_sources = pq_sources;
+	params->timeout = timeout;
 
 	return run_threaded_test(info);
 }
-- 
1.8.2.rc0.22.gb3600c3

