Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbaGWKyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:54:17 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38664 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293AbaGWKyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:14 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 03/25] clocksource: sh_tmu: Drop support for legacy platform data
Date: Wed, 23 Jul 2014 12:53:45 +0200
Message-Id: <1406112847-26275-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Now that all platforms have switched to the new-style platform data,
drop support for the legacy version.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/clocksource/sh_tmu.c |   82 ++++++++----------------------------------
 1 file changed, 15 insertions(+), 67 deletions(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 6bd17a8..3eee5c8 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -32,7 +32,6 @@
 #include <linux/spinlock.h>
 
 enum sh_tmu_model {
-	SH_TMU_LEGACY,
 	SH_TMU,
 	SH_TMU_SH3,
 };
@@ -91,8 +90,6 @@ static inline unsigned long sh_tmu_read(struct sh_tmu_channel *ch, int reg_nr)
 
 	if (reg_nr == TSTR) {
 		switch (ch->tmu->model) {
-		case SH_TMU_LEGACY:
-			return ioread8(ch->tmu->mapbase);
 		case SH_TMU_SH3:
 			return ioread8(ch->tmu->mapbase + 2);
 		case SH_TMU:
@@ -115,8 +112,6 @@ static inline void sh_tmu_write(struct sh_tmu_channel *ch, int reg_nr,
 
 	if (reg_nr == TSTR) {
 		switch (ch->tmu->model) {
-		case SH_TMU_LEGACY:
-			return iowrite8(value, ch->tmu->mapbase);
 		case SH_TMU_SH3:
 			return iowrite8(value, ch->tmu->mapbase + 2);
 		case SH_TMU:
@@ -476,27 +471,12 @@ static int sh_tmu_channel_setup(struct sh_tmu_channel *ch, unsigned int index,
 		return 0;
 
 	ch->tmu = tmu;
+	ch->index = index;
 
-	if (tmu->model == SH_TMU_LEGACY) {
-		struct sh_timer_config *cfg = tmu->pdev->dev.platform_data;
-
-		/*
-		 * The SH3 variant (SH770x, SH7705, SH7710 and SH7720) maps
-		 * channel registers blocks at base + 2 + 12 * index, while all
-		 * other variants map them at base + 4 + 12 * index. We can
-		 * compute the index by just dividing by 12, the 2 bytes or 4
-		 * bytes offset being hidden by the integer division.
-		 */
-		ch->index = cfg->channel_offset / 12;
-		ch->base = tmu->mapbase + cfg->channel_offset;
-	} else {
-		ch->index = index;
-
-		if (tmu->model == SH_TMU_SH3)
-			ch->base = tmu->mapbase + 4 + ch->index * 12;
-		else
-			ch->base = tmu->mapbase + 8 + ch->index * 12;
-	}
+	if (tmu->model == SH_TMU_SH3)
+		ch->base = tmu->mapbase + 4 + ch->index * 12;
+	else
+		ch->base = tmu->mapbase + 8 + ch->index * 12;
 
 	ch->irq = platform_get_irq(tmu->pdev, index);
 	if (ch->irq < 0) {
@@ -526,28 +506,9 @@ static int sh_tmu_map_memory(struct sh_tmu_device *tmu)
 	if (tmu->mapbase == NULL)
 		return -ENXIO;
 
-	/*
-	 * In legacy platform device configuration (with one device per channel)
-	 * the resource points to the channel base address.
-	 */
-	if (tmu->model == SH_TMU_LEGACY) {
-		struct sh_timer_config *cfg = tmu->pdev->dev.platform_data;
-		tmu->mapbase -= cfg->channel_offset;
-	}
-
 	return 0;
 }
 
-static void sh_tmu_unmap_memory(struct sh_tmu_device *tmu)
-{
-	if (tmu->model == SH_TMU_LEGACY) {
-		struct sh_timer_config *cfg = tmu->pdev->dev.platform_data;
-		tmu->mapbase += cfg->channel_offset;
-	}
-
-	iounmap(tmu->mapbase);
-}
-
 static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 {
 	struct sh_timer_config *cfg = pdev->dev.platform_data;
@@ -564,8 +525,7 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 	tmu->model = id->driver_data;
 
 	/* Get hold of clock. */
-	tmu->clk = clk_get(&tmu->pdev->dev,
-			   tmu->model == SH_TMU_LEGACY ? "tmu_fck" : "fck");
+	tmu->clk = clk_get(&tmu->pdev->dev, "fck");
 	if (IS_ERR(tmu->clk)) {
 		dev_err(&tmu->pdev->dev, "cannot get clock\n");
 		return PTR_ERR(tmu->clk);
@@ -583,10 +543,7 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 	}
 
 	/* Allocate and setup the channels. */
-	if (tmu->model == SH_TMU_LEGACY)
-		tmu->num_channels = 1;
-	else
-		tmu->num_channels = hweight8(cfg->channels_mask);
+	tmu->num_channels = hweight8(cfg->channels_mask);
 
 	tmu->channels = kzalloc(sizeof(*tmu->channels) * tmu->num_channels,
 				GFP_KERNEL);
@@ -595,23 +552,15 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 		goto err_unmap;
 	}
 
-	if (tmu->model == SH_TMU_LEGACY) {
-		ret = sh_tmu_channel_setup(&tmu->channels[0], 0,
-					   cfg->clockevent_rating != 0,
-					   cfg->clocksource_rating != 0, tmu);
+	/*
+	 * Use the first channel as a clock event device and the second channel
+	 * as a clock source.
+	 */
+	for (i = 0; i < tmu->num_channels; ++i) {
+		ret = sh_tmu_channel_setup(&tmu->channels[i], i,
+					   i == 0, i == 1, tmu);
 		if (ret < 0)
 			goto err_unmap;
-	} else {
-		/*
-		 * Use the first channel as a clock event device and the second
-		 * channel as a clock source.
-		 */
-		for (i = 0; i < tmu->num_channels; ++i) {
-			ret = sh_tmu_channel_setup(&tmu->channels[i], i,
-						   i == 0, i == 1, tmu);
-			if (ret < 0)
-				goto err_unmap;
-		}
 	}
 
 	platform_set_drvdata(pdev, tmu);
@@ -620,7 +569,7 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 
 err_unmap:
 	kfree(tmu->channels);
-	sh_tmu_unmap_memory(tmu);
+	iounmap(tmu->mapbase);
 err_clk_unprepare:
 	clk_unprepare(tmu->clk);
 err_clk_put:
@@ -671,7 +620,6 @@ static int sh_tmu_remove(struct platform_device *pdev)
 }
 
 static const struct platform_device_id sh_tmu_id_table[] = {
-	{ "sh_tmu", SH_TMU_LEGACY },
 	{ "sh-tmu", SH_TMU },
 	{ "sh-tmu-sh3", SH_TMU_SH3 },
 	{ }
-- 
1.7.9.5

