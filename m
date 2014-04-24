Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbaDXWq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:46:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40996 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaDXVpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:45:01 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 26/26] ARM: OMAP: dmtimer: Use is_timer_available function in omap_dm_timer_trigger
Date: Thu, 24 Apr 2014 16:44:09 -0500
Message-ID: <1398375849-6017-27-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398375849-6017-1-git-send-email-joelf@ti.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timer availability can be checked with is_timer_available function. Move it
before omap_dm_timer_trigger and use it.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/plat-omap/dmtimer.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 1059881..0d0e83b 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -221,6 +221,19 @@ int omap_dm_timer_reserve_systimer(int id)
 	return 0;
 }
 
+static int is_timer_available(struct omap_dm_timer *timer)
+{
+	if (timer && timer->systimer)
+		return 1;
+
+	if (unlikely(!timer || pm_runtime_suspended(&timer->pdev->dev))) {
+		pr_err("Timer not available or enabled.\n");
+		WARN_ON(1);
+		return 0;
+	}
+	return 1;
+}
+
 void omap_dm_timer_init_regs(struct omap_dm_timer *timer)
 {
 	u32 tidr;
@@ -524,7 +537,7 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_get_fclk);
 
 int omap_dm_timer_trigger(struct omap_dm_timer *timer)
 {
-	if (unlikely(!timer || pm_runtime_suspended(&timer->pdev->dev))) {
+	if (!is_timer_available(timer)) {
 		pr_err("%s: timer not available or enabled.\n", __func__);
 		return -EINVAL;
 	}
@@ -867,19 +880,6 @@ int omap_dm_timer_set_int_disable(struct omap_dm_timer *timer, u32 mask)
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_set_int_disable);
 
-static int is_timer_available(struct omap_dm_timer *timer)
-{
-	if (timer && timer->systimer)
-		return 1;
-
-	if (unlikely(!timer || pm_runtime_suspended(&timer->pdev->dev))) {
-		pr_err("Timer not available or enabled.\n");
-		WARN_ON(1);
-		return 0;
-	}
-	return 1;
-}
-
 unsigned int omap_dm_timer_read_status(struct omap_dm_timer *timer)
 {
 	unsigned int l;
-- 
1.7.9.5

