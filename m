Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3GEKJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:09:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:44178 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab3GEKJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:09:21 -0400
Date: Fri, 5 Jul 2013 12:09:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Artem Savkov <artem.savkov@gmail.com>
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, david.vrabel@citrix.com
Subject: Re: [tip:timers/core] hrtimers: Support resuming with two or more
 CPUs online (but stopped)
In-Reply-To: <20130705093003.GA4033@cpv436-motbuntu>
Message-ID: <alpine.DEB.2.02.1307051204270.11637@ionos.tec.linutronix.de>
References: <1372329348-20841-2-git-send-email-david.vrabel@citrix.com> <tip-7c4c3a0f18ba57ea2a2985034532303d2929902a@git.kernel.org> <20130705093003.GA4033@cpv436-motbuntu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013, Artem Savkov wrote:

> This commit brings up a warning about a potential deadlock in
> smp_call_function_many() discussed previously:
> https://lkml.org/lkml/2013/4/18/546

> On Fri, Jun 28, 2013 at 02:18:37PM -0700, tip-bot for David Vrabel wrote:
> > Commit-ID:  7c4c3a0f18ba57ea2a2985034532303d2929902a

It's not caused by this commit. The problem was there before. We call
clock_was_set() from softirq context because we cannot call it from
the timer interrupt.

So that new WARN on in the smp code requires us to move that call out
from softirq context.

Does the patch below fix it ?

Thanks,

	tglx

---
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e86827e..24c6f3b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -721,6 +721,18 @@ static int hrtimer_switch_to_hres(void)
 	return 1;
 }
 
+static void clock_was_set_work(struct work_struct *work)
+{
+	clock_was_set();
+}
+
+static DECLARE_WORK(hrtimer_work, clock_was_set_work);
+
+static void softirq_clock_was_set(void)
+{
+	schedule_work(&hrtimer_work);
+}
+
 /*
  * Called from timekeeping code to reprogramm the hrtimer interrupt
  * device. If called from the timer interrupt context we defer it to
@@ -748,7 +760,10 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 }
 static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base) { }
 static inline void retrigger_next_event(void *arg) { }
-
+static void softirq_clock_was_set(void)
+{
+	clock_was_set();
+}
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
 /*
@@ -1445,7 +1460,7 @@ static void run_hrtimer_softirq(struct softirq_action *h)
 
 	if (cpu_base->clock_was_set) {
 		cpu_base->clock_was_set = 0;
-		clock_was_set();
+		softirq_clock_was_set();
 	}
 
 	hrtimer_peek_ahead_timers();


