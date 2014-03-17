Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaCQTKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:10:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaCQTKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:10:53 -0400
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Aaron Tomlin <atomlin@redhat.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH] watchdog: Printing traces for all cpus on lockup detection
Date: Mon, 17 Mar 2014 15:10:05 -0400
Message-Id: <1395083405-3091-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

A 'softlockup' is defined as a bug that causes the kernel to
loop in kernel mode for more than a predefined period to
time, without giving other tasks a chance to run.

Currently, upon detection of this condition by the per-cpu
watchdog task, debug information (including a stack trace)
is sent to the system log.

On some occasions, we have observed that the "victim" rather
than the actual "culprit" (i.e. the owner/holder of the
contended resource) is reported to the user.
Often this information has proven to be insufficient to
assist debugging efforts.

To avoid loss of useful debug information, for architectures
which support NMI, this patch makes it possible to improve
soft lockup reporting. This is accomplished by issuing an
NMI to each cpu to obtain a stack trace.

If NMI is not supported we just revert back to the old method.
A sysctl and boot-time parameter is available to toggle this
feature.

[updated kernel-parameters.txt too]

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Suggested-by: Mateusz Guzik <mguzik@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 Documentation/kernel-parameters.txt |    5 +++++
 Documentation/sysctl/kernel.txt     |   17 +++++++++++++++++
 include/linux/nmi.h                 |    1 +
 kernel/sysctl.c                     |    9 +++++++++
 kernel/watchdog.c                   |   35 +++++++++++++++++++++++++++++++++++
 5 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda..80f2a21 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3047,6 +3047,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			[KNL] Should the soft-lockup detector generate panics.
 			Format: <integer>
 
+	softlockup_all_cpu_backtrace=
+			[KNL] Should the soft-lockup detector generate
+			backtraces on all cpus.
+			Format: <integer>
+
 	sonypi.*=	[HW] Sony Programmable I/O Control Device driver
 			See Documentation/laptops/sonypi.txt
 
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index e55124e..b6873b2 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -75,6 +75,7 @@ show up in /proc/sys/kernel:
 - shmall
 - shmmax                      [ sysv ipc ]
 - shmmni
+- softlockup_all_cpu_backtrace
 - stop-a                      [ SPARC only ]
 - sysrq                       ==> Documentation/sysrq.txt
 - tainted
@@ -768,6 +769,22 @@ without users and with a dead originative process will be destroyed.
 
 ==============================================================
 
+softlockup_all_cpu_backtrace:
+
+This value controls the soft lockup detector thread's behavior
+when a soft lockup condition is detected as to whether or not
+to gather further debug information. If enabled, each cpu will
+be issued an NMI and instructed to capture stack trace.
+
+This feature is only applicable for architectures which support
+NMI.
+
+0: do nothing. This is the default behavior.
+
+1: on detection capture more debug information.
+
+==============================================================
+
 tainted:
 
 Non-zero if the kernel has been tainted.  Numeric values, which
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 6a45fb5..d0ce056 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -48,6 +48,7 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *);
 u64 hw_nmi_get_sample_period(int watchdog_thresh);
 extern int watchdog_user_enabled;
 extern int watchdog_thresh;
+extern int softlockup_all_cpu_backtrace;
 struct ctl_table;
 extern int proc_dowatchdog(struct ctl_table *, int ,
 			   void __user *, size_t *, loff_t *);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 49e13e1..66297ac 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -855,6 +855,15 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 	{
+		.procname	= "softlockup_all_cpu_backtrace",
+		.data		= &softlockup_all_cpu_backtrace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
 		.procname       = "nmi_watchdog",
 		.data           = &watchdog_user_enabled,
 		.maxlen         = sizeof (int),
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4431610..24d80cf 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -31,6 +31,7 @@
 
 int watchdog_user_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
+int __read_mostly softlockup_all_cpu_backtrace = 0;
 static int __read_mostly watchdog_running;
 static u64 __read_mostly sample_period;
 
@@ -47,6 +48,7 @@ static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
+static unsigned long soft_lockup_nmi_warn;
 
 /* boot commands */
 /*
@@ -95,6 +97,20 @@ static int __init nosoftlockup_setup(char *str)
 }
 __setup("nosoftlockup", nosoftlockup_setup);
 /*  */
+static int __init softlockup_all_cpu_backtrace_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	softlockup_all_cpu_backtrace = simple_strtoul(str, NULL, 0);
+
+	if (softlockup_all_cpu_backtrace < 0 ||
+		softlockup_all_cpu_backtrace > 1)
+		return -EINVAL;
+
+	return 1;
+}
+__setup("softlockup_all_cpu_backtrace=", softlockup_all_cpu_backtrace_setup);
 
 /*
  * Hard-lockup warnings should be triggered after just a few seconds. Soft-
@@ -313,6 +329,14 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		if (__this_cpu_read(soft_watchdog_warn) == true)
 			return HRTIMER_RESTART;
 
+		if (softlockup_all_cpu_backtrace) {
+			if (test_and_set_bit(0, &soft_lockup_nmi_warn)) {
+				/* Someone else will report us. Let's give up */
+				__this_cpu_write(soft_watchdog_warn, true);
+				return HRTIMER_RESTART;
+			}
+		}
+
 		printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
@@ -323,6 +347,17 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		else
 			dump_stack();
 
+		if (softlockup_all_cpu_backtrace) {
+			/* Inject an NMI to gather a stack trace for
+			 * each cpu in the hope to obtain further
+			 * debug information
+			 */
+			trigger_all_cpu_backtrace();
+
+			clear_bit(0, &soft_lockup_nmi_warn);
+			smp_mb__after_clear_bit();
+		}
+
 		if (softlockup_panic)
 			panic("softlockup: hung tasks");
 		__this_cpu_write(soft_watchdog_warn, true);
-- 
1.7.1

