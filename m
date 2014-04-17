Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbaDQADx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:03:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35111 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbaDQADu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:03:50 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Rajendra Nayak <rnayak@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 1/9] ARM: OMAP: dmtimer: Remove setting of clk parent indirectly through platform hook
Date: Wed, 16 Apr 2014 19:03:11 -0500
Message-ID: <1397692999-7800-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a platform specific hook just for OMAP1 to set its clk parent.  Remove
this hook and have OMAP1 set its parent in omap1_dm_timer_init.  If OMAP1 is
ever migrated to clock framework, the correct way to do this would be through
clk_set_parent like other platforms.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap1/timer.c                |    8 +++++++-
 arch/arm/plat-omap/dmtimer.c               |    8 +++-----
 include/linux/platform_data/dmtimer-omap.h |    2 --
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap1/timer.c b/arch/arm/mach-omap1/timer.c
index bde7a35..4b9c604 100644
--- a/arch/arm/mach-omap1/timer.c
+++ b/arch/arm/mach-omap1/timer.c
@@ -140,7 +140,13 @@ static int __init omap1_dm_timer_init(void)
 			goto err_free_pdata;
 		}
 
-		pdata->set_timer_src = omap1_dm_timer_set_src;
+		/*
+		 * Since OMAP1 doesn't support clock framework, set timer clock
+		 * source to 32KHz here instead of expecting it to be set by
+		 * dmtimer code.
+		 */
+		omap1_dm_timer_set_src(pdev, 0x01);
+
 		pdata->timer_capability = OMAP_TIMER_ALWON |
 				OMAP_TIMER_NEEDS_RESET | OMAP_TIMER_HAS_DSP_IRQ;
 
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 869254c..ecd3f97 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -494,12 +494,10 @@ int omap_dm_timer_set_source(struct omap_dm_timer *timer, int source)
 		return -EINVAL;
 
 	/*
-	 * FIXME: Used for OMAP1 devices only because they do not currently
-	 * use the clock framework to set the parent clock. To be removed
-	 * once OMAP1 migrated to using clock framework for dmtimers
+	 * For OMAP1, timer source is already set during omap1_dm_timer_init.
 	 */
-	if (pdata && pdata->set_timer_src)
-		return pdata->set_timer_src(timer->pdev, source);
+	if (timer->capability & OMAP_TIMER_NEEDS_RESET)
+		return 0;
 
 	if (IS_ERR(timer->fclk))
 		return -EINVAL;
diff --git a/include/linux/platform_data/dmtimer-omap.h b/include/linux/platform_data/dmtimer-omap.h
index a19b78d..9f42b06 100644
--- a/include/linux/platform_data/dmtimer-omap.h
+++ b/include/linux/platform_data/dmtimer-omap.h
@@ -21,8 +21,6 @@
 #define __PLATFORM_DATA_DMTIMER_OMAP_H__
 
 struct dmtimer_platform_data {
-	/* set_timer_src - Only used for OMAP1 devices */
-	int (*set_timer_src)(struct platform_device *pdev, int source);
 	u32 timer_capability;
 	u32 timer_errata;
 	int (*get_context_loss_count)(struct device *);
-- 
1.7.9.5

