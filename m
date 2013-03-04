Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab3CDJJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:09:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:28340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222Ab3CDJJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:09:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="294402032"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 09/10] dmatest: gather test results in the linked list
Date: Mon,  4 Mar 2013 11:09:33 +0200
Message-Id: <1362388174-3435-10-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch provides a storage for the test results in the linked list. The
gathered data could be used after test is done.

The new file 'results' represents gathered data of the in progress test. The
messages collected are printed to the kernel log as well.

Example of output:
	% cat /sys/kernel/debug/dmatest/results
	dma0chan0-copy0: #1: No errors with src_off=0x7bf dst_off=0x8ad len=0x3fea (0)

The message format is unified across the different types of errors. A number in
the parens represents additional information, e.g. error code, error counter,
or status.

Note that the buffer comparison is done in the old way, i.e. data is not
collected and just printed out.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/dmatest.txt |  19 ++++
 drivers/dma/dmatest.c     | 234 ++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 223 insertions(+), 30 deletions(-)

diff --git a/Documentation/dmatest.txt b/Documentation/dmatest.txt
index 3e17b55..d05782b 100644
--- a/Documentation/dmatest.txt
+++ b/Documentation/dmatest.txt
@@ -58,3 +58,22 @@ the above section "Part 2 - When dmatest is built as a module..."
 In both cases the module parameters are used as initial values for the test case.
 You always could check them at run-time by running
 	% grep -H . /sys/module/dmatest/parameters/*
+
+	Part 4 - Gathering the test results
+
+The module provides a storage for the test results in the memory. The gathered
+data could be used after test is done.
+
+The special file 'results' in the debugfs represents gathered data of the in
+progress test. The messages collected are printed to the kernel log as well.
+
+Example of output:
+	% cat /sys/kernel/debug/dmatest/results
+	dma0chan0-copy0: #1: No errors with src_off=0x7bf dst_off=0x8ad len=0x3fea (0)
+
+The message format is unified across the different types of errors. A number in
+the parens represents additional information, e.g. error code, error counter,
+or status.
+
+Note that the buffer comparison is done in the old way, i.e. data is not
+collected and just printed out.
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 4225a29..3697bd4 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -86,6 +86,39 @@ MODULE_PARM_DESC(timeout, "Transfer Timeout in msec (default: 3000), "
 #define PATTERN_OVERWRITE	0x20
 #define PATTERN_COUNT_MASK	0x1f
 
+enum dmatest_error_type {
+	DMATEST_ET_OK,
+	DMATEST_ET_MAP_SRC,
+	DMATEST_ET_MAP_DST,
+	DMATEST_ET_PREP,
+	DMATEST_ET_SUBMIT,
+	DMATEST_ET_TIMEOUT,
+	DMATEST_ET_DMA_ERROR,
+	DMATEST_ET_DMA_IN_PROGRESS,
+	DMATEST_ET_VERIFY,
+};
+
+struct dmatest_thread_result {
+	struct list_head	node;
+	unsigned int		n;
+	unsigned int		src_off;
+	unsigned int		dst_off;
+	unsigned int		len;
+	enum dmatest_error_type	type;
+	union {
+		unsigned long		data;
+		dma_cookie_t		cookie;
+		enum dma_status		status;
+		int			error;
+	};
+};
+
+struct dmatest_result {
+	struct list_head	node;
+	char			*name;
+	struct list_head	results;
+};
+
 struct dmatest_info;
 
 struct dmatest_thread {
@@ -146,6 +179,10 @@ struct dmatest_info {
 	/* debugfs related stuff */
 	struct dentry		*root;
 	struct dmatest_params	dbgfs_params;
+
+	/* Test results */
+	struct list_head	results;
+	struct mutex		results_lock;
 };
 
 static struct dmatest_info test_info;
@@ -303,6 +340,98 @@ static unsigned int min_odd(unsigned int x, unsigned int y)
 	return val % 2 ? val : val - 1;
 }
 
