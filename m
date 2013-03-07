Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3CGAHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:07:16 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15517 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3CGAEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:04:09 -0500
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="27967221"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 05/10] ARM: EXYNOS4: Divorce mct from local timer API
Date: Wed,  6 Mar 2013 16:04:01 -0800
Message-Id: <1362614646-24113-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org>
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the mct local timers from the local timer API. This will
allow us to remove ARM local timer support in the near future and
gets us closer to moving this driver to drivers/clocksource.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-exynos/mct.c | 53 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-exynos/mct.c b/arch/arm/mach-exynos/mct.c
index c9d6650..5a9a73f 100644
--- a/arch/arm/mach-exynos/mct.c
+++ b/arch/arm/mach-exynos/mct.c
@@ -16,13 +16,13 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/clockchips.h>
+#include <linux/cpu.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/percpu.h>
 #include <linux/of.h>
 
 #include <asm/arch_timer.h>
-#include <asm/localtimer.h>
 
 #include <plat/cpu.h>
 
@@ -42,7 +42,7 @@ static unsigned long clk_rate;
 static unsigned int mct_int_type;
 
 struct mct_clock_event_device {
-	struct clock_event_device *evt;
+	struct clock_event_device evt;
 	void __iomem *base;
 	char name[10];
 };
@@ -264,8 +264,6 @@ static void exynos4_clockevent_init(void)
 		setup_irq(EXYNOS4_IRQ_MCT_G0, &mct_comp_event_irq);
 }
 
-#ifdef CONFIG_LOCAL_TIMERS
-
 static DEFINE_PER_CPU(struct mct_clock_event_device, percpu_mct_tick);
 
 /* Clock event handling */
@@ -338,7 +336,7 @@ static inline void exynos4_tick_set_mode(enum clock_event_mode mode,
 
 static int exynos4_mct_tick_clear(struct mct_clock_event_device *mevt)
 {
-	struct clock_event_device *evt = mevt->evt;
+	struct clock_event_device *evt = &mevt->evt;
 
 	/*
 	 * This is for supporting oneshot mode.
@@ -360,7 +358,7 @@ static int exynos4_mct_tick_clear(struct mct_clock_event_device *mevt)
 static irqreturn_t exynos4_mct_tick_isr(int irq, void *dev_id)
 {
 	struct mct_clock_event_device *mevt = dev_id;
-	struct clock_event_device *evt = mevt->evt;
+	struct clock_event_device *evt = &mevt->evt;
 
 	exynos4_mct_tick_clear(mevt);
 
@@ -388,7 +386,6 @@ static int __cpuinit exynos4_local_timer_setup(struct clock_event_device *evt)
 	int mct_lx_irq;
 
 	mevt = this_cpu_ptr(&percpu_mct_tick);
-	mevt->evt = evt;
 
 	mevt->base = EXYNOS4_MCT_L_BASE(cpu);
 	sprintf(mevt->name, "mct_tick%d", cpu);
@@ -426,7 +423,7 @@ static int __cpuinit exynos4_local_timer_setup(struct clock_event_device *evt)
 	return 0;
 }
 
-static void exynos4_local_timer_stop(struct clock_event_device *evt)
+static void __cpuinit exynos4_local_timer_stop(struct clock_event_device *evt)
 {
 	unsigned int cpu = smp_processor_id();
 	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
@@ -439,22 +436,38 @@ static void exynos4_local_timer_stop(struct clock_event_device *evt)
 		disable_percpu_irq(EXYNOS_IRQ_MCT_LOCALTIMER);
 }
 
-static struct local_timer_ops exynos4_mct_tick_ops __cpuinitdata = {
-	.setup	= exynos4_local_timer_setup,
-	.stop	= exynos4_local_timer_stop,
+static int __cpuinit exynos4_mct_cpu_notify(struct notifier_block *self,
+					   unsigned long action, void *hcpu)
+{
+	struct mct_clock_event_device *mevt = this_cpu_ptr(&percpu_mct_tick);
+	struct clock_event_device *evt = &mevt->evt;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		exynos4_local_timer_setup(evt);
+		break;
+	case CPU_DYING:
+		exynos4_local_timer_stop(evt);
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
 
 static void __init exynos4_timer_resources(void)
 {
+	int err;
+	struct mct_clock_event_device *mevt = this_cpu_ptr(&percpu_mct_tick);
 	struct clk *mct_clk;
 	mct_clk = clk_get(NULL, "xtal");
 
 	clk_rate = clk_get_rate(mct_clk);
 
-#ifdef CONFIG_LOCAL_TIMERS
 	if (mct_int_type == MCT_INT_PPI) {
-		int err;
 
 		err = request_percpu_irq(EXYNOS_IRQ_MCT_LOCALTIMER,
 					 exynos4_mct_tick_isr, "MCT",
@@ -463,8 +476,16 @@ static void __init exynos4_timer_resources(void)
 		     EXYNOS_IRQ_MCT_LOCALTIMER, err);
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
+	free_percpu_irq(EXYNOS_IRQ_MCT_LOCALTIMER, &percpu_mct_tick);
 }
 
 void __init exynos4_timer_init(void)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

