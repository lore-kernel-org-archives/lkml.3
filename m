Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbaDXWta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:49:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40986 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbaDXVov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:44:51 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 19/26] ARM: OMAP: dmtimer: Remove API __omap_dm_timer_load_start
Date: Thu, 24 Apr 2014 16:44:02 -0500
Message-ID: <1398375849-6017-20-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398375849-6017-1-git-send-email-joelf@ti.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fold back functionality of __omap_dm_timer_load_start from the header into the
public dmtimer.c omap_dmtimer_set_load_start API, and convert all dependencies
to use it. All users should use the existing omap_dmtimer_set_load_start
function for such uses.  This is in the direction of making the system timer
code independent of the private functions which we're trying to eliminate so
that they can just use the public ones which we want to expose.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c                  |   17 +++++--------
 arch/arm/plat-omap/dmtimer.c                 |   34 +++++++++++++++-----------
 arch/arm/plat-omap/include/plat/dmtimer.h    |   12 ++-------
 drivers/staging/tidspbridge/core/dsp-clock.c |    2 +-
 4 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 81a29b1..6735e2f 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -95,8 +95,7 @@ static struct irqaction omap2_gp_timer_irq = {
 static int omap2_gp_timer_set_next_event(unsigned long cycles,
 					 struct clock_event_device *evt)
 {
-	__omap_dm_timer_load_start(&clkev, 0,
-				   0xffffffff - cycles, OMAP_TIMER_POSTED);
+	omap_dm_timer_set_load_start(&clkev, 0xffffffff - cycles, 0, 0);
 
 	return 0;
 }
@@ -112,12 +111,7 @@ static void omap2_gp_timer_set_mode(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_PERIODIC:
 		period = clkev.rate / HZ;
 		period -= 1;
-		/* Looks like we need to first set the load value separately */
-		__omap_dm_timer_write(&clkev, OMAP_TIMER_LOAD_REG,
-				      0xffffffff - period, OMAP_TIMER_POSTED);
-		__omap_dm_timer_load_start(&clkev,
-					OMAP_TIMER_CTRL_AR,
-					0xffffffff - period, OMAP_TIMER_POSTED);
+		omap_dm_timer_set_load_start(&clkev, 0xffffffff - period, 1, 0);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
 		break;
@@ -259,6 +253,8 @@ static int legacy_hwmod_clkget(struct omap_dm_timer *timer, const char *oh_name)
 	timer->fclk = clk_get(NULL, omap_hwmod_get_main_clk(oh));
 	if (IS_ERR(timer->fclk))
 		return PTR_ERR(timer->fclk);
+
+	return 0;
 }
 
 static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
@@ -528,9 +524,8 @@ static void __init omap2_gptimer_clocksource_init(int gptimer_id,
 
 	clocksource_gpt.name = "timer_clksrc";
 
-	__omap_dm_timer_load_start(&clksrc,
-				   OMAP_TIMER_CTRL_AR, 0,
-				   OMAP_TIMER_NONPOSTED);
+	omap_dm_timer_set_load_start(&clksrc, 0, 1, 0);
+
 	sched_clock_register(dmtimer_read_sched_clock, 32, clksrc.rate);
 
 	if (clocksource_register_hz(&clocksource_gpt, clksrc.rate))
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index b52d34d..dee70be 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -571,33 +571,39 @@ int omap_dm_timer_set_load(struct omap_dm_timer *timer, int autoreload,
 EXPORT_SYMBOL_GPL(omap_dm_timer_set_load);
 
 /* Optimized set_load which removes costly spin wait in timer_start */
-int omap_dm_timer_set_load_start(struct omap_dm_timer *timer, int autoreload,
-                            unsigned int load)
+int omap_dm_timer_set_load_start(struct omap_dm_timer *timer, unsigned int load,
+				 int autoreload, int pm)
 {
-	u32 l;
 	int rc;
+	u32 mask = ~0, val = 0;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	rc = omap_dm_timer_enable(timer);
-	if (rc)
-		return rc;
+	if (pm) {
+		rc = omap_dm_timer_enable(timer);
+		if (rc)
+			return rc;
+	}
 
-	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
 	if (autoreload) {
-		l |= OMAP_TIMER_CTRL_AR;
+		val |= OMAP_TIMER_CTRL_AR;
 		omap_dm_timer_write_reg(timer, OMAP_TIMER_LOAD_REG, load);
 	} else {
-		l &= ~OMAP_TIMER_CTRL_AR;
+		mask &= ~OMAP_TIMER_CTRL_AR;
 	}
 
-	__omap_dm_timer_load_start(timer, l, load, timer->posted);
+	val |= OMAP_TIMER_CTRL_ST;
 
-	/* Save the context */
-	timer->context.tclr = l;
-	timer->context.tldr = load;
-	timer->context.tcrr = load;
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_COUNTER_REG, load);
+	val = omap_dm_timer_write_ctrl(timer, mask, val);
+
+	if (pm) {
+		/* Save the context */
+		timer->context.tclr = val;
+		timer->context.tldr = load;
+		timer->context.tcrr = load;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_set_load_start);
diff --git a/arch/arm/plat-omap/include/plat/dmtimer.h b/arch/arm/plat-omap/include/plat/dmtimer.h
index 6b6fbd2..7432bf3 100644
--- a/arch/arm/plat-omap/include/plat/dmtimer.h
+++ b/arch/arm/plat-omap/include/plat/dmtimer.h
@@ -145,7 +145,8 @@ int omap_dm_timer_stop(struct omap_dm_timer *timer);
 
 int omap_dm_timer_set_source(struct omap_dm_timer *timer, int source);
 int omap_dm_timer_set_load(struct omap_dm_timer *timer, int autoreload, unsigned int value);
-int omap_dm_timer_set_load_start(struct omap_dm_timer *timer, int autoreload, unsigned int value);
+int omap_dm_timer_set_load_start(struct omap_dm_timer *timer, unsigned int load,
+				 int autoreload, int pm);
 int omap_dm_timer_set_match(struct omap_dm_timer *timer, int enable, unsigned int match);
 int omap_dm_timer_set_pwm(struct omap_dm_timer *timer, int def_on, int toggle, int trigger);
 int omap_dm_timer_set_prescaler(struct omap_dm_timer *timer, int prescaler);
@@ -389,15 +390,6 @@ static inline void __omap_dm_timer_stop(struct omap_dm_timer *timer,
 	__raw_writel(OMAP_TIMER_INT_OVERFLOW, timer->irq_stat);
 }
 
-static inline void __omap_dm_timer_load_start(struct omap_dm_timer *timer,
-						u32 ctrl, unsigned int load,
-						int posted)
-{
-	ctrl |= OMAP_TIMER_CTRL_ST;
-	__omap_dm_timer_write(timer, OMAP_TIMER_COUNTER_REG, load, posted);
-	__omap_dm_timer_write(timer, OMAP_TIMER_CTRL_REG, ctrl, posted);
-}
-
 static inline void __omap_dm_timer_int_enable(struct omap_dm_timer *timer,
 						unsigned int value)
 {
diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index 2f084e18..2788158 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -189,7 +189,7 @@ void dsp_gpt_wait_overflow(short int clk_id, unsigned int load)
 	 * Set counter value to overflow counter after
 	 * one tick and start timer.
 	 */
-	omap_dm_timer_set_load_start(gpt, 0, load);
+	omap_dm_timer_set_load_start(gpt, load, 0, 1);
 
 	/* Wait 80us for timer to overflow */
 	udelay(80);
-- 
1.7.9.5

