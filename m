Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaGPVfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:35:53 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59189 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbaGPVfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:35:48 -0400
Date: Thu, 17 Jul 2014 00:35:42 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] proc: convert /proc/$PID/io to seq_file interface
Message-ID: <20140716213542.GG21290@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2399,7 +2399,7 @@ static const struct file_operations proc_coredump_filter_operations = {
 #endif
 
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
+static int do_io_accounting(struct task_struct *task, struct seq_file *m, int whole)
 {
 	struct task_io_accounting acct = task->ioac;
 	unsigned long flags;
@@ -2423,7 +2423,7 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 
 		unlock_task_sighand(task, &flags);
 	}
-	result = sprintf(buffer,
+	result = seq_printf(m,
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
@@ -2443,14 +2443,16 @@ out_unlock:
 	return result;
 }
 
-static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
+static int proc_tid_io_accounting(struct seq_file *m, struct pid_namespace *ns,
+				  struct pid *pid, struct task_struct *task)
 {
-	return do_io_accounting(task, buffer, 0);
+	return do_io_accounting(task, m, 0);
 }
 
-static int proc_tgid_io_accounting(struct task_struct *task, char *buffer)
+static int proc_tgid_io_accounting(struct seq_file *m, struct pid_namespace *ns,
+				   struct pid *pid, struct task_struct *task)
 {
-	return do_io_accounting(task, buffer, 1);
+	return do_io_accounting(task, m, 1);
 }
 #endif /* CONFIG_TASK_IO_ACCOUNTING */
 
@@ -2632,7 +2634,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUSR, proc_tgid_io_accounting),
+	ONE("io",	S_IRUSR, proc_tgid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
 	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
@@ -2967,7 +2969,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUSR, proc_tid_io_accounting),
+	ONE("io",	S_IRUSR, proc_tid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
 	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
