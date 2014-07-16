Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaGPV05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:26:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58311 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaGPV0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:26:55 -0400
Date: Thu, 17 Jul 2014 00:26:51 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] proc: convert /proc/$PID/syscall to seq_file interface
Message-ID: <20140716212651.GB21290@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -482,7 +482,8 @@ static int proc_pid_limits(struct seq_file *m, struct pid_namespace *ns,
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-static int proc_pid_syscall(struct task_struct *task, char *buffer)
+static int proc_pid_syscall(struct seq_file *m, struct pid_namespace *ns,
+			    struct pid *pid, struct task_struct *task)
 {
 	long nr;
 	unsigned long args[6], sp, pc;
@@ -491,11 +492,11 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
 		return res;
 
 	if (task_current_syscall(task, &nr, args, 6, &sp, &pc))
-		res = sprintf(buffer, "running\n");
+		seq_puts(m, "running\n");
 	else if (nr < 0)
-		res = sprintf(buffer, "%ld 0x%lx 0x%lx\n", nr, sp, pc);
+		seq_printf(m, "%ld 0x%lx 0x%lx\n", nr, sp, pc);
 	else
-		res = sprintf(buffer,
+		seq_printf(m,
 		       "%ld 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
 		       nr,
 		       args[0], args[1], args[2], args[3], args[4], args[5],
@@ -2564,7 +2565,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",    S_IRUSR, proc_pid_syscall),
+	ONE("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
@@ -2900,7 +2901,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",   S_IRUSR, proc_pid_syscall),
+	ONE("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
