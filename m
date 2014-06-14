Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaFNSww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 14:52:52 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64620 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaFNSwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 14:52:51 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: hpa@linux.intel.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [RFT v4] printk: allow increasing the ring buffer depending on the number of CPUs
Date: Sat, 14 Jun 2014 11:52:45 -0700
Message-Id: <1402771965-7515-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The default size of the ring buffer is too small for machines
with a large amount of CPUs under heavy load. What ends up
happening when debugging is the ring buffer overlaps and chews
up old messages making debugging impossible unless the size is
passed as a kernel parameter. An idle system upon boot up will
on average spew out only about one or two extra lines but where
this really matters is on heavy load and that will vary widely
depending on the system and environment.

There are mechanisms to help increase the kernel ring buffer
for tracing through debugfs, and those interfaces even allow growing
the kernel ring buffer per CPU. We also have a static value which
can be passed upon boot. Relying on debugfs however is not ideal
for production, and relying on the value passed upon bootup is
can only used *after* an issue has creeped up. Instead of being
reactive this adds a proactive measure which lets you scale the
amount of contributions you'd expect to the kernel ring buffer
under load by each CPU in the worst case scenario.

We use num_possible_cpus() to avoid complexities which could be
introduced by dynamically changing the ring buffer size at run
time, num_possible_cpus() lets us use the upper limit on possible
number of CPUs therefore avoiding having to deal with hotplugging
CPUs on and off. This introduces the kernel configuration option
LOG_CPU_MIN_BUF_SHIFT which is used to specify the maximum amount
of contributions to the kernel ring buffer in the worst case before
the kernel ring buffer flips over, the size is specified as a power
of 2. The total amount of contributions made by each CPU must be
greater than half of the default kernel ring buffer size
(1 << LOG_BUF_SHIFT bytes) in order to trigger an increase upon
bootup. For example if LOG_BUF_SHIFT is 18 (256 KB) you'd require at
least 128 KB contributions by other CPUs in order to trigger an
increase. With a LOG_CPU_BUF_SHIFT of 12 (4 KB) you'd require at
least anything over > 64 possible CPUs to trigger an increase. If
you had 128 possible CPUs your kernel buffer size would be:

   ((1 << 18) + ((128 - 1) * (1 << 12))) / 1024 = 764 KB

This value is ignored when "log_buf_len" kernel parameter is used
as it forces the exact size of the ring buffer to an expected value.

In order to use num_possible_cpus() we need to make this a late call
on the init process but that also means we cannot share __init code,
the late_setup_log_buf() provided is therefore very similar to the
setup_log_buf() but just modified slightly, in particular since we're
at late boot we can now also use kzalloc().

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Arun KS <arunks.linux@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---

This doesn't kfree() at halt but do we need to do it ?

 Documentation/kernel-parameters.txt |  8 ++++--
 include/linux/printk.h              |  5 ++++
 init/Kconfig                        | 45 +++++++++++++++++++++++++++++++-
 init/main.c                         |  1 +
 kernel/printk/printk.c              | 51 +++++++++++++++++++++++++++++++++++++
 5 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6eaa9cd..229d031 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1685,8 +1685,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			7 (KERN_DEBUG)		debug-level messages
 
 	log_buf_len=n[KMG]	Sets the size of the printk ring buffer,
-			in bytes.  n must be a power of two.  The default
-			size is set in the kernel config file.
+			in bytes.  n must be a power of two and greater
+			than the minimal size. The minimal size is defined
+			by LOG_BUF_SHIFT kernel config parameter. There is
+			also CONFIG_LOG_CPU_MIN_BUF_SHIFT config parameter
+			that allows to increase the default size depending on
+			the number of CPUs. See init/Kconfig for more details.
 
 	logo.nologo	[FB] Disables display of the built-in Linux logo.
 			This may be used to provide more screen space for
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 319ff7e..315a0b7 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -161,6 +161,7 @@ extern void wake_up_klogd(void);
 
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
+void late_setup_log_buf(void);
 void dump_stack_set_arch_desc(const char *fmt, ...);
 void dump_stack_print_info(const char *log_lvl);
 void show_regs_print_info(const char *log_lvl);
@@ -202,6 +203,10 @@ static inline void setup_log_buf(int early)
 {
 }
 
+static inline void late_setup_log_buf(void)
+{
+}
+
 static inline void dump_stack_set_arch_desc(const char *fmt, ...)
 {
 }
diff --git a/init/Kconfig b/init/Kconfig
index 9d76b99..f0607d0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -807,7 +807,11 @@ config LOG_BUF_SHIFT
 	range 12 21
 	default 17
 	help
-	  Select kernel log buffer size as a power of 2.
+	  Select the minimal kernel log buffer size as a power of 2.
+	  The final size is affected by LOG_CPU_MIN_BUF_SHIFT config
+	  parameter, see below. Any higher size also might be forced
+	  by "log_buf_len" boot parameter.
+
 	  Examples:
 	  	     17 => 128 KB
 		     16 => 64 KB
@@ -816,6 +820,45 @@ config LOG_BUF_SHIFT
 		     13 =>  8 KB
 		     12 =>  4 KB
 
