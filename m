Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3GEWwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:52:43 -0400
Received: from gloria.sntech.de ([95.129.55.99]:37960 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab3GEWwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:52:42 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 2/9] clocksource: dw_apb_timer: flexible register addresses
Date: Sat, 6 Jul 2013 00:52:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
References: <201307060051.09716.heiko@sntech.de>
In-Reply-To: <201307060051.09716.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307060052.31758.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There exists variants of the apb-timer that use slightly different
register positions. To accomodate this, add elements to the timer struct
to hold the actual register offsets.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/clocksource/dw_apb_timer.c |   83 ++++++++++++++++++++++--------------
 include/linux/dw_apb_timer.h       |    5 +++
 2 files changed, 56 insertions(+), 32 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
index 01bdac0..f5e7be8 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -49,6 +49,15 @@ clocksource_to_dw_apb_clocksource(struct clocksource *cs)
 	return container_of(cs, struct dw_apb_clocksource, cs);
 }
 
+static void apbt_init_regs(struct dw_apb_timer *timer, int quirks)
+{
+	timer->reg_load_count = APBTMR_N_LOAD_COUNT;
+	timer->reg_current_value = APBTMR_N_CURRENT_VALUE;
+	timer->reg_control = APBTMR_N_CONTROL;
+	timer->reg_eoi = APBTMR_N_EOI;
+	timer->reg_int_status = APBTMR_N_INT_STATUS;
+}
+
 static unsigned long apbt_readl(struct dw_apb_timer *timer, unsigned long offs)
 {
 	return readl(timer->base + offs);
@@ -62,10 +71,10 @@ static void apbt_writel(struct dw_apb_timer *timer, unsigned long val,
 
 static void apbt_disable_int(struct dw_apb_timer *timer)
 {
-	unsigned long ctrl = apbt_readl(timer, APBTMR_N_CONTROL);
+	unsigned long ctrl = apbt_readl(timer, timer->reg_control);
 
 	ctrl |= APBTMR_CONTROL_INT;
-	apbt_writel(timer, ctrl, APBTMR_N_CONTROL);
+	apbt_writel(timer, ctrl, timer->reg_control);
 }
 
 /**
@@ -81,7 +90,7 @@ void dw_apb_clockevent_pause(struct dw_apb_clock_event_device *dw_ced)
 
 static void apbt_eoi(struct dw_apb_timer *timer)
 {
-	apbt_readl(timer, APBTMR_N_EOI);
+	apbt_readl(timer, timer->reg_eoi);
 }
 
 static irqreturn_t dw_apb_clockevent_irq(int irq, void *data)
@@ -103,11 +112,11 @@ static irqreturn_t dw_apb_clockevent_irq(int irq, void *data)
 
 static void apbt_enable_int(struct dw_apb_timer *timer)
 {
-	unsigned long ctrl = apbt_readl(timer, APBTMR_N_CONTROL);
+	unsigned long ctrl = apbt_readl(timer, timer->reg_control);
 	/* clear pending intr */
-	apbt_readl(timer, APBTMR_N_EOI);
+	apbt_readl(timer, timer->reg_eoi);
 	ctrl &= ~APBTMR_CONTROL_INT;
-	apbt_writel(timer, ctrl, APBTMR_N_CONTROL);
+	apbt_writel(timer, ctrl, timer->reg_control);
 }
 
 static void apbt_set_mode(enum clock_event_mode mode,
@@ -116,31 +125,32 @@ static void apbt_set_mode(enum clock_event_mode mode,
 	unsigned long ctrl;
 	unsigned long period;
 	struct dw_apb_clock_event_device *dw_ced = ced_to_dw_apb_ced(evt);
+	struct dw_apb_timer *timer = &dw_ced->timer;
 
 	pr_debug("%s CPU %d mode=%d\n", __func__, first_cpu(*evt->cpumask),
 		 mode);
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		period = DIV_ROUND_UP(dw_ced->timer.freq, HZ);
-		ctrl = apbt_readl(&dw_ced->timer, APBTMR_N_CONTROL);
+		period = DIV_ROUND_UP(timer->freq, HZ);
+		ctrl = apbt_readl(timer, timer->reg_control);
 		ctrl |= APBTMR_CONTROL_MODE_PERIODIC;
-		apbt_writel(&dw_ced->timer, ctrl, APBTMR_N_CONTROL);
+		apbt_writel(timer, ctrl, timer->reg_control);
 		/*
 		 * DW APB p. 46, have to disable timer before load counter,
 		 * may cause sync problem.
 		 */
 		ctrl &= ~APBTMR_CONTROL_ENABLE;
-		apbt_writel(&dw_ced->timer, ctrl, APBTMR_N_CONTROL);
+		apbt_writel(timer, ctrl, timer->reg_control);
 		udelay(1);
 		pr_debug("Setting clock period %lu for HZ %d\n", period, HZ);
-		apbt_writel(&dw_ced->timer, period, APBTMR_N_LOAD_COUNT);
+		apbt_writel(timer, period, timer->reg_load_count);
 		ctrl |= APBTMR_CONTROL_ENABLE;
-		apbt_writel(&dw_ced->timer, ctrl, APBTMR_N_CONTROL);
+		apbt_writel(timer, ctrl, timer->reg_control);
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
-		ctrl = apbt_readl(&dw_ced->timer, APBTMR_N_CONTROL);
+		ctrl = apbt_readl(timer, timer->reg_control);
 		/*
 		 * set free running mode, this mode will let timer reload max
 		 * timeout which will give time (3min on 25MHz clock) to rearm
@@ -149,29 +159,29 @@ static void apbt_set_mode(enum clock_event_mode mode,
 		ctrl &= ~APBTMR_CONTROL_ENABLE;
 		ctrl &= ~APBTMR_CONTROL_MODE_PERIODIC;
 
-		apbt_writel(&dw_ced->timer, ctrl, APBTMR_N_CONTROL);
+		apbt_writel(timer, ctrl, timer->reg_control);
 		/* write again to set free running mode */
-		apbt_writel(&dw_ced->timer, ctrl, APBTMR_N_CONTROL);
+		apbt_writel(timer, ctrl, timer->reg_control);
 
 		/*
 		 * DW APB p. 46, load counter with all 1s before starting free
 		 * running mode.
 		 */
-		apbt_writel(&dw_ced->timer, ~0, APBTMR_N_LOAD_COUNT);
+		apbt_writel(timer, ~0, timer->reg_load_count);
 		ctrl &= ~APBTMR_CONTROL_INT;
 		ctrl |= APBTMR_CONTROL_ENABLE;
-		apbt_writel(&dw_ced->timer, ctrl, APBTMR_N_CONTROL);
+		apbt_writel(timer, ctrl, timer->reg_control);
 		break;
 
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		ctrl = apbt_readl(&dw_ced->timer, APBTMR_N_CONTROL);
+		ctrl = apbt_readl(timer, timer->reg_control);
 		ctrl &= ~APBTMR_CONTROL_ENABLE;
-		apbt_writel(&dw_ced->timer, ctrl, APBTMR_N_CONTROL);
+		apbt_writel(timer, ctrl, timer->reg_control);
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
-		apbt_enable_int(&dw_ced->timer);
+		apbt_enable_int(timer);
 		break;
 	}
 }
@@ -181,15 +191,16 @@ static int apbt_next_event(unsigned long delta,
 {
 	unsigned long ctrl;
 	struct dw_apb_clock_event_device *dw_ced = ced_to_dw_apb_ced(evt);
+	struct dw_apb_timer *timer = &dw_ced->timer;
 
 	/* Disable timer */
-	ctrl = apbt_readl(&dw_ced->timer, APBTMR_N_CONTROL);
+	ctrl = apbt_readl(timer, timer->reg_control);
 	ctrl &= ~APBTMR_CONTROL_ENABLE;
-	apbt_writel(&dw_ced->timer, ctrl, APBTMR_N_CONTROL);
+	apbt_writel(timer, ctrl, timer->reg_control);
 	/* write new count */
-	apbt_writel(&dw_ced->timer, delta, APBTMR_N_LOAD_COUNT);
+	apbt_writel(timer, delta, timer->reg_load_count);
 	ctrl |= APBTMR_CONTROL_ENABLE;
-	apbt_writel(&dw_ced->timer, ctrl, APBTMR_N_CONTROL);
+	apbt_writel(timer, ctrl, timer->reg_control);
 
 	return 0;
 }
@@ -227,6 +238,7 @@ dw_apb_clockevent_init(int cpu, const char *name, unsigned rating,
 	dw_ced->timer.irq = irq;
 	dw_ced->timer.freq = freq;
 	dw_ced->timer.quirks = quirks;
+	apbt_init_regs(&dw_ced->timer, quirks);
 
 	clockevents_calc_mult_shift(&dw_ced->ced, freq, APBT_MIN_PERIOD);
 	dw_ced->ced.max_delta_ns = clockevent_delta2ns(0x7fffffff,
@@ -286,9 +298,11 @@ void dw_apb_clockevent_stop(struct dw_apb_clock_event_device *dw_ced)
  */
 void dw_apb_clockevent_register(struct dw_apb_clock_event_device *dw_ced)
 {
-	apbt_writel(&dw_ced->timer, 0, APBTMR_N_CONTROL);
+	struct dw_apb_timer *timer = &dw_ced->timer;
+
+	apbt_writel(timer, 0, timer->reg_control);
 	clockevents_register_device(&dw_ced->ced);
-	apbt_enable_int(&dw_ced->timer);
+	apbt_enable_int(timer);
 }
 
 /**
@@ -301,19 +315,20 @@ void dw_apb_clockevent_register(struct dw_apb_clock_event_device *dw_ced)
  */
 void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs)
 {
+	struct dw_apb_timer *timer = &dw_cs->timer;
 	/*
 	 * start count down from 0xffff_ffff. this is done by toggling the
 	 * enable bit then load initial load count to ~0.
 	 */
-	unsigned long ctrl = apbt_readl(&dw_cs->timer, APBTMR_N_CONTROL);
+	unsigned long ctrl = apbt_readl(timer, timer->reg_control);
 
 	ctrl &= ~APBTMR_CONTROL_ENABLE;
-	apbt_writel(&dw_cs->timer, ctrl, APBTMR_N_CONTROL);
-	apbt_writel(&dw_cs->timer, ~0, APBTMR_N_LOAD_COUNT);
+	apbt_writel(timer, ctrl, timer->reg_control);
+	apbt_writel(timer, ~0, timer->reg_load_count);
 	/* enable, mask interrupt */
 	ctrl &= ~APBTMR_CONTROL_MODE_PERIODIC;
 	ctrl |= (APBTMR_CONTROL_ENABLE | APBTMR_CONTROL_INT);
-	apbt_writel(&dw_cs->timer, ctrl, APBTMR_N_CONTROL);
+	apbt_writel(timer, ctrl, timer->reg_control);
 	/* read it once to get cached counter value initialized */
 	dw_apb_clocksource_read(dw_cs);
 }
@@ -323,8 +338,9 @@ static cycle_t __apbt_read_clocksource(struct clocksource *cs)
 	unsigned long current_count;
 	struct dw_apb_clocksource *dw_cs =
 		clocksource_to_dw_apb_clocksource(cs);
+	struct dw_apb_timer *timer = &dw_cs->timer;
 
-	current_count = apbt_readl(&dw_cs->timer, APBTMR_N_CURRENT_VALUE);
+	current_count = apbt_readl(timer, timer->reg_current_value);
 
 	return (cycle_t)~current_count;
 }
@@ -361,6 +377,8 @@ dw_apb_clocksource_init(unsigned rating, const char *name, void __iomem *base,
 	dw_cs->timer.base = base;
 	dw_cs->timer.freq = freq;
 	dw_cs->timer.quirks = quirks;
+	apbt_init_regs(&dw_cs->timer, quirks);
+
 	dw_cs->cs.name = name;
 	dw_cs->cs.rating = rating;
 	dw_cs->cs.read = __apbt_read_clocksource;
@@ -388,7 +406,8 @@ void dw_apb_clocksource_register(struct dw_apb_clocksource *dw_cs)
  */
 cycle_t dw_apb_clocksource_read(struct dw_apb_clocksource *dw_cs)
 {
-	return (cycle_t)~apbt_readl(&dw_cs->timer, APBTMR_N_CURRENT_VALUE);
+	struct dw_apb_timer *timer = &dw_cs->timer;
+	return (cycle_t)~apbt_readl(timer, timer->reg_current_value);
 }
 
 /**
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index 67d09c7..7dc7166 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -24,6 +24,11 @@ struct dw_apb_timer {
 	unsigned long				freq;
 	int					irq;
 	int					quirks;
+	u8					reg_load_count;
+	u8					reg_current_value;
+	u8					reg_control;
+	u8					reg_eoi;
+	u8					reg_int_status;
 };
 
 struct dw_apb_clock_event_device {
-- 
1.7.10.4

