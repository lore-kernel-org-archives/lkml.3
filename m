Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab3GWPhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:37:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:32904 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148Ab3GWPhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:37:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,728,1367996400"; 
   d="scan'208";a="272111692"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        "Blin, Jerome" <jerome.blin@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/3] dmatest: make module parameters writable
Date: Tue, 23 Jul 2013 18:36:46 +0300
Message-Id: <1374593808-32475-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debugfs interface brought a copy of the test case parameters. This makes
different set of values under /sys/module/dmatest/parameters/ and
/sys/kernel/debug/dmatest/. The user might be confused by the divergence of
values.

The proposed solution in this patch is to make module parameters writable and
remove them from the debugfs. Though we're still using debugfs to control test
runner and getting results.

Documentation part is updated accordingly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Dan Williams <djbw@fb.com>
---
 Documentation/dmatest.txt |  15 +++--
 drivers/dma/dmatest.c     | 159 ++++++----------------------------------------
 2 files changed, 28 insertions(+), 146 deletions(-)

diff --git a/Documentation/dmatest.txt b/Documentation/dmatest.txt
index 132a094..a2b5663 100644
--- a/Documentation/dmatest.txt
+++ b/Documentation/dmatest.txt
@@ -16,15 +16,16 @@ be built as module or inside kernel. Let's consider those cases.
 	Part 2 - When dmatest is built as a module...
 
 After mounting debugfs and loading the module, the /sys/kernel/debug/dmatest
-folder with nodes will be created. They are the same as module parameters with
-addition of the 'run' node that controls run and stop phases of the test.
+folder with nodes will be created. There are two important files located. First
+is the 'run' node that controls run and stop phases of the test, and the second
+one, 'results', is used to get the test case results.
 
 Note that in this case test will not run on load automatically.
 
 Example of usage:
-	% echo dma0chan0 > /sys/kernel/debug/dmatest/channel
-	% echo 2000 > /sys/kernel/debug/dmatest/timeout
-	% echo 1 > /sys/kernel/debug/dmatest/iterations
+	% echo dma0chan0 > /sys/module/dmatest/parameters/channel
+	% echo 2000 > /sys/module/dmatest/parameters/timeout
+	% echo 1 > /sys/module/dmatest/parameters/iterations
 	% echo 1 > /sys/kernel/debug/dmatest/run
 
 Hint: available channel list could be extracted by running the following
@@ -55,8 +56,8 @@ for the first performed test. After user gets a control, the test could be
 re-run with the same or different parameters. For the details see the above
 section "Part 2 - When dmatest is built as a module..."
 
-In both cases the module parameters are used as initial values for the test case.
-You always could check them at run-time by running
+In both cases the module parameters are used as the actual values for the test
+case. You always could check them at run-time by running
 	% grep -H . /sys/module/dmatest/parameters/*
 
 	Part 4 - Gathering the test results
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index e88ded2..91716f4 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -25,44 +25,46 @@
 #include <linux/seq_file.h>
 
 static unsigned int test_buf_size = 16384;
-module_param(test_buf_size, uint, S_IRUGO);
+module_param(test_buf_size, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(test_buf_size, "Size of the memcpy test buffer");
 
 static char test_channel[20];
-module_param_string(channel, test_channel, sizeof(test_channel), S_IRUGO);
+module_param_string(channel, test_channel, sizeof(test_channel),
+		S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(channel, "Bus ID of the channel to test (default: any)");
 
 static char test_device[20];
-module_param_string(device, test_device, sizeof(test_device), S_IRUGO);
+module_param_string(device, test_device, sizeof(test_device),
+		S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(device, "Bus ID of the DMA Engine to test (default: any)");
 
 static unsigned int threads_per_chan = 1;
-module_param(threads_per_chan, uint, S_IRUGO);
+module_param(threads_per_chan, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(threads_per_chan,
 		"Number of threads to start per channel (default: 1)");
 
 static unsigned int max_channels;
-module_param(max_channels, uint, S_IRUGO);
+module_param(max_channels, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(max_channels,
 		"Maximum number of channels to use (default: all)");
 
 static unsigned int iterations;
-module_param(iterations, uint, S_IRUGO);
+module_param(iterations, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(iterations,
 		"Iterations before stopping test (default: infinite)");
 
 static unsigned int xor_sources = 3;
-module_param(xor_sources, uint, S_IRUGO);
+module_param(xor_sources, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(xor_sources,
 		"Number of xor source buffers (default: 3)");
 
 static unsigned int pq_sources = 3;
-module_param(pq_sources, uint, S_IRUGO);
+module_param(pq_sources, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(pq_sources,
 		"Number of p+q source buffers (default: 3)");
 
 static int timeout = 3000;
-module_param(timeout, uint, S_IRUGO);
+module_param(timeout, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(timeout, "Transfer Timeout in msec (default: 3000), "
 		 "Pass -1 for infinite timeout");
 
@@ -193,7 +195,6 @@ struct dmatest_info {
 
 	/* debugfs related stuff */
 	struct dentry		*root;
