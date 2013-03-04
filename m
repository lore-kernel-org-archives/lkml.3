Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3CDJKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:10:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:22479 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab3CDJKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:10:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="293180850"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 06/10] dmatest: run test via debugfs
Date: Mon,  4 Mar 2013 11:09:30 +0200
Message-Id: <1362388174-3435-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of doing
	modprobe dmatest ...
	modprobe -r dmatest
we allow user to run tests interactively.

The dmatest could be built as module or inside kernel. Let's consider those
cases.

1. When dmatest is built as a module...

After mounting debugfs and loading the module, the /sys/kernel/debug/dmatest
folder with nodes will be created. They are the same as module parameters with
addition of the 'run' node that controls run and stop phases of the test.

Note that in this case test will not run on load automatically.

Example of usage:
	% echo dma0chan0 > /sys/kernel/debug/dmatest/channel
	% echo 2000 > /sys/kernel/debug/dmatest/timeout
	% echo 1 > /sys/kernel/debug/dmatest/iterations
	% echo 1 > /sys/kernel/debug/dmatest/run

After a while you will start to get messages about current status or error like
in the original code.

Note that running a new test will stop any in progress test.

2. When built-in in the kernel...

The module parameters that is supplied to the kernel command line will be used
for the first performed test. After user gets a control, the test could be
interrupted or re-run with same or different parameters. For the details see
the above section "1. When dmatest is built as a module..."

In both cases the module parameters are used as initial values for the test case.
You always could check them at run-time by running
	% grep -H . /sys/module/dmatest/parameters/*

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/dmatest.txt |  48 +++++++++
 drivers/dma/dmatest.c     | 257 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 303 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/dmatest.txt

diff --git a/Documentation/dmatest.txt b/Documentation/dmatest.txt
new file mode 100644
index 0000000..9a90729
--- /dev/null
+++ b/Documentation/dmatest.txt
@@ -0,0 +1,48 @@
+				DMA Test Guide
+				==============
+
+		Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+
+This small document introduces how to test DMA drivers using dmatest module.
+
+	Part 1 - How to build the test module
+
+The menuconfig contains an option that could be found by following path:
+	Device Drivers -> DMA Engine support -> DMA Test client
+
+In the configuration file the option called CONFIG_DMATEST. The dmatest could
+be built as module or inside kernel. Let's consider those cases.
+
+	Part 2 - When dmatest is built as a module...
+
+After mounting debugfs and loading the module, the /sys/kernel/debug/dmatest
+folder with nodes will be created. They are the same as module parameters with
+addition of the 'run' node that controls run and stop phases of the test.
+
+Note that in this case test will not run on load automatically.
+
+Example of usage:
+	% echo dma0chan0 > /sys/kernel/debug/dmatest/channel
+	% echo 2000 > /sys/kernel/debug/dmatest/timeout
+	% echo 1 > /sys/kernel/debug/dmatest/iterations
+	% echo 1 > /sys/kernel/debug/dmatest/run
+
+Hint: available channel list could be extracted by running the following
+command:
+	% ls -1 /sys/class/dma/
+
+After a while you will start to get messages about current status or error like
+in the original code.
+
+Note that running a new test will stop any in progress test.
+
+	Part 3 - When built-in in the kernel...
+
+The module parameters that is supplied to the kernel command line will be used
+for the first performed test. After user gets a control, the test could be
+interrupted or re-run with same or different parameters. For the details see
+the above section "Part 2 - When dmatest is built as a module..."
+
+In both cases the module parameters are used as initial values for the test case.
+You always could check them at run-time by running
+	% grep -H . /sys/module/dmatest/parameters/*
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index c6e5d83..fc31542 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -2,6 +2,7 @@
  * DMA Engine test module
  *
  * Copyright (C) 2007 Atmel Corporation
+ * Copyright (C) 2013 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -18,6 +19,10 @@
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
+#include <linux/ctype.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/seq_file.h>
 
 static unsigned int test_buf_size = 16384;
 module_param(test_buf_size, uint, S_IRUGO);
@@ -123,6 +128,7 @@ struct dmatest_params {
 /**
  * struct dmatest_info - test information.
  * @params:		test parameters
+ * @lock:		access protection to the fields of this structure
  */
 struct dmatest_info {
 	/* Test parameters */
@@ -131,6 +137,11 @@ struct dmatest_info {
 	/* Internal state */
 	struct list_head	channels;
 	unsigned int		nr_channels;
+	struct mutex		lock;
+
+	/* debugfs related stuff */
+	struct dentry		*root;
+	struct dmatest_params	dbgfs_params;
 };
 
 static struct dmatest_info test_info;
@@ -718,7 +729,7 @@ static bool filter(struct dma_chan *chan, void *param)
 		return true;
 }
 
