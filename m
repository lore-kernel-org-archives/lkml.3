Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaATRfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:35:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaATRfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:35:02 -0500
From: atomlin@redhat.com
To: linux-kernel@vger.kernel.org
Cc: rientjes@google.com, mingo@kernel.org, oleg@redhat.com, riel@redhat.com,
        akpm@linux-foundation.org, atomlin@redhat.com
Subject: [RFC PATCH v4 2/2] hung_task: Display every hung task warning
Date: Mon, 20 Jan 2014 17:34:13 +0000
Message-Id: <1390239253-24030-3-git-send-email-atomlin@redhat.com>
In-Reply-To: <1390239253-24030-1-git-send-email-atomlin@redhat.com>
References: <1390239253-24030-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

When khungtaskd detects hung tasks, it prints out
backtraces from a number of those tasks.
Limiting the number of backtraces being printed
out can result in the user not seeing the information
necessary to debug the issue. The hung_task_warnings
sysctl controls this feature.

This patch makes it possible for hung_task_warnings
to accept a special value to print an unlimited
number of backtraces when khungtaskd detects hung
tasks.

The special value is -1. To use this value it is
necessary to change types from ulong to int.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>

---
 Documentation/sysctl/kernel.txt | 42 +++++++++++++++++++++++++++++++++++++++++
 include/linux/sched/sysctl.h    |  2 +-
 kernel/hung_task.c              |  6 ++++--
 kernel/sysctl.c                 |  5 +++--
 4 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 26b7ee4..ff1a167 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -33,6 +33,10 @@ show up in /proc/sys/kernel:
 - domainname
 - hostname
 - hotplug
+- hung_task_panic
+- hung_task_check_count
+- hung_task_timeout_secs
+- hung_task_warnings
 - kptr_restrict
 - kstack_depth_to_print       [ X86 only ]
 - l2cr                        [ PPC only ]
@@ -287,6 +291,44 @@ Default value is "/sbin/hotplug".
 
 ==============================================================
 
+hung_task_panic:
+
+Controls the kernel's behavior when a hung task is detected.
+This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+
+0: continue operation. This is the default behavior.
+
+1: panic immediately.
+
+==============================================================
+
+hung_task_check_count:
+
+The upper bound on the number of tasks that are checked.
+This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+
+==============================================================
+
+hung_task_timeout_secs:
+
+Check interval. When a task in D state did not get scheduled
+for more than this value report a warning.
+This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+
+0: means infinite timeout - no checking done.
+
+==============================================================
+
+hung_task_warning:
+
+The maximum number of warnings to report. During a check interval
+When this value is reached, no more the warnings will be reported.
+This file shows up if CONFIG_DETECT_HUNG_TASK is enabled.
+
+-1: report an infinite number of warnings.
+
+==============================================================
+
 kptr_restrict:
 
 This toggle indicates whether restrictions are placed on
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
index 9328b80..0b9c169 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -37,7 +37,7 @@ int __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
  */
 unsigned long __read_mostly sysctl_hung_task_timeout_secs = CONFIG_DEFAULT_HUNG_TASK_TIMEOUT;
 
-unsigned long __read_mostly sysctl_hung_task_warnings = 10;
+int __read_mostly sysctl_hung_task_warnings = 10;
 
 static int __read_mostly did_panic;
 
@@ -98,7 +98,9 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 
 	if (!sysctl_hung_task_warnings)
 		return;
-	sysctl_hung_task_warnings--;
+
+	if (sysctl_hung_task_warnings > 0)
+		sysctl_hung_task_warnings--;
 
 	/*
 	 * Ok, the task did not get scheduled for more than 2 minutes,
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

