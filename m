Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab3GPRfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:35:22 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:58744 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933668Ab3GPRfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:35:13 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 10/10] alpha: Use qemu+cserve provided high-res clock and alarm.
Date: Tue, 16 Jul 2013 10:34:18 -0700
Message-Id: <1373996058-13399-11-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373996058-13399-1-git-send-email-rth@twiddle.net>
References: <1373996058-13399-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

QEMU provides a high-resolution timer and alarm; use this for
a clock source and clock event source when available.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/include/asm/pal.h  |  14 ++++++
 arch/alpha/kernel/irq_alpha.c |   2 +-
 arch/alpha/kernel/proto.h     |   2 +-
 arch/alpha/kernel/time.c      | 106 ++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 117 insertions(+), 7 deletions(-)

diff --git a/arch/alpha/include/asm/pal.h b/arch/alpha/include/asm/pal.h
index ccaa49a..5422a47 100644
--- a/arch/alpha/include/asm/pal.h
+++ b/arch/alpha/include/asm/pal.h
@@ -168,5 +168,19 @@ qemu_set_alarm_abs(unsigned long expire)
 		     : "$0", "$18", "$19", "$20", "$21");
 }
 
+static inline unsigned long
+qemu_get_vmtime(void)
+{
+	register unsigned long v0 __asm__("$0");
+	register unsigned long a0 __asm__("$16") = 7;
+
+	asm("call_pal %2 # cserve get_time"
+	    : "=r"(v0), "+r"(a0)
+	    : "i"(PAL_cserve)
+	    : "$17", "$18", "$19", "$20", "$21");
+
+	return v0;
+}
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ALPHA_PAL_H */
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index 49d50e2..00add72 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -214,7 +214,7 @@ process_mcheck_info(unsigned long vector, unsigned long la_ptr,
  */
 
 struct irqaction timer_irqaction = {
-	.handler	= timer_interrupt,
+	.handler	= rtc_timer_interrupt,
 	.name		= "timer",
 };
 
diff --git a/arch/alpha/kernel/proto.h b/arch/alpha/kernel/proto.h
index 175f7a4..db31ffb 100644
--- a/arch/alpha/kernel/proto.h
+++ b/arch/alpha/kernel/proto.h
@@ -140,7 +140,7 @@ extern void handle_ipi(struct pt_regs *);
 /* extern void reset_for_srm(void); */
 
 /* time.c */
-extern irqreturn_t timer_interrupt(int irq, void *dev);
+extern irqreturn_t rtc_timer_interrupt(int irq, void *dev);
 extern void init_clockevent(void);
 extern void common_init_rtc(void);
 extern unsigned long est_cycle_freq;
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index ec45001..3b7601e 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -89,7 +89,7 @@ static inline __u32 rpcc(void)
 static DEFINE_PER_CPU(struct clock_event_device, cpu_ce);
 
 irqreturn_t
-timer_interrupt(int irq, void *dev)
+rtc_timer_interrupt(int irq, void *dev)
 {
 	int cpu = smp_processor_id();
 	struct clock_event_device *ce = &per_cpu(cpu_ce, cpu);
@@ -119,8 +119,8 @@ rtc_ce_set_next_event(unsigned long evt, struct clock_event_device *ce)
 	return -EINVAL;
 }
 
-void __init
-init_clockevent(void)
+static void __init
+init_rtc_clockevent(void)
 {
 	int cpu = smp_processor_id();
 	struct clock_event_device *ce = &per_cpu(cpu_ce, cpu);
@@ -137,6 +137,83 @@ init_clockevent(void)
 	clockevents_config_and_register(ce, CONFIG_HZ, 0, 0);
 }
 
+
+/*
+ * The QEMU clock as a clocksource primitive.
+ */
+
+static cycle_t
+qemu_cs_read(struct clocksource *cs)
+{
+	return qemu_get_vmtime();
+}
+
+static struct clocksource qemu_cs = {
+	.name                   = "qemu",
+	.rating                 = 400,
+	.read                   = qemu_cs_read,
+	.mask                   = CLOCKSOURCE_MASK(64),
+	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS,
+	.mult			= 1,
+	.shift			= 0,
+	.max_idle_ns		= LONG_MAX
+};
+
+/*
+ * The QEMU clock and alarm as a clock_event_device primitive.
+ */
+
+
+static void
+qemu_ce_set_mode(enum clock_event_mode mode, struct clock_event_device *ce)
+{
+	/* The mode member of CE is updated for us in generic code.
+	   Just make sure that the event is disabled.  */
+	qemu_set_alarm_abs(0);
+}
+
+static int
+qemu_ce_set_next_event(unsigned long evt, struct clock_event_device *ce)
+{
+	qemu_set_alarm_rel(evt);
+	return 0;
+}
+
+static irqreturn_t
+qemu_timer_interrupt(int irq, void *dev)
+{
+	int cpu = smp_processor_id();
+	struct clock_event_device *ce = &per_cpu(cpu_ce, cpu);
+
+	ce->event_handler(ce);
+	return IRQ_HANDLED;
+}
+
+static void __init
+init_qemu_clockevent(void)
+{
+	int cpu = smp_processor_id();
+	struct clock_event_device *ce = &per_cpu(cpu_ce, cpu);
+
+	*ce = (struct clock_event_device){
+		.name = "qemu",
+		.features = CLOCK_EVT_FEAT_ONESHOT,
+		.min_delta_ns = 1000,
+		.min_delta_ticks = 1000,
+		.max_delta_ns = LONG_MAX,
+		.max_delta_ticks = LONG_MAX,
+		.mult = 1,
+		.shift = 0,
+		.rating = 400,
+		.cpumask = cpumask_of(cpu),
+		.set_mode = qemu_ce_set_mode,
+		.set_next_event = qemu_ce_set_next_event,
+	};
+
+	clockevents_register_device(ce);
+}
+
+
 void __init
 common_init_rtc(void)
 {
@@ -324,6 +401,15 @@ time_init(void)
 	unsigned long cycle_freq, tolerance;
 	long diff;
 
+	if (alpha_using_qemu) {
+		clocksource_register(&qemu_cs);
+		init_qemu_clockevent();
+
+		timer_irqaction.handler = qemu_timer_interrupt;
+		init_rtc_irq();
+		return;
+	}
+
 	/* Calibrate CPU clock -- attempt #1.  */
 	if (!est_cycle_freq)
 		est_cycle_freq = validate_cc_value(calibrate_cc_with_pit());
@@ -363,7 +449,17 @@ time_init(void)
 
 	/* Startup the timer source. */
 	alpha_mv.init_rtc();
+	init_rtc_clockevent();
+}
 
-	/* Start up the clock event device.  */
-	init_clockevent();
+/* Initialize the clock_event_device for secondary cpus.  */
+#ifdef CONFIG_SMP
+void __init
+init_clockevent(void)
+{
+	if (alpha_using_qemu)
+		init_qemu_clockevent();
+	else
+		init_rtc_clockevent();
 }
+#endif
-- 
1.8.1.4

