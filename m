Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab3DKGzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 02:55:10 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45830 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3DKGzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 02:55:08 -0400
X-AuditID: 9c930179-b7b2aae000000518-14-51665e4850d4
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/2] tracing: Fix possible NULL pointer dereferences
Date: Thu, 11 Apr 2013 15:55:01 +0900
Message-Id: <1365663302-2170-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Currently set_ftrace_pid and set_graph_function files use seq_lseek
for their fops.  However seq_open() is called only for FMODE_READ in
the fops->open() so that if an user tries to seek one of those file
when she open it for writing, it sees NULL seq_file and then panic.

It can be easily reproduced with following command:

  $ cd /sys/kernel/debug/tracing
  $ echo 1234 | sudo tee -a set_ftrace_pid

In this example, GNU coreutils' tee opens the file with fopen(, "a")
and then the fopen() internally calls lseek().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 include/linux/ftrace.h     |  2 +-
 kernel/trace/ftrace.c      | 10 +++++-----
 kernel/trace/trace_stack.c |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 832422d706f4..c7687d8c0b30 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -396,7 +396,7 @@ ssize_t ftrace_filter_write(struct file *file, const char __user *ubuf,
 			    size_t cnt, loff_t *ppos);
 ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
 			     size_t cnt, loff_t *ppos);
-loff_t ftrace_regex_lseek(struct file *file, loff_t offset, int whence);
+loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int whence);
 int ftrace_regex_release(struct inode *inode, struct file *file);
 
 void __init
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 03953fbd1b2a..be2bcb7ab2f7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2688,7 +2688,7 @@ ftrace_notrace_open(struct inode *inode, struct file *file)
 }
 
 loff_t
-ftrace_regex_lseek(struct file *file, loff_t offset, int whence)
+ftrace_filter_lseek(struct file *file, loff_t offset, int whence)
 {
 	loff_t ret;
 
@@ -3613,7 +3613,7 @@ static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -3621,7 +3621,7 @@ static const struct file_operations ftrace_notrace_fops = {
 	.open = ftrace_notrace_open,
 	.read = seq_read,
 	.write = ftrace_notrace_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -3826,8 +3826,8 @@ static const struct file_operations ftrace_graph_fops = {
 	.open		= ftrace_graph_open,
 	.read		= seq_read,
 	.write		= ftrace_graph_write,
+	.llseek		= ftrace_filter_lseek,
 	.release	= ftrace_graph_release,
-	.llseek		= seq_lseek,
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
@@ -4481,7 +4481,7 @@ static const struct file_operations ftrace_pid_fops = {
 	.open		= ftrace_pid_open,
 	.write		= ftrace_pid_write,
 	.read		= seq_read,
-	.llseek		= seq_lseek,
+	.llseek		= ftrace_filter_lseek,
 	.release	= ftrace_pid_release,
 };
 
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 8c3f37e2dc43..b20428c5efe2 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -382,7 +382,7 @@ static const struct file_operations stack_trace_filter_fops = {
 	.open = stack_trace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 
-- 
1.7.11.7

