Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaAYO0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:26:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52586 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbaAYO0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:26:20 -0500
Date: Sat, 25 Jan 2014 06:26:01 -0800
From: tip-bot for Aaron Tomlin <tipbot@zytor.com>
Message-ID: <tip-270750dbc18a71b23d660df110e433ff9616a2d4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, atomlin@redhat.com, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, atomlin@redhat.com,
        rientjes@google.com
In-Reply-To: <1390239253-24030-3-git-send-email-atomlin@redhat.com>
References: <1390239253-24030-3-git-send-email-atomlin@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] hung_task: Display every hung task warning
Git-Commit-ID: 270750dbc18a71b23d660df110e433ff9616a2d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:26:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  270750dbc18a71b23d660df110e433ff9616a2d4
Gitweb:     http://git.kernel.org/tip/270750dbc18a71b23d660df110e433ff9616a2d4
Author:     Aaron Tomlin <atomlin@redhat.com>
AuthorDate: Mon, 20 Jan 2014 17:34:13 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 12:13:33 +0100

hung_task: Display every hung task warning

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
Acked-by: David Rientjes <rientjes@google.com>
Cc: oleg@redhat.com
Link: http://lkml.kernel.org/r/1390239253-24030-3-git-send-email-atomlin@redhat.com
[ Build warning fix. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/sysctl/kernel.txt | 42 +++++++++++++++++++++++++++++++++++++++++
 include/linux/sched/sysctl.h    |  2 +-
 kernel/hung_task.c              |  6 ++++--
 kernel/sysctl.c                 |  8 +++++---
 4 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 6d48640..4205f3c 100644
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
index 31e0193..3a93f84 100644
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
index c398a58..dd5b449 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -122,7 +122,8 @@ extern int blk_iopoll_enabled;
 static int sixty = 60;
 #endif
 
-static int neg_one = -1;
+static int __maybe_unused neg_one = -1;
+
 static int zero;
 static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
@@ -978,9 +979,10 @@ static struct ctl_table kern_table[] = {
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
