Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaAOIMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:12:33 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43437 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaAOIMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:12:31 -0500
Subject: [PATCH V5 3/8] cpuidle/ppc: Split timer_interrupt() into timer
 handling and interrupt handling routines
To: daniel.lezcano@linaro.org, peterz@infradead.org, fweisbec@gmail.com,
        agraf@suse.de, paul.gortmaker@windriver.com, paulus@samba.org,
        mingo@kernel.org, mikey@neuling.org, shangw@linux.vnet.ibm.com,
        rafael.j.wysocki@intel.com, galak@kernel.crashing.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, anton@samba.org, tglx@linutronix.de,
        chenhui.zhao@freescale.com, deepthi@linux.vnet.ibm.com,
        r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 15 Jan 2014 13:38:52 +0530
Message-ID: <20140115080847.20446.36690.stgit@preeti.in.ibm.com>
In-Reply-To: <20140115080555.20446.27238.stgit@preeti.in.ibm.com>
References: <20140115080555.20446.27238.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011508-8236-0000-0000-00000615D15C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split timer_interrupt(), which is the local timer interrupt handler on ppc
into routines called during regular interrupt handling and __timer_interrupt(),
which takes care of running local timers and collecting time related stats.

This will enable callers interested only in running expired local timers to
directly call into __timer_interupt(). One of the use cases of this is the
tick broadcast IPI handling in which the sleeping CPUs need to handle the local
timers that have expired.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/kernel/time.c |   73 +++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 42269c7..42cb603 100644
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
@@ -816,6 +821,10 @@ static void decrementer_set_mode(enum clock_event_mode mode,
 /* Interrupt handler for the timer broadcast IPI */
 void tick_broadcast_ipi_handler(void)
 {
+	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
+
+	*next_tb = get_tb_or_rtc();
+	__timer_interrupt();
 }
 
 static void register_decrementer_clockevent(int cpu)

