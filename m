Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab3CDJKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:10:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:4286 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222Ab3CDJKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:10:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="208485586"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 03/10] dmatest: create dmatest_info to keep test parameters
Date: Mon,  4 Mar 2013 11:09:27 +0200
Message-Id: <1362388174-3435-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The proposed change will remove usage of the module parameters as global
variables. In future it helps to run different test cases sequentially.

The patch introduces the run_threaded_test() and stop_threaded_test() functions
that could be used later outside of dmatest_init, dmatest_exit scope.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dmatest.c | 160 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 113 insertions(+), 47 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index e3955be..7f9e3cc 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -78,8 +78,11 @@ MODULE_PARM_DESC(timeout, "Transfer Timeout in msec (default: 3000), "
 #define PATTERN_OVERWRITE	0x20
 #define PATTERN_COUNT_MASK	0x1f
 
+struct dmatest_info;
+
 struct dmatest_thread {
 	struct list_head	node;
+	struct dmatest_info	*info;
 	struct task_struct	*task;
 	struct dma_chan		*chan;
 	u8			**srcs;
@@ -93,6 +96,32 @@ struct dmatest_chan {
 	struct list_head	threads;
 };
 
+/**
+ * struct dmatest_info - test information.
+ * @buf_size:		size of the memcpy test buffer
+ * @channel:		bus ID of the channel to test
+ * @device:		bus ID of the DMA Engine to test
+ * @threads_per_chan:	number of threads to start per channel
+ * @max_channels:	maximum number of channels to use
+ * @iterations:		iterations before stopping test
+ * @xor_sources:	number of xor source buffers
+ * @pq_sources:		number of p+q source buffers
+ * @timeout:		transfer timeout in msec, -1 for infinite timeout
+ */
+struct dmatest_info {
+	unsigned int	buf_size;
+	char		channel[20];
+	char		device[20];
+	unsigned int	threads_per_chan;
+	unsigned int	max_channels;
+	unsigned int	iterations;
+	unsigned int	xor_sources;
+	unsigned int	pq_sources;
+	int		timeout;
+};
+
+static struct dmatest_info test_info;
+
 /*
  * These are protected by dma_list_mutex since they're only used by
  * the DMA filter function callback
@@ -100,18 +129,20 @@ struct dmatest_chan {
 static LIST_HEAD(dmatest_channels);
 static unsigned int nr_channels;
 
-static bool dmatest_match_channel(struct dma_chan *chan)
+static bool dmatest_match_channel(struct dmatest_info *info,
+		struct dma_chan *chan)
 {
-	if (test_channel[0] == '\0')
+	if (info->channel[0] == '\0')
 		return true;
-	return strcmp(dma_chan_name(chan), test_channel) == 0;
+	return strcmp(dma_chan_name(chan), info->channel) == 0;
 }
 
-static bool dmatest_match_device(struct dma_device *device)
+static bool dmatest_match_device(struct dmatest_info *info,
+		struct dma_device *device)
 {
-	if (test_device[0] == '\0')
+	if (info->device[0] == '\0')
 		return true;
-	return strcmp(dev_name(device->dev), test_device) == 0;
+	return strcmp(dev_name(device->dev), info->device) == 0;
 }
 
 static unsigned long dmatest_random(void)
@@ -122,7 +153,8 @@ static unsigned long dmatest_random(void)
 	return buf;
 }
 
-static void dmatest_init_srcs(u8 **bufs, unsigned int start, unsigned int len)
+static void dmatest_init_srcs(u8 **bufs, unsigned int start, unsigned int len,
+		unsigned int buf_size)
 {
 	unsigned int i;
 	u8 *buf;
@@ -133,13 +165,14 @@ static void dmatest_init_srcs(u8 **bufs, unsigned int start, unsigned int len)
 		for ( ; i < start + len; i++)
 			buf[i] = PATTERN_SRC | PATTERN_COPY
 				| (~i & PATTERN_COUNT_MASK);
-		for ( ; i < test_buf_size; i++)
+		for ( ; i < buf_size; i++)
 			buf[i] = PATTERN_SRC | (~i & PATTERN_COUNT_MASK);
 		buf++;
 	}
 }
 
-static void dmatest_init_dsts(u8 **bufs, unsigned int start, unsigned int len)
+static void dmatest_init_dsts(u8 **bufs, unsigned int start, unsigned int len,
+		unsigned int buf_size)
 {
 	unsigned int i;
 	u8 *buf;
@@ -150,7 +183,7 @@ static void dmatest_init_dsts(u8 **bufs, unsigned int start, unsigned int len)
 		for ( ; i < start + len; i++)
 			buf[i] = PATTERN_DST | PATTERN_OVERWRITE
 				| (~i & PATTERN_COUNT_MASK);
-		for ( ; i < test_buf_size; i++)
+		for ( ; i < buf_size; i++)
 			buf[i] = PATTERN_DST | (~i & PATTERN_COUNT_MASK);
 	}
 }
@@ -268,6 +301,7 @@ static int dmatest_func(void *data)
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(done_wait);
 	struct dmatest_thread	*thread = data;
 	struct dmatest_done	done = { .wait = &done_wait };
+	struct dmatest_info	*info;
 	struct dma_chan		*chan;
 	struct dma_device	*dev;
 	const char		*thread_name;
@@ -290,20 +324,21 @@ static int dmatest_func(void *data)
 	ret = -ENOMEM;
 
 	smp_rmb();
+	info = thread->info;
 	chan = thread->chan;
 	dev = chan->device;
 	if (thread->type == DMA_MEMCPY)
 		src_cnt = dst_cnt = 1;
 	else if (thread->type == DMA_XOR) {
 		/* force odd to ensure dst = src */
-		src_cnt = min_odd(xor_sources | 1, dev->max_xor);
+		src_cnt = min_odd(info->xor_sources | 1, dev->max_xor);
 		dst_cnt = 1;
 	} else if (thread->type == DMA_PQ) {
 		/* force odd to ensure dst = src */
-		src_cnt = min_odd(pq_sources | 1, dma_maxpq(dev, 0));
+		src_cnt = min_odd(info->pq_sources | 1, dma_maxpq(dev, 0));
 		dst_cnt = 2;
 
-		pq_coefs = kmalloc(pq_sources+1, GFP_KERNEL);
+		pq_coefs = kmalloc(info->pq_sources+1, GFP_KERNEL);
 		if (!pq_coefs)
 			goto err_thread_type;
 
@@ -316,7 +351,7 @@ static int dmatest_func(void *data)
 	if (!thread->srcs)
 		goto err_srcs;
 	for (i = 0; i < src_cnt; i++) {
-		thread->srcs[i] = kmalloc(test_buf_size, GFP_KERNEL);
+		thread->srcs[i] = kmalloc(info->buf_size, GFP_KERNEL);
 		if (!thread->srcs[i])
 			goto err_srcbuf;
 	}
@@ -326,7 +361,7 @@ static int dmatest_func(void *data)
 	if (!thread->dsts)
 		goto err_dsts;
 	for (i = 0; i < dst_cnt; i++) {
-		thread->dsts[i] = kmalloc(test_buf_size, GFP_KERNEL);
+		thread->dsts[i] = kmalloc(info->buf_size, GFP_KERNEL);
 		if (!thread->dsts[i])
 			goto err_dstbuf;
 	}
@@ -342,7 +377,7 @@ static int dmatest_func(void *data)
 	      | DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SRC_UNMAP_SINGLE;
 
 	while (!kthread_should_stop()
-	       && !(iterations && total_tests >= iterations)) {
+	       && !(info->iterations && total_tests >= info->iterations)) {
 		struct dma_async_tx_descriptor *tx = NULL;
 		dma_addr_t dma_srcs[src_cnt];
 		dma_addr_t dma_dsts[dst_cnt];
@@ -358,24 +393,24 @@ static int dmatest_func(void *data)
 		else if (thread->type == DMA_PQ)
 			align = dev->pq_align;
 
-		if (1 << align > test_buf_size) {
+		if (1 << align > info->buf_size) {
 			pr_err("%u-byte buffer too small for %d-byte alignment\n",
-			       test_buf_size, 1 << align);
+			       info->buf_size, 1 << align);
 			break;
 		}
 
-		len = dmatest_random() % test_buf_size + 1;
+		len = dmatest_random() % info->buf_size + 1;
 		len = (len >> align) << align;
 		if (!len)
 			len = 1 << align;
-		src_off = dmatest_random() % (test_buf_size - len + 1);
-		dst_off = dmatest_random() % (test_buf_size - len + 1);
+		src_off = dmatest_random() % (info->buf_size - len + 1);
+		dst_off = dmatest_random() % (info->buf_size - len + 1);
 
 		src_off = (src_off >> align) << align;
 		dst_off = (dst_off >> align) << align;
 
-		dmatest_init_srcs(thread->srcs, src_off, len);
-		dmatest_init_dsts(thread->dsts, dst_off, len);
+		dmatest_init_srcs(thread->srcs, src_off, len, info->buf_size);
+		dmatest_init_dsts(thread->dsts, dst_off, len, info->buf_size);
 
 		for (i = 0; i < src_cnt; i++) {
 			u8 *buf = thread->srcs[i] + src_off;
@@ -396,16 +431,16 @@ static int dmatest_func(void *data)
 		/* map with DMA_BIDIRECTIONAL to force writeback/invalidate */
 		for (i = 0; i < dst_cnt; i++) {
 			dma_dsts[i] = dma_map_single(dev->dev, thread->dsts[i],
-						     test_buf_size,
+						     info->buf_size,
 						     DMA_BIDIRECTIONAL);
 			ret = dma_mapping_error(dev->dev, dma_dsts[i]);
 			if (ret) {
 				unmap_src(dev->dev, dma_srcs, len, src_cnt);
-				unmap_dst(dev->dev, dma_dsts, test_buf_size, i);
+				unmap_dst(dev->dev, dma_dsts, info->buf_size, i);
 				pr_warn("%s: #%u: mapping error %d with "
 					"dst_off=0x%x len=0x%x\n",
 					thread_name, total_tests - 1, ret,
-					dst_off, test_buf_size);
+					dst_off, info->buf_size);
 				failed_tests++;
 				continue;
 			}
@@ -433,7 +468,7 @@ static int dmatest_func(void *data)
 
 		if (!tx) {
 			unmap_src(dev->dev, dma_srcs, len, src_cnt);
-			unmap_dst(dev->dev, dma_dsts, test_buf_size, dst_cnt);
+			unmap_dst(dev->dev, dma_dsts, info->buf_size, dst_cnt);
 			pr_warning("%s: #%u: prep error with src_off=0x%x "
 					"dst_off=0x%x len=0x%x\n",
 					thread_name, total_tests - 1,
@@ -461,7 +496,7 @@ static int dmatest_func(void *data)
 
 		wait_event_freezable_timeout(done_wait,
 					     done.done || kthread_should_stop(),
-					     msecs_to_jiffies(timeout));
+					     msecs_to_jiffies(info->timeout));
 
 		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
 
@@ -488,7 +523,7 @@ static int dmatest_func(void *data)
 		}
 
 		/* Unmap by myself (see DMA_COMPL_SKIP_DEST_UNMAP above) */
-		unmap_dst(dev->dev, dma_dsts, test_buf_size, dst_cnt);
+		unmap_dst(dev->dev, dma_dsts, info->buf_size, dst_cnt);
 
 		error_count = 0;
 
@@ -499,7 +534,7 @@ static int dmatest_func(void *data)
 				src_off + len, src_off,
 				PATTERN_SRC | PATTERN_COPY, true);
 		error_count += dmatest_verify(thread->srcs, src_off + len,
-				test_buf_size, src_off + len,
+				info->buf_size, src_off + len,
 				PATTERN_SRC, true);
 
 		pr_debug("%s: verifying dest buffer...\n",
@@ -510,7 +545,7 @@ static int dmatest_func(void *data)
 				dst_off + len, src_off,
 				PATTERN_SRC | PATTERN_COPY, false);
 		error_count += dmatest_verify(thread->dsts, dst_off + len,
-				test_buf_size, dst_off + len,
+				info->buf_size, dst_off + len,
 				PATTERN_DST, false);
 
 		if (error_count) {
@@ -547,7 +582,7 @@ err_thread_type:
 	if (ret)
 		dmaengine_terminate_all(chan);
 
-	if (iterations > 0)
+	if (info->iterations > 0)
 		while (!kthread_should_stop()) {
 			DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_dmatest_exit);
 			interruptible_sleep_on(&wait_dmatest_exit);
@@ -576,7 +611,8 @@ static void dmatest_cleanup_channel(struct dmatest_chan *dtc)
 	kfree(dtc);
 }
 
-static int dmatest_add_threads(struct dmatest_chan *dtc, enum dma_transaction_type type)
+static int dmatest_add_threads(struct dmatest_info *info,
+		struct dmatest_chan *dtc, enum dma_transaction_type type)
 {
 	struct dmatest_thread *thread;
 	struct dma_chan *chan = dtc->chan;
@@ -592,7 +628,7 @@ static int dmatest_add_threads(struct dmatest_chan *dtc, enum dma_transaction_ty
 	else
 		return -EINVAL;
 
-	for (i = 0; i < threads_per_chan; i++) {
+	for (i = 0; i < info->threads_per_chan; i++) {
 		thread = kzalloc(sizeof(struct dmatest_thread), GFP_KERNEL);
 		if (!thread) {
 			pr_warning("dmatest: No memory for %s-%s%u\n",
@@ -600,6 +636,7 @@ static int dmatest_add_threads(struct dmatest_chan *dtc, enum dma_transaction_ty
 
 			break;
 		}
+		thread->info = info;
 		thread->chan = dtc->chan;
 		thread->type = type;
 		smp_wmb();
@@ -620,7 +657,8 @@ static int dmatest_add_threads(struct dmatest_chan *dtc, enum dma_transaction_ty
 	return i;
 }
 
-static int dmatest_add_channel(struct dma_chan *chan)
+static int dmatest_add_channel(struct dmatest_info *info,
+		struct dma_chan *chan)
 {
 	struct dmatest_chan	*dtc;
 	struct dma_device	*dma_dev = chan->device;
@@ -637,15 +675,15 @@ static int dmatest_add_channel(struct dma_chan *chan)
 	INIT_LIST_HEAD(&dtc->threads);
 
 	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
-		cnt = dmatest_add_threads(dtc, DMA_MEMCPY);
+		cnt = dmatest_add_threads(info, dtc, DMA_MEMCPY);
 		thread_count += cnt > 0 ? cnt : 0;
 	}
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
-		cnt = dmatest_add_threads(dtc, DMA_XOR);
+		cnt = dmatest_add_threads(info, dtc, DMA_XOR);
 		thread_count += cnt > 0 ? cnt : 0;
 	}
 	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
-		cnt = dmatest_add_threads(dtc, DMA_PQ);
+		cnt = dmatest_add_threads(info, dtc, DMA_PQ);
 		thread_count += cnt > 0 ? cnt : 0;
 	}
 
@@ -660,13 +698,16 @@ static int dmatest_add_channel(struct dma_chan *chan)
 
 static bool filter(struct dma_chan *chan, void *param)
 {
-	if (!dmatest_match_channel(chan) || !dmatest_match_device(chan->device))
+	struct dmatest_info *info = param;
+
+	if (!dmatest_match_channel(info, chan) ||
+	    !dmatest_match_device(info, chan->device))
 		return false;
 	else
 		return true;
 }
 
-static int __init dmatest_init(void)
+static int run_threaded_test(struct dmatest_info *info)
 {
 	dma_cap_mask_t mask;
 	struct dma_chan *chan;
@@ -675,25 +716,22 @@ static int __init dmatest_init(void)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_MEMCPY, mask);
 	for (;;) {
-		chan = dma_request_channel(mask, filter, NULL);
+		chan = dma_request_channel(mask, filter, info);
 		if (chan) {
-			err = dmatest_add_channel(chan);
+			err = dmatest_add_channel(info, chan);
 			if (err) {
 				dma_release_channel(chan);
 				break; /* add_channel failed, punt */
 			}
 		} else
 			break; /* no more channels available */
-		if (max_channels && nr_channels >= max_channels)
+		if (info->max_channels && nr_channels >= info->max_channels)
 			break; /* we have all we need */
 	}
-
 	return err;
 }
-/* when compiled-in wait for drivers to load first */
-late_initcall(dmatest_init);
 
-static void __exit dmatest_exit(void)
+static void stop_threaded_test(struct dmatest_info *info)
 {
 	struct dmatest_chan *dtc, *_dtc;
 	struct dma_chan *chan;
@@ -707,6 +745,34 @@ static void __exit dmatest_exit(void)
 		dma_release_channel(chan);
 	}
 }
+
+static int __init dmatest_init(void)
+{
+	struct dmatest_info *info = &test_info;
+
+	memset(info, 0, sizeof(*info));
+
+	info->buf_size = test_buf_size;
+	strlcpy(info->channel, test_channel, sizeof(info->channel));
+	strlcpy(info->device, test_device, sizeof(info->device));
+	info->threads_per_chan = threads_per_chan;
+	info->max_channels = max_channels;
+	info->iterations = iterations;
+	info->xor_sources = xor_sources;
+	info->pq_sources = pq_sources;
+	info->timeout = timeout;
+
+	return run_threaded_test(info);
+}
+/* when compiled-in wait for drivers to load first */
+late_initcall(dmatest_init);
+
+static void __exit dmatest_exit(void)
+{
+	struct dmatest_info *info = &test_info;
+
+	stop_threaded_test(info);
+}
 module_exit(dmatest_exit);
 
 MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
-- 
1.8.2.rc0.22.gb3600c3

