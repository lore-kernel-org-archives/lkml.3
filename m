Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaGPV0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:26:15 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:55983 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaGPV0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:26:12 -0400
Date: Thu, 17 Jul 2014 00:26:08 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] proc: convert /proc/$PID/limits to seq_file interface
Message-ID: <20140716212608.GA21290@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -440,12 +440,11 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
 };
 
 /* Display limits for a process */
-static int proc_pid_limits(struct task_struct *task, char *buffer)
+static int proc_pid_limits(struct seq_file *m, struct pid_namespace *ns,
+			   struct pid *pid, struct task_struct *task)
 {
 	unsigned int i;
-	int count = 0;
 	unsigned long flags;
-	char *bufptr = buffer;
 
 	struct rlimit rlim[RLIM_NLIMITS];
 
@@ -457,31 +456,29 @@ static int proc_pid_limits(struct task_struct *task, char *buffer)
 	/*
 	 * print the file header
 	 */
-	count += sprintf(&bufptr[count], "%-25s %-20s %-20s %-10s\n",
+       seq_printf(m, "%-25s %-20s %-20s %-10s\n",
 			"Limit", "Soft Limit", "Hard Limit", "Units");
 
 	for (i = 0; i < RLIM_NLIMITS; i++) {
 		if (rlim[i].rlim_cur == RLIM_INFINITY)
-			count += sprintf(&bufptr[count], "%-25s %-20s ",
+			seq_printf(m, "%-25s %-20s ",
 					 lnames[i].name, "unlimited");
 		else
-			count += sprintf(&bufptr[count], "%-25s %-20lu ",
+			seq_printf(m, "%-25s %-20lu ",
 					 lnames[i].name, rlim[i].rlim_cur);
 
 		if (rlim[i].rlim_max == RLIM_INFINITY)
-			count += sprintf(&bufptr[count], "%-20s ", "unlimited");
+			seq_printf(m, "%-20s ", "unlimited");
 		else
-			count += sprintf(&bufptr[count], "%-20lu ",
-					 rlim[i].rlim_max);
+			seq_printf(m, "%-20lu ", rlim[i].rlim_max);
 
 		if (lnames[i].unit)
-			count += sprintf(&bufptr[count], "%-10s\n",
-					 lnames[i].unit);
+			seq_printf(m, "%-10s\n", lnames[i].unit);
 		else
-			count += sprintf(&bufptr[count], "\n");
+			seq_putc(m, '\n');
 	}
 
-	return count;
+	return 0;
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
@@ -2558,7 +2555,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	ONE("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	  S_IRUGO, proc_pid_limits),
+	ONE("limits",	  S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
@@ -2897,7 +2894,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	ONE("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	 S_IRUGO, proc_pid_limits),
+	ONE("limits",	 S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
