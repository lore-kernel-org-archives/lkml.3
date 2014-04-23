Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbaDWB2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:28:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46799 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619AbaDWB2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:28:00 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 2/8] ARM: OMAP2+: timer: Simplify clock event/source name setting
Date: Tue, 22 Apr 2014 20:27:03 -0500
Message-ID: <1398216429-4681-3-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398216429-4681-1-git-send-email-joelf@ti.com>
References: <1398216429-4681-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the OMAPs, we're setting up only one clockevent and clocksource. Further,
for DT boot there's no easy way to get the timer name and currently this is
done in an ugly way by reading a hwmod entry. So let's just set it to a simpler
name like timer_clkev and timer_clksrc.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index ec427e6..f192a41 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -251,7 +251,6 @@ static u32 __init omap_dm_timer_get_errata(void)
 static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 					 const char *fck_source,
 					 const char *property,
-					 const char **timer_name,
 					 int posted)
 {
 	char name[10]; /* 10 = sizeof("gptXX_Xck0") */
@@ -290,8 +289,6 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 	if (!oh)
 		return -ENODEV;
 
-	*timer_name = oh->name;
-
 	if (!of_have_populated_dt()) {
 		r = omap_hwmod_get_resource_byname(oh, IORESOURCE_IRQ, NULL,
 						   &irq);
@@ -365,8 +362,10 @@ static void __init omap2_gp_clockevent_init(int gptimer_id,
 	 */
 	__omap_dm_timer_override_errata(&clkev, OMAP_TIMER_ERRATA_I103_I767);
 
+	clockevent_gpt.name = "timer_clkev";
+
 	res = omap_dm_timer_init_one(&clkev, fck_source, property,
-				     &clockevent_gpt.name, OMAP_TIMER_POSTED);
+				     OMAP_TIMER_POSTED);
 	BUG_ON(res);
 
 	omap2_gp_timer_irq.dev_id = &clkev;
@@ -489,10 +488,11 @@ static void __init omap2_gptimer_clocksource_init(int gptimer_id,
 	clksrc.errata = omap_dm_timer_get_errata();
 
 	res = omap_dm_timer_init_one(&clksrc, fck_source, property,
-				     &clocksource_gpt.name,
 				     OMAP_TIMER_NONPOSTED);
 	BUG_ON(res);
 
+	clocksource_gpt.name = "timer_clksrc";
+
 	__omap_dm_timer_load_start(&clksrc,
 				   OMAP_TIMER_CTRL_AR, 0,
 				   OMAP_TIMER_NONPOSTED);
-- 
1.7.9.5

