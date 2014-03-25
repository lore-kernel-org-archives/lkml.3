Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbaCYR7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:59:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202AbaCYRzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:55:19 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 6/8] printk: Start printing handover kthreads on demand
Date: Tue, 25 Mar 2014 18:54:59 +0100
Message-Id: <1395770101-24534-7-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395770101-24534-1-git-send-email-jack@suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start kthreads for handing over printing only when printk.offload_chars
is set to value > 0 (i.e., when print offloading gets enabled).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 64 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 14 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index cb7e06850eb5..8d981b2b5bb1 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -109,6 +109,10 @@ static long printk_handover_state;
  * CPUs.
  */
 #define PRINTING_TASKS 2
+/* Pointers to printing kthreads */
+static struct task_struct *printing_kthread[PRINTING_TASKS];
+/* Serialization of changes to printk_offload_chars and kthread creation */
+static DEFINE_MUTEX(printk_kthread_mutex);
 
 /* Wait queue printing kthreads sleep on when idle */
 static DECLARE_WAIT_QUEUE_HEAD(print_queue); 
@@ -280,6 +284,12 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+static int offload_chars_set(const char *val, const struct kernel_param *kp);
+static struct kernel_param_ops offload_chars_ops = {
+	.set = offload_chars_set,
+	.get = param_get_uint,
+};
+
 /*
  * How many characters can we print in one call of printk before asking
  * other cpus to continue printing. 0 means infinity. Tunable via
@@ -288,7 +298,7 @@ static u32 log_buf_len = __LOG_BUF_LEN;
  */
 static unsigned int __read_mostly printk_offload_chars = 1000;
 
-module_param_named(offload_chars, printk_offload_chars, uint,
+module_param_cb(offload_chars, &offload_chars_ops, &printk_offload_chars,
 		   S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(offload_chars, "offload printing to console to a different"
 	" cpu after this number of characters");
@@ -2571,30 +2581,56 @@ static int printing_task(void *arg)
 	return 0;
 }
 
-static int __init printk_late_init(void)
+static void printk_start_offload_kthreads(void)
 {
-	struct console *con;
 	int i;
 	struct task_struct *task;
 
-	for_each_console(con) {
-		if (!keep_bootcon && con->flags & CON_BOOT) {
-			unregister_console(con);
-		}
-	}
-	hotcpu_notifier(console_cpu_notify, 0);
-
-	/* Does any handover of printing have any sence? */
-	if (num_possible_cpus() <= 1)
-		return 0;
-
+	/* Does handover of printing make any sense? */
+	if (printk_offload_chars == 0 || num_possible_cpus() <= 1)
+		return;
 	for (i = 0; i < PRINTING_TASKS; i++) {
+		if (printing_kthread[i])
+			continue;
 		task = kthread_run(printing_task, NULL, "print/%d", i);
 		if (IS_ERR(task)) {
 			pr_err("printk: Cannot create printing thread: %ld\n",
 			       PTR_ERR(task));
 		}
+		printing_kthread[i] = task;
 	}
+}
+
+static int offload_chars_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+
+	/* Protect against parallel change of printk_offload_chars */
+	mutex_lock(&printk_kthread_mutex);
+	ret = param_set_uint(val, kp);
+	if (ret) {
+		mutex_unlock(&printk_kthread_mutex);
+		return ret;
+	}
+	printk_start_offload_kthreads();
+	mutex_unlock(&printk_kthread_mutex);
+	return 0;
+}
+
+static int __init printk_late_init(void)
+{
+	struct console *con;
+
+	for_each_console(con) {
+		if (!keep_bootcon && con->flags & CON_BOOT) {
+			unregister_console(con);
+		}
+	}
+	hotcpu_notifier(console_cpu_notify, 0);
+
+	mutex_lock(&printk_kthread_mutex);
+	printk_start_offload_kthreads();
+	mutex_unlock(&printk_kthread_mutex);
 
 	return 0;
 }
-- 
1.8.1.4

