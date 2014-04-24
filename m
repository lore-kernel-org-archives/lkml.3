Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbaDXWu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:50:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53143 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbaDXVou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:44:50 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 15/26] ARM: OMAP2+: timer: Use of_clk_get for DT platforms
Date: Thu, 24 Apr 2014 16:43:58 -0500
Message-ID: <1398375849-6017-16-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398375849-6017-1-git-send-email-joelf@ti.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For DT-booting platforms, use of_clk_get to get the fclk for system timers.
Separate out the legacy code for non-DT platform use.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/timer.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index ea91ef9..4fcfd7a 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -277,6 +277,10 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 		if (!timer->io_base)
 			return -ENXIO;
 
+		timer->fclk = of_clk_get(np, 0);
+		if (IS_ERR(timer->fclk))
+			return PTR_ERR(timer->fclk);
+
 		r = omap_dmtimer_powerup(np);
 		if (r)
 			return r;
@@ -308,14 +312,13 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
 		if (!timer->io_base)
 			return -ENXIO;
 
+		timer->fclk = clk_get(NULL, omap_hwmod_get_main_clk(oh));
+		if (IS_ERR(timer->fclk))
+			return PTR_ERR(timer->fclk);
 
 		omap_hwmod_setup_one(oh_name);
 		omap_hwmod_enable(oh);
 	}
-	/* After the dmtimer is using hwmod these clocks won't be needed */
-	timer->fclk = clk_get(NULL, omap_hwmod_get_main_clk(oh));
-	if (IS_ERR(timer->fclk))
-		return PTR_ERR(timer->fclk);
 
 	/*
 	 * Clock reparenting code, goes away for DT-boot atleast,
-- 
1.7.9.5

