Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161500AbaDQAD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:03:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33636 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbaDQADy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:03:54 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Rajendra Nayak <rnayak@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 7/9] ARM: OMAP: dmtimer: Have __omap_dm_timer_load_start set ST bit in CTRL instead of caller
Date: Wed, 16 Apr 2014 19:03:17 -0500
Message-ID: <1397692999-7800-7-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397692999-7800-1-git-send-email-joelf@ti.com>
References: <1397692999-7800-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"load_start" implies start, so it makes sense to set the ST bit in
__omap_dm_timer_load_start instead of callers.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c               |    6 +++---
 arch/arm/plat-omap/dmtimer.c              |    1 -
 arch/arm/plat-omap/include/plat/dmtimer.h |    1 +
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 74044aa..dfb19df 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -95,7 +95,7 @@ static struct irqaction omap2_gp_timer_irq = {
 static int omap2_gp_timer_set_next_event(unsigned long cycles,
 					 struct clock_event_device *evt)
 {
-	__omap_dm_timer_load_start(&clkev, OMAP_TIMER_CTRL_ST,
+	__omap_dm_timer_load_start(&clkev, 0,
 				   0xffffffff - cycles, OMAP_TIMER_POSTED);
 
 	return 0;
@@ -116,7 +116,7 @@ static void omap2_gp_timer_set_mode(enum clock_event_mode mode,
 		__omap_dm_timer_write(&clkev, OMAP_TIMER_LOAD_REG,
 				      0xffffffff - period, OMAP_TIMER_POSTED);
 		__omap_dm_timer_load_start(&clkev,
-					OMAP_TIMER_CTRL_AR | OMAP_TIMER_CTRL_ST,
+					OMAP_TIMER_CTRL_AR,
 					0xffffffff - period, OMAP_TIMER_POSTED);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
@@ -469,7 +469,7 @@ static void __init omap2_gptimer_clocksource_init(int gptimer_id,
 	BUG_ON(res);
 
 	__omap_dm_timer_load_start(&clksrc,
-				   OMAP_TIMER_CTRL_ST | OMAP_TIMER_CTRL_AR, 0,
+				   OMAP_TIMER_CTRL_AR, 0,
 				   OMAP_TIMER_NONPOSTED);
 	sched_clock_register(dmtimer_read_sched_clock, 32, clksrc.rate);
 
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 782ff10..8a4a97c 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -573,7 +573,6 @@ int omap_dm_timer_set_load_start(struct omap_dm_timer *timer, int autoreload,
 	} else {
 		l &= ~OMAP_TIMER_CTRL_AR;
 	}
-	l |= OMAP_TIMER_CTRL_ST;
 
 	__omap_dm_timer_load_start(timer, l, load, timer->posted);
 
diff --git a/arch/arm/plat-omap/include/plat/dmtimer.h b/arch/arm/plat-omap/include/plat/dmtimer.h
index 16ea9fd..fe3780a 100644
--- a/arch/arm/plat-omap/include/plat/dmtimer.h
+++ b/arch/arm/plat-omap/include/plat/dmtimer.h
@@ -393,6 +393,7 @@ static inline void __omap_dm_timer_load_start(struct omap_dm_timer *timer,
 						u32 ctrl, unsigned int load,
 						int posted)
 {
+	ctrl |= OMAP_TIMER_CTRL_ST;
 	__omap_dm_timer_write(timer, OMAP_TIMER_COUNTER_REG, load, posted);
 	__omap_dm_timer_write(timer, OMAP_TIMER_CTRL_REG, ctrl, posted);
 }
-- 
1.7.9.5

