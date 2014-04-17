Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161727AbaDQAGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:06:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36301 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbaDQADw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:03:52 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Rajendra Nayak <rnayak@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 6/9] ARM: OMAP: dmtimer: Add a write_ctrl function to simplify bit setting
Date: Wed, 16 Apr 2014 19:03:16 -0500
Message-ID: <1397692999-7800-6-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397692999-7800-1-git-send-email-joelf@ti.com>
References: <1397692999-7800-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common pattern in dmtimer code is to read the control reg, set and reset
certain bits, and write it back. We abstract this pattern and introduce a
new function to do so.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/plat-omap/dmtimer.c |   63 ++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 0e96ad2..782ff10 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -91,6 +91,18 @@ static void omap_dm_timer_write_reg(struct omap_dm_timer *timer, u32 reg,
 	__omap_dm_timer_write(timer, reg, value, timer->posted);
 }
 
+static u32 omap_dm_timer_write_ctrl(struct omap_dm_timer *timer, u32 mask,
+		u32 value)
+{
+	u32 l;
+
+	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
+	l &= mask;
+	l |= value;
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_CTRL_REG, l);
+	return l;
+}
+
 static void omap_timer_restore_context(struct omap_dm_timer *timer)
 {
 	omap_dm_timer_write_reg(timer, OMAP_TIMER_WAKEUP_EN_REG,
@@ -521,23 +533,22 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_set_source);
 int omap_dm_timer_set_load(struct omap_dm_timer *timer, int autoreload,
 			    unsigned int load)
 {
-	u32 l;
+	u32 mask = ~0, val = 0;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
 	omap_dm_timer_enable(timer);
-	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
 	if (autoreload)
-		l |= OMAP_TIMER_CTRL_AR;
+		val |= OMAP_TIMER_CTRL_AR;
 	else
-		l &= ~OMAP_TIMER_CTRL_AR;
-	omap_dm_timer_write_reg(timer, OMAP_TIMER_CTRL_REG, l);
+		mask &= ~OMAP_TIMER_CTRL_AR;
+	val = omap_dm_timer_write_ctrl(timer, mask, val);
 	omap_dm_timer_write_reg(timer, OMAP_TIMER_LOAD_REG, load);
 
 	omap_dm_timer_write_reg(timer, OMAP_TIMER_TRIGGER_REG, 0);
 	/* Save the context */
-	timer->context.tclr = l;
+	timer->context.tclr = val;
 	timer->context.tldr = load;
 	omap_dm_timer_disable(timer);
 	return 0;
@@ -577,22 +588,22 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_set_load_start);
 int omap_dm_timer_set_match(struct omap_dm_timer *timer, int enable,
 			     unsigned int match)
 {
-	u32 l;
+	u32 mask = ~0, val = 0;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
 	omap_dm_timer_enable(timer);
-	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
 	if (enable)
-		l |= OMAP_TIMER_CTRL_CE;
+		val |= OMAP_TIMER_CTRL_CE;
 	else
-		l &= ~OMAP_TIMER_CTRL_CE;
+		mask &= ~OMAP_TIMER_CTRL_CE;
+
 	omap_dm_timer_write_reg(timer, OMAP_TIMER_MATCH_REG, match);
-	omap_dm_timer_write_reg(timer, OMAP_TIMER_CTRL_REG, l);
+	val = omap_dm_timer_write_ctrl(timer, mask, val);
 
 	/* Save the context */
-	timer->context.tclr = l;
+	timer->context.tclr = val;
 	timer->context.tmar = match;
 	omap_dm_timer_disable(timer);
 	return 0;
@@ -602,24 +613,23 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_set_match);
 int omap_dm_timer_set_pwm(struct omap_dm_timer *timer, int def_on,
 			   int toggle, int trigger)
 {
-	u32 l;
+	u32 mask = ~0, val = 0;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
 	omap_dm_timer_enable(timer);
-	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
-	l &= ~(OMAP_TIMER_CTRL_GPOCFG | OMAP_TIMER_CTRL_SCPWM |
+	mask &= ~(OMAP_TIMER_CTRL_GPOCFG | OMAP_TIMER_CTRL_SCPWM |
 	       OMAP_TIMER_CTRL_PT | (0x03 << 10));
 	if (def_on)
-		l |= OMAP_TIMER_CTRL_SCPWM;
+		val |= OMAP_TIMER_CTRL_SCPWM;
 	if (toggle)
-		l |= OMAP_TIMER_CTRL_PT;
-	l |= trigger << 10;
-	omap_dm_timer_write_reg(timer, OMAP_TIMER_CTRL_REG, l);
+		val |= OMAP_TIMER_CTRL_PT;
+	val |= trigger << 10;
+	val = omap_dm_timer_write_ctrl(timer, mask, val);
 
 	/* Save the context */
-	timer->context.tclr = l;
+	timer->context.tclr = val;
 	omap_dm_timer_disable(timer);
 	return 0;
 }
@@ -627,22 +637,21 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_set_pwm);
 
 int omap_dm_timer_set_prescaler(struct omap_dm_timer *timer, int prescaler)
 {
-	u32 l;
+	u32 mask = ~0, val = 0;
 
 	if (unlikely(!timer))
 		return -EINVAL;
 
 	omap_dm_timer_enable(timer);
-	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
-	l &= ~(OMAP_TIMER_CTRL_PRE | (0x07 << 2));
+	mask &= ~(OMAP_TIMER_CTRL_PRE | (0x07 << 2));
 	if (prescaler >= 0x00 && prescaler <= 0x07) {
-		l |= OMAP_TIMER_CTRL_PRE;
-		l |= prescaler << 2;
+		val |= OMAP_TIMER_CTRL_PRE;
+		val |= prescaler << 2;
 	}
-	omap_dm_timer_write_reg(timer, OMAP_TIMER_CTRL_REG, l);
+	val = omap_dm_timer_write_ctrl(timer, mask, val);
 
 	/* Save the context */
-	timer->context.tclr = l;
+	timer->context.tclr = val;
 	omap_dm_timer_disable(timer);
 	return 0;
 }
-- 
1.7.9.5

