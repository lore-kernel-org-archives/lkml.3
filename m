Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3F0KhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:37:11 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:22463 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3F0Kf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:35:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,951,1363132800"; 
   d="scan'208";a="32154648"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/5] hrtimers: support resuming with two or more CPUs online (but stopped)
Date: Thu, 27 Jun 2013 11:35:44 +0100
Message-ID: <1372329348-20841-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

hrtimers_resume() only reprograms the timers for the current CPU as it
assumes that all other CPUs are offline at this point in the resume
process.  If other CPUs are online then their timers will not be
corrected and they may fire at the wrong time.

When running as a Xen guest, this assumption is not true.  Non-boot
CPUs are only stopped with IRQs disabled instead of offlining them.
This is a performance optimization as disabling the CPUs would add an
unacceptable amount of additional downtime during a live migration (>
200 ms for a 4 VCPU guest).

hrtimers_resume() cannot call on_each_cpu(retrigger_next_event,...)
as the other CPUs will be stopped with IRQs disabled.  Instead, defer
the call to the next softirq.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/xen/manage.c |    3 ---
 kernel/hrtimer.c     |   15 ++++++++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 412b96c..421da85 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -166,9 +166,6 @@ out_resume:
 
 	dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
-	/* Make sure timer events get retriggered on all CPUs */
-	clock_was_set();
-
 out_thaw:
 #ifdef CONFIG_PREEMPT
 	thaw_processes();
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index fd4b13b..e86827e 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -773,15 +773,24 @@ void clock_was_set(void)
 
 /*
  * During resume we might have to reprogram the high resolution timer
- * interrupt (on the local CPU):
+ * interrupt on all online CPUs.  However, all other CPUs will be
+ * stopped with IRQs interrupts disabled so the clock_was_set() call
+ * must be deferred to the softirq.
+ *
+ * The one-shot timer has already been programmed to fire immediately
+ * (see tick_resume_oneshot()) and this interrupt will trigger the
+ * softirq to run early enough to correctly reprogram the timers on
+ * all CPUs.
  */
 void hrtimers_resume(void)
 {
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+
 	WARN_ONCE(!irqs_disabled(),
 		  KERN_INFO "hrtimers_resume() called with IRQs enabled!");
 
-	retrigger_next_event(NULL);
-	timerfd_clock_was_set();
+	cpu_base->clock_was_set = 1;
+	__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
 }
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
-- 
1.7.2.5

