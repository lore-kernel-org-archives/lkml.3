Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbaGWKzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:55:19 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:61086 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbaGWKyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:38 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 24/25] clocksource: exynos_mct: Use readl_relaxed/writel_relaxed
Date: Wed, 23 Jul 2014 12:54:06 +0200
Message-Id: <1406112847-26275-24-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Anderson <dianders@chromium.org>

Using the __raw functions is discouraged.  Update the file to
consistently use the proper functions.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/exynos_mct.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index ab51bf20a..2df03e2 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -94,7 +94,7 @@ static void exynos4_mct_write(unsigned int value, unsigned long offset)
 	u32 mask;
 	u32 i;
 
-	__raw_writel(value, reg_base + offset);
+	writel_relaxed(value, reg_base + offset);
 
 	if (likely(offset >= EXYNOS4_MCT_L_BASE(0))) {
 		stat_addr = (offset & ~EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
@@ -144,8 +144,8 @@ static void exynos4_mct_write(unsigned int value, unsigned long offset)
 
 	/* Wait maximum 1 ms until written values are applied */
 	for (i = 0; i < loops_per_jiffy / 1000 * HZ; i++)
-		if (__raw_readl(reg_base + stat_addr) & mask) {
-			__raw_writel(mask, reg_base + stat_addr);
+		if (readl_relaxed(reg_base + stat_addr) & mask) {
+			writel_relaxed(mask, reg_base + stat_addr);
 			return;
 		}
 
@@ -157,7 +157,7 @@ static void exynos4_mct_frc_start(void)
 {
 	u32 reg;
 
-	reg = __raw_readl(reg_base + EXYNOS4_MCT_G_TCON);
+	reg = readl_relaxed(reg_base + EXYNOS4_MCT_G_TCON);
 	reg |= MCT_G_TCON_START;
 	exynos4_mct_write(reg, EXYNOS4_MCT_G_TCON);
 }
@@ -165,12 +165,12 @@ static void exynos4_mct_frc_start(void)
 static cycle_t notrace _exynos4_frc_read(void)
 {
 	unsigned int lo, hi;
-	u32 hi2 = __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_U);
+	u32 hi2 = readl_relaxed(reg_base + EXYNOS4_MCT_G_CNT_U);
 
 	do {
 		hi = hi2;
-		lo = __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_L);
-		hi2 = __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_U);
+		lo = readl_relaxed(reg_base + EXYNOS4_MCT_G_CNT_L);
+		hi2 = readl_relaxed(reg_base + EXYNOS4_MCT_G_CNT_U);
 	} while (hi != hi2);
 
 	return ((cycle_t)hi << 32) | lo;
@@ -225,7 +225,7 @@ static void exynos4_mct_comp0_stop(void)
 {
 	unsigned int tcon;
 
-	tcon = __raw_readl(reg_base + EXYNOS4_MCT_G_TCON);
+	tcon = readl_relaxed(reg_base + EXYNOS4_MCT_G_TCON);
 	tcon &= ~(MCT_G_TCON_COMP0_ENABLE | MCT_G_TCON_COMP0_AUTO_INC);
 
 	exynos4_mct_write(tcon, EXYNOS4_MCT_G_TCON);
@@ -238,7 +238,7 @@ static void exynos4_mct_comp0_start(enum clock_event_mode mode,
 	unsigned int tcon;
 	cycle_t comp_cycle;
 
-	tcon = __raw_readl(reg_base + EXYNOS4_MCT_G_TCON);
+	tcon = readl_relaxed(reg_base + EXYNOS4_MCT_G_TCON);
 
 	if (mode == CLOCK_EVT_MODE_PERIODIC) {
 		tcon |= MCT_G_TCON_COMP0_AUTO_INC;
@@ -327,7 +327,7 @@ static void exynos4_mct_tick_stop(struct mct_clock_event_device *mevt)
 	unsigned long mask = MCT_L_TCON_INT_START | MCT_L_TCON_TIMER_START;
 	unsigned long offset = mevt->base + MCT_L_TCON_OFFSET;
 
-	tmp = __raw_readl(reg_base + offset);
+	tmp = readl_relaxed(reg_base + offset);
 	if (tmp & mask) {
 		tmp &= ~mask;
 		exynos4_mct_write(tmp, offset);
@@ -349,7 +349,7 @@ static void exynos4_mct_tick_start(unsigned long cycles,
 	/* enable MCT tick interrupt */
 	exynos4_mct_write(0x1, mevt->base + MCT_L_INT_ENB_OFFSET);
 
-	tmp = __raw_readl(reg_base + mevt->base + MCT_L_TCON_OFFSET);
+	tmp = readl_relaxed(reg_base + mevt->base + MCT_L_TCON_OFFSET);
 	tmp |= MCT_L_TCON_INT_START | MCT_L_TCON_TIMER_START |
 	       MCT_L_TCON_INTERVAL_MODE;
 	exynos4_mct_write(tmp, mevt->base + MCT_L_TCON_OFFSET);
@@ -401,7 +401,7 @@ static int exynos4_mct_tick_clear(struct mct_clock_event_device *mevt)
 		exynos4_mct_tick_stop(mevt);
 
 	/* Clear the MCT tick interrupt */
-	if (__raw_readl(reg_base + mevt->base + MCT_L_INT_CSTAT_OFFSET) & 1) {
+	if (readl_relaxed(reg_base + mevt->base + MCT_L_INT_CSTAT_OFFSET) & 1) {
 		exynos4_mct_write(0x1, mevt->base + MCT_L_INT_CSTAT_OFFSET);
 		return 1;
 	} else {
-- 
1.7.9.5

