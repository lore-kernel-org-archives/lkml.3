Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaDXVpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:45:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40990 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaDXVo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:44:56 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 21/26] ARM: OMAP: dmtimer: Add systimer flag to dmtimer structure
Date: Thu, 24 Apr 2014 16:44:04 -0500
Message-ID: <1398375849-6017-22-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398375849-6017-1-git-send-email-joelf@ti.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a systimer flag to mark that a timer is used for system timers, this will
help simplify cases where we have to use runtime PM for non system timers, and
we don't have explicitly pass arguments to functions to tell it to do runtime
PM and context save or not.

Also will be useful in upcoming patches to not do certain pm runtime checks
for !systimers.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c                  |   12 ++++++------
 arch/arm/plat-omap/dmtimer.c                 |   11 ++++++-----
 arch/arm/plat-omap/include/plat/dmtimer.h    |    5 +++--
 drivers/media/rc/ir-rx51.c                   |    4 ++--
 drivers/staging/tidspbridge/core/dsp-clock.c |    4 ++--
 5 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 2d8ea96..5cceaae 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -64,7 +64,7 @@
 
 /* Clockevent code */
 
-static struct omap_dm_timer clkev;
+static struct omap_dm_timer clkev = { .systimer = 1 };
 static struct clock_event_device clockevent_gpt;
 
 #ifdef CONFIG_SOC_HAS_REALTIME_COUNTER
