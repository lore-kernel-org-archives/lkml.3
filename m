Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaEGAMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 20:12:46 -0400
Received: from mail-pa0-f66.google.com ([209.85.220.66]:45348 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaEGAMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 20:12:42 -0400
From: David Riley <davidriley@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
        David Riley <davidriley@chromium.org>
Subject: [PATCH 1/2] kernel: time: Add udelay_test module to validate udelay
Date: Tue,  6 May 2014 17:12:22 -0700
Message-Id: <1399421543-7751-2-git-send-email-davidriley@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
References: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a module that allows udelay() to be executed to ensure that
it is delaying at least as long as requested.

Signed-off-by: David Riley <davidriley@chromium.org>
Reviewed-on: https://chromium-review.googlesource.com/194223
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
 kernel/time/Kconfig       |    7 ++
 kernel/time/Makefile      |    1 +
 kernel/time/udelay_test.c |  166 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 174 insertions(+)
 create mode 100644 kernel/time/udelay_test.c

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index f448513..c6af048 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -202,3 +202,10 @@ config HIGH_RES_TIMERS
 
 endmenu
 endif
+
+config UDELAY_TEST
+	tristate "udelay test driver"
+	default n
+	help
+	  This builds the "udelay_test" module that helps to make sure
+	  that udelay() is working properly.
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index 57a413f..dca9175 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
 obj-$(CONFIG_TIMER_STATS)			+= timer_stats.o
 obj-$(CONFIG_DEBUG_FS)				+= timekeeping_debug.o
+obj-$(CONFIG_UDELAY_TEST)			+= udelay_test.o
diff --git a/kernel/time/udelay_test.c b/kernel/time/udelay_test.c
new file mode 100644
index 0000000..c0eccef
--- /dev/null
+++ b/kernel/time/udelay_test.c
@@ -0,0 +1,166 @@
+/*
+ * udelay() test kernel module
+ *
+ * Test is executed by writing and reading to /sys/kernel/debug/udelay_test
+ * Tests are configured by writing: USECS ITERATIONS
+ * Tests are executed by reading from the same file.
+ * Specifying usecs of 0 or negative values will run multiples tests.
+ *
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/ktime.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+#define DEFAULT_ITERATIONS 100
+
+#define DEBUGFS_FILENAME "udelay_test"
+
+static DEFINE_MUTEX(udelay_test_lock);
+static struct dentry *udelay_test_debugfs_file;
+static int udelay_test_usecs;
+static int udelay_test_iterations = DEFAULT_ITERATIONS;
+
+static int udelay_test_single(struct seq_file *s, int usecs, int iters)
+{
+	int min = 0, max = 0, fail_count = 0;
+	long long sum = 0;
+	long long avg;
+	int i;
+
+	if (iters <= 0)
+		return 0;
+
+	for (i = 0; i < iters; ++i) {
+		struct timespec ts1, ts2;
+		int time_passed;
+
+		ktime_get_ts(&ts1);
+		udelay(usecs);
+		ktime_get_ts(&ts2);
+		time_passed = timespec_to_ns(&ts2) - timespec_to_ns(&ts1);
+
+		if (i == 0 || time_passed < min)
+			min = time_passed;
+		if (i == 0 || time_passed > max)
+			max = time_passed;
+		if (time_passed / 1000 < usecs)
+			++fail_count;
+		sum += time_passed;
+	}
+
+	avg = sum;
+	do_div(avg, iters);
+	seq_printf(s, "%d usecs x %d: exp=%d min=%d avg=%lld max=%d", usecs,
+			iters, usecs * 1000, min, avg, max);
+	if (fail_count)
+		seq_printf(s, " FAIL=%d", fail_count);
+	seq_puts(s, "\n");
+
+	return 0;
+}
+
+static int udelay_test_show(struct seq_file *s, void *v)
+{
+	int usecs;
+	int iters;
+	int ret = 0;
+
+	mutex_lock(&udelay_test_lock);
+	usecs = udelay_test_usecs;
+	iters = udelay_test_iterations;
+	mutex_unlock(&udelay_test_lock);
+
+	if (usecs > 0) {
+		return udelay_test_single(s, usecs, iters);
+	} else if (usecs == 0) {
+		struct timespec ts;
+		ktime_get_ts(&ts);
+		seq_printf(s, "udelay() test (lpj=%ld kt=%ld.%09ld)\n",
+				loops_per_jiffy, ts.tv_sec, ts.tv_nsec);
+		seq_puts(s, "usage:\n");
+		seq_puts(s, "echo USECS [ITERS] > " DEBUGFS_FILENAME "\n");
+		seq_puts(s, "cat " DEBUGFS_FILENAME "\n");
+	}
+
+	return ret;
+}
+
+static int udelay_test_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, udelay_test_show, inode->i_private);
+}
+
+static ssize_t udelay_test_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *pos)
+{
+	char lbuf[32];
+	int ret;
+	int usecs;
+	int iters;
+
+	if (count >= sizeof(lbuf))
+		return -EINVAL;
+
+	if (copy_from_user(lbuf, buf, count))
+		return -EFAULT;
+	lbuf[count] = '\0';
+
+	ret = sscanf(lbuf, "%d %d", &usecs, &iters);
+	if (ret < 1)
+		return -EINVAL;
+	else if (ret < 2)
+		iters = DEFAULT_ITERATIONS;
+
+	mutex_lock(&udelay_test_lock);
+	udelay_test_usecs = usecs;
+	udelay_test_iterations = iters;
+	mutex_unlock(&udelay_test_lock);
+
+	return count;
+}
+
+static const struct file_operations udelay_test_debugfs_ops = {
+	.owner = THIS_MODULE,
+	.open = udelay_test_open,
+	.read = seq_read,
+	.write = udelay_test_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int __init udelay_test_init(void)
+{
+	mutex_lock(&udelay_test_lock);
+	udelay_test_debugfs_file = debugfs_create_file(DEBUGFS_FILENAME,
+			S_IRUSR, NULL, NULL, &udelay_test_debugfs_ops);
+	mutex_unlock(&udelay_test_lock);
+
+	return 0;
+}
+
+module_init(udelay_test_init);
+
+static void __exit udelay_test_exit(void)
+{
+	mutex_lock(&udelay_test_lock);
+	debugfs_remove(udelay_test_debugfs_file);
+	mutex_unlock(&udelay_test_lock);
+}
+
+module_exit(udelay_test_exit);
+
+MODULE_AUTHOR("David Riley <davidriley@chromium.org>");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

