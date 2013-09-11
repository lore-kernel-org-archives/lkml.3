Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3IKCya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:54:30 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57525 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab3IKCy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:54:28 -0400
Subject: [PATCH V3 3/6] cpuidle/ppc: Split timer_interrupt() into timer
 handling and interrupt handling routines
To: benh@kernel.crashing.org, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, galak@kernel.crashing.org,
        fweisbec@gmail.com, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 08:21:34 +0530
Message-ID: <20130911025134.27726.85426.stgit@preeti.in.ibm.com>
In-Reply-To: <20130911024906.27726.4735.stgit@preeti.in.ibm.com>
References: <20130911024906.27726.4735.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091102-3532-0000-0000-0000015A884D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PowerPC, when CPUs enter deep idle states, their local timers get
switched off. The local timer is called the decrementer. An external clock
device needs to programmed to wake them up at their next timer event.
	On PowerPC, we do not have an external device equivalent to HPET,
which is currently used on architectures like x86 under the same scenario.
Instead we assign the local timer of one of the CPUs to do this job.

On expiry of this timer, the broadcast framework today has the infrastructure
to send ipis to all such CPUs whose local timers have expired.

When such an ipi is received, the cpus in deep idle should handle their
expired timers. It should be as though they were woken up from a
timer interrupt itself. Hence this external ipi serves as an emulated timer
interrupt for the cpus in deep idle.

Therefore ideally on ppc, these cpus should call timer_interrupt() which
is the interrupt handler for a decrementer interrupt. But timer_interrupt()
also contains routines which are usually performed in an interrupt handler.
These are not required to be done in this scenario as the external interrupt
handler takes care of them.

Therefore split up timer_interrupt() into routines performed during regular
interrupt handling and __timer_interrupt(), which takes care of running local
timers and collecting time related stats. Now on a broadcast ipi, call
__timer_interrupt().

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/kernel/time.c |   69 ++++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 0dfa0c5..eb48291 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -478,6 +478,42 @@ void arch_irq_work_raise(void)
 
 #endif /* CONFIG_IRQ_WORK */
 
+static void __timer_interrupt(void)
+{
+	struct pt_regs *regs = get_irq_regs();
+	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
+	struct clock_event_device *evt = &__get_cpu_var(decrementers);
+	u64 now;
+
+	__get_cpu_var(irq_stat).timer_irqs++;
+	trace_timer_interrupt_entry(regs);
+
+	if (test_irq_work_pending()) {
+		clear_irq_work_pending();
+		irq_work_run();
+	}
+
+	now = get_tb_or_rtc();
+	if (now >= *next_tb) {
+		*next_tb = ~(u64)0;
+		if (evt->event_handler)
+			evt->event_handler(evt);
+	} else {
+		now = *next_tb - now;
+		if (now <= DECREMENTER_MAX)
+			set_dec((int)now);
+	}
+
+#ifdef CONFIG_PPC64
+	/* collect purr register values often, for accurate calculations */
+	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
+		struct cpu_usage *cu = &__get_cpu_var(cpu_usage_array);
+		cu->current_tb = mfspr(SPRN_PURR);
+	}
+#endif
+	trace_timer_interrupt_exit(regs);
+}
+
 /*
  * timer_interrupt - gets called when the decrementer overflows,
  * with interrupts disabled.
@@ -486,8 +522,6 @@ void timer_interrupt(struct pt_regs * regs)
 {
 	struct pt_regs *old_regs;
 	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
-	struct clock_event_device *evt = &__get_cpu_var(decrementers);
-	u64 now;
 
 	/* Ensure a positive value is written to the decrementer, or else
 	 * some CPUs will continue to take decrementer exceptions.
@@ -510,8 +544,6 @@ void timer_interrupt(struct pt_regs * regs)
 	 */
 	may_hard_irq_enable();
 
-	__get_cpu_var(irq_stat).timer_irqs++;
-
 #if defined(CONFIG_PPC32) && defined(CONFIG_PMAC)
 	if (atomic_read(&ppc_n_lost_interrupts) != 0)
 		do_IRQ(regs);
@@ -520,34 +552,7 @@ void timer_interrupt(struct pt_regs * regs)
 	old_regs = set_irq_regs(regs);
 	irq_enter();
 
-	trace_timer_interrupt_entry(regs);
-
-	if (test_irq_work_pending()) {
-		clear_irq_work_pending();
-		irq_work_run();
-	}
-
-	now = get_tb_or_rtc();
-	if (now >= *next_tb) {
-		*next_tb = ~(u64)0;
-		if (evt->event_handler)
-			evt->event_handler(evt);
-	} else {
-		now = *next_tb - now;
-		if (now <= DECREMENTER_MAX)
-			set_dec((int)now);
-	}
-
-#ifdef CONFIG_PPC64
-	/* collect purr register values often, for accurate calculations */
-	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
-		struct cpu_usage *cu = &__get_cpu_var(cpu_usage_array);
-		cu->current_tb = mfspr(SPRN_PURR);
-	}
-#endif
-
-	trace_timer_interrupt_exit(regs);
-
+	__timer_interrupt();
 	irq_exit();
 	set_irq_regs(old_regs);
 }

