Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3FTTNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:13:47 -0400
Received: from smtp.citrix.com ([66.165.176.89]:54346 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758101Ab3FTTNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:13:44 -0400
X-IronPort-AV: E=Sophos;i="4.87,906,1363132800"; 
   d="scan'208";a="32469512"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] hrtimers: provide a hrtimers_late_resume() call
Date: Thu, 20 Jun 2013 20:13:38 +0100
Message-ID: <1371755619-25348-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1371755619-25348-1-git-send-email-david.vrabel@citrix.com>
References: <1371755619-25348-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Xen suspends (and resumes) without disabling non-boot CPUs as doing so
adds considerable delay to live migrations.  A 4 VCPU guest had more
than 200 ms of additional downtime if disable_nonboot_cpus() was
called prior to suspending.

As a consequence, only high resolution timers on the current CPU are
retriggered when resuming.  The Xen resume path worked around this
with a call to clock_was_set() to retrigger timers on all the CPUs.

A subsequent change will make clock_was_set() internal to hrtimers so
add an new call (hrtimers_late_resume()) to do the same job.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/xen/manage.c    |    8 ++++++--
 include/linux/hrtimer.h |    1 +
 kernel/hrtimer.c        |    9 +++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 412b96c..75bc2d5 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -166,8 +166,12 @@ out_resume:
 
 	dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
-	/* Make sure timer events get retriggered on all CPUs */
-	clock_was_set();
+	/*
+	 * syscore_resume() ends up calling hrtimer_resume() but this
+	 * only retriggers timer events on the current CPU.  We need
+	 * to retrigger the events on all the other CPUS.
+	 */
+	hrtimers_late_resume();
 
 out_thaw:
 #ifdef CONFIG_PREEMPT
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index d19a5c2..13df0fa 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -323,6 +323,7 @@ extern void timerfd_clock_was_set(void);
 static inline void timerfd_clock_was_set(void) { }
 #endif
 extern void hrtimers_resume(void);
+extern void hrtimers_late_resume(void);
 
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index fd4b13b..34384b4 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -784,6 +784,15 @@ void hrtimers_resume(void)
 	timerfd_clock_was_set();
 }
 
+/*
+ * If non-boot CPUs were online during resume, we need to retrigger
+ * the events for all the non-boot CPUs.
+ */
+void hrtimers_late_resume(void)
+{
+	clock_was_set();
+}
+
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 {
 #ifdef CONFIG_TIMER_STATS
-- 
1.7.2.5

