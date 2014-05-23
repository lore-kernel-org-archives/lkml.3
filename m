Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbaEWKcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:32:41 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45021 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaEWKcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:32 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 45/71] clocksource: sh_mtu2: Allocate channels dynamically
Date: Fri, 23 May 2014 12:31:25 +0200
Message-Id: <1400841111-6683-45-git-send-email-daniel.lezcano@linaro.org>
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
Tested-by: Wolfram Sang <wsa@sang-engineering.com>
---
 drivers/clocksource/sh_mtu2.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 94a5342..45e1e85 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -52,7 +52,8 @@ struct sh_mtu2_device {
 	void __iomem *mapbase;
 	struct clk *clk;
 
-	struct sh_mtu2_channel channel;
+	struct sh_mtu2_channel *channels;
+	unsigned int num_channels;
 };
 
 static DEFINE_RAW_SPINLOCK(sh_mtu2_lock);
@@ -296,6 +297,7 @@ static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 {
 	struct sh_timer_config *cfg = pdev->dev.platform_data;
 	struct resource *res;
+	void __iomem *base;
 	int ret;
 	ret = -ENXIO;
 
@@ -315,16 +317,16 @@ static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 	}
 
 	/*
-	 * Map memory, let channel.base point to our channel and mapbase to the
+	 * Map memory, let base point to our channel and mapbase to the
 	 * start/stop shared register.
 	 */
-	mtu->channel.base = ioremap_nocache(res->start, resource_size(res));
-	if (mtu->channel.base == NULL) {
+	base = ioremap_nocache(res->start, resource_size(res));
+	if (base == NULL) {
 		dev_err(&mtu->pdev->dev, "failed to remap I/O memory\n");
 		goto err0;
 	}
 
-	mtu->mapbase = mtu->channel.base + cfg->channel_offset;
+	mtu->mapbase = base + cfg->channel_offset;
 
 	/* get hold of clock */
 	mtu->clk = clk_get(&mtu->pdev->dev, "mtu2_fck");
@@ -338,17 +340,28 @@ static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 	if (ret < 0)
 		goto err2;
 
-	ret = sh_mtu2_setup_channel(&mtu->channel, mtu);
+	mtu->channels = kzalloc(sizeof(*mtu->channels), GFP_KERNEL);
+	if (mtu->channels == NULL) {
+		ret = -ENOMEM;
+		goto err3;
+	}
+
+	mtu->num_channels = 1;
+
+	mtu->channels[0].base = base;
+
+	ret = sh_mtu2_setup_channel(&mtu->channels[0], mtu);
 	if (ret < 0)
 		goto err3;
 
 	return 0;
  err3:
+	kfree(mtu->channels);
 	clk_unprepare(mtu->clk);
  err2:
 	clk_put(mtu->clk);
  err1:
-	iounmap(mtu->channel.base);
+	iounmap(base);
  err0:
 	return ret;
 }
-- 
1.7.9.5

