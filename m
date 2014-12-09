Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaLIWD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 17:03:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:59636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaLIWDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 17:03:41 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Frederic Weisbecker <fweisbec@gmail.com>, preeti@linux.vnet.ibm.com
Subject: [PATCH 2/2] clockevents: migrate some drivers to new ->set_dev_mode()
Date: Tue,  9 Dec 2014 14:03:34 -0800
Message-Id: <1418162614-19182-3-git-send-email-khilman@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418162614-19182-1-git-send-email-khilman@kernel.org>
References: <1418162614-19182-1-git-send-email-khilman@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

Clockevents core now supports ->set_dev_mode() (as a replacement to
->set_mode()), with capability to return error codes.

This patch migrates few clockevent drivers to the new method to demonstrate how
to convert to the new interface.

Drivers are modified to return -ENOSYS when requested to switch to unsupported
mode and return 0 on success. This patch shouldn't result in any other
functional change in drivers.

Most of the changes are automated with help of Coccinelle
(http://coccinelle.lip6.fr/) and the ones left are around the switch
block which are handled manually.  Some additional changes (like
adding 'int ret = 0' and 'return ret') as well as whitespace fixups
were also done manually after coccinelle.

A simplified version of the semantic patch is:

// <smpl>
@@
identifier m,c,setmode;
@@
-void
+int
setmode(enum clock_event_mode m, struct clock_event_device *c);

@@
identifier setmode;
@@
-void
+int
setmode(enum clock_event_mode, struct clock_event_device *);

@fixret@
identifier m,c,setmode;
@@
-void
+int
setmode(enum clock_event_mode m, struct clock_event_device *c)
 {
 ...
+ return 0;
 }

@depends on fixret@
identifier ced;
identifier fixret.setmode;
@@
... struct clock_event_device ced = {
...,
-.set_mode
+.set_dev_mode
= setmode,
};

@depends on fixret@
expression ced;
identifier fixret.setmode;
@@
- ced->set_mode
+ ced->set_dev_mode
= setmode

@depends on fixret@
identifier fixret.setmode;
@@
{
.
-set_mode
+set_dev_mode
= setmode
}

@depends on fixret@
expression ced;
identifier fixret.setmode;
@@
- ced.set_mode
+ ced.set_dev_mode
= setmode

// </smpl>

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Kevin Hilman <khilman@linaro.org>
[khilman: rework changelog, minor formatting, checkpatch cleanups]
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 drivers/clocksource/arm_arch_timer.c     | 46 +++++++++++++++++---------------
 drivers/clocksource/bcm2835_timer.c      | 10 +++----
 drivers/clocksource/bcm_kona_timer.c     | 15 ++++++++---
 drivers/clocksource/i8253.c              | 11 +++++---
 drivers/clocksource/time-armada-370-xp.c | 21 +++++++++++----
 5 files changed, 65 insertions(+), 38 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 43005d4d3348..368302004076 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -179,8 +179,8 @@ static irqreturn_t arch_timer_handler_virt_mem(int irq, void *dev_id)
 	return timer_handler(ARCH_TIMER_MEM_VIRT_ACCESS, evt);
 }
 
-static __always_inline void timer_set_mode(const int access, int mode,
-				  struct clock_event_device *clk)
+static __always_inline int timer_set_mode(const int access, int mode,
+					  struct clock_event_device *clk)
 {
 	unsigned long ctrl;
 	switch (mode) {
@@ -190,33 +190,37 @@ static __always_inline void timer_set_mode(const int access, int mode,
 		ctrl &= ~ARCH_TIMER_CTRL_ENABLE;
 		arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, clk);
 		break;
-	default:
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_RESUME:
 		break;
+	default:
+		return -ENOSYS;
 	}
+	return 0;
 }
 
-static void arch_timer_set_mode_virt(enum clock_event_mode mode,
-				     struct clock_event_device *clk)
+static int arch_timer_set_mode_virt(enum clock_event_mode mode,
+				    struct clock_event_device *clk)
 {
-	timer_set_mode(ARCH_TIMER_VIRT_ACCESS, mode, clk);
+	return timer_set_mode(ARCH_TIMER_VIRT_ACCESS, mode, clk);
 }
 
-static void arch_timer_set_mode_phys(enum clock_event_mode mode,
-				     struct clock_event_device *clk)
+static int arch_timer_set_mode_phys(enum clock_event_mode mode,
+				    struct clock_event_device *clk)
 {
-	timer_set_mode(ARCH_TIMER_PHYS_ACCESS, mode, clk);
+	return timer_set_mode(ARCH_TIMER_PHYS_ACCESS, mode, clk);
 }
 
