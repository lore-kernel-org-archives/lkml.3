Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaEBThQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:37:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:44006 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaEBThO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:37:14 -0400
Date: Fri, 2 May 2014 21:37:05 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: spinlock trylock failure on UP, i.MX28 3.12.15-rt25
Message-ID: <20140502193705.GI9178@linutronix.de>
References: <534C3606.7010206@meduna.org>
 <534C731F.1050406@meduna.org>
 <534DADF1.6060608@meduna.org>
 <20140422115439.GA20669@linutronix.de>
 <20140422094657.5b6ca1e2@gandalf.local.home>
 <53569E05.8010600@linutronix.de>
 <20140422134802.73fc1fa4@gandalf.local.home>
 <20140422141650.7f43d5ba@gandalf.local.home>
 <20140502183824.GH9178@linutronix.de>
 <alpine.DEB.2.02.1405022100351.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405022100351.6261@ionos.tec.linutronix.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner | 2014-05-02 21:01:50 [+0200]:

>It's different as it CANNOT fail on UP. That's called from the idle
>code and there is no way that anything holds that lock on UP when idle
>runs.

Okay, so I will add the patch here. The same thing (mostly) but it will
also skip the irq_work_needs_cpu() check since we will run the timer
softirq anyway.

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Fri, 2 May 2014 21:31:50 +0200
Subject: [PATCH] timer: do not spin_trylock() on UP

This will void a warning comming from the spin-lock debugging code. The
lock avoiding idea is from Steven Rostedt.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/timer.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/timer.c b/kernel/timer.c
index 54596b5..8750875 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1455,18 +1455,31 @@ void run_local_timers(void)
 	struct tvec_base *base = __this_cpu_read(tvec_bases);
 
 	hrtimer_run_queues();
 	/*
 	 * We can access this lockless as we are in the timer
 	 * interrupt. If there are no timers queued, nothing to do in
 	 * the timer softirq.
 	 */
 #ifdef CONFIG_PREEMPT_RT_FULL
+
+#ifndef CONFIG_SMP
+	/*
+	 * The spin_do_trylock() later may fail as the lock may be hold before
+	 * the interrupt arrived. The spin-lock debugging code will raise a
+	 * warning if the try_lock fails on UP. Since this is only an
+	 * optimization for the FULL_NO_HZ case (not to run the timer softirq on
+	 * an nohz_full CPU) we don't really care and shedule the softirq.
+	 */
+	raise_softirq(TIMER_SOFTIRQ);
+	return;
+#endif
+
 	/* On RT, irq work runs from softirq */
 	if (irq_work_needs_cpu()) {
 		raise_softirq(TIMER_SOFTIRQ);
 		return;
 	}
 
 	if (!spin_do_trylock(&base->lock)) {
 		raise_softirq(TIMER_SOFTIRQ);
 		return;
-- 
2.0.0.rc0

>Thanks,
>
>	tglx

Sebastian