+static char *thread_result_get(const char *name,
+		struct dmatest_thread_result *tr)
+{
+	static const char * const messages[] = {
+		[DMATEST_ET_OK]			= "No errors",
+		[DMATEST_ET_MAP_SRC]		= "src mapping error",
+		[DMATEST_ET_MAP_DST]		= "dst mapping error",
+		[DMATEST_ET_PREP]		= "prep error",
+		[DMATEST_ET_SUBMIT]		= "submit error",
+		[DMATEST_ET_TIMEOUT]		= "test timed out",
+		[DMATEST_ET_DMA_ERROR]		=
+			"got completion callback (DMA_ERROR)",
+		[DMATEST_ET_DMA_IN_PROGRESS]	=
+			"got completion callback (DMA_IN_PROGRESS)",
+		[DMATEST_ET_VERIFY]		= "errors",
+	};
+	static char buf[512];
+
+	snprintf(buf, sizeof(buf) - 1,
+		 "%s: #%u: %s with src_off=0x%x ""dst_off=0x%x len=0x%x (%lu)",
+		 name, tr->n, messages[tr->type], tr->src_off, tr->dst_off,
+		 tr->len, tr->data);
+
+	return buf;
+}
+
+static int thread_result_add(struct dmatest_info *info,
+		struct dmatest_result *r, enum dmatest_error_type type,
+		unsigned int n, unsigned int src_off, unsigned int dst_off,
+		unsigned int len, unsigned long data)
+{
+	struct dmatest_thread_result *tr;
+
+	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
+	if (!tr)
+		return -ENOMEM;
+
+	tr->type = type;
+	tr->n = n;
+	tr->src_off = src_off;
+	tr->dst_off = dst_off;
+	tr->len = len;
+	tr->data = data;
+
+	mutex_lock(&info->results_lock);
+	list_add_tail(&tr->node, &r->results);
+	mutex_unlock(&info->results_lock);
+
+	pr_warn("%s\n", thread_result_get(r->name, tr));
+	return 0;
+}
+
+static void result_free(struct dmatest_info *info, const char *name)
+{
+	struct dmatest_result *r, *_r;
+
+	mutex_lock(&info->results_lock);
+	list_for_each_entry_safe(r, _r, &info->results, node) {
+		struct dmatest_thread_result *tr, *_tr;
+
+		if (name && strcmp(r->name, name))
+			continue;
+
+		list_for_each_entry_safe(tr, _tr, &r->results, node) {
+			list_del(&tr->node);
+			kfree(tr);
+		}
+
+		kfree(r->name);
+		list_del(&r->node);
+		kfree(r);
+	}
+
+	mutex_unlock(&info->results_lock);
+}
+
+static struct dmatest_result *result_init(struct dmatest_info *info,
+		const char *name)
+{
+	struct dmatest_result *r;
+
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (r) {
+		r->name = kstrdup(name, GFP_KERNEL);
+		INIT_LIST_HEAD(&r->results);
+		mutex_lock(&info->results_lock);
+		list_add_tail(&r->node, &info->results);
+		mutex_unlock(&info->results_lock);
+	}
+	return r;
+}
+
 /*
  * This function repeatedly tests DMA transfers of various lengths and
  * offsets for a given operation type until it is told to exit by
@@ -339,6 +468,7 @@ static int dmatest_func(void *data)
 	int			src_cnt;
 	int			dst_cnt;
 	int			i;
+	struct dmatest_result	*result;
 
 	thread_name = current->comm;
 	set_freezable();
@@ -370,6 +500,10 @@ static int dmatest_func(void *data)
 	} else
 		goto err_thread_type;
 
+	result = result_init(info, thread_name);
+	if (!result)
+		goto err_srcs;
+
 	thread->srcs = kcalloc(src_cnt+1, sizeof(u8 *), GFP_KERNEL);
 	if (!thread->srcs)
 		goto err_srcs;
@@ -443,10 +577,10 @@ static int dmatest_func(void *data)
 			ret = dma_mapping_error(dev->dev, dma_srcs[i]);
 			if (ret) {
 				unmap_src(dev->dev, dma_srcs, len, i);
-				pr_warn("%s: #%u: mapping error %d with "
-					"src_off=0x%x len=0x%x\n",
-					thread_name, total_tests - 1, ret,
-					src_off, len);
+				thread_result_add(info, result,
+						  DMATEST_ET_MAP_SRC,
+						  total_tests, src_off, dst_off,
+						  len, ret);
 				failed_tests++;
 				continue;
 			}
@@ -461,10 +595,10 @@ static int dmatest_func(void *data)
 				unmap_src(dev->dev, dma_srcs, len, src_cnt);
 				unmap_dst(dev->dev, dma_dsts, params->buf_size,
 					  i);
-				pr_warn("%s: #%u: mapping error %d with "
-					"dst_off=0x%x len=0x%x\n",
-					thread_name, total_tests - 1, ret,
-					dst_off, params->buf_size);
+				thread_result_add(info, result,
+						  DMATEST_ET_MAP_DST,
+						  total_tests, src_off, dst_off,
+						  len, ret);
 				failed_tests++;
 				continue;
 			}
@@ -494,10 +628,9 @@ static int dmatest_func(void *data)
 			unmap_src(dev->dev, dma_srcs, len, src_cnt);
 			unmap_dst(dev->dev, dma_dsts, params->buf_size,
 				  dst_cnt);
-			pr_warning("%s: #%u: prep error with src_off=0x%x "
-					"dst_off=0x%x len=0x%x\n",
-					thread_name, total_tests - 1,
-					src_off, dst_off, len);
+			thread_result_add(info, result, DMATEST_ET_PREP,
+					  total_tests, src_off, dst_off,
+					  len, 0);
 			msleep(100);
 			failed_tests++;
 			continue;
@@ -509,10 +642,9 @@ static int dmatest_func(void *data)
 		cookie = tx->tx_submit(tx);
 
 		if (dma_submit_error(cookie)) {
-			pr_warning("%s: #%u: submit error %d with src_off=0x%x "
-					"dst_off=0x%x len=0x%x\n",
-					thread_name, total_tests - 1, cookie,
-					src_off, dst_off, len);
+			thread_result_add(info, result, DMATEST_ET_SUBMIT,
+					  total_tests, src_off, dst_off,
+					  len, cookie);
 			msleep(100);
 			failed_tests++;
 			continue;
@@ -534,15 +666,17 @@ static int dmatest_func(void *data)
 			 * free it this time?" dancing.  For now, just
 			 * leave it dangling.
 			 */
