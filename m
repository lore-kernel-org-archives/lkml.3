Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3IKCyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:54:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42651 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab3IKCyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:54:12 -0400
Subject: [PATCH V3 2/6] powerpc: Implement broadcast timer interrupt as an
 IPI message
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
Date: Wed, 11 Sep 2013 08:21:22 +0530
Message-ID: <20130911025122.27726.84259.stgit@preeti.in.ibm.com>
In-Reply-To: <20130911024906.27726.4735.stgit@preeti.in.ibm.com>
References: <20130911024906.27726.4735.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091102-7182-0000-0000-0000085D7522
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

For scalability and performance reasons, we want the broadcast IPIs
to be handled as efficiently as possible. Fixed IPI messages
are one of the most efficient mechanisms available - they are faster
than the smp_call_function mechanism because the IPI handlers are fixed
and hence they don't involve costly operations such as adding IPI handlers
to the target CPU's function queue, acquiring locks for synchronization etc.

Luckily we have an unused IPI message slot, so use that to implement
broadcast timer interrupts efficiently.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
[Changelog modified by preeti@linux.vnet.ibm.com]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/smp.h          |    3 ++-
 arch/powerpc/include/asm/time.h         |    1 +
 arch/powerpc/kernel/smp.c               |   19 +++++++++++++++----
 arch/powerpc/kernel/time.c              |    4 ++++
 arch/powerpc/platforms/cell/interrupt.c |    2 +-
 arch/powerpc/platforms/ps3/smp.c        |    2 +-
 scripts/kconfig/streamline_config.pl    |    0 
 7 files changed, 24 insertions(+), 7 deletions(-)
 mode change 100644 => 100755 scripts/kconfig/streamline_config.pl

diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
index a632b6e..22f6d63 100644
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -117,7 +117,7 @@ extern int cpu_to_core_id(int cpu);
  *
  * Make sure this matches openpic_request_IPIs in open_pic.c, or what shows up
  * in /proc/interrupts will be wrong!!! --Troy */
-#define PPC_MSG_UNUSED		0
+#define PPC_MSG_TIMER		0
 #define PPC_MSG_RESCHEDULE      1
 #define PPC_MSG_CALL_FUNC_SINGLE	2
 #define PPC_MSG_DEBUGGER_BREAK  3
@@ -194,6 +194,7 @@ extern struct smp_ops_t *smp_ops;
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+extern void arch_send_tick_broadcast(const struct cpumask *mask);
 
 /* Definitions relative to the secondary CPU spin loop
  * and entry point. Not all of them exist on both 32 and
diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index c1f2676..4e35282 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -28,6 +28,7 @@ extern struct clock_event_device decrementer_clockevent;
 struct rtc_time;
 extern void to_tm(int tim, struct rtc_time * tm);
 extern void GregorianDay(struct rtc_time *tm);
+extern void decrementer_timer_interrupt(void);
 
 extern void generic_calibrate_decr(void);
 
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index bc41e9f..d3b7014 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -35,6 +35,7 @@
 #include <asm/ptrace.h>
 #include <linux/atomic.h>
 #include <asm/irq.h>
+#include <asm/hw_irq.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/prom.h>
@@ -111,9 +112,9 @@ int smp_generic_kick_cpu(int nr)
 }
 #endif /* CONFIG_PPC64 */
 
-static irqreturn_t unused_action(int irq, void *data)
+static irqreturn_t timer_action(int irq, void *data)
 {
-	/* This slot is unused and hence available for use, if needed */
+	decrementer_timer_interrupt();
 	return IRQ_HANDLED;
 }
 
@@ -144,14 +145,14 @@ static irqreturn_t debug_ipi_action(int irq, void *data)
 }
 
 static irq_handler_t smp_ipi_action[] = {
-	[PPC_MSG_UNUSED] =  unused_action, /* Slot available for future use */
+	[PPC_MSG_TIMER] =  timer_action,
 	[PPC_MSG_RESCHEDULE] = reschedule_action,
 	[PPC_MSG_CALL_FUNC_SINGLE] = call_function_single_action,
 	[PPC_MSG_DEBUGGER_BREAK] = debug_ipi_action,
 };
 
 const char *smp_ipi_name[] = {
-	[PPC_MSG_UNUSED] =  "ipi unused",
+	[PPC_MSG_TIMER] =  "ipi timer",
 	[PPC_MSG_RESCHEDULE] = "ipi reschedule",
 	[PPC_MSG_CALL_FUNC_SINGLE] = "ipi call function single",
 	[PPC_MSG_DEBUGGER_BREAK] = "ipi debugger",
@@ -221,6 +222,8 @@ irqreturn_t smp_ipi_demux(void)
 		all = xchg(&info->messages, 0);
 
 #ifdef __BIG_ENDIAN
+		if (all & (1 << (24 - 8 * PPC_MSG_TIMER)))
+			decrementer_timer_interrupt();
 		if (all & (1 << (24 - 8 * PPC_MSG_RESCHEDULE)))
 			scheduler_ipi();
 		if (all & (1 << (24 - 8 * PPC_MSG_CALL_FUNC_SINGLE)))
@@ -266,6 +269,14 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 		do_message_pass(cpu, PPC_MSG_CALL_FUNC_SINGLE);
 }
 
+void arch_send_tick_broadcast(const struct cpumask *mask)
+{
+	unsigned int cpu;
+
+	for_each_cpu(cpu, mask)
+		do_message_pass(cpu, PPC_MSG_TIMER);
+}
+
 #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
 void smp_send_debugger_break(void)
 {
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 65ab9e9..0dfa0c5 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -813,6 +813,10 @@ static void decrementer_set_mode(enum clock_event_mode mode,
 		decrementer_set_next_event(DECREMENTER_MAX, dev);
 }
 
+void decrementer_timer_interrupt(void)
+{
+}
+
 static void register_decrementer_clockevent(int cpu)
 {
 	struct clock_event_device *dec = &per_cpu(decrementers, cpu);
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 28166e4..1359113 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -213,7 +213,7 @@ static void iic_request_ipi(int msg)
 
 void iic_request_IPIs(void)
 {
-	iic_request_ipi(PPC_MSG_UNUSED);
+	iic_request_ipi(PPC_MSG_TIMER);
 	iic_request_ipi(PPC_MSG_RESCHEDULE);
 	iic_request_ipi(PPC_MSG_CALL_FUNC_SINGLE);
 	iic_request_ipi(PPC_MSG_DEBUGGER_BREAK);
diff --git a/arch/powerpc/platforms/ps3/smp.c b/arch/powerpc/platforms/ps3/smp.c
index 488f069..5cb742a 100644
--- a/arch/powerpc/platforms/ps3/smp.c
+++ b/arch/powerpc/platforms/ps3/smp.c
@@ -74,7 +74,7 @@ static int __init ps3_smp_probe(void)
 		* to index needs to be setup.
 		*/
 
-		BUILD_BUG_ON(PPC_MSG_UNUSED	      != 0);
+		BUILD_BUG_ON(PPC_MSG_TIMER	      != 0);
 		BUILD_BUG_ON(PPC_MSG_RESCHEDULE       != 1);
 		BUILD_BUG_ON(PPC_MSG_CALL_FUNC_SINGLE != 2);
 		BUILD_BUG_ON(PPC_MSG_DEBUGGER_BREAK   != 3);
diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
old mode 100644
new mode 100755

