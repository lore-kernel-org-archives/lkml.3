Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaEWKmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:42:38 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48008 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaEWKcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:25 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 39/71] clocksource: sh_mtu2: Rename struct sh_mtu2_priv to sh_mtu2_device
Date: Fri, 23 May 2014 12:31:19 +0200
Message-Id: <1400841111-6683-39-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Channel data is private as well, rename priv to device to make the
distrinction between the core device and the channels clearer.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Wolfram Sang <wsa@sang-engineering.com>
---
 drivers/clocksource/sh_mtu2.c |   65 +++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index e509f41..256621c 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -34,15 +34,15 @@
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
 
-struct sh_mtu2_priv;
+struct sh_mtu2_device;
 
 struct sh_mtu2_channel {
-	struct sh_mtu2_priv *mtu;
+	struct sh_mtu2_device *mtu;
 	int irq;
 	struct clock_event_device ced;
 };
 
-struct sh_mtu2_priv {
+struct sh_mtu2_device {
 	struct platform_device *pdev;
 
 	void __iomem *mapbase;
@@ -273,75 +273,76 @@ static int sh_mtu2_register(struct sh_mtu2_channel *ch, char *name,
 	return 0;
 }
 
-static int sh_mtu2_setup(struct sh_mtu2_priv *p, struct platform_device *pdev)
+static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
+			 struct platform_device *pdev)
 {
 	struct sh_timer_config *cfg = pdev->dev.platform_data;
 	struct resource *res;
 	int ret;
 	ret = -ENXIO;
 
-	memset(p, 0, sizeof(*p));
-	p->pdev = pdev;
+	memset(mtu, 0, sizeof(*mtu));
+	mtu->pdev = pdev;
 
 	if (!cfg) {
-		dev_err(&p->pdev->dev, "missing platform data\n");
+		dev_err(&mtu->pdev->dev, "missing platform data\n");
 		goto err0;
 	}
 
-	platform_set_drvdata(pdev, p);
+	platform_set_drvdata(pdev, mtu);
 
-	res = platform_get_resource(p->pdev, IORESOURCE_MEM, 0);
+	res = platform_get_resource(mtu->pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-		dev_err(&p->pdev->dev, "failed to get I/O memory\n");
+		dev_err(&mtu->pdev->dev, "failed to get I/O memory\n");
 		goto err0;
 	}
 
-	p->channel.irq = platform_get_irq(p->pdev, 0);
-	if (p->channel.irq < 0) {
-		dev_err(&p->pdev->dev, "failed to get irq\n");
+	mtu->channel.irq = platform_get_irq(mtu->pdev, 0);
+	if (mtu->channel.irq < 0) {
+		dev_err(&mtu->pdev->dev, "failed to get irq\n");
 		goto err0;
 	}
 
 	/* map memory, let mapbase point to our channel */
-	p->mapbase = ioremap_nocache(res->start, resource_size(res));
-	if (p->mapbase == NULL) {
-		dev_err(&p->pdev->dev, "failed to remap I/O memory\n");
+	mtu->mapbase = ioremap_nocache(res->start, resource_size(res));
+	if (mtu->mapbase == NULL) {
+		dev_err(&mtu->pdev->dev, "failed to remap I/O memory\n");
 		goto err0;
 	}
 
 	/* get hold of clock */
-	p->clk = clk_get(&p->pdev->dev, "mtu2_fck");
-	if (IS_ERR(p->clk)) {
-		dev_err(&p->pdev->dev, "cannot get clock\n");
-		ret = PTR_ERR(p->clk);
+	mtu->clk = clk_get(&mtu->pdev->dev, "mtu2_fck");
+	if (IS_ERR(mtu->clk)) {
+		dev_err(&mtu->pdev->dev, "cannot get clock\n");
+		ret = PTR_ERR(mtu->clk);
 		goto err1;
 	}
 
-	ret = clk_prepare(p->clk);
+	ret = clk_prepare(mtu->clk);
 	if (ret < 0)
 		goto err2;
 
-	p->channel.mtu = p;
+	mtu->channel.mtu = mtu;
 
-	ret = sh_mtu2_register(&p->channel, (char *)dev_name(&p->pdev->dev),
+	ret = sh_mtu2_register(&mtu->channel, (char *)dev_name(&mtu->pdev->dev),
 			       cfg->clockevent_rating);
 	if (ret < 0)
 		goto err3;
 
 	return 0;
  err3:
-	clk_unprepare(p->clk);
+	clk_unprepare(mtu->clk);
  err2:
-	clk_put(p->clk);
+	clk_put(mtu->clk);
  err1:
-	iounmap(p->mapbase);
+	iounmap(mtu->mapbase);
  err0:
 	return ret;
 }
 
 static int sh_mtu2_probe(struct platform_device *pdev)
 {
-	struct sh_mtu2_priv *p = platform_get_drvdata(pdev);
+	struct sh_mtu2_device *mtu = platform_get_drvdata(pdev);
 	struct sh_timer_config *cfg = pdev->dev.platform_data;
 	int ret;
 
@@ -350,20 +351,20 @@ static int sh_mtu2_probe(struct platform_device *pdev)
 		pm_runtime_enable(&pdev->dev);
 	}
 
-	if (p) {
+	if (mtu) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
 		goto out;
 	}
 
-	p = kmalloc(sizeof(*p), GFP_KERNEL);
-	if (p == NULL) {
+	mtu = kmalloc(sizeof(*mtu), GFP_KERNEL);
+	if (mtu == NULL) {
 		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		return -ENOMEM;
 	}
 
-	ret = sh_mtu2_setup(p, pdev);
+	ret = sh_mtu2_setup(mtu, pdev);
 	if (ret) {
-		kfree(p);
+		kfree(mtu);
 		pm_runtime_idle(&pdev->dev);
 		return ret;
 	}
-- 
1.7.9.5

