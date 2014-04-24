Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbaDXWuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:50:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40984 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbaDXVov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:44:51 -0400
From: Joel Fernandes <joelf@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH 10/26] ARM: OMAP: dmtimer: Check return of pm_runtime_get_sync
Date: Thu, 24 Apr 2014 16:43:53 -0500
Message-ID: <1398375849-6017-11-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398375849-6017-1-git-send-email-joelf@ti.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap_timer_enable doesn't check return value, this can lead to nasty bus
errors. Add a check and report issues.

Tested-by: Joachim Eastwood <manabian@gmail.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/plat-omap/dmtimer.c              |   62 +++++++++++++++++++++++------
 arch/arm/plat-omap/include/plat/dmtimer.h |    2 +-
 2 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 1fd30fa..b52d34d 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -164,7 +164,9 @@ static int omap_dm_timer_prepare(struct omap_dm_timer *timer)
 		}
 	}
 
-	omap_dm_timer_enable(timer);
+	rc = omap_dm_timer_enable(timer);
+	if (rc)
+		return rc;
 
 	if (timer->capability & OMAP_TIMER_NEEDS_RESET) {
 		rc = omap_dm_timer_reset(timer);
@@ -375,11 +377,16 @@ int omap_dm_timer_free(struct omap_dm_timer *timer)
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_free);
 
-void omap_dm_timer_enable(struct omap_dm_timer *timer)
+int omap_dm_timer_enable(struct omap_dm_timer *timer)
 {
-	int c;
+	int c, err;
 
-	pm_runtime_get_sync(&timer->pdev->dev);
+	err = pm_runtime_get_sync(&timer->pdev->dev);
+	if (err < 0) {
+		dev_err(&timer->pdev->dev, "%s: pm_runtime_get_sync failed (err=%d).",
+			__func__, err);
+		return err;
+	}
 
 	if (!(timer->capability & OMAP_TIMER_ALWON)) {
 		if (timer->get_context_loss_count) {
@@ -392,6 +399,7 @@ void omap_dm_timer_enable(struct omap_dm_timer *timer)
 			omap_timer_restore_context(timer);
 		}
 	}
+	return 0;
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_enable);
 
@@ -432,11 +440,14 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_trigger);
 int omap_dm_timer_start(struct omap_dm_timer *timer)
 {
 	u32 l;
+	int rc;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	omap_dm_timer_enable(timer);
+	rc = omap_dm_timer_enable(timer);
+	if (rc)
+		return rc;
 
 	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
 	if (!(l & OMAP_TIMER_CTRL_ST)) {
@@ -534,11 +545,15 @@ int omap_dm_timer_set_load(struct omap_dm_timer *timer, int autoreload,
 			    unsigned int load)
 {
 	u32 mask = ~0, val = 0;
+	int rc;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	omap_dm_timer_enable(timer);
+	rc = omap_dm_timer_enable(timer);
+	if (rc)
+		return rc;
+
 	if (autoreload)
 		val |= OMAP_TIMER_CTRL_AR;
 	else
@@ -560,11 +575,14 @@ int omap_dm_timer_set_load_start(struct omap_dm_timer *timer, int autoreload,
                             unsigned int load)
 {
 	u32 l;
+	int rc;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	omap_dm_timer_enable(timer);
+	rc = omap_dm_timer_enable(timer);
+	if (rc)
+		return rc;
 
 	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
 	if (autoreload) {
@@ -588,11 +606,15 @@ int omap_dm_timer_set_match(struct omap_dm_timer *timer, int enable,
 			     unsigned int match)
 {
 	u32 mask = ~0, val = 0;
+	int rc;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	omap_dm_timer_enable(timer);
+	rc = omap_dm_timer_enable(timer);
+	if (rc)
+		return rc;
+
 	if (enable)
 		val |= OMAP_TIMER_CTRL_CE;
 	else
@@ -613,11 +635,15 @@ int omap_dm_timer_set_pwm(struct omap_dm_timer *timer, int def_on,
 			   int toggle, int trigger)
 {
 	u32 mask = ~0, val = 0;
+	int rc;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	omap_dm_timer_enable(timer);
+	rc = omap_dm_timer_enable(timer);
+	if (rc)
+		return rc;
+
 	mask &= ~(OMAP_TIMER_CTRL_GPOCFG | OMAP_TIMER_CTRL_SCPWM |
 	       OMAP_TIMER_CTRL_PT | (0x03 << 10));
 	if (def_on)
@@ -637,11 +663,15 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_set_pwm);
 int omap_dm_timer_set_prescaler(struct omap_dm_timer *timer, int prescaler)
 {
 	u32 mask = ~0, val = 0;
+	int rc;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	omap_dm_timer_enable(timer);
+	rc = omap_dm_timer_enable(timer);
+	if (rc)
+		return rc;
+
 	mask &= ~(OMAP_TIMER_CTRL_PRE | (0x07 << 2));
 	if (prescaler >= 0x00 && prescaler <= 0x07) {
 		val |= OMAP_TIMER_CTRL_PRE;
@@ -659,10 +689,15 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_set_prescaler);
 int omap_dm_timer_set_int_enable(struct omap_dm_timer *timer,
 				  unsigned int value)
 {
+	int rc;
+
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	omap_dm_timer_enable(timer);
+	rc = omap_dm_timer_enable(timer);
+	if (rc)
+		return rc;
+
 	__omap_dm_timer_int_enable(timer, value);
 
 	/* Save the context */
@@ -683,11 +718,14 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_set_int_enable);
 int omap_dm_timer_set_int_disable(struct omap_dm_timer *timer, u32 mask)
 {
 	u32 l = mask;
+	int rc;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
-	omap_dm_timer_enable(timer);
+	rc = omap_dm_timer_enable(timer);
+	if (rc)
+		return rc;
 
 	if (timer->revision == 1)
 		l = __raw_readl(timer->irq_ena) & ~mask;
diff --git a/arch/arm/plat-omap/include/plat/dmtimer.h b/arch/arm/plat-omap/include/plat/dmtimer.h
index fe3780a..6b6fbd2 100644
--- a/arch/arm/plat-omap/include/plat/dmtimer.h
+++ b/arch/arm/plat-omap/include/plat/dmtimer.h
@@ -130,7 +130,7 @@ struct omap_dm_timer *omap_dm_timer_request_specific(int timer_id);
 struct omap_dm_timer *omap_dm_timer_request_by_cap(u32 cap);
 struct omap_dm_timer *omap_dm_timer_request_by_node(struct device_node *np);
 int omap_dm_timer_free(struct omap_dm_timer *timer);
-void omap_dm_timer_enable(struct omap_dm_timer *timer);
+int omap_dm_timer_enable(struct omap_dm_timer *timer);
 void omap_dm_timer_disable(struct omap_dm_timer *timer);
 
 int omap_dm_timer_get_irq(struct omap_dm_timer *timer);
-- 
1.7.9.5

