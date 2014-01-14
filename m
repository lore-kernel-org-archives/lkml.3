Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaANXmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:42:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbaANXmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:42:47 -0500
From: atomlin@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, oleg@redhat.com, riel@redhat.com,
        akpm@linux-foundation.org
Subject: [RFC PATCH v2 2/2] hung_task: Display every hung task warning
Date: Tue, 14 Jan 2014 23:41:58 +0000
Message-Id: <1389742918-32598-3-git-send-email-atomlin@redhat.com>
In-Reply-To: <1389742918-32598-1-git-send-email-atomlin@redhat.com>
References: <1389742918-32598-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

The khungtaskd thread limits how many hung task
warnings it displays at a time, when a timeout
occurs. This patch allows that limit to be set
to "unlimited", by setting hung_task_warnings
to -1, which will cause khungtaskd to display
information about all hung tasks.

While ULONG_MAX is practically "inf", this
patch takes it one step further.  Note: The
maximum is now 2^31-1 (INT_MAX) which should
hopefully be sufficient.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 include/linux/sched/sysctl.h | 2 +-
 kernel/hung_task.c           | 9 +++++----
 kernel/sysctl.c              | 5 +++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 41467f8..eb3c72d7 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -5,7 +5,7 @@
 extern int	     sysctl_hung_task_check_count;
 extern unsigned int  sysctl_hung_task_panic;
 extern unsigned long sysctl_hung_task_timeout_secs;
-extern unsigned long sysctl_hung_task_warnings;
+extern int sysctl_hung_task_warnings;
 extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
 					 void __user *buffer,
 					 size_t *lenp, loff_t *ppos);
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 9328b80..343ed70 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -37,7 +37,7 @@ int __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
  */
 unsigned long __read_mostly sysctl_hung_task_timeout_secs = CONFIG_DEFAULT_HUNG_TASK_TIMEOUT;
 
-unsigned long __read_mostly sysctl_hung_task_warnings = 10;
+int __read_mostly sysctl_hung_task_warnings = 10;
 
 static int __read_mostly did_panic;
 
@@ -98,11 +98,12 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 
 	if (!sysctl_hung_task_warnings)
 		return;
-	sysctl_hung_task_warnings--;
+
+	if (sysctl_hung_task_warnings > 0)
+		sysctl_hung_task_warnings--;
 
 	/*
-	 * Ok, the task did not get scheduled for more than 2 minutes,
-	 * complain:
+	 * Ok, the task did not get scheduled for a while, complain:
 	 */
 	pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
 		t->comm, t->pid, timeout);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index dd531a6..b50cd13 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -985,9 +985,10 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "hung_task_warnings",
 		.data		= &sysctl_hung_task_warnings,
-		.maxlen		= sizeof(unsigned long),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &neg_one,
 	},
 #endif
 #ifdef CONFIG_COMPAT
-- 
1.8.4.2

