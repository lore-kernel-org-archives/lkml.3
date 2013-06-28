Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3F1VTC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:19:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49078 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab3F1VTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:19:00 -0400
Date: Fri, 28 Jun 2013 14:18:37 -0700
From: tip-bot for David Vrabel <tipbot@zytor.com>
Message-ID: <tip-7c4c3a0f18ba57ea2a2985034532303d2929902a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, tglx@linutronix.de, david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, tglx@linutronix.de, david.vrabel@citrix.com
In-Reply-To: <1372329348-20841-2-git-send-email-david.vrabel@citrix.com>
References: <1372329348-20841-2-git-send-email-david.vrabel@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] hrtimers:
  Support resuming with two or more CPUs online (but stopped)
Git-Commit-ID: 7c4c3a0f18ba57ea2a2985034532303d2929902a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 14:18:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c4c3a0f18ba57ea2a2985034532303d2929902a
Gitweb:     http://git.kernel.org/tip/7c4c3a0f18ba57ea2a2985034532303d2929902a
Author:     David Vrabel <david.vrabel@citrix.com>
AuthorDate: Thu, 27 Jun 2013 11:35:44 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2013 23:15:06 +0200

hrtimers: Support resuming with two or more CPUs online (but stopped)

hrtimers_resume() only reprograms the timers for the current CPU as it
assumes that all other CPUs are offline at this point in the resume
process. If other CPUs are online then their timers will not be
corrected and they may fire at the wrong time.

When running as a Xen guest, this assumption is not true.  Non-boot
CPUs are only stopped with IRQs disabled instead of offlining them.
This is a performance optimization as disabling the CPUs would add an
unacceptable amount of additional downtime during a live migration (>
200 ms for a 4 VCPU guest).

hrtimers_resume() cannot call on_each_cpu(retrigger_next_event,...)
as the other CPUs will be stopped with IRQs disabled.  Instead, defer
the call to the next softirq.

[ tglx: Separated the xen change out ]

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk  <konrad.wilk@oracle.com>
Cc: John Stultz  <john.stultz@linaro.org>
Cc: <xen-devel@lists.xen.org>
Link: http://lkml.kernel.org/r/1372329348-20841-2-git-send-email-david.vrabel@citrix.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/hrtimer.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

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