-	struct dmatest_params	dbgfs_params;
 
 	/* Test results */
 	struct list_head	results;
@@ -1007,7 +1008,15 @@ static int __restart_threaded_test(struct dmatest_info *info, bool run)
 	result_free(info, NULL);
 
 	/* Copy test parameters */
-	memcpy(params, &info->dbgfs_params, sizeof(*params));
+	params->buf_size = test_buf_size;
+	strlcpy(params->channel, strim(test_channel), sizeof(params->channel));
+	strlcpy(params->device, strim(test_device), sizeof(params->device));
+	params->threads_per_chan = threads_per_chan;
+	params->max_channels = max_channels;
+	params->iterations = iterations;
+	params->xor_sources = xor_sources;
+	params->pq_sources = pq_sources;
+	params->timeout = timeout;
 
 	/* Run test with new parameters */
 	return __run_threaded_test(info);
@@ -1029,71 +1038,6 @@ static bool __is_threaded_test_run(struct dmatest_info *info)
 	return false;
 }
 
-static ssize_t dtf_write_string(void *to, size_t available, loff_t *ppos,
-		const void __user *from, size_t count)
-{
-	char tmp[20];
-	ssize_t len;
-
-	len = simple_write_to_buffer(tmp, sizeof(tmp) - 1, ppos, from, count);
-	if (len >= 0) {
-		tmp[len] = '\0';
-		strlcpy(to, strim(tmp), available);
-	}
-
-	return len;
-}
-
-static ssize_t dtf_read_channel(struct file *file, char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct dmatest_info *info = file->private_data;
-	return simple_read_from_buffer(buf, count, ppos,
-			info->dbgfs_params.channel,
-			strlen(info->dbgfs_params.channel));
-}
-
-static ssize_t dtf_write_channel(struct file *file, const char __user *buf,
-		size_t size, loff_t *ppos)
-{
-	struct dmatest_info *info = file->private_data;
-	return dtf_write_string(info->dbgfs_params.channel,
-				sizeof(info->dbgfs_params.channel),
-				ppos, buf, size);
-}
-
-static const struct file_operations dtf_channel_fops = {
-	.read	= dtf_read_channel,
-	.write	= dtf_write_channel,
-	.open	= simple_open,
-	.llseek	= default_llseek,
-};
-
-static ssize_t dtf_read_device(struct file *file, char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct dmatest_info *info = file->private_data;
-	return simple_read_from_buffer(buf, count, ppos,
-			info->dbgfs_params.device,
-			strlen(info->dbgfs_params.device));
-}
-
-static ssize_t dtf_write_device(struct file *file, const char __user *buf,
-		size_t size, loff_t *ppos)
-{
-	struct dmatest_info *info = file->private_data;
-	return dtf_write_string(info->dbgfs_params.device,
-				sizeof(info->dbgfs_params.device),
-				ppos, buf, size);
-}
-
-static const struct file_operations dtf_device_fops = {
-	.read	= dtf_read_device,
-	.write	= dtf_write_device,
-	.open	= simple_open,
-	.llseek	= default_llseek,
-};
-
 static ssize_t dtf_read_run(struct file *file, char __user *user_buf,
 		size_t count, loff_t *ppos)
 {
@@ -1187,7 +1131,6 @@ static const struct file_operations dtf_results_fops = {
 static int dmatest_register_dbgfs(struct dmatest_info *info)
 {
 	struct dentry *d;
-	struct dmatest_params *params = &info->dbgfs_params;
 	int ret = -ENOMEM;
 
 	d = debugfs_create_dir("dmatest", NULL);
@@ -1198,56 +1141,6 @@ static int dmatest_register_dbgfs(struct dmatest_info *info)
 
 	info->root = d;
 
-	/* Copy initial values */
-	memcpy(params, &info->params, sizeof(*params));
-
-	/* Test parameters */
-
-	d = debugfs_create_u32("test_buf_size", S_IWUSR | S_IRUGO, info->root,
-			       (u32 *)&params->buf_size);
-	if (IS_ERR_OR_NULL(d))
-		goto err_node;
-
-	d = debugfs_create_file("channel", S_IRUGO | S_IWUSR, info->root,
-				info, &dtf_channel_fops);
-	if (IS_ERR_OR_NULL(d))
-		goto err_node;
-
-	d = debugfs_create_file("device", S_IRUGO | S_IWUSR, info->root,
-				info, &dtf_device_fops);
-	if (IS_ERR_OR_NULL(d))
-		goto err_node;
-
-	d = debugfs_create_u32("threads_per_chan", S_IWUSR | S_IRUGO, info->root,
-			       (u32 *)&params->threads_per_chan);
-	if (IS_ERR_OR_NULL(d))
-		goto err_node;
-
-	d = debugfs_create_u32("max_channels", S_IWUSR | S_IRUGO, info->root,
-			       (u32 *)&params->max_channels);
-	if (IS_ERR_OR_NULL(d))
-		goto err_node;
-
-	d = debugfs_create_u32("iterations", S_IWUSR | S_IRUGO, info->root,
-			       (u32 *)&params->iterations);
-	if (IS_ERR_OR_NULL(d))
-		goto err_node;
-
-	d = debugfs_create_u32("xor_sources", S_IWUSR | S_IRUGO, info->root,
-			       (u32 *)&params->xor_sources);
-	if (IS_ERR_OR_NULL(d))
-		goto err_node;
-
-	d = debugfs_create_u32("pq_sources", S_IWUSR | S_IRUGO, info->root,
-			       (u32 *)&params->pq_sources);
-	if (IS_ERR_OR_NULL(d))
-		goto err_node;
-
-	d = debugfs_create_u32("timeout", S_IWUSR | S_IRUGO, info->root,
-			       (u32 *)&params->timeout);
-	if (IS_ERR_OR_NULL(d))
-		goto err_node;
-
 	/* Run or stop threaded test */
 	d = debugfs_create_file("run", S_IWUSR | S_IRUGO, info->root,
 				info, &dtf_run_fops);
@@ -1272,7 +1165,6 @@ err_root:
 static int __init dmatest_init(void)
 {
 	struct dmatest_info *info = &test_info;
-	struct dmatest_params *params = &info->params;
 	int ret;
 
 	memset(info, 0, sizeof(*info));
@@ -1283,17 +1175,6 @@ static int __init dmatest_init(void)
 	mutex_init(&info->results_lock);
 	INIT_LIST_HEAD(&info->results);
 
-	/* Set default parameters */
-	params->buf_size = test_buf_size;
-	strlcpy(params->channel, test_channel, sizeof(params->channel));
-	strlcpy(params->device, test_device, sizeof(params->device));
-	params->threads_per_chan = threads_per_chan;
-	params->max_channels = max_channels;
-	params->iterations = iterations;
-	params->xor_sources = xor_sources;
-	params->pq_sources = pq_sources;
-	params->timeout = timeout;
-
 	ret = dmatest_register_dbgfs(info);
 	if (ret)
 		return ret;
-- 
1.8.3.2

