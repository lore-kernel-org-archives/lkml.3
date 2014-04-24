Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbaDXWoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:44:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38828 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbaDXVpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:45:03 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 20/26] ARM: OMAP: dmtimer: Fold back private stop function
Date: Thu, 24 Apr 2014 16:44:03 -0500
Message-ID: <1398375849-6017-21-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398375849-6017-1-git-send-email-joelf@ti.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch, we fold back the functionality of the __omap_dm_timer_stop
function into omap_dm_timer_stop. This reduces code size as we don't need any
hacks or parameter passing. All public users are converted to use the
omap_dm_timer_stop function.  The clk rate is setup into the dmtimer structure
either by the early boot code for the specific platforms, or by calling a
clk_get_rate once the timer is requested and prepared.

We're also using omap_dm_timer_{read,write}_reg functions instead of underscore
prefixed ones so that avoids passing of posted flags.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c                  |    2 +-
 arch/arm/plat-omap/dmtimer.c                 |   45 ++++++++++++++++++--------
 arch/arm/plat-omap/include/plat/dmtimer.h    |   26 +--------------
 drivers/media/rc/ir-rx51.c                   |    4 +--
 drivers/staging/tidspbridge/core/dsp-clock.c |    2 +-
 5 files changed, 36 insertions(+), 43 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 6735e2f..2d8ea96 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -105,7 +105,7 @@ static void omap2_gp_timer_set_mode(enum clock_event_mode mode,
 {
 	u32 period;
 
-	__omap_dm_timer_stop(&clkev, OMAP_TIMER_POSTED, clkev.rate);
+	omap_dm_timer_stop(&clkev, 0);
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index dee70be..8602586 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -310,6 +310,12 @@ found:
 
 	if (!timer)
 		pr_debug("%s: timer request failed!\n", __func__);
+	/*
+	 * The prepare stage would've setup the parent clock or we wouldn't
+	 * get so far. Set the rate of the timer now.
+	 */
+	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET))
+		timer->rate = clk_get_rate(timer->fclk);
 
 	return timer;
 }
@@ -461,27 +467,38 @@ int omap_dm_timer_start(struct omap_dm_timer *timer)
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_start);
 
-int omap_dm_timer_stop(struct omap_dm_timer *timer)
+int omap_dm_timer_stop(struct omap_dm_timer *timer, int pm)
 {
-	unsigned long rate = 0;
+	u32 l;
+	unsigned long rate;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	/* OMAP1 is not converted to clk framework so avoid clk_get_rate here */
-	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET))
-		rate = clk_get_rate(timer->fclk);
+	rate = timer->rate;
+
+	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
+	if (l & OMAP_TIMER_CTRL_ST) {
+		l &= ~0x1;
+		omap_dm_timer_write_reg(timer, OMAP_TIMER_CTRL_REG, l);
+#ifdef CONFIG_ARCH_OMAP2PLUS
+		/* Readback to make sure write has completed */
+		omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
+		/*
+		 * Wait for functional clock period x 3.5 to make sure that
+		 * timer is stopped
+		 */
+		udelay(3500000 / rate + 1);
+#endif
+	}
 
-	__omap_dm_timer_stop(timer, timer->posted, rate);
+	/* Ack possibly pending interrupt */
+	__raw_writel(OMAP_TIMER_INT_OVERFLOW, timer->irq_stat);
 
-	/*
-	 * Since the register values are computed and written within
-	 * __omap_dm_timer_stop, we need to use read to retrieve the
-	 * context.
-	 */
-	timer->context.tclr =
-			omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
-	omap_dm_timer_disable(timer);
+	if (pm) {
+		timer->context.tclr = l;
+		omap_dm_timer_disable(timer);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_stop);
diff --git a/arch/arm/plat-omap/include/plat/dmtimer.h b/arch/arm/plat-omap/include/plat/dmtimer.h
index 7432bf3..1d3d9bb 100644
--- a/arch/arm/plat-omap/include/plat/dmtimer.h
+++ b/arch/arm/plat-omap/include/plat/dmtimer.h
@@ -141,7 +141,7 @@ struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer);
 
 int omap_dm_timer_trigger(struct omap_dm_timer *timer);
 int omap_dm_timer_start(struct omap_dm_timer *timer);
-int omap_dm_timer_stop(struct omap_dm_timer *timer);
+int omap_dm_timer_stop(struct omap_dm_timer *timer, int pm);
 
 int omap_dm_timer_set_source(struct omap_dm_timer *timer, int source);
 int omap_dm_timer_set_load(struct omap_dm_timer *timer, int autoreload, unsigned int value);
@@ -366,30 +366,6 @@ static inline void __omap_dm_timer_override_errata(struct omap_dm_timer *timer,
 	timer->errata &= ~errata;
 }
 
-static inline void __omap_dm_timer_stop(struct omap_dm_timer *timer,
-					int posted, unsigned long rate)
-{
-	u32 l;
-
-	l = __omap_dm_timer_read(timer, OMAP_TIMER_CTRL_REG, posted);
-	if (l & OMAP_TIMER_CTRL_ST) {
-		l &= ~0x1;
-		__omap_dm_timer_write(timer, OMAP_TIMER_CTRL_REG, l, posted);
-#ifdef CONFIG_ARCH_OMAP2PLUS
-		/* Readback to make sure write has completed */
-		__omap_dm_timer_read(timer, OMAP_TIMER_CTRL_REG, posted);
-		/*
-		 * Wait for functional clock period x 3.5 to make sure that
-		 * timer is stopped
-		 */
-		udelay(3500000 / rate + 1);
-#endif
-	}
-
-	/* Ack possibly pending interrupt */
-	__raw_writel(OMAP_TIMER_INT_OVERFLOW, timer->irq_stat);
-}
-
 static inline void __omap_dm_timer_int_enable(struct omap_dm_timer *timer,
 						unsigned int value)
 {
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index b1e19a2..3dc736d 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -165,8 +165,8 @@ end:
 	/* Stop TX here */
 	lirc_rx51_off(lirc_rx51);
 	lirc_rx51->wbuf_index = -1;
-	omap_dm_timer_stop(lirc_rx51->pwm_timer);
-	omap_dm_timer_stop(lirc_rx51->pulse_timer);
+	omap_dm_timer_stop(lirc_rx51->pwm_timer, 1);
+	omap_dm_timer_stop(lirc_rx51->pulse_timer, 1);
 	omap_dm_timer_set_int_enable(lirc_rx51->pulse_timer, 0);
 	wake_up_interruptible(&lirc_rx51->wqueue);
 
diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index 2788158..6ac36d1 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -300,7 +300,7 @@ int dsp_clk_disable(enum dsp_clk_id clk_id)
 		clk_disable(iva2_clk);
 		break;
 	case GPT_CLK:
-		status = omap_dm_timer_stop(timer[clk_id - 1]);
+		status = omap_dm_timer_stop(timer[clk_id - 1], 1);
 		break;
 #ifdef CONFIG_OMAP_MCBSP
 	case MCBSP_CLK:
-- 
1.7.9.5

