Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3ILFox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:44:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3ILFko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:40:44 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=30hhJTnV670A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jVUhGfaWpGQA:10 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=tHz9FfFoAAAA:8 a=VwQbUJbxAAAA:8 a=oGMlB6cnAAAA:8 a=KKAkSRfTAAAA:8 a=mLnsDVdbAAAA:8 a=DGllHieoAAAA:8 a=ayC55rCoAAAA:8 a=oDolL_PHAAAA:8 a=ESq3jojpAAAA:8 a=T2h1Z_K7z-JURIdn7sYA:9 a=UMgd3SV4NB4A:10 a=Zh68SRI7RUMA:10 a=MSl-tDqOz04A:10 a=7DSvI1NPTFQA:10 a=6O0IECtVFhoA:10 a=LI9Vle30uBYA:10 a=CY6gl2JlH4YA:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=lcDeQFAzrr8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042904.536864111@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, Ingo Molnar <mingo@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        John Stultz <john.stultz@linaro.org>, <xen-devel@lists.xen.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [073/251] hrtimers: Move SMP function call to thread context
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0073-hrtimers-Move-SMP-function-call-to-thread-context.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 5ec2481b7b47a4005bb446d176e5d0257400c77d ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/hrtimer.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e3999c2..e522f9a 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -719,17 +719,20 @@ static int hrtimer_switch_to_hres(void)
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
@@ -779,8 +782,10 @@ void hrtimers_resume(void)
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
1.7.10.4


