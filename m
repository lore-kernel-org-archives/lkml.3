Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbaFPV64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:58:56 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44975 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbaFPV6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:58:51 -0400
From: David Riley <davidriley@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
        David Riley <davidriley@chromium.org>
Subject: [PATCH v4 1/2] kernel: time: Add udelay_test module to validate udelay
Date: Mon, 16 Jun 2014 14:58:32 -0700
Message-Id: <1402955913-25036-2-git-send-email-davidriley@chromium.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402955913-25036-1-git-send-email-davidriley@chromium.org>
References: <1402955913-25036-1-git-send-email-davidriley@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a module that allows udelay() to be executed to ensure that
it is delaying at least as long as requested (with a little bit of
error allowed).

There are some configurations which don't have reliably udelay
due to using a loop delay with cpufreq changes which should use
a counter time based delay instead.  This test aims to identify
those configurations where timing is unreliable.

Signed-off-by: David Riley <davidriley@chromium.org>
---
 kernel/time/Makefile      |   1 +
 kernel/time/udelay_test.c | 168 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug         |   9 +++
 3 files changed, 178 insertions(+)
 create mode 100644 kernel/time/udelay_test.c

diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index 57a413f..5b2dc10 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
 obj-$(CONFIG_TIMER_STATS)			+= timer_stats.o
 obj-$(CONFIG_DEBUG_FS)				+= timekeeping_debug.o
+obj-$(CONFIG_TEST_UDELAY)			+= udelay_test.o
diff --git a/kernel/time/udelay_test.c b/kernel/time/udelay_test.c
new file mode 100644
index 0000000..e622ba3
--- /dev/null
+++ b/kernel/time/udelay_test.c
@@ -0,0 +1,168 @@
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
+static int udelay_test_single(struct seq_file *s, int usecs, uint32_t iters)
+{
+	int min = 0, max = 0, fail_count = 0;
+	uint64_t sum = 0;
+	uint64_t avg;
+	int i;
+	/* Allow udelay to be up to 0.5% fast */
+	int allowed_error_ns = usecs * 5;
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
+		if ((time_passed + allowed_error_ns) / 1000 < usecs)
+			++fail_count;
+		WARN_ON(time_passed < 0);
+		sum += time_passed;
+	}
+
+	avg = sum;
+	do_div(avg, iters);
+	seq_printf(s, "%d usecs x %d: exp=%d allowed=%d min=%d avg=%lld max=%d",
+			usecs, iters, usecs * 1000,
+			(usecs * 1000) - allowed_error_ns, min, avg, max);
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
+	if (usecs > 0 && iters > 0) {
+		return udelay_test_single(s, usecs, iters);
+	} else if (usecs == 0) {
+		struct timespec ts;
+
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
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ccca322..d15a2a1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1635,6 +1635,15 @@ config TEST_USER_COPY
 
 	  If unsure, say N.
 
+config TEST_UDELAY
+	tristate "udelay test driver"
+	default n
+	help
+	  This builds the "udelay_test" module that helps to make sure
+	  that udelay() is working properly.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
-- 
2.0.0