@@ -95,7 +95,7 @@ static struct irqaction omap2_gp_timer_irq = {
 static int omap2_gp_timer_set_next_event(unsigned long cycles,
 					 struct clock_event_device *evt)
 {
-	omap_dm_timer_set_load_start(&clkev, 0xffffffff - cycles, 0, 0);
+	omap_dm_timer_set_load_start(&clkev, 0xffffffff - cycles, 0);
 
 	return 0;
 }
@@ -105,13 +105,13 @@ static void omap2_gp_timer_set_mode(enum clock_event_mode mode,
 {
 	u32 period;
 
-	omap_dm_timer_stop(&clkev, 0);
+	omap_dm_timer_stop(&clkev);
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		period = clkev.rate / HZ;
 		period -= 1;
-		omap_dm_timer_set_load_start(&clkev, 0xffffffff - period, 1, 0);
+		omap_dm_timer_set_load_start(&clkev, 0xffffffff - period, 1);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
 		break;
@@ -415,7 +415,7 @@ static void __init omap2_gp_clockevent_init(int gptimer_id,
 }
 
 /* Clocksource code */
-static struct omap_dm_timer clksrc;
+static struct omap_dm_timer clksrc = { .systimer = 1 };
 static bool use_gptimer_clksrc;
 
 /*
@@ -524,7 +524,7 @@ static void __init omap2_gptimer_clocksource_init(int gptimer_id,
 
 	clocksource_gpt.name = "timer_clksrc";
 
-	omap_dm_timer_set_load_start(&clksrc, 0, 1, 0);
+	omap_dm_timer_set_load_start(&clksrc, 0, 1);
 
 	sched_clock_register(dmtimer_read_sched_clock, 32, clksrc.rate);
 
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 8602586..504784f 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -467,7 +467,7 @@ int omap_dm_timer_start(struct omap_dm_timer *timer)
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_start);
 
-int omap_dm_timer_stop(struct omap_dm_timer *timer, int pm)
+int omap_dm_timer_stop(struct omap_dm_timer *timer)
 {
 	u32 l;
 	unsigned long rate;
@@ -495,7 +495,7 @@ int omap_dm_timer_stop(struct omap_dm_timer *timer, int pm)
 	/* Ack possibly pending interrupt */
 	__raw_writel(OMAP_TIMER_INT_OVERFLOW, timer->irq_stat);
 
-	if (pm) {
+	if (!timer->systimer) {
 		timer->context.tclr = l;
 		omap_dm_timer_disable(timer);
 	}
@@ -589,7 +589,7 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_set_load);
 
 /* Optimized set_load which removes costly spin wait in timer_start */
 int omap_dm_timer_set_load_start(struct omap_dm_timer *timer, unsigned int load,
-				 int autoreload, int pm)
+				 int autoreload)
 {
 	int rc;
 	u32 mask = ~0, val = 0;
@@ -597,7 +597,7 @@ int omap_dm_timer_set_load_start(struct omap_dm_timer *timer, unsigned int load,
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	if (pm) {
+	if (!timer->systimer) {
 		rc = omap_dm_timer_enable(timer);
 		if (rc)
 			return rc;
@@ -615,12 +615,13 @@ int omap_dm_timer_set_load_start(struct omap_dm_timer *timer, unsigned int load,
 	omap_dm_timer_write_reg(timer, OMAP_TIMER_COUNTER_REG, load);
 	val = omap_dm_timer_write_ctrl(timer, mask, val);
 
-	if (pm) {
+	if (!timer->systimer) {
 		/* Save the context */
 		timer->context.tclr = val;
 		timer->context.tldr = load;
 		timer->context.tcrr = load;
 	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_set_load_start);
diff --git a/arch/arm/plat-omap/include/plat/dmtimer.h b/arch/arm/plat-omap/include/plat/dmtimer.h
index 1d3d9bb..7005a1e 100644
--- a/arch/arm/plat-omap/include/plat/dmtimer.h
+++ b/arch/arm/plat-omap/include/plat/dmtimer.h
@@ -118,6 +118,7 @@ struct omap_dm_timer {
 	int (*get_context_loss_count)(struct device *);
 	int ctx_loss_count;
 	int revision;
+	int systimer;
 	u32 capability;
 	u32 errata;
 	struct platform_device *pdev;
@@ -141,12 +142,12 @@ struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer);
 
 int omap_dm_timer_trigger(struct omap_dm_timer *timer);
 int omap_dm_timer_start(struct omap_dm_timer *timer);
-int omap_dm_timer_stop(struct omap_dm_timer *timer, int pm);
+int omap_dm_timer_stop(struct omap_dm_timer *timer);
 
 int omap_dm_timer_set_source(struct omap_dm_timer *timer, int source);
 int omap_dm_timer_set_load(struct omap_dm_timer *timer, int autoreload, unsigned int value);
 int omap_dm_timer_set_load_start(struct omap_dm_timer *timer, unsigned int load,
-				 int autoreload, int pm);
+				 int autoreload);
 int omap_dm_timer_set_match(struct omap_dm_timer *timer, int enable, unsigned int match);
 int omap_dm_timer_set_pwm(struct omap_dm_timer *timer, int def_on, int toggle, int trigger);
 int omap_dm_timer_set_prescaler(struct omap_dm_timer *timer, int prescaler);
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 3dc736d..b1e19a2 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -165,8 +165,8 @@ end:
 	/* Stop TX here */
 	lirc_rx51_off(lirc_rx51);
 	lirc_rx51->wbuf_index = -1;
-	omap_dm_timer_stop(lirc_rx51->pwm_timer, 1);
-	omap_dm_timer_stop(lirc_rx51->pulse_timer, 1);
+	omap_dm_timer_stop(lirc_rx51->pwm_timer);
+	omap_dm_timer_stop(lirc_rx51->pulse_timer);
 	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
 	wake_up_interruptible(&lirc_rx51->wqueue);
 
diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index 6ac36d1..e4b4181 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -189,7 +189,7 @@ void dsp_gpt_wait_overflow(short int clk_id, unsigned int load)
 	 * Set counter value to overflow counter after
 	 * one tick and start timer.
 	 */
-	omap_dm_timer_set_load_start(gpt, load, 0, 1);
+	omap_dm_timer_set_load_start(gpt, load, 0);
 
 	/* Wait 80us for timer to overflow */
 	udelay(80);
@@ -300,7 +300,7 @@ int dsp_clk_disable(enum dsp_clk_id clk_id)
 		clk_disable(iva2_clk);
 		break;
 	case GPT_CLK:
-		status = omap_dm_timer_stop(timer[clk_id - 1], 1);
+		status = omap_dm_timer_stop(timer[clk_id - 1]);
 		break;
 #ifdef CONFIG_OMAP_MCBSP
 	case MCBSP_CLK:
-- 
1.7.9.5