-static void arch_timer_set_mode_virt_mem(enum clock_event_mode mode,
-					 struct clock_event_device *clk)
+static int arch_timer_set_mode_virt_mem(enum clock_event_mode mode,
+					struct clock_event_device *clk)
 {
-	timer_set_mode(ARCH_TIMER_MEM_VIRT_ACCESS, mode, clk);
+	return timer_set_mode(ARCH_TIMER_MEM_VIRT_ACCESS, mode, clk);
 }
 
-static void arch_timer_set_mode_phys_mem(enum clock_event_mode mode,
-					 struct clock_event_device *clk)
+static int arch_timer_set_mode_phys_mem(enum clock_event_mode mode,
+					struct clock_event_device *clk)
 {
-	timer_set_mode(ARCH_TIMER_MEM_PHYS_ACCESS, mode, clk);
+	return timer_set_mode(ARCH_TIMER_MEM_PHYS_ACCESS, mode, clk);
 }
 
 static __always_inline void set_next_event(const int access, unsigned long evt,
@@ -271,11 +275,11 @@ static void __arch_timer_setup(unsigned type,
 		clk->cpumask = cpumask_of(smp_processor_id());
 		if (arch_timer_use_virtual) {
 			clk->irq = arch_timer_ppi[VIRT_PPI];
-			clk->set_mode = arch_timer_set_mode_virt;
+			clk->set_dev_mode = arch_timer_set_mode_virt;
 			clk->set_next_event = arch_timer_set_next_event_virt;
 		} else {
 			clk->irq = arch_timer_ppi[PHYS_SECURE_PPI];
-			clk->set_mode = arch_timer_set_mode_phys;
+			clk->set_dev_mode = arch_timer_set_mode_phys;
 			clk->set_next_event = arch_timer_set_next_event_phys;
 		}
 	} else {
@@ -284,17 +288,17 @@ static void __arch_timer_setup(unsigned type,
 		clk->rating = 400;
 		clk->cpumask = cpu_all_mask;
 		if (arch_timer_mem_use_virtual) {
-			clk->set_mode = arch_timer_set_mode_virt_mem;
+			clk->set_dev_mode = arch_timer_set_mode_virt_mem;
 			clk->set_next_event =
 				arch_timer_set_next_event_virt_mem;
 		} else {
-			clk->set_mode = arch_timer_set_mode_phys_mem;
+			clk->set_dev_mode = arch_timer_set_mode_phys_mem;
 			clk->set_next_event =
 				arch_timer_set_next_event_phys_mem;
 		}
 	}
 
-	clk->set_mode(CLOCK_EVT_MODE_SHUTDOWN, clk);
+	clk->set_dev_mode(CLOCK_EVT_MODE_SHUTDOWN, clk);
 
 	clockevents_config_and_register(clk, arch_timer_rate, 0xf, 0x7fffffff);
 }
@@ -497,7 +501,7 @@ static void arch_timer_stop(struct clock_event_device *clk)
 			disable_percpu_irq(arch_timer_ppi[PHYS_NONSECURE_PPI]);
 	}
 
-	clk->set_mode(CLOCK_EVT_MODE_UNUSED, clk);
+	clk->set_dev_mode(CLOCK_EVT_MODE_UNUSED, clk);
 }
 
 static int arch_timer_cpu_notify(struct notifier_block *self,
diff --git a/drivers/clocksource/bcm2835_timer.c b/drivers/clocksource/bcm2835_timer.c
index 26ed331b1aad..04ae14ca81ab 100644
--- a/drivers/clocksource/bcm2835_timer.c
+++ b/drivers/clocksource/bcm2835_timer.c
@@ -54,8 +54,8 @@ static u64 notrace bcm2835_sched_read(void)
 	return readl_relaxed(system_clock);
 }
 
