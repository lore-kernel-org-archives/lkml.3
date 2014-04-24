Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaDXVpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:45:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40991 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbaDXVo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:44:56 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 24/26] ARM: OMAP: dmtimer: Move private functions into dmtimer core and export others
Date: Thu, 24 Apr 2014 16:44:07 -0500
Message-ID: <1398375849-6017-25-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398375849-6017-1-git-send-email-joelf@ti.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap_dm_timer_read/write are no longer used by anyone else outside of dmtimer.c,
This allows us to remove it completely from the dmtimer.h header.

The reset of the functions are moved into dmtimer.c and the "__" prefix is removed,
and they're exported for use by others such as OMAP2+ system timers.
omap_dm_timer_init_regs
omap_dm_timer_enable_posted
omap_dm_timer_override_errata
omap_dm_timer_int_enable

All other functions in dmtimer.h have been either removed, or folded into other similar
functions, and such users converted to use the one folded into.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c               |    8 +--
 arch/arm/plat-omap/dmtimer.c              |  105 ++++++++++++++++++++++++++++-
 arch/arm/plat-omap/include/plat/dmtimer.h |  103 ++--------------------------
 3 files changed, 113 insertions(+), 103 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 39b3e34..afb22eb 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -363,9 +363,9 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 
 	clk_put(src);
 
-	__omap_dm_timer_init_regs(timer);
+	omap_dm_timer_init_regs(timer);
 	if (posted)
-		__omap_dm_timer_enable_posted(timer);
+		omap_dm_timer_enable_posted(timer);
 
 	/* Check that the intended posted configuration matches the actual */
 	if (posted != timer->posted)
