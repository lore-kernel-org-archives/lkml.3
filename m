Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaEWKmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:42:37 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57320 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaEWKc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:26 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 40/71] clocksource: sh_mtu2: Split channel setup to separate function
Date: Fri, 23 May 2014 12:31:20 +0200
Message-Id: <1400841111-6683-40-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Move the channel setup code from sh_mtu2_setup to a new
sh_mtu2_setup_channel function and call it from sh_mtu2_setup.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Wolfram Sang <wsa@sang-engineering.com>
---
 drivers/clocksource/sh_mtu2.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 256621c..8fd7059 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -273,6 +273,24 @@ static int sh_mtu2_register(struct sh_mtu2_channel *ch, char *name,
 	return 0;
 }
 
+static int sh_mtu2_setup_channel(struct sh_mtu2_channel *ch,
+				 struct sh_mtu2_device *mtu)
+{
+	struct sh_timer_config *cfg = mtu->pdev->dev.platform_data;
+
+	memset(ch, 0, sizeof(*ch));
+	ch->mtu = mtu;
+
+	ch->irq = platform_get_irq(mtu->pdev, 0);
+	if (ch->irq < 0) {
+		dev_err(&mtu->pdev->dev, "failed to get irq\n");
+		return ch->irq;
+	}
+
+	return sh_mtu2_register(ch, (char *)dev_name(&mtu->pdev->dev),
+				cfg->clockevent_rating);
+}
+
 static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 			 struct platform_device *pdev)
 {
@@ -297,12 +315,6 @@ static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 		goto err0;
 	}
 
-	mtu->channel.irq = platform_get_irq(mtu->pdev, 0);
-	if (mtu->channel.irq < 0) {
-		dev_err(&mtu->pdev->dev, "failed to get irq\n");
-		goto err0;
-	}
-
 	/* map memory, let mapbase point to our channel */
 	mtu->mapbase = ioremap_nocache(res->start, resource_size(res));
 	if (mtu->mapbase == NULL) {
@@ -322,10 +334,7 @@ static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 	if (ret < 0)
 		goto err2;
 
-	mtu->channel.mtu = mtu;
-
-	ret = sh_mtu2_register(&mtu->channel, (char *)dev_name(&mtu->pdev->dev),
-			       cfg->clockevent_rating);
+	ret = sh_mtu2_setup_channel(&mtu->channel, mtu);
 	if (ret < 0)
 		goto err3;
 
-- 
1.7.9.5

