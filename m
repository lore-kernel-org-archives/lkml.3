Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaDWBaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:30:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32908 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633AbaDWB2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:28:01 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 7/8] ARM: OMAP2+: timer: Add fallback for of_clk_get
Date: Tue, 22 Apr 2014 20:27:08 -0500
Message-ID: <1398216429-4681-8-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398216429-4681-1-git-send-email-joelf@ti.com>
References: <1398216429-4681-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all platforms currently will support of_clk_get on timer
because they may not have clock property in their DT nodes. Add
code to handle this case so that things are kept working. Finally
we can delete this code once all system timer nodes have a clock
property.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 519ccfd..b3db1da 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -277,13 +277,19 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 		if (!timer->io_base)
 			return -ENXIO;
 
-		timer->fclk = of_clk_get(np, 0);
-		if (IS_ERR(timer->fclk))
-			return PTR_ERR(timer->fclk);
-
 		r = omap_dmtimer_powerup(np);
 		if (r)
 			return r;
+
+		timer->fclk = of_clk_get(np, 0);
+		if (IS_ERR(timer->fclk)) {
+			/*
+			 * Support DT platforms temporarily that don't have
+			 * clock property in their dts yet. Ultimately this
+			 * fall back code is to be deleted and we're to return
+			 * PTR_ERR(timer->fclk) here.
+			 */
+		}
 	} else {
 		if (omap_dm_timer_reserve_systimer(timer->id))
 			return -ENODEV;
@@ -312,14 +318,19 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 		if (!timer->io_base)
 			return -ENXIO;
 
-		timer->fclk = clk_get(NULL, omap_hwmod_get_main_clk(oh));
-		if (IS_ERR(timer->fclk))
-			return PTR_ERR(timer->fclk);
-
 		omap_hwmod_setup_one(oh_name);
 		omap_hwmod_enable(oh);
 	}
 
+	if (!timer->fclk || IS_ERR(timer->fclk)) {
+		oh = omap_hwmod_lookup(oh_name);
+		if (!oh)
+			return -ENODEV;
+		timer->fclk = clk_get(NULL, omap_hwmod_get_main_clk(oh));
+		if (IS_ERR(timer->fclk))
+			return PTR_ERR(timer->fclk);
+	}
+
 	/*
 	 * Clock reparenting code, goes away for DT-boot atleast,
 	 * once clock layer can do it through DT.
-- 
1.7.9.5

