Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaCQGz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 02:55:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbaCQGy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 02:54:56 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 8/8] printk: Add config option for disabling printk offloading
Date: Fri, 14 Mar 2014 17:21:52 +0100
Message-Id: <1394814112-20200-9-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394814112-20200-1-git-send-email-jack@suse.cz>
References: <1394814112-20200-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Necessity for offloading of printing was observed only for large
systems. So add a config option (disabled by default) which removes most
of the overhead added by this functionality.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/kernel-parameters.txt | 13 +++++++------
 init/Kconfig                        | 14 ++++++++++++++
 kernel/printk/printk.c              | 14 ++++++++++++++
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 74826b1e2529..3c6d5aec501a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2621,18 +2621,19 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 			default: disabled
 
-	printk.offload_chars=
+	printk.offload_chars=	[KNL]
 			Printing to console can be relatively slow especially
 			in case of serial console. When there is intensive
 			printing happening from several cpus (as is the case
 			during boot), a cpu can be spending significant time
 			(seconds or more) doing printing. To avoid softlockups,
 			lost interrupts, and similar problems other cpus
-			will take over printing after the currently printing
-			cpu has printed 'printk.offload_chars' characters.
-			Higher value means possibly longer interrupt and other
-			latencies but lower overhead of printing due to handing
-			over of printing.
+			will take over printing (if CONFIG_PRINTK_OFFLOAD=y)
+			after the currently printing cpu has printed
+			'printk.offload_chars' characters. Higher value means
+			possibly longer interrupt and other latencies but
+			lower overhead of printing due to handing over of
+			printing.
 			Format: <number> (0 = disabled)
 			default: 1000
 
diff --git a/init/Kconfig b/init/Kconfig
index 009a797dd242..45aa7368d92f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1343,6 +1343,20 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+config PRINTK_OFFLOAD
+	default y
+	bool "Enable support for offloading printing to different CPU"
+	depends on PRINTK
+	help
+	  Printing to console can be relatively slow especially in case of
+	  serial console. On large machines when there is intensive printing
+	  happening from several cpus (as is the case during boot), a cpu can
+	  be spending significant time (seconds or more) doing printing. To
+	  avoid softlockups, lost interrupts, and similar problems other cpus
+	  will take over printing after the currently printing cpu has printed
+	  certain number of characters (tunable via 'printk.offload_chars'
+	  kernel parameter).
+
 config BUG
 	bool "BUG() support" if EXPERT
 	default y
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 06e39c661a00..679805e98843 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -103,6 +103,7 @@ enum {
 };
 static long printk_handover_state;
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 /*
  * Number of kernel threads for offloading printing. We need at least two so
  * that they can hand over printing from one to another one and thus switch
@@ -116,6 +117,7 @@ static DEFINE_MUTEX(printk_kthread_mutex);
 
 /* Wait queue printing kthreads sleep on when idle */
 static DECLARE_WAIT_QUEUE_HEAD(print_queue); 
+#endif	/* CONFIG_PRINTK_OFFLOAD */
 
 #ifdef CONFIG_LOCKDEP
 static struct lockdep_map console_lock_dep_map = {
@@ -284,6 +286,7 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 static int offload_chars_set(const char *val, const struct kernel_param *kp);
 static struct kernel_param_ops offload_chars_ops = {
 	.set = offload_chars_set,
@@ -302,6 +305,7 @@ module_param_cb(offload_chars, &offload_chars_ops, &printk_offload_chars,
 		   S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(offload_chars, "offload printing to console to a different"
 	" cpu after this number of characters");
+#endif
 
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
@@ -2021,6 +2025,7 @@ int console_trylock(void)
 }
 EXPORT_SYMBOL(console_trylock);
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 /*
  * This is a version of console_lock() which spins to acquire console_sem.
  * It is only for use by threads that take care of flushing printk buffer so
@@ -2052,6 +2057,7 @@ static int console_lock_try_spin(void)
 	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
 	return 1;
 }
+#endif
 
 int is_console_locked(void)
 {
@@ -2087,6 +2093,7 @@ out:
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 /*
  * Returns true iff there is other cpu waiting to take over printing. This
  * function also takes are of setting PRINTK_HANDOVER_B if we want to hand over
@@ -2113,6 +2120,7 @@ static bool cpu_stop_printing(int printed_chars)
 	}
 	return false;
 }
+#endif
 
 /**
  * console_unlock - unlock the console system
@@ -2155,10 +2163,12 @@ again:
 		size_t len;
 		int level;
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 		if (cpu_stop_printing(printed_chars)) {
 			hand_over = true;
 			break;
 		}
+#endif
 
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		if (seen_seq != log_next_seq) {
@@ -2576,6 +2586,7 @@ int unregister_console(struct console *console)
 }
 EXPORT_SYMBOL(unregister_console);
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 /* Kthread which takes over printing from a CPU which asks for help */
 static int printing_task(void *arg)
 {
@@ -2638,6 +2649,7 @@ static int offload_chars_set(const char *val, const struct kernel_param *kp)
 	mutex_unlock(&printk_kthread_mutex);
 	return 0;
 }
+#endif	/* CONFIG_PRINTK_OFFLOAD */
 
 static int __init printk_late_init(void)
 {
@@ -2650,9 +2662,11 @@ static int __init printk_late_init(void)
 	}
 	hotcpu_notifier(console_cpu_notify, 0);
 
+#ifdef CONFIG_PRINTK_OFFLOAD
 	mutex_lock(&printk_kthread_mutex);
 	printk_start_offload_kthreads();
 	mutex_unlock(&printk_kthread_mutex);
+#endif
 
 	return 0;
 }
-- 
1.8.1.4

