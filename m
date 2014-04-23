Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbaDWB2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:28:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43770 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbaDWB2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:28:00 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 4/8] ARM: OMAP2+: timer: Remove hwmod look-up dependency for DT-boot
Date: Tue, 22 Apr 2014 20:27:05 -0500
Message-ID: <1398216429-4681-5-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398216429-4681-1-git-send-email-joelf@ti.com>
References: <1398216429-4681-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwmod look ups should no longer directly happen for dmtimer users of
DT-boot platforms. We separate out the code for platforms that are
still non-DT. Ultimately this code should be deleted if all platforms
are converted to DT-boot.

We use omap_dmtimer_powerup introduced earlier in the series to abstract
out the hwmod dependency for the same. This will help us move the generic
DT specific code out into drivers/clocksource/ later.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 9fdff5b..ea91ef9 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -266,10 +266,6 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 		if (!np)
 			return -ENODEV;
 
-		of_property_read_string_index(np, "ti,hwmods", 0, &oh_name);
-		if (!oh_name)
-			return -ENODEV;
-
 		timer->irq = irq_of_parse_and_map(np, 0);
 		if (!timer->irq)
 			return -ENXIO;
@@ -277,19 +273,24 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 		timer->io_base = of_iomap(np, 0);
 
 		of_node_put(np);
+
+		if (!timer->io_base)
+			return -ENXIO;
+
+		r = omap_dmtimer_powerup(np);
+		if (r)
+			return r;
 	} else {
 		if (omap_dm_timer_reserve_systimer(timer->id))
 			return -ENODEV;
 
 		sprintf(name, "timer%d", timer->id);
 		oh_name = name;
-	}
 
-	oh = omap_hwmod_lookup(oh_name);
-	if (!oh)
-		return -ENODEV;
+		oh = omap_hwmod_lookup(oh_name);
+		if (!oh)
+			return -ENODEV;
 
-	if (!of_have_populated_dt()) {
 		r = omap_hwmod_get_resource_byname(oh, IORESOURCE_IRQ, NULL,
 						   &irq);
 		if (r)
@@ -303,11 +304,14 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 
 		/* Static mapping, never released */
 		timer->io_base = ioremap(mem.start, mem.end - mem.start);
+
+		if (!timer->io_base)
+			return -ENXIO;
+
+
+		omap_hwmod_setup_one(oh_name);
+		omap_hwmod_enable(oh);
 	}
-
-	if (!timer->io_base)
-		return -ENXIO;
-
 	/* After the dmtimer is using hwmod these clocks won't be needed */
 	timer->fclk = clk_get(NULL, omap_hwmod_get_main_clk(oh));
 	if (IS_ERR(timer->fclk))
@@ -333,10 +337,7 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 
 	clk_put(src);
 
-	omap_hwmod_setup_one(oh_name);
-	omap_hwmod_enable(oh);
 	__omap_dm_timer_init_regs(timer);
-
 	if (posted)
 		__omap_dm_timer_enable_posted(timer);
 
-- 
1.7.9.5

