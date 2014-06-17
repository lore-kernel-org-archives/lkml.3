Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaFQAhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:37:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaFQAhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:37:50 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: hpa@linux.intel.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [RFT v5h printk: allow increasing the ring buffer depending on the number of CPUs
Date: Mon, 16 Jun 2014 17:37:44 -0700
Message-Id: <1402965464-11202-1-git-send-email-mcgrof@do-not-panic.com>
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
bootup. The kernel ring buffer is increased to the next power of
two that would fit the required minimum kernel ring buffer size
plus the additional CPU contribution. For example if LOG_BUF_SHIFT
is 18 (256 KB) you'd require at least 128 KB contributions by
other CPUs in order to trigger an increase of the kernel ring buffer.
With a LOG_CPU_BUF_SHIFT of 12 (4 KB) you'd require at least
anything over > 64 possible CPUs to trigger an increase. If you
had 128 possible CPUs the amount of minimum required kernel ring
buffer bumps to:

   ((1 << 18) + ((128 - 1) * (1 << 12))) / 1024 = 764 KB

Since we require the ring buffer to be a power of two this would
the new required size would be 1024 KB.

This CPU contributions are ignored when the "log_buf_len" kernel parameter
is used as it forces the exact size of the ring buffer to an expected power
of two value.

In order to make this code a bit more legible, add a small enum to keep
track of when the reasons of setting the ring buffer, and extend the
documentation quite a bit to make all this clear.

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

I've modified the computation to just go to the next power of two. All
other implementations do that, and although its not well documented 
I rather follow that logic. Without the enum stuff this code can get
ugly easy, while at it I also extended the documentation a bit more.

 Documentation/kernel-parameters.txt |   8 ++-
 init/Kconfig                        |  53 +++++++++++++++++-
 kernel/printk/printk.c              | 108 ++++++++++++++++++++++++++++++++++--
 3 files changed, 162 insertions(+), 7 deletions(-)

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
diff --git a/init/Kconfig b/init/Kconfig
index 9d76b99..69bdbcf 100644
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
@@ -816,6 +820,53 @@ config LOG_BUF_SHIFT
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
+	  ((1 << LOG_BUF_SHIFT / 2 bytes)) in order to trigger an increase upon
+	  bootup. If an increase is required the ring buffer is increated to
+	  the next power of 2 that can fit both the minimum kernel ring buffer
+	  (LOG_BUF_SHIFT) plus the additional worst case CPU contributions.
+	  For example if LOG_BUF_SHIFT is 18 (256 KB) you'd require at laest
+	  128 KB contributions by other CPUs in order to trigger an increase.
+	  With a LOG_CPU_BUF_SHIFT of 12 (4 KB) you'd require at least anything
+	  over > 64 possible CPUs to trigger an increase. If you had 128
+	  possible CPUs the new minimum required kernel ring buffer size
+	  would be:
+
+	     ((1 << 18) + ((128 - 1) * (1 << 12))) / 1024 = 764 KB
+
+	  Since we only allow powers of two for the kernel ring buffer size the
+	  new kernel ring buffer size would be 1024 KB.
+
+	  CPU contributions are ignored when "log_buf_len" kernel parameter is
+	  used as it forces an exact (power of two) size of the ring buffer to
+	  an expected value.
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
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ea2d5f6..54632a0c 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -214,6 +214,67 @@ enum log_flags {
 	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
 };
 
+/**
+ * DOC: Kernel ring buffer setup
+ *
+ * The size of the kernel ring buffer is always set to a size as a power of 2.
+ * By default the kernel ring buffer size is set up using static data through
+ * LOG_BUF_SHIFT. You can manually override the kernel ring buffer on boot by
+ * using the log_buf_len=n parameter. On really large CPU systems (default is
+ * more than 64 CPUs) an extra CPU contribution is computed in which case the
+ * ring buffer is adjusted to the next power 2 that can fit the expected worst
+ * case CPU contributions to the kernel ring buffer. The LOG_CPU_MIN_BUF_SHIFT
+ * contributions are computed late after setup_arch() in order to make use of
+ * num_possible_cpus(). LOG_CPU_MIN_BUF_SHIFT is a proactive measure for large
+ * systems. With a LOG_BUF_SHIFT of 18 and LOG_CPU_MIN_BUF_SHIFT 12 you'd need
+ * at least 64 CPUs in order to trigger an increase.
+ *
+ * setup_log_buf() can be called at early init during setup_arch(), at
+ * which point the early parameter must be set to true, this varies accross
+ * architectures but currently only x86 uses this. The early case of
+ * setup_log_buf() cannot use num_possible_cpus() as set_cpu_possible()
+ * is not guaranteed to have been called then.
+ */
+
+
+/**
+ * enum klog_setup_state - states for the kernel ring buffer setup
+ *
+ * This is used by by setup_log_buf() to keep track of the state of the
+ * kernel ring buffer via klog_state.
+ *
+ * @KLOG_STATIC: the minimum configured kernel ring buffer size is used. The
+ * 	ring buffer size is set from static kernel data. The size is set with
+ * 	LOG_BUF_SHIFT. Each architecture can define its own default size
+ * 	through its respective architecture defconfig. This is a power of 2.
+ * 	The maximum allowed value is 21, allowing for a maximum static size
+ * 	of 2 GiB.
+ * @KLOG_PARAM: the log_buf_len=n kernel parameter was passed, the passsed
+ * 	size will be used, it must be a power of 2 and greater than the
+ * 	mimimum required size set with LOG_BUF_SHIFT. When the kernel parameter
+ * 	is set CPU contributions set by LOG_CPU_MIN_BUF_SHIFT will be ignored.
+ *	Architectures can require the kernel ring buffer to be set up
+ * 	early in the boot process during setup_arch(). These architectures must
+ * 	call setup_log_buf() with the early parameter set. Since the kernel
+ * 	ring buffer is already set with the minimum required size an early
+ * 	allocation can only occur when the log_buf_len=n parameter is used.
+ * 	Currently only the x86 architectures requires the early setup.
+ * @KLOG_CPU_EXTRA: after setup_arch() has been called setup_log_buf() will
+ * 	be called for all architectures. For architectures that did not use
+ * 	the early call during its setup_arch() this is where the log_buf_len=n
+ * 	kernel parameter is checked for. The LOG_CPU_MIN_BUF_SHIFT
+ * 	contributions will be ignored if klog_state is already set to
+ * 	KLOG_PARAM. Architecures are expected to have prefilled the possible
+ * 	CPU bits cpu_possible_bits with set_cpu_possible() during setup_arch()
+ * 	in order for this extra CPU computation to work, for those that haven't
+ * 	this evaluation will have no effect.
+ */
+enum klog_setup_state {
+	KLOG_STATIC,
+	KLOG_PARAM,
+	KLOG_CPU_EXTRA,
+};
+
 struct printk_log {
 	u64 ts_nsec;		/* timestamp in nanoseconds */
 	u16 len;		/* length of entire record */
@@ -266,9 +327,11 @@ static u32 clear_idx;
 #define LOG_ALIGN __alignof__(struct printk_log)
 #endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
+#define __LOG_CPU_MIN_BUF_LEN (1 << CONFIG_LOG_CPU_MIN_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
+static enum klog_setup_state klog_state = KLOG_STATIC;
 
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
@@ -842,20 +905,56 @@ static int __init log_buf_len_setup(char *str)
 }
 early_param("log_buf_len", log_buf_len_setup);
 
+static unsigned __init compute_cpu_contrib(void)
+{
+	int cpu_extra;
+	unsigned extra_cpu_log_size;
+
+	/*
+	 * archs should set up cpu_possible_bits properly with
+	 * set_cpu_possible() after setup_arch() but just in
+	 * case lets ensure this is valid.
+	 */
+	if (num_possible_cpus() <= 1)
+		return 0;
+
+	cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MIN_BUF_LEN;
+	extra_cpu_log_size = roundup_pow_of_two(cpu_extra + __LOG_BUF_LEN);
+
+	if (cpu_extra <= __LOG_BUF_LEN / 2)
+		return 0;
+
+	pr_info("log_buf_len cpu_extra contribution: %d\n", cpu_extra);
+	pr_info("log_buf_len min size: %d\n", __LOG_BUF_LEN);
+
+	return extra_cpu_log_size;
+}
+
 void __init setup_log_buf(int early)
 {
 	unsigned long flags;
 	char *new_log_buf;
 	int free;
-
-	if (!new_log_buf_len)
-		return;
+	enum klog_setup_state new_klog_state;
 
 	if (early) {
+		if (!new_log_buf_len)
+			return;
 		new_log_buf =
 			memblock_virt_alloc(new_log_buf_len, PAGE_SIZE);
+		new_klog_state = KLOG_PARAM;
 	} else {
-		new_log_buf = memblock_virt_alloc_nopanic(new_log_buf_len, 0);
+		if (klog_state == KLOG_PARAM)
+			return;
+		if (new_log_buf_len)
+			new_klog_state = KLOG_PARAM;
+		else {
+			new_log_buf_len = compute_cpu_contrib();
+			new_klog_state = KLOG_CPU_EXTRA;
+		}
+		if (!new_log_buf_len)
+			return;
+		new_log_buf = memblock_virt_alloc(new_log_buf_len, PAGE_SIZE);
 	}
 
 	if (unlikely(!new_log_buf)) {
@@ -868,6 +967,7 @@ void __init setup_log_buf(int early)
 	log_buf_len = new_log_buf_len;
 	log_buf = new_log_buf;
 	new_log_buf_len = 0;
+	klog_state = new_klog_state;
 	free = __LOG_BUF_LEN - log_next_idx;
 	memcpy(log_buf, __log_buf, __LOG_BUF_LEN);
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
-- 
1.9.3

