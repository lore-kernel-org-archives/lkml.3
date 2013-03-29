Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3C2JS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 05:18:26 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:50445 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320Ab3C2JSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 05:18:24 -0400
From: <ning.n.jiang@gmail.com>
To: <linux@arm.linux.org.uk>, <kgene.kim@samsung.com>, <davidb@codeaurora.org>,
        <dwalker@fifo99.com>, <bryanh@codeaurora.org>,
        <john.stultz@linaro.org>, <tglx@linutronix.de>,
        <linus.walleij@linaro.org>, <shawn.guo@linaro.org>,
        <rob.herring@calxeda.com>, <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        Ning Jiang <ning.n.jiang@gmail.com>
Subject: [PATCH] ARM: timer: Shutdown clock event device when stopping local timer
Date: Fri, 29 Mar 2013 17:24:09 +0800
Message-ID: <1364549049-29278-1-git-send-email-ning.n.jiang@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ning Jiang <ning.n.jiang@gmail.com>

Currently there are two problems when we try to stop local timer.
First, it calls set_mode function directly so mode state is not
updated for the clock event device. Second, it makes the device
unused instead of shutdown.

A subtle error will happen because of it. When a cpu is plugged out
it will stop the local timer. It will call tick_nohz_idle_enter()
in idle thread afterwards. It will cancel the sched timer and try
to reprogram the next event. This is wrong since the local timer
is supposed to be stopped.

The right way to stop the local timer is to shutdown it by calling
clockevents_set_mode(). Thus when we try to reprogram the clock
event device, it will return directly without doing anything since
the clock mode is CLOCK_EVT_MODE_SHUTDOWN.

Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
---
 arch/arm/kernel/smp_twd.c                |    2 +-
 arch/arm/mach-exynos/mct.c               |    2 +-
 arch/arm/mach-msm/timer.c                |    2 +-
 drivers/clocksource/arm_arch_timer.c     |    2 +-
 drivers/clocksource/time-armada-370-xp.c |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 3f25650..c1d4ab4 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -92,7 +92,7 @@ static int twd_timer_ack(void)
 
 static void twd_timer_stop(struct clock_event_device *clk)
 {
-	twd_set_mode(CLOCK_EVT_MODE_UNUSED, clk);
+	clockevents_set_mode(clk, CLOCK_EVT_MODE_SHUTDOWN);
 	disable_percpu_irq(clk->irq);
 }
 
diff --git a/arch/arm/mach-exynos/mct.c b/arch/arm/mach-exynos/mct.c
index c9d6650..b2d0d46 100644
--- a/arch/arm/mach-exynos/mct.c
+++ b/arch/arm/mach-exynos/mct.c
@@ -429,7 +429,7 @@ static int __cpuinit exynos4_local_timer_setup(struct clock_event_device *evt)
 static void exynos4_local_timer_stop(struct clock_event_device *evt)
 {
 	unsigned int cpu = smp_processor_id();
-	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
+	clockevents_set_mode(evt, CLOCK_EVT_MODE_SHUTDOWN);
 	if (mct_int_type == MCT_INT_SPI)
 		if (cpu == 0)
 			remove_irq(evt->irq, &mct_tick0_event_irq);
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 2969027..9b0cc66 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -152,7 +152,7 @@ static int __cpuinit msm_local_timer_setup(struct clock_event_device *evt)
 
 static void msm_local_timer_stop(struct clock_event_device *evt)
 {
-	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
+	clockevents_set_mode(evt, CLOCK_EVT_MODE_SHUTDOWN);
 	disable_percpu_irq(evt->irq);
 }
 
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index d7ad425..beecb26 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -242,7 +242,7 @@ static void __cpuinit arch_timer_stop(struct clock_event_device *clk)
 			disable_percpu_irq(arch_timer_ppi[PHYS_NONSECURE_PPI]);
 	}
 
-	clk->set_mode(CLOCK_EVT_MODE_UNUSED, clk);
+	clockevents_set_mode(clk, CLOCK_EVT_MODE_SHUTDOWN);
 }
 
 static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 47a6730..bfb2971 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -201,7 +201,7 @@ static int __cpuinit armada_370_xp_timer_setup(struct clock_event_device *evt)
 
 static void  armada_370_xp_timer_stop(struct clock_event_device *evt)
 {
-	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
+	clockevents_set_mode(evt, CLOCK_EVT_MODE_SHUTDOWN);
 	disable_percpu_irq(evt->irq);
 }
 
-- 
1.7.1