-static int run_threaded_test(struct dmatest_info *info)
+static int __run_threaded_test(struct dmatest_info *info)
 {
 	dma_cap_mask_t mask;
 	struct dma_chan *chan;
@@ -744,7 +755,19 @@ static int run_threaded_test(struct dmatest_info *info)
 	return err;
 }
 
-static void stop_threaded_test(struct dmatest_info *info)
+#ifndef MODULE
+static int run_threaded_test(struct dmatest_info *info)
+{
+	int ret;
+
+	mutex_lock(&info->lock);
+	ret = __run_threaded_test(info);
+	mutex_unlock(&info->lock);
+	return ret;
+}
+#endif
+
+static void __stop_threaded_test(struct dmatest_info *info)
 {
 	struct dmatest_chan *dtc, *_dtc;
 	struct dma_chan *chan;
@@ -760,13 +783,234 @@ static void stop_threaded_test(struct dmatest_info *info)
 	info->nr_channels = 0;
 }
 
+static void stop_threaded_test(struct dmatest_info *info)
+{
+	mutex_lock(&info->lock);
+	__stop_threaded_test(info);
+	mutex_unlock(&info->lock);
+}
+
+static int __restart_threaded_test(struct dmatest_info *info, bool run)
+{
+	struct dmatest_params *params = &info->params;
+	int ret;
+
+	/* Stop any running test first */
+	__stop_threaded_test(info);
+
+	if (run == false)
+		return 0;
+
+	/* Copy test parameters */
+	memcpy(params, &info->dbgfs_params, sizeof(*params));
+
+	/* Run test with new parameters */
+	ret = __run_threaded_test(info);
+	if (ret) {
+		__stop_threaded_test(info);
+		pr_err("dmatest: Can't run test\n");
+	}
+
+	return ret;
+}
+
+static ssize_t dtf_write_string(void *to, size_t available, loff_t *ppos,
+		const void __user *from, size_t count)
+{
+	char tmp[20];
+	ssize_t len;
+
+	len = simple_write_to_buffer(tmp, sizeof(tmp) - 1, ppos, from, count);
+	if (len >= 0) {
+		tmp[len] = '\0';
+		strlcpy(to, strim(tmp), available);
+	}
+
+	return len;
+}
+
+static ssize_t dtf_read_channel(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct dmatest_info *info = file->private_data;
+	return simple_read_from_buffer(buf, count, ppos,
+			info->dbgfs_params.channel,
+			strlen(info->dbgfs_params.channel));
+}
+
+static ssize_t dtf_write_channel(struct file *file, const char __user *buf,
+		size_t size, loff_t *ppos)
+{
+	struct dmatest_info *info = file->private_data;
+	return dtf_write_string(info->dbgfs_params.channel,
+				sizeof(info->dbgfs_params.channel),
+				ppos, buf, size);
+}
+
+static const struct file_operations dtf_channel_fops = {
+	.read	= dtf_read_channel,
+	.write	= dtf_write_channel,
+	.open	= simple_open,
+	.llseek	= default_llseek,
+};
+
+static ssize_t dtf_read_device(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct dmatest_info *info = file->private_data;
+	return simple_read_from_buffer(buf, count, ppos,
+			info->dbgfs_params.device,
+			strlen(info->dbgfs_params.device));
+}
+
+static ssize_t dtf_write_device(struct file *file, const char __user *buf,
+		size_t size, loff_t *ppos)
+{
+	struct dmatest_info *info = file->private_data;
+	return dtf_write_string(info->dbgfs_params.device,
+				sizeof(info->dbgfs_params.device),
+				ppos, buf, size);
+}
+
+static const struct file_operations dtf_device_fops = {
+	.read	= dtf_read_device,
+	.write	= dtf_write_device,
+	.open	= simple_open,
+	.llseek	= default_llseek,
+};
+
+static ssize_t dtf_read_run(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	struct dmatest_info *info = file->private_data;
+	char buf[3];
+
+	mutex_lock(&info->lock);
+	if (info->nr_channels)
+		buf[0] = 'Y';
+	else
+		buf[0] = 'N';
+	mutex_unlock(&info->lock);
+	buf[1] = '\n';
+	buf[2] = 0x00;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t dtf_write_run(struct file *file, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	struct dmatest_info *info = file->private_data;
+	char buf[16];
+	bool bv;
+	int ret = 0;
+
+	if (copy_from_user(buf, user_buf, min(count, (sizeof(buf) - 1))))
+		return -EFAULT;
+
+	if (strtobool(buf, &bv) == 0) {
+		mutex_lock(&info->lock);
+		ret = __restart_threaded_test(info, bv);
+		mutex_unlock(&info->lock);
+	}
+
+	return ret ? ret : count;
+}
+
+static const struct file_operations dtf_run_fops = {
+	.read	= dtf_read_run,
+	.write	= dtf_write_run,
+	.open	= simple_open,
+	.llseek	= default_llseek,
+};
+
+static int dmatest_register_dbgfs(struct dmatest_info *info)
+{
+	struct dentry *d;
+	struct dmatest_params *params = &info->dbgfs_params;
+	int ret = -ENOMEM;
+
+	d = debugfs_create_dir("dmatest", NULL);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+	if (!d)
+		goto err_root;
+
+	info->root = d;
+
+	/* Copy initial values */
+	memcpy(params, &info->params, sizeof(*params));
+
+	/* Test parameters */
+
+	d = debugfs_create_u32("test_buf_size", S_IWUSR | S_IRUGO, info->root,
+			       (u32 *)&params->buf_size);
+	if (IS_ERR_OR_NULL(d))
+		goto err_node;
+
+	d = debugfs_create_file("channel", S_IRUGO | S_IWUSR, info->root,
+				info, &dtf_channel_fops);
+	if (IS_ERR_OR_NULL(d))
+		goto err_node;
+
+	d = debugfs_create_file("device", S_IRUGO | S_IWUSR, info->root,
+				info, &dtf_device_fops);
+	if (IS_ERR_OR_NULL(d))
+		goto err_node;
+
+	d = debugfs_create_u32("threads_per_chan", S_IWUSR | S_IRUGO, info->root,
+			       (u32 *)&params->threads_per_chan);
+	if (IS_ERR_OR_NULL(d))
+		goto err_node;
+
+	d = debugfs_create_u32("max_channels", S_IWUSR | S_IRUGO, info->root,
+			       (u32 *)&params->max_channels);
+	if (IS_ERR_OR_NULL(d))
+		goto err_node;
+
+	d = debugfs_create_u32("iterations", S_IWUSR | S_IRUGO, info->root,
+			       (u32 *)&params->iterations);
+	if (IS_ERR_OR_NULL(d))
+		goto err_node;
+
+	d = debugfs_create_u32("xor_sources", S_IWUSR | S_IRUGO, info->root,
+			       (u32 *)&params->xor_sources);
+	if (IS_ERR_OR_NULL(d))
+		goto err_node;
+
+	d = debugfs_create_u32("pq_sources", S_IWUSR | S_IRUGO, info->root,
+			       (u32 *)&params->pq_sources);
+	if (IS_ERR_OR_NULL(d))
+		goto err_node;
+
+	d = debugfs_create_u32("timeout", S_IWUSR | S_IRUGO, info->root,
+			       (u32 *)&params->timeout);
+	if (IS_ERR_OR_NULL(d))
+		goto err_node;
+
+	/* Run or stop threaded test */
+	d = debugfs_create_file("run", S_IWUSR | S_IRUGO, info->root,
+				info, &dtf_run_fops);
+	if (IS_ERR_OR_NULL(d))
+		goto err_node;
+
+	return 0;
+
+err_node:
+	debugfs_remove_recursive(info->root);
+err_root:
+	pr_err("dmatest: Failed to initialize debugfs\n");
+	return ret;
+}
+
 static int __init dmatest_init(void)
 {
 	struct dmatest_info *info = &test_info;
 	struct dmatest_params *params = &info->params;
+	int ret;
 
 	memset(info, 0, sizeof(*info));
 
+	mutex_init(&info->lock);
 	INIT_LIST_HEAD(&info->channels);
 
 	/* Set default parameters */
@@ -780,7 +1024,15 @@ static int __init dmatest_init(void)
 	params->pq_sources = pq_sources;
 	params->timeout = timeout;
 
+	ret = dmatest_register_dbgfs(info);
+	if (ret)
+		return ret;
+
+#ifdef MODULE
+	return 0;
+#else
 	return run_threaded_test(info);
+#endif
 }
 /* when compiled-in wait for drivers to load first */
 late_initcall(dmatest_init);
@@ -789,6 +1041,7 @@ static void __exit dmatest_exit(void)
 {
 	struct dmatest_info *info = &test_info;
 
+	debugfs_remove_recursive(info->root);
 	stop_threaded_test(info);
 }
 module_exit(dmatest_exit);
-- 
1.8.2.rc0.22.gb3600c3

