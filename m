Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaGPVYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:24:37 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58592 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaGPVYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:24:34 -0400
Date: Thu, 17 Jul 2014 00:24:29 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] proc: convert /proc/$PID/auxv to seq_file interface
Message-ID: <20140716212429.GB21242@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -205,22 +205,20 @@ static int proc_pid_cmdline(struct task_struct *task, char *buffer)
 	return get_cmdline(task, buffer, PAGE_SIZE);
 }
 
-static int proc_pid_auxv(struct task_struct *task, char *buffer)
+static int proc_pid_auxv(struct seq_file *m, struct pid_namespace *ns,
+			 struct pid *pid, struct task_struct *task)
 {
 	struct mm_struct *mm = mm_access(task, PTRACE_MODE_READ);
-	int res = PTR_ERR(mm);
 	if (mm && !IS_ERR(mm)) {
 		unsigned int nwords = 0;
 		do {
 			nwords += 2;
 		} while (mm->saved_auxv[nwords - 2] != 0); /* AT_NULL */
-		res = nwords * sizeof(mm->saved_auxv[0]);
-		if (res > PAGE_SIZE)
-			res = PAGE_SIZE;
-		memcpy(buffer, mm->saved_auxv, res);
+		seq_write(m, mm->saved_auxv, nwords * sizeof(mm->saved_auxv[0]));
 		mmput(mm);
-	}
-	return res;
+		return 0;
+	} else
+		return PTR_ERR(mm);
 }
 
 
@@ -2557,7 +2555,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
 #endif
 	REG("environ",    S_IRUSR, proc_environ_operations),
-	INF("auxv",       S_IRUSR, proc_pid_auxv),
+	ONE("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
 	INF("limits",	  S_IRUGO, proc_pid_limits),
@@ -2896,7 +2894,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	DIR("ns",	 S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
 	REG("environ",   S_IRUSR, proc_environ_operations),
-	INF("auxv",      S_IRUSR, proc_pid_auxv),
+	ONE("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
 	INF("limits",	 S_IRUGO, proc_pid_limits),
