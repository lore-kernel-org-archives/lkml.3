Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab3EVFdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 01:33:06 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60695 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3EVFdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 01:33:01 -0400
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: zoran.markovic@linaro.org, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        Benoit Goby <benoit@android.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCHv2] power: Add option to log time spent in suspend
Date: Tue, 21 May 2013 22:32:14 -0700
Message-Id: <1369200734-5187-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Below is a patch from android kernel that maintains a histogram of
suspend times. Please review and provide feedback.

Statistices on the time spent in suspend are kept in
/sys/kernel/debug/sleep_time.

Cc: Android Kernel Team <kernel-team@android.com>
Cc: Colin Cross <ccross@android.com>
Cc: Todd Poynor <toddpoynor@google.com>
Cc: San Mehat <san@google.com>
Cc: Benoit Goby <benoit@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
[zoran.markovic@linaro.org: Re-formatted suspend time table to better fit
expected values. Moved accounting of suspend time into timekeeping core.
Removed CONFIG_SUSPEND_TIME flag and made the feature conditional on
CONFIG_DEBUG_FS. Changed the file name to sleep_time to better fit terminology
in timekeeping core. Changed seq_printf to seq_puts. Tweaked commit message]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 kernel/time/Makefile               |    1 +
 kernel/time/timekeeping.c          |    2 +
 kernel/time/timekeeping_debug.c    |   72 ++++++++++++++++++++++++++++++++++++
 kernel/time/timekeeping_internal.h |   14 +++++++
 4 files changed, 89 insertions(+)
 create mode 100644 kernel/time/timekeeping_debug.c
 create mode 100644 kernel/time/timekeeping_internal.h

diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index ff7d9d2..d52ac8b 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
 obj-$(CONFIG_TIMER_STATS)			+= timer_stats.o
+obj-$(CONFIG_DEBUG_FS)				+= timekeeping_debug.o
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index baeeb5c..e7e2f05 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -25,6 +25,7 @@
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
+#include "timekeeping_internal.h"
 
 static struct timekeeper timekeeper;
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
@@ -841,6 +842,7 @@ static void __timekeeping_inject_sleeptime(struct timekeeper *tk,
 	tk_xtime_add(tk, delta);
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *delta));
 	tk_set_sleep_time(tk, timespec_add(tk->total_sleep_time, *delta));
+	tk_debug_account_sleep_time(delta);
 }
 
 /**
diff --git a/kernel/time/timekeeping_debug.c b/kernel/time/timekeeping_debug.c
new file mode 100644
index 0000000..802433a
--- /dev/null
+++ b/kernel/time/timekeeping_debug.c
@@ -0,0 +1,72 @@
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
+#include <linux/time.h>
+
+static unsigned int sleep_time_bin[32] = {0};
+
+static int tk_debug_show_sleep_time(struct seq_file *s, void *data)
+{
+	unsigned int bin;
+	seq_puts(s, "      time (secs)        count\n");
+	seq_puts(s, "------------------------------\n");
+	for (bin = 0; bin < 32; bin++) {
+		if (sleep_time_bin[bin] == 0)
+			continue;
+		seq_printf(s, "%10u - %-10u %4u\n",
+			bin ? 1 << (bin - 1) : 0, 1 << bin,
+				sleep_time_bin[bin]);
+	}
+	return 0;
+}
+
+static int tk_debug_sleep_time_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, tk_debug_show_sleep_time, NULL);
+}
+
+static const struct file_operations tk_debug_sleep_time_fops = {
+	.open		= tk_debug_sleep_time_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init tk_debug_sleep_time_init(void)
+{
+	struct dentry *d;
+
+	d = debugfs_create_file("sleep_time", 0444, NULL, NULL,
+		&tk_debug_sleep_time_fops);
+	if (!d) {
+		pr_err("Failed to create sleep_time debug file\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+late_initcall(tk_debug_sleep_time_init);
+
+void tk_debug_account_sleep_time(struct timespec *t)
+{
+	sleep_time_bin[fls(t->tv_sec)]++;
+}
+
diff --git a/kernel/time/timekeeping_internal.h b/kernel/time/timekeeping_internal.h
new file mode 100644
index 0000000..13323ea
--- /dev/null
+++ b/kernel/time/timekeeping_internal.h
@@ -0,0 +1,14 @@
+#ifndef _TIMEKEEPING_INTERNAL_H
+#define _TIMEKEEPING_INTERNAL_H
+/*
+ * timekeeping debug functions
+ */
+#include <linux/time.h>
+
+#ifdef CONFIG_DEBUG_FS
+extern void tk_debug_account_sleep_time(struct timespec *t);
+#else
+#define tk_debug_account_sleep_time(x)
+#endif
+
+#endif /* _TIMEKEEPING_INTERNAL_H */
-- 
1.7.9.5

