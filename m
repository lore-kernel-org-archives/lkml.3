Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3FKG25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:28:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab3FKG2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:28:49 -0400
Subject: Patch "tracing: Fix possible NULL pointer dereferences" has been added to the 3.4-stable tree
To: namhyung.kim@lge.com, fweisbec@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com, mingo@kernel.org,
        namhyung@kernel.org, rostedt@goodmis.org, stable@vger.kernel.org
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 10 Jun 2013 14:28:03 -0700
In-Reply-To: <51B1A15C.5040108@huawei.com>
Message-ID: <13708996832884@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tracing: Fix possible NULL pointer dereferences

to the 3.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     tracing-fix-possible-null-pointer-dereferences.patch
and it can be found in the queue-3.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From lizefan@huawei.com  Mon Jun 10 14:15:28 2013
From: Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 7 Jun 2013 17:01:16 +0800
Subject: tracing: Fix possible NULL pointer dereferences
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Message-ID: <51B1A15C.5040108@huawei.com>


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

Link:
http://lkml.kernel.org/r/1365663302-2170-1-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ lizf: adjust context ]
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ftrace.h     |    2 +-
 kernel/trace/ftrace.c      |   10 +++++-----
 kernel/trace/trace_stack.c |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -299,7 +299,7 @@ ssize_t ftrace_filter_write(struct file
 			    size_t cnt, loff_t *ppos);
 ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
 			     size_t cnt, loff_t *ppos);
-loff_t ftrace_regex_lseek(struct file *file, loff_t offset, int origin);
+loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int origin);
 int ftrace_regex_release(struct inode *inode, struct file *file);
 
 void __init
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2626,7 +2626,7 @@ ftrace_notrace_open(struct inode *inode,
 }
 
 loff_t
-ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
+ftrace_filter_lseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t ret;
 
@@ -3445,7 +3445,7 @@ static const struct file_operations ftra
 	.open = ftrace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -3453,7 +3453,7 @@ static const struct file_operations ftra
 	.open = ftrace_notrace_open,
 	.read = seq_read,
 	.write = ftrace_notrace_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -3659,8 +3659,8 @@ static const struct file_operations ftra
 	.open		= ftrace_graph_open,
 	.read		= seq_read,
 	.write		= ftrace_graph_write,
+	.llseek		= ftrace_filter_lseek,
 	.release	= ftrace_graph_release,
-	.llseek		= seq_lseek,
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
@@ -4261,7 +4261,7 @@ static const struct file_operations ftra
 	.open		= ftrace_pid_open,
 	.write		= ftrace_pid_write,
 	.read		= seq_read,
-	.llseek		= seq_lseek,
+	.llseek		= ftrace_filter_lseek,
 	.release	= ftrace_pid_release,
 };
 
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -384,7 +384,7 @@ static const struct file_operations stac
 	.open = stack_trace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 


Patches currently in stable-queue which might be from namhyung.kim@lge.com are

queue-3.4/tracing-fix-possible-null-pointer-dereferences.patch
