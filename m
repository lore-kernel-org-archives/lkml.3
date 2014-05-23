Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaEWKrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:47:52 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:44902 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbaEWKcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:09 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 26/71] clocksource: sh_tmu: Add memory base to sh_tmu_channel structure
Date: Fri, 23 May 2014 12:31:06 +0200
Message-Id: <1400841111-6683-26-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The channel memory base is channel-specific, add it to the channel
structure in preparation for support of multiple channels per device.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_tmu.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 2c64e3f..a464ed8 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -40,6 +40,7 @@ struct sh_tmu_device;
 struct sh_tmu_channel {
 	struct sh_tmu_device *tmu;
 
+	void __iomem *base;
 	int irq;
 
 	unsigned long rate;
@@ -68,39 +69,35 @@ static DEFINE_RAW_SPINLOCK(sh_tmu_lock);
 
 static inline unsigned long sh_tmu_read(struct sh_tmu_channel *ch, int reg_nr)
 {
-	struct sh_timer_config *cfg = ch->tmu->pdev->dev.platform_data;
-	void __iomem *base = ch->tmu->mapbase;
 	unsigned long offs;
 
 	if (reg_nr == TSTR)
-		return ioread8(base - cfg->channel_offset);
+		return ioread8(ch->tmu->mapbase);
 
 	offs = reg_nr << 2;
 
 	if (reg_nr == TCR)
-		return ioread16(base + offs);
+		return ioread16(ch->base + offs);
 	else
-		return ioread32(base + offs);
+		return ioread32(ch->base + offs);
 }
 
 static inline void sh_tmu_write(struct sh_tmu_channel *ch, int reg_nr,
 				unsigned long value)
 {
-	struct sh_timer_config *cfg = ch->tmu->pdev->dev.platform_data;
-	void __iomem *base = ch->tmu->mapbase;
 	unsigned long offs;
 
 	if (reg_nr == TSTR) {
-		iowrite8(value, base - cfg->channel_offset);
+		iowrite8(value, ch->tmu->mapbase);
 		return;
 	}
 
 	offs = reg_nr << 2;
 
 	if (reg_nr == TCR)
-		iowrite16(value, base + offs);
+		iowrite16(value, ch->base + offs);
 	else
-		iowrite32(value, base + offs);
+		iowrite32(value, ch->base + offs);
 }
 
 static void sh_tmu_start_stop_ch(struct sh_tmu_channel *ch, int start)
@@ -481,13 +478,18 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 		goto err0;
 	}
 
-	/* map memory, let mapbase point to our channel */
-	tmu->mapbase = ioremap_nocache(res->start, resource_size(res));
-	if (tmu->mapbase == NULL) {
+	/*
+	 * Map memory, let channel.base point to our channel and mapbase to the
+	 * start/stop shared register.
+	 */
+	tmu->channel.base = ioremap_nocache(res->start, resource_size(res));
+	if (tmu->channel.base == NULL) {
 		dev_err(&tmu->pdev->dev, "failed to remap I/O memory\n");
 		goto err0;
 	}
 
+	tmu->mapbase = tmu->channel.base - cfg->channel_offset;
+
 	/* get hold of clock */
 	tmu->clk = clk_get(&tmu->pdev->dev, "tmu_fck");
 	if (IS_ERR(tmu->clk)) {
@@ -511,7 +513,7 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
  err2:
 	clk_put(tmu->clk);
  err1:
-	iounmap(tmu->mapbase);
+	iounmap(tmu->channel.base);
  err0:
 	return ret;
 }
-- 
1.7.9.5

