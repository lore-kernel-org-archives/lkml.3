Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab3FKGae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:30:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab3FKG2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:28:46 -0400
Subject: Patch "tracing: Fix possible NULL pointer dereferences" has been added to the 3.0-stable tree
To: lizefan@huawei.com, fweisbec@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, namhyung@kernel.org,
        namhyung.kim@lge.com, rostedt@goodmis.org, stable@vger.kernel.org
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 10 Jun 2013 14:28:01 -0700
In-Reply-To: <51B1A131.9090206@huawei.com>
Message-ID: <13708996813585@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tracing: Fix possible NULL pointer dereferences

to the 3.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     tracing-fix-possible-null-pointer-dereferences.patch
and it can be found in the queue-3.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From lizefan@huawei.com  Mon Jun 10 14:16:36 2013
From: Li Zefan <lizefan@huawei.com>
Date: Fri, 7 Jun 2013 17:00:33 +0800
Subject: tracing: Fix possible NULL pointer dereferences
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Message-ID: <51B1A131.9090206@huawei.com>


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
 kernel/trace/ftrace.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2300,7 +2300,7 @@ ftrace_notrace_open(struct inode *inode,
 }
 
 static loff_t
-ftrace_regex_lseek(struct file *file, loff_t offset, int origin)
+ftrace_filter_lseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t ret;
 
@@ -3118,7 +3118,7 @@ static const struct file_operations ftra
 	.open = ftrace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -3126,7 +3126,7 @@ static const struct file_operations ftra
 	.open = ftrace_notrace_open,
 	.read = seq_read,
 	.write = ftrace_notrace_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = ftrace_filter_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -3335,8 +3335,8 @@ static const struct file_operations ftra
 	.open		= ftrace_graph_open,
 	.read		= seq_read,
 	.write		= ftrace_graph_write,
+	.llseek		= ftrace_filter_lseek,
 	.release	= ftrace_graph_release,
-	.llseek		= seq_lseek,
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
@@ -3822,7 +3822,7 @@ static const struct file_operations ftra
 	.open		= ftrace_pid_open,
 	.write		= ftrace_pid_write,
 	.read		= seq_read,
-	.llseek		= seq_lseek,
+	.llseek		= ftrace_filter_lseek,
 	.release	= ftrace_pid_release,
 };
 


Patches currently in stable-queue which might be from lizefan@huawei.com are

queue-3.0/tracing-fix-possible-null-pointer-dereferences.patch
queue-3.0/ftrace-move-ftrace_filter_lseek-out-of-config_dynamic_ftrace-section.patch
