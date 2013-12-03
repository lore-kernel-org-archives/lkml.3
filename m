Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3LCVzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:55:45 -0500
Received: from mail-oa0-f73.google.com ([209.85.219.73]:48966 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab3LCVzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:55:43 -0500
From: Ben Zhang <benzh@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Don Zickus <dzickus@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ben Zhang <benzh@chromium.org>
Subject: [PATCH] watchdog: Add a sysctl to disable soft lockup detector
Date: Tue,  3 Dec 2013 13:54:34 -0800
Message-Id: <1386107674-15903-1-git-send-email-benzh@chromium.org>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides usermode a way to disable only the soft
lockup detector while keeping the hard lockup detector
running.

kernel.softlockup_detector_enable=1:
This is the default. The soft lockup detector is enabled.
When a soft lockup is detected, a warning message with
debug info is printed. The kernel may be configured to
panics in this case via the sysctl kernel.softlockup_panic.

kernel.softlockup_detector_enable=0:
The soft lockup detector is disabled. Warning message is
not printed on soft lockup. The kernel does not panic on
soft lockup regardless of the value of kernel.softlockup_panic.
Note kernel.softlockup_detector_enable does not affect
the hard lockup detector.

Signed-off-by: Ben Zhang <benzh@chromium.org>
---
 include/linux/sched.h |  1 +
 kernel/sysctl.c       |  9 +++++++++
 kernel/watchdog.c     | 15 +++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 768b037..93ebec4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -270,6 +270,7 @@ extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
 				  void __user *buffer,
 				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
+extern unsigned int  softlockup_detector_enable;
 void lockup_detector_init(void);
 #else
 static inline void touch_softlockup_watchdog(void)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34a6047..8ae1f36 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -840,6 +840,15 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 	{
+		.procname	= "softlockup_detector_enable",
+		.data		= &softlockup_detector_enable,
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
index 4431610..b9594e6 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -80,6 +80,18 @@ static int __init softlockup_panic_setup(char *str)
 }
 __setup("softlockup_panic=", softlockup_panic_setup);
 
+unsigned int __read_mostly softlockup_detector_enable = 1;
+
+static int __init softlockup_detector_enable_setup(char *str)
+{
+	unsigned long res;
+	if (kstrtoul(str, 0, &res))
+		res = 1;
+	softlockup_detector_enable = res;
+	return 1;
+}
+__setup("softlockup_detector_enable=", softlockup_detector_enable_setup);
+
 static int __init nowatchdog_setup(char *str)
 {
 	watchdog_user_enabled = 0;
@@ -293,6 +305,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		return HRTIMER_RESTART;
 	}
 
+	if (!softlockup_detector_enable)
+		return HRTIMER_RESTART;
+
 	/* check for a softlockup
 	 * This is done by making sure a high priority task is
 	 * being scheduled.  The task touches the watchdog to
-- 
1.8.4.1

