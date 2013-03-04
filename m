Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab3CDJKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:10:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:32610 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250Ab3CDJJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:09:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="270536374"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 10/10] dmatest: append verify result to results
Date: Mon,  4 Mar 2013 11:09:34 +0200
Message-Id: <1362388174-3435-11-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparison between buffers is stored to the dedicated structure.

Note that the verify result is now accessible only via file 'results' in the
debugfs.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/dmatest.txt |   6 +-
 drivers/dma/dmatest.c     | 182 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 132 insertions(+), 56 deletions(-)

diff --git a/Documentation/dmatest.txt b/Documentation/dmatest.txt
index d05782b..279ac0a 100644
--- a/Documentation/dmatest.txt
+++ b/Documentation/dmatest.txt
@@ -75,5 +75,7 @@ The message format is unified across the different types of errors. A number in
 the parens represents additional information, e.g. error code, error counter,
 or status.
 
-Note that the buffer comparison is done in the old way, i.e. data is not
-collected and just printed out.
+Comparison between buffers is stored to the dedicated structure.
+
+Note that the verify result is now accessible only via file 'results' in the
+debugfs.
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 3697bd4..d8ce4ec 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -96,6 +96,20 @@ enum dmatest_error_type {
 	DMATEST_ET_DMA_ERROR,
 	DMATEST_ET_DMA_IN_PROGRESS,
 	DMATEST_ET_VERIFY,
+	DMATEST_ET_VERIFY_BUF,
+};
+
+struct dmatest_verify_buffer {
+	unsigned int	index;
+	u8		expected;
+	u8		actual;
+};
+
+struct dmatest_verify_result {
+	unsigned int			error_count;
+	struct dmatest_verify_buffer	data[MAX_ERROR_COUNT];
+	u8				pattern;
+	bool				is_srcbuf;
 };
 
 struct dmatest_thread_result {
@@ -106,10 +120,11 @@ struct dmatest_thread_result {
 	unsigned int		len;
 	enum dmatest_error_type	type;
 	union {
-		unsigned long		data;
-		dma_cookie_t		cookie;
-		enum dma_status		status;
-		int			error;
+		unsigned long			data;
+		dma_cookie_t			cookie;
+		enum dma_status			status;
+		int				error;
+		struct dmatest_verify_result	*vr;
 	};
 };
 
@@ -246,35 +261,9 @@ static void dmatest_init_dsts(u8 **bufs, unsigned int start, unsigned int len,
 	}
 }
 
