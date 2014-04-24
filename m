Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbaDXWuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:50:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40985 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbaDXVov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:44:51 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 05/26] ARM: OMAP1: dmtimer: Rewrite modify of IDLECT mask to use new is_running function
Date: Thu, 24 Apr 2014 16:43:48 -0500
Message-ID: <1398375849-6017-6-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398375849-6017-1-git-send-email-joelf@ti.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, also delete the old definition of the function in dmtimer.c code.
This completes the separation and removal of OMAP1 header dependency in dmtimer
code and removes references to MOD_CONF_CTRL registers in dmtimer.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap1/include/mach/hardware.h |    2 ++
 arch/arm/mach-omap1/timer.c                 |   26 +++++++++++++++
 arch/arm/plat-omap/dmtimer.c                |   48 ---------------------------
 arch/arm/plat-omap/include/plat/dmtimer.h   |    1 -
 4 files changed, 28 insertions(+), 49 deletions(-)

diff --git a/arch/arm/mach-omap1/include/mach/hardware.h b/arch/arm/mach-omap1/include/mach/hardware.h
index 5875a50..46de040 100644
--- a/arch/arm/mach-omap1/include/mach/hardware.h
+++ b/arch/arm/mach-omap1/include/mach/hardware.h
@@ -70,6 +70,8 @@ static inline u32 omap_cs3_phys(void)
 			? 0 : OMAP_CS3_PHYS;
 }
 
+__u32 omap_dm_timer_modify_idlect_mask(__u32 inputmask);
+
 #endif	/* ifndef __ASSEMBLER__ */
 
 #define OMAP1_IO_OFFSET		0x01000000	/* Virtual IO = 0xfefb0000 */
diff --git a/arch/arm/mach-omap1/timer.c b/arch/arm/mach-omap1/timer.c
index 4b9c604..0a039f1 100644
--- a/arch/arm/mach-omap1/timer.c
+++ b/arch/arm/mach-omap1/timer.c
@@ -42,6 +42,32 @@
 
 #define OMAP1_DM_TIMER_COUNT		8
 
+/**
+ * omap_dm_timer_modify_idlect_mask - Check if any running timers use ARMXOR
+ * @inputmask: current value of idlect mask
+ */
+__u32 omap_dm_timer_modify_idlect_mask(__u32 inputmask)
+{
+	int i;
+
+	/* If ARMXOR cannot be idled this function call is unnecessary */
+	if (!(inputmask & (1 << 1)))
+		return inputmask;
+
+	for (i = 1; i <= OMAP1_DM_TIMER_COUNT; i++) {
+		if (omap_dm_timer_is_running(i)) {
+			if (((omap_readl(MOD_CONF_CTRL_1) >> ((i-1) * 2))
+			      & 0x03) == 0)
+				inputmask &= ~(1 << 1);
+			else
+				inputmask &= ~(1 << 2);
+		}
+		i++;
+	}
+
+	return inputmask;
+}
+
 static int omap1_dm_timer_set_src(struct platform_device *pdev,
 				int source)
 {
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 86b2641..0e96ad2 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -397,44 +397,6 @@ int omap_dm_timer_get_irq(struct omap_dm_timer *timer)
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_get_irq);
 
-#if defined(CONFIG_ARCH_OMAP1)
-#include <mach/hardware.h>
-/**
- * omap_dm_timer_modify_idlect_mask - Check if any running timers use ARMXOR
- * @inputmask: current value of idlect mask
- */
-__u32 omap_dm_timer_modify_idlect_mask(__u32 inputmask)
-{
-	int i = 0;
-	struct omap_dm_timer *timer = NULL;
-	unsigned long flags;
-
-	/* If ARMXOR cannot be idled this function call is unnecessary */
-	if (!(inputmask & (1 << 1)))
-		return inputmask;
-
-	/* If any active timer is using ARMXOR return modified mask */
-	spin_lock_irqsave(&dm_timer_lock, flags);
-	list_for_each_entry(timer, &omap_timer_list, node) {
-		u32 l;
-
-		l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
-		if (l & OMAP_TIMER_CTRL_ST) {
-			if (((omap_readl(MOD_CONF_CTRL_1) >> (i * 2)) & 0x03) == 0)
-				inputmask &= ~(1 << 1);
-			else
-				inputmask &= ~(1 << 2);
-		}
-		i++;
-	}
-	spin_unlock_irqrestore(&dm_timer_lock, flags);
-
-	return inputmask;
-}
-EXPORT_SYMBOL_GPL(omap_dm_timer_modify_idlect_mask);
-
-#else
-
 struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer)
 {
 	if (timer && !IS_ERR(timer->fclk))
@@ -443,16 +405,6 @@ struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer)
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_get_fclk);
 
-__u32 omap_dm_timer_modify_idlect_mask(__u32 inputmask)
-{
-	BUG();
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(omap_dm_timer_modify_idlect_mask);
-
-#endif
-
 int omap_dm_timer_trigger(struct omap_dm_timer *timer)
 {
 	if (unlikely(!timer || pm_runtime_suspended(&timer->pdev->dev))) {
diff --git a/arch/arm/plat-omap/include/plat/dmtimer.h b/arch/arm/plat-omap/include/plat/dmtimer.h
index 41df0a6..16ea9fd 100644
--- a/arch/arm/plat-omap/include/plat/dmtimer.h
+++ b/arch/arm/plat-omap/include/plat/dmtimer.h
@@ -137,7 +137,6 @@ int omap_dm_timer_get_irq(struct omap_dm_timer *timer);
 
 int omap_dm_timer_is_running(int timer_id);
 
-u32 omap_dm_timer_modify_idlect_mask(u32 inputmask);
 struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer);
 
 int omap_dm_timer_trigger(struct omap_dm_timer *timer);
-- 
1.7.9.5

