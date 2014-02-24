Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaBXQF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:05:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42031 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbaBXQF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:05:57 -0500
Date: Mon, 24 Feb 2014 17:05:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/5] idle: Move idle conditions in cpuidle_idle main
 function
Message-ID: <20140224160543.GZ9987@twins.programming.kicks-ass.net>
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
 <1393250151-6982-4-git-send-email-daniel.lezcano@linaro.org>
 <20140224145912.GW27965@twins.programming.kicks-ass.net>
 <530B679C.6070204@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B679C.6070204@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 04:39:08PM +0100, Daniel Lezcano wrote:

> >And when you do that; you can also push down the
> >current_clr_polling_and_test() muck so it doesn't cover the actual
> >cpuidle policy code.
> 
> I am not getting it. Where do you suggest to move it ?

A little something like so I suppose; only call
current_clr_polling_and_test() right before calling the actual idle
function. Although I suppose cpuidle_enter() can still do all sorts of
weird.

--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -78,37 +78,35 @@ static int cpuidle_idle_call(void)
 	stop_critical_timings();
 	rcu_idle_enter();
 
-	next_state = cpuidle_enabled(drv, dev);
-	if (next_state < 0) {
-		arch_cpu_idle();
-		goto out;
-	}
-
-	/*
-	 * Ask the governor for the next state, this call can fail for
-	 * different reasons: cpuidle is not enabled or an idle state
-	 * fulfilling the constraints was not found. In this case, we
-	 * fall back to the default idle function
-	 */
-	next_state = cpuidle_select(drv, dev);
+	if (cpuidle_enabled(drv, dev) == 0) {
+		/*
+		 * Ask the governor for the next state, this call can fail for
+		 * different reasons: cpuidle is not enabled or an idle state
+		 * fulfilling the constraints was not found. In this case, we
+		 * fall back to the default idle function
+		 */
+		next_state = cpuidle_select(drv, dev);
+
+		if (current_clr_polling_and_test()) {
+			dev->last_residency = 0;
+			entered_state = next_state;
+			local_irq_enable();
+		} else {
+			trace_cpu_idle_rcuidle(next_state, dev->cpu);
+			entered_state = cpuidle_enter(drv, dev, next_state);
+			trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+		}
 
-	if (need_resched()) {
-		dev->last_residency = 0;
 		/* give the governor an opportunity to reflect on the outcome */
-		cpuidle_reflect(dev, next_state);
-		local_irq_enable();
-		goto out;
+		cpuidle_reflect(dev, entered_state);
+	} else {
+		if (current_clr_polling_and_test())
+			local_irq_enable();
+		else
+			arch_cpu_idle();
 	}
+	__current_set_polling();
 
-	trace_cpu_idle_rcuidle(next_state, dev->cpu);
-
-	entered_state = cpuidle_enter(drv, dev, next_state);
-
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
-
-	/* give the governor an opportunity to reflect on the outcome */
-	cpuidle_reflect(dev, entered_state);
-out:
 	if (WARN_ON_ONCE(irqs_disabled()))
 		local_irq_enable();
 
@@ -145,16 +143,11 @@ static void cpu_idle_loop(void)
 			 * know that the IPI is going to arrive right
 			 * away
 			 */
-			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
+			if (cpu_idle_force_poll || tick_check_broadcast_expired())
 				cpu_idle_poll();
-			} else {
-				if (!current_clr_polling_and_test()) {
-					cpuidle_idle_call();
-				} else {
-					local_irq_enable();
-				}
-				__current_set_polling();
-			}
+			else
+				cpu_idle_call();
+
 			arch_cpu_idle_exit();
 			/*
 			 * We need to test and propagate the TIF_NEED_RESCHED
