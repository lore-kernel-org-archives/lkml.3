Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877Ab3D3W35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 18:29:57 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62154 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933783Ab3D3W3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 18:29:52 -0400
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        Benoit Goby <benoit@android.com>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>,
        Zoran Markovic <zoran.markovic@linaro.org>
Subject: [RFC PATCH] power: Add option to log time spent in suspend
Date: Tue, 30 Apr 2013 15:28:34 -0700
Message-Id: <1367360914-23389-2-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Below is a patch from android kernel that maintains a histogram of
suspend times. Please review and provide feedback.

Prints the time spent in suspend in the kernel log, and keeps statistics
on the time spent in suspend in /sys/kernel/debug/suspend_time

Cc: Android Kernel Team <kernel-team@android.com>
Cc: Colin Cross <ccross@android.com>
Cc: Todd Poynor <toddpoynor@google.com>
Cc: San Mehat <san@google.com>
Cc: Benoit Goby <benoit@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
[zoran.markovic@linaro.org: Re-formatted suspend time table to better fit
expected values, tweaked commit message]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 kernel/power/Kconfig        |    7 +++
 kernel/power/Makefile       |    1 +
 kernel/power/suspend_time.c |  111 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+)
 create mode 100644 kernel/power/suspend_time.c

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 5dfdc9e..edc8bdd 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -274,3 +274,10 @@ config PM_GENERIC_DOMAINS_RUNTIME
 config CPU_PM
 	bool
 	depends on SUSPEND || CPU_IDLE
+
+config SUSPEND_TIME
+       bool "Log time spent in suspend"
+       ---help---
+         Prints the time spent in suspend in the kernel log, and
+         keeps statistics on the time spent in suspend in
+         /sys/kernel/debug/suspend_time
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 29472bf..578e20e 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -11,5 +11,6 @@ obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
 				   block_io.o
 obj-$(CONFIG_PM_AUTOSLEEP)	+= autosleep.o
 obj-$(CONFIG_PM_WAKELOCKS)	+= wakelock.o
+obj-$(CONFIG_SUSPEND_TIME)     += suspend_time.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
diff --git a/kernel/power/suspend_time.c b/kernel/power/suspend_time.c
new file mode 100644
index 0000000..a613ede
--- /dev/null
+++ b/kernel/power/suspend_time.c
@@ -0,0 +1,111 @@
+/*
+ * debugfs file to track time spent in suspend
+ *
+ * Copyright (c) 2011, Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/seq_file.h>
+#include <linux/syscore_ops.h>
+#include <linux/time.h>
+
+static struct timespec suspend_time_before;
+static unsigned int time_in_suspend_bins[32];
+
+#ifdef CONFIG_DEBUG_FS
+static int suspend_time_debug_show(struct seq_file *s, void *data)
+{
+	unsigned int bin;
+	seq_printf(s, "      time (secs)        count\n");
+	seq_printf(s, "------------------------------\n");
+	for (bin = 0; bin < 32; bin++) {
+		if (time_in_suspend_bins[bin] == 0)
+			continue;
+		seq_printf(s, "%10u - %-10u %4u\n",
+			bin ? 1 << (bin - 1) : 0, 1 << bin,
+				time_in_suspend_bins[bin]);
+	}
+	return 0;
+}
+
+static int suspend_time_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, suspend_time_debug_show, NULL);
+}
+
+static const struct file_operations suspend_time_debug_fops = {
+	.open		= suspend_time_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init suspend_time_debug_init(void)
+{
+	struct dentry *d;
+
+	d = debugfs_create_file("suspend_time", 0444, NULL, NULL,
+		&suspend_time_debug_fops);
+	if (!d) {
+		pr_err("Failed to create suspend_time debug file\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+late_initcall(suspend_time_debug_init);
+#endif
+
+static int suspend_time_syscore_suspend(void)
+{
+	read_persistent_clock(&suspend_time_before);
+
+	return 0;
+}
+
+static void suspend_time_syscore_resume(void)
+{
+	struct timespec after;
+
+	read_persistent_clock(&after);
+
+	after = timespec_sub(after, suspend_time_before);
+
+	time_in_suspend_bins[fls(after.tv_sec)]++;
+
+	pr_info("Suspended for %lu.%03lu seconds\n", after.tv_sec,
+		after.tv_nsec / NSEC_PER_MSEC);
+}
+
+static struct syscore_ops suspend_time_syscore_ops = {
+	.suspend = suspend_time_syscore_suspend,
+	.resume = suspend_time_syscore_resume,
+};
+
+static int suspend_time_syscore_init(void)
+{
+	register_syscore_ops(&suspend_time_syscore_ops);
+
+	return 0;
+}
+
+static void suspend_time_syscore_exit(void)
+{
+	unregister_syscore_ops(&suspend_time_syscore_ops);
+}
+module_init(suspend_time_syscore_init);
+module_exit(suspend_time_syscore_exit);
-- 
1.7.9.5