-static void bcm2835_time_set_mode(enum clock_event_mode mode,
-	struct clock_event_device *evt_dev)
+static int bcm2835_time_set_mode(enum clock_event_mode mode,
+				 struct clock_event_device *evt_dev)
 {
 	switch (mode) {
 	case CLOCK_EVT_MODE_ONESHOT:
@@ -64,9 +64,9 @@ static void bcm2835_time_set_mode(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_RESUME:
 		break;
 	default:
-		WARN(1, "%s: unhandled event mode %d\n", __func__, mode);
-		break;
+		return -ENOSYS;
 	}
+	return 0;
 }
 
 static int bcm2835_time_set_next_event(unsigned long event,
@@ -129,7 +129,7 @@ static void __init bcm2835_timer_init(struct device_node *node)
 	timer->evt.name = node->name;
 	timer->evt.rating = 300;
 	timer->evt.features = CLOCK_EVT_FEAT_ONESHOT;
-	timer->evt.set_mode = bcm2835_time_set_mode;
+	timer->evt.set_dev_mode = bcm2835_time_set_mode;
 	timer->evt.set_next_event = bcm2835_time_set_next_event;
 	timer->evt.cpumask = cpumask_of(0);
 	timer->act.name = node->name;
diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
index 0595dc6c453e..807915e9e2f8 100644
--- a/drivers/clocksource/bcm_kona_timer.c
+++ b/drivers/clocksource/bcm_kona_timer.c
@@ -128,25 +128,32 @@ static int kona_timer_set_next_event(unsigned long clc,
 	return 0;
 }
 
-static void kona_timer_set_mode(enum clock_event_mode mode,
-			     struct clock_event_device *unused)
+static int kona_timer_set_mode(enum clock_event_mode mode,
+			       struct clock_event_device *unused)
 {
+	int ret = 0;
+
 	switch (mode) {
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* by default mode is one shot don't do any thing */
 		break;
+	default:
+		ret = -ENOSYS;
+		/* fall through so timer is disabled */
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-	default:
+	case CLOCK_EVT_MODE_RESUME:
 		kona_timer_disable_and_clear(timers.tmr_regs);
+		break;
 	}
+	return ret;
 }
 
 static struct clock_event_device kona_clockevent_timer = {
 	.name = "timer 1",
 	.features = CLOCK_EVT_FEAT_ONESHOT,
 	.set_next_event = kona_timer_set_next_event,
-	.set_mode = kona_timer_set_mode
+	.set_dev_mode = kona_timer_set_mode
 };
 
 static void __init kona_timer_clockevents_init(void)
diff --git a/drivers/clocksource/i8253.c b/drivers/clocksource/i8253.c
index 14ee3efcc404..ea28efbfe9cf 100644
--- a/drivers/clocksource/i8253.c
+++ b/drivers/clocksource/i8253.c
@@ -105,9 +105,11 @@ int __init clocksource_i8253_init(void)
  *
  * This is also called after resume to bring the PIT into operation again.
  */
-static void init_pit_timer(enum clock_event_mode mode,
-			   struct clock_event_device *evt)
+static int init_pit_timer(enum clock_event_mode mode,
+			  struct clock_event_device *evt)
 {
+	int ret = 0;
+
 	raw_spin_lock(&i8253_lock);
 
 	switch (mode) {
@@ -136,8 +138,11 @@ static void init_pit_timer(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_RESUME:
 		/* Nothing to do here */
 		break;
+	default:
+		ret = -ENOSYS;
 	}
 	raw_spin_unlock(&i8253_lock);
+	return ret;
 }
 
 /*
@@ -162,7 +167,7 @@ static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
 struct clock_event_device i8253_clockevent = {
 	.name		= "pit",
 	.features	= CLOCK_EVT_FEAT_PERIODIC,
-	.set_mode	= init_pit_timer,
+	.set_dev_mode	= init_pit_timer,
 	.set_next_event = pit_next_event,
 };
 
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 0451e62fac7a..4ea3d4c9d651 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -120,12 +120,14 @@ armada_370_xp_clkevt_next_event(unsigned long delta,
 	return 0;
 }
 
-static void
+static int
 armada_370_xp_clkevt_mode(enum clock_event_mode mode,
 			  struct clock_event_device *dev)
 {
-	if (mode == CLOCK_EVT_MODE_PERIODIC) {
+	int ret = 0;
 
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
 		/*
 		 * Setup timer to fire at 1/HZ intervals.
 		 */
@@ -136,7 +138,14 @@ armada_370_xp_clkevt_mode(enum clock_event_mode mode,
 		 * Enable timer.
 		 */
 		local_timer_ctrl_clrset(0, TIMER0_RELOAD_EN | enable_mask);
-	} else {
+		break;
+	default:
+		ret = -ENOSYS;
+		/* fall through so timer is disabled, ACK'd */
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_RESUME:
 		/*
 		 * Disable timer.
 		 */
@@ -146,7 +155,9 @@ armada_370_xp_clkevt_mode(enum clock_event_mode mode,
 		 * ACK pending timer interrupt.
 		 */
 		writel(TIMER0_CLR_MASK, local_base + LCL_TIMER_EVENTS_STATUS);
+		break;
 	}
+	return ret;
 }
 
 static int armada_370_xp_clkevt_irq;
@@ -184,7 +195,7 @@ static int armada_370_xp_timer_setup(struct clock_event_device *evt)
 	evt->shift		= 32,
 	evt->rating		= 300,
 	evt->set_next_event	= armada_370_xp_clkevt_next_event,
-	evt->set_mode		= armada_370_xp_clkevt_mode,
+	evt->set_dev_mode	= armada_370_xp_clkevt_mode,
 	evt->irq		= armada_370_xp_clkevt_irq;
 	evt->cpumask		= cpumask_of(cpu);
 
@@ -196,7 +207,7 @@ static int armada_370_xp_timer_setup(struct clock_event_device *evt)
 
 static void armada_370_xp_timer_stop(struct clock_event_device *evt)
 {
-	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
+	evt->set_dev_mode(CLOCK_EVT_MODE_UNUSED, evt);
 	disable_percpu_irq(evt->irq);
 }
 
-- 
2.1.3

