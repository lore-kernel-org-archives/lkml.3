Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbaEKXfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 19:35:37 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:52214 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbaEKXeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 19:34:05 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/5] irq_work: Architecture support for remote irq work raise
Date: Mon, 12 May 2014 01:33:53 +0200
Message-Id: <1399851237-2226-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
References: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to extend irq work to support remote queuing.

So lets add a cpu argument to arch_irq_work_raise(). The architectures
willing to support that must then provide the backend to raise irq work
IPIs remotely.

Initial support is provided for x86 and ARM since they are easily
extended. The other archs that overwrite arch_irq_work_raise() seem
to use local clock interrupts and therefore need deeper rewrite of their
irq work support to implement remote raising.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/Kconfig               | 12 ++++++++++++
 arch/alpha/kernel/time.c   |  3 ++-
 arch/arm/Kconfig           |  1 +
 arch/arm/kernel/smp.c      |  4 ++--
 arch/powerpc/kernel/time.c |  3 ++-
 arch/sparc/kernel/pcr.c    |  3 ++-
 arch/x86/Kconfig           |  1 +
 arch/x86/kernel/irq_work.c | 10 ++--------
 kernel/irq_work.c          |  4 ++--
 9 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 97ff872..3a38356 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -472,6 +472,18 @@ config HAVE_IRQ_EXIT_ON_IRQ_STACK
 	  This spares a stack switch and improves cache usage on softirq
 	  processing.
 
+config HAVE_IRQ_WORK_IPI
+	bool
+	help
+	  Architecture supports raising irq work interrupts both locally and
+	  remotely. Without this capability, we can only trigger local irq works
+	  loosely handled by the generic timer tick with the bad implications
+	  coming along: the irq work is subject to HZ latency and it runs under
+	  the tick random locking scenario (possibly holding hrtimer lock).
+
+	  This capability is required on configs running with a very minimized
+	  tick rate like full dynticks.
+
 #
 # ABI hall of shame
 #
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index ee39cee..2ff0c61 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -60,8 +60,9 @@ DEFINE_PER_CPU(u8, irq_work_pending);
 #define test_irq_work_pending()      __get_cpu_var(irq_work_pending)
 #define clear_irq_work_pending()     __get_cpu_var(irq_work_pending) = 0
 
-void arch_irq_work_raise(void)
+void arch_irq_work_raise(int cpu)
 {
+	WARN_ON_ONCE(cpu != smp_processor_id());
 	set_irq_work_pending_flag();
 }
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index db3c541..7edce21 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -46,6 +46,7 @@ config ARM
 	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7))
 	select HAVE_IDE if PCI || ISA || PCMCIA
 	select HAVE_IRQ_TIME_ACCOUNTING
+	select HAVE_IRQ_WORK_IPI
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZ4
 	select HAVE_KERNEL_LZMA
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 7c4fada..042a800 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -454,10 +454,10 @@ void arch_send_call_function_single_ipi(int cpu)
 }
 
 #ifdef CONFIG_IRQ_WORK
-void arch_irq_work_raise(void)
+void arch_irq_work_raise(int cpu)
 {
 	if (is_smp())
-		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
+		smp_cross_call(cpumask_of(cpu), IPI_IRQ_WORK);
 }
 #endif
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 122a580..4de25f4 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -464,9 +464,10 @@ DEFINE_PER_CPU(u8, irq_work_pending);
 
 #endif /* 32 vs 64 bit */
 
-void arch_irq_work_raise(void)
+void arch_irq_work_raise(int cpu)
 {
 	preempt_disable();
+	WARN_ON_ONCE(cpu != smp_processor_id());
 	set_irq_work_pending_flag();
 	set_dec(1);
 	preempt_enable();
diff --git a/arch/sparc/kernel/pcr.c b/arch/sparc/kernel/pcr.c
index 269af58..0e5bfd9 100644
--- a/arch/sparc/kernel/pcr.c
+++ b/arch/sparc/kernel/pcr.c
@@ -43,8 +43,9 @@ void __irq_entry deferred_pcr_work_irq(int irq, struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
-void arch_irq_work_raise(void)
+void arch_irq_work_raise(int cpu)
 {
+	WARN_ON_ONCE(cpu != smp_processor_id());
 	set_softint(1 << PIL_DEFERRED_PCR_WORK);
 }
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..b06f3fd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -130,6 +130,7 @@ config X86
 	select HAVE_CC_STACKPROTECTOR
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_IRQ_WORK_IPI
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index 1de84e3..500ec1f 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -38,13 +38,7 @@ __visible void smp_trace_irq_work_interrupt(struct pt_regs *regs)
 	exiting_irq();
 }
 
-void arch_irq_work_raise(void)
+void arch_irq_work_raise(int cpu)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
-	if (!cpu_has_apic)
-		return;
-
-	apic->send_IPI_self(IRQ_WORK_VECTOR);
-	apic_wait_icr_idle();
-#endif
+	apic->send_IPI_mask(cpumask_of(cpu), IRQ_WORK_VECTOR);
 }
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index a82170e..2559383 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -48,7 +48,7 @@ static bool irq_work_claim(struct irq_work *work)
 	return true;
 }
 
-void __weak arch_irq_work_raise(void)
+void __weak arch_irq_work_raise(int cpu)
 {
 	/*
 	 * Lame architectures will get the timer tick callback
@@ -79,7 +79,7 @@ bool irq_work_queue(struct irq_work *work)
 	 */
 	if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
 		if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
-			arch_irq_work_raise();
+			arch_irq_work_raise(smp_processor_id());
 	}
 
 	preempt_enable();
-- 
1.8.3.1

