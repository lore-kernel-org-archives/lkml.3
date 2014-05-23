Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbaEWKqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:46:19 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:44088 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaEWKcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:12 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 29/71] clocksource: sh_tmu: Allocate channels dynamically
Date: Fri, 23 May 2014 12:31:09 +0200
Message-Id: <1400841111-6683-29-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

This prepares the driver for multi-channel support.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_tmu.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 26a9f7d..55b7a37 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -58,7 +58,8 @@ struct sh_tmu_device {
 	void __iomem *mapbase;
 	struct clk *clk;
 
-	struct sh_tmu_channel channel;
+	struct sh_tmu_channel *channels;
+	unsigned int num_channels;
 };
 
 static DEFINE_RAW_SPINLOCK(sh_tmu_lock);
@@ -469,6 +470,7 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 {
 	struct sh_timer_config *cfg = pdev->dev.platform_data;
 	struct resource *res;
+	void __iomem *base;
 	int ret;
 	ret = -ENXIO;
 
@@ -488,16 +490,16 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 	}
 
 	/*
-	 * Map memory, let channel.base point to our channel and mapbase to the
+	 * Map memory, let base point to our channel and mapbase to the
 	 * start/stop shared register.
 	 */
-	tmu->channel.base = ioremap_nocache(res->start, resource_size(res));
-	if (tmu->channel.base == NULL) {
+	base = ioremap_nocache(res->start, resource_size(res));
+	if (base == NULL) {
 		dev_err(&tmu->pdev->dev, "failed to remap I/O memory\n");
 		goto err0;
 	}
 
-	tmu->mapbase = tmu->channel.base - cfg->channel_offset;
+	tmu->mapbase = base - cfg->channel_offset;
 
 	/* get hold of clock */
 	tmu->clk = clk_get(&tmu->pdev->dev, "tmu_fck");
@@ -511,18 +513,29 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 	if (ret < 0)
 		goto err2;
 
-	ret = sh_tmu_channel_setup(&tmu->channel, tmu);
+	tmu->channels = kzalloc(sizeof(*tmu->channels), GFP_KERNEL);
+	if (tmu->channels == NULL) {
+		ret = -ENOMEM;
+		goto err3;
+	}
+
+	tmu->num_channels = 1;
+
+	tmu->channels[0].base = base;
+
+	ret = sh_tmu_channel_setup(&tmu->channels[0], tmu);
 	if (ret < 0)
 		goto err3;
 
 	return 0;
 
  err3:
+	kfree(tmu->channels);
 	clk_unprepare(tmu->clk);
  err2:
 	clk_put(tmu->clk);
  err1:
-	iounmap(tmu->channel.base);
+	iounmap(base);
  err0:
 	return ret;
 }
-- 
1.7.9.5

