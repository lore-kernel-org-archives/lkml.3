Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030665Ab3DSQVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:21:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13957 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757581Ab3DSQTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:19:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,510,1363158000"; 
   d="scan'208";a="39954137"
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: [PATCHv5 06/11] ARM: EXYNOS4: Divorce mct from local timer API
Date: Fri, 19 Apr 2013 09:19:40 -0700
Message-Id: <1366388385-30722-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1.392.g85e7e81
In-Reply-To: <1366388385-30722-1-git-send-email-sboyd@codeaurora.org>
References: <1366388385-30722-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the mct local timers from the local timer API. This will
allow us to remove ARM local timer support in the near future and
gets us closer to moving this driver to drivers/clocksource.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/exynos_mct.c | 61 ++++++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 18 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index a5e9b48..ed4f463 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/clockchips.h>
+#include <linux/cpu.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/percpu.h>
@@ -24,8 +25,6 @@
 #include <linux/of_address.h>
 #include <linux/clocksource.h>
 
-#include <asm/localtimer.h>
-
 #include <plat/cpu.h>
 
 #include <mach/map.h>
@@ -85,7 +84,7 @@ static unsigned int mct_int_type;
 static int mct_irqs[MCT_NR_IRQS];
 
 struct mct_clock_event_device {
-	struct clock_event_device *evt;
+	struct clock_event_device evt;
 	unsigned long base;
 	char name[10];
 };
@@ -300,8 +299,6 @@ static void exynos4_clockevent_init(void)
 	setup_irq(mct_irqs[MCT_G0_IRQ], &mct_comp_event_irq);
 }
 
-#ifdef CONFIG_LOCAL_TIMERS
-
 static DEFINE_PER_CPU(struct mct_clock_event_device, percpu_mct_tick);
 
 /* Clock event handling */
@@ -374,7 +371,7 @@ static inline void exynos4_tick_set_mode(enum clock_event_mode mode,
 
 static int exynos4_mct_tick_clear(struct mct_clock_event_device *mevt)
 {
-	struct clock_event_device *evt = mevt->evt;
+	struct clock_event_device *evt = &mevt->evt;
 
 	/*
 	 * This is for supporting oneshot mode.
@@ -396,7 +393,7 @@ static int exynos4_mct_tick_clear(struct mct_clock_event_device *mevt)
 static irqreturn_t exynos4_mct_tick_isr(int irq, void *dev_id)
 {
 	struct mct_clock_event_device *mevt = dev_id;
-	struct clock_event_device *evt = mevt->evt;
+	struct clock_event_device *evt = &mevt->evt;
 
 	exynos4_mct_tick_clear(mevt);
 
@@ -422,8 +419,7 @@ static int __cpuinit exynos4_local_timer_setup(struct clock_event_device *evt)
 	struct mct_clock_event_device *mevt;
 	unsigned int cpu = smp_processor_id();
 
-	mevt = this_cpu_ptr(&percpu_mct_tick);
-	mevt->evt = evt;
+	mevt = container_of(evt, struct mct_clock_event_device, evt);
 
 	mevt->base = EXYNOS4_MCT_L_BASE(cpu);
 	sprintf(mevt->name, "mct_tick%d", cpu);
@@ -457,7 +453,7 @@ static int __cpuinit exynos4_local_timer_setup(struct clock_event_device *evt)
 	return 0;
 }
 
-static void exynos4_local_timer_stop(struct clock_event_device *evt)
+static void __cpuinit exynos4_local_timer_stop(struct clock_event_device *evt)
 {
 	unsigned int cpu = smp_processor_id();
 	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
@@ -470,14 +466,37 @@ static void exynos4_local_timer_stop(struct clock_event_device *evt)
 		disable_percpu_irq(mct_irqs[MCT_L0_IRQ]);
 }
 
-static struct local_timer_ops exynos4_mct_tick_ops __cpuinitdata = {
-	.setup	= exynos4_local_timer_setup,
-	.stop	= exynos4_local_timer_stop,
+static int __cpuinit exynos4_mct_cpu_notify(struct notifier_block *self,
+					   unsigned long action, void *hcpu)
+{
+	struct mct_clock_event_device *mevt;
+
+	/*
+	 * Grab cpu pointer in each case to avoid spurious
+	 * preemptible warnings
+	 */
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		mevt = this_cpu_ptr(&percpu_mct_tick);
+		exynos4_local_timer_setup(&mevt->evt);
+		break;
+	case CPU_DYING:
+		mevt = this_cpu_ptr(&percpu_mct_tick);
+		exynos4_local_timer_stop(&mevt->evt);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block exynos4_mct_cpu_nb __cpuinitdata = {
+	.notifier_call = exynos4_mct_cpu_notify,
 };
-#endif /* CONFIG_LOCAL_TIMERS */
 
 static void __init exynos4_timer_resources(struct device_node *np, void __iomem *base)
 {
+	int err;
+	struct mct_clock_event_device *mevt = this_cpu_ptr(&percpu_mct_tick);
 	struct clk *mct_clk, *tick_clk;
 
 	tick_clk = np ? of_clk_get_by_name(np, "fin_pll") :
@@ -495,9 +514,7 @@ static void __init exynos4_timer_resources(struct device_node *np, void __iomem
 	if (!reg_base)
 		panic("%s: unable to ioremap mct address space\n", __func__);
 
-#ifdef CONFIG_LOCAL_TIMERS
 	if (mct_int_type == MCT_INT_PPI) {
-		int err;
 
 		err = request_percpu_irq(mct_irqs[MCT_L0_IRQ],
 					 exynos4_mct_tick_isr, "MCT",
@@ -506,8 +523,16 @@ static void __init exynos4_timer_resources(struct device_node *np, void __iomem
 		     mct_irqs[MCT_L0_IRQ], err);
 	}
 
-	local_timer_register(&exynos4_mct_tick_ops);
-#endif /* CONFIG_LOCAL_TIMERS */
+	err = register_cpu_notifier(&exynos4_mct_cpu_nb);
+	if (err)
+		goto out_irq;
+
+	/* Immediately configure the timer on the boot CPU */
+	exynos4_local_timer_setup(&mevt->evt);
+	return;
+
+out_irq:
+	free_percpu_irq(mct_irqs[MCT_L0_IRQ], &percpu_mct_tick);
 }
 
 void __init mct_init(void)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

