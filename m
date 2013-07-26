Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab3GZUxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:53:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760011Ab3GZUs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, Ingo Molnar <mingo@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        xen-devel@lists.xen.org
Subject: [ 76/79] hrtimers: Move SMP function call to thread context
Date: Fri, 26 Jul 2013 13:48:06 -0700
Message-Id: <20130726204730.788417658@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/hrtimer.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -721,17 +721,20 @@ static int hrtimer_switch_to_hres(void)
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
@@ -780,8 +783,10 @@ void hrtimers_resume(void)
 	WARN_ONCE(!irqs_disabled(),
 		  KERN_INFO "hrtimers_resume() called with IRQs enabled!");
 
+	/* Retrigger on the local CPU */
 	retrigger_next_event(NULL);
-	timerfd_clock_was_set();
+	/* And schedule a retrigger for all others */
+	clock_was_set_delayed();
 }
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
@@ -1432,13 +1437,6 @@ void hrtimer_peek_ahead_timers(void)
 
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
 