-static void dmatest_mismatch(u8 actual, u8 pattern, unsigned int index,
-		unsigned int counter, bool is_srcbuf)
-{
-	u8		diff = actual ^ pattern;
-	u8		expected = pattern | (~counter & PATTERN_COUNT_MASK);
-	const char	*thread_name = current->comm;
-
-	if (is_srcbuf)
-		pr_warning("%s: srcbuf[0x%x] overwritten!"
-				" Expected %02x, got %02x\n",
-				thread_name, index, expected, actual);
-	else if ((pattern & PATTERN_COPY)
-			&& (diff & (PATTERN_COPY | PATTERN_OVERWRITE)))
-		pr_warning("%s: dstbuf[0x%x] not copied!"
-				" Expected %02x, got %02x\n",
-				thread_name, index, expected, actual);
-	else if (diff & PATTERN_SRC)
-		pr_warning("%s: dstbuf[0x%x] was copied!"
-				" Expected %02x, got %02x\n",
-				thread_name, index, expected, actual);
-	else
-		pr_warning("%s: dstbuf[0x%x] mismatch!"
-				" Expected %02x, got %02x\n",
-				thread_name, index, expected, actual);
-}
-
-static unsigned int dmatest_verify(u8 **bufs, unsigned int start,
-		unsigned int end, unsigned int counter, u8 pattern,
-		bool is_srcbuf)
+static unsigned int dmatest_verify(struct dmatest_verify_result *vr, u8 **bufs,
+		unsigned int start, unsigned int end, unsigned int counter,
+		u8 pattern, bool is_srcbuf)
 {
 	unsigned int i;
 	unsigned int error_count = 0;
@@ -282,6 +271,7 @@ static unsigned int dmatest_verify(u8 **bufs, unsigned int start,
 	u8 expected;
 	u8 *buf;
 	unsigned int counter_orig = counter;
+	struct dmatest_verify_buffer *vb;
 
 	for (; (buf = *bufs); bufs++) {
 		counter = counter_orig;
@@ -289,9 +279,12 @@ static unsigned int dmatest_verify(u8 **bufs, unsigned int start,
 			actual = buf[i];
 			expected = pattern | (~counter & PATTERN_COUNT_MASK);
 			if (actual != expected) {
-				if (error_count < MAX_ERROR_COUNT)
-					dmatest_mismatch(actual, pattern, i,
-							 counter, is_srcbuf);
+				if (error_count < MAX_ERROR_COUNT && vr) {
+					vb = &vr->data[error_count];
+					vb->index = i;
+					vb->expected = expected;
+					vb->actual = actual;
+				}
 				error_count++;
 			}
 			counter++;
@@ -340,6 +333,30 @@ static unsigned int min_odd(unsigned int x, unsigned int y)
 	return val % 2 ? val : val - 1;
 }
 
+static char *verify_result_get_one(struct dmatest_verify_result *vr,
+		unsigned int i)
+{
+	struct dmatest_verify_buffer *vb = &vr->data[i];
+	u8 diff = vb->actual ^ vr->pattern;
+	static char buf[512];
+	char *msg;
+
+	if (vr->is_srcbuf)
+		msg = "srcbuf overwritten!";
+	else if ((vr->pattern & PATTERN_COPY)
+			&& (diff & (PATTERN_COPY | PATTERN_OVERWRITE)))
+		msg = "dstbuf not copied!";
+	else if (diff & PATTERN_SRC)
+		msg = "dstbuf was copied!";
+	else
+		msg = "dstbuf mismatch!";
+
+	snprintf(buf, sizeof(buf) - 1, "%s [0x%x] Expected %02x, got %02x", msg,
+		 vb->index, vb->expected, vb->actual);
+
+	return buf;
+}
+
 static char *thread_result_get(const char *name,
 		struct dmatest_thread_result *tr)
 {
@@ -355,6 +372,7 @@ static char *thread_result_get(const char *name,
 		[DMATEST_ET_DMA_IN_PROGRESS]	=
 			"got completion callback (DMA_IN_PROGRESS)",
 		[DMATEST_ET_VERIFY]		= "errors",
+		[DMATEST_ET_VERIFY_BUF]		= "verify errors",
 	};
 	static char buf[512];
 
@@ -392,6 +410,51 @@ static int thread_result_add(struct dmatest_info *info,
 	return 0;
 }
 
+static unsigned int verify_result_add(struct dmatest_info *info,
+		struct dmatest_result *r, unsigned int n,
+		unsigned int src_off, unsigned int dst_off, unsigned int len,
+		u8 **bufs, int whence, unsigned int counter, u8 pattern,
+		bool is_srcbuf)
+{
+	struct dmatest_verify_result *vr;
+	unsigned int error_count;
+	unsigned int buf_off = is_srcbuf ? src_off : dst_off;
+	unsigned int start, end;
+
+	if (whence < 0) {
+		start = 0;
+		end = buf_off;
+	} else if (whence > 0) {
+		start = buf_off + len;
+		end = info->params.buf_size;
+	} else {
+		start = buf_off;
+		end = buf_off + len;
+	}
+
+	vr = kmalloc(sizeof(*vr), GFP_KERNEL);
+	if (!vr) {
+		pr_warn("dmatest: No memory to store verify result\n");
+		return dmatest_verify(NULL, bufs, start, end, counter, pattern,
+				      is_srcbuf);
+	}
+
+	vr->pattern = pattern;
+	vr->is_srcbuf = is_srcbuf;
+
+	error_count = dmatest_verify(vr, bufs, start, end, counter, pattern,
+				     is_srcbuf);
+	if (error_count) {
+		vr->error_count = error_count;
+		thread_result_add(info, r, DMATEST_ET_VERIFY_BUF, n, src_off,
+				  dst_off, len, (unsigned long)vr);
+		return error_count;
+	}
+
+	kfree(vr);
+	return 0;
+}
+
 static void result_free(struct dmatest_info *info, const char *name)
 {
 	struct dmatest_result *r, *_r;
@@ -404,6 +467,8 @@ static void result_free(struct dmatest_info *info, const char *name)
 			continue;
 
 		list_for_each_entry_safe(tr, _tr, &r->results, node) {
+			if (tr->type == DMATEST_ET_VERIFY_BUF)
+				kfree(tr->vr);
 			list_del(&tr->node);
 			kfree(tr);
 		}
@@ -687,25 +752,26 @@ static int dmatest_func(void *data)
 		error_count = 0;
 
 		pr_debug("%s: verifying source buffer...\n", thread_name);
-		error_count += dmatest_verify(thread->srcs, 0, src_off,
+		error_count += verify_result_add(info, result, total_tests,
+				src_off, dst_off, len, thread->srcs, -1,
 				0, PATTERN_SRC, true);
-		error_count += dmatest_verify(thread->srcs, src_off,
-				src_off + len, src_off,
-				PATTERN_SRC | PATTERN_COPY, true);
-		error_count += dmatest_verify(thread->srcs, src_off + len,
-				params->buf_size, src_off + len,
-				PATTERN_SRC, true);
-
-		pr_debug("%s: verifying dest buffer...\n",
-				thread->task->comm);
-		error_count += dmatest_verify(thread->dsts, 0, dst_off,
+		error_count += verify_result_add(info, result, total_tests,
+				src_off, dst_off, len, thread->srcs, 0,
+				src_off, PATTERN_SRC | PATTERN_COPY, true);
+		error_count += verify_result_add(info, result, total_tests,
+				src_off, dst_off, len, thread->srcs, 1,
+				src_off + len, PATTERN_SRC, true);
+
+		pr_debug("%s: verifying dest buffer...\n", thread_name);
+		error_count += verify_result_add(info, result, total_tests,
+				src_off, dst_off, len, thread->dsts, -1,
 				0, PATTERN_DST, false);
-		error_count += dmatest_verify(thread->dsts, dst_off,
-				dst_off + len, src_off,
-				PATTERN_SRC | PATTERN_COPY, false);
-		error_count += dmatest_verify(thread->dsts, dst_off + len,
-				params->buf_size, dst_off + len,
-				PATTERN_DST, false);
+		error_count += verify_result_add(info, result, total_tests,
+				src_off, dst_off, len, thread->dsts, 0,
+				src_off, PATTERN_SRC | PATTERN_COPY, false);
+		error_count += verify_result_add(info, result, total_tests,
+				src_off, dst_off, len, thread->dsts, 1,
+				dst_off + len, PATTERN_DST, false);
 
 		if (error_count) {
 			thread_result_add(info, result, DMATEST_ET_VERIFY,
@@ -1085,12 +1151,20 @@ static int dtf_results_show(struct seq_file *sf, void *data)
 	struct dmatest_info *info = sf->private;
 	struct dmatest_result *result;
 	struct dmatest_thread_result *tr;
+	unsigned int i;
 
 	mutex_lock(&info->results_lock);
 	list_for_each_entry(result, &info->results, node) {
-		list_for_each_entry(tr, &result->results, node)
+		list_for_each_entry(tr, &result->results, node) {
 			seq_printf(sf, "%s\n",
 				thread_result_get(result->name, tr));
+			if (tr->type == DMATEST_ET_VERIFY_BUF) {
+				for (i = 0; i < tr->vr->error_count; i++) {
+					seq_printf(sf, "\t%s\n",
+						verify_result_get_one(tr->vr, i));
+				}
+			}
+		}
 	}
 
 	mutex_unlock(&info->results_lock);
-- 
1.8.2.rc0.22.gb3600c3

