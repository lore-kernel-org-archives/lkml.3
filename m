Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaBJCmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:42:08 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36456 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaBJCmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:42:05 -0500
Subject: [RESEND PATCH 3/3] cpuidle/ppc: Split timer_interrupt() into timer
 handling and interrupt handling routines
To: benh@kernel.crashing.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: deepthi@linux.vnet.ibm.com, arnd@arndb.de, geoff@infradead.org,
        mpe@ellerman.id.au, paul.gortmaker@windriver.com, paulus@samba.org,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Date: Mon, 10 Feb 2014 08:08:25 +0530
Message-ID: <20140210023824.19345.48767.stgit@preeti>
In-Reply-To: <20140210023503.19345.30567.stgit@preeti>
References: <20140210023503.19345.30567.stgit@preeti>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021002-5806-0000-0000-000024176CCC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Split timer_interrupt(), which is the local timer interrupt handler on ppc
into routines called during regular interrupt handling and __timer_interrupt(),
which takes care of running local timers and collecting time related stats.

This will enable callers interested only in running expired local timers to
directly call into __timer_interupt(). One of the use cases of this is the
tick broadcast IPI handling in which the sleeping CPUs need to handle the local
timers that have expired.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/kernel/time.c |   81 +++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 35 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 3ff97db..df2989b 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -478,6 +478,47 @@ void arch_irq_work_raise(void)
 
 #endif /* CONFIG_IRQ_WORK */
 
+void __timer_interrupt(void)
+{
+	struct pt_regs *regs = get_irq_regs();
+	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
+	struct clock_event_device *evt = &__get_cpu_var(decrementers);
+	u64 now;
+
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
+		__get_cpu_var(irq_stat).timer_irqs_event++;
+	} else {
+		now = *next_tb - now;
+		if (now <= DECREMENTER_MAX)
+			set_dec((int)now);
+		/* We may have raced with new irq work */
+		if (test_irq_work_pending())
+			set_dec(1);
+		__get_cpu_var(irq_stat).timer_irqs_others++;
+	}
+
+#ifdef CONFIG_PPC64
+	/* collect purr register values often, for accurate calculations */
+	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
+		struct cpu_usage *cu = &__get_cpu_var(cpu_usage_array);
+		cu->current_tb = mfspr(SPRN_PURR);
+	}
+#endif
+
+	trace_timer_interrupt_exit(regs);
+}
+
 /*
  * timer_interrupt - gets called when the decrementer overflows,
  * with interrupts disabled.
@@ -486,8 +527,6 @@ void timer_interrupt(struct pt_regs * regs)
 {
 	struct pt_regs *old_regs;
 	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
-	struct clock_event_device *evt = &__get_cpu_var(decrementers);
-	u64 now;
 
 	/* Ensure a positive value is written to the decrementer, or else
 	 * some CPUs will continue to take decrementer exceptions.
@@ -519,39 +558,7 @@ void timer_interrupt(struct pt_regs * regs)
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
-		__get_cpu_var(irq_stat).timer_irqs_event++;
-	} else {
-		now = *next_tb - now;
-		if (now <= DECREMENTER_MAX)
-			set_dec((int)now);
-		/* We may have raced with new irq work */
-		if (test_irq_work_pending())
-			set_dec(1);
-		__get_cpu_var(irq_stat).timer_irqs_others++;
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
@@ -828,6 +835,10 @@ static void decrementer_set_mode(enum clock_event_mode mode,
 /* Interrupt handler for the timer broadcast IPI */
 void tick_broadcast_ipi_handler(void)
 {
+	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
+
+	*next_tb = get_tb_or_rtc();
+	__timer_interrupt();
 }
 
 static void register_decrementer_clockevent(int cpu)

