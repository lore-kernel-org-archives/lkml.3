Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbaDVPSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:18:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932904AbaDVPRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:17:44 -0400
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, x86@kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, mguzik@redhat.com,
        Aaron Tomlin <atomlin@redhat.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 4/4 v3] watchdog: Printing traces for all cpus on lockup detection
Date: Tue, 22 Apr 2014 11:17:28 -0400
Message-Id: <1398179848-197479-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1398179848-197479-1-git-send-email-dzickus@redhat.com>
References: <1398179848-197479-1-git-send-email-dzickus@redhat.com>
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

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 Documentation/kernel-parameters.txt |    5 +++++
 Documentation/sysctl/kernel.txt     |   17 +++++++++++++++++
 include/linux/nmi.h                 |    1 +
 kernel/sysctl.c                     |    9 +++++++++
 kernel/watchdog.c                   |   32 ++++++++++++++++++++++++++++++++
 5 files changed, 64 insertions(+), 0 deletions(-)

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
index a17ab63..447775e 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -57,6 +57,7 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *);
 u64 hw_nmi_get_sample_period(int watchdog_thresh);
 extern int watchdog_user_enabled;
 extern int watchdog_thresh;
+extern int sysctl_softlockup_all_cpu_backtrace;
 struct ctl_table;
 extern int proc_dowatchdog(struct ctl_table *, int ,
 			   void __user *, size_t *, loff_t *);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 49e13e1..e3e84f1 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -855,6 +855,15 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 	{
+		.procname	= "softlockup_all_cpu_backtrace",
+		.data		= &sysctl_softlockup_all_cpu_backtrace,
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
index 4431610..9e661de 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -31,6 +31,7 @@
 
 int watchdog_user_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
+int __read_mostly sysctl_softlockup_all_cpu_backtrace;
 static int __read_mostly watchdog_running;
 static u64 __read_mostly sample_period;
 
@@ -47,6 +48,7 @@ static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
+static unsigned long soft_lockup_nmi_warn;
 
 /* boot commands */
 /*
@@ -95,6 +97,13 @@ static int __init nosoftlockup_setup(char *str)
 }
 __setup("nosoftlockup", nosoftlockup_setup);
 /*  */
+static int __init softlockup_all_cpu_backtrace_setup(char *str)
+{
+	sysctl_softlockup_all_cpu_backtrace =
+		!!simple_strtol(str, NULL, 0);
+	return 1;
+}
+__setup("softlockup_all_cpu_backtrace=", softlockup_all_cpu_backtrace_setup);
 
 /*
  * Hard-lockup warnings should be triggered after just a few seconds. Soft-
@@ -267,6 +276,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	unsigned long touch_ts = __this_cpu_read(watchdog_touch_ts);
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
+	int softlockup_all_cpu_backtrace = sysctl_softlockup_all_cpu_backtrace;
 
 	/* kick the hardlockup detector */
 	watchdog_interrupt_count();
@@ -313,6 +323,17 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		if (__this_cpu_read(soft_watchdog_warn) == true)
 			return HRTIMER_RESTART;
 
+		if (softlockup_all_cpu_backtrace) {
+			/* Prevent multiple soft-lockup reports if one cpu is already
+			 * engaged in dumping cpu back traces
+			 */
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
@@ -323,6 +344,17 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		else
 			dump_stack();
 
+		if (softlockup_all_cpu_backtrace) {
+			/* Avoid generating two back traces for current
+			 * given that one is already made above
+			 */
+			trigger_allbutself_cpu_backtrace();
+
+			clear_bit(0, &soft_lockup_nmi_warn);
+			/* Barrier to sync with other cpus */
+			smp_mb__after_clear_bit();
+		}
+
 		if (softlockup_panic)
 			panic("softlockup: hung tasks");
 		__this_cpu_write(soft_watchdog_warn, true);
-- 
1.7.1

