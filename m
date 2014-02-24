Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaBXRWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:22:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44227 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaBXRWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:22:16 -0500
Date: Mon, 24 Feb 2014 18:22:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/5] idle: Move idle conditions in cpuidle_idle main
 function
Message-ID: <20140224172207.GC9987@twins.programming.kicks-ass.net>
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org>
 <1393250151-6982-4-git-send-email-daniel.lezcano@linaro.org>
 <20140224145912.GW27965@twins.programming.kicks-ass.net>
 <530B679C.6070204@linaro.org>
 <20140224160543.GZ9987@twins.programming.kicks-ass.net>
 <530B7B4E.50306@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B7B4E.50306@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 06:03:10PM +0100, Daniel Lezcano wrote:
> Well there is the polling idle state for the x86 and ppc cpuidle drivers.
> Except that, I think we have something more or less clean.

Yeah, they have to set it back to polling again :/

Ideally we'd sweep the entire tree and switch the default polling state
to polling and add a current_clr_polling_and_test() to all WFI/HLT like
ones that need the interrupt.

But lots of work that.

> >-	if (need_resched()) {
> 
> Ok. The need_resched is now replaced by 'current_clr_polling_and_test', with
> a call to '__current_set_polling()' to set the flag back, right ?

Yah.

> For my personal information, what is the subtlety with:
> 
> if (tif_need_resched())
> 	set_preempt_need_resched();
> 
> ?

Urgh, looks like something went wrong with: cf37b6b48428d 

That commit doesn't actually remove kernel/cpu/idle.c nor is the new
code an exact replica of the old one.

Ingo, any chance we can get that fixed?

Daniel; does the below change/comment clarify?


---
Subject: sched/idle: Fixup merge fail of idle.c move

Commit cf37b6b48428d ("sched/idle: Move cpu/idle.c to sched/idle.c")
said to simply move a file; somehow it got mangled and created an old
version of the file and forgot to remove the old file.

Fix this fail; add the lost change and remove the now identical old
file.

Cc: Nicolas Pitre <nico@linaro.org>
Fixes: cf37b6b48428d ("sched/idle: Move cpu/idle.c to sched/idle.c")
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/cpu/idle.c   | 147 ----------------------------------------------------
 kernel/sched/idle.c |  17 +++---
 2 files changed, 10 insertions(+), 154 deletions(-)

diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
deleted file mode 100644
index b7976a127178..000000000000
--- a/kernel/cpu/idle.c
+++ /dev/null
@@ -1,147 +0,0 @@
-/*
- * Generic entry point for the idle threads
- */
-#include <linux/sched.h>
-#include <linux/cpu.h>
-#include <linux/cpuidle.h>
-#include <linux/tick.h>
-#include <linux/mm.h>
-#include <linux/stackprotector.h>
-
-#include <asm/tlb.h>
-
-#include <trace/events/power.h>
-
-static int __read_mostly cpu_idle_force_poll;
-
-void cpu_idle_poll_ctrl(bool enable)
-{
-	if (enable) {
-		cpu_idle_force_poll++;
-	} else {
-		cpu_idle_force_poll--;
-		WARN_ON_ONCE(cpu_idle_force_poll < 0);
-	}
-}
-
-#ifdef CONFIG_GENERIC_IDLE_POLL_SETUP
-static int __init cpu_idle_poll_setup(char *__unused)
-{
-	cpu_idle_force_poll = 1;
-	return 1;
-}
-__setup("nohlt", cpu_idle_poll_setup);
-
-static int __init cpu_idle_nopoll_setup(char *__unused)
-{
-	cpu_idle_force_poll = 0;
-	return 1;
-}
-__setup("hlt", cpu_idle_nopoll_setup);
-#endif
-
-static inline int cpu_idle_poll(void)
-{
-	rcu_idle_enter();
-	trace_cpu_idle_rcuidle(0, smp_processor_id());
-	local_irq_enable();
-	while (!tif_need_resched())
-		cpu_relax();
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
-	rcu_idle_exit();
-	return 1;
-}
-
-/* Weak implementations for optional arch specific functions */
-void __weak arch_cpu_idle_prepare(void) { }
-void __weak arch_cpu_idle_enter(void) { }
-void __weak arch_cpu_idle_exit(void) { }
-void __weak arch_cpu_idle_dead(void) { }
-void __weak arch_cpu_idle(void)
-{
-	cpu_idle_force_poll = 1;
-	local_irq_enable();
-}
-
-/*
- * Generic idle loop implementation
- */
-static void cpu_idle_loop(void)
-{
-	while (1) {
-		tick_nohz_idle_enter();
-
-		while (!need_resched()) {
-			check_pgt_cache();
-			rmb();
-
-			if (cpu_is_offline(smp_processor_id()))
-				arch_cpu_idle_dead();
-
-			local_irq_disable();
-			arch_cpu_idle_enter();
-
-			/*
-			 * In poll mode we reenable interrupts and spin.
-			 *
-			 * Also if we detected in the wakeup from idle
-			 * path that the tick broadcast device expired
-			 * for us, we don't want to go deep idle as we
-			 * know that the IPI is going to arrive right
-			 * away
-			 */
-			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
-				cpu_idle_poll();
-			} else {
-				if (!current_clr_polling_and_test()) {
-					stop_critical_timings();
-					rcu_idle_enter();
-					if (cpuidle_idle_call())
-						arch_cpu_idle();
-					if (WARN_ON_ONCE(irqs_disabled()))
-						local_irq_enable();
-					rcu_idle_exit();
-					start_critical_timings();
-				} else {
-					local_irq_enable();
-				}
-				__current_set_polling();
-			}
-			arch_cpu_idle_exit();
-		}
-
-		/*
-		 * Since we fell out of the loop above, we know
-		 * TIF_NEED_RESCHED must be set, propagate it into
-		 * PREEMPT_NEED_RESCHED.
-		 *
-		 * This is required because for polling idle loops we will
-		 * not have had an IPI to fold the state for us.
-		 */
-		preempt_set_need_resched();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
-void cpu_startup_entry(enum cpuhp_state state)
-{
-	/*
-	 * This #ifdef needs to die, but it's too late in the cycle to
-	 * make this generic (arm and sh have never invoked the canary
-	 * init for the non boot cpus!). Will be fixed in 3.11
-	 */
-#ifdef CONFIG_X86
-	/*
-	 * If we're the non-boot CPU, nothing set the stack canary up
-	 * for us. The boot CPU already has it initialized but no harm
-	 * in doing it again. This is a good place for updating it, as
-	 * we wont ever return from this function (so the invalid
-	 * canaries already on the stack wont ever trigger).
-	 */
-	boot_init_stack_canary();
-#endif
-	__current_set_polling();
-	arch_cpu_idle_prepare();
-	cpu_idle_loop();
-}
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 14ca43430aee..b7976a127178 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -108,14 +108,17 @@ static void cpu_idle_loop(void)
 				__current_set_polling();
 			}
 			arch_cpu_idle_exit();
-			/*
-			 * We need to test and propagate the TIF_NEED_RESCHED
-			 * bit here because we might not have send the
-			 * reschedule IPI to idle tasks.
-			 */
-			if (tif_need_resched())
-				set_preempt_need_resched();
 		}
+
+		/*
+		 * Since we fell out of the loop above, we know
+		 * TIF_NEED_RESCHED must be set, propagate it into
+		 * PREEMPT_NEED_RESCHED.
+		 *
+		 * This is required because for polling idle loops we will
+		 * not have had an IPI to fold the state for us.
+		 */
+		preempt_set_need_resched();
 		tick_nohz_idle_exit();
 		schedule_preempt_disabled();
 	}