+config LOG_CPU_MIN_BUF_SHIFT
+	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
+	range 0 21
+	default 12
+	depends on SMP
+	depends on !BASE_SMALL
+	help
+	  The kernel ring buffer will get additional data logged onto it
+	  when multiple CPUs are supported. Typically the contributions are
+	  only a few lines when idle however under under load this can vary
+	  and in the worst case it can mean losing logging information. You
+	  can use this to set the maximum expected mount of amount of logging
+	  contribution under load by each CPU in the worst case scenario, as
+	  a power of 2. The total amount of contributions made by each CPU
+	  must be greater than half of the default kernel ring buffer size
+	  (1 << LOG_BUF_SHIFT bytes) in order to trigger an increase upon
+	  bootup. For example if LOG_BUF_SHIFT is 18 (256 KB) you're require
+	  at least 128 KB contributions by other CPUs in order to trigger
+	  an increase. With a LOG_CPU_BUF_SHIFT of 12 (4 KB) you'd require
+	  at least anything over > 64 possible CPUs to trigger an increase.
+	  If you had 128 possible CPUs your kernel buffer size would be:
+
+	     ((1 << 18) + ((128 - 1) * (1 << 12))) / 1024 = 764 KB
+
+	  This value is ignored when "log_buf_len" kernel parameter is used
+	  as it forces the exact size of the ring buffer to an expected value.
+
+	  The number of possible CPUs is used for this computation ignoring
+	  hotplugging making the compuation optimal for the the worst case
+	  scenerio while allowing a simple algorithm to be used from bootup.
+
+	  Examples shift values and their meaning:
+		     17 => 128 KB for each CPU
+		     16 =>  64 KB for each CPU
+		     15 =>  32 KB for each CPU
+		     14 =>  16 KB for each CPU
+		     13 =>   8 KB for each CPU
+		     12 =>   4 KB for each CPU
+
 #
 # Architectures with an unreliable sched_clock() should select this:
 #
diff --git a/init/main.c b/init/main.c
index e8ae1fe..8b472c6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -940,6 +940,7 @@ static int __ref kernel_init(void *unused)
 	numa_default_policy();
 
 	flush_delayed_fput();
+	late_setup_log_buf();
 
 	if (ramdisk_execute_command) {
 		ret = run_init_process(ramdisk_execute_command);
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ea2d5f6..9cf919f 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -266,6 +266,7 @@ static u32 clear_idx;
 #define LOG_ALIGN __alignof__(struct printk_log)
 #endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
+#define __LOG_CPU_MIN_BUF_LEN (1 << CONFIG_LOG_CPU_MIN_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
@@ -842,6 +843,12 @@ static int __init log_buf_len_setup(char *str)
 }
 early_param("log_buf_len", log_buf_len_setup);
 
+/*
+ * The log buffer is by default set using static memory unless
+ * you either set the log_buf_len=n kernel parameter or use a
+ * LOG_CPU_MIN_BUF_SHIFT that triggers a required increase
+ * via late_setup_log_buf().
+ */
 void __init setup_log_buf(int early)
 {
 	unsigned long flags;
@@ -877,6 +884,50 @@ void __init setup_log_buf(int early)
 		free, (free * 100) / __LOG_BUF_LEN);
 }
 
+/*
+ * If you set log_buf_len=n kernel parameter LOG_CPU_MIN_BUF_SHIFT will
+ * be ignored. LOG_CPU_MIN_BUF_SHIFT is a proactive measure for large
+ * systems. With a LOG_BUF_SHIFT of 18 and LOG_CPU_MIN_BUF_SHIFT 12 at
+ * we'd require more than 64 CPUs to trigger an increase from the
+ * default. Since we need num_possible_cpus() we do this allocation
+ * later in the boot process.
+ */
+void late_setup_log_buf(void)
+{
+	unsigned long flags;
+	char *new_log_buf;
+	int free;
+	int cpu_extra = (num_possible_cpus() - 1) *  __LOG_CPU_MIN_BUF_LEN;
+	size_t new_log_size;
+
+	/* The log_buf_len=n kernel parameter was passed */
+	if (log_buf_len > __LOG_BUF_LEN)
+		return;
+
+	/* Extra CPU contribution penalty not incurred */
+	if (cpu_extra < __LOG_BUF_LEN / 2)
+		return;
+
+	new_log_size = __LOG_BUF_LEN + cpu_extra;
+	new_log_buf = kzalloc(new_log_size, GFP_KERNEL);
+
+	if (unlikely(!new_log_buf)) {
+		pr_err("log_buf_len: %ld bytes not available\n", new_log_size);
+		return;
+	}
+
+	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	log_buf_len = new_log_size;
+	log_buf = new_log_buf;
+	free = __LOG_BUF_LEN - log_next_idx;
+	memcpy(log_buf, __log_buf, __LOG_BUF_LEN);
+	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+
+	pr_info("big CPU log_buf_len: %d\n", log_buf_len);
+	pr_info("big CPU early log buf free: %d(%d%%)\n",
+		free, (free * 100) / __LOG_BUF_LEN);
+}
+
 static bool __read_mostly ignore_loglevel;
 
 static int __init ignore_loglevel_setup(char *str)
-- 
1.9.3

