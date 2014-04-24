Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbaDXWq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:46:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53150 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbaDXVpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:45:01 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 25/26] ARM: OMAP: dmtimer: Eliminate omap_dm_timer_int_enable function
Date: Thu, 24 Apr 2014 16:44:08 -0500
Message-ID: <1398375849-6017-26-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398375849-6017-1-git-send-email-joelf@ti.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fold this function back into omap_dm_timer_set_int_enable and
use the systimer flag to not call PM functions for system timer.
Then remove it from the header file, and convert users to use
omap_dm_timer_set_int_enable.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c               |    2 +-
 arch/arm/plat-omap/dmtimer.c              |   48 +++++++++++++++--------------
 arch/arm/plat-omap/include/plat/dmtimer.h |    3 --
 3 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index afb22eb..ba75385 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -402,7 +402,7 @@ static void __init omap2_gp_clockevent_init(int gptimer_id,
 	omap2_gp_timer_irq.dev_id = &clkev;
 	setup_irq(clkev.irq, &omap2_gp_timer_irq);
 
-	omap_dm_timer_int_enable(&clkev, OMAP_TIMER_INT_OVERFLOW);
+	omap_dm_timer_set_int_enable(&clkev, OMAP_TIMER_INT_OVERFLOW);
 
 	clockevent_gpt.cpumask = cpu_possible_mask;
 	clockevent_gpt.irq = omap_dm_timer_get_irq(&clkev);
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index f7c1d14..1059881 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -292,14 +292,6 @@ void omap_dm_timer_override_errata(struct omap_dm_timer *timer,
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_override_errata);
 
-void omap_dm_timer_int_enable(struct omap_dm_timer *timer,
-						unsigned int value)
-{
-	__raw_writel(value, timer->irq_ena);
-	__omap_dm_timer_write(timer, OMAP_TIMER_WAKEUP_EN_REG, value, 0);
-}
-EXPORT_SYMBOL_GPL(omap_dm_timer_int_enable);
-
 /*
  * Check if a timer is running based on timer_id, used for OMAP1 currently.
  */
@@ -817,16 +809,21 @@ int omap_dm_timer_set_int_enable(struct omap_dm_timer *timer,
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	rc = omap_dm_timer_enable(timer);
-	if (rc)
-		return rc;
+	if (!timer->systimer) {
+		rc = omap_dm_timer_enable(timer);
+		if (rc)
+			return rc;
+	}
 
-	omap_dm_timer_int_enable(timer, value);
+	__raw_writel(value, timer->irq_ena);
+	__omap_dm_timer_write(timer, OMAP_TIMER_WAKEUP_EN_REG, value, 0);
 
-	/* Save the context */
-	timer->context.tier = value;
-	timer->context.twer = value;
-	omap_dm_timer_disable(timer);
+	if (!timer->systimer) {
+		/* Save the context */
+		timer->context.tier = value;
+		timer->context.twer = value;
+		omap_dm_timer_disable(timer);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_set_int_enable);
@@ -846,9 +843,11 @@ int omap_dm_timer_set_int_disable(struct omap_dm_timer *timer, u32 mask)
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	rc = omap_dm_timer_enable(timer);
-	if (rc)
-		return rc;
+	if (!timer->systimer) {
+		rc = omap_dm_timer_enable(timer);
+		if (rc)
+			return rc;
+	}
 
 	if (timer->revision == 1)
 		l = __raw_readl(timer->irq_ena) & ~mask;
@@ -857,10 +856,13 @@ int omap_dm_timer_set_int_disable(struct omap_dm_timer *timer, u32 mask)
 	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_WAKEUP_EN_REG) & ~mask;
 	omap_dm_timer_write_reg(timer, OMAP_TIMER_WAKEUP_EN_REG, l);
 
-	/* Save the context */
-	timer->context.tier &= ~mask;
-	timer->context.twer &= ~mask;
-	omap_dm_timer_disable(timer);
+
+	if (!timer->systimer) {
+		/* Save the context */
+		timer->context.tier &= ~mask;
+		timer->context.twer &= ~mask;
+		omap_dm_timer_disable(timer);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_set_int_disable);
diff --git a/arch/arm/plat-omap/include/plat/dmtimer.h b/arch/arm/plat-omap/include/plat/dmtimer.h
index 9b52607..2f27dca 100644
--- a/arch/arm/plat-omap/include/plat/dmtimer.h
+++ b/arch/arm/plat-omap/include/plat/dmtimer.h
@@ -166,9 +166,6 @@ void omap_dm_timer_init_regs(struct omap_dm_timer *timer);
 void omap_dm_timer_enable_posted(struct omap_dm_timer *timer);
 void omap_dm_timer_override_errata(struct omap_dm_timer *timer,
 				   u32 errata);
-void omap_dm_timer_int_enable(struct omap_dm_timer *timer,
-			      unsigned int value);
-
 /*
  * Do not use the defines below, they are not needed. They should be only
  * used by dmtimer.c and sys_timer related code.
-- 
1.7.9.5