@@ -391,7 +391,7 @@ static void __init omap2_gp_clockevent_init(int gptimer_id,
 	 * so we are not impacted by errata i103 and i767. Therefore,
 	 * we can safely ignore this errata for clock-event timers.
 	 */
-	__omap_dm_timer_override_errata(&clkev, OMAP_TIMER_ERRATA_I103_I767);
+	omap_dm_timer_override_errata(&clkev, OMAP_TIMER_ERRATA_I103_I767);
 
 	clockevent_gpt.name = "timer_clkev";
 
@@ -402,7 +402,7 @@ static void __init omap2_gp_clockevent_init(int gptimer_id,
 	omap2_gp_timer_irq.dev_id = &clkev;
 	setup_irq(clkev.irq, &omap2_gp_timer_irq);
 
-	__omap_dm_timer_int_enable(&clkev, OMAP_TIMER_INT_OVERFLOW);
+	omap_dm_timer_int_enable(&clkev, OMAP_TIMER_INT_OVERFLOW);
 
 	clockevent_gpt.cpumask = cpu_possible_mask;
 	clockevent_gpt.irq = omap_dm_timer_get_irq(&clkev);
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 44cc336..f7c1d14 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -59,6 +59,26 @@ enum {
 	REQUEST_BY_NODE,
 };
 
+static inline u32 __omap_dm_timer_read(struct omap_dm_timer *timer, u32 reg,
+		int posted)
+{
+	if (posted)
+		while (__raw_readl(timer->pend) & (reg >> WPSHIFT))
+			cpu_relax();
+
+	return __raw_readl(timer->func_base + (reg & 0xff));
+}
+
+static inline void __omap_dm_timer_write(struct omap_dm_timer *timer,
+		u32 reg, u32 val, int posted)
+{
+	if (posted)
+		while (__raw_readl(timer->pend) & (reg >> WPSHIFT))
+			cpu_relax();
+
+	__raw_writel(val, timer->func_base + (reg & 0xff));
+}
+
 /**
  * omap_dm_timer_read_reg - read timer registers in posted and non-posted mode
  * @timer:      timer pointer over which read operation to perform
@@ -176,7 +196,7 @@ static int omap_dm_timer_prepare(struct omap_dm_timer *timer)
 		}
 	}
 
-	__omap_dm_timer_enable_posted(timer);
+	omap_dm_timer_enable_posted(timer);
 	omap_dm_timer_disable(timer);
 
 	/*
@@ -201,6 +221,85 @@ int omap_dm_timer_reserve_systimer(int id)
 	return 0;
 }
 
+void omap_dm_timer_init_regs(struct omap_dm_timer *timer)
+{
+	u32 tidr;
+
+	/* Assume v1 ip if bits [31:16] are zero */
+	tidr = __raw_readl(timer->io_base);
+	if (!(tidr >> 16)) {
+		timer->revision = 1;
+		timer->irq_stat = timer->io_base + OMAP_TIMER_V1_STAT_OFFSET;
+		timer->irq_ena = timer->io_base + OMAP_TIMER_V1_INT_EN_OFFSET;
+		timer->irq_dis = timer->io_base + OMAP_TIMER_V1_INT_EN_OFFSET;
+		timer->pend = timer->io_base + _OMAP_TIMER_WRITE_PEND_OFFSET;
+		timer->func_base = timer->io_base;
+	} else {
+		timer->revision = 2;
+		timer->irq_stat = timer->io_base + OMAP_TIMER_V2_IRQSTATUS;
+		timer->irq_ena = timer->io_base + OMAP_TIMER_V2_IRQENABLE_SET;
+		timer->irq_dis = timer->io_base + OMAP_TIMER_V2_IRQENABLE_CLR;
+		timer->pend = timer->io_base +
+			_OMAP_TIMER_WRITE_PEND_OFFSET +
+				OMAP_TIMER_V2_FUNC_OFFSET;
+		timer->func_base = timer->io_base + OMAP_TIMER_V2_FUNC_OFFSET;
+	}
+}
+EXPORT_SYMBOL_GPL(omap_dm_timer_init_regs);
+
+/*
+ * omap_dm_timer_enable_posted - enables write posted mode
+ * @timer:      pointer to timer instance handle
+ *
+ * Enables the write posted mode for the timer. When posted mode is enabled
+ * writes to certain timer registers are immediately acknowledged by the
+ * internal bus and hence prevents stalling the CPU waiting for the write to
+ * complete. Enabling this feature can improve performance for writing to the
+ * timer registers.
+ */
+void omap_dm_timer_enable_posted(struct omap_dm_timer *timer)
+{
+	if (timer->posted)
+		return;
+
+	if (timer->errata & OMAP_TIMER_ERRATA_I103_I767) {
+		timer->posted = OMAP_TIMER_NONPOSTED;
+		__omap_dm_timer_write(timer, OMAP_TIMER_IF_CTRL_REG, 0, 0);
+		return;
+	}
+
+	__omap_dm_timer_write(timer, OMAP_TIMER_IF_CTRL_REG,
+			      OMAP_TIMER_CTRL_POSTED, 0);
+	timer->context.tsicr = OMAP_TIMER_CTRL_POSTED;
+	timer->posted = OMAP_TIMER_POSTED;
+}
+EXPORT_SYMBOL_GPL(omap_dm_timer_enable_posted);
+
+/**
+ * omap_dm_timer_override_errata - override errata flags for a timer
+ * @timer:      pointer to timer handle
+ * @errata:	errata flags to be ignored
+ *
+ * For a given timer, override a timer errata by clearing the flags
+ * specified by the errata argument. A specific erratum should only be
+ * overridden for a timer if the timer is used in such a way the erratum
+ * has no impact.
+ */
+void omap_dm_timer_override_errata(struct omap_dm_timer *timer,
+						   u32 errata)
+{
+	timer->errata &= ~errata;
+}
+EXPORT_SYMBOL_GPL(omap_dm_timer_override_errata);
+
+void omap_dm_timer_int_enable(struct omap_dm_timer *timer,
+						unsigned int value)
+{
+	__raw_writel(value, timer->irq_ena);
+	__omap_dm_timer_write(timer, OMAP_TIMER_WAKEUP_EN_REG, value, 0);
+}
+EXPORT_SYMBOL_GPL(omap_dm_timer_int_enable);
+
 /*
  * Check if a timer is running based on timer_id, used for OMAP1 currently.
  */
@@ -722,7 +821,7 @@ int omap_dm_timer_set_int_enable(struct omap_dm_timer *timer,
 	if (rc)
 		return rc;
 
-	__omap_dm_timer_int_enable(timer, value);
+	omap_dm_timer_int_enable(timer, value);
 
 	/* Save the context */
 	timer->context.tier = value;
@@ -917,7 +1016,7 @@ static int omap_dm_timer_probe(struct platform_device *pdev)
 
 	if (!timer->reserved) {
 		pm_runtime_get_sync(dev);
-		__omap_dm_timer_init_regs(timer);
+		omap_dm_timer_init_regs(timer);
 		pm_runtime_put(dev);
 	}
 
diff --git a/arch/arm/plat-omap/include/plat/dmtimer.h b/arch/arm/plat-omap/include/plat/dmtimer.h
index 6ab801b..9b52607 100644
--- a/arch/arm/plat-omap/include/plat/dmtimer.h
+++ b/arch/arm/plat-omap/include/plat/dmtimer.h
@@ -162,6 +162,13 @@ int omap_dm_timer_write_counter(struct omap_dm_timer *timer, unsigned int value)
 
 int omap_dm_timers_active(void);
 
+void omap_dm_timer_init_regs(struct omap_dm_timer *timer);
+void omap_dm_timer_enable_posted(struct omap_dm_timer *timer);
+void omap_dm_timer_override_errata(struct omap_dm_timer *timer,
+				   u32 errata);
+void omap_dm_timer_int_enable(struct omap_dm_timer *timer,
+			      unsigned int value);
+
 /*
  * Do not use the defines below, they are not needed. They should be only
  * used by dmtimer.c and sys_timer related code.
@@ -278,100 +285,4 @@ int omap_dm_timers_active(void);
 
 #define OMAP_TIMER_TICK_INT_MASK_COUNT_REG				\
 		(_OMAP_TIMER_TICK_INT_MASK_COUNT_OFFSET | (WP_TOWR << WPSHIFT))
-
-static inline u32 __omap_dm_timer_read(struct omap_dm_timer *timer, u32 reg,
-						int posted)
-{
-	if (posted)
-		while (__raw_readl(timer->pend) & (reg >> WPSHIFT))
-			cpu_relax();
-
-	return __raw_readl(timer->func_base + (reg & 0xff));
-}
-
-static inline void __omap_dm_timer_write(struct omap_dm_timer *timer,
-					u32 reg, u32 val, int posted)
-{
-	if (posted)
-		while (__raw_readl(timer->pend) & (reg >> WPSHIFT))
-			cpu_relax();
-
-	__raw_writel(val, timer->func_base + (reg & 0xff));
-}
-
-static inline void __omap_dm_timer_init_regs(struct omap_dm_timer *timer)
-{
-	u32 tidr;
-
-	/* Assume v1 ip if bits [31:16] are zero */
-	tidr = __raw_readl(timer->io_base);
-	if (!(tidr >> 16)) {
-		timer->revision = 1;
-		timer->irq_stat = timer->io_base + OMAP_TIMER_V1_STAT_OFFSET;
-		timer->irq_ena = timer->io_base + OMAP_TIMER_V1_INT_EN_OFFSET;
-		timer->irq_dis = timer->io_base + OMAP_TIMER_V1_INT_EN_OFFSET;
-		timer->pend = timer->io_base + _OMAP_TIMER_WRITE_PEND_OFFSET;
-		timer->func_base = timer->io_base;
-	} else {
-		timer->revision = 2;
-		timer->irq_stat = timer->io_base + OMAP_TIMER_V2_IRQSTATUS;
-		timer->irq_ena = timer->io_base + OMAP_TIMER_V2_IRQENABLE_SET;
-		timer->irq_dis = timer->io_base + OMAP_TIMER_V2_IRQENABLE_CLR;
-		timer->pend = timer->io_base +
-			_OMAP_TIMER_WRITE_PEND_OFFSET +
-				OMAP_TIMER_V2_FUNC_OFFSET;
-		timer->func_base = timer->io_base + OMAP_TIMER_V2_FUNC_OFFSET;
-	}
-}
-
-/*
- * __omap_dm_timer_enable_posted - enables write posted mode
- * @timer:      pointer to timer instance handle
- *
- * Enables the write posted mode for the timer. When posted mode is enabled
- * writes to certain timer registers are immediately acknowledged by the
- * internal bus and hence prevents stalling the CPU waiting for the write to
- * complete. Enabling this feature can improve performance for writing to the
- * timer registers.
- */
-static inline void __omap_dm_timer_enable_posted(struct omap_dm_timer *timer)
-{
-	if (timer->posted)
-		return;
-
-	if (timer->errata & OMAP_TIMER_ERRATA_I103_I767) {
-		timer->posted = OMAP_TIMER_NONPOSTED;
-		__omap_dm_timer_write(timer, OMAP_TIMER_IF_CTRL_REG, 0, 0);
-		return;
-	}
-
-	__omap_dm_timer_write(timer, OMAP_TIMER_IF_CTRL_REG,
-			      OMAP_TIMER_CTRL_POSTED, 0);
-	timer->context.tsicr = OMAP_TIMER_CTRL_POSTED;
-	timer->posted = OMAP_TIMER_POSTED;
-}
-
-/**
- * __omap_dm_timer_override_errata - override errata flags for a timer
- * @timer:      pointer to timer handle
- * @errata:	errata flags to be ignored
- *
- * For a given timer, override a timer errata by clearing the flags
- * specified by the errata argument. A specific erratum should only be
- * overridden for a timer if the timer is used in such a way the erratum
- * has no impact.
- */
-static inline void __omap_dm_timer_override_errata(struct omap_dm_timer *timer,
-						   u32 errata)
-{
-	timer->errata &= ~errata;
-}
-
-static inline void __omap_dm_timer_int_enable(struct omap_dm_timer *timer,
-						unsigned int value)
-{
-	__raw_writel(value, timer->irq_ena);
-	__omap_dm_timer_write(timer, OMAP_TIMER_WAKEUP_EN_REG, value, 0);
-}
-
 #endif /* __ASM_ARCH_DMTIMER_H */
-- 
1.7.9.5

