Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3DVOaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:30:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51612 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab3DVOaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Namhyung Kim" <namhyung.kim@lge.com>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Steven Rostedt" <rostedt@goodmis.org>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.32194437@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [38/75] tracing: Fix possible NULL pointer dereferences
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

commit 6a76f8c0ab19f215af2a3442870eeb5f0e81998d upstream.

Currently set_ftrace_pid and set_graph_function files use seq_lseek
for their fops.  However seq_open() is called only for FMODE_READ in
the fops->open() so that if an user tries to seek one of those file
when she open it for writing, it sees NULL seq_file and then panic.

It can be easily reproduced with following command:

  $ cd /sys/kernel/debug/tracing
  $ echo 1234 | sudo tee -a set_ftrace_pid

In this example, GNU coreutils' tee opens the file with fopen(, "a")
and then the fopen() internally calls lseek().

Link: http://lkml.kernel.org/r/1365663302-2170-1-git-send-email-namhyung@kernel.org

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[bwh: Backported to 3.2: ftrace_regex_lseek() is static]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2316,7 +2316,7 @@ ftrace_notrace_open(struct inode *inode,
 }
 
 static loff_t
-ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
+ftrace_filter_lseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t ret;
 
@@ -3134,7 +3134,7 @@ static const struct file_operations ftra
 	.open = ftrace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -3142,7 +3142,7 @@ static const struct file_operations ftra
 	.open = ftrace_notrace_open,
 	.read = seq_read,
 	.write = ftrace_notrace_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -3350,8 +3350,8 @@ static const struct file_operations ftra
 	.open		= ftrace_graph_open,
 	.read		= seq_read,
 	.write		= ftrace_graph_write,
+	.llseek		= ftrace_filter_lseek,
 	.release	= ftrace_graph_release,
-	.llseek		= seq_lseek,
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
@@ -3843,7 +3843,7 @@ static const struct file_operations ftra
 	.open		= ftrace_pid_open,
 	.write		= ftrace_pid_write,
 	.read		= seq_read,
-	.llseek		= seq_lseek,
+	.llseek		= ftrace_filter_lseek,
 	.release	= ftrace_pid_release,
 };
 