-			pr_warning("%s: #%u: test timed out\n",
-				   thread_name, total_tests - 1);
+			thread_result_add(info, result, DMATEST_ET_TIMEOUT,
+					  total_tests, src_off, dst_off,
+					  len, 0);
 			failed_tests++;
 			continue;
 		} else if (status != DMA_SUCCESS) {
-			pr_warning("%s: #%u: got completion callback,"
-				   " but status is \'%s\'\n",
-				   thread_name, total_tests - 1,
-				   status == DMA_ERROR ? "error" : "in progress");
+			enum dmatest_error_type type = (status == DMA_ERROR) ?
+				DMATEST_ET_DMA_ERROR : DMATEST_ET_DMA_IN_PROGRESS;
+			thread_result_add(info, result, type,
+					  total_tests, src_off, dst_off,
+					  len, status);
 			failed_tests++;
 			continue;
 		}
@@ -574,16 +708,14 @@ static int dmatest_func(void *data)
 				PATTERN_DST, false);
 
 		if (error_count) {
-			pr_warning("%s: #%u: %u errors with "
-				"src_off=0x%x dst_off=0x%x len=0x%x\n",
-				thread_name, total_tests - 1, error_count,
-				src_off, dst_off, len);
+			thread_result_add(info, result, DMATEST_ET_VERIFY,
+					  total_tests, src_off, dst_off,
+					  len, error_count);
 			failed_tests++;
 		} else {
-			pr_debug("%s: #%u: No errors with "
-				"src_off=0x%x dst_off=0x%x len=0x%x\n",
-				thread_name, total_tests - 1,
-				src_off, dst_off, len);
+			thread_result_add(info, result, DMATEST_ET_OK,
+					  total_tests, src_off, dst_off,
+					  len, 0);
 		}
 	}
 
@@ -807,6 +939,9 @@ static int __restart_threaded_test(struct dmatest_info *info, bool run)
 	if (run == false)
 		return 0;
 
+	/* Clear results from previous run */
+	result_free(info, NULL);
+
 	/* Copy test parameters */
 	memcpy(params, &info->dbgfs_params, sizeof(*params));
 
@@ -945,6 +1080,35 @@ static const struct file_operations dtf_run_fops = {
 	.llseek	= default_llseek,
 };
 
+static int dtf_results_show(struct seq_file *sf, void *data)
+{
+	struct dmatest_info *info = sf->private;
+	struct dmatest_result *result;
+	struct dmatest_thread_result *tr;
+
+	mutex_lock(&info->results_lock);
+	list_for_each_entry(result, &info->results, node) {
+		list_for_each_entry(tr, &result->results, node)
+			seq_printf(sf, "%s\n",
+				thread_result_get(result->name, tr));
+	}
+
+	mutex_unlock(&info->results_lock);
+	return 0;
+}
+
+static int dtf_results_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dtf_results_show, inode->i_private);
+}
+
+static const struct file_operations dtf_results_fops = {
+	.open		= dtf_results_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int dmatest_register_dbgfs(struct dmatest_info *info)
 {
 	struct dentry *d;
@@ -1015,6 +1179,12 @@ static int dmatest_register_dbgfs(struct dmatest_info *info)
 	if (IS_ERR_OR_NULL(d))
 		goto err_node;
 
+	/* Results of test in progress */
+	d = debugfs_create_file("results", S_IRUGO, info->root, info,
+				&dtf_results_fops);
+	if (IS_ERR_OR_NULL(d))
+		goto err_node;
+
 	return 0;
 
 err_node:
@@ -1035,6 +1205,9 @@ static int __init dmatest_init(void)
 	mutex_init(&info->lock);
 	INIT_LIST_HEAD(&info->channels);
 
+	mutex_init(&info->results_lock);
+	INIT_LIST_HEAD(&info->results);
+
 	/* Set default parameters */
 	params->buf_size = test_buf_size;
 	strlcpy(params->channel, test_channel, sizeof(params->channel));
@@ -1065,6 +1238,7 @@ static void __exit dmatest_exit(void)
 
 	debugfs_remove_recursive(info->root);
 	stop_threaded_test(info);
+	result_free(info, NULL);
 }
 module_exit(dmatest_exit);
 
-- 
1.8.2.rc0.22.gb3600c3

