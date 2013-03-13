Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163Ab3CMSTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:19:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34795 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933997Ab3CMSSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:18:01 -0400
X-IronPort-AV: E=Sophos;i="4.84,838,1355126400"; 
   d="scan'208";a="29403403"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: [PATCHv3 07/10] ARM: msm: Divorce msm_timer from local timer API
Date: Wed, 13 Mar 2013 11:17:53 -0700
Message-Id: <1363198676-30417-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org>
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the msm_timer from the local timer API. This will allow
us to remove ARM local timer support in the near future and gets
us closer to moving this driver to drivers/clocksource.

Acked-by: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/timer.c | 125 +++++++++++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 58 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 2969027..4675c5e 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -16,6 +16,7 @@
 
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
+#include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -25,7 +26,6 @@
 #include <linux/of_irq.h>
 
 #include <asm/mach/time.h>
-#include <asm/localtimer.h>
 #include <asm/sched_clock.h>
 
 #include "common.h"
@@ -46,7 +46,7 @@ static void __iomem *event_base;
 
 static irqreturn_t msm_timer_interrupt(int irq, void *dev_id)
 {
-	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
+	struct clock_event_device *evt = dev_id;
 	/* Stop the timer tick */
 	if (evt->mode == CLOCK_EVT_MODE_ONESHOT) {
 		u32 ctrl = readl_relaxed(event_base + TIMER_ENABLE);
@@ -90,18 +90,7 @@ static void msm_timer_set_mode(enum clock_event_mode mode,
 	writel_relaxed(ctrl, event_base + TIMER_ENABLE);
 }
 
-static struct clock_event_device msm_clockevent = {
-	.name		= "gp_timer",
-	.features	= CLOCK_EVT_FEAT_ONESHOT,
-	.rating		= 200,
-	.set_next_event	= msm_timer_set_next_event,
-	.set_mode	= msm_timer_set_mode,
-};
-
-static union {
-	struct clock_event_device *evt;
-	struct clock_event_device * __percpu *percpu_evt;
-} msm_evt;
+static struct clock_event_device __percpu *msm_evt;
 
 static void __iomem *source_base;
 
@@ -127,40 +116,66 @@ static struct clocksource msm_clocksource = {
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
-#ifdef CONFIG_LOCAL_TIMERS
+static int msm_timer_irq;
+static int msm_timer_has_ppi;
+
 static int __cpuinit msm_local_timer_setup(struct clock_event_device *evt)
 {
-	/* Use existing clock_event for cpu 0 */
-	if (!smp_processor_id())
-		return 0;
+	int cpu = smp_processor_id();
+	int err;
 
 	writel_relaxed(0, event_base + TIMER_ENABLE);
 	writel_relaxed(0, event_base + TIMER_CLEAR);
 	writel_relaxed(~0, event_base + TIMER_MATCH_VAL);
-	evt->irq = msm_clockevent.irq;
+	evt->irq = msm_timer_irq;
 	evt->name = "local_timer";
-	evt->features = msm_clockevent.features;
-	evt->rating = msm_clockevent.rating;
+	evt->features = CLOCK_EVT_FEAT_ONESHOT;
+	evt->rating = 200;
 	evt->set_mode = msm_timer_set_mode;
 	evt->set_next_event = msm_timer_set_next_event;
+	evt->cpumask = cpumask_of(cpu);
+
+	clockevents_config_and_register(evt, GPT_HZ, 4, 0xffffffff);
+
+	if (msm_timer_has_ppi) {
+		enable_percpu_irq(evt->irq, IRQ_TYPE_EDGE_RISING);
+	} else {
+		err = request_irq(evt->irq, msm_timer_interrupt,
+				IRQF_TIMER | IRQF_NOBALANCING |
+				IRQF_TRIGGER_RISING, "gp_timer", evt);
+		if (err)
+			pr_err("request_irq failed\n");
+	}
 
-	*__this_cpu_ptr(msm_evt.percpu_evt) = evt;
-	clockevents_config_and_register(evt, GPT_HZ, 4, 0xf0000000);
-	enable_percpu_irq(evt->irq, IRQ_TYPE_EDGE_RISING);
 	return 0;
 }
 
-static void msm_local_timer_stop(struct clock_event_device *evt)
+static void __cpuinit msm_local_timer_stop(struct clock_event_device *evt)
 {
 	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
 	disable_percpu_irq(evt->irq);
 }
 
-static struct local_timer_ops msm_local_timer_ops __cpuinitdata = {
-	.setup	= msm_local_timer_setup,
-	.stop	= msm_local_timer_stop,
+static int __cpuinit msm_timer_cpu_notify(struct notifier_block *self,
+					   unsigned long action, void *hcpu)
+{
+	struct clock_event_device *evt = this_cpu_ptr(msm_evt);
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		msm_local_timer_setup(evt);
+		break;
+	case CPU_DYING:
+		msm_local_timer_stop(evt);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block msm_timer_cpu_nb __cpuinitdata = {
+	.notifier_call = msm_timer_cpu_notify,
 };
-#endif /* CONFIG_LOCAL_TIMERS */
 
 static notrace u32 msm_sched_clock_read(void)
 {
@@ -170,41 +185,35 @@ static notrace u32 msm_sched_clock_read(void)
 static void __init msm_timer_init(u32 dgt_hz, int sched_bits, int irq,
 				  bool percpu)
 {
-	struct clock_event_device *ce = &msm_clockevent;
 	struct clocksource *cs = &msm_clocksource;
-	int res;
+	int res = 0;
 
-	writel_relaxed(0, event_base + TIMER_ENABLE);
-	writel_relaxed(0, event_base + TIMER_CLEAR);
-	writel_relaxed(~0, event_base + TIMER_MATCH_VAL);
-	ce->cpumask = cpumask_of(0);
-	ce->irq = irq;
-
-	clockevents_config_and_register(ce, GPT_HZ, 4, 0xffffffff);
-	if (percpu) {
-		msm_evt.percpu_evt = alloc_percpu(struct clock_event_device *);
-		if (!msm_evt.percpu_evt) {
-			pr_err("memory allocation failed for %s\n", ce->name);
+	msm_timer_irq = irq;
+	msm_timer_has_ppi = percpu;
+
+	msm_evt = alloc_percpu(struct clock_event_device);
+	if (!msm_evt) {
+		pr_err("memory allocation failed for clockevents\n");
+		goto err;
+	}
+
+	if (percpu)
+		res = request_percpu_irq(irq, msm_timer_interrupt,
+					 "gp_timer", msm_evt);
+
+	if (res) {
+		pr_err("request_percpu_irq failed\n");
+	} else {
+		res = register_cpu_notifier(&msm_timer_cpu_nb);
+		if (res) {
+			free_percpu_irq(irq, msm_evt);
 			goto err;
 		}
-		*__this_cpu_ptr(msm_evt.percpu_evt) = ce;
-		res = request_percpu_irq(ce->irq, msm_timer_interrupt,
-					 ce->name, msm_evt.percpu_evt);
-		if (!res) {
-			enable_percpu_irq(ce->irq, IRQ_TYPE_EDGE_RISING);
-#ifdef CONFIG_LOCAL_TIMERS
-			local_timer_register(&msm_local_timer_ops);
-#endif
-		}
-	} else {
-		msm_evt.evt = ce;
-		res = request_irq(ce->irq, msm_timer_interrupt,
-				  IRQF_TIMER | IRQF_NOBALANCING |
-				  IRQF_TRIGGER_RISING, ce->name, &msm_evt.evt);
+
+		/* Immediately configure the timer on the boot CPU */
+		msm_local_timer_setup(this_cpu_ptr(msm_evt));
 	}
 
-	if (res)
-		pr_err("request_irq failed for %s\n", ce->name);
 err:
 	writel_relaxed(TIMER_ENABLE_EN, source_base + TIMER_ENABLE);
 	res = clocksource_register_hz(cs, dgt_hz);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

