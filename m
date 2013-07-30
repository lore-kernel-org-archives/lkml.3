Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab3G3JeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:34:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53451 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab3G3JeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:34:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Konrad Wilk <konrad.wilk@oracle.com>,
        John Stultz <john.stultz@linaro.org>, xen-devel@lists.xen.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 106/106] hrtimers: Move SMP function call to thread context
Date: Tue, 30 Jul 2013 10:32:05 +0100
Message-Id: <1375176725-5825-107-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 5ec2481b7b47a4005bb446d176e5d0257400c77d upstream.

smp_call_function_* must not be called from softirq context.

But clock_was_set() which calls on_each_cpu() is called from softirq
context to implement a delayed clock_was_set() for the timer interrupt
handler. Though that almost never gets invoked. A recent change in the
resume code uses the softirq based delayed clock_was_set to support
Xens resume mechanism.

linux-next contains a new warning which warns if smp_call_function_*
is called from softirq context which gets triggered by that Xen
change.

Fix this by moving the delayed clock_was_set() call to a work context.

Reported-and-tested-by: Artem Savkov <artem.savkov@gmail.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>,
Cc: Konrad Wilk <konrad.wilk@oracle.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: xen-devel@lists.xen.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/hrtimer.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 60f7e32..a57ef25 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -707,17 +707,20 @@ static int hrtimer_switch_to_hres(void)
 	return 1;
 }
 
+static void clock_was_set_work(struct work_struct *work)
+{
+	clock_was_set();
+}
+
+static DECLARE_WORK(hrtimer_work, clock_was_set_work);
+
 /*
- * Called from timekeeping code to reprogramm the hrtimer interrupt
- * device. If called from the timer interrupt context we defer it to
- * softirq context.
+ * Called from timekeeping and resume code to reprogramm the hrtimer
+ * interrupt device on all cpus.
  */
 void clock_was_set_delayed(void)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-
-	cpu_base->clock_was_set = 1;
-	__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+	schedule_work(&hrtimer_work);
 }
 
 #else
@@ -766,8 +769,10 @@ void hrtimers_resume(void)
 	WARN_ONCE(!irqs_disabled(),
 		  KERN_INFO "hrtimers_resume() called with IRQs enabled!");
 
+	/* Retrigger on the local CPU */
 	retrigger_next_event(NULL);
-	timerfd_clock_was_set();
+	/* And schedule a retrigger for all others */
+	clock_was_set_delayed();
 }
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
@@ -1416,13 +1421,6 @@ void hrtimer_peek_ahead_timers(void)
 
 static void run_hrtimer_softirq(struct softirq_action *h)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-
-	if (cpu_base->clock_was_set) {
-		cpu_base->clock_was_set = 0;
-		clock_was_set();
-	}
-
 	hrtimer_peek_ahead_timers();
 }
 
-- 
1.8.3.2

