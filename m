Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaFKBEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 21:04:52 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57071 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaFKBEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 21:04:51 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-kernel@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>, Michal Hocko <mhocko@suse.cz>,
        Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>
Subject: [RFC] printk: allow increasing the ring buffer depending on the number of CPUs
Date: Tue, 10 Jun 2014 18:04:45 -0700
Message-Id: <1402448685-30634-1-git-send-email-mcgrof@do-not-panic.com>
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
under load by each CPU in the worst case scenerio.

We use num_possible_cpus() to avoid complexities which could be
introduced by dynamically changing the ring buffer size at run
time, num_possible_cpus() lets us use the upper limit on possible
number of CPUs therefore avoiding having to deal with hotplugging
CPUs on and off. This option is diabled by default, and if used
the kernel ring buffer size then can be computed as follows:

size = __LOG_BUF_LEN + (num_possible_cpus() - 1 ) *  __LOG_CPU_BUF_LEN

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Arun KS <arunks.linux@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 init/Kconfig           | 28 ++++++++++++++++++++++++++++
 kernel/printk/printk.c |  6 ++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 9d3585b..1814436 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -806,6 +806,34 @@ config LOG_BUF_SHIFT
 		     13 =>  8 KB
 		     12 =>  4 KB
 
+config LOG_CPU_BUF_SHIFT
+	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
+	range 0 21
+	default 0
+	help
+	  The kernel ring buffer will get additional data logged onto it
+	  when multiple CPUs are supported. Typically the contributions is a
+	  few lines when idle however under under load this can vary and in the
+	  worst case it can mean loosing logging information. You can use this
+	  to set the maximum expected mount of amount of logging contribution
+	  under load by each CPU in the worst case scenerio. Select a size as
+	  a power of 2. For example if LOG_BUF_SHIFT is 18 and if your
+	  LOG_CPU_BUF_SHIFT is 12 your kernel ring buffer size will be as
+	  follows having 16 CPUs as possible.
+
+	     ((1 << 18) + ((16 - 1) * (1 << 12))) / 1024 = 316 KB
+
+	  Where as typically you'd only end up with 256 KB. This is disabled
+	  by default with a value of 0.
+
+	  Examples:
+		     17 => 128 KB
+		     16 => 64 KB
+	             15 => 32 KB
+	             14 => 16 KB
+		     13 =>  8 KB
+		     12 =>  4 KB
+
 #
 # Architectures with an unreliable sched_clock() should select this:
 #
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7228258..2023424 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -246,6 +246,7 @@ static u32 clear_idx;
 #define LOG_ALIGN __alignof__(struct printk_log)
 #endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
+#define __LOG_CPU_BUF_LEN (1 << CONFIG_LOG_CPU_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
@@ -752,9 +753,10 @@ void __init setup_log_buf(int early)
 	unsigned long flags;
 	char *new_log_buf;
 	int free;
+	int cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_BUF_LEN;
 
-	if (!new_log_buf_len)
-		return;
+	if (!new_log_buf_len && cpu_extra > 1)
+		new_log_buf_len = __LOG_BUF_LEN + cpu_extra;
 
 	if (early) {
 		new_log_buf =
-- 
2.0.0.rc3.18.g00a5b79

