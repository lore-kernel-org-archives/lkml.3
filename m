Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaJTTFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:05:05 -0400
Received: from mail-qg0-f74.google.com ([209.85.192.74]:34414 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbaJTTER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:17 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/19] clocksource: mips-gic: Use CPU notifiers to setup the timer
Date: Mon, 20 Oct 2014 12:04:04 -0700
Message-Id: <1413831846-32100-18-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of requiring an explicit call to gic_clockevent_init in the SMP
startup path, use CPU notifiers to register and enable the GIC timer on
CPU startup.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/include/asm/time.h         |  5 +--
 drivers/clocksource/mips-gic-timer.c | 60 ++++++++++++++++++++++++++----------
 2 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/arch/mips/include/asm/time.h b/arch/mips/include/asm/time.h
index 5f30aab..8ab2874 100644
--- a/arch/mips/include/asm/time.h
+++ b/arch/mips/include/asm/time.h
@@ -53,13 +53,10 @@ extern int __weak get_c0_perfcount_int(void);
  */
 extern unsigned int __weak get_c0_compare_int(void);
 extern int r4k_clockevent_init(void);
-extern int gic_clockevent_init(void);
 
 static inline int mips_clockevent_init(void)
 {
-#if   defined(CONFIG_CLKSRC_MIPS_GIC)
-	return (gic_clockevent_init() | r4k_clockevent_init());
-#elif defined(CONFIG_CEVT_R4K)
+#ifdef CONFIG_CEVT_R4K
 	return r4k_clockevent_init();
 #else
 	return -ENXIO;
diff --git a/drivers/clocksource/mips-gic-timer.c b/drivers/clocksource/mips-gic-timer.c
index 05bdfe1..3ce992b 100644
--- a/drivers/clocksource/mips-gic-timer.c
+++ b/drivers/clocksource/mips-gic-timer.c
@@ -6,9 +6,11 @@
  * Copyright (C) 2012 MIPS Technologies, Inc.  All rights reserved.
  */
 #include <linux/clockchips.h>
+#include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irqchip/mips-gic.h>
+#include <linux/notifier.h>
 #include <linux/percpu.h>
 #include <linux/smp.h>
 #include <linux/time.h>
@@ -16,7 +18,7 @@
 #include <asm/time.h>
 
 static DEFINE_PER_CPU(struct clock_event_device, gic_clockevent_device);
-static int gic_timer_irq_installed;
+static int gic_timer_irq;
 static unsigned int gic_frequency;
 
 static int gic_next_event(unsigned long delta, struct clock_event_device *evt)
@@ -53,18 +55,9 @@ struct irqaction gic_compare_irqaction = {
 	.name = "timer",
 };
 
-int gic_clockevent_init(void)
+static void gic_clockevent_cpu_init(struct clock_event_device *cd)
 {
 	unsigned int cpu = smp_processor_id();
-	struct clock_event_device *cd;
-	unsigned int irq;
-
-	if (!cpu_has_counter || !gic_frequency)
-		return -ENXIO;
-
-	irq = MIPS_GIC_IRQ_BASE + GIC_LOCAL_TO_HWIRQ(GIC_LOCAL_INT_COMPARE);
-
-	cd = &per_cpu(gic_clockevent_device, cpu);
 
 	cd->name		= "MIPS GIC";
 	cd->features		= CLOCK_EVT_FEAT_ONESHOT |
@@ -77,19 +70,52 @@ int gic_clockevent_init(void)
 	cd->min_delta_ns	= clockevent_delta2ns(0x300, cd);
 
 	cd->rating		= 300;
-	cd->irq			= irq;
+	cd->irq			= gic_timer_irq;
 	cd->cpumask		= cpumask_of(cpu);
 	cd->set_next_event	= gic_next_event;
 	cd->set_mode		= gic_set_clock_mode;
 
 	clockevents_register_device(cd);
 
-	if (!gic_timer_irq_installed) {
-		setup_percpu_irq(irq, &gic_compare_irqaction);
-		gic_timer_irq_installed = 1;
+	enable_percpu_irq(gic_timer_irq, IRQ_TYPE_NONE);
+}
+
+static void gic_clockevent_cpu_exit(struct clock_event_device *cd)
+{
+	disable_percpu_irq(gic_timer_irq);
+}
+
+static int gic_cpu_notifier(struct notifier_block *nb, unsigned long action,
+				void *data)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		gic_clockevent_cpu_init(this_cpu_ptr(&gic_clockevent_device));
+		break;
+	case CPU_DYING:
+		gic_clockevent_cpu_exit(this_cpu_ptr(&gic_clockevent_device));
+		break;
 	}
 
-	enable_percpu_irq(irq, IRQ_TYPE_NONE);
+	return NOTIFY_OK;
+}
+
+static struct notifier_block gic_cpu_nb = {
+	.notifier_call = gic_cpu_notifier,
+};
+
+static int gic_clockevent_init(void)
+{
+	if (!cpu_has_counter || !gic_frequency)
+		return -ENXIO;
+
+	gic_timer_irq = MIPS_GIC_IRQ_BASE +
+		GIC_LOCAL_TO_HWIRQ(GIC_LOCAL_INT_COMPARE);
+	setup_percpu_irq(gic_timer_irq, &gic_compare_irqaction);
+
+	register_cpu_notifier(&gic_cpu_nb);
+
+	gic_clockevent_cpu_init(this_cpu_ptr(&gic_clockevent_device));
 
 	return 0;
 }
@@ -116,4 +142,6 @@ void __init gic_clocksource_init(unsigned int frequency)
 	gic_clocksource.rating = 200 + frequency / 10000000;
 
 	clocksource_register_hz(&gic_clocksource, frequency);
+
+	gic_clockevent_init();
 }
-- 
2.1.0.rc2.206.gedb03e5

