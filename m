Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab3LGAkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:40:12 -0500
Received: from mail-oa0-f74.google.com ([209.85.219.74]:39224 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3LGAkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:40:09 -0500
From: Sonny Rao <sonnyrao@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Stephane Eranian <eranian@google.com>,
        Josh Triplett <josh.triplett@intel.com>,
        Pawel Moll <pawell.moll@arm.com>, Olof Johansson <olof@lixom.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: [RFC PATCH] drivers: char: Add a dynamic clock for the trace clock
Date: Fri,  6 Dec 2013 16:34:11 -0800
Message-Id: <1386376451-24593-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on a suggestion from John Stultz.

This adds a dynamic clock device which can be used with clock_gettime
to sample the clock source used for time stamping trace events in the
kernel.  The only use for this clock source is to associate user space
events with kernel events on a given kernel.  It is explicitly not
supposed to be used as a generic time source and won't necessarily be
consistent between kernels.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
 drivers/char/Kconfig       |  8 ++++
 drivers/char/Makefile      |  1 +
 drivers/char/trace_clock.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kernel.h     | 12 ++++++
 kernel/trace/trace.c       | 23 +++++++++++
 5 files changed, 143 insertions(+)
 create mode 100644 drivers/char/trace_clock.c

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index fa3243d..785ab73 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -599,5 +599,13 @@ config TILE_SROM
 	  device appear much like a simple EEPROM, and knows
 	  how to partition a single ROM for multiple purposes.
 
+config TRACE_CLOCK_DEV
+	tristate "Dynamic clock type which gives time used for ftrace events"
+	depends on TRACING
+	default y
+	help
+	  This device presents a posix dynamic clock which allows user
+	  space to sample the clock used for time stamps on trace events
+	  in the kernel.
 endmenu
 
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index a324f93..5cd42e0 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -61,3 +61,4 @@ obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
 
 obj-$(CONFIG_TILE_SROM)		+= tile-srom.o
+obj-$(CONFIG_TRACE_CLOCK_DEV)	+= trace_clock.o
diff --git a/drivers/char/trace_clock.c b/drivers/char/trace_clock.c
new file mode 100644
index 0000000..d73b35d
--- /dev/null
+++ b/drivers/char/trace_clock.c
@@ -0,0 +1,99 @@
+/*
+ * Copyright (C) 2013 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *                    All Rights Reserved.
+ *
+ * This file is released under the GPL.
+ *
+ * Posix Dynamic Clock for tracing clock.
+ *
+ * This device is meant to provide a stream which userspace can sample
+ * to match up kernel generated events to user generated events, on a
+ * given kernel.  It  * is explicitly *not* trying to be a standalone
+ * time source and shouldn't be used for anything else or for
+ * comparisons between different kernels.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/posix-clock.h>
+
+static dev_t tc_devt;
+static struct class *tc_class;
+static struct device *tc_dev;
+static struct posix_clock tc_pclock;
+
+static int tc_clock_gettime(struct posix_clock *pc, struct timespec *ts)
+{
+	trace_clock_gettime(ts);
+	return 0;
+}
+
+static int tc_clock_getres(struct posix_clock *pc, struct timespec *ts)
+{
+	trace_clock_getres(ts);
+	return 0;
+}
+
+static struct posix_clock_operations tc_clock_ops = {
+	.owner		= THIS_MODULE,
+	.clock_gettime	= tc_clock_gettime,
+	.clock_getres	= tc_clock_getres,
+};
+
+static void __exit trace_clock_exit(void)
+{
+	posix_clock_unregister(&tc_pclock);
+	device_destroy(tc_class, tc_devt);
+	unregister_chrdev_region(tc_devt, 1);
+	class_destroy(tc_class);
+}
+
+static int __init trace_clock_init(void)
+{
+	int err = -ENODEV;
+
+	tc_class = class_create(THIS_MODULE, "trace_clock");
+	if (IS_ERR(tc_class)) {
+		pr_err("trace_clock: failed to allocate class\n");
+		return PTR_ERR(tc_class);
+	}
+
+	err = alloc_chrdev_region(&tc_devt, 0, 1, "trace_clock");
+	if (err < 0) {
+		pr_err("trace_clock: failed to allocate device region\n");
+		goto no_region;
+	}
+	tc_dev = device_create(tc_class, NULL, tc_devt, NULL, "trace_clock");
+	if (!tc_dev) {
+		pr_err("trace_clock: failed to create device\n");
+		goto no_device;
+	}
+
+	tc_pclock.ops = tc_clock_ops;
+
+	err = posix_clock_register(&tc_pclock, tc_devt);
+	if (err < 0) {
+		pr_err("trace_clock: failed to register posix clock %d\n",
+		       err);
+		goto no_pclock;
+	}
+	pr_info("Trace clock support registered\n");
+	return 0;
+
+no_pclock:
+	device_destroy(tc_class, tc_devt);
+
+no_device:
+	unregister_chrdev_region(tc_devt, 1);
+
+no_region:
+	class_destroy(tc_class);
+	return err;
+}
+
+subsys_initcall(trace_clock_init);
+module_exit(trace_clock_exit);
+
+MODULE_AUTHOR("Sonny Rao <sonnyrao@chromium.org>");
+MODULE_DESCRIPTION("Trace clock device support");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2ac0277..68a922a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -510,6 +510,9 @@ void tracing_snapshot_alloc(void);
 
 extern void tracing_start(void);
 extern void tracing_stop(void);
+struct timespec;
+extern void trace_clock_gettime(struct timespec *);
+extern void trace_clock_getres(struct timespec *);
 
 static inline __printf(1, 2)
 void ____trace_printk_check_format(const char *fmt, ...)
@@ -648,6 +651,15 @@ extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void trace_dump_stack(int skip) { }
+struct timespec;
+static inline void trace_clock_gettime(struct timespec *tp)
+{
+	getrawmonotonic(tp);
+}
+static inline void trace_clock_getres(struct timespec *tp)
+{
+	*tp = ktime_to_timespec(KTIME_LOW_RES);
+}
 
 static inline void tracing_on(void) { }
 static inline void tracing_off(void) { }
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9d20cd9..f30420a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -282,6 +282,29 @@ cycle_t ftrace_now(int cpu)
 	return buffer_ftrace_now(&global_trace.trace_buffer, cpu);
 }
 
+/*
+ * Interface used by trace clock device.
+ */
+void trace_clock_getres(struct timespec *tp)
+{
+	*tp = ktime_to_timespec(KTIME_LOW_RES);
+}
+EXPORT_SYMBOL_GPL(trace_clock_getres);
+
+/*
+ * Interface used by trace clock device.
+ */
+void trace_clock_gettime(struct timespec *tp)
+{
+	u64 now;
+	u32 rem;
+
+	now = ftrace_now(raw_smp_processor_id());
+	tp->tv_sec = div_u64_rem(now, NSEC_PER_SEC, &rem);
+	tp->tv_nsec = rem;
+}
+EXPORT_SYMBOL_GPL(trace_clock_gettime);
+
 /**
  * tracing_is_enabled - Show if global_trace has been disabled
  *
-- 
1.8.5.1

